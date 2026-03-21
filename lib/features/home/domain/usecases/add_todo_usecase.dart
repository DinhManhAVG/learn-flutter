import 'package:injectable/injectable.dart';
import 'package:todo_app_flutter/features/home/domain/entities/todo_entity.dart';
import 'package:todo_app_flutter/features/home/domain/repositories/i_todo_repository.dart';

@injectable
class AddTodoUseCase {
  final ITodoRepository _repository;
  const AddTodoUseCase(this._repository);

  Future<TodoEntity> execute({
    required String userId,
    required String title,
    required String description,
  }) =>
      _repository.addTodo(
        userId: userId,
        title: title,
        description: description,
      );
}
