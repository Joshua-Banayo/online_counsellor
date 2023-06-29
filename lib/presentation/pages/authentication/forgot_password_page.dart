import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/components/widgets/custom_button.dart';
import 'package:online_counsellor/core/components/widgets/custom_input.dart';
import 'package:online_counsellor/core/components/widgets/smart_dialog.dart';
import 'package:online_counsellor/services/firebase_auth.dart';
import 'package:online_counsellor/state/navigation_state.dart';
import '../../../core/components/constants/strings.dart';
import '../../../generated/assets.dart';
import '../../../styles/styles.dart';

class ForgotPasswordPage extends ConsumerWidget {
  ForgotPasswordPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: ListTile(
            title: Row(
              children: [
                TextButton.icon(
                    onPressed: () {
                      ref.read(authIndexProvider.notifier).state = 0;
                    },
                    icon: Icon(MdiIcons.arrowLeft),
                    label: const Text('Back')),
              ],
            ),
            subtitle: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(Assets.logoLogo, width: 200),
                      Text('Password Reset'.toUpperCase(),
                          style: normalText(
                              fontSize: 35, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomTextFields(
                        hintText: 'Your Email',
                        controller: _emailController,
                        prefixIcon: MdiIcons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(emailReg).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          text: 'Reset Password',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              CustomDialog.showLoading(
                                  message: 'Sending reset Link ...');
                              await FirebaseAuthService.resetPassword(
                                      _emailController.text)
                                  .then((value) {
                                CustomDialog.dismiss();
                                if (value == 'success') {
                                  CustomDialog.showSuccess(
                                    title: 'Success',
                                    message:
                                        'Password reset link has been sent to your email',
                                  );
                                  ref.read(authIndexProvider.notifier).state =
                                      0;
                                } else {
                                  CustomDialog.showError(
                                    title: 'Error',
                                    message: value,
                                  );
                                }
                              });
                            }
                          })
                    ]),
              ),
            )));
  }
}
