import 'package:flutter/material.dart';

// import 'package:tastebud/shared/popup-card/fake_popup_data.dart';

import 'checkbox_list_tile.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  // Widget categoryItem(String item) {
  //   return Container(
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 5,
  //           height: 5,
  //           decoration: BoxDecoration(
  //             color: Colors.black87,
  //             borderRadius: BorderRadius.circular(2),
  //           ),
  //           child: Checkbox(
  //             value: value,
  //             onChanged: onChanged,
  //           )
  //         ),
  //         Text(
  //           item,
  //           style: const TextStyle(
  //             fontFamily: 'Inter',
  //             fontWeight: FontWeight.w400,
  //             fontSize: 14,
  //           ),
  //         )
  //       ],
  //     )
  //   );
  // }

  Widget expansionCard(context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Contents
            Expanded(
                child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 9),
                    scrollDirection: Axis.vertical,
                    physics: const PageScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                        10,
                        (index) => CustomCheckboxListTile(
                            title: 'Dummy', value: false)))),

            // Arrow to expand
            Container(
                width: 30,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.shade300,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      // Popup Card
      expansionCard(context),

      Expanded(
        child: ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: const Text('User Profile details'),
            subtitle: Text('$index'),
          );
        }),
      )
    ]));
  }
}

// import 'package:flutter/material.dart';
// import 'package:tastebud/core/widgets/hero_dialog_route.dart';
//
// import 'package:tastebud/shared/popup-card/fake_popup_data.dart';
// import 'package:tastebud/shared/popup-card/popup_card.dart';
//
//
// class UserProfile extends StatelessWidget {
//   const UserProfile({ super.key });
//
//   Widget _popupCardList( data ){
//     return Expanded(
//       child: ListView.builder(
//         itemCount: data.length,
//         padding: const EdgeInsets.all(16),
//         itemBuilder: (context, index) {
//           final _category = data[index];
//           return _CategoryCard(category: _category);
//           // final _todo = todos[index];
//           // return _TodoCard(todo: _todo);
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Column(
//             children: [
//               _popupCardList(fakeData),
//             ]
//         )
//     );
//   }
// }
//
// class _CategoryCard extends StatelessWidget {
//   const _CategoryCard({ super.key, required this.category });
//
//   final PopupCard category;
//
//   @override
//   Widget build(BuildContext context){
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           HeroDialogRoute(
//               builder: (context) => Center(
//                 child: _CategoryPopupCard (category: category),
//               ), settings: settings)
//         )
//       }
//     )
//   }
// }
