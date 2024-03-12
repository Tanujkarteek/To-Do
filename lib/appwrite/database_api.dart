import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../constants/constants.dart';
import 'auth_api.dart';

class DatabaseAPI {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  final AuthAPI auth = AuthAPI();

  DatabaseAPI() {
    init();
  }

  init() {
    client
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
  }

  Future<DocumentList> getTodo({required String? userId}) {
    return databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_TODO,
      queries: [
        Query.equal('user_id', userId)
      ]
    );
  }

  Future<Document> addTodo({required String message}) {
    return databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_TODO,
        documentId: ID.unique(),
        data: {
          'text': message,
          'date': DateTime.now().toString(),
          'user_id': auth.userid,
          'complete': false
        });
  }

  Future<dynamic> deleteTodo({required String id}) {
    return databases.deleteDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_TODO,
        documentId: id);
  }

  Future<dynamic> updateTodo(
      {required String id, required String message, required bool complete}) {
    return databases.updateDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_TODO,
        documentId: id,
        data: {
          'text': message,
          'date': DateTime.now().toString(),
          'user_id': auth.userid,
          'complete': complete
        });
  }

  Future<dynamic> updateTodoComplete(
      {required String id, required bool complete}) {
    return databases.updateDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_TODO,
        documentId: id,
        data: {
          'complete': complete
        });
  }
}