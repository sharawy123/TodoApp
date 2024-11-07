import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/models/user_model.dart';

class FireBaseFunctions {
  static CollectionReference<TaskModel> getTasksCollection() =>
      FirebaseFirestore.instance.collection('tasks').withConverter<TaskModel>(
        fromFirestore: (docSnapshot, _) =>
            TaskModel.fromJson(docSnapshot.data()!),
        toFirestore: (taskmodel, _) => taskmodel.toJson(),
      );

  static CollectionReference<UserModel> getUserCollection() =>
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
          fromFirestore: (docSnapshot, _) =>
              UserModel.fromJson(docSnapshot.data()!),
          toFirestore: (userModel, _) => userModel.toJson());

  static Future<void> addtaskFireStore(TaskModel task) {
    CollectionReference<TaskModel> taskCollection = getTasksCollection();
    DocumentReference<TaskModel> doc = taskCollection.doc();
    task.id = doc.id;
    return doc.set(task);
  }

  static Future<List<TaskModel>> getAlltasksFromFireStore() async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs.map((docSnapShot) => docSnapShot.data()).toList();
  }

  static Future<void> deleteTaskFromFirestore(String taskID) async {
    CollectionReference<TaskModel> taskCollection = getTasksCollection();
    return taskCollection.doc(taskID).delete();
  }

  static Future<void> register({required String name,
    required String password,
    required String email}) async {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    CollectionReference<UserModel> usercollection = getUserCollection();
    UserModel user =
    UserModel(id: credential.user!.uid, name: name, email: email);
    await usercollection.doc(user.id).set(user);
  }

  static Future<UserModel> login(
      {required String email, required String password}) async {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    CollectionReference <UserModel> userCollection = getUserCollection();
    DocumentSnapshot <UserModel> docSnapshot = await userCollection.doc(
        credential.user!.uid).get();
    return docSnapshot.data()!;
  }

  Future<void> logout() => FirebaseAuth.instance.signOut();
}