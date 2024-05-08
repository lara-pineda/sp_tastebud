import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:sp_tastebud/core/config/assets_path.dart';
import 'package:sp_tastebud/features/auth/bloc/auth_bloc.dart';
import 'package:sp_tastebud/shared/checkbox_card/checkbox_card.dart';
import 'package:sp_tastebud/shared/checkbox_card/options.dart';
import '../bloc/user_profile_bloc.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // used for updating user details
  List<bool> selectedDietaryPreferences = [];
  List<bool> selectedAllergies = [];
  List<bool> selectedMacronutrients = [];
  List<bool> selectedMicronutrients = [];

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load the initial value for the email controller here, if needed.
    _emailController.text = 'user@gmail.com'; // Placeholder email

    // Load the user profile data when the widget is initialized
    BlocProvider.of<UserProfileBloc>(context).add(LoadUserProfile());
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _emailController.dispose();
    super.dispose();
  }

  // This function will be called whenever a checkbox state changes.
  void _onDietPrefSelectionChanged(List<bool> newSelections) {
    selectedDietaryPreferences = newSelections;
  }

  void _onAllergiesSelectionChanged(List<bool> newSelections) {
    selectedAllergies = newSelections;
  }

  void _onMacronutrientSelectionChanged(List<bool> newSelections) {
    selectedMacronutrients = newSelections;
  }

  void _onMicronutrientSelectionChanged(List<bool> newSelections) {
    selectedMicronutrients = newSelections;
  }

  // maps checked indices to option label in list
  List<String> getSelectedOptions(List selections, List<String> options) {
    List<String> selectedOptions = [];

    for (int i = 0; i < selections.length; i++) {
      if (selections[i]) {
        selectedOptions.add(options[i]);
      }
    }

    return selectedOptions;
  }

  // handler for save button
  void _onSaveButtonPressed(BuildContext context) {
    final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);

    final updatedDietPref = getSelectedOptions(
      selectedDietaryPreferences,
      Options.dietaryPreferences,
    );

    final updatedAllergies = getSelectedOptions(
      selectedAllergies,
      Options.allergies,
    );

    final updatedMacronutrients = getSelectedOptions(
      selectedMacronutrients,
      Options.macronutrients,
    );

    final updatedMicronutrients = getSelectedOptions(
      selectedMicronutrients,
      Options.micronutrients,
    );

    // dependency injection
    userProfileBloc.add(UpdateUserProfile(updatedDietPref, updatedAllergies,
        updatedMacronutrients, updatedMicronutrients));
  }

  // Helper method to map selected options to boolean values
  List<bool> mapOptionsToBoolean(
      List<dynamic> selectedOptions, List<String> allOptions) {
    return allOptions
        .map((option) => selectedOptions.contains(option))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, loginState) {
        if (loginState is AuthFailure) {
          context.go('/');
          // Return error text if login fails
          return Text("User not logged in.");
        } else {
          // If login is successful, proceed with UserProfileBloc
          return BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (context, userProfileState) {
              if (userProfileState is UserProfileLoaded) {
                // Use the state values to build your UI
                return buildUserProfileUI(userProfileState);
              } else if (userProfileState is UserProfileError) {
                // Show error message if loading fails
                return Text(userProfileState.error);
              }
              // Show loading indicator while loading
              return Text("Page not found");
            },
          );
        }
      },
    );
  }

  Widget buildUserProfileUI(UserProfileLoaded state) {
    // Map the selected options to boolean values
    selectedDietaryPreferences = mapOptionsToBoolean(
        state.dietaryPreferences, Options.dietaryPreferences);
    selectedAllergies = mapOptionsToBoolean(state.allergies, Options.allergies);
    selectedMacronutrients =
        mapOptionsToBoolean(state.macronutrients, Options.macronutrients);
    selectedMicronutrients =
        mapOptionsToBoolean(state.micronutrients, Options.micronutrients);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: (30.toVHLength).toPX()),
                // Adding a section for the user profile icon and editable email
                Image.asset(
                  Assets.imagesDefaultProfile,
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: (20.toVHLength).toPX()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.edit),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      // Implement logic to save the email when form is saved
                    },
                  ),
                ),

                SizedBox(height: (30.toVHLength).toPX()),

                Text(
                  'Dietary Preferences',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: (20.toVHLength).toPX()),
                CheckboxCard(
                  allChoices: Options.dietaryPreferences,
                  initialSelections: selectedDietaryPreferences,
                  onSelectionChanged: _onDietPrefSelectionChanged,
                ),
                SizedBox(height: (40.toVHLength).toPX()),
                Text(
                  'Allergies',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: (20.toVHLength).toPX()),
                CheckboxCard(
                  allChoices: Options.allergies,
                  initialSelections: selectedAllergies,
                  onSelectionChanged: _onAllergiesSelectionChanged,
                ),
                SizedBox(height: (40.toVHLength).toPX()),
                Text(
                  'Macronutrients',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: (20.toVHLength).toPX()),
                CheckboxCard(
                  allChoices: Options.macronutrients,
                  initialSelections: selectedMacronutrients,
                  onSelectionChanged: _onMacronutrientSelectionChanged,
                ),
                SizedBox(height: (40.toVHLength).toPX()),
                Text(
                  'Micronutrients',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: (20.toVHLength).toPX()),
                CheckboxCard(
                  allChoices: Options.micronutrients,
                  initialSelections: selectedMicronutrients,
                  onSelectionChanged: _onMicronutrientSelectionChanged,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _onSaveButtonPressed(context),
            child: Text('Save Changes'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
