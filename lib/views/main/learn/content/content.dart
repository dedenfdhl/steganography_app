import 'package:flutter/material.dart';
import 'package:steganography_app/constants/typo.dart';

import '../../../../constants/custom_colors.dart';

class LearnContent extends StatelessWidget {
  final String title;
  final String content;
  final String image;

  const LearnContent({
    super.key,
    required this.content,
    required this.image,
    required this.title,
  });

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
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              iconSize: 25,
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              title,
                              style: AppTypography.headline.copyWith(
                                fontSize: 25,
                                color: CustomColors.primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: const Color(0xff5B5B5B),
                        )),
                        child: Image.asset(image, fit: BoxFit.fill),
                      ),
                      const SizedBox(height: 38),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xff5B5B5B),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            content,
                            style:
                                AppTypography.regular12.copyWith(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 29),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
