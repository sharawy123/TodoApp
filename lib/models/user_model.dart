 import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:to_do_app/firebase_functions.dart';
class UserModel{
  String id;
  String name;
  String email;
  UserModel({required this.id,required this.name,required this.email});

    UserModel.fromJson(Map<String,dynamic>json ): this(id: json['id'],name: json['name'],email: json['email']);

      Map<String,dynamic>toJson() =>{
       'id':id,
      'name':name,
        'email':email,
   };
 }