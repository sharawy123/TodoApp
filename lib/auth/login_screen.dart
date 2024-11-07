import 'package:flutter/material.dart';
import 'package:to_do_app/auth/register_screen.dart';
import 'package:to_do_app/widgets/def_text_field.dart';

import '../widgets/def_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextFormField(
                controller: emailController,
                hintText: "Email",
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
                hintText: "Password",
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
                label: 'Login',
                onPressedButton: Login,
              ),
              SizedBox(height: 8),
              TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(RegisterScreen.routeName),
                  child: Text("Don't have an account?")),
            ],
          ),
        ),
      ),
    );
  }

  void Login() {
    if (formkey.currentState!.validate()) {}
  }
}
