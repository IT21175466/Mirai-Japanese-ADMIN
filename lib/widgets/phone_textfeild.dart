import 'package:flutter/material.dart';
import 'package:mirai_japanese_admin/constaints/app_colors.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;

  const PhoneTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      height: 50,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText, //"71XXXXXXX"
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: AppColors.borderColor,
              width: 0.5,
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.textGrayColor,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        ),
      ),
    );
  }
}
