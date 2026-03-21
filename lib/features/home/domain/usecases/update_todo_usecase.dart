import 'package:injectable/injectable.dart';
import 'package:todo_app_flutter/features/home/domain/repositories/i_todo_repository.dart';

@injectable
class UpdateTodoUseCase {
  final ITodoRepository _repository;
  const UpdateTodoUseCase(this._repository);

  Future<void> execute({
    required String userId,
    required String id,
    required String title,
    required String description,
  }) =>
      _repository.updateTodo(
        userId: userId,
        id: id,
        title: title,
        description: description,
      );
}
