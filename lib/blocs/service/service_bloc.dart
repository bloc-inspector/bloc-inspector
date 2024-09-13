import 'dart:convert';
import 'dart:io';

import 'package:bloc_inspector_client/models/instance_identity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nsd/nsd.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_inspector_client/enums/bloc_log_type.dart';
import 'package:bloc_inspector_client/enums/packet_type.dart';
import 'package:bloc_inspector_client/helpers/logging_helper.dart';
import 'package:bloc_inspector_client/models/bloc_log.dart';
import 'package:bloc_inspector_client/models/investigative_packet.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:synchronized/synchronized.dart' as synchronized;

part 'service_state.dart';
part 'service_event.dart';
part 'service_bloc.freezed.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final synchronized.Lock lock = synchronized.Lock();

  ServiceBloc({ServiceState initialState = const ServiceState()})
      : super(initialState) {
    on<_Initialized>(_initialized);
    on<_NewInstance>(_newInstance);
    on<_Log>(_log);
    on<_SelectInstance>(_selectInstance);
    on<_ClearLogs>(_clearLogs);
    on<_TriggerUIRebuild>(_triggerUIRebuild);
    on<_HandleHttpRequest>(_handleHttpRequest);

    add(const _Initialized());
  }

  /// Initialize Services.
  void _initialized(_Initialized event, Emitter<ServiceState> emit) async {
    emit(state.copyWith(
        server: await HttpServer.bind(InternetAddress.loopbackIPv4, 8275)));

    state.server?.listen((HttpRequest request) {
      add(_HandleHttpRequest(request));
    });

    logInfo("Socket Server Initialized");

    if (!Platform.isLinux) {
      final registration = await register(const Service(
          name: 'bloc_inspector_client', type: '_http._tcp', port: 8275));

      emit(state.copyWith(registration: registration));

      logInfo("Network Service Registered");
    } else {
      logInfo("Skipping service registration as Linux is not supported.");
    }
  }

  void _handleHttpRequest(
      _HandleHttpRequest event, Emitter<ServiceState> emit) async {
    final request = event.request;
    final response = request.response;
    final path = request.uri.path;

    logInfo(
        "Request received from ${request.connectionInfo?.remoteAddress}:${request.connectionInfo?.remotePort}");

    logInfo(path);

    try {
      if (path == "/" && request.method == "POST") {
        String content = await utf8.decoder.bind(request).join();
        logInfo("Content: $content");
        dynamic data = jsonDecode(content);
        final InvestigativePacket packet = InvestigativePacket.fromJson(data);
        switch (packet.type) {
          case PacketType.instanceIdentity:
            add(_NewInstance(packet.identity));
            break;
          case PacketType.blocCreated:
            _log(
                _Log(
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
                _Log(
                  packet.identity,
                  BlocLog(
                    type: BlocLogType.blocFallbackCreated,
                    decodeErrorReason: packet.decodeErrorReason,
                    blocName: packet.blocName,
                    fallbackState: packet.fallbackState,
                  ),
                ),
                emit);
            break;
          case PacketType.blocFallbackTransitioned:
            _log(
                _Log(
                  packet.identity,
                  BlocLog(
                      decodeErrorReason: packet.decodeErrorReason,
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
                _Log(
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
        response.write(jsonEncode({"status": "ok"}));
        response.close();
        logInfo(
            "Request from ${request.connectionInfo?.remoteAddress}:${request.connectionInfo?.remotePort} processed!");
      } else {
        response.write("Not Found");
        response.close();
      }
    } catch (error, trace) {
      logError(error, trace);
      response.write(jsonEncode({"status": "error"}));
    }
  }

  void _newInstance(_NewInstance event, Emitter<ServiceState> emit) {
    if (state.instances.firstWhereOrNull(
            (e) => e.applicationId == event.identity.applicationId) ==
        null) {
      emit(state.copyWith(
          instances: List.from(state.instances)..add(event.identity)));
    }
  }

  void _clearLogs(_ClearLogs event, Emitter<ServiceState> emit) {
    Map<String, List<BlocLog>> map = Map.from(state.logs);
    // Must have at least one log entry.
    if ((map[event.identity.applicationId]?.length ?? 0) > 1) {
      // Leave the latest log behind.
      map[event.identity.applicationId] = [
        map[event.identity.applicationId]!.last
      ];
      emit(state.copyWith(
        logs: map,
      ));
    }
  }

  void _selectInstance(_SelectInstance event, Emitter<ServiceState> emit) {
    emit(state.copyWith(selectedInstanceIdentity: event.identity));
  }

  void _log(_Log event, Emitter<ServiceState> emit) {
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

  void _triggerUIRebuild(_TriggerUIRebuild event, Emitter<ServiceState> emit) {
    emit(state.copyWith(builderTrigger: state.builderTrigger + 1));
  }

  @override
  Future<void> close() async {
    super.close();
    if (state.registration != null) await unregister(state.registration!);
  }
}
