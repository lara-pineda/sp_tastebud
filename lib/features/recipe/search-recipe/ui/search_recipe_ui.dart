import 'package:flutter/material.dart';
import 'package:sp_tastebud/core/utils/hex_to_color.dart';
import 'package:sp_tastebud/core/widgets/custom_dialog.dart';
import 'package:sp_tastebud/core/widgets/custom_search_bar.dart';
import 'package:sp_tastebud/shared/recipe_card/recipe_card.dart';

class SearchRecipe extends StatelessWidget {
  const SearchRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: <Widget>[
        // search bar
        const CustomSearchBar(),

        // sign in button
        SizedBox(
          width: (MediaQuery.of(context).size.width / 6) * 4.5,
          child: ElevatedButton(
            onPressed: () {
              openDialog(context, "Sample Title", "Lorem ipsum dolor sit amet");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: '#F06F6F'.toColor(),
              foregroundColor: const Color(0xFFF7EBE8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
            child: const Text("Click Me"),
          ),
        ),

        const SizedBox(height: 20),

        // // Sample recipe card
        // const Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     RecipeCard(),
        //     RecipeCard(),
        //   ],
        // ),

        Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.3),
                    scrollDirection: Axis.vertical,
                    physics: const PageScrollPhysics(),
                    shrinkWrap: true,
                    children:
                        List.generate(8, (index) => const RecipeCard())))),
      ]),
    );
  }
}
