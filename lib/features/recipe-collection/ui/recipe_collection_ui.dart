import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../auth/bloc/auth_bloc.dart';

class RecipeCollection extends StatelessWidget {
  RecipeCollection({super.key});

  // Retrieve AuthBloc using GetIt
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();

  Widget _buildCollectionScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: (50.toVHLength).toPX()),
                Text(
                  'Collection',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.black45),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: (20.toVHLength).toPX()),

                // saved recipes
                InkWell(
                  // onTap: context.go(),
                  child: Card(
                    elevation: 4.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.emoji_food_beverage_outlined,
                            color: Colors.green),
                        // Expanded(
                        //   child: Image.asset(
                        //     thumbnailAsset,
                        //     fit: BoxFit.cover,  // Adjust based on your thumbnail style
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Saved Recipes"),
                        ),
                      ],
                    ),
                  ),
                ),

                // rejected recipes
                InkWell(
                  // onTap: context.go(),
                  child: Card(
                    elevation: 4.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.no_food_outlined, color: Colors.red),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Rejected Recipes"),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
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
          // If login is successful, proceed with UserProfileBloc
          return _buildCollectionScreen();
        }
      },
    );
  }
}
