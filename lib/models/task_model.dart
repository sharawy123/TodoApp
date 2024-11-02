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
}
