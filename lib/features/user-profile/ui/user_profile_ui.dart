import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/core/config/assets_path.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
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
    // BlocProvider.of<UserProfileBloc>(context).add(LoadUserProfile());
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

  // These functions will be called whenever a checkbox state changes.
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

  void _logout(BuildContext context) {
    _authBloc.add(LogoutRequested());
    context.go('/');
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
      bloc: _authBloc,
      builder: (context, AuthState loginState) {
        if (loginState is AuthFailure) {
          context.go('/');
          // Return error text if login fails
          return Text("User not logged in.");
        } else {
          // If login is successful, proceed with UserProfileBloc
          return BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (context, userProfileState) {
              if (userProfileState is UserProfileLoaded) {
                // Use the state values to build the UI
                _emailController.text =
                    userProfileState.email ?? ''; // Set the fetched email

                return buildUserProfileUI(userProfileState);
              } else if (userProfileState is UserProfileError) {
                // Show error message if loading fails
                return Text(userProfileState.error);
              } else if (userProfileState is UserProfileChangeEmailError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(userProfileState.error),
                    // backgroundColor: Colors.red,
                  ),
                );
              }
              // Fallback widget
              return Text("Page not found.");
            },
          );
        }
      },
    );
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
                            onPressed: () => _changeEmail(context),
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

  void _changeEmail(BuildContext context) {
    _userProfileBloc.add(ChangeEmail(
      _emailController.text,
      _newEmailController.text,
      _passwordController.text,
    ));
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
                        onPressed: () => _logout(context),
                        iconSize: 36,
                      ),
                    ],
                  ),

                  SizedBox(height: (20.toVHLength).toPX()),
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
                  SizedBox(height: (40.toVHLength).toPX()),
                ],
              ),
            ),
            // ElevatedButton(
            //   onPressed: () => _onSaveButtonPressed(context),
            //   child: Text('Save Changes'),
            //   style: ElevatedButton.styleFrom(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //   ),
            // ),
          ],
        ),
      ),

      // logout button on upper right
      // Positioned(
      //   top: 40,
      //   right: 20,
      //   child: IconButton(
      //     icon: Icon(Icons.logout),
      //     onPressed: () => _logout(context),
      //   ),
      // ),

      // save changes button on lower right
      Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton(
          onPressed: () => _onSaveButtonPressed(context),
          backgroundColor: Colors.white,
          elevation: 4,
          child: const Icon(
            Icons.save_outlined,
            color: Colors.black54,
          ),
        ),
      ),
    ]);
  }
}
