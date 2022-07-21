import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_inspector/blocs/service/service_bloc.dart';
import 'package:bloc_inspector/blocs/service/service_event.dart';
import 'package:bloc_inspector/blocs/service/service_state.dart';
import 'package:bloc_inspector/widgets/custom_app_bar.dart';
import 'package:bloc_inspector/widgets/log_item.dart';

class LogsScreen extends StatelessWidget {
  static const String routeName = "logs";

  const LogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) => Scaffold(
        appBar: Platform.isMacOS
            ? null
            : CustomAppBar(
                width: MediaQuery.of(context).size.width,
              ),
        body: state.selectedInstanceIdentity == null ||
                state.logs[state.selectedInstanceIdentity!.applicationId] ==
                    null
            ? const Center(child: Text("No Logs Yet"))
            : ListView.builder(
                itemCount: state
                    .logs[state.selectedInstanceIdentity!.applicationId]!
                    .length,
                itemBuilder: ((context, index) => LogItem(
                    index: index,
                    log: state
                        .logs[state.selectedInstanceIdentity!.applicationId]!
                        .reversed
                        .elementAt(index))),
              ),
        floatingActionButton: Stack(fit: StackFit.expand, children: [
          Positioned(
            width: 45,
            height: 45,
            right: 30,
            bottom: 30,
            child: FloatingActionButton(
              heroTag: "Back",
              child: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            width: 120,
            height: 45,
            left: 50,
            bottom: 30,
            child: Row(children: [
              FloatingActionButton(
                heroTag: "Clear",
                child: const Icon(Icons.clear),
                onPressed: () => context.read<ServiceBloc>().add(
                    ServiceEvent.clearLogs(state.selectedInstanceIdentity!)),
              ),
              FloatingActionButton(
                heroTag: "Refresh",
                child: const Icon(Icons.refresh),
                onPressed: () => context
                    .read<ServiceBloc>()
                    .add(const ServiceEvent.triggerUIRebuild()),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
