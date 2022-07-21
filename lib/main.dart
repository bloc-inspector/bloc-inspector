import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_inspector/blocs/service/service_bloc.dart';
import 'package:bloc_inspector/cubits/selected_log_index_cubit.dart';
import 'package:bloc_inspector/screens/instances.dart';
import 'package:bloc_inspector/screens/logs.dart';
import 'package:logger/logger.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('My App');
    setWindowMaxSize(const Size(double.infinity, double.infinity));
    setWindowMinSize(const Size(1280, 720));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServiceBloc>(
          create: (context) => ServiceBloc(),
          lazy: false,
        ),
        BlocProvider<SelectedLogIndexCubit>(
          create: (context) => SelectedLogIndexCubit(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter BLoC Investigator',
        initialRoute: InstancesScreen.routeName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          InstancesScreen.routeName: (context) => const InstancesScreen(),
          LogsScreen.routeName: (context) => const LogsScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Logger logger = Logger();
  Map<int, String?> buffer = {};

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
