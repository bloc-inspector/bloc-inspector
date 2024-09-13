part of 'service_bloc.dart';

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
    HttpServer? server,
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
