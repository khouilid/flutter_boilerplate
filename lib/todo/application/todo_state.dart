import 'package:boilerplate_app/core/domain/failure.dart';
import 'package:boilerplate_app/todo/domain/todo_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_state.freezed.dart';

@freezed
class TodoState with _$TodoState {
  const TodoState._();
  const factory TodoState.initial() = _Initial;
  const factory TodoState.loading() = _Loading;
  const factory TodoState.success(List<TodoItem> todos) = _Success;
  const factory TodoState.error(Failure failure) = _Error;
}
