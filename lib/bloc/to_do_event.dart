part of 'to_do_bloc.dart';

sealed class ToDoEvent extends Equatable {
  const ToDoEvent();

  @override
  List<Object> get props => [];
}

class CreateTask extends ToDoEvent {
  final ToDo task;
  CreateTask(this.task);
}

class DeleteTask extends ToDoEvent {
  final ToDo taskId;
  DeleteTask(this.taskId);
}

class EditTask extends ToDoEvent {
  final ToDo task;
  EditTask(this.task);
}

class SortTasksByPriority extends ToDoEvent {}

class SearchTasks extends ToDoEvent {
  final String keyword;
  SearchTasks(this.keyword);
}
