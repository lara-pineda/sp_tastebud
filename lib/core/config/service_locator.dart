import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//BLoCs
import 'package:sp_tastebud/features/auth/bloc/auth_bloc.dart';
import 'package:sp_tastebud/features/user-profile/bloc/user_profile_bloc.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/bloc/search_recipe_bloc.dart';
import 'package:sp_tastebud/features/ingredients/bloc/ingredients_bloc.dart';

// services
import 'package:sp_tastebud/features/auth/data/auth_service.dart';
import 'package:sp_tastebud/features/user-profile/data/user_profile_services.dart';
import 'package:sp_tastebud/features/ingredients/data/ingredients_services.dart';

// repositories
import 'package:sp_tastebud/features/auth/data/user_repository.dart';
import 'package:sp_tastebud/features/user-profile/data/user_profile_repository.dart';
import 'package:sp_tastebud/features/ingredients/data/ingredients_repository.dart';
import 'package:sp_tastebud/features/recipe/search-recipe/data/search_repository.dart';

// instantiate get_it
final getIt = GetIt.instance;

void setupServices() {
  // Register Firebase products
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  // Register services
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt(), getIt()));
  getIt.registerLazySingleton<UserProfileService>(
      () => UserProfileService(getIt(), getIt()));
  getIt.registerLazySingleton<IngredientsService>(
      () => IngredientsService(getIt(), getIt()));
  getIt.registerLazySingleton<SearchRecipeRepository>(
      () => SearchRecipeRepository(getIt(), getIt()));

  // Register repositories
  getIt.registerFactory<UserRepository>(
      () => UserRepository(getIt<AuthService>()));
  getIt.registerFactory<UserProfileRepository>(
      () => UserProfileRepository(getIt<UserProfileService>()));
  getIt.registerFactory<IngredientsRepository>(
      () => IngredientsRepository(getIt<IngredientsService>()));

  // Register BLoCs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<UserRepository>()));
  getIt.registerFactory<UserProfileBloc>(
      () => UserProfileBloc(getIt<UserProfileRepository>()));
  getIt.registerFactory<IngredientsBloc>(
      () => IngredientsBloc(getIt<IngredientsRepository>()));
  getIt.registerFactory<SearchRecipeBloc>(
      () => SearchRecipeBloc(getIt<SearchRecipeRepository>()));
}
