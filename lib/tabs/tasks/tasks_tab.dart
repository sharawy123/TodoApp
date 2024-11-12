import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/app_theme.dart';
import 'package:to_do_app/auth/user_provider.dart';
import 'package:to_do_app/firebase_functions.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/tabs/tasks/task_item.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:to_do_app/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../settings/settings_provider.dart';


class TasksTab extends StatefulWidget {
  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  bool shouldGetTask =true;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .sizeOf(context)
        .height;

    TaskProvider tasksProvider =Provider.of<TaskProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    String userId =userProvider.currUser!.id;
    //tasksProvider .getTasks();
    if(shouldGetTask){
      tasksProvider.getTasks(userId);
      shouldGetTask=false;
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
                  AppLocalizations.of(context)!.todoList,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: settingsProvider.isDark?AppTheme.black:AppTheme.white, fontSize: 22),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: EasyInfiniteDateTimeLine(
                showTimelineHeader: false,
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                focusDate: tasksProvider.selectedDate,
                lastDate: DateTime.now().add(Duration(days: 365)),
                onDateChange: (selectedDate){
                  tasksProvider.changeSelectedDate(selectedDate,userId);
                  tasksProvider.getTasks(userId);
                },
                //activeColor: AppTheme.white,
                dayProps: EasyDayProps(
                    height: 79,
                    width: 58,
                    dayStructure: DayStructure.dayNumDayStr,
                    activeDayStyle: DayStyle(
                      decoration: BoxDecoration(
                          color: settingsProvider.isDark?AppTheme.DarkNavColor:AppTheme.white,
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
                          color: settingsProvider.isDark?AppTheme.DarkNavColor:AppTheme.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),

                      //borderRadius: BorderRadius.all(Radius.circular(5)),
                      dayNumStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: settingsProvider.isDark?AppTheme.white:AppTheme.DarkNavColor),
                      dayStrStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: settingsProvider.isDark?AppTheme.white:AppTheme.DarkNavColor),
                    ),
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                        color: settingsProvider.isDark?AppTheme.DarkNavColor:AppTheme.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),

                    //borderRadius: BorderRadius.all(Radius.circular(5)),
                    dayNumStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: settingsProvider.isDark?AppTheme.white:AppTheme.DarkNavColor),
                    dayStrStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: settingsProvider.isDark?AppTheme.white:AppTheme.DarkNavColor),
                  )

                ),

              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 20),
            itemBuilder: (_, index) => TaskItem(tasksProvider.tasks[index]),
            itemCount:tasksProvider.tasks.length,
          ),
        ),
      ],
    );
  }


}
