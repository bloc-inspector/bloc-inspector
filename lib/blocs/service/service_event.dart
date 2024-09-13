part of 'service_bloc.dart';

@freezed
class ServiceEvent with _$ServiceEvent {
  const factory ServiceEvent() = _ServiceEvent;

  const factory ServiceEvent.initialized() = _Initialized;
  const factory ServiceEvent.newInstance(InstanceIdentity identity) =
      _NewInstance;
  const factory ServiceEvent.closeConnection() = _CloseConnection;
  const factory ServiceEvent.log(InstanceIdentity identity, BlocLog log) = _Log;
  const factory ServiceEvent.selectInstance(InstanceIdentity identity) =
      _SelectInstance;
  const factory ServiceEvent.clearLogs(InstanceIdentity identity) = _ClearLogs;
  const factory ServiceEvent.triggerUIRebuild() = _TriggerUIRebuild;
  const factory ServiceEvent.handleHttpRequest(HttpRequest request) =
      _HandleHttpRequest;
}
