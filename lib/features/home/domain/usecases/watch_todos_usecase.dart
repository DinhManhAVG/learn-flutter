import 'package:injectable/injectable.dart';
import 'package:todo_app_flutter/features/home/domain/entities/todo_entity.dart';
import 'package:todo_app_flutter/features/home/domain/repositories/i_todo_repository.dart';

@injectable
class WatchTodosUseCase {
  final ITodoRepository _repository;
  const WatchTodosUseCase(this._repository);

  Stream<List<TodoEntity>> execute(String userId) =>
      _repository.watchTodos(userId);
}
