import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase_functions.dart';
import 'package:to_do_app/tabs/settings/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_app/tabs/tasks/tasks_provider.dart';
import 'package:to_do_app/tabs/tasks/tasks_tab.dart';
import 'package:to_do_app/widgets/def_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../app_theme.dart';
import '../../auth/user_provider.dart';
import '../../models/task_model.dart';
import '../../widgets/def_elevated_button.dart';

class EditTask extends StatefulWidget {
  static const String routeName = '/edit';
  final TaskModel Task;

  EditTask(this.Task);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var formkey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Column(
      children: [
        Stack(children: [
          // AppBar background container
          Container(
            height: screenHeight * 0.16,
            color: AppTheme.primary,
            width: double.infinity,
          ),
          PositionedDirectional(
            start: 55,
            top: 6,
            child: SafeArea(
              child: Text(
                (AppLocalizations.of(context)!.todoList),
                // Adjust text as needed
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: settingsProvider.isDark
                          ? AppTheme.black
                          : AppTheme.white,
                      fontSize: 22,
                    ),
              ),
            ),
          ),

          PositionedDirectional(
              top: 25,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: settingsProvider.isDark
                      ? AppTheme.DarkNavColor
                      : AppTheme.white,
                ),
              ))
        ]),
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: 352,
            height: 617,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Shadow color
                    spreadRadius: 4,
                    blurRadius: 10, // Softness of shadow
                    offset: Offset(0, 4), // Position of shadow (x, y)
                  ),
                ],
                color: settingsProvider.isDark
                    ? AppTheme.DarkNavColor
                    : AppTheme.white,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      (AppLocalizations.of(context)!.edit),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: settingsProvider.isDark
                              ? AppTheme.white
                              : AppTheme.black),
                    ),
                    SizedBox(height: 52),
                    DefaultTextFormField(
                      hintText: (AppLocalizations.of(context)!.newtitle),
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.trim().length < 1) {
                          return "title can not be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    DefaultTextFormField(
                      hintText: (AppLocalizations.of(context)!.newdesc),
                      controller: descriptionController,
                      validator: (value) {
                        if (value == null || value.trim().length < 1) {
                          return "description can not be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    Text(
                      (AppLocalizations.of(context)!.selectnewdate),
                      style: TextStyle(
                          fontSize: 20,
                          color: settingsProvider.isDark
                              ? AppTheme.white
                              : AppTheme.black),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        DateTime? dateTime = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                          initialDate: selectedDate,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                        );
                        if (dateTime != null && selectedDate != dateTime) {
                          selectedDate = dateTime;
                          setState(() {});
                        }
                      },
                      child: Text(
                        dateFormat.format(selectedDate),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: settingsProvider.isDark
                                ? AppTheme.white
                                : AppTheme.LighttaskFormField),
                      ),
                    ),
                    SizedBox(height: 32),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 39),
                      child: defElevatedButton(
                        label: (AppLocalizations.of(context)!.savenew),
                        onPressedButton: () {
                          if (formkey.currentState!.validate()) {
                            editTask();
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                                msg: "pull to refresh ,Task Edited successfully",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 18.0);

                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }

  void editTask() {

      String userId =
          Provider.of<UserProvider>(context, listen: false).currUser!.id;
      TaskModel task = TaskModel(
        title: titleController.text,
        description: descriptionController.text,
        date: selectedDate,
      );
      FireBaseFunctions.editTask(userId, task, widget.Task.id,
              titleController.text, descriptionController.text, selectedDate)
          .timeout(Duration(milliseconds: 100), onTimeout: () {
        // Provider.of<TaskProvider>(context,listen: false).getTasks(userId);
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: "Something went wrong in editing task",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0);
      });

  }
}
