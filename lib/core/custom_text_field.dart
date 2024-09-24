import 'package:flutter/material.dart';


import 'colors.dart';
import 'spaces.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function(String value)? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization? capizalize;
  final bool showLabel;
  final Widget? suffixIcon;
  final Color? color;
  final bool? readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.capizalize,
    this.showLabel = true,
    this.suffixIcon,
    this.readOnly,
    this.color = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SpaceHeight(12.0),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color,
          ),
          child: TextFormField(
            readOnly: readOnly ?? false,
            controller: controller,
            onChanged: onChanged,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: color!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: color!),
              ),
              hintText: label,
            ),
            textCapitalization: capizalize ?? TextCapitalization.words,
          ),
        ),
      ],
    );
  }
}
