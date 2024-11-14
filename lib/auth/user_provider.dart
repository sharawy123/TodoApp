import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/user_model.dart';

class UserProvider with ChangeNotifier{
  UserModel? currUser;

  void UpdateUser (UserModel ? user){
    currUser =user;
    notifyListeners();

  }


}