import 'package:json_annotation/json_annotation.dart';

part 'default_model.g.dart';

abstract class BaseModel {}

class LoadingModel extends BaseModel {}

class ErrorModel extends BaseModel {}

class ListModel<T> extends BaseModel {
  List<T> data;

  ListModel({required this.data});
}

/*
{
  "content": [
    {
      "projectId": 0,
      "title": "string",
      "description": "string",
      "startDate": "2023-11-17",
      "endDate": "2023-11-17",
      "state": "TBD",
      "imageUrl": "string"
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
@JsonSerializable(
  genericArgumentFactories: true,
)
class PaginationModel<T> extends BaseModel {
  final List<T>? data;
  final int? pageNumber;
  final int? totalElements;
  final int? totalPages;
  final bool? last;
  final int? size;
  final PaginationSort? sort;
  final int? numberOfElements;
  final bool? first;
  final bool? empty;

  PaginationModel({
    required this.data,
    required this.pageNumber,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.size,
    required this.sort,
    required this.numberOfElements,
    required this.first,
    required this.empty,
  });

  factory PaginationModel.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$PaginationModelFromJson(json, fromJsonT);
  }
}

@JsonSerializable()
class PaginationSort {
  final bool empty;
  final bool sorted;
  final bool unsorted;

  PaginationSort({
    required this.empty,
    required this.sorted,
    required this.unsorted,
  });

  factory PaginationSort.fromJson(Map<String, dynamic> json) =>
      _$PaginationSortFromJson(json);
}
