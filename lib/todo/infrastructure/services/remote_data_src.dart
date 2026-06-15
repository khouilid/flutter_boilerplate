import 'package:boilerplate_app/core/infrastructure/helpers/remote_service_helper.dart';
import 'package:boilerplate_app/todo/infrastructure/DTO/todo_dto.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_data_src.g.dart';

List<TodoDto> todos = [
  TodoDto(
    id: '1',
    title: 'Buy groceries',
    description: 'Milk, Bread, Eggs',
    isCompleted: false,
    createdAt: DateTime.now().toString(),
    updatedAt: DateTime.now().toString(),
  ),
  TodoDto(
    id: '2',
    title: 'Walk the dog',
    description: null,
    isCompleted: true,
    createdAt: DateTime.now().toString(),
    updatedAt: DateTime.now().toString(),
  ),
];

@Riverpod()
class TodoApiService extends _$TodoApiService with RemoteServiceHelper {
  late Dio _dio;

  @override
  Future<void> build() async {
    // _dio = ref.watch(dioProvider);
  }

  Future<List<TodoDto>> getTodos() async {
    return todos;
    // return handleRemoteResponse(
    //   _dio.get('/todos'),
    //   (data) => (data as List).map((e) => TodoDto.fromJson(e)).toList(),
    // );
  }

  Future<TodoDto> addTodo(TodoDto todo) async {
    todos.add(todo);
    return todo;
    // return handleRemoteResponse(
    //   _dio.post('/todos', data: todo.toJson()),
    //   (data) => TodoDto.fromJson(data),
    // );
  }

  Future<TodoDto> updateTodo(TodoDto todo) async {
    todos.removeWhere((element) => element.id == todo.id);
    todos.add(todo);
    return todo;
    // return handleRemoteResponse(
    //   _dio.put('/todos/${todo.id}', data: todo.toJson()),
    //   (data) => TodoDto.fromJson(data),
    // );
  }

  Future<void> deleteTodo(String id) async {
    todos.removeWhere((element) => element.id == id);
    // return handleRemoteResponse(
    //   _dio.delete('/todos/$id'),
    // );
  }
}
