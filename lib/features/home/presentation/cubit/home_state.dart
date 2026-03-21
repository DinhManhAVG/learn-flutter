part of 'home_cubit.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;

  const factory HomeState.loading() = _Loading;

  /// Todo list for the current user successfully loaded/updated.
  const factory HomeState.loaded(List<TodoEntity> todos) = _Loaded;

  const factory HomeState.error(String message) = _Error;
}

