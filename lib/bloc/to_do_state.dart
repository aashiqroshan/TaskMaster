part of 'to_do_bloc.dart';

sealed class ToDoState extends Equatable {
  const ToDoState();

  @override
  List<Object> get props => [];
}

final class ToDoInitial extends ToDoState {}

class ToDoLoading extends ToDoState {}

class ToDoLoaded extends ToDoState {
  final List<ToDo> tasks;
  ToDoLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class ToDoError extends ToDoState {
  final String message;
  ToDoError(this.message);

  @override
  List<Object> get props => [message];
}
