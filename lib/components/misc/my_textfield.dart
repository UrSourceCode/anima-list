import 'package:AnimaList/theme/colors.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.lightPrimaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.lightPrimaryColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.lightPrimaryColor)
      ),
    );
  }
}
