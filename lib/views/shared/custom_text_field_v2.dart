import 'package:flutter/material.dart';

class CustomTextFieldV2 extends StatelessWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final bool readOnly;
  final Function()? onTap;
  final TextEditingController? controller;

  const CustomTextFieldV2({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      onTap: onTap,
      style: const TextStyle(fontSize: 20, color: Color(0xff393838)),
      decoration: InputDecoration(
        filled: true,
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 18, color: Color(0xff393838)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff5B5B5B)),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff5B5B5B)),
          borderRadius: BorderRadius.circular(10),
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
    );
  }
}
