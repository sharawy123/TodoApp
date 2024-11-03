import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/task_model.dart';

class FireBaseFunctions {
  static CollectionReference <TaskModel> getTasksCollection() => FirebaseFirestore.instance
      .collection('tasks')
      .withConverter<TaskModel>(
      fromFirestore: (docSnapshot,_)=>TaskModel.fromJson(docSnapshot.data()!),
      toFirestore: (taskmodel,_) => taskmodel.toJson(),
  );
  static Future<void> addtaskFireStore(TaskModel task){
    CollectionReference <TaskModel>  taskCollection  =  getTasksCollection();
    DocumentReference<TaskModel> doc =  taskCollection.doc();
    task.id=doc.id;
    return doc.set(task);
  }
  static Future<List<TaskModel>> getAlltasksFromFireStore() async{
    CollectionReference <TaskModel> tasksCollection =getTasksCollection();
     QuerySnapshot <TaskModel> querySnapshot  = await tasksCollection.get();
      return querySnapshot.docs.map((docSnapShot)=>docSnapShot.data()).toList();
  }
}
