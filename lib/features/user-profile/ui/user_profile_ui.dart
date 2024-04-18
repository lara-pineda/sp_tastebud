import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sp_tastebud/shared/checkbox_card/checkbox_card.dart';
import 'package:sp_tastebud/shared/checkbox_card/options.dart';
import '../bloc/user_profile_bloc.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<bool> selectedDietaryPreferences = [];
  List<bool> selectedAllergies = [];
  List<bool> selectedMacronutrients = [];
  List<bool> selectedMicronutrients = [];

  @override
  void initState() {
    super.initState();
    // Initialize all selections to false, assuming none are selected by default.
    selectedDietaryPreferences =
        List.generate(Options.dietaryPreferences.length, (_) => false);
    selectedAllergies = List.generate(Options.allergies.length, (_) => false);
    selectedMacronutrients =
        List.generate(Options.macronutrients.length, (_) => false);
    selectedMicronutrients =
        List.generate(Options.micronutrients.length, (_) => false);
  }

  // This function will be called whenever a checkbox state changes.
  void _onDietPrefSelectionChanged(List<bool> newSelections) {
    setState(() {
      selectedDietaryPreferences = newSelections;
    });
  }

  void _onAllergiesSelectionChanged(List<bool> newSelections) {
    setState(() {
      selectedAllergies = newSelections;
    });
  }

  void _onMacronutrientSelectionChanged(List<bool> newSelections) {
    setState(() {
      selectedMacronutrients = newSelections;
    });
  }

  void _onMicronutrientSelectionChanged(List<bool> newSelections) {
    setState(() {
      selectedMicronutrients = newSelections;
    });
  }

  // maps checked indices to option label in list
  List<String> getSelectedOptions(List<bool> selections, List<String> options) {
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
    print(updatedDietPref);
    print(updatedAllergies);
    print(updatedMacronutrients);
    print(updatedMicronutrients);

    context.read<UserProfileBloc>().add(UpdateUserProfile(updatedDietPref,
        updatedAllergies, updatedMacronutrients, updatedMicronutrients));
  }

  @override
  Widget build(BuildContext context) {
    final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(
                  'Dietary Preferences',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: (20.toVHLength).toPX()),
                CheckboxCard(
                  allChoices: Options.dietaryPreferences,
                  onSelectionChanged: _onDietPrefSelectionChanged,
                ),
                SizedBox(height: (40.toVHLength).toPX()),
                Text(
                  'Allergies',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: (20.toVHLength).toPX()),
                CheckboxCard(
                  allChoices: Options.allergies,
                  onSelectionChanged: _onAllergiesSelectionChanged,
                ),
                SizedBox(height: (40.toVHLength).toPX()),
                Text(
                  'Macronutrients',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: (20.toVHLength).toPX()),
                CheckboxCard(
                  allChoices: Options.macronutrients,
                  onSelectionChanged: _onMacronutrientSelectionChanged,
                ),
                SizedBox(height: (40.toVHLength).toPX()),
                Text(
                  'Micronutrients',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: (20.toVHLength).toPX()),
                CheckboxCard(
                  allChoices: Options.micronutrients,
                  onSelectionChanged: _onMicronutrientSelectionChanged,
                ),
              ],
            ),
          ),
          BlocListener<UserProfileBloc, UserProfileState>(
            listener: (context, state) {
              if (state is UserProfileUpdated) {
                print("Update successful!");
              } else if (state is UserProfileError) {
                print(state.error);
              }
            },
            child: Container(
                height: 0), // Placeholder or optional additional UI element
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
