import 'dart:io';

import 'package:flutter_bloc_investigator/models/bloc_log.dart';
import 'package:flutter_bloc_investigator/models/instance_identity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_event.freezed.dart';

@freezed
class ServiceEvent with _$ServiceEvent {
  const factory ServiceEvent() = _ServiceEvent;

  const factory ServiceEvent.initialized() = Initialized;
  const factory ServiceEvent.newInstance(InstanceIdentity identity) =
      NewInstance;
  const factory ServiceEvent.newConnection(Socket client) = NewConnection;
  const factory ServiceEvent.closeConnection() = CloseConnection;
  const factory ServiceEvent.buffer(int key, String data) = Buffer;
  const factory ServiceEvent.clearBuffer(int key) = ClearBuffer;
  const factory ServiceEvent.readBuffer(int key, String remnant) = ReadBuffer;
  const factory ServiceEvent.log(InstanceIdentity identity, BlocLog log) = Log;
  const factory ServiceEvent.selectInstance(InstanceIdentity identity) =
      SelectInstance;
  const factory ServiceEvent.clearLogs(InstanceIdentity identity) = ClearLogs;
}
