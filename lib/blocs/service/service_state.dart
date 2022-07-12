import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_investigator/models/bloc_log.dart';
import 'package:flutter_bloc_investigator/models/instance_identity.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

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
    ServerSocket? server,
  }) = _ServiceState;

  @override
  List<Object?> get props => [
        instances,
        server,
        clients,
        buffer,
        logs,
        selectedInstanceIdentity,
      ];
}
