import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numguess_flutter/components/elevated_button_decoration.dart';
import 'package:numguess_flutter/components/input_decoration.dart';
import 'package:numguess_flutter/logger.dart';
import 'package:numguess_flutter/main.dart';
import 'package:numguess_flutter/screens/home_page.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:numguess_client/numguess_client.dart';

class AccountDialog extends ConsumerStatefulWidget {
  const AccountDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountDialogState();
}

class _AccountDialogState extends ConsumerState<AccountDialog> {
  bool loginPage = true;
  bool confirmationPage = false;

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  TextEditingController accountCreationUsernameController =
      TextEditingController();
  TextEditingController accountCreationEmailController =
      TextEditingController();
  TextEditingController accountCreationPasswordController =
      TextEditingController();
  TextEditingController accountCreationPasswordConfirmationController =
      TextEditingController();

  TextEditingController accountValidationCodeController =
      TextEditingController();
  TextEditingController accountValidationEmailController =
      TextEditingController();

  bool loading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    var currentUserProvider = ref.watch(currentUserNotifierProvider);
    return Dialog(
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(Size.fromWidth(300)),
          child: Builder(builder: (context) {
            if (currentUserProvider != null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    currentUserProvider.userInfo?.userName ?? "",
                    style: textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: theme.tertiary),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: theme.primaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Games played",
                            style: textTheme.bodyMedium,
                          ),
                          Text(
                            currentUserProvider.games.length.toString(),
                            style: textTheme.bodyMedium,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButtonDecoration
                            .primaryElevatedButtonDecoration(theme, textTheme),
                        onPressed: () {
                          //TODO: Implement view games
                        },
                        child: Text(
                          "View Games",
                          style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.onPrimary),
                        )),
                  )
                ],
              );
            }
            if (confirmationPage) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Confirm Email",
                    style: textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: theme.tertiary),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextField(
                    controller: accountValidationEmailController,
                    style: textTheme.bodyMedium,
                    decoration: StandardInputDecoration.inputDecoration(
                        theme, textTheme, "Email"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: accountValidationCodeController,
                    style: textTheme.bodyMedium,
                    decoration: StandardInputDecoration.inputDecoration(
                        theme, textTheme, "Code"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButtonDecoration
                            .primaryElevatedButtonDecoration(theme, textTheme),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          final result = await validateEmail(
                              accountValidationEmailController.text,
                              accountValidationCodeController.text);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error = "Validation failed";
                            });
                          } else {
                            setState(() {
                              loading = false;
                              confirmationPage = false;
                            });
                          }
                        },
                        child: Text(
                          "Validate",
                          style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.onPrimary),
                        )),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (error.isNotEmpty)
                    Text(
                      "Error validating: $error",
                      style: textTheme.bodySmall!.copyWith(color: theme.error),
                    )
                ],
              );
            }
            if (loginPage) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Login",
                    style: textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: theme.primary),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: loginEmailController,
                    style: textTheme.bodyMedium,
                    decoration: StandardInputDecoration.inputDecoration(
                        theme, textTheme, "Email"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: loginPasswordController,
                    obscureText: true,
                    style: textTheme.bodyMedium,
                    decoration: StandardInputDecoration.inputDecoration(
                        theme, textTheme, "Password"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButtonDecoration
                            .secondaryElevatedButtonDecoration(
                                theme, textTheme),
                        onPressed: () {
                          setState(() {
                            loginPage = false;
                          });
                        },
                        child: Text(
                          "Create an Account",
                          style: textTheme.bodyMedium,
                        )),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButtonDecoration
                            .primaryElevatedButtonDecoration(theme, textTheme),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                            error = "";
                          });
                          final result = await loginWithEmail(
                              loginEmailController.text,
                              loginPasswordController.text,
                              ref);
                          if (result == null) {
                            setState(() {
                              error = "Invalid login.";
                              loading = false;
                            });
                          }
                          if (result != null) {
                            setState(() {
                              loading = false;
                              loginEmailController.text = "";
                              loginPasswordController.text = "";
                            });
                          }
                        },
                        child: loading
                            ? SizedBox(
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ))
                            : Text(
                                "Submit",
                                style: textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.onPrimary),
                              )),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (error.isNotEmpty)
                    Text(
                      "Error: $error please try again.",
                      style: textTheme.bodySmall!.copyWith(color: theme.error),
                    )
                ],
              );
            }
            //* ACCOUNT CREATION PAGE
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "Create an Account",
                  style: textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: theme.tertiary),
                ),
                const SizedBox(
                  height: 32,
                ),
                TextField(
                  controller: accountCreationUsernameController,
                  style: textTheme.bodyMedium,
                  decoration: StandardInputDecoration.inputDecoration(
                      theme, textTheme, "Username"),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: accountCreationEmailController,
                  style: textTheme.bodyMedium,
                  decoration: StandardInputDecoration.inputDecoration(
                      theme, textTheme, "Email"),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  obscureText: true,
                  controller: accountCreationPasswordController,
                  style: textTheme.bodyMedium,
                  decoration: StandardInputDecoration.inputDecoration(
                      theme, textTheme, "Password"),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  obscureText: true,
                  controller: accountCreationPasswordConfirmationController,
                  style: textTheme.bodyMedium,
                  decoration: StandardInputDecoration.inputDecoration(
                      theme, textTheme, "Confirm Password"),
                ),
                const SizedBox(
                  height: 16,
                ),
                //* Buttons
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButtonDecoration
                          .secondaryElevatedButtonDecoration(theme, textTheme),
                      onPressed: () => setState(() => confirmationPage = true),
                      child: Text(
                        "I have a validation code",
                        style: textTheme.bodyMedium,
                      )),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButtonDecoration
                          .secondaryElevatedButtonDecoration(theme, textTheme),
                      onPressed: () => setState(() => loginPage = true),
                      child: Text(
                        "I already have an account",
                        style: textTheme.bodyMedium,
                      )),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButtonDecoration
                          .primaryElevatedButtonDecoration(theme, textTheme),
                      onPressed: () async {
                        if (accountCreationPasswordController.text !=
                            accountCreationPasswordConfirmationController
                                .text) {
                          setState(() {
                            error = "Password does not match";
                          });
                        }
                        setState(() {
                          loading = true;
                        });
                        final req = await createUser(
                            accountCreationUsernameController.text,
                            accountCreationEmailController.text,
                            accountCreationPasswordController.text);
                        if (req) {
                          setState(() {
                            loading = false;
                            error = "";
                          });
                        } else {
                          setState(() {
                            loading = false;
                            error = "Unable to create user.";
                          });
                        }
                      },
                      child: Text(
                        "Submit",
                        style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.onPrimary),
                      )),
                )
              ],
            );
          }),
        ),
      ),
    );
    //TODO: Implement current account view
  }
}

//* State & Logic
Future<bool> createUser(String username, String email, String password) async {
  final emailAuthController = EmailAuthController(client.modules.auth);
  final request =
      await emailAuthController.createAccountRequest(username, email, password);
  return request;
}

Future<User?> validateEmail(String email, String validationCode) async {
  final emailAuthController = EmailAuthController(client.modules.auth);
  final request =
      await emailAuthController.validateAccount(email, validationCode);
  if (request == null) return null;
  logger.i("Validation request UserInfo: $request");
  final user = await client.createUserData.createUserData(request);
  return user;
}

Future<User?> loginWithEmail(
    String email, String password, WidgetRef ref) async {
  final emailAuthController = EmailAuthController(client.modules.auth);
  final request = await emailAuthController.signIn(email, password);
  logger.d(request);
  if (request == null) return null;
  var userData = await getUserData(request);
  logger.d(userData);
  if (userData != null) {
    ref.read(currentUserNotifierProvider.notifier).setUser(userData);
  }
  if (userData == null) {
    final userDataCreation =
        await client.createUserData.createUserData(request);
    logger.d(userDataCreation);
    ref.read(currentUserNotifierProvider.notifier).setUser(userDataCreation);
    return userDataCreation;
  }
  return userData;
}

Future<User?> getUserData(UserInfo userInfo) async {
  final request = await client.getUserData.getUserData(userInfo);
  return request;
}
