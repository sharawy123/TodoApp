import 'package:flutter/material.dart';
import '../../firebase_functions.dart';
import '../../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  List<TaskModel> tasks = [];

  void changeSelectedDate(DateTime date,String userID) {
    selectedDate = date;
   getTasks(userID);
  }
  Future <void> updateTasks (String userid, TaskModel updateTask) async{
  await FireBaseFunctions.editTask(userid, updateTask);
  int indx = tasks.indexWhere((tasks)=>tasks.id==updateTask.id);
  tasks[indx] = updateTask;
  notifyListeners();
  }
  Future<void> getTasks(String userID) async {
    tasks = await FireBaseFunctions.getAlltasksFromFireStore(userID);
    tasks = tasks
        .where((task) =>
    task.date.year == selectedDate.year &&
        task.date.month == selectedDate.month &&
        task.date.day == selectedDate.day)
        .toList();
    notifyListeners();
  }
}