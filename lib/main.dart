import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numguess_client/numguess_client.dart';
import 'package:flutter/material.dart';
import 'package:numguess_flutter/router.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.

late SessionManager sessionManager;
late Client client;

Future<void> initializeServerpodClient() async {
  // The android emulator does not have access to the localhost of the machine.
  // const ipAddress = '10.0.2.2'; // Android emulator ip for the host

  // On a real device replace the ipAddress with the IP address of your computer.
  // const ipAddress = 'localhost';

  // Sets up a singleton client object that can be used to talk to the server from
  // anywhere in our app. The client is generated from your server code.
  // The client is set up to connect to a Serverpod running on a local server on
  // the default port. You will need to modify this to connect to staging or
  // production servers.

  const productionIp = 'https://alkadev.xyz/';
  const developmentIp = 'http://localhost:8080/';

  client = Client(
    kDebugMode ? developmentIp : productionIp,
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

  // The session manager keeps track of the signed-in state of the user. You
  // can query it to see if the user is currently signed in and get information
  // about the user.
  sessionManager = SessionManager(
    caller: client.modules.auth,
  );

  await sessionManager.initialize();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServerpodClient();
  runApp(ProviderScope(child: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Numguess',
      theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: Color(0xFFBFBA85),
              onPrimary: Colors.black,
              secondary: Color(0xFFd2cda7),
              onSecondary: Colors.black,
              tertiary: Color(0xFFdbd7b8),
              primaryContainer: Color(0xFF32435d),
              onPrimaryContainer: Colors.white,
              secondaryContainer: Color(0xFF4a5870),
              onSecondaryContainer: Colors.white,
              tertiaryContainer: Color(0xFF626d83),
              error: Colors.red,
              onError: Colors.white,
              surface: Color(0xFF1a2f4b),
              onSurface: Colors.white),
          textTheme: GoogleFonts.lexendTextTheme(ThemeData.dark().textTheme)),
      routerConfig: router,
    );
  }
}
