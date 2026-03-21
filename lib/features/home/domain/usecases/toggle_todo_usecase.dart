import 'package:injectable/injectable.dart';
import 'package:todo_app_flutter/features/home/domain/repositories/i_todo_repository.dart';

@injectable
class ToggleTodoUseCase {
  final ITodoRepository _repository;
  const ToggleTodoUseCase(this._repository);

  Future<void> execute(String userId, String id, bool isCompleted) =>
      _repository.toggleTodo(userId, id, isCompleted);
}
