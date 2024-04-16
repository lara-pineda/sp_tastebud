import 'package:flutter/material.dart';
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
  List<bool> selectedValues = [];

  @override
  void initState() {
    super.initState();
    // Initialize all selections to false, assuming none are selected by default.
    selectedValues =
        List.generate(Options.dietaryPreferences.length, (_) => false);
  }

  // This function will be called whenever a checkbox state changes.
  void _onSelectionChanged(List<bool> newSelections) {
    setState(() {
      selectedValues = newSelections;
    });
    // Perform any additional actions with the updated selection states if needed
  }

  void checkContext(BuildContext context) {
    print(context.widget.runtimeType); // Should give you the widget class
    print(context
        .findAncestorWidgetOfExactType<BlocProvider<UserProfileBloc>>()
        ?.runtimeType);
  }

  List<String> getSelectedOptions(List<bool> selections, List<String> options) {
    List<String> selectedOptions = [];

    for (int i = 0; i < selections.length; i++) {
      if (selections[i]) {
        selectedOptions.add(options[i]);
      }
    }

    return selectedOptions;
  }

  void _onSaveButtonPressed(BuildContext context) {
    final selectedNames = getSelectedOptions(
      selectedValues,
      Options.dietaryPreferences,
    );
    print(selectedNames);
    context.read<UserProfileBloc>().add(UpdateUserProfile(selectedNames));
  }

  @override
  Widget build(BuildContext context) {
    checkContext(context);

    final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);

    return Center(
        child: Column(children: [
      CheckboxCard(
        allChoices: Options.dietaryPreferences,
        onSelectionChanged: _onSelectionChanged,
      ),
      ElevatedButton(
        onPressed: () {
          _onSaveButtonPressed(context);
          // ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text("Update successful!")));
        },
        child: Text('Save Changes'),
      ),
      Expanded(
        child: ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: const Text('User Profile details'),
            subtitle: Text('$index'),
          );
        }),
      ),
      // Listen to state changes
      BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileUpdated) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Update successful!")));
          } else if (state is UserProfileError) {
            // Show error message
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        // placeholder, typically replaced by the whole widget
        child: Container(),
      )
    ]));
  }
}
