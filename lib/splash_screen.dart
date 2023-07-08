import 'dart:async';
import 'package:flutter/material.dart';
import 'package:steganography_app/views/login/login_view.dart';
// ignore: unused_import
import 'package:flutter/src/widgets/placeholder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //untuk memberika jeda waktu ketika splashscreen muncul
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          )); //untuk memindahkan splashscreen sebelum menu login
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffF7E7FB),
        width: MediaQuery.of(context)
            .size
            .width, //ukuran container disesuaikan dengan layar
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/1.png'),
        ]),
      ),
    );
  }
}
