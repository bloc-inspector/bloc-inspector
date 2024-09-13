import 'package:bloc_inspector_client/blocs/service/service_bloc.dart';
import 'package:bloc_inspector_client/screens/home/panes/home.dart';
import 'package:bloc_inspector_client/screens/home/panes/instances.dart';
import 'package:bloc_inspector_client/screens/home/panes/logs.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeScreen extends HookWidget {
  static const String routeName = 'home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPane = useState(0);

    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) => NavigationView(
        appBar: const NavigationAppBar(title: Text("Flutter BLoC Inspector")),
        pane: NavigationPane(
          selected: selectedPane.value,
          items: [
            PaneItem(
              icon: const Icon(FluentIcons.home),
              title: const Text('Home'),
              body: const HomePane(),
            ),
            PaneItemSeparator(),
            PaneItemExpander(
              icon: const Icon(FluentIcons.cube_shape_solid),
              title: const Text('Instances'),
              body: InstancesPane(
                onInstanceSelected: (index) {
                  selectedPane.value = 2 + index;
                },
              ),
              items: state.instances
                  .map(
                    (e) => PaneItem(
                      icon: const Icon(FluentIcons.cube_shape_solid),
                      title: Text(e.applicationId),
                      body: LogsScreen(instance: e),
                    ),
                  )
                  .toList(),
            ),
          ],
          onChanged: (i) => selectedPane.value = i,
        ),
      ),
    );
  }
}
