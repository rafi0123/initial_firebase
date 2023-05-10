import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:learn_firebase/utils/app_constant.dart';
import 'package:learn_firebase/utils/app_styles.dart';
import 'package:learn_firebase/views/auth/signup_view.dart';
import 'package:learn_firebase/widgets/custom_button.dart';
import 'package:learn_firebase/widgets/custom_loader.dart';
import 'package:learn_firebase/widgets/flush_bar.dart';
import 'package:learn_firebase/widgets/navigation_dialog.dart';
import 'package:learn_firebase/widgets/text_field_widget.dart';

import '../add_note_view/add_note.dart';
import 'forgot_password.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

  bool isObsecure = true;

  Future<bool> showExitPopup() async {
    return await showNavigationDialog(context,
        message: "Do you want to exit the app",
        buttonText: 'Exit', navigation: () {
      Navigator.of(context).pop(true);
    }, secondButtonText: 'Cencle', showSecondButton: true);
  }

  bool validateEmail(String email) {
    // Regular expression pattern to match email format
    const pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);

    // Check if the email matches the pattern
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: kPoppinMedium,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      TextFieldWidget(
                        hintText: 'Email',
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is Required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Password',
                        style: kPoppinMedium,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      TextFieldWidget(
                        hintText: 'Password',
                        controller: _passwordController,
                        isObsecure: isObsecure,
                        suffixIcon: InkWell(
                          onTap: () {
                            isObsecure = !isObsecure;
                            setState(() {});
                          },
                          child: isObsecure
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is Required';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),

              const SizedBox(
                height: 20,
              ),
              CustomButton(
                title: 'Login',
                ontap: () {
                  if (_emailController.text.isEmpty) {
                    getFlushBar(context, title: 'Email is Required');
                  } else if (!validateEmail(
                      _emailController.value.toString())) {
                    getFlushBar(context,
                        title: 'Please enter a valid email address');
                  } else if (_passwordController.text.isEmpty) {
                    getFlushBar(context, title: 'Password is Required');
                  } else {
                    _loginUser();
                  }

                  /// Form Validation

                  // if (_loginFormKey.currentState!.validate()) {
                  //   SmartDialog.showLoading(
                  //     builder: (ctx) => const CustomLoading(
                  //       type: 2,
                  //     ),
                  //   );
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: ((context) => const HomePage())));
                  //   SmartDialog.dismiss();
                  // }
                },
              ),

              Align(
                  alignment: Alignment.topRight,
                  child: MaterialButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const ForgotPassword())));
                      },
                      child: Text(
                        'Forgot Password',
                        style: kPoppinMedium,
                      ))),
              const SizedBox(
                height: 20,
              ),
              Text.rich(TextSpan(children: [
                TextSpan(text: "Don't have an account ", style: kPoppinRegular),
                TextSpan(
                    text: " SignUp",
                    style: kPoppinMedium,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const SignUpView())));
                      }),
              ])),

              // Both RichText works Now it's up to you which one you use

              // RichText(
              //     text: TextSpan(children: [
              //   TextSpan(
              //       text: "Don't have an account ",
              //       style: DefaultTextStyle.of(context).style),
              //   TextSpan(
              //       text: " Login",
              //       style: kPoppinMedium,
              //       recognizer: TapGestureRecognizer()
              //         ..onTap = () {
              //           print('rafi');
              //         }),
              // ])),
            ],
          ),
        )),
      ),
    );
  }

  _loginUser() async {
    SmartDialog.showLoading(
      builder: (ctx) => const CustomLoading(
        type: 2,
      ),
    );
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((value) {
        SmartDialog.dismiss();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AddNote()));
      });
    } catch (e) {
      SmartDialog.dismiss();
      showNavigationDialog(context, message: e.toString(), buttonText: 'Okey',
          navigation: () {
        Navigator.pop(context);
      }, secondButtonText: '', showSecondButton: false);
    }
  }
}
