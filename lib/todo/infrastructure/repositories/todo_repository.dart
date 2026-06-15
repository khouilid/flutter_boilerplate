import 'package:boilerplate_app/core/infrastructure/helpers/repository_helper.dart';
import 'package:boilerplate_app/todo/domain/todo_item.dart';
import 'package:boilerplate_app/todo/infrastructure/services/remote_data_src.dart';
import 'package:boilerplate_app/todo/infrastructure/DTO/todo_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_repository.g.dart';

@Riverpod()
class TodoRepository extends _$TodoRepository with RepositoryHelper {
  late TodoApiService _apiService;

  @override
  Future<void> build() async {
    _apiService = ref.read(todoApiServiceProvider.notifier);
  }

  FutureEitherFailureOr<List<TodoItem>> getTodos() async {
    return handleData(
      _apiService.getTodos(),
      (data) async => data.map((dto) => dto.toDomain()).toList(),
    );
  }

  FutureEitherFailureOr<TodoItem> addTodo(TodoItem todo) async {
    final dto = TodoDto.fromDomain(todo);
    return handleData(
      _apiService.addTodo(dto),
      (data) async => data.toDomain(),
    );
  }

  FutureEitherFailureOr<TodoItem> updateTodo(TodoItem todo) async {
    final dto = TodoDto.fromDomain(todo);
    return handleData(
      _apiService.updateTodo(dto),
      (data) async => data.toDomain(),
    );
  }

  FutureEitherFailureOr<void> deleteTodo(String id) async {
    return handleData(
      _apiService.deleteTodo(id),
      (data) async => data,
    );
  }
}
