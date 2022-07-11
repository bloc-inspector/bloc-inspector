import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_investigator/blocs/service/service_bloc.dart';
import 'package:flutter_bloc_investigator/blocs/service/service_state.dart';
import 'package:flutter_bloc_investigator/extensions/string.dart';

class InstancesScreen extends StatelessWidget {
  static const String routeName = "application_instances";

  const InstancesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Application Instances"),
      ),
      body: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: state.instances.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => InkWell(
              onTap: () => {},
              onLongPress: () {},
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
                        const Text(
                          "20",
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
                          DateTime.now().toString(),
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
