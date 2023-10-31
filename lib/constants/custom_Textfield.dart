import 'package:flutter/material.dart';

import '../utils/colors.dart';



class CustomTextFormField extends StatelessWidget {
  final String hinttext ;
  final controller;
  bool obscure ;
  final inputType;
   CustomTextFormField({super.key,required this.hinttext, required this.controller, this.obscure= false, this.inputType});

  @override
  Widget build(BuildContext context) {
    final border =  OutlineInputBorder(
      borderSide: Divider.createBorderSide(context)
    );
    return   TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscure,
      decoration: InputDecoration(
          fillColor: mobileSearchColor,
          filled: true,
          hintText: hinttext,
          border:border,
        enabledBorder: border,
        focusedBorder: border
      ),
    );
  }
}
