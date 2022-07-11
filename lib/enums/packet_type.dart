import 'package:json_annotation/json_annotation.dart';

enum PacketType {
  @JsonValue("instance_identity")
  instanceIdentity,
  @JsonValue("bloc_created")
  blocCreated,
  @JsonValue("bloc_changed")
  blocChanged,
  @JsonValue("bloc_error")
  blocError,
}
