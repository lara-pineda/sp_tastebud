import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/features/auth/bloc/auth_bloc.dart';
import 'package:sp_tastebud/shared/checkbox_card/checkbox_card.dart';
import 'package:sp_tastebud/shared/checkbox_card/options.dart';
import 'package:sp_tastebud/shared/connectivity/connectivity_listener_widget.dart';
import 'package:sp_tastebud/shared/custom_dialog/custom_dialog.dart';
import '../bloc/user_profile_bloc.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // lists to hold selected options
  List<bool> selectedDietaryPreferences = [];
  List<bool> selectedAllergies = [];
  List<bool> selectedMacronutrients = [];
  List<bool> selectedMicronutrients = [];

  // lists to hold fetched data from firestore
  List<bool> initialDietaryPreferences = [];
  List<bool> initialAllergies = [];
  List<bool> initialMacronutrients = [];
  List<bool> initialMicronutrients = [];

  // Track if changes are made
  final ValueNotifier<bool> _isModified = ValueNotifier<bool>(false);

  // Retrieve blocs using GetIt
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();
  final UserProfileBloc _userProfileBloc = GetIt.instance<UserProfileBloc>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load the user profile data when the widget is initialized
    _userProfileBloc.add(LoadUserProfile());
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _emailController.dispose();
    _newEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handler for logout user
  void _logout() {
    _authBloc.add(LogoutRequested());
    // Trigger navigation outside the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/');
    });
  }

  // Handle change email functionality
  void _changeEmail() {
    _userProfileBloc.add(ChangeEmail(
      _emailController.text,
      _newEmailController.text,
      _passwordController.text,
    ));
  }

  // These functions will be called whenever a checkbox state changes.
  void _onDietPrefSelectionChanged(List<bool> newSelections) {
    selectedDietaryPreferences = newSelections;
    _checkIfModified();
  }

  void _onAllergiesSelectionChanged(List<bool> newSelections) {
    selectedAllergies = newSelections;
    _checkIfModified();
  }

  void _onMacronutrientSelectionChanged(List<bool> newSelections) {
    selectedMacronutrients = newSelections;
    _checkIfModified();
  }

  void _onMicronutrientSelectionChanged(List<bool> newSelections) {
    selectedMicronutrients = newSelections;
    _checkIfModified();
  }

  // Check if any changes have been made
  void _checkIfModified() {
    bool checkIsModified =
        !listEquals(selectedDietaryPreferences, initialDietaryPreferences) ||
            !listEquals(selectedAllergies, initialAllergies) ||
            !listEquals(selectedMacronutrients, initialMacronutrients) ||
            !listEquals(selectedMicronutrients, initialMicronutrients);

    _isModified.value = checkIsModified;
  }

  // Maps checked indices to option label in list
  List<String> getSelectedOptions(List selections, List<String> options) {
    List<String> selectedOptions = [];

    for (int i = 0; i < selections.length; i++) {
      if (selections[i]) {
        selectedOptions.add(options[i]);
      }
    }

    return selectedOptions;
  }

  // Handler for save button
  void _onSaveButtonPressed() {
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
    _userProfileBloc.add(UpdateUserProfile(updatedDietPref, updatedAllergies,
        updatedMacronutrients, updatedMicronutrients));

    // Update initial values to reflect saved state
    initialDietaryPreferences = List.from(selectedDietaryPreferences);
    initialAllergies = List.from(selectedAllergies);
    selectedMicronutrients = List.from(selectedMicronutrients);
    selectedMacronutrients = List.from(selectedMacronutrients);

    _isModified.value = false;
  }

  // Helper method to map selected options to boolean values
  List<bool> mapOptionsToBoolean(
      List<dynamic> selectedOptions, List<String> allOptions) {
    return allOptions
        .map((option) => selectedOptions.contains(option))
        .toList();
  }

  // Handler for confirming to save changes
  void _handleConfirmSave() {
    const confirmationMessage =
        'Do you confirm to save the changes made for user profile preferences?';

    openDialog(
      context,
      'Confirmation',
      confirmationMessage,
      onConfirm: () => _onSaveButtonPressed(),
      showCancelButton: true,
    );
  }

  // Method to show success dialog
  void _showSuccessDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openDialog(
        context,
        'Success',
        'Changes have been successfully saved!',
        onConfirm: () {},
        showCancelButton: false,
      );
    });
  }

  // Method to show error dialog
  void _showErrorDialog(String error) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openDialog(
        context,
        'Error',
        error,
        onConfirm: () {},
        showCancelButton: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityListenerWidget(
        child: BlocListener<UserProfileBloc, UserProfileState>(
            bloc: _userProfileBloc,
            listener: (context, state) {
              if (state is UserProfileUpdated) {
                _showSuccessDialog();
              } else if (state is UserProfileError) {
                _showErrorDialog(state.error);
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              bloc: _authBloc,
              builder: (context, AuthState loginState) {
                if (loginState is AuthFailure) {
                  // Trigger navigation outside the build phase
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.go('/');
                  });
                  // Return error text if login fails
                  return Text("User not logged in.");
                } else {
                  // If login is successful, proceed with UserProfileBloc
                  return BlocBuilder<UserProfileBloc, UserProfileState>(
                    builder: (context, userProfileState) {
                      if (userProfileState is UserProfileLoaded) {
                        // Use the state values to build the UI
                        _emailController.text = userProfileState.email ??
                            ''; // Set the fetched email

                        return buildUserProfileUI(
                            userProfileState.dietaryPreferences,
                            userProfileState.allergies,
                            userProfileState.macronutrients,
                            userProfileState.micronutrients);
                      } else if (userProfileState is UserProfileUpdated) {
                        _emailController.text = userProfileState.email ??
                            ''; // Set the fetched email

                        return buildUserProfileUI(
                            userProfileState.dietaryPreferences,
                            userProfileState.allergies,
                            userProfileState.macronutrients,
                            userProfileState.micronutrients);
                      } else if (userProfileState is UserProfileError) {
                        // Show error message if loading fails
                        return Text(userProfileState.error);
                      } else if (userProfileState
                          is UserProfileChangeEmailError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(userProfileState.error),
                          ),
                        );
                      }
                      // Fallback widget.
                      return Text("State is not as expected.");
                    },
                  );
                }
              },
            )));
  }

  Future<void> _showEditEmailBottomSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Make the bottom sheet scrollable
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    viewInsets: EdgeInsets.zero, // Remove the bottom inset
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom /
                            1.2 // Adjust padding based on the inset
                        ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Change Email Address',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                        SizedBox(height: (20.toVHLength).toPX()),
                        TextFormField(
                          controller: _newEmailController,
                          enableSuggestions: false,
                          autocorrect: false,
                          // keyboardType: TextInputType.none,
                          decoration: InputDecoration(
                            labelText: 'New Email Address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: (20.toVHLength).toPX()),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: (20.toVHLength).toPX()),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 6) * 4.5,
                          child: ElevatedButton(
                            onPressed: () => _changeEmail(),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.seaGreenColor,
                              foregroundColor: const Color(0xFFF7EBE8),
                            ),
                            child: Text('Change Email'),
                          ),
                        ),
                        SizedBox(height: (20.toVHLength).toPX()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildUserProfileUI(
      List<dynamic> dietaryPreferences,
      List<dynamic> allergies,
      List<dynamic> macronutrients,
      List<dynamic> micronutrients) {
    // Map the selected options to boolean values
    initialDietaryPreferences =
        mapOptionsToBoolean(dietaryPreferences, Options.dietaryPreferences);
    initialAllergies = mapOptionsToBoolean(allergies, Options.allergies);
    initialMacronutrients =
        mapOptionsToBoolean(macronutrients, Options.macronutrients);
    initialMicronutrients =
        mapOptionsToBoolean(micronutrients, Options.micronutrients);

    selectedDietaryPreferences = List.from(initialDietaryPreferences);
    selectedAllergies = List.from(initialAllergies);
    selectedMacronutrients = List.from(initialMacronutrients);
    selectedMicronutrients = List.from(initialMicronutrients);

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: (20.toVHLength).toPX()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // page title
                      Text(
                        'User Profile',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: AppColors.purpleColor),
                        textAlign: TextAlign.left,
                      ),

                      // logout button on upper right
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () => _logout(),
                        iconSize: 36,
                        color: AppColors.seaGreenColor,
                      ),
                    ],
                  ),

                  // SizedBox(height: (10.toVHLength).toPX()),
                  // // Adding a section for the user profile icon and editable email
                  // Image.asset(
                  //   Assets.imagesAppIcon,
                  //   width: 150,
                  //   height: 150,
                  //   fit: BoxFit.contain,
                  // ),

                  SizedBox(height: (30.toVHLength).toPX()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: _showEditEmailBottomSheet,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: (30.toVHLength).toPX()),

                  Text(
                    'Click on the circle next to an option to check the option.\n\nOptions with asterisks mean that you can click on it to see what the option means.\n\nYou may save your changes by clicking the button on the lower right.',
                    // 'Click on the circle next to an option to check the option.\n\nOptions with asterisks mean that you can click on it to see what the option means.\n\nClicking the save button on the lower right will save your changes if any changes have been made on the page.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: (30.toVHLength).toPX()),

                  // DIETARY PREFERENCES
                  Text(
                    'Dietary Preferences',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.purpleColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: (20.toVHLength).toPX()),
                  CheckboxCard(
                    allChoices: Options.dietaryPreferences,
                    initialSelections: selectedDietaryPreferences,
                    onSelectionChanged: _onDietPrefSelectionChanged,
                    infoTexts: Options.dietaryPreferencesInfoText,
                    cardLabel: 'Dietary Preferences',
                  ),

                  // ALLERGIES
                  SizedBox(height: (40.toVHLength).toPX()),
                  Text(
                    'Allergies',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.purpleColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: (20.toVHLength).toPX()),
                  CheckboxCard(
                    allChoices: Options.allergies,
                    initialSelections: selectedAllergies,
                    onSelectionChanged: _onAllergiesSelectionChanged,
                    infoTexts: Options.allergiesInfoText,
                    cardLabel: 'Allergies',
                  ),
                  SizedBox(height: (40.toVHLength).toPX()),

                  // MACRONUTRIENTS
                  Text(
                    'Macronutrients',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.purpleColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: (20.toVHLength).toPX()),
                  CheckboxCard(
                    allChoices: Options.macronutrients,
                    initialSelections: selectedMacronutrients,
                    onSelectionChanged: _onMacronutrientSelectionChanged,
                    cardLabel: 'Macronutrients',
                  ),
                  SizedBox(height: (40.toVHLength).toPX()),

                  // MICRONUTRIENTS
                  Text(
                    'Micronutrients',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.purpleColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: (20.toVHLength).toPX()),
                  CheckboxCard(
                    allChoices: Options.micronutrients,
                    initialSelections: selectedMicronutrients,
                    onSelectionChanged: _onMicronutrientSelectionChanged,
                    cardLabel: 'Micronutrients',
                  ),
                  SizedBox(height: (40.toVHLength).toPX()),
                ],
              ),
            ),
          ],
        ),
      ),
      // save changes button on lower right
      Positioned(
        bottom: 20,
        right: 20,
        child: ValueListenableBuilder<bool>(
          valueListenable: _isModified,
          builder: (context, isModified, child) {
            return FloatingActionButton(
              onPressed: isModified ? _handleConfirmSave : null,
              backgroundColor:
                  // isModified ? Colors.white : Colors.grey[100],
                  isModified ? AppColors.orangeDisabledColor : Colors.grey[100],
              elevation: 4,
              child: Icon(
                Icons.save_outlined,
                color:
                    // isModified ? Colors.black87 : Colors.grey[300],
                    isModified ? AppColors.orangeDarkerColor : Colors.grey[300],
              ),
            );
          },
        ),
      ),
    ]);
  }
}
