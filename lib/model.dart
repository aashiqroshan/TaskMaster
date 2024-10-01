class ToDo {
  final String title;
  final bool completed;
  final Priority priority;

  ToDo({required this.title,required this.completed,required this.priority});
}

enum Priority { normal, important, veryImportant }
