/*
{
  "projectId": 0,
  "title": "string",
  "content": "string"
}
 */
import 'package:json_annotation/json_annotation.dart';

part 'memo_param.g.dart';

@JsonSerializable()
class DefaultMemoParam {
  final int projectId;

  DefaultMemoParam({
    required this.projectId,
  });

  Map<String, dynamic> toJson() => _$DefaultMemoParamToJson(this);
}

@JsonSerializable()
class MemoParam extends DefaultMemoParam {
  final String title;
  final String content;

  MemoParam({
    required super.projectId,
    required this.title,
    required this.content,
  });

  @override
  Map<String, dynamic> toJson() => _$MemoParamToJson(this);
}

@JsonSerializable()
class DeleteMemoParam extends DefaultMemoParam {
  DeleteMemoParam({required super.projectId});
}

@JsonSerializable()
class BookmarkMemoParam extends DefaultMemoParam {
  BookmarkMemoParam({required super.projectId});
}
