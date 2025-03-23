import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numguess_client/numguess_client.dart';
import 'package:numguess_flutter/components/elevated_button_decoration.dart';
import 'package:numguess_flutter/screens/home_page.dart';

class GamesPage extends ConsumerStatefulWidget {
  const GamesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GamesPageState();
}

class _GamesPageState extends ConsumerState<GamesPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var games = ref.watch(currentUserNotifierProvider)?.games;
    if (games == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "No data! Are you logged in?",
            style: textTheme.headlineSmall,
          ),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Games",
                    style: textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w900, color: theme.tertiary),
                  ),
                  SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton.filled(
                          style: ElevatedButtonDecoration
                              .secondaryElevatedButtonDecoration(
                                  theme, textTheme),
                          onPressed: () => context.go("/"),
                          icon: Icon(
                            Icons.logout_rounded,
                            color: theme.tertiary,
                          ))),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (var game in games) GameListItemCard(game: game)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameListItemCard extends StatelessWidget {
  const GameListItemCard({super.key, required this.game});
  final Game game;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: theme.tertiaryContainer, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  color: theme.primary,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text.rich(TextSpan(children: [
                  for (var guess in game.guesses) ...[
                    if (guess != game.correct) ...[
                      TextSpan(
                          text: guess.toString(),
                          style: textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "/",
                          style: textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold))
                    ] else ...[
                      TextSpan(
                          text: game.correct.toString(),
                          style: textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.tertiary))
                    ]
                  ]
                ])),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: theme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "${game.timestamp.day} ${monthIntToString(game.timestamp.month)} ${game.timestamp.year}",
                  style: textTheme.bodySmall!
                      .copyWith(color: theme.onSurface.withValues(alpha: 0.5)),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule,
                  color: theme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(durationToText(game.duration),
                    style: textTheme.bodySmall!.copyWith(
                        color: theme.onSurface.withValues(alpha: 0.5)))
              ],
            )
          ],
        ),
      ),
    );
  }
}

String monthIntToString(int month) {
  switch (month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
    default:
      throw ArgumentError("Invalid month: $month. Must be between 1 and 12.");
  }
}

String durationToText(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  List<String> parts = [];
  if (hours > 0) parts.add("${hours}h");
  if (minutes > 0) parts.add("${minutes}m");
  if (seconds > 0) parts.add("${seconds}s");

  return parts.isNotEmpty ? parts.join(" ") : "0s";
}
