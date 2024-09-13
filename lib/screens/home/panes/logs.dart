import 'dart:io';

import 'package:bloc_inspector_client/models/instance_identity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_inspector_client/blocs/service/service_bloc.dart';
import 'package:bloc_inspector_client/widgets/custom_app_bar.dart';
import 'package:bloc_inspector_client/widgets/log_item.dart';

class LogsScreen extends StatelessWidget {
  static const String routeName = "logs";

  final InstanceIdentity instance;

  const LogsScreen({super.key, required this.instance});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) => Scaffold(
        appBar: Platform.isMacOS
            ? null
            : CustomAppBar(
                width: MediaQuery.of(context).size.width,
              ),
        body: (state.logs[instance.applicationId]?.length ?? 0) == 0
            ? const Center(child: Text("No Logs Yet"))
            : ListView.builder(
                itemCount: state.logs[instance.applicationId]!.length,
                itemBuilder: ((context, index) => LogItem(
                    index: index,
                    log: state.logs[instance.applicationId]!.reversed
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
                onPressed: () => context
                    .read<ServiceBloc>()
                    .add(ServiceEvent.clearLogs(instance)),
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
