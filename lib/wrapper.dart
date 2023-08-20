import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:steganography_app/data/auth_service.dart';
import 'package:steganography_app/splash_screen.dart';
import 'package:steganography_app/views/login/login_view.dart';
import 'package:steganography_app/views/main/main_view.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.userStream,
      builder: (context, snapshot) {
      if (snapshot.hasData) {
        return MainView();
      }
      return LoginView();
    },
    );
  }
}