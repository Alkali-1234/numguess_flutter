import 'package:go_router/go_router.dart';
import 'package:numguess_flutter/screens/games_page.dart';
import 'package:numguess_flutter/screens/home_page.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) {
      return HomePage();
    },
  ),
  GoRoute(
    path: "/games",
    builder: (context, state) {
      return GamesPage();
    },
  )
]);
