import 'package:flutter/material.dart';
import 'package:steganography_app/constants/custom_colors.dart';
import 'package:steganography_app/splash_screen.dart';
// ignore: unused_import
import 'package:steganography_app/views/login/login_view.dart';
import 'package:steganography_app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quest',
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColors.background,
      
      ),
      home: const SplashScreen(), 
    );
  }
}
