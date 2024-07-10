import 'package:flutter/material.dart';
import 'package:instafake_flutter/core/providers/auth_provider.dart';
import 'package:instafake_flutter/utils/enums/entry_state.dart';
import 'package:instafake_flutter/widgets/entry_form.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController emailEditController = TextEditingController();
  final TextEditingController emailConfirmEditController = TextEditingController();
  final TextEditingController passwordEditController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [

          Align(
            alignment: const AlignmentDirectional(0, -0.6),
            child: Text(
              "Instafake",
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w300,
                color: colorScheme.primary
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, 0.6),
            child: EntryForm(
              usernameEditingController: usernameEditingController,
              nameEditingController: nameEditingController,
              emailEditController: emailEditController, 
              emailConfirmEditController: emailConfirmEditController,
              passwordEditController: passwordEditController,
              passwordConfirmController: passwordConfirmController,
              state: context.watch<AuthProvider>().state,
              context: context,
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AuthProvider>(
          builder: (BuildContext context, AuthProvider value, Widget? child) { 
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => value.changeEntryState(newEntryState: EntryState.login),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: value.state==EntryState.login? colorScheme.primaryContainer : colorScheme.onSurface,
                      fontWeight: value.state==EntryState.login?FontWeight.bold:FontWeight.normal,
                      fontSize: value.state==EntryState.login?16:14
                    )
                  ),
                ),
                ElevatedButton(
                  onPressed: () => value.changeEntryState(newEntryState: EntryState.register),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: value.state==EntryState.register? colorScheme.primaryContainer : colorScheme.onSurface,
                      fontWeight: value.state==EntryState.register?FontWeight.bold:FontWeight.normal,
                      fontSize: value.state==EntryState.register?16:14
                    )
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

