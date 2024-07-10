import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/providers/auth_provider.dart';
import 'package:instafake_flutter/utils/enums/entry_state.dart';
import 'package:instafake_flutter/widgets/custom_card_widget.dart';
import 'package:instafake_flutter/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class EntryForm extends StatelessWidget {
  const EntryForm({
    super.key,
    required this.nameEditingController,
    required this.usernameEditingController,
    required this.emailEditController,
    required this.emailConfirmEditController,
    required this.passwordEditController,
    required this.passwordConfirmController,
    required this.state,
    required this.context,
  });

  final TextEditingController nameEditingController;
  final TextEditingController usernameEditingController;
  final TextEditingController emailEditController;
  final TextEditingController emailConfirmEditController;
  final TextEditingController passwordEditController;
  final TextEditingController passwordConfirmController;
  final EntryState state;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<AuthProvider>(
      builder: (buildContext, value, child) {
        switch(state){
          case EntryState.register:
            return CustomCardWidget(
              child: ListView(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                children: [
                  CustomTextField(
                    labelText: "Username",
                    controller: usernameEditingController,
                  ),
                  CustomTextField(
                    labelText: "Name",
                    controller: nameEditingController,
                  ),
                  CustomTextField(
                    labelText: "Email",
                    controller: emailEditController,
                  ),
                  CustomTextField(
                    labelText: "Confirm Email",
                    controller: emailConfirmEditController,
                    onChanged: (text) {
                      if (text != emailEditController.text) {
                        value.changeEmailErrorNotifierValue(newError: "Emails do not match");
                      } else {
                        value.changeEmailErrorNotifierValue(newError: null);
                      }
                    },
                    errorNotifier: value.emailErrorNotifier,
                  ),
                  CustomTextField(
                    labelText: "Password",
                    controller: passwordEditController,
                    obscureText: true,
                  ),
                  CustomTextField(
                    labelText: "Confirm Password",
                    controller: passwordConfirmController,
                    onChanged: (text) {
                      if (text != passwordEditController.text) {
                        value.changePasswordErrorNotifierValue(newError: "Passwords do not match");
                      } else {
                        value.changePasswordErrorNotifierValue(newError: null);
                      }
                    },
                    errorNotifier: value.passwordErrorNotifier,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (emailEditController.text == emailConfirmEditController.text && passwordEditController.text == passwordConfirmController.text) {
                        value.commitEmailRegistration(
                          nameEditingController.text,
                          usernameEditingController.text,
                          emailEditController.text,
                          passwordEditController.text,
                        );
                      } else {
                        Get.snackbar("Failed", "Email or password do not match");
                      }
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      value.changeEntryState(newEntryState: EntryState.login);
                    },
                    child: Text(
                      "login with Email.",
                      style: TextStyle(
                        color: colorScheme.surface,
                      ),
                    ),
                  ),
                ],
              )
            );
          case EntryState.login:
            return CustomCardWidget(
              child: ListView(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                children: [
                  CustomTextField(
                    labelText: "Username",
                    controller: usernameEditingController
                  ),
                  CustomTextField(
                    labelText: "Password",
                    controller: passwordEditController,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      value.commitEmailLogin(username: usernameEditingController.text, password: passwordEditController.text);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      FocusManager.instance.primaryFocus?.unfocus();
                      value.changeEntryState(newEntryState: EntryState.register);
                    }, 
                    child: Text(
                      "Don't have an account? Register here.",
                      style: TextStyle(
                        color: colorScheme.surface,
                      ),
                    )
                  )
                ],
              ),
            );
          default:
            return const Text('Error');
        }
      }
    );
  }
}