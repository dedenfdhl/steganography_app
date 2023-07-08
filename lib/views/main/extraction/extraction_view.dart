import 'dart:io';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import 'package:steganography_app/constants/custom_colors.dart';
import 'package:steganography_app/constants/typo.dart';
import 'package:steganography_app/views/shared/custom_text_field_v2.dart';

import '../../../data/auth_service.dart';
import '../../../data/firebase_database_service.dart';
import '../../../data/firebase_storage_service.dart';
import '../../../model/image_picker.dart';

class ExtractionView extends StatefulWidget {
  const ExtractionView({Key? key}) : super(key: key);

  @override
  State<ExtractionView> createState() => _ExtractionViewState();
}

class _ExtractionViewState extends State<ExtractionView> {
  final imagePicker = ImagePickerHandler();
  final TextEditingController keyController = TextEditingController();

  File? stegoImage;
  List<String> methods = [
    'Choose Method',
    'Quantum DCT',
    'Quantum DWT',
    'Quantum SS',
  ];

  String? methodController = 'Choose Method';

  Future<void> submitExtraction() async {
    if (stegoImage != null &&
        keyController.text.isNotEmpty &&
        methodController != 'Choose Method' &&
        AuthService.currentUser != null) {
      // userid_metode_attack_H_timelapse
      final String method =
          methodController!.replaceAll('Quantum ', '').toLowerCase();
      final String timelapse =
          (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString();

      final String refStego =
          'StegoEx/${AuthService.currentUser!.uid}_${method.toLowerCase()}_SI_$timelapse';

      try {
        FirebaseStorageService.uploadImage(stegoImage!, refStego);

        FirebaseDatabaseService.addData(
          'Extraction/StegoEx/$timelapse',
          {
            'key': keyController.text,
            'metode': method.toLowerCase(),
            'nama_file': refStego,
            'path_file': 'StegoEx/',
            'status': 0,
            'timestamp': timelapse,
            'user_id': AuthService.currentUser!.uid,
          },
        );

        stegoImage = null;
        keyController.clear();
        methodController = '';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    style:
                        const TextStyle(fontSize: 18, color: Color(0xff393838)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Stego Image', style: AppTypography.title),
                CustomTextFieldV2(
                  controller: TextEditingController(
                      text: stegoImage == null ? '' : stegoImage?.path),
                  readOnly: true,
                  onTap: () async {
                    stegoImage = await imagePicker.pickImage();
                    dev.log('stegoImage: ${stegoImage?.uri}');

                    setState(() {});
                  },
                  prefixIcon: stegoImage == null
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
                const Text('Key', style: AppTypography.title),
                CustomTextFieldV2(
                  controller: keyController,
                  hintText: 'Enter your key heres',
                ),
                const SizedBox(height: 24),
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
                    onPressed: submitExtraction,
                    child: Text('Extraction',
                        style: AppTypography.regular12.copyWith(
                            fontSize: 16, color: const Color(0xff602B6F))),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                    child: Text('Watermarking',
                        style: AppTypography.regular12.copyWith(fontSize: 18))),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  height: 236,
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: CustomColors.primaryPurple,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0),
                      onPressed: () {},
                      child: Text(
                        'Save',
                        style: AppTypography.regular12.copyWith(
                          fontSize: 14,
                          color: CustomColors.primaryPurple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: CustomColors.primaryPurple,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0),
                      onPressed: () {},
                      child: Text(
                        'Share',
                        style: AppTypography.regular12.copyWith(
                          fontSize: 14,
                          color: CustomColors.primaryPurple,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
