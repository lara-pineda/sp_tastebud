import 'package:sp_tastebud/features/user-profile/data/user_profile_services.dart';

class UserProfileRepository {
  final UserProfileService _userProfileService;

  UserProfileRepository(this._userProfileService);

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    return await _userProfileService.getUserProfile(userId);
  }

  Future<void> saveUserProfile(
      String userId, List<String> selectedOptions) async {
    await _userProfileService.updateUserProfile(userId, selectedOptions);
  }
}
