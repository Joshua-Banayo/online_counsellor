import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/components/widgets/custom_drop_down.dart';
import 'package:online_counsellor/state/navigation_state.dart';
import '../../../core/components/constants/strings.dart';
import '../../../core/components/widgets/custom_button.dart';
import '../../../core/components/widgets/custom_input.dart';
import '../../../generated/assets.dart';
import '../../../state/data_state.dart';
import '../../../styles/colors.dart';
import '../../../styles/styles.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Assets.logoLogo, width: 200),
                Text('User Login'.toUpperCase(),
                    style:
                        normalText(fontSize: 35, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFields(
                  hintText: 'Email',
                  prefixIcon: MdiIcons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(emailReg).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFields(
                  hintText: 'Password',
                  prefixIcon: MdiIcons.lock,
                  obscureText: _isPasswordVisible,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a valid password';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? MdiIcons.eyeOffOutline
                          : MdiIcons.eyeOutline,
                      color: Colors.black,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomDropDown(
                    value: ref.read(userTypeProvider),
                    hintText: 'Select User Type',
                    icon: MdiIcons.accountAlert,
                    validator: (userType) {
                      if (userType == null) {
                        return 'Please select a user type';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      ref.read(userTypeProvider.notifier).state =
                          value.toString();
                    },
                    items: ['Counsellor', 'Client']
                        .map((value) =>
                            DropdownMenuItem(value: value, child: Text(value)))
                        .toList()),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(authIndexProvider.notifier).state = 2;
                    },
                    child: Text(
                      'Forgot Password ?',
                      style: normalText(
                          fontSize: 15,
                          color: primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: 'Login'.toUpperCase(),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(userSignInProvider.notifier).signIn(
                          email: _emailController.text,
                          password: _passwordController.text,
                          ref: ref,
                          context: context);
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account ? ',
                      style: normalText(fontSize: 15, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: normalText(
                              fontSize: 15,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ref.read(authIndexProvider.notifier).state = 1;
                            },
                        )
                      ]),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
