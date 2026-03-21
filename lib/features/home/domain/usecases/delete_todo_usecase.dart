import 'package:injectable/injectable.dart';
import 'package:todo_app_flutter/features/home/domain/repositories/i_todo_repository.dart';

@injectable
class DeleteTodoUseCase {
  final ITodoRepository _repository;
  const DeleteTodoUseCase(this._repository);

  Future<void> execute(String userId, String id) =>
      _repository.deleteTodo(userId, id);
}
