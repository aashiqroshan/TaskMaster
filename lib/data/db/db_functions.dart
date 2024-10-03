import 'package:hive/hive.dart';
import 'package:taskmaster/domain/bloc/to_do_bloc.dart';
import 'package:taskmaster/data/models/model.dart';

class TaskDb {
  final Box<ToDo> box = Hive.box<ToDo>('Box');

  // TaskDb(this.box);

  List<ToDo> getTasks() {
    return box.values.toList();
  }

  void addTask(ToDo task) {
    box.add(task);
    print('the data is added');
  }

  void updateTask(int index, ToDo task) {
    box.putAt(index, task);
  }

  void deleteTask(int index) {
    box.deleteAt(index);
  }
}
