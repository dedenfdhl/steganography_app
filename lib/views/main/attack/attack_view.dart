import 'package:flutter/material.dart';
import 'package:steganography_app/constants/custom_colors.dart';
import 'package:steganography_app/constants/typo.dart';
import 'package:steganography_app/views/shared/custom_text_field_v2.dart';

class AttackView extends StatelessWidget {
  const AttackView({Key? key}) : super(key: key);

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
                  'Stego Image',
                  style: AppTypography.title
                ),
                CustomTextFieldV2(
                  readOnly: true,
                  onTap: () {},
                  prefixIcon: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xffD9D9D9),
                        border: Border.all(color: const Color(0xff5B5B5B)),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text('Choose File'),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Noise',
                  style: AppTypography.title,
                ),
                CustomTextFieldV2(
                  readOnly: true,
                  onTap: () {},
                  prefixIcon: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xffD9D9D9),
                        border: Border.all(color: const Color(0xff5B5B5B)),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text('Choose Noise'),
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 12),
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
                    onPressed: () {},
                    child: Text(
                      'Attack',
                      style: AppTypography.regular12.copyWith(
                        fontSize: 16,
                        color: CustomColors.primaryPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 21),
                Center(
                  child: Text('Stego-Image (Before)', style: AppTypography.regular12.copyWith(fontSize: 18))),
                SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  height: 236,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Center(child: Text('Stego-Image (After)', style: AppTypography.regular12.copyWith(fontSize: 18))),
                SizedBox(height: 10), 
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
