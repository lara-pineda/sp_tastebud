import 'package:flutter/material.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialize all selections to false, assuming none are selected by default.
    selectedPantryEssentials =
        List.generate(Options.pantryEssentials.length, (_) => false);
    selectedMeat = List.generate(Options.meat.length, (_) => false);
    selectedVegetables = List.generate(Options.vegetables.length, (_) => false);
  }

  // This function will be called whenever a checkbox state changes.
  void _onPantryEssentialsSelectionChanged(List<bool> newSelections) {
    setState(() {
      selectedPantryEssentials = newSelections;
    });
  }

  void _onMeatSelectionChanged(List<bool> newSelections) {
    setState(() {
      selectedMeat = newSelections;
    });
  }

  void _onVegetablesSelectionChanged(List<bool> newSelections) {
    setState(() {
      selectedVegetables = newSelections;
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
    print(updatedPantryEssentials);
    print(updatedMeat);
    print(updatedVegetables);

    context.read<IngredientsBloc>().add(UpdateIngredients(
        updatedPantryEssentials, updatedMeat, updatedVegetables));
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsBloc = BlocProvider.of<IngredientsBloc>(context);

    return Padding(
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
                      color: Colors.black45),
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
                  onSelectionChanged: _onVegetablesSelectionChanged,
                ),
                SizedBox(height: (40.toVHLength).toPX()),
              ],
            ),
          ),
          BlocListener<IngredientsBloc, IngredientsState>(
            listener: (context, state) {
              if (state is IngredientsUpdated) {
                print("Update successful!");
              } else if (state is IngredientsError) {
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
