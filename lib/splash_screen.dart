import 'dart:async';
import 'package:flutter/material.dart';
import 'package:steganography_app/views/login/login_view.dart';
import 'package:steganography_app/wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreentState();
}

class _SplashScreentState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4), () { 
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Wrapper(),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffF7E7FB),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/1.png'),
          ],
        ),
      ),
    );
  }
}