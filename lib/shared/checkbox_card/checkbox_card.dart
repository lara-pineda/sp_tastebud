import 'package:flutter/material.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'checkbox_list_tile.dart';

class CheckboxCard extends StatefulWidget {
  final List<String> allChoices;
  final List<bool> initialSelections;
  final ValueChanged<List<bool>> onSelectionChanged;
  final String cardLabel;
  final List<String?>? infoTexts;

  const CheckboxCard({
    super.key,
    required this.allChoices,
    required this.initialSelections,
    required this.onSelectionChanged,
    required this.cardLabel,
    this.infoTexts,
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

  @override
  void didUpdateWidget(covariant CheckboxCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelections != widget.initialSelections) {
      setState(() {
        selectedValues = widget.initialSelections;
      });
    }
  }

  void _showFullList(
      BuildContext context, List<String> allChoices, String label,
      [infoTexts]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.cardLabel,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 12),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 9),
                    children: List.generate(
                      widget.allChoices.length,
                      (index) => CustomCheckboxListTile(
                        title: widget.allChoices[index],
                        initialValue: selectedValues[index],
                        infoText: infoTexts[index],
                        onChanged: (bool value) {
                          setState(() {
                            selectedValues[index] = value;
                          });
                          widget.onSelectionChanged(selectedValues);
                        },
                      ),
                    ),
                  ),
                ),
              ],
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
      margin: const EdgeInsets.only(left: 10),
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
                        infoText: widget.infoTexts != null &&
                                widget.infoTexts!.length > index
                            ? widget.infoTexts![index]
                            : null,
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
              color: AppColors.redColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.chevron_right, color: Colors.white, size: 30),
              onPressed: () => _showFullList(context, widget.allChoices,
                  widget.cardLabel, widget.infoTexts),
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
