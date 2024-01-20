/*
{
  "memoId": 0,
  "author": "string",
  "title": "string",
  "content": "string",
  "createdDate": "2023-11-29T02:23:52.048Z",
  "modifiedDate": "2023-11-29T02:23:52.048Z",
  "deletable": true,
  "editable": true,
  "bookmarked": true
}
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';

part 'memo_model.g.dart';

@JsonSerializable()
class MemoModel extends BaseModel {
  final int memoId;
  final String author;
  final String title;
  final String content;
  final String createdDate;
  final String modifiedDate;
  final bool deletable;
  final bool editable;
  final bool bookmarked;

  MemoModel({
    required this.memoId,
    required this.author,
    required this.title,
    required this.content,
    required this.createdDate,
    required this.modifiedDate,
    required this.deletable,
    required this.editable,
    required this.bookmarked,
  });

  MemoModel copyWith({
    int? memoId,
    String? author,
    String? title,
    String? content,
    String? createdDate,
    String? modifiedDate,
    bool? deletable,
    bool? editable,
    bool? bookmarked,
  }) {
    return MemoModel(
      memoId: memoId ?? this.memoId,
      author: author ?? this.author,
      title: title ?? this.title,
      content: content ?? this.content,
      createdDate: createdDate ?? this.createdDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      deletable: deletable ?? this.deletable,
      editable: editable ?? this.editable,
      bookmarked: bookmarked ?? this.bookmarked,
    );
  }

  factory MemoModel.fromJson(Map<String, dynamic> json) =>
      _$MemoModelFromJson(json);
}

/*
{
  "content": [
    {
      "memoId": 0,
      "author": "string",
      "title": "string",
      "createdDate": "2023-11-29T02:45:00.374Z",
      "modifiedDate": "2023-11-29T02:45:00.374Z"
    }
  ],
  "pageNumber": 0,
  "totalElements": 0,
  "totalPages": 0,
  "last": true,
  "size": 0,
  "sort": {
    "empty": true,
    "sorted": true,
    "unsorted": true
  },
  "numberOfElements": 0,
  "first": true,
  "empty": true
}
 */

@JsonSerializable()
class MemoListModel {
  final int memoId;
  final String author;
  final String title;
  final String createdDate;
  final String modifiedDate;

  MemoListModel({
    required this.memoId,
    required this.author,
    required this.title,
    required this.createdDate,
    required this.modifiedDate,
  });

  factory MemoListModel.fromJson(Map<String, dynamic> json) =>
      _$MemoListModelFromJson(json);
}

@JsonSerializable()
class MemoList extends PaginationModel<MemoListModel> {
  @JsonKey(name: 'content')
  @override
  List<MemoListModel>? get data => super.data;

  MemoList(
      {required super.data,
      required super.pageNumber,
      required super.totalElements,
      required super.totalPages,
      required super.last,
      required super.size,
      required super.sort,
      required super.numberOfElements,
      required super.first,
      required super.empty});

  factory MemoList.fromJson(Map<String, dynamic> json) =>
      _$MemoListFromJson(json);
}
