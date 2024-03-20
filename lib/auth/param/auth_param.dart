import 'package:google_sign_in/google_sign_in.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

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

  static AuthParameter fromKakao({required User userProfile}){
    return AuthParameter(
      email: userProfile.kakaoAccount?.email ?? '',
      imageUrl: userProfile.kakaoAccount?.profile?.thumbnailImageUrl ?? '',
      name: userProfile.kakaoAccount?.profile?.nickname ?? '',
      nickName: userProfile.kakaoAccount?.profile?.nickname ?? '',
      oauth2Id: 'kakao_${userProfile.id}',
    );
  }
  static AuthParameter fromGoogle({required GoogleSignInAccount googleUser}){
    return AuthParameter(
      email: googleUser.email ?? '',
      imageUrl: googleUser.photoUrl ?? '',
      name: googleUser.displayName ?? '',
      nickName: googleUser.displayName ?? '',
      oauth2Id: 'google_${googleUser.id}',
    );
  }
  Map<String, dynamic> toJson() => _$AuthParameterToJson(this);
}
