import 'package:flutter/material.dart';

import '../core/colors.dart';

class CategoryButton extends StatelessWidget {
  final String? imagePath;
  final String label;
  final VoidCallback onPressed;

  const CategoryButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: AppColors.primary,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Icon(
                Icons.description,
                size: 80.0,
                color: AppColors.primary,
              ),
              SizedBox(
                width: 70.0,
                child: Text(
                  label,
                  style: const TextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
