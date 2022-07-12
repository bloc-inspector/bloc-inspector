import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_investigator/blocs/service/service_bloc.dart';
import 'package:flutter_bloc_investigator/blocs/service/service_state.dart';
import 'package:flutter_bloc_investigator/widgets/custom_app_bar.dart';
import 'package:flutter_bloc_investigator/widgets/log_item.dart';

class LogsScreen extends StatelessWidget {
  static const String routeName = "logs";

  const LogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) => Scaffold(
        appBar: CustomAppBar(
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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
