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
    @Default(PacketType.instanceIdentity)
    @JsonKey(unknownEnumValue: PacketType.instanceIdentity)
        PacketType type,
    InstanceIdentity? identity,
    @JsonKey(name: "bloc_change") BlocChange? blocChange,
  }) = _InvestigativePacket;

  factory InvestigativePacket.fromJson(Map<String, dynamic> json) =>
      _$InvestigativePacketFromJson(json);
}
