import 'package:flutter/material.dart';

class RecipeCollection extends StatelessWidget {
  const RecipeCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Expanded(
        child: ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: const Text('Saved recipe'),
            subtitle: Text('$index'),
          );
        }),
      )
    ]));
  }
}
