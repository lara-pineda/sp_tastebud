import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_tastebud/features/ingredients/data/ingredients_repository.dart';

part 'ingredients_event.dart';
part 'ingredients_state.dart';

class IngredientsBloc extends Bloc<IngredientsEvent, IngredientsState> {
  final IngredientsRepository _ingredientsRepository;

  IngredientsBloc(this._ingredientsRepository) : super(IngredientsInitial()) {
    on<LoadIngredients>(_onLoadIngredients);
    on<UpdateIngredients>(_onUpdateIngredients);
  }

  void _onLoadIngredients(
      LoadIngredients event, Emitter<IngredientsState> emit) async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(IngredientsError("User not logged in"));
      return;
    }

    try {
      var data = await _ingredientsRepository.fetchIngredients(userId);
      if (data != null) {
        var fetchPantryEssentials = data['pantryEssentials'] as List<dynamic>;
        var fetchMeat = data['meat'] as List<dynamic>;
        var fetchVegetablesAndGreens =
            data['vegetablesAndGreens'] as List<dynamic>;
        var fetchFishAndPoultry = data['fishAndPoultry'] as List<dynamic>;
        var fetchBaking = data['baking'] as List<dynamic>;

        print("fetchPantryEssentials: $fetchPantryEssentials");
        print("fetchMeat: $fetchMeat");
        print("fetchVegetablesAndGreens: $fetchVegetablesAndGreens");
        print("fetchFishAndPoultry: $fetchFishAndPoultry");
        print("fetchBaking: $fetchBaking");

        emit(IngredientsLoaded(fetchPantryEssentials, fetchMeat,
            fetchVegetablesAndGreens, fetchFishAndPoultry, fetchBaking));
      } else {
        // // No user data found, defaulting to all unchecked.
        // emit(IngredientsLoaded(
        //   List<bool>.filled(Options.pantryEssentials.length, false),
        //   List<bool>.filled(Options.meat.length, false),
        //   List<bool>.filled(Options.vegetables.length, false),

        // Return empty lists
        emit(IngredientsLoaded([], [], [], [], []));
      }
    } catch (e) {
      emit(IngredientsError(e.toString()));
    }
  }

  void _onUpdateIngredients(
      UpdateIngredients event, Emitter<IngredientsState> emit) async {
    var userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      emit(IngredientsError("User not logged in"));
      return;
    }
    try {
      await _ingredientsRepository.saveIngredients(
          userId,
          event.pantryEssentials,
          event.meat,
          event.vegetablesAndGreens,
          event.fishAndPoultry,
          event.baking);

      // load again after updating to firestore
      emit(IngredientsLoaded(event.pantryEssentials, event.meat,
          event.vegetablesAndGreens, event.fishAndPoultry, event.baking));
      // emit(IngredientsUpdated());
    } catch (e) {
      emit(IngredientsError(e.toString()));
    }
  }
}
