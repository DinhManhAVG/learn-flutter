// Migrated to Clean Architecture + Cubit.
// The real implementation lives at:
//   features/home/presentation/pages/home_page.dart
//
// This file keeps [HomeScreen] as a thin alias so that existing imports
// in main_dashboard.dart continue to compile without changes.
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/features/home/presentation/pages/home_page.dart';

/// Backward-compatibility alias -> delegates to [HomePage].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const HomePage();
}
