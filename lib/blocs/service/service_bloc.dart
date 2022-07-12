import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:nsd/nsd.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_investigator/blocs/service/service_event.dart';
import 'package:flutter_bloc_investigator/blocs/service/service_state.dart';
import 'package:flutter_bloc_investigator/enums/bloc_log_type.dart';
import 'package:flutter_bloc_investigator/enums/packet_type.dart';
import 'package:flutter_bloc_investigator/helpers/logging_helper.dart';
import 'package:flutter_bloc_investigator/models/bloc_log.dart';
import 'package:flutter_bloc_investigator/models/investigative_packet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synchronized/synchronized.dart' as synchronized;

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final synchronized.Lock lock = synchronized.Lock();

  ServiceBloc({ServiceState initialState = const ServiceState()})
      : super(initialState) {
    on<Initialized>(_initialized);
    on<NewInstance>(_newInstance);
    on<NewConnection>(_newConnection);
    on<Buffer>(_buffer);
    on<ClearBuffer>(_clearBuffer);
    on<ReadBuffer>(_readBuffer);
    on<Log>(_log);
    on<SelectInstance>(_selectInstance);
    on<ClearLogs>(_clearLogs);

    add(const Initialized());
  }

  /// Initialize Services.
  void _initialized(Initialized event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(
        server: await ServerSocket.bind(InternetAddress.anyIPv4, 8275)));
    state.server!.listen((client) {
      add(NewConnection(client));
    });

    logInfo("Socket Server Initialized");

    if (!Platform.isLinux) {
      final registration = await register(const Service(
          name: 'flutter_bloc_investigator', type: '_http._tcp', port: 8275));

      emit(state.copyWith(registration: registration));

      logInfo("Network Service Registered");
    } else {
      logInfo("Skipping service registration as Linux is not supported.");
    }
  }

  void _newInstance(NewInstance event, Emitter<ServiceState> emit) {
    if (state.instances.firstWhereOrNull(
            (e) => e.applicationId == event.identity.applicationId) ==
        null) {
      emit(state.copyWith(
          instances: List.from(state.instances)..add(event.identity)));
    }
  }

  void _buffer(Buffer event, Emitter<ServiceState> emit) async {
    await lock.synchronized(() {
      emit(state.copyWith(
          buffer: Map.from(state.buffer)
            ..[event.key] = (state.buffer[event.key] ?? "") + event.data));
    });
  }

  void _clearLogs(ClearLogs event, Emitter<ServiceState> emit) {
    Map<String, List<BlocLog>> map = Map.from(state.logs);
    map[event.identity.applicationId] = [];
    emit(state.copyWith(
      logs: map,
    ));
  }

  void _selectInstance(SelectInstance event, Emitter<ServiceState> emit) {
    emit(state.copyWith(selectedInstanceIdentity: event.identity));
  }

  void _clearBuffer(ClearBuffer event, Emitter<ServiceState> emit) async {
    await lock.synchronized(() {
      emit(state.copyWith(buffer: Map.from(state.buffer)..[event.key] = null));
    });
  }

  void _log(Log event, Emitter<ServiceState> emit) {
    List<BlocLog> logs =
        List.from(state.logs[event.identity.applicationId] ?? []);
    if (logs.length >= state.maxLogsCount) {
      logs.removeAt(0);
    }
    logs.add(event.log.copyWith(
      createdAt: DateTime.now(),
    ));
    Map<String, List<BlocLog>> map = Map.from(state.logs);
    map[event.identity.applicationId] = logs;
    emit(state.copyWith(
      logs: map,
    ));
  }

  void _readBuffer(ReadBuffer event, Emitter<ServiceState> emit) async {
    logInfo("Reading Buffer: ${event.key}");
    lock.synchronized(() {
      try {
        final fullMessage =
            (state.buffer[event.key]?.trim() ?? "") + event.remnant;

        add(ClearBuffer(event.key));

        final messages = fullMessage.split("[&&]");

        for (String message in messages) {
          // logger.d(message);
          if (message.trim().isNotEmpty) {
            final InvestigativePacket packet =
                InvestigativePacket.fromJson(json.decode(message.trim()));
            logger.e(packet.type);
            switch (packet.type) {
              case PacketType.instanceIdentity:
                add(NewInstance(packet.identity));
                break;
              case PacketType.blocCreated:
                _log(
                    Log(
                      packet.identity,
                      BlocLog(
                        type: BlocLogType.blocCreated,
                        blocName: packet.blocName,
                        state: packet.state,
                      ),
                    ),
                    emit);
                break;
              case PacketType.blocFallbackCreated:
                _log(
                    Log(
                      packet.identity,
                      BlocLog(
                        type: BlocLogType.blocFallbackCreated,
                        blocName: packet.blocName,
                        fallbackState: packet.fallbackState,
                      ),
                    ),
                    emit);
                break;
              case PacketType.blocFallbackTransitioned:
                _log(
                    Log(
                      packet.identity,
                      BlocLog(
                          type: BlocLogType.blocFallbackTransitioned,
                          blocName: packet.blocName,
                          blocChange: packet.blocChange,
                          oldFallbackState: packet.oldFallbackState,
                          newFallbackState: packet.newFallbackState),
                    ),
                    emit);
                break;
              case PacketType.blocTransitioned:
                _log(
                    Log(
                        packet.identity,
                        BlocLog(
                          type: BlocLogType.blocTransitioned,
                          blocName: packet.blocName,
                          blocChange: packet.blocChange,
                        )),
                    emit);
                break;
              case PacketType.blocError:
                break;
              default:
            }
          }
        }
      } catch (error, trace) {
        final fullMessage =
            (state.buffer[event.key]?.trim() ?? "") + event.remnant;
        logError(error, trace);
        add(ClearBuffer(event.key));
      }
    });
  }

  void _newConnection(NewConnection event, Emitter<ServiceState> emit) {
    logInfo('Connection from'
        ' ${event.client.remoteAddress.address}:${event.client.remotePort}');

    emit(state.copyWith(
        clients: Map.from(state.clients)..[event.client.port] = event.client));

    event.client.listen(
      (Uint8List data) async {
        // await Future.delayed(const Duration(milliseconds: 500));
        final message = String.fromCharCodes(data);
        if (!message.endsWith("\n")) {
          add(Buffer(event.client.port, message));
        } else {
          add(ReadBuffer(event.client.port, message));
          state.clients[event.client.port]?.writeln("Ok");
        }
      },
      onError: (error) {
        logger.e(error);
        event.client.close();
      },
      onDone: () {
        logInfo('Client left');
        event.client.close();
      },
    );
  }

  @override
  Future<void> close() async {
    super.close();
    if (state.registration != null) await unregister(state.registration!);
  }
}
