part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class TodoLoad extends TodoEvent {
  final String? userId;

  TodoLoad({required this.userId});
}

class TodoAdd extends TodoEvent {
  final String message;

  TodoAdd(
      {required this.message});
}

class TodoUpdate extends TodoEvent {
  final String id;
  final String message;
  final bool isDone;

  TodoUpdate({required this.id, required this.message, required this.isDone});
}

class TodoDelete extends TodoEvent {
  final String id;

  TodoDelete({required this.id});
}

class TodoStatusChanged extends TodoEvent {
  final String id;
  final bool isDone;

  TodoStatusChanged({required this.id, required this.isDone});
}