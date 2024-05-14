import 'package:flutter/material.dart';

class ViewCollectionPage extends StatelessWidget {
  // final String collectionType; // 'Saved' or 'Rejected'

  ViewCollectionPage({Key? key}) : super(key: key);

  // Dummy data for recipes. Replace these with your actual data fetching logic.
  final List<Map<String, String>> recipes = [
    {
      'title': 'Chocolate Cake',
      'source': 'Recipe Source',
      'imageUrl': 'path_to_image'
    },
    {
      'title': 'Vegetable Pasta',
      'source': 'Recipe Source',
      'imageUrl': 'path_to_image'
    },
    {
      'title': 'Grilled Cheese Sandwich',
      'source': 'Recipe Source',
      'imageUrl': 'path_to_image'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.asset(recipes[index]['imageUrl']!,
              fit: BoxFit
                  .cover), // Ensure you have a placeholder if the image is not available
          title: Text(recipes[index]['title']!),
          subtitle: Text(recipes[index]['source']!),
          onTap: () {
            // Navigation or further action can be handled here
            print("Recipe tapped: ${recipes[index]['title']}");
          },
        );
      },
    );
  }
}
