import 'package:flutter/material.dart';

class DefaultTextFormField extends StatefulWidget {
  bool isPassword;

  TextEditingController controller;
  String hintText;
  String? Function(String?)? validator;

  DefaultTextFormField(
      {required this.controller,
      required this.hintText,
      this.validator,
      this.isPassword = false});

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  late bool isObsecure = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  isObsecure = !isObsecure;
                  setState(() {});
                },
                icon: Icon( isObsecure ? Icons.visibility_off_outlined:
                    Icons.visibility_outlined ))
            : null,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isObsecure,
    );
  }
}
