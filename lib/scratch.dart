i get this error:

Handler: "onTap"
The following ProviderNotFoundException was thrown while handling a gesture:
Error: Could not find the correct Provider<UserProfileBloc> above this UserProfile Widget

This happens because you used a `BuildContext` that does not include the provider
of your choice. There are a few common scenarios:

- You added a new provider in your `main.dart` and performed a hot-reload.
To fix, perform a hot-restart.

- The provider you are trying to read is in a different route.

Providers are "scoped". So if you insert of provider inside a route, then
other routes will not be able to access that provider.

- You used a `BuildContext` that is an ancestor of the provider you are trying to read.

Make sure that UserProfile is under your MultiProvider/Provider<UserProfileBloc>.
This usually happens when you are creating a provider and trying to read it immediately.

For example, instead of:

```
Widget build(BuildContext context) {
  return Provider<Example>(
    create: (_) => Example(),
    // Will throw a ProviderNotFoundError, because `context` is associated
    // to the widget that is the parent of `Provider<Example>`
    child: Text(context.watch<Example>().toString()),
  );
}
```

consider using `builder` like so:

```
Widget build(BuildContext context) {
  return Provider<Example>(
      create: (_) => Example(),
      // we use `builder` to obtain a new `BuildContext` that has access to the provider
      builder: (context, child) {
        // No longer throws
        return Text(context.watch<Example>().toString());
      }
  );
}
```


> user_profile_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sp_tastebud/shared/checkbox_card/options.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final FirebaseFirestore _firestore;

  UserProfileBloc(this._firestore) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  // Fetch user profile from Firestore and emit LoadedUserProfile state
  void _onLoadUserProfile(
      LoadUserProfile event, Emitter<UserProfileState> emit) async {
    try {
      var snapshot = await _firestore.collection('users').doc('user_id').get();
      var data = snapshot.data();

      if (data != null && data.containsKey('dietaryPreferences')) {
        // Ensure the data exists and is in the expected format.
        var preferences =
        List<bool>.from(data['dietaryPreferences'] as List<dynamic>);
        emit(UserProfileLoaded(preferences));
      } else {
        // Handle the case where dietaryPreferences does not exist or data is null
        emit(UserProfileLoaded(
            List<bool>.filled(Options.dietaryPreferences.length, false)));
      }
    } catch (e) {
      // Handle any errors that might occur during fetching or processing data
      emit(UserProfileError(e.toString()));
      // Depending on your implementation, you might want to log this error or show a user-friendly message.
    }
  }

  // Update user profile in Firestore and emit UserProfileUpdated state
  void _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<UserProfileState> emit) async {
    await _firestore
        .collection('users')
        .doc('user_id')
        .update({'dietaryPreferences': event.dietaryPreferences});
    emit(UserProfileUpdated());
  }
}


> GoRouter for userprofile

GoRoute(
  name: "userProfile",
  path: "/profile",
  parentNavigatorKey: _shellNavigatorKey,
  builder: (context, state) {
    return BlocProvider<UserProfileBloc>(
      create: (context) =>
        UserProfileBloc(FirebaseFirestore.instance),
      child: UserProfile(),
    );
  },
),

> user_profile_ui.dart

update of profile must be done once a button is clicked, which is implemented below:

ElevatedButton(
  onPressed: () {
    // userProfileBloc.add(UpdateUserProfile(selectedValues));
  },
  child: Text('Save Changes'),
),


should i also add bloclistener/consumer in user_profile_ui.dart? thats what i did in my signup/login

// Listen to state changes
BlocListener<SignupBloc, SignupState>(
  listener: (context, state) {
    // If signup is successful, navigate to main menu
    if (state is SignupSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signup successful!")));
      context.go('/');

    // Signup failed
    } else if (state is SignupFailure) {
      // Show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.error)));
    }
  },
  // placeholder, typically replaced by the whole signup_ui widget
  child: Container(),
)