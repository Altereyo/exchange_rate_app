import 'package:exchange_rate_app/presentation/shared/app_colors.dart';
import 'package:exchange_rate_app/presentation/shared/app_styles.dart';
import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  AppInput({
    super.key,
    this.controller,
    this.onChanged,
    required this.label,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String label;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;

  final border = OutlineInputBorder(
    borderSide: const BorderSide(
      color: AppColors.grey,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(8),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child:
          Text(label, style: AppStyles.inputLabel),
        ),
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          cursorColor: AppColors.grey,
          style: AppStyles.inputText,
          decoration: InputDecoration(
            border: border,
            focusedBorder: border,
            enabledBorder: border,
          ),
        ),
      ],
    );
  }
}
