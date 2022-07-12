import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_investigator/blocs/service/service_bloc.dart';
import 'package:flutter_bloc_investigator/blocs/service/service_event.dart';
import 'package:flutter_bloc_investigator/blocs/service/service_state.dart';
import 'package:flutter_bloc_investigator/extensions/string.dart';
import 'package:flutter_bloc_investigator/screens/logs.dart';
import 'package:flutter_bloc_investigator/widgets/custom_app_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class InstancesScreen extends StatelessWidget {
  static const String routeName = "application_instances";

  const InstancesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isMacOS
          ? null
          : CustomAppBar(
              width: MediaQuery.of(context).size.width,
            ),
      body: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: state.instances.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                context
                    .read<ServiceBloc>()
                    .add(ServiceEvent.selectInstance(state.instances[index]));
                Navigator.of(context).pushNamed(LogsScreen.routeName);
              },
              child: GridTile(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FlutterLogo(
                      size: 80,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      state.instances[index].applicationId,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "App Name: ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          state.instances[index].appName.ucfirst(),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "OS: ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          state.instances[index].deviceOS.ucfirst(),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Logs: ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          state.logs[state.instances[index].applicationId]
                                  ?.length
                                  .toString() ??
                              "0",
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Last Event: ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          (state.logs[state.instances[index].applicationId]
                                          ?.length ??
                                      0) >
                                  0
                              ? timeago.format(state
                                  .logs[state.instances[index].applicationId]!
                                  .last
                                  .createdAt!)
                              : "Offline",
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
