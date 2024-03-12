import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo/appwrite/database_api.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final DatabaseAPI databaseAPI;
  TodoBloc(this.databaseAPI) : super(TodoInitial()) {
    on<TodoLoad>((event, emit) async {
      bool noException = true;
      late final DocumentList value;
      try {
        value = await databaseAPI.getTodo(
          userId: event.userId,
        );
      } catch (e) {
        print(e);
        emit(TodoLoadError(message: e.toString()));
        noException = false;
      } finally {
        if (noException) {
          emit(TodoLoadSuccess(todos: value.documents.cast<Document>()));
        }
      }
    });
    on<TodoAdd>((event, emit) async {
      bool noException = true;
      try {
        await databaseAPI.addTodo(
          message: event.message,
        );
      } catch (e) {
        print(e);
        emit(TodoAddError(message: e.toString()));
        noException = false;
      } finally {
        if (noException) {
          emit(TodoAddSuccess(message: 'Todo added successfully'));
        }
      }
    });
    on<TodoUpdate>((event, emit) async {
      bool noException = true;
      try {
        await databaseAPI.updateTodo(
          id: event.id,
          message: event.message,
          complete: event.isDone,
        );
      } catch (e) {
        print(e);
        emit(TodoUpdateError(message: e.toString()));
        noException = false;
      } finally {
        if (noException) {
          emit(TodoUpdateSuccess(message: 'Todo updated successfully'));
        }
      }
    });
    on<TodoDelete>((event, emit) async {
      bool noException = true;
      try {
        await databaseAPI.deleteTodo(
          id: event.id,
        );
      } catch (e) {
        print(e);
        emit(TodoDeleteError(message: e.toString()));
        noException = false;
      } finally {
        if (noException) {
          emit(TodoDeleteSuccess(message: 'Todo deleted successfully'));
        }
      }
    });
    on<TodoStatusChanged>((event, emit) async {
      bool noException = true;
      try {
        await databaseAPI.updateTodoComplete(
          id: event.id,
          complete: event.isDone,
        );
      } catch (e) {
        print(e);
        emit(TodoUpdateError(message: e.toString()));
        noException = false;
      } finally {
        if (noException) {
          emit(TodoUpdateSuccess(message: 'Todo updated successfully'));
        }
      }
    });
  }
}
