import 'package:flutter/material.dart';
import '../../firebase_functions.dart';
import '../../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  List<TaskModel> tasks = [];

  Future<void> getTasks() async {
    tasks = await FireBaseFunctions.getAlltasksFromFireStore();
    tasks = tasks
        .where((task) =>
            task.date.year == selectedDate.year &&
            task.date.month == selectedDate.month &&
            task.date.day == selectedDate.day)
        .toList();
    notifyListeners();
  }

  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}