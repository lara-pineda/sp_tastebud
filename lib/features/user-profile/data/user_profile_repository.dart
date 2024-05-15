import 'package:sp_tastebud/features/user-profile/data/user_profile_services.dart';

class UserProfileRepository {
  final UserProfileService _userProfileService;

  UserProfileRepository(this._userProfileService);

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    return await _userProfileService.getUserProfile(userId);
  }

  Future<void> callChangeEmail(
      String currentEmail, String newEmail, String password) async {
    try {
      return await _userProfileService.changeEmail(
          currentEmail, newEmail, password);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> saveUserProfile(
      String userId,
      List<String> dietPref,
      List<String> allergies,
      List<String> macronutrients,
      List<String> micronutrients) async {
    await _userProfileService.updateDietPref(userId, dietPref);
    await _userProfileService.updateAllergies(userId, allergies);
    await _userProfileService.updateMacronutrients(userId, macronutrients);
    await _userProfileService.updateMicronutrients(userId, micronutrients);
  }
}
