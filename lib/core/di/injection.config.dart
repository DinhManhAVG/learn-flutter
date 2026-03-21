// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:todo_app_flutter/core/di/modules/app_module.dart' as _i36;
import 'package:todo_app_flutter/features/home/data/repositories/todo_repository_impl.dart'
    as _i154;
import 'package:todo_app_flutter/features/home/domain/repositories/i_todo_repository.dart'
    as _i917;
import 'package:todo_app_flutter/features/home/domain/usecases/add_todo_usecase.dart'
    as _i161;
import 'package:todo_app_flutter/features/home/domain/usecases/delete_todo_usecase.dart'
    as _i851;
import 'package:todo_app_flutter/features/home/domain/usecases/toggle_todo_usecase.dart'
    as _i177;
import 'package:todo_app_flutter/features/home/domain/usecases/update_todo_usecase.dart'
    as _i130;
import 'package:todo_app_flutter/features/home/domain/usecases/watch_todos_usecase.dart'
    as _i55;
import 'package:todo_app_flutter/features/home/presentation/cubit/home_cubit.dart'
    as _i344;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i974.FirebaseFirestore>(() => appModule.firestore);
    gh.lazySingleton<_i59.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.factory<_i917.ITodoRepository>(
      () => _i154.TodoRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i161.AddTodoUseCase>(
      () => _i161.AddTodoUseCase(gh<_i917.ITodoRepository>()),
    );
    gh.factory<_i851.DeleteTodoUseCase>(
      () => _i851.DeleteTodoUseCase(gh<_i917.ITodoRepository>()),
    );
    gh.factory<_i177.ToggleTodoUseCase>(
      () => _i177.ToggleTodoUseCase(gh<_i917.ITodoRepository>()),
    );
    gh.factory<_i130.UpdateTodoUseCase>(
      () => _i130.UpdateTodoUseCase(gh<_i917.ITodoRepository>()),
    );
    gh.factory<_i55.WatchTodosUseCase>(
      () => _i55.WatchTodosUseCase(gh<_i917.ITodoRepository>()),
    );
    gh.factory<_i344.HomeCubit>(
      () => _i344.HomeCubit(
        gh<_i55.WatchTodosUseCase>(),
        gh<_i161.AddTodoUseCase>(),
        gh<_i177.ToggleTodoUseCase>(),
        gh<_i130.UpdateTodoUseCase>(),
        gh<_i851.DeleteTodoUseCase>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i36.AppModule {}
