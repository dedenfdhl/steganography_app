import 'package:flutter/material.dart';
import '../../constants/custom_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField(
      {super.key,
      this.hintText,
      this.suffixIcon,
      this.obscureText = false,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, color: CustomColors.primaryPurple),
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        hintText: hintText,
        hintStyle:
            const TextStyle(fontSize: 20, color: CustomColors.primaryPurple),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: CustomColors.primaryPurple),
          borderRadius: BorderRadius.circular(45),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: CustomColors.primaryPurple),
          borderRadius: BorderRadius.circular(45),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(45),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(45),
        ),
      ),
      // ignore: body_might_complete_normally_nullable
      validator: (value) {
        if (value!.isEmpty) {
          return 'This Field cannot be empyt';
        }
      },
    );
  }
}
