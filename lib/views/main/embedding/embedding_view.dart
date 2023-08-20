// Page Two
import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:steganography_app/constants/common.dart';
import 'package:steganography_app/constants/custom_colors.dart';
import 'package:steganography_app/constants/typo.dart';
import 'package:steganography_app/model/image_picker.dart';
import 'package:steganography_app/views/shared/custom_text_field_v2.dart';

import '../../../data/auth_service.dart';
import '../../../data/firebase_database_service.dart';
import '../../../data/firebase_storage_service.dart';

class EmbeddingView extends StatefulWidget {
  final Widget? prefixIcon;

  const EmbeddingView({this.prefixIcon, Key? key}) : super(key: key);

  @override
  State<EmbeddingView> createState() => _EmbeddingViewState();
}

class _EmbeddingViewState extends State<EmbeddingView> {
  final imagePicker = ImagePickerHandler();

  File? citraImage;
  File? watermarkImage;

  List<String> noises = [
    'Without Attack',
    'Quantum Attack',
  ];

  List<String> methods = [
    'Choose Method',
    'Quantum DCT',
    'Quantum Wavelet',
    'Quantum SS',
  ];

  String? noiseController = 'Without Attack';
  String? methodController = 'Choose Method';

  final TextEditingController keyController = TextEditingController();

  Future<void> submitEmbedding() async {
    if (citraImage != null &&
        watermarkImage != null &&
        keyController.text.isNotEmpty &&
        // noiseController != 'Choose Noise' &&
        methodController != 'Choose Method' &&
        AuthService.currentUser != null) {
      String citraExtension = '';
      if (citraImage!.path.endsWith("png")) {
        citraExtension = 'png';
      } else if (citraImage!.path.endsWith("jpg")) {
        citraExtension = 'jpg';
      } else if (citraImage!.path.endsWith("jpeg")) {
        citraExtension = 'jpeg';
      }

      String watermarkExtension = '';
      if (watermarkImage!.path.endsWith("png")) {
        watermarkExtension = 'png';
      } else if (watermarkImage!.path.endsWith("jpg")) {
        watermarkExtension = 'jpg';
      } else if (watermarkImage!.path.endsWith("jpeg")) {
        watermarkExtension = 'jpeg';
      }
      // userid_metode_attack_H_timelapse
      final String method =
          methodController!.replaceAll('Quantum ', '').toLowerCase();
      final String noise =
          noiseController!.replaceAll('Attack', '').toLowerCase();
      final String timelapse =
          (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString();

      // final String refCitra =
      //     'HostEm/${AuthService.currentUser!.uid}_${method}_${noise}_${keyController.text}_H_$timelapse';
      // final String refWatermark =
      //     'WatermarkEm/${AuthService.currentUser!.uid}_${method}_${noise}_${keyController.text}_W_$timelapse';
      final String refCitra =
          'HostEm/${AuthService.currentUser!.uid}_${method.toLowerCase()}_H_$timelapse.$citraExtension';
      final String refWatermark =
          'WatermarkEm/${AuthService.currentUser!.uid}_${method.toLowerCase()}_W_$timelapse.$watermarkExtension';

      try {
        FirebaseStorageService.uploadImage(citraImage!, refCitra);
        FirebaseStorageService.uploadImage(watermarkImage!, refWatermark);

        FirebaseDatabaseService.addData(
          'Embedding/HostEm/$timelapse',
          {
            'attack': noise == 'without' ? '0' : '0.1',
            'key': keyController.text,
            'metode': method.toLowerCase(),
            'nama_file': refCitra.replaceAll('HostEm/', ''),
            'path_file': 'HostEm/',
            'status': '0',
            'timestamp': timelapse,
            'userid': AuthService.currentUser!.uid,
          },
        );
        FirebaseDatabaseService.addData(
          'Embedding/WatermarkEm/$timelapse',
          {
            'attack': noise == 'without' ? '0' : '0.1',
            'key': keyController.text,
            'metode': method.toLowerCase(),
            'nama_file': refWatermark.replaceAll('WatermarkEm/', ''),
            'path_file': 'WatermarkEm/',
            'status': '0',
            'timestamp': timelapse,
            'userid': AuthService.currentUser!.uid,
          },
        );

        // FirebaseDatabaseService.addData(
        //   'deden_test/${Utils.generateUuid()}',
        //   {'nama_file': 'asd', 'path_file': 'HostEm/'},
        // );
        // FirebaseDatabaseService.addData(
        //   'Embedding/HostEm/$timelapse',
        //   {'nama_file': 'asd', 'path_file': 'HostEm/'},
        // );

        citraImage = null;
        watermarkImage = null;
        keyController.clear();
        noiseController = 'Without Attack';
        methodController = 'Choose Method';
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Data has been uploaded and saved successfully',
          style: AppTypography.regular12.copyWith(color: Colors.white),
        )));
        dev.log('upload finish and saved', name: 'selesai');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Error. $e',
              style: AppTypography.regular12.copyWith(color: Colors.white),
            ),
          ),
        );
        dev.log(e.toString());
        debugPrint(e.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'All field are required! Please check',
            style: AppTypography.regular12.copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            minHeight: constraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox( height: 16),
                  Text('Notes:', style: AppTypography.subHeading,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)
                    ),
                    child: SingleChildScrollView(
                      child: 
                        Text(Common.guideEmbedding, style: AppTypography.regular12.copyWith(fontSize: 14))
                      ,
                    ),
                  ), 
                  const SizedBox(height: 16),
                  const Text(
                    'Method',
                    style: AppTypography.title,
                  ),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xff5B5B5B)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton(
                      value: methodController,
                      items: methods.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          methodController = value;
                        });
                      },
                      hint: const Text(
                        'Choose Noise',
                      ),
                      underline: const SizedBox(),
                      icon: const SizedBox(),
                      style: const TextStyle(
                          fontSize: 18, color: Color(0xff393838)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Host Image', style: AppTypography.title),
                  CustomTextFieldV2(
                    controller: TextEditingController(
                        text: citraImage == null ? '' : citraImage?.path),
                    readOnly: true,
                    onTap: () async {
                      citraImage = await imagePicker.pickImage();
                      dev.log('CitraImage: ${citraImage?.uri}');

                      setState(() {});

                      // dev.log(
                      //   AuthService.currentUser!.uid.toString(),
                      //   name: 'user',
                      // );

                      // dev.log(
                      //   (DateTime.now().millisecondsSinceEpoch / 1000)
                      //       .floor()
                      //       .toString(),
                      //   name: 'timestamp milliseconds',
                      // );
                    },
                    prefixIcon: citraImage == null
                        ? Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                                color: const Color(0xffD9D9D9),
                                border:
                                    Border.all(color: const Color(0xff5B5B5B)),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text('Choose File'),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hidden Image',
                    style: AppTypography.title,
                  ),
                  CustomTextFieldV2(
                    controller: TextEditingController(
                        text:
                            watermarkImage == null ? '' : watermarkImage?.path),
                    readOnly: true,
                    onTap: () async {
                      watermarkImage = await imagePicker.pickImage();
                      dev.log('WatermarkImage: ${watermarkImage?.uri}');

                      setState(() {});
                    },
                    prefixIcon: watermarkImage == null
                        ? Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                                color: const Color(0xffD9D9D9),
                                border:
                                    Border.all(color: const Color(0xff5B5B5B)),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text('Choose File'),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Key',
                    style: AppTypography.title,
                  ),
                  Text('(Key atau kunci merupakan kombinasi angka dari 1-1023)', style: AppTypography.regular12.copyWith(fontSize: 12)),
                  TextFormField(
                    controller: keyController,
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: widget.prefixIcon,
                      prefixIconConstraints:
                          const BoxConstraints(minHeight: 0, minWidth: 0),
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff5B5B5B)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff5B5B5B)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Enter your key here',
                      hintStyle: AppTypography.headline.copyWith(
                        fontSize: 18,
                        color: const Color(0xff393838),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Attack',
                    style: AppTypography.title,
                  ),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xff5B5B5B)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton(
                      value: noiseController,
                      items: noises.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          noiseController = value;
                        });
                      },
                      hint: const Text(
                        'Without Noise',
                      ),
                      underline: const SizedBox(),
                      icon: const SizedBox(),
                      style: const TextStyle(
                          fontSize: 18, color: Color(0xff393838)),
                    ),
                  ),
                  // CustomTextFieldV2(
                  //   readOnly: true,
                  //   hintText: 'Choose noise',
                  //   onTap: () {},
                  //   // prefixIcon: Container(
                  //   //   margin: const EdgeInsets.only(left: 10),
                  //   //   padding: const EdgeInsets.symmetric(
                  //   //       vertical: 8, horizontal: 12),
                  //   //   decoration: BoxDecoration(
                  //   //     color: const Color(0xffD9D9D9),
                  //   //     border: Border.all(color: const Color(0xff5B5B5B)),
                  //   //     borderRadius: BorderRadius.circular(
                  //   //       10,
                  //   //     ),
                  //   //   ),
                  //   //   child: const Text('Choose Noise'),
                  //   // ),
                  // ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: CustomColors.primaryPurple,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0),
                      onPressed: submitEmbedding,
                      child: Text(
                        'Embedding',
                        style: AppTypography.regular12.copyWith(
                            fontSize: 16, color: const Color(0xff602B6F), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // const SizedBox(height: 15),
                  // Center(
                  //     child: Text('Stego-Image',
                  //         style:
                  //             AppTypography.regular12.copyWith(fontSize: 18))),
                  // const SizedBox(height: 10),
                  // Container(
                  //   margin: const EdgeInsets.only(bottom: 20),
                  //   width: double.infinity,
                  //   height: 236,
                  //   color: Colors.white,
                  // ),
                  // const SizedBox(height: 10),
                  // Center(
                  //     child: Text('Stego-Image (After)',
                  //         style:
                  //             AppTypography.regular12.copyWith(fontSize: 18))),
                  // const SizedBox(height: 10),
                  // Container(
                  //   margin: const EdgeInsets.only(bottom: 20),
                  //   width: double.infinity,
                  //   height: 236,
                  //   color: Colors.white,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //             side: const BorderSide(
                  //               color: CustomColors.primaryPurple,
                  //             ),
                  //           ),
                  //           backgroundColor: Colors.transparent,
                  //           elevation: 0),
                  //       onPressed: () {},
                  //       child: Text('Save',
                  //           style: AppTypography.regular12.copyWith(
                  //               fontSize: 14, color: const Color(0xff602B6F))),
                  //     ),
                  //     const SizedBox(width: 40),
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //             side: const BorderSide(
                  //               color: CustomColors.primaryPurple,
                  //             ),
                  //           ),
                  //           backgroundColor: Colors.transparent,
                  //           elevation: 0),
                  //       onPressed: () {},
                  //       child: Text('Share',
                  //           style: AppTypography.regular12.copyWith(
                  //               fontSize: 14, color: const Color(0xff602B6F))),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
