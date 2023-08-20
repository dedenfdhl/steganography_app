import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:steganography_app/constants/custom_colors.dart';
import 'package:steganography_app/constants/typo.dart';

class SteganoLearn extends StatelessWidget {
  const SteganoLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Steganografi', style: AppTypography.title.copyWith(color: CustomColors.primaryPurple, fontSize: 25),),
        elevation: 0,
        backgroundColor: Color(0xffF7E7FB),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xff602B6F),
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context);
          }
        )
      ),
      body: MyStatefulWidget(),
    );
  }
}
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final pdfPinchcontroller = PdfControllerPinch(
    document: PdfDocument.openAsset('assets/images/stegano.pdf'),
  );

  @override
  Widget build(BuildContext context) {
    return PdfViewPinch(
      controller: pdfPinchcontroller,
    );
  }
  
}
 