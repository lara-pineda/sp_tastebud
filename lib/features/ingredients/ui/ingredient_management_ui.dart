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
import '../bloc/ingredients_bloc.dart';

class IngredientManagement extends StatefulWidget {
  const IngredientManagement({super.key});

  @override
  State<IngredientManagement> createState() => _IngredientsState();
}

class _IngredientsState extends State<IngredientManagement> {
  // lists to hold selected options
  List<bool> selectedPantryEssentials = [];
  List<bool> selectedMeat = [];
  List<bool> selectedVegetablesAndGreens = [];
  List<bool> selectedFishAndPoultry = [];
  List<bool> selectedBaking = [];

  // lists to hold fetched data from firestore
  List<bool> initialPantryEssentials = [];
  List<bool> initialMeat = [];
  List<bool> initialVegetablesAndGreens = [];
  List<bool> initialFishAndPoultry = [];
  List<bool> initialBaking = [];

  // Track if changes are made
  final ValueNotifier<bool> _isModified = ValueNotifier<bool>(false);

  // Retrieve AuthBloc using GetIt
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();
  final IngredientsBloc _ingredientsBloc = GetIt.instance<IngredientsBloc>();

  @override
  void initState() {
    super.initState();

    // Load the user profile data when the widget is initialized
    _ingredientsBloc.add(LoadIngredients());
  }

  // These functions will be called whenever a checkbox state changes.
  void _onPantryEssentialsSelectionChanged(List<bool> newSelections) {
    selectedPantryEssentials = newSelections;
    _checkIfModified();
  }

  void _onMeatSelectionChanged(List<bool> newSelections) {
    selectedMeat = newSelections;
    _checkIfModified();
  }

  void _onVegetablesAndGreensSelectionChanged(List<bool> newSelections) {
    selectedVegetablesAndGreens = newSelections;
    _checkIfModified();
  }

  void _onFishAndPoultrySelectionChanged(List<bool> newSelections) {
    selectedFishAndPoultry = newSelections;
    _checkIfModified();
  }

  void _onBakingSelectionChanged(List<bool> newSelections) {
    selectedBaking = newSelections;
    _checkIfModified();
  }

  // Check if any changes have been made
  void _checkIfModified() {
    bool checkIsModified = !listEquals(
            selectedPantryEssentials, initialPantryEssentials) ||
        !listEquals(selectedMeat, initialMeat) ||
        !listEquals(selectedVegetablesAndGreens, initialVegetablesAndGreens) ||
        !listEquals(selectedFishAndPoultry, initialFishAndPoultry) ||
        !listEquals(selectedBaking, initialBaking);

    _isModified.value = checkIsModified;
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
  void _onSaveButtonPressed() {
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
    _ingredientsBloc.add(UpdateIngredients(updatedPantryEssentials, updatedMeat,
        updatedVegetables, updatedFishAndPoultry, updatedBaking));

    // Update initial values to reflect saved state
    initialPantryEssentials = List.from(selectedPantryEssentials);
    initialMeat = List.from(selectedMeat);
    initialVegetablesAndGreens = List.from(selectedVegetablesAndGreens);
    initialFishAndPoultry = List.from(selectedFishAndPoultry);
    initialBaking = List.from(selectedBaking);

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
        child: BlocListener<IngredientsBloc, IngredientsState>(
            bloc: _ingredientsBloc,
            listener: (context, state) {
              if (state is IngredientsUpdated) {
                _showSuccessDialog();
              } else if (state is IngredientsError) {
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
                  // If login is successful, proceed with IngredientsBloc
                  return BlocBuilder<IngredientsBloc, IngredientsState>(
                    builder: (context, ingredientsState) {
                      if (ingredientsState is IngredientsLoaded) {
                        // Use the state values to build your UI
                        return buildIngredientManagementUI(
                            ingredientsState.pantryEssentials,
                            ingredientsState.meat,
                            ingredientsState.vegetablesAndGreens,
                            ingredientsState.fishAndPoultry,
                            ingredientsState.baking);
                      } else if (ingredientsState is IngredientsUpdated) {
                        return buildIngredientManagementUI(
                            ingredientsState.pantryEssentials,
                            ingredientsState.meat,
                            ingredientsState.vegetablesAndGreens,
                            ingredientsState.fishAndPoultry,
                            ingredientsState.baking);
                      } else if (ingredientsState is IngredientsError) {
                        // Show error message if loading fails
                        return Text(ingredientsState.error);
                      }
                      // Show loading indicator while loading
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                }
              },
            )));
  }

  Widget buildIngredientManagementUI(
      List<dynamic> pantryEssentials,
      List<dynamic> meat,
      List<dynamic> vegetablesAndGreens,
      List<dynamic> fishAndPoultry,
      List<dynamic> baking) {
    // Map the selected options to boolean values
    initialPantryEssentials =
        mapOptionsToBoolean(pantryEssentials, Options.pantryEssentials);
    initialMeat = mapOptionsToBoolean(meat, Options.meat);
    initialVegetablesAndGreens =
        mapOptionsToBoolean(vegetablesAndGreens, Options.vegetablesAndGreens);
    initialFishAndPoultry =
        mapOptionsToBoolean(fishAndPoultry, Options.fishAndPoultry);
    initialBaking = mapOptionsToBoolean(baking, Options.baking);

    selectedPantryEssentials = List.from(initialPantryEssentials);
    selectedMeat = List.from(initialMeat);
    selectedVegetablesAndGreens = List.from(initialVegetablesAndGreens);
    selectedFishAndPoultry = List.from(initialFishAndPoultry);
    selectedBaking = List.from(initialBaking);

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
                      color: AppColors.purpleColor,
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
                      color: AppColors.purpleColor,
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
                      color: AppColors.purpleColor,
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
                      color: AppColors.purpleColor,
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
                      color: AppColors.purpleColor,
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
        child: ValueListenableBuilder<bool>(
          valueListenable: _isModified,
          builder: (context, isModified, child) {
            return FloatingActionButton(
              onPressed: isModified ? _handleConfirmSave : null,
              backgroundColor: isModified ? Colors.white : Colors.grey[100],
              elevation: 4,
              child: Icon(
                Icons.save_outlined,
                color: isModified ? Colors.black54 : Colors.grey[300],
              ),
            );
          },
        ),
      ),
    ]);
  }
}
