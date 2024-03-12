part of 'todo_bloc.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoSuccess extends TodoState {
  final String message;

  TodoSuccess({required this.message});
}

class TodoError extends TodoState {
  final String message;

  TodoError({required this.message});
}

class TodoLoadSuccess extends TodoState {
  final List<Document> todos;

  TodoLoadSuccess({required this.todos});
}

class TodoLoadError extends TodoState {
  final String message;

  TodoLoadError({required this.message});
}

class TodoAddSuccess extends TodoState {
  final String message;

  TodoAddSuccess({required this.message});
}

class TodoAddError extends TodoState {
  final String message;

  TodoAddError({required this.message});
}

class TodoUpdateSuccess extends TodoState {
  final String message;

  TodoUpdateSuccess({required this.message});
}

class TodoUpdateError extends TodoState {
  final String message;

  TodoUpdateError({required this.message});
}

class TodoDeleteSuccess extends TodoState {
  final String message;

  TodoDeleteSuccess({required this.message});
}

class TodoDeleteError extends TodoState {
  final String message;

  TodoDeleteError({required this.message});
}

class TodoStatusChangedSuccess extends TodoState {
  final String message;

  TodoStatusChangedSuccess({required this.message});
}

class TodoStatusChangedError extends TodoState {
  final String message;

  TodoStatusChangedError({required this.message});
}