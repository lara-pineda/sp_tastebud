import 'package:flutter/material.dart';

class IngredientManagement extends StatelessWidget {
  const IngredientManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Expanded(
        child: ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: const Text('Ingredients here'),
            subtitle: Text('$index'),
          );
        }),
      )
    ]));
  }
}
