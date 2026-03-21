import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Global service locator instance – use [getIt] everywhere in the app.
final getIt = GetIt.instance;

/// Called once in [main] before [runApp].
/// Triggers the injectable-generated [init] extension on [GetIt].
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
