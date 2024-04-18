import 'package:sp_tastebud/features/user-profile/data/user_profile_services.dart';

class UserProfileRepository {
  final UserProfileService _userProfileService;

  UserProfileRepository(this._userProfileService);

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    return await _userProfileService.getUserProfile(userId);
  }

  Future<void> saveUserProfile(
      String userId,
      List<String> dietPref,
      List<String> allergies,
      List<String> macronutrients,
      List<String> micronutrients) async {
    print("UserID 2:");
    print(userId);
    await _userProfileService.updateDietPref(userId, dietPref);
    await _userProfileService.updateAllergies(userId, allergies);
    await _userProfileService.updateMacronutrients(userId, macronutrients);
    await _userProfileService.updateDietPref(userId, micronutrients);
  }
}
