import 'package:flutter/material.dart';
import 'package:to_do_app/auth/login_screen.dart';

import '../widgets/def_elevated_button.dart';
import '../widgets/def_text_field.dart';
class RegisterScreen extends StatefulWidget {
  static const String routeName ='/register';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController =TextEditingController();
  TextEditingController nameController =TextEditingController();

  TextEditingController passwordController =TextEditingController();

  var formkey =GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextFormField(
                controller: nameController,
                hintText: "Name",
                validator: (value) {
                  if(value==null || value.trim().length<5){
                    return 'Name can not be less than 2 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              DefaultTextFormField(
                controller: emailController,
                hintText: "Email",
                validator: (value) {
                  if(value==null || value.trim().length<5){
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
                  if(value==null || value.trim().length<8){
                    return 'Password can not be less than 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),

              defElevatedButton(label: 'Register',onPressedButton: Register,),
              SizedBox(height: 8),
              TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName),
                  child: Text("Already have an account?")),
            ],
          ),
        ),
      ),
    );

  }

  void Register(){
    if(formkey.currentState!.validate()){

    }
  }
  
}
