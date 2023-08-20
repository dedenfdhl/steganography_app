import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:steganography_app/constants/typo.dart';
import 'package:steganography_app/data/auth_service.dart';
import '../../constants/custom_colors.dart';
import '../shared/custom_button.dart';
import '../shared/custom_text_field.dart';
// ignore: unused_import


class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }
   @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 10,
                minHeight: 100,
              ),
              child: IntrinsicHeight(
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const Spacer(),
                      Container(
                          child: 
                          Image.asset('assets/images/or.png', height: 300, ),
                      ),
                      
                      Text(
                        'Forget Password',
                        style: AppTypography.medium.copyWith(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Don't worry it happens. Please enter the address associated with your account.",
                        style: AppTypography.regular12.copyWith(
                          fontSize: 16,
                          color: CustomColors.primaryPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(controller: _emailController,
                        hintText: 'Enter your email',
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        textButton: 'Submit',
                        onPressed: () async {
                          if (_emailController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 
                          Text('Email cannot be empty', 
                          style: AppTypography.regular12.copyWith(color: Colors.white),)));
                          } else {
                            try {
                              await AuthService.resetPassword(_emailController.text);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 
                          Text('Reset password succesfully send to email', 
                          style: AppTypography.regular12.copyWith(color: Colors.white),)));

                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 
                          Text(e.message ?? 'Error', 
                          style: AppTypography.regular12.copyWith(color: Colors.white),)));
                            } catch(e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 
                          Text('Failed to send a link to reset password', 
                          style: AppTypography.regular12.copyWith(color: Colors.white),)));
                            } 
                          }
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
