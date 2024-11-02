import 'package:flutter/material.dart';
import 'package:to_do_app/app_theme.dart';
import 'package:to_do_app/models/task_model.dart';

class TaskItem extends StatelessWidget {
  TaskItem(this.Task);
  TaskModel Task;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.white,
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
            child: Icon(Icons.check, size: 32, color: AppTheme.white,),
          )
        ],
      ),
    );
  }
}
