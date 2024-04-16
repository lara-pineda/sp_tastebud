import 'package:flutter/material.dart';

import '../../../shared/checkbox_card/checkbox_card.dart';
import '../../../shared/checkbox_card/options.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<bool> selectedValues = [];

  @override
  void initState() {
    super.initState();
    // Initialize all selections to false, assuming none are selected by default.
    selectedValues =
        List.generate(Options.dietaryPreferences.length, (_) => false);
  }

  // This function will be called whenever a checkbox's state changes.
  void _onSelectionChanged(List<bool> newSelections) {
    setState(() {
      selectedValues = newSelections;
    });
    // Perform any additional actions with the updated selection states if needed
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      CheckboxCard(
        allChoices: Options.dietaryPreferences,
        onSelectionChanged: _onSelectionChanged,
      ),
      Expanded(
        child: ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: const Text('User Profile details'),
            subtitle: Text('$index'),
          );
        }),
      )
    ]));
  }
}
