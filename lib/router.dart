import 'package:go_router/go_router.dart';
import 'package:numguess_flutter/screens/home_page.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) {
      return HomePage();
    },
  )
]);
