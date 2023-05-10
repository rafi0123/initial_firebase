import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:learn_firebase/views/auth/login_view.dart';
import 'package:learn_firebase/views/add_note_view/add_note.dart';
import 'package:learn_firebase/widgets/custom_button.dart';
import 'package:learn_firebase/widgets/custom_loader.dart';
import 'package:learn_firebase/widgets/flush_bar.dart';
import 'package:learn_firebase/widgets/navigation_dialog.dart';
import 'package:learn_firebase/widgets/text_field_widget.dart';

import '../../utils/app_constant.dart';
import '../../utils/app_styles.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conformpasswordController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  bool validateEmail(String email) {
    // Regular expression pattern to match email format
    const pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);

    // Check if the email matches the pattern
    return regex.hasMatch(email);
  }

  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.13,
              ),
              Form(
                  key: _fromKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: kPoppinMedium,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      TextFieldWidget(
                        hintText: 'Name',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'value is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is Required';
                          } else if (value.length <= 6) {
                            return 'Password should be greater then 6 char';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Conform Password',
                        style: kPoppinMedium,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      TextFieldWidget(
                        hintText: 'Conform Password',
                        controller: _conformpasswordController,
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
                          if (value != _passwordController.text) {
                            return 'Password not match';
                          } else if (value!.isEmpty) {
                            return 'Password required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
              CustomButton(
                ontap: () {
                  if (_nameController.text.isEmpty) {
                    getFlushBar(context, title: 'Name is Required');
                  } else if (_emailController.text.isEmpty) {
                    getFlushBar(context, title: 'Email is Required');
                  } else if (!validateEmail(
                      _emailController.value.toString())) {
                    getFlushBar(context,
                        title: 'Please enter a valid email address');
                  } else if (_passwordController.text.isEmpty) {
                    getFlushBar(context, title: 'Password is Required');
                  } else if (_passwordController.text.length <= 6) {
                    getFlushBar(context,
                        title: 'Password should be greater then 6 char');
                  } else if (_conformpasswordController.text !=
                      _passwordController.text) {
                    getFlushBar(context,
                        title: 'Conform password do not match');
                  } else {
                    _createAccount();
                  }

                  // this is Question

                  /// Form validation

                  // if (_fromKey.currentState!.validate()) {
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
                title: 'Sign Up',
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "Don't have an account ",
                    style: kPoppinRegular,
                  ),
                  TextSpan(
                      text: " Login",
                      style: kPoppinMedium,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>const LoginView())));
                        }),
                ])),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void _createAccount() async {
    SmartDialog.showLoading(
      builder: (ctx) => const CustomLoading(
        type: 2,
      ),
    );

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((value) async {
        var userID = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection('Users').doc(userID).set({
          "Name": _nameController.text.toString(),
          "Email": _emailController.text.toString(),
          'Password': _passwordController.text.toString(),
        }).then((value) {
          SmartDialog.dismiss();
          showNavigationDialog(context,
              message: "Thank you for Registration \nLogin Now",
              buttonText: 'Okey', navigation: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const LoginView())));
          }, secondButtonText: '', showSecondButton: false);
        });
      });
    } catch (e) {
      SmartDialog.dismiss();
      showNavigationDialog(context, message: e.toString(), buttonText: 'Okey',
          navigation: () {
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const LoginView())));
      }, secondButtonText: '', showSecondButton: false);
    }
  }
}
