import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 1)
class ToDo {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final bool completed;

  @HiveField(2)
  final Prioritys priority;

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

  ToDo copyWith(
      {String? title,
      String? description,
      bool? completed,
      Prioritys? priority,
      DateTime? dueDate}) {
    return ToDo(
        title: title ?? this.title,
        completed: completed ?? this.completed,
        priority: priority ?? this.priority,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        reminder: reminder ?? this.reminder);
  }
}

enum Prioritys { normal, important, veryImportant }

class PrioritysAdapter extends TypeAdapter<Prioritys> {
  @override
  final int typeId = 2; // Unique ID for the adapter

  @override
  Prioritys read(BinaryReader reader) {
    // Read an integer and convert it back to the enum
    return Prioritys.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, Prioritys obj) {
    // Write the index of the enum
    writer.writeInt(obj.index);
  }
}
