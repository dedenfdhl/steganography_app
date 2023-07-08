import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:steganography_app/constants/typo.dart';
import 'package:steganography_app/data/auth_service.dart';
import 'package:steganography_app/views/shared/custom_button.dart';
import 'package:steganography_app/views/shared/custom_text_field.dart';

import '../../data/firebase_database_service.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _rePasswordController;
  late TextEditingController _fullNameController;
  bool isPasswordHide = true;
  bool isRePasswordHide = true;
  // ignore: unused_field
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
    _fullNameController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _navigateToLogInView() => Navigator.pop(context);

  void registerAction() async {
    FocusScope.of(context).unfocus();
    if (_key.currentState!.validate() &&
        _passwordController.text == _rePasswordController.text) {
      try {
        // ignore: unused_local_variable
        final result = await AuthService.register(
            _emailController.text, _passwordController.text);

        if (result != null) {
          _navigateToLogInView();
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //     content: Text(
          //   'Account has succesfully registered',
          //   style: AppTypography.regular12.copyWith(color: Colors.white),
          // )));

          final String timelapse =
              (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString();

          FirebaseDatabaseService.addData(
            'users/${AuthService.currentUser!.uid}',
            {
              'email': _emailController.text,
              'full_name': _fullNameController.text,
              'last_login': timelapse,
            },
          );
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
    } else if (_passwordController.text != _rePasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Register failed! Password not same',
            style: AppTypography.regular12.copyWith(color: Colors.white),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Register failed, please check all field requirements',
            style: AppTypography.regular12.copyWith(color: Colors.white),
          ),
        ),
      );
    }
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
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      'Register',
                      style: AppTypography.medium.copyWith(fontSize: 48),
                    ),
                    const SizedBox(height: 24),
                    Form(
                        key: _key,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _emailController,
                              hintText: 'Enter your email',
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: _fullNameController,
                              hintText: 'Enter your full name',
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: _passwordController,
                              hintText: 'Enter password',
                              obscureText: isPasswordHide,
                              suffixIcon: InkWell(
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
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: _rePasswordController,
                              hintText: 'Re-nter password',
                              obscureText: isRePasswordHide,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isRePasswordHide = !isRePasswordHide;
                                  });
                                },
                                child: Icon(isRePasswordHide
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 37),
                    CustomButton(
                      textButton: 'Register',
                      onPressed: registerAction,
                    ),
                    const SizedBox(height: 18),
                    _buildLogInQuestion(),
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

  Row _buildLogInQuestion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Have an account already?  ',
          style: AppTypography.regular12.copyWith(
            fontSize: 14,
            color: const Color(0xff0D0C0C),
          ),
        ),
        InkWell(
          onTap: () => _navigateToLogInView(),
          child: Text(
            'Log in',
            style: AppTypography.regular12
                .copyWith(color: Colors.blue, fontSize: 14),
          ),
        )
      ],
    );
  }
}
