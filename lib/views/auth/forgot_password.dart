import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:learn_firebase/widgets/custom_button.dart';
import 'package:learn_firebase/widgets/custom_loader.dart';
import 'package:learn_firebase/widgets/text_field_widget.dart';

import '../../widgets/navigation_dialog.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final ref = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFieldWidget(
              hintText: 'Email',
              controller: _emailController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              title: 'Enter',
              ontap: () {
                SmartDialog.showLoading(builder: (_) {
                  return const CustomLoading(
                    type: 2,
                  );
                });
                ref
                    .sendPasswordResetEmail(
                        email: _emailController.text.toString())
                    .then((value) {
                  SmartDialog.dismiss();
                  _emailController.clear();
                  showNavigationDialog(
                    context,
                    message: 'Firebase just send you an email link',
                    buttonText: 'Okey',
                    navigation: () {
                      Navigator.pop(context);
                    },
                    secondButtonText: '',
                    showSecondButton: false,
                  );
                }).onError((error, stackTrace) {
                  SmartDialog.dismiss();
                  _emailController.clear();

                  showNavigationDialog(context,
                      message: e.toString(),
                      buttonText: 'Okey', navigation: () {
                    Navigator.pop(context);
                  }, secondButtonText: '', showSecondButton: false);
                });
              },
            )
          ],
        ),
      )),
    );
  }
}
