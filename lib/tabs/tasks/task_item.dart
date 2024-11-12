import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/app_theme.dart';
import 'package:to_do_app/firebase_functions.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/tabs/settings/settings_provider.dart';
import 'package:to_do_app/tabs/tasks/tasks_provider.dart';

import '../../auth/user_provider.dart';

class TaskItem extends StatelessWidget {
  TaskItem(this.Task);

  TaskModel Task;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    SettingsProvider settingsProvider =Provider.of<SettingsProvider>(context);
    String userId =userProvider.currUser!.id;

    ThemeData theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                FireBaseFunctions.deleteTaskFromFirestore(Task.id,userId)
                    .timeout(
                  Duration(microseconds: 100),
                  onTimeout: () =>
                      Provider.of<TaskProvider>(context, listen: false)
                          .getTasks(userId),
                )
                    .catchError((_) {
                  Fluttertoast.showToast(
                      msg: "Something went wrong",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      //default
                      timeInSecForIosWeb: 5,
                      //for IOS and web
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 18.0);
                });
              },
              borderRadius: BorderRadius.circular(20),
              padding: EdgeInsets.zero,
              backgroundColor: AppTheme.red,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: settingsProvider.isDark?AppTheme.DarkNavColor:AppTheme.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(end: 12),
                    height: 62,
                    width: 4,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Task.title,
                        style: theme.textTheme.titleMedium!
                            .copyWith(color: theme.primaryColor),
                      ),
                      SizedBox(height: 4),
                      Text(
                        Task.description,
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Container(
                height: 34,
                width: 69,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(
                  Icons.check,
                  size: 32,
                  color: AppTheme.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


