import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_investigator/blocs/service/service_bloc.dart';
import 'package:flutter_bloc_investigator/screens/instances.dart';
import 'package:logger/logger.dart';

void main() {
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
      ],
      child: MaterialApp(
        title: 'Flutter BLoC Investigator',
        initialRoute: InstancesScreen.routeName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          InstancesScreen.routeName: (context) => const InstancesScreen(),
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

  @override
  void initState() {
    super.initState();
    _initServer();
  }

  void _initServer() async {
    // final server = await ServerSocket.bind(InternetAddress.anyIPv4, 8275);
    // server.listen((client) {
    //   handleConnection(client);
    // });
  }

  // void handleConnection(Socket client) {
  //   logger.d('Connection from'
  //       ' ${client.remoteAddress.address}:${client.remotePort}');

  //   // listen for events from the client
  //   client.listen(
  //     // handle data from the client
  //     (Uint8List data) async {
  //       await Future.delayed(Duration(seconds: 1));
  //       final message = String.fromCharCodes(data);
  //       //final p = InvestigativePacket.fromJson(json.decode(message));
  //       //logger.d(p);
  //       logger.d(message.contains("\n"));
  //       if (!message.endsWith("\n")) {
  //         buffer[client.port] = (buffer[client.port] ?? "") + message;
  //       } else {
  //         logger.d(InvestigativePacket.fromJson(
  //             json.decode((buffer[client.port]?.trim() ?? "") + message)));
  //         buffer[client.port] = null;
  //         client.writeln("Ok");
  //       }
  //     },

  //     // handle errors
  //     onError: (error) {
  //       logger.e(error);
  //       client.close();
  //     },

  //     // handle the client closing the connection
  //     onDone: () {
  //       print('Client left');
  //       client.close();
  //     },
  //   );
  // }

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
