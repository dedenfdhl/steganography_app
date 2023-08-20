import 'package:flutter/material.dart';
import 'package:steganography_app/constants/custom_colors.dart';
import 'package:steganography_app/constants/typo.dart';

class CustomButton extends StatelessWidget {
  final String textButton;
  final Function() onPressed;

  const CustomButton({
    super.key,
    required this.textButton,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.orangeButton,
          fixedSize: Size(MediaQuery.of(context).size.width, double.infinity),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          textButton,
          style: AppTypography.regular12.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
