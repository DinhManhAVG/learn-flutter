import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_flutter/core/di/injection.dart';
import 'package:todo_app_flutter/core/theme/app_colors.dart';
import 'package:todo_app_flutter/core/widgets/glass_card.dart';
import 'package:todo_app_flutter/features/home/domain/entities/todo_entity.dart';
import 'package:todo_app_flutter/features/home/presentation/cubit/home_cubit.dart';

/// Entry-point widget for the Home tab.
/// Owns the [BlocProvider] and starts the stream when first built.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..init(),
      child: const _HomeView(),
    );
  }
}

// ---------------------------------------------------------------------------
// Private view
// ---------------------------------------------------------------------------

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.backgroundGradient,
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accentBlue.withValues(alpha: 0.1),
                    AppColors.accentPurple.withValues(alpha: 0.1),
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _Header(isDark: isDark),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) => state.map(
                    initial: (_) => const SizedBox.shrink(),
                    loading: (_) => _LoadingView(isDark: isDark),
                    loaded: (s) => _TodoListView(
                      todos: s.todos,
                      isDark: isDark,
                    ),
                    error: (s) =>
                        _ErrorView(message: s.message, isDark: isDark),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditSheet(context),
        backgroundColor: AppColors.accentBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  final bool isDark;
  const _Header({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Todo List',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.textDark,
                  ),
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (_, curr) => curr.maybeMap(
                    loaded: (_) => true,
                    loading: (_) => true,
                    orElse: () => false,
                  ),
                  builder: (_, state) {
                    final count = state.maybeMap(
                      loaded: (s) =>
                          s.todos.where((t) => !t.isCompleted).length,
                      orElse: () => null,
                    );
                    return Text(
                      count == null
                          ? 'Loading...'
                          : '$count task${count == 1 ? '' : 's'} remaining',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondary
                            : Colors.grey.shade600,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Logout',
                          style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.logout,
              color: isDark ? AppColors.textSecondary : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient:
                  LinearGradient(colors: AppColors.accentGradient),
            ),
            child: const Icon(
              Icons.checklist_rtl,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading / Error / Empty views
// ---------------------------------------------------------------------------

class _LoadingView extends StatelessWidget {
  final bool isDark;
  const _LoadingView({required this.isDark});

  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.accentBlue : AppColors.accentPurple,
        ),
      );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final bool isDark;
  const _ErrorView({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 56, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                message,
                style: GoogleFonts.inter(
                  color: isDark
                      ? AppColors.textSecondary
                      : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

class _EmptyView extends StatelessWidget {
  final bool isDark;
  const _EmptyView({required this.isDark});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 64,
              color: isDark
                  ? AppColors.textTertiary
                  : Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No tasks yet!\nTap + to add one.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: isDark
                    ? AppColors.textSecondary
                    : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
}

// ---------------------------------------------------------------------------
// Todo list
// ---------------------------------------------------------------------------

class _TodoListView extends StatelessWidget {
  final List<TodoEntity> todos;
  final bool isDark;
  const _TodoListView({required this.todos, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) return _EmptyView(isDark: isDark);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: todos.length,
      itemBuilder: (context, i) =>
          _TodoTile(todo: todos[i], isDark: isDark),
    );
  }
}

class _TodoTile extends StatelessWidget {
  final TodoEntity todo;
  final bool isDark;
  const _TodoTile({required this.todo, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final accent = isDark ? AppColors.accentBlue : AppColors.accentPurple;
    final textMain =
        isDark ? AppColors.textPrimary : AppColors.textDark;
    final textSub =
        isDark ? AppColors.textSecondary : Colors.grey.shade600;

    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline,
            color: Colors.white, size: 28),
      ),
      onDismissed: (_) => cubit.deleteTodo(todo.id),
      child: GestureDetector(
        onTap: () => _showAddEditSheet(context, todo: todo),
        child: GlassCard(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Circle checkbox
              GestureDetector(
                onTap: () =>
                    cubit.toggleTodo(todo.id, !todo.isCompleted),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: todo.isCompleted
                        ? accent
                        : Colors.transparent,
                    border: Border.all(
                      color: todo.isCompleted
                          ? accent
                          : (isDark
                              ? AppColors.textTertiary
                              : Colors.grey.shade400),
                      width: 2,
                    ),
                  ),
                  child: todo.isCompleted
                      ? const Icon(Icons.check,
                          size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              // Title & description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color:
                            todo.isCompleted ? textSub : textMain,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (todo.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        todo.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: textSub),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: textSub, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Add / Edit bottom sheet  (stateful – owns TextEditingControllers)
// ---------------------------------------------------------------------------

void _showAddEditSheet(BuildContext context, {TodoEntity? todo}) {
  final cubit = context.read<HomeCubit>();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddEditSheet(cubit: cubit, todo: todo),
  );
}

class _AddEditSheet extends StatefulWidget {
  final HomeCubit cubit;
  final TodoEntity? todo;
  const _AddEditSheet({required this.cubit, this.todo});

  @override
  State<_AddEditSheet> createState() => _AddEditSheetState();
}

class _AddEditSheetState extends State<_AddEditSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl =
        TextEditingController(text: widget.todo?.title ?? '');
    _descCtrl =
        TextEditingController(text: widget.todo?.description ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    setState(() => _saving = true);

    if (widget.todo == null) {
      await widget.cubit
          .addTodo(title, _descCtrl.text.trim());
    } else {
      await widget.cubit.updateTodo(
        id: widget.todo!.id,
        title: title,
        description: _descCtrl.text.trim(),
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final sheetBg =
        isDark ? AppColors.primaryDark : Colors.white;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.textTertiary
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              widget.todo == null ? 'Add Task' : 'Edit Task',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleCtrl,
              autofocus: true,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.textDark,
              ),
              decoration: InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.textDark,
              ),
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        widget.todo == null
                            ? 'Add Task'
                            : 'Save Changes',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
