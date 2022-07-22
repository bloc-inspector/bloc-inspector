import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:bloc_inspector_client/models/bloc_log.dart';
import 'package:bloc_inspector_client/models/instance_identity.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nsd/nsd.dart';

part 'service_state.freezed.dart';

@freezed
class ServiceState extends Equatable with _$ServiceState {
  const ServiceState._();

  const factory ServiceState({
    @Default(40) int maxLogsCount,
    @Default([]) List<InstanceIdentity> instances,
    @Default({}) Map<int, Socket> clients,
    @Default({}) Map<int, String?> buffer,
    @Default({}) Map<String, List<BlocLog>> logs,
    InstanceIdentity? selectedInstanceIdentity,
    Registration? registration,
    ServerSocket? server,
    @Default(0) int builderTrigger,
  }) = _ServiceState;

  @override
  List<Object?> get props => [
        instances,
        server,
        clients,
        buffer,
        logs,
        registration,
        selectedInstanceIdentity,
        builderTrigger,
      ];
}
