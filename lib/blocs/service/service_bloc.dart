import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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

    add(const Initialized());
  }

  void _initialized(Initialized event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(
        server: await ServerSocket.bind(InternetAddress.anyIPv4, 8275)));
    state.server!.listen((client) {
      add(NewConnection(client));
    });
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

  void _clearBuffer(ClearBuffer event, Emitter<ServiceState> emit) async {
    await lock.synchronized(() {
      emit(state.copyWith(buffer: Map.from(state.buffer)..[event.key] = null));
    });
  }

  void _log(Log event, Emitter<ServiceState> emit) {
    emit(state.copyWith(
      logs: List.from(state.logs)
        ..add(event.log.copyWith(
          createdAt: DateTime.now(),
        )),
    ));
  }

  void _readBuffer(ReadBuffer event, Emitter<ServiceState> emit) async {
    try {
      final InvestigativePacket packet = InvestigativePacket.fromJson(
          json.decode((state.buffer[event.key]?.trim() ?? "") + event.remnant));

      add(ClearBuffer(event.key));

      switch (packet.type) {
        case PacketType.instanceIdentity:
          add(NewInstance(packet.identity!));
          break;
        case PacketType.blocCreated:
          add(Log(BlocLog(
            type: BlocLogType.blocCreated,
            blocName: "BlocName",
          )));
          break;
        case PacketType.blocChanged:
          add(Log(BlocLog(
            type: BlocLogType.blocChanged,
            blocChange: packet.blocChange,
          )));
          break;
        case PacketType.blocError:
          break;
      }
    } catch (error, trace) {
      logError(error, trace);
      add(ClearBuffer(event.key));
    }
  }

  void _newConnection(NewConnection event, Emitter<ServiceState> emit) {
    logInfo('Connection from'
        ' ${event.client.remoteAddress.address}:${event.client.remotePort}');

    emit(state.copyWith(
        clients: Map.from(state.clients)..[event.client.port] = event.client));

    event.client.listen(
      (Uint8List data) async {
        await Future.delayed(const Duration(seconds: 1));
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
}
