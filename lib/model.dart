
import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 1)
class ToDo {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final bool completed;

  @HiveField(2)
  final Priority priority;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime dueDate;
  
  @HiveField(5)
  final DateTime? reminder;

  ToDo(
      {required this.title,
      required this.completed,
      required this.priority,
      required this.description,
      required this.dueDate,
      this.reminder});
}

enum Priority { normal, important, veryImportant }
