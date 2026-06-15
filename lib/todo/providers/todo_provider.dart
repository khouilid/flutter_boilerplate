import 'package:boilerplate_app/todo/application/todo_application.dart';
import 'package:boilerplate_app/todo/application/todo_state.dart';
import 'package:boilerplate_app/todo/domain/todo_item.dart';
import 'package:boilerplate_app/todo/infrastructure/repositories/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoApplicationProvider =
    StateNotifierProvider<TodoApplicationNotifier, TodoState>((ref) {
  final repository = ref.watch(todoRepositoryProvider.notifier);
  return TodoApplicationNotifier(
      repository, ref.watch(todoStateProvider.notifier));
});

final todoStateProvider = StateProvider<List<TodoItem>>((ref) {
  return [];
});

final todoSearchQueryProvider = StateProvider<String>((ref) {
  return '';
});

final filteredTodoProvider = Provider<List<TodoItem>>((ref) {
  final todos = ref.watch(todoStateProvider);
  final searchQuery = ref.watch(todoSearchQueryProvider);
  final notifier = ref.watch(todoApplicationProvider.notifier);
  return notifier.filterTodos(todos, searchQuery);
});
