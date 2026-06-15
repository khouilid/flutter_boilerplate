import 'package:boilerplate_app/todo/application/todo_state.dart';
import 'package:boilerplate_app/todo/presentation/widgets/todo_input_dialog.dart';
import 'package:boilerplate_app/todo/presentation/widgets/todo_item_widget.dart';
import 'package:boilerplate_app/todo/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(todoApplicationProvider.notifier).loadTodos();
    });

    ref.listenManual<TodoState>(todoApplicationProvider, (previous, next) {
      next.maybeMap(
        error: (errorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${errorState.failure.message}')),
          );
        },
        orElse: () {},
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todoApplicationProvider);
    final searchQuery = ref.watch(todoSearchQueryProvider);
    final filtered = ref.watch(filteredTodoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        backgroundColor: Colors.transparent,
        elevation: 1,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search todos...',
              leading: const Icon(Icons.search),
              trailing: [
                if (searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(todoSearchQueryProvider.notifier).state = '';
                    },
                  ),
              ],
              onChanged: (value) {
                ref.read(todoSearchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: state.maybeMap(
              loading: (_) => const Center(child: Text('Loading...')),
              orElse: () {
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      searchQuery.isNotEmpty
                          ? 'No todos match your search'
                          : 'No todos yet. Add one!',
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(todoApplicationProvider.notifier).loadTodos(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final todo = filtered[index];
                      return TodoItemWidget(
                        todo: todo,
                        onToggle: () => ref
                            .read(todoApplicationProvider.notifier)
                            .toggleTodo(todo.id),
                        onDelete: () => ref
                            .read(todoApplicationProvider.notifier)
                            .deleteTodo(todo.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addTodo() async {
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (_) => const TodoInputDialog(),
    );

    if (result != null && mounted) {
      ref
          .read(todoApplicationProvider.notifier)
          .addTodo(result['title']!, result['description']);
    }
  }
}
