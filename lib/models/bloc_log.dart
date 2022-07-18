// ignore_for_file: invalid_annotation_target

import 'package:flutter_bloc_investigator/enums/bloc_log_type.dart';
import 'package:flutter_bloc_investigator/models/bloc_change.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bloc_log.freezed.dart';
part 'bloc_log.g.dart';

@freezed
class BlocLog with _$BlocLog {
  factory BlocLog({
    @Default(BlocLogType.blocChanged) BlocLogType type,
    BlocChange? blocChange,
    String? blocName,
    DateTime? createdAt,
    Map<String, dynamic>? state,
    String? fallbackState,
    String? oldFallbackState,
    String? newFallbackState,
    String? decodeErrorReason,
  }) = _BlocLog;

  factory BlocLog.fromJson(Map<String, dynamic> json) =>
      _$BlocLogFromJson(json);
}
