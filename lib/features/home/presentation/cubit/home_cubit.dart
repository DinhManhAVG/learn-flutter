import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app_flutter/features/home/domain/entities/todo_entity.dart';
import 'package:todo_app_flutter/features/home/domain/usecases/add_todo_usecase.dart';
import 'package:todo_app_flutter/features/home/domain/usecases/delete_todo_usecase.dart';
import 'package:todo_app_flutter/features/home/domain/usecases/toggle_todo_usecase.dart';
import 'package:todo_app_flutter/features/home/domain/usecases/update_todo_usecase.dart';
import 'package:todo_app_flutter/features/home/domain/usecases/watch_todos_usecase.dart';

// Generated – run `dart run build_runner build` to update.
part 'home_cubit.freezed.dart';
part 'home_state.dart';

/// Cubit that drives the Home (Todo list) screen.
///
/// Registered as [factory] so each visit to the tab gets a fresh instance.
@injectable
class HomeCubit extends Cubit<HomeState> {
  final WatchTodosUseCase _watchTodos;
  final AddTodoUseCase _addTodo;
  final ToggleTodoUseCase _toggleTodo;
  final UpdateTodoUseCase _updateTodo;
  final DeleteTodoUseCase _deleteTodo;
  final FirebaseAuth _auth;

  StreamSubscription<List<TodoEntity>>? _todosSubscription;

  HomeCubit(
    this._watchTodos,
    this._addTodo,
    this._toggleTodo,
    this._updateTodo,
    this._deleteTodo,
    this._auth,
  ) : super(const HomeState.initial());

  String? get _userId => _auth.currentUser?.uid;

  /// Starts listening to the Firestore stream for the current user's todos.
  void init() {
    final uid = _userId;
    if (uid == null) {
      emit(const HomeState.error('Chưa đăng nhập'));
      return;
    }
    emit(const HomeState.loading());
    _todosSubscription = _watchTodos.execute(uid).listen(
      (todos) => emit(HomeState.loaded(todos)),
      onError: (e) => emit(HomeState.error(e.toString())),
    );
  }

  Future<void> addTodo(String title, String description) async {
    final uid = _userId;
    if (uid == null) return;
    try {
      await _addTodo.execute(
        userId: uid,
        title: title,
        description: description,
      );
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  Future<void> toggleTodo(String id, bool isCompleted) async {
    final uid = _userId;
    if (uid == null) return;
    try {
      await _toggleTodo.execute(uid, id, isCompleted);
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  Future<void> updateTodo({
    required String id,
    required String title,
    required String description,
  }) async {
    final uid = _userId;
    if (uid == null) return;
    try {
      await _updateTodo.execute(
        userId: uid,
        id: id,
        title: title,
        description: description,
      );
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  Future<void> deleteTodo(String id) async {
    final uid = _userId;
    if (uid == null) return;
    try {
      await _deleteTodo.execute(uid, id);
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _todosSubscription?.cancel();
    return super.close();
  }
}

