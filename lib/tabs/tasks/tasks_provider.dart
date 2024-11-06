import 'package:flutter/material.dart';

import '../../firebase_functions.dart';
import '../../models/task_model.dart';

class TaskProvider with ChangeNotifier{
  List <TaskModel> tasks = [];
  Future <void> getTasks ()async{
    tasks = await FireBaseFunctions.getAlltasksFromFireStore();
    notifyListeners();
  }

}