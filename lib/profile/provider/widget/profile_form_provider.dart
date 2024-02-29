import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/profile/provider/profile_provider.dart';
import 'package:pllcare/profile/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'profile_form_provider.g.dart';

class ProfileEdit {
  final bool contact;
  final bool role;
  final bool experience;

  ProfileEdit(
      {required this.contact, required this.role, required this.experience,});

  ProfileEdit copyWith({
    bool? contact,
    bool? role,
    bool? experience,
  }) {
    return ProfileEdit(
      contact: contact ?? this.contact,
      role: role ?? this.role,
      experience: experience ?? this.experience,);
  }
}

final profileContactFormProvider = StateProvider.family.autoDispose((ref, int memberId) {
  ref.read(profileContactProvider(memberId: memberId));
});