import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_inspector_client/blocs/service/service_bloc.dart';
import 'package:bloc_inspector_client/cubits/selected_log_index_cubit.dart';
import 'package:bloc_inspector_client/screens/instances.dart';
import 'package:bloc_inspector_client/screens/logs.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('BLoC Inspector');
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
        title: 'BLoC Inspector',
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
