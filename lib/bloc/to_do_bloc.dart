import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskmaster/model.dart';

part 'to_do_event.dart';
part 'to_do_state.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  List<ToDo> tasks = [];
  ToDoBloc() : super(ToDoInitial()) {
    on<CreateTask>((event, emit) {
      tasks.add(event.task);
      emit(ToDoLoaded(List.from(tasks)));
    });
    on<DeleteTask>(
      (event, emit) {
        tasks.removeWhere(
          (task) =>
              task.title == event.task.title &&
              task.dueDate == event.task.dueDate,
        );
        emit(ToDoLoaded(List.from(tasks)));
      },
    );
    on<EditTask>(
      (event, emit) {
        final index =
            tasks.indexWhere((task) => task.title == event.task.title);
        if (index != -1) {
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
        final updatedTasks = tasks.map(
          (task) {
            if (task.title == event.task.title &&
                task.description == event.task.description) {
              return task.copyWith(completed: event.completed);
            }
            return task;
          },
        ).toList();
        emit(ToDoLoaded(updatedTasks));
      },
    );
  }
}
