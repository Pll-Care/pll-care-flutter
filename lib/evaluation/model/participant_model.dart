import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/evaluation/model/midterm_model.dart';
part 'participant_model.g.dart';
@JsonSerializable()
class ParticipantModel {
  final int memberId;
  final String name;
  final String imageUrl;
  final List<BadgeModel> badgeDtos;
  final int finalEvalId;
  final bool me;

  ParticipantModel({
    required this.memberId,
    required this.name,
    required this.imageUrl,
    required this.badgeDtos,
    required this.finalEvalId,
    required this.me,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) => _$ParticipantModelFromJson(json);
}