class Task {
  String title;
  bool isDone;
  List<Task> subtasks;

  Task({required this.title, this.isDone = false, this.subtasks = const []});
}
