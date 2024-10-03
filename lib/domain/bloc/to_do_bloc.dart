import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskmaster/data/db/db_functions.dart';
import 'package:taskmaster/data/models/model.dart';

part 'to_do_event.dart';
part 'to_do_state.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  final TaskDb taskDb;
  List<ToDo> tasks = [];
  ToDoBloc(this.taskDb) : super(ToDoInitial()) {
    tasks = taskDb.getTasks();
    emit(ToDoLoaded(List.from(tasks)));

    on<CreateTask>((event, emit) {
      taskDb.addTask(event.task);
      tasks.add(event.task);
      emit(ToDoLoaded(List.from(tasks)));
    });
    on<DeleteTask>(
      (event, emit) {
        final index = tasks.indexOf(event.task);
        if (index != -1) {
          taskDb.deleteTask(index);
          tasks.removeAt(index);
          emit(ToDoLoaded(List.from(tasks)));
        }
      },
    );
    on<EditTask>(
      (event, emit) {
        final index = tasks.indexOf(event.task);
        if (index != -1) {
          taskDb.updateTask(index, event.task);
          tasks[index] = event.task;
          emit(ToDoLoaded(List.from(tasks)));
        } else {
          print('Not found so no editing');
        }
      },
    );
    on<SortTasksByPriority>(
      (event, emit) {
        tasks.sort(
          (a, b) => a.priority.index.compareTo(b.priority.index),
        );
        emit(ToDoLoaded(List.from(tasks)));
      },
    );
    on<SearchTasks>(
      (event, emit) {
        final filteredtasks = tasks
            .where((task) =>
                task.title.contains(event.keyword) ||
                task.description.contains(event.keyword))
            .toList();
        emit(ToDoLoaded(filteredtasks));
      },
    );
    on<UpdateTaskCompletion>(
      (event, emit) {
        final index = tasks.indexWhere(
          (task) =>
              task.title == event.task.title &&
              task.description == event.task.description,
        );
        if (index != -1) {
          tasks[index] =
              tasks[index].copyWith(completed: !tasks[index].completed);
        }
        emit(ToDoLoaded(List.from(tasks)));
      },
    );

    on<LoadTasks>(
      (event, emit) async {
        emit(ToDoLoading());
        tasks = taskDb.getTasks();
        emit(ToDoLoaded(List.from(tasks)));
      },
    );
  }
}
