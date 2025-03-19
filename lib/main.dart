import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numguess_client/numguess_client.dart';
import 'package:flutter/material.dart';
import 'package:numguess_flutter/router.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.
var client = Client('http://$localhost:8080/')..connectivityMonitor = FlutterConnectivityMonitor();

void main() {
  runApp(ProviderScope(child: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Number Guessing Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}
