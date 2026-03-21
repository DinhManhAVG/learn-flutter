import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app_flutter/features/home/data/models/todo_model.dart';
import 'package:todo_app_flutter/features/home/domain/entities/todo_entity.dart';
import 'package:todo_app_flutter/features/home/domain/repositories/i_todo_repository.dart';

/// Stores todos under `users/{userId}/todos` in Firestore so each user's
/// data is isolated automatically.
@Injectable(as: ITodoRepository)
class TodoRepositoryImpl implements ITodoRepository {
  final FirebaseFirestore _firestore;

  const TodoRepositoryImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _firestore.collection('users').doc(userId).collection('todos');

  @override
  Stream<List<TodoEntity>> watchTodos(String userId) => _col(userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs
          .map((doc) => TodoModel.fromDoc(doc).toEntity())
          .toList());

  @override
  Future<TodoEntity> addTodo({
    required String userId,
    required String title,
    required String description,
  }) async {
    final ref = _col(userId).doc();
    final now = DateTime.now();
    await ref.set({
      'userId': userId,
      'title': title,
      'description': description,
      'isCompleted': false,
      'createdAt': Timestamp.fromDate(now),
    });
    return TodoEntity(
      id: ref.id,
      userId: userId,
      title: title,
      description: description,
      createdAt: now,
    );
  }

  @override
  Future<void> toggleTodo(String userId, String id, bool isCompleted) =>
      _col(userId).doc(id).update({'isCompleted': isCompleted});

  @override
  Future<void> updateTodo({
    required String userId,
    required String id,
    required String title,
    required String description,
  }) =>
      _col(userId)
          .doc(id)
          .update({'title': title, 'description': description});

  @override
  Future<void> deleteTodo(String userId, String id) =>
      _col(userId).doc(id).delete();
}
