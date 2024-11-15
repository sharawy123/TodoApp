import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/app_theme.dart';
import 'package:to_do_app/firebase_functions.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/tabs/settings/settings_provider.dart';
import 'package:to_do_app/tabs/tasks/edit_task.dart';
import 'package:to_do_app/tabs/tasks/tasks_provider.dart';
import '../../auth/user_provider.dart';

class TaskItem extends StatefulWidget {
  TaskItem(this.Task);
  TaskModel Task;



  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    String userId = userProvider.currUser!.id;

    ThemeData theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditTask(widget.Task)),
                );
              },
              borderRadius: BorderRadius.circular(20),
              padding: EdgeInsets.zero,
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: 'Update',
            ),
            SlidableAction(
              onPressed: (_) {
                FireBaseFunctions.deleteTaskFromFirestore(
                    widget.Task.id, userId)
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
              label: 'delete',
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: settingsProvider.isDark
                ? AppTheme.DarkNavColor
                : AppTheme.white,
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
                      color: widget.Task.isDone
                          ? AppTheme.green
                          : theme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.Task.title,
                        style: theme.textTheme.titleMedium!.copyWith(
                            color: widget.Task.isDone
                                ? AppTheme.green
                                : theme.primaryColor),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.Task.description,
                        style: theme.textTheme.titleSmall!.copyWith(
                            color: widget.Task.isDone
                                ? AppTheme.green
                                : theme.primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              widget.Task.isDone
                  ? Text(
                      'Done!',
                      style: TextStyle(
                          color: AppTheme.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )
                  : Container(
                      height: 34,
                      width: 69,
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: IconButton(
                        // alignment: Alignment.center,
                        icon: Icon(
                          Icons.check,
                          size: 29,
                        ),
                        color: AppTheme.white,
                        padding: EdgeInsets.only(bottom: 1),
                        onPressed: () {
                          FireBaseFunctions.taskIsDone(
                              userId, widget.Task.id, widget.Task);

                          setState(() {});
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
