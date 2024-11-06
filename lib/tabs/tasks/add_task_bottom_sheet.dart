import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase_functions.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/tabs/tasks/tasks_provider.dart';
import 'package:to_do_app/widgets/def_elevated_button.dart';
import 'package:to_do_app/widgets/def_text_field.dart';

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
    TextStyle? titleMedStyle = Theme.of(context).textTheme.titleMedium;
    return Container(
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
              style: titleMedStyle?.copyWith(fontWeight: FontWeight.w500),
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
    );
  }

  void addTask() {
    TaskModel task = TaskModel(
      title: titleControlelr.text,
      description: descriptionControlelr.text,
      date: selectedDate,
    );
    FireBaseFunctions.addtaskFireStore(task).
    timeout(
        Duration(microseconds: 100),
        onTimeout:(){
      Navigator.of(context).pop();
      Provider.of<TaskProvider>(context,listen: false).getTasks();
    }).
    catchError((error) {
      print(error);
    });
  }
}
