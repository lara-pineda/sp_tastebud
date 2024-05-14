import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/core/config/assets_path.dart';

import '../../auth/bloc/auth_bloc.dart';

class RecipeCollection extends StatelessWidget {
  RecipeCollection({super.key});

  // Retrieve AuthBloc using GetIt
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();

  void navigateToRecipePage(BuildContext context, String type) {
    String collectionType = type == 'Saved Recipes' ? 'saved' : 'rejected';

    print("collectionType: $collectionType");

    context.go('/recipe-collection/collection/$collectionType');
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
          return _buildCollectionScreen(context);
        }
      },
    );
  }

  Widget _buildCollectionScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: (50.toVHLength).toPX()),
          Text(
            'Collection',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.purpleColor),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: (20.toVHLength).toPX()),
          Container(
            height: 500,
            child: GridView.count(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 10, // Horizontal space between cards
              mainAxisSpacing:
                  20, // Vertical space between cards increased for text space
              childAspectRatio: 1.0 /
                  1.2, // Adjusted aspect ratio to accommodate text outside the card
              children:
                  <String>['Saved Recipes', 'Rejected Recipes'].map((title) {
                return GestureDetector(
                  onTap: () => navigateToRecipePage(context, title),
                  child: _buildRecipeCard(title),
                );
                return _buildRecipeCard(title);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecipeCard(String title) {
    String image =
        title == 'Saved Recipes' ? Assets.savedRecipe : Assets.rejectedRecipe;
    return Column(
      mainAxisSize:
          MainAxisSize.min, // Use the minimum space needed by the child widgets
      children: [
        Flexible(
          flex: 5, // Allocates 5 parts of the space to the image card
          child: Card(
            elevation: 10,
            shadowColor: Colors.grey.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1, // Allocates 1 part of the space to the text
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8, bottom: 4), // Space around the text
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
