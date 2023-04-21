import 'package:flutter/material.dart';
import 'package:learn_firebase/utils/app_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.title,
    this.ontap,
    this.style = const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: kWhite),
  }) : super(key: key);
  final String title;
  final VoidCallback? ontap;
  final TextStyle style;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: MaterialButton(
        color: kPrimary,
        onPressed: ontap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            title,
            style: style,
          ),
        ),
      ),
    );
  }
}
