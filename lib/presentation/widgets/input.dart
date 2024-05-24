import 'package:exchange_rate_app/presentation/shared/app_colors.dart';
import 'package:exchange_rate_app/presentation/shared/app_styles.dart';
import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  AppInput({
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    required this.label,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
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
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          cursorColor: AppColors.grey,
          style: AppStyles.inputText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            border: border,
            focusedBorder: border,
            enabledBorder: border,
          ),
        ),
      ],
    );
  }
}
