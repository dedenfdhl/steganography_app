import 'package:flutter/material.dart';
import 'package:steganography_app/views/main/your_project/embedding_projects.dart';
import 'package:steganography_app/views/main/your_project/extraction_projects.dart';

import '../../../constants/custom_colors.dart';
import '../../../constants/typo.dart';

class YourProject extends StatefulWidget {
  const YourProject({super.key});

  @override
  State<YourProject> createState() => _YourProjectState();
}

class _YourProjectState extends State<YourProject> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            minHeight: constraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildYourProjectItem(
                  'Embedding',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmbeddingProjects(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildYourProjectItem(
                  'Extraction',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExtractionProjects(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  InkWell _buildYourProjectItem(String name, Function() onTap) {
    return InkWell(
      //Menampilkan tampilan menu Learn
      onTap: onTap,
      child: Container(
        height: 78,
        decoration: BoxDecoration(
          color: CustomColors.secondaryOrange,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.25),
              offset: const Offset(0, 4),
              blurRadius: 4,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  name,
                  style: AppTypography.medium.copyWith(
                      fontSize: 18, color: CustomColors.primaryPurple, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CustomColors.primaryPurple)),
                child: const Icon(
                  Icons.chevron_right,
                  size: 32,
                  color: CustomColors.primaryPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
