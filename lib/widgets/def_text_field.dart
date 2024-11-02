import 'package:flutter/material.dart';

class DefaultTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  String? Function (String?) ? validator;
  DefaultTextFormField ({ required this.controller,required this.hintText, this.validator});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,

      ),

    );
  }
}
