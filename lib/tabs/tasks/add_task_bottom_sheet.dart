import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/app_theme.dart';
import 'package:to_do_app/firebase_functions.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/tabs/settings/settings_provider.dart';
import 'package:to_do_app/tabs/tasks/tasks_provider.dart';
import 'package:to_do_app/widgets/def_elevated_button.dart';
import 'package:to_do_app/widgets/def_text_field.dart';

import '../../auth/user_provider.dart';


class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController titleControlelr = TextEditingController();
  TextEditingController descriptionControlelr = TextEditingController();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =Provider.of<SettingsProvider>(context);
    TextStyle? titleMedStyle = Theme.of(context).textTheme.titleMedium;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String userId =Provider.of<UserProvider>(context,listen: false).currUser!.id;
    return Padding(
      padding: EdgeInsets.only(bottom:  MediaQuery.of(context).viewInsets.bottom),
      child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
        color: settingsProvider.isDark? AppTheme .DarkNavColor : AppTheme.white
      ),
        height: MediaQuery.sizeOf(context).height * 0.5,
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Add new task',
                style: titleMedStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              DefaultTextFormField(
                controller: titleControlelr,
                hintText: "Enter Task Title",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'title cannot be empty';
                  }
                },
              ),
              SizedBox(height: 16),
              DefaultTextFormField(
                controller: descriptionControlelr,
                hintText: "Enter Task Description",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'description cannot be empty';
                  }
                },
              ),
              SizedBox(height: 16),
              Text(
                'Select date',
                style: titleMedStyle?.copyWith(fontWeight: FontWeight.w500,color:
                settingsProvider.isDark? AppTheme.DarktaskFormField :AppTheme.black,
                ),
              ),
              SizedBox(height: 8),
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
                  style: TextStyle(color: settingsProvider.isDark? AppTheme.white :AppTheme.LighttaskFormField),

                ),
              ),
              SizedBox(height: 32),
              defElevatedButton(
                label: "ADD",
                onPressedButton: () {
                  if (formKey.currentState!.validate()) {
                    addTask();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTask() {
    String userId =Provider.of<UserProvider>(context,listen: false).currUser!.id;
    TaskModel task = TaskModel(
      title: titleControlelr.text,
      description: descriptionControlelr.text,
      date: selectedDate,
    );
    FireBaseFunctions.addtaskFireStore(task,userId).
    timeout(
        Duration(microseconds: 100),
        onTimeout:(){
      Navigator.of(context).pop();


      Provider.of<TaskProvider>(context,listen: false).getTasks(userId);
      Fluttertoast.showToast(
          msg: "Task added successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM, //default
          timeInSecForIosWeb: 5, //for IOS and web
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0
      );
    }).catchError((error)
    {
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM, //default
          timeInSecForIosWeb: 5, //for IOS and web
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0
      );
    });
  }
}
