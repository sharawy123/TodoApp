import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/app_theme.dart';

import '../tabs/settings/settings_provider.dart';

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
    SettingsProvider settingsProvider =Provider.of<SettingsProvider>(context);
    return TextFormField(
      style: TextStyle(color: settingsProvider.isDark?AppTheme.white:AppTheme.black),
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: settingsProvider.isDark? AppTheme.DarktaskFormField:AppTheme.LighttaskFormField ),
        hintText: widget.hintText,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  isObsecure = !isObsecure;
                  setState(() {});
                },
                icon: Icon( isObsecure ? Icons.visibility_off_outlined:
                    Icons.visibility_outlined,color: settingsProvider.isDark? AppTheme.white:AppTheme.black, ))
            : null,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isObsecure,
    );
  }
}