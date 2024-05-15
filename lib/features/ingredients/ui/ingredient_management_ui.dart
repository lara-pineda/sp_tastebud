import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/features/auth/bloc/auth_bloc.dart';
import 'package:sp_tastebud/shared/checkbox_card/checkbox_card.dart';
import 'package:sp_tastebud/shared/checkbox_card/options.dart';
import '../../../shared/custom_dialog.dart';
import '../bloc/ingredients_bloc.dart';

class IngredientManagement extends StatefulWidget {
  const IngredientManagement({super.key});

  @override
  State<IngredientManagement> createState() => _IngredientsState();
}

class _IngredientsState extends State<IngredientManagement> {
  List<bool> selectedPantryEssentials = [];
  List<bool> selectedMeat = [];
  List<bool> selectedVegetablesAndGreens = [];
  List<bool> selectedFishAndPoultry = [];
  List<bool> selectedBaking = [];

  // Retrieve AuthBloc using GetIt
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();

  @override
  void initState() {
    super.initState();

    // Load the user profile data when the widget is initialized
    BlocProvider.of<IngredientsBloc>(context).add(LoadIngredients());
  }

  // These functions will be called whenever a checkbox state changes.
  void _onPantryEssentialsSelectionChanged(List<bool> newSelections) {
    selectedPantryEssentials = newSelections;
  }

  void _onMeatSelectionChanged(List<bool> newSelections) {
    selectedMeat = newSelections;
  }

  void _onVegetablesAndGreensSelectionChanged(List<bool> newSelections) {
    selectedVegetablesAndGreens = newSelections;
  }

  void _onFishAndPoultrySelectionChanged(List<bool> newSelections) {
    selectedFishAndPoultry = newSelections;
  }

  void _onBakingSelectionChanged(List<bool> newSelections) {
    selectedBaking = newSelections;
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
      selectedVegetablesAndGreens,
      Options.vegetablesAndGreens,
    );

    final updatedFishAndPoultry = getSelectedOptions(
      selectedFishAndPoultry,
      Options.fishAndPoultry,
    );

    final updatedBaking = getSelectedOptions(
      selectedBaking,
      Options.baking,
    );

    // dependency injection
    context.read<IngredientsBloc>().add(UpdateIngredients(
        updatedPantryEssentials,
        updatedMeat,
        updatedVegetables,
        updatedFishAndPoultry,
        updatedBaking));
  }

  // Helper method to map selected options to boolean values
  List<bool> mapOptionsToBoolean(
      List<dynamic> selectedOptions, List<String> allOptions) {
    return allOptions
        .map((option) => selectedOptions.contains(option))
        .toList();
  }

  void _handleConfirmSave(BuildContext context) {
    const confirmationMessage =
        'Do you confirm to save the changes made for ingredient management page?';

    openDialog(
      context,
      'Confirmation',
      confirmationMessage,
      onConfirm: () => _onSaveButtonPressed(context),
    );
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
          // If login is successful, proceed with IngredientsBloc
          return BlocBuilder<IngredientsBloc, IngredientsState>(
            builder: (context, ingredientsState) {
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
    selectedVegetablesAndGreens = mapOptionsToBoolean(
        state.vegetablesAndGreens, Options.vegetablesAndGreens);
    selectedFishAndPoultry =
        mapOptionsToBoolean(state.fishAndPoultry, Options.fishAndPoultry);
    selectedBaking = mapOptionsToBoolean(state.baking, Options.baking);

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

                  // PANTRY ESSENTIALS
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
                    cardLabel: 'Pantry Essentials',
                  ),
                  SizedBox(height: (40.toVHLength).toPX()),

                  // MEAT
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
                    cardLabel: 'Meat',
                  ),
                  SizedBox(height: (40.toVHLength).toPX()),

                  // FISH AND POULTRY
                  Text(
                    'Fish and Poultry',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: (20.toVHLength).toPX()),
                  CheckboxCard(
                    allChoices: Options.fishAndPoultry,
                    initialSelections: selectedFishAndPoultry,
                    onSelectionChanged: _onFishAndPoultrySelectionChanged,
                    cardLabel: 'Fish and Poultry',
                  ),
                  SizedBox(height: (40.toVHLength).toPX()),

                  // VEGETABLES AND GREENS
                  Text(
                    'Vegetables and Greens',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: (20.toVHLength).toPX()),
                  CheckboxCard(
                    allChoices: Options.vegetablesAndGreens,
                    initialSelections: selectedVegetablesAndGreens,
                    onSelectionChanged: _onVegetablesAndGreensSelectionChanged,
                    cardLabel: 'Vegetables and Greens',
                  ),
                  SizedBox(height: (40.toVHLength).toPX()),

                  // BAKING
                  Text(
                    'Baking',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: (20.toVHLength).toPX()),
                  CheckboxCard(
                    allChoices: Options.baking,
                    initialSelections: selectedBaking,
                    onSelectionChanged: _onBakingSelectionChanged,
                    cardLabel: 'Baking',
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
        child: FloatingActionButton(
          onPressed: () => _handleConfirmSave(context),
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
