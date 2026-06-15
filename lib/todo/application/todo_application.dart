import 'package:boilerplate_app/todo/application/todo_state.dart';
import 'package:boilerplate_app/todo/domain/todo_item.dart';
import 'package:boilerplate_app/todo/infrastructure/repositories/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoApplicationNotifier extends StateNotifier<TodoState> {
  late TodoRepository _repository;
  final StateController<List<TodoItem>> _todoItemController;
  TodoApplicationNotifier(this._repository, this._todoItemController)
      : super(const TodoState.initial());

  List<TodoItem> filterTodos(List<TodoItem> todos, String query) {
    if (query.isEmpty) return todos;
    final lowerQuery = query.toLowerCase();
    return todos.where((t) {
      return t.title.toLowerCase().contains(lowerQuery) ||
          (t.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  Future<void> loadTodos({bool showLoading = true}) async {
    if (showLoading) {
      state = const TodoState.loading();
    }

    final response = await _repository.getTodos();

    response.fold(
      (error) => state = TodoState.error(error),
      (todos) {
        _todoItemController.state = todos;
        state = TodoState.success(todos);
      },
    );
  }

  Future<void> addTodo(String title, String? description) async {
    final todo = TodoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final response = await _repository.addTodo(todo);

    response.fold(
      (error) => state = TodoState.error(error),
      (_) => loadTodos(showLoading: false),
    );
  }

  Future<void> toggleTodo(String id) async {
    state.maybeMap(
      success: (current) {
        final todo = current.todos.firstWhere((t) => t.id == id);
        final updated = todo.copyWith(
          isCompleted: !todo.isCompleted,
          updatedAt: DateTime.now(),
        );
        _repository.updateTodo(updated);
        state = TodoState.success(
          current.todos.map((t) => t.id == id ? updated : t).toList(),
        );
      },
      orElse: () {},
    );
  }

  Future<void> deleteTodo(String id) async {
    state.maybeMap(
      success: (current) {
        state =
            TodoState.success(current.todos.where((t) => t.id != id).toList());
        _repository.deleteTodo(id);
      },
      orElse: () {},
    );
  }
}
