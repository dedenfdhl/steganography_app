import 'package:flutter/material.dart';
import 'package:steganography_app/constants/custom_colors.dart';
import 'package:steganography_app/constants/typo.dart';
import 'package:steganography_app/data/auth_service.dart';
// ignore: unused_import
import 'package:steganography_app/views/login/login_view.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen', 
        style: AppTypography.title.copyWith(color: CustomColors.primaryPurple, fontSize: 24),),
        centerTitle: true,
        backgroundColor: const Color(0xffF7E7FB),
        elevation: 0,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.close)),
        iconTheme: const IconThemeData(color: Color(0xff602B6F)),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFFF5AE52)
              ),
              child: Center(
                child: Text(
                  AuthService.currentUser!.email![0].toUpperCase(), 
                  style: AppTypography.medium.copyWith(fontSize: 40, color: CustomColors.primaryPurple)),
              ),
            ),
            const SizedBox(height: 20),
            Text(AuthService.currentUser!.email!, style: AppTypography.regular12.copyWith(fontSize: 18, color: CustomColors.primaryPurple)
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                    onPressed: () async {
                     await AuthService.logOut();
                     Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5AE52),
                      fixedSize: Size(MediaQuery.of(context).size.width, double.infinity),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: 
                      Text('Log Out',style: AppTypography.regular12.copyWith(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}