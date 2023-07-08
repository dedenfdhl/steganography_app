import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:steganography_app/constants/typo.dart';
import 'package:steganography_app/data/firebase_database_service.dart';
import 'package:steganography_app/views/forget_password/forget_password_view.dart';
import 'package:steganography_app/views/registration/registration_view.dart';
import 'package:steganography_app/views/shared/custom_button.dart';
import 'package:steganography_app/views/shared/custom_text_field.dart';

import '../../data/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool isPasswordHide = true;
  // ignore: unused_field
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _navigateToRegistrationView() => Navigator.push(
        //Perintah jika menekan tombol registrasi
        context,
        MaterialPageRoute(
          builder: (context) => const RegistrationView(),
        ),
      );

  void _navigateToForgetPasswordView() => Navigator.push(
        //Perintah jika menekan tombol forget password
        context,
        MaterialPageRoute(
          builder: (context) => const ForgetPasswordView(),
        ),
      );

  void loginAction() async {
    FocusScope.of(context).unfocus();
    if (_key.currentState!.validate()) {
      try {
        // ignore: unused_local_variable
        final result = await AuthService.login(
            _emailController.text, _passwordController.text);

        if (result != null) {
          dev.log(result.uid, name: 'UID');

          final userExist = await FirebaseDatabaseService.getdata(
            'users/${AuthService.currentUser!.uid}',
          );

          final String timelapse =
              (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString();

          if (userExist == null) {
            final postData = {
              'email': _emailController.text,
              'full_name': '',
              'last_login': timelapse,
            };
            FirebaseDatabaseService.updateData(
              'users/${AuthService.currentUser!.uid}',
              postData,
            );
          } else {
            final postData = {
              'email': _emailController.text,
              'full_name': (userExist as Map)['full_name'],
              'last_login': timelapse,
            };
            FirebaseDatabaseService.updateData(
              'users/${AuthService.currentUser!.uid}',
              postData,
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          e.message ?? 'Error',
          style: AppTypography.regular12.copyWith(color: Colors.white),
        )));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Register failed, please try again',
          style: AppTypography.regular12.copyWith(color: Colors.white),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        //Perintah untuk membuat layout menjadi responsif berdasarkan batasan yang dibuat
        return GestureDetector(
          //perintah untuk memberikan respon interaksi ketika menekan widget
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            //Perintah agar tampilan bisa di scroll
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                //Perintah setiap widget memiliki tinggi yang sama
                child: Column(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
                              style:
                                  AppTypography.medium.copyWith(fontSize: 40),
                            ),
                            const SizedBox(height: 24),
                            Form(
                                key: _key,
                                child: Column(
                                  children: [
                                    CustomTextField(
                                        controller: _emailController,
                                        hintText: 'Enter Email'),
                                    const SizedBox(height: 20),
                                    CustomTextField(
                                      controller: _passwordController,
                                      hintText: 'Enter password',
                                      obscureText: isPasswordHide,
                                      suffixIcon: InkWell(
                                        //perintah agar memberikan efek visual ketika menekan widget
                                        onTap: () {
                                          setState(() {
                                            isPasswordHide = !isPasswordHide;
                                          });
                                        },
                                        child: Icon(isPasswordHide
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                    ),
                                    const SizedBox(height: 37),
                                    CustomButton(
                                      textButton: 'Login',
                                      onPressed: loginAction,
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 18),
                            InkWell(
                              onTap: () => _navigateToForgetPasswordView(),
                              child: Text(
                                'Forgot Password',
                                style: AppTypography.regular12.copyWith(
                                    fontSize: 14,
                                    color: const Color(0xff060606)),
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(height: 10),
                    _buildHorizontalRule(),
                    const SizedBox(height: 12),
                    _buildSignUpQuestion(),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Row _buildHorizontalRule() {
    return Row(
      children: [
        Expanded(child: Container(height: 3, color: Colors.black)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'or',
            style: AppTypography.regular12.copyWith(fontSize: 14),
          ),
        ),
        Expanded(child: Container(height: 3, color: Colors.black))
      ],
    );
  }

  Row _buildSignUpQuestion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don’t have an account?  ',
          style: AppTypography.regular12.copyWith(
            fontSize: 14,
            color: const Color(0xff0D0C0C),
          ),
        ),
        InkWell(
          onTap: () => _navigateToRegistrationView(),
          child: Text(
            'Sign up',
            style: AppTypography.regular12
                .copyWith(color: Colors.black, fontSize: 14),
          ),
        )
      ],
    );
  }
}
