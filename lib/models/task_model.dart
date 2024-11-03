import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String title, description, id;
  DateTime date;
  bool isDone;

  TaskModel({
    required this.title,
    required this.description,
    required this.date,
    this.id = '',
    this.isDone = false,
  });

  TaskModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            title: json['title'],
            date: (json['date'] as Timestamp).toDate(),
            description: json['description'],
            isDone: json['isDone']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'isDone': isDone,
      };
}
