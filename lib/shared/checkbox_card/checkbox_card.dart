import 'package:flutter/material.dart';
import 'checkbox_list_tile.dart';

class CheckboxCard extends StatefulWidget {
  final List<String> allChoices;
  final List<bool> initialSelections;
  final ValueChanged<List<bool>> onSelectionChanged;

  const CheckboxCard({
    super.key,
    required this.allChoices,
    required this.initialSelections,
    required this.onSelectionChanged,
  });

  @override
  State<CheckboxCard> createState() => _CheckboxCardState();
}

class _CheckboxCardState extends State<CheckboxCard> {
  late List<bool> selectedValues;

  @override
  void initState() {
    super.initState();

    selectedValues = widget.initialSelections;
  }

  // @override
  // void didUpdateWidget(covariant CheckboxCard oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // Check if the list of choices has changed
  //   if (oldWidget.allChoices != widget.allChoices) {
  //     // Update selectedValues to match new list length and preserve current selections
  //     selectedValues = List.generate(
  //       widget.allChoices.length,
  //       (index) =>
  //           index < selectedValues.length ? selectedValues[index] : false,
  //     );
  //   }
  // }
  @override
  void didUpdateWidget(covariant CheckboxCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelections != widget.initialSelections) {
      setState(() {
        selectedValues = widget.initialSelections;
      });
    }
  }

  void _showFullList(BuildContext context, List<String> allChoices) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: allChoices.length,
              itemBuilder: (context, index) {
                return CustomCheckboxListTile(
                  title: allChoices[index],
                  initialValue: false,
                  // This should be set based on the item's selection state
                  onChanged: (bool value) {
                    // Handle the change
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget expansionCard(BuildContext context) {
    int itemCount = widget.allChoices.length > 10
        ? 10
        : widget.allChoices.length; // Display up to 10 options

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch horizontally
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 9),
                    children: List.generate(
                      widget.allChoices.length > 10
                          ? 10
                          : widget
                              .allChoices.length, // Limit display to up to 10
                      (index) => CustomCheckboxListTile(
                        title: widget.allChoices[index], // choices to display
                        initialValue: selectedValues[index],
                        onChanged: (bool value) {
                          setState(() {
                            selectedValues[index] = value;
                            widget.onSelectionChanged(selectedValues);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.chevron_right, color: Colors.white, size: 30),
              onPressed: () => _showFullList(context, widget.allChoices),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      expansionCard(context),
    ]);
  }
}
