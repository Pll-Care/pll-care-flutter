import 'package:json_annotation/json_annotation.dart';

part 'auth_param.g.dart';

@JsonSerializable()
class AuthParameter {
  final String email;
  final String imageUrl;
  final String name;
  final String nickName;
  final String oauth2Id;

  AuthParameter({
    required this.email,
    required this.imageUrl,
    required this.name,
    required this.nickName,
    required this.oauth2Id,
  });

  Map<String, dynamic> toJson() => _$AuthParameterToJson(this);
}
