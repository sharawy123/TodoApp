import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/models/user_model.dart';

class FireBaseFunctions {
  static CollectionReference<UserModel> getUserCollection() =>
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
          fromFirestore: (docSnapshot, _) =>
              UserModel.fromJson(docSnapshot.data()!),
          toFirestore: (userModel, _) => userModel.toJson());

  static CollectionReference<TaskModel> getTasksCollection(String userID) =>
      getUserCollection()
          .doc(userID)
          .collection('tasks')
          .withConverter<TaskModel>(
            fromFirestore: (docSnapshot, _) =>
                TaskModel.fromJson(docSnapshot.data()!),
            toFirestore: (taskmodel, _) => taskmodel.toJson(),
          );

  static Future<void> addtaskFireStore(TaskModel task, String userID) {
    CollectionReference<TaskModel> taskCollection = getTasksCollection(userID);
    DocumentReference<TaskModel> doc = taskCollection.doc();
    task.id = doc.id;
    return doc.set(task);
  }

  static Future<List<TaskModel>> getAlltasksFromFireStore(String userID) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userID);
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs.map((docSnapShot) => docSnapShot.data()).toList();
  }

  static Future<void> editTask(String userId, TaskModel task) async {
    CollectionReference<TaskModel> taskCollection = getTasksCollection(userId);
    DocumentReference<TaskModel> doc = taskCollection.doc();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(task.id)
        .update({
      'title': task.title,
      'description': task.description,
      'date': task.date,
    });
    //taskCollection.doc(taskId).set(task);
  }

  static Future<void> taskIsDone(
      String userID, String taskID, TaskModel task) async {
    CollectionReference<TaskModel> taskCollection = getTasksCollection(userID);
    DocumentReference<TaskModel> doc = taskCollection.doc();
    //taskCollection.doc(taskID).update((task.isDone=true));
    task.isDone = true;
    taskCollection.doc(taskID).set(task);
  }

  static Future<void> deleteTaskFromFirestore(
      String taskID, String userID) async {
    CollectionReference<TaskModel> taskCollection = getTasksCollection(userID);
    return taskCollection.doc(taskID).delete();
  }

  static Future<UserModel> register(
      {required String name,
      required String password,
      required String email}) async {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    UserModel user =
        UserModel(id: credential.user!.uid, name: name, email: email);
    CollectionReference<UserModel> usercollection = getUserCollection();
    await usercollection.doc(user.id).set(user);
    return user;
  }

  static Future<UserModel> login(
      {required String email, required String password}) async {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    CollectionReference<UserModel> userCollection = getUserCollection();
    DocumentSnapshot<UserModel> docSnapshot =
        await userCollection.doc(credential.user!.uid).get();
    return docSnapshot.data()!;
  }

  Future<void> logout() => FirebaseAuth.instance.signOut();
}
