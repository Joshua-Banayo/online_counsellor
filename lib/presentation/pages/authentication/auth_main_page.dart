import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/navigation_state.dart';
import '../../../styles/colors.dart';
import '../../../styles/styles.dart';
import 'forgot_password_page.dart';
import 'login_page.dart';
import 'sign_up_page.dart';

class AuthMainPage extends ConsumerWidget {
  const AuthMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        return await warnUserBeforeCloseApp(context);
      },
      child: SafeArea(
          child: Scaffold(
              body: IndexedStack(
        alignment: Alignment.center,
        index: ref.watch(authIndexProvider),
        children: [const LoginPage(), const SignUpPage(), ForgotPasswordPage()],
      ))),
    );
  }

  Future<bool> warnUserBeforeCloseApp(BuildContext context) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App',
                style: normalText(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 16)),
            content: Text('Do you want to exit an App?',
                style: normalText(
                    fontWeight: FontWeight.normal,
                    color: primaryColor,
                    fontSize: 14)),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialog had returned null, then return false
  }
}
