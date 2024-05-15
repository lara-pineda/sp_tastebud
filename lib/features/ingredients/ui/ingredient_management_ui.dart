import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/features/auth/bloc/auth_bloc.dart';
import 'package:sp_tastebud/shared/checkbox_card/checkbox_card.dart';
import 'package:sp_tastebud/shared/checkbox_card/options.dart';
import '../bloc/ingredients_bloc.dart';

class IngredientManagement extends StatefulWidget {
  const IngredientManagement({super.key});

  @override
  State<IngredientManagement> createState() => _IngredientsState();
}

class _IngredientsState extends State<IngredientManagement> {
  List<bool> selectedPantryEssentials = [];
  List<bool> selectedMeat = [];
  List<bool> selectedVegetables = [];

  // Retrieve AuthBloc using GetIt
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();

  @override
  void initState() {
    super.initState();

    // Load the user profile data when the widget is initialized
    BlocProvider.of<IngredientsBloc>(context).add(LoadIngredients());
  }

  // This function will be called whenever a checkbox state changes.
  void _onPantryEssentialsSelectionChanged(List<bool> newSelections) {
    selectedPantryEssentials = newSelections;
  }

  void _onMeatSelectionChanged(List<bool> newSelections) {
    selectedMeat = newSelections;
  }

  void _onVegetablesSelectionChanged(List<bool> newSelections) {
    selectedVegetables = newSelections;
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
    final updatedPantryEssentials = getSelectedOptions(
      selectedPantryEssentials,
      Options.pantryEssentials,
    );

    final updatedMeat = getSelectedOptions(
      selectedMeat,
      Options.meat,
    );

    final updatedVegetables = getSelectedOptions(
      selectedVegetables,
      Options.vegetables,
    );

    // dependency injection
    context.read<IngredientsBloc>().add(UpdateIngredients(
        updatedPantryEssentials, updatedMeat, updatedVegetables));
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
          return BlocBuilder<IngredientsBloc, IngredientsState>(
            builder: (context, ingredientsState) {
              print(ingredientsState);

              if (ingredientsState is IngredientsLoaded) {
                // Use the state values to build your UI
                return buildIngredientManagementUI(ingredientsState);
              } else if (ingredientsState is IngredientsError) {
                // Show error message if loading fails
                return Text(ingredientsState.error);
              }
              // Show loading indicator while loading
              return CircularProgressIndicator();
            },
          );
        }
      },
    );
  }

  Widget buildIngredientManagementUI(IngredientsLoaded state) {
    // Map the selected options to boolean values
    selectedPantryEssentials =
        mapOptionsToBoolean(state.pantryEssentials, Options.pantryEssentials);
    selectedMeat = mapOptionsToBoolean(state.meat, Options.meat);
    selectedVegetables =
        mapOptionsToBoolean(state.vegetables, Options.vegetables);

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: (50.toVHLength).toPX()),
                  Text(
                    'Ingredients',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppColors.purpleColor),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: (20.toVHLength).toPX()),
                  Text(
                    'Pantry Essentials',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: (20.toVHLength).toPX()),
                  CheckboxCard(
                    allChoices: Options.pantryEssentials,
                    initialSelections: selectedPantryEssentials,
                    onSelectionChanged: _onPantryEssentialsSelectionChanged,
                  ),
                  SizedBox(height: (40.toVHLength).toPX()),
                  Text(
                    'Meat',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: (20.toVHLength).toPX()),
                  CheckboxCard(
                    allChoices: Options.meat,
                    initialSelections: selectedMeat,
                    onSelectionChanged: _onMeatSelectionChanged,
                  ),
                  SizedBox(height: (40.toVHLength).toPX()),
                  Text(
                    'Vegetables',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: (20.toVHLength).toPX()),
                  CheckboxCard(
                    allChoices: Options.vegetables,
                    initialSelections: selectedVegetables,
                    onSelectionChanged: _onVegetablesSelectionChanged,
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
            //     padding: EdgeInsets.symmetric(vertical: 20),
            //   ),
            // ),
          ],
        ),
      ),
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
