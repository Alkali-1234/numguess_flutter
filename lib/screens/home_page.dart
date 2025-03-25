import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numguess_client/numguess_client.dart';
import 'package:numguess_flutter/components/account_dialog.dart';
import 'package:numguess_flutter/logger.dart';
import 'package:numguess_flutter/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_page.g.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final guessInputController = TextEditingController();
  late var inStream = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    //* Provider
    var currentUserProvider = ref.watch(currentUserNotifierProvider);
    var currentResponse = ref.watch(guessResultProvider(inStream.stream)).value;

    var theme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text.rich(
                          textAlign: TextAlign.center,
                          key: ValueKey(currentResponse),
                          TextSpan(children: [
                            if (currentResponse == null) ...[
                              TextSpan(
                                  text: "Choose a number from ",
                                  style: textTheme.displayLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 48,
                                  )),
                              TextSpan(
                                  text: "1-100",
                                  style: textTheme.displayLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 48,
                                      color: theme.tertiary))
                            ],
                            if (currentResponse == GuessResponses.higher)
                              TextSpan(
                                  text: "Go higher!",
                                  style: textTheme.displayLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 48,
                                  )),
                            if (currentResponse == GuessResponses.lower)
                              TextSpan(
                                  text: "Go lower!",
                                  style: textTheme.displayLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 48,
                                  )),
                            if (currentResponse == GuessResponses.correct)
                              TextSpan(
                                  text: "Correct!",
                                  style: textTheme.displayLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 48,
                                      color: theme.tertiary))
                          ])),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextField(
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      controller: guessInputController,
                      style: textTheme.bodyMedium,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.primaryContainer,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          alignLabelWithHint: true,
                          hintText: "Your guess",
                          hintStyle: textTheme.bodyMedium!.copyWith(
                              color: theme.onPrimaryContainer
                                  .withValues(alpha: 0.5))),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primary,
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            )),
                        onPressed: () async {
                          if (currentResponse == GuessResponses.correct) {
                            setState(() {
                              inStream = StreamController<int>();
                              guessInputController.text = "";
                            });
                            ref.invalidate(guessResultProvider);
                            setState(() {});
                            return;
                          }
                          final number =
                              int.tryParse(guessInputController.text);
                          if (number == null) return;
                          setState(() {
                            inStream.add(number);
                          });
                        },
                        child: Center(
                          child: Text(
                            currentResponse == GuessResponses.correct
                                ? "Try again!"
                                : "Guess!",
                            style: textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        )),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AccountDialog());
                  },
                  style: ElevatedButton.styleFrom(
                    enableFeedback: false,
                  ),
                  child: Builder(builder: (context) {
                    if (currentUserProvider == null) {
                      return Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "Login ",
                            style: textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.tertiary)),
                        TextSpan(
                            text: "to save games", style: textTheme.bodyMedium)
                      ]));
                    }
                    return Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Logged in as ",
                          style: textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: currentUserProvider.userInfo?.userName,
                          style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.tertiary))
                    ]));
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//* State
//* User Authentication Status
final currentUserNotifierProvider =
    NotifierProvider<CurrentUserNotifier, User?>(CurrentUserNotifier.new);

class CurrentUserNotifier extends Notifier<User?> {
  void setUser(User? user) {
    state = user;
  }

  @override
  build() {
    return null;
  }
}

@riverpod
Stream<GuessResponses?> guessResult(Ref ref, Stream<int> guesses) async* {
  logger.i("Guess result stream started");
  await for (GuessResponses? result in client.guess.guessStream(guesses)) {
    yield result;
    if (result == GuessResponses.correct) {
      logger.i("Guess result stream finished");
      return;
    }
  }
}
