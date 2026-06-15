import 'package:boilerplate_app/todo/domain/todo_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_dto.freezed.dart';
part 'todo_dto.g.dart';

@freezed
class TodoDto with _$TodoDto {
  const TodoDto._();

  @JsonSerializable()
  const factory TodoDto({
    @JsonKey(name: '_id') String? id,
    required String title,
    String? description,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _TodoDto;

  factory TodoDto.fromJson(Map<String, dynamic> json) =>
      _$TodoDtoFromJson(json);

  factory TodoDto.fromDomain(TodoItem todo) {
    return TodoDto(
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt:
          createdAt != null ? DateTime.parse(createdAt!) : DateTime.now(),
      updatedAt:
          updatedAt != null ? DateTime.parse(updatedAt!) : DateTime.now(),
    );
  }
}
