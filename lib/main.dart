import 'dart:io';

import 'package:bloc_inspector_client/screens/home/home.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_inspector_client/blocs/service/service_bloc.dart';
import 'package:bloc_inspector_client/cubits/selected_log_index_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  const MyApp({super.key});

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
      child: ScreenUtilInit(
        designSize: const Size(1920, 1080),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => FluentApp(
          title: 'BLoC Inspector',
          initialRoute: HomeScreen.routeName,
          theme: FluentThemeData(),
          routes: {
            HomeScreen.routeName: (context) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}
