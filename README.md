# sp_tastebud

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



### Folder Structure

-   assets/
    -   images/
        -   icons/
    -   fonts/
-   test/
-   lib/
    (LAYOUT FIRST)
    -   data/ : only if may lib/presentation din para separate data and ui-related code
    -   config/
        -   routes/ : defines named routes for navigation
        -   themes/ : custom colors, typography, style
    -   models/ : data models that define the app's data structure
    -   pages/
        -   main-menu/
            -   sign-up/
            -   login/
        -   recipe-search/
        -   user-profile/
        -   recipe-view/
        -   recipe-collection/
        -   ingredient-management/
    -   services/ : API calls, business logic, database operations, etc.
    -   src/
    -   constants/
    -   utils/ : holds utility/helper functions shared across the app
    -   widgets/ : contains reusable custom widgets
    -   main.dart : entry point of app

    (FEATURE FIRST)
    - config/
    - constants/
    - features/
        - auth/
        - manage-ingredients/
            - ingredient_management_presenter.dart
            - ingredient_management_model.dart
            - ingredient_management_data.dart
        - manage-profile
        - manage-recipe-collection
        - manage-rejects
        - reviews
        - search-recipe
        - view-recipe
    - utils/
    - widgets/

features:

-   authentication
-   search recipe
-   sort recipe
-   substitute recipe
-   manage saved recipes
-   manage ingredients
-   manage personal info
-
-   manage equipments
-   manage rejected recipes
-   leave a review



HOW TO CREATE BLOC

import 'dart:async'
import 'package:flutter/material.dart';

class MyBloc {
// Define the sink and stream controllers
final \_myController = StreamController<String>();
Stream<String> get myStream => \_myController.stream;
Sink<String> get mySink => \_myController.sink;

    // Define the business logic
    void processEvent(String event) {
        String newState = 'Processed $event';
        mySink.add(newState);
    }
    
    // Dispose the controllers
    void dispose() {
        \_myController.close();
    }
};

CONNECTING THE BLOC TO UI

import 'package:flutter/material.dart'
import 'my_bloc.dart';

class MyPage extends StatefulWidget {
@override
\_MyPageState createState() => \_MyPageState();
}

class \_MyPageState extends State<MyPage> {
// Create a new instance of the BLoC
final MyBloc \_bloc = MyBloc();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('My App'),
            ),
            body: Center(
                child: StreamBuilder<String>(
                    stream: \_bloc.myStream,
                    builder: (context, snapshot) {
                        if (snapshot.hasData) {
                            return Text(snapshot.data);
                        } else {
                            return Text('No data');
                        }
                    },
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    \_bloc.processEvent('Button clicked');
                },
                child: Icon(Icons.add),
            ),
        );
    }

    @override
    void dispose() {
        // Dispose the BLoC
        \_bloc.dispose();
        super.dispose();
    }
};
