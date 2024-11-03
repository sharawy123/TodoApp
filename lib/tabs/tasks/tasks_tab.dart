import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/app_theme.dart';
import 'package:to_do_app/firebase_functions.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/tabs/tasks/task_item.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class TasksTab extends StatefulWidget {
  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  List <TaskModel> tasks = [];
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .sizeOf(context)
        .height;
    if(tasks.isEmpty){
      getTasks();
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: screenHeight * 0.16,
              color: AppTheme.primary,
              width: double.infinity,
            ),
            PositionedDirectional(
              start: 20,
              //  top: 45,
              child: SafeArea(
                child: Text(
                  "To Do List",
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppTheme.white, fontSize: 22),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: EasyInfiniteDateTimeLine(
                showTimelineHeader: false,
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                focusDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
                //activeColor: AppTheme.white,
                dayProps: EasyDayProps(
                    height: 79,
                    width: 58,
                    dayStructure: DayStructure.dayNumDayStr,
                    activeDayStyle: DayStyle(
                      decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      dayNumStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary),
                      dayStrStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary),
                    ),
                    inactiveDayStyle: DayStyle(
                      decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      //borderRadius: BorderRadius.all(Radius.circular(5)),
                      dayNumStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black),
                      dayStrStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black),
                    )),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 20),
            itemBuilder: (_, index) => TaskItem(tasks[index]),
            itemCount: tasks.length,
          ),
        ),
      ],
    );
  }

  Future <void> getTasks ()async{
    tasks = await FireBaseFunctions.getAlltasksFromFireStore();
    setState(() {

    });
  }
}
