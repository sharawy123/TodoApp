import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/app_theme.dart';
import 'package:to_do_app/auth/login_screen.dart';
import 'package:to_do_app/auth/user_provider.dart';
import 'package:to_do_app/firebase_functions.dart';
import 'package:to_do_app/home_screen.dart';
import 'package:to_do_app/tabs/settings/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/def_elevated_button.dart';
import '../widgets/def_text_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(((AppLocalizations.of(context)!.register)),
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color:
                    settingsProvider.isDark ? AppTheme.white : AppTheme.black)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextFormField(
                controller: nameController,
                hintText: ((AppLocalizations.of(context)!.name)),
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Name can not be less than 2 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DefaultTextFormField(
                controller: emailController,
                hintText: ((AppLocalizations.of(context)!.email)),
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Email can not be less than 5 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              DefaultTextFormField(
                controller: passwordController,
                hintText: (AppLocalizations.of(context)!.password),
                isPassword: true,
                validator: (value) {
                  if (value == null || value.trim().length < 8) {
                    return 'Password can not be less than 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              defElevatedButton(
                label: ((AppLocalizations.of(context)!.register)),
                onPressedButton: Register,
              ),
              SizedBox(height: 8),
              TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName),
                  child: Text(AppLocalizations.of(context)!.already)),
            ],
          ),
        ),
      ),
    );
  }

  void Register() {
    if (formkey.currentState!.validate()) {
      FireBaseFunctions.register(
        name: nameController.text,
        password: passwordController.text,
        email: emailController.text,
      ).then(
        (user) {
          Provider.of<UserProvider>(context, listen: false).UpdateUser(user);
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        },
      ).catchError((error) {
        String? message;
        if (error is FirebaseAuthException) {
          message = error.message;
        }
        Fluttertoast.showToast(
          msg: message ?? 'Something went wrong!',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.red,
        );
      });
    }
  }
}
