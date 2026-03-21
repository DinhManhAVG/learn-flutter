import 'package:todo_app_flutter/features/home/domain/entities/todo_entity.dart';

/// Contract for persisting todo items per user.
abstract class ITodoRepository {
  /// Stream of all todos for [userId], ordered by creation date.
  Stream<List<TodoEntity>> watchTodos(String userId);

  /// Adds a new todo. Returns the created entity with its generated id.
  Future<TodoEntity> addTodo({
    required String userId,
    required String title,
    required String description,
  });

  /// Toggles the [isCompleted] flag of the todo with [id].
  Future<void> toggleTodo(String userId, String id, bool isCompleted);

  /// Replaces title and description of the todo with [id].
  Future<void> updateTodo({
    required String userId,
    required String id,
    required String title,
    required String description,
  });

  /// Permanently removes the todo with [id].
  Future<void> deleteTodo(String userId, String id);
}
