import 'package:flutter/material.dart';

import 'package:bloc_inspector/enums/bloc_log_type.dart';
import 'package:bloc_inspector/models/bloc_log.dart';
import 'package:bloc_inspector/widgets/bloc_created_item.dart';
import 'package:bloc_inspector/widgets/bloc_fallback_created_item.dart';
import 'package:bloc_inspector/widgets/bloc_fallback_transitioned_item.dart';
import 'package:bloc_inspector/widgets/bloc_transitioned_item.dart';

class LogItem extends StatelessWidget {
  final BlocLog log;
  final int index;

  const LogItem({
    Key? key,
    required this.log,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (log.type) {
      case BlocLogType.blocCreated:
        return BlocCreatedItem(
          log: log,
          index: index,
        );
      case BlocLogType.blocTransitioned:
        return BlocTransitionedItem(log: log, index: index);
      case BlocLogType.blocFallbackCreated:
        return BlocFallbackCreatedItem(log: log, index: index);
      case BlocLogType.blocFallbackTransitioned:
        return BlocFallbackTransitionedItem(log: log, index: index);
      default:
        return const Text("Unsupported");
    }
  }
}
