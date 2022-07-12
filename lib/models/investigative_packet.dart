// ignore_for_file: invalid_annotation_target

import 'package:flutter_bloc_investigator/models/bloc_change.dart';
import 'package:flutter_bloc_investigator/models/instance_identity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_bloc_investigator/enums/packet_type.dart';

part 'investigative_packet.freezed.dart';
part 'investigative_packet.g.dart';

@freezed
class InvestigativePacket with _$InvestigativePacket {
  factory InvestigativePacket({
    @Default(PacketType.instanceIdentity) PacketType type,
    @JsonKey(name: "bloc_name") @Default("") String blocName,
    @Default(InstanceIdentity()) InstanceIdentity identity,
    @JsonKey(name: "bloc_change") BlocChange? blocChange,
    Map<String, dynamic>? state,
    @JsonKey(name: "fall_back_state") String? fallbackState,
    @JsonKey(name: "old_fall_back_state") String? oldFallbackState,
    @JsonKey(name: "new_fall_back_state") String? newFallbackState,
  }) = _InvestigativePacket;

  factory InvestigativePacket.fromJson(Map<String, dynamic> json) =>
      _$InvestigativePacketFromJson(json);
}
