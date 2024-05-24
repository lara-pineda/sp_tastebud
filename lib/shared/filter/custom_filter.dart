import 'package:flutter/material.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';

class CustomFilter extends StatefulWidget {
  final String category;
  final String tag;
  final List<String> options;
  final Set<String> selectedOptions;
  final Function(String, Set<String>) onFilterChanged;
  final Function(String) onFilterCleared;
  final VoidCallback onApplyFilters;

  const CustomFilter({
    super.key,
    required this.category,
    required this.tag,
    required this.options,
    required this.selectedOptions,
    required this.onFilterChanged,
    required this.onFilterCleared,
    required this.onApplyFilters,
  });

  @override
  State<CustomFilter> createState() => _CustomFilterState();
}

class _CustomFilterState extends State<CustomFilter> {
  late Set<String> selectedOptions;

  @override
  void initState() {
    super.initState();
    selectedOptions = Set.from(widget.selectedOptions);
  }

  // Toggles the selection state of a filter option
  void toggleOptionSelection(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
      widget.onFilterChanged(widget.tag, selectedOptions);
    });
  }

  // Shows the filter options modal bottom sheet
  void showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // This makes the modal bottom sheet scrollable
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // Local state to manage the modal's state
        Set<String> localSelectedOptions = Set.from(selectedOptions);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Toggle selection within the modal's state
            void localToggleOptionSelection(String option) {
              setModalState(() {
                if (localSelectedOptions.contains(option)) {
                  localSelectedOptions.remove(option);
                } else {
                  localSelectedOptions.add(option);
                }
                // Update the parent state as well
                setState(() {
                  selectedOptions = Set.from(localSelectedOptions);
                });
                widget.onFilterChanged(widget.tag, localSelectedOptions);
              });
            }

            // Build the option button within the modal's state
            Widget buildLocalOptionButton(String option) {
              bool isSelected = localSelectedOptions.contains(option);
              return Padding(
                padding: const EdgeInsets.all(2.5),
                child: IntrinsicWidth(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          isSelected ? AppColors.orangeDisabledColor : null,
                      foregroundColor: isSelected
                          ? AppColors.orangeDarkerColor
                          : Colors.black87,
                      side: BorderSide(
                          color: isSelected
                              ? AppColors.orangeDarkerColor
                              : Colors.black87),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: TextStyle(fontSize: 13),
                    ),
                    onPressed: () {
                      localToggleOptionSelection(option);
                    },
                    child: Text(option),
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.category,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.seaGreenColor,
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(),
                  SizedBox(height: 5),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: widget.options
                        .map((option) => buildLocalOptionButton(option))
                        .toList(),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.seaGreenColor,
                        ),
                        onPressed: () {
                          setModalState(() {
                            localSelectedOptions.clear();
                          });
                          setState(() {
                            selectedOptions.clear();
                          });
                          widget.onFilterCleared(widget.tag);
                          Navigator.pop(context);
                        },
                        child: Text('Clear Filters',
                            style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // Call the callback function to apply filters when the modal is closed
      widget.onApplyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return selectedOptions.isNotEmpty
        ? ElevatedButton(
            onPressed: () => showFilterOptions(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pastelPinkColor,
              foregroundColor: AppColors.darkerPinkColor,
            ),
            child: Text(
              widget.category,
              style: TextStyle(fontSize: 14),
            ),
          )
        : OutlinedButton(
            onPressed: () => showFilterOptions(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.darkerPinkColor,
              side: BorderSide(
                color: AppColors.darkerPinkColor,
              ),
            ),
            child: Text(
              widget.category,
              style: TextStyle(fontSize: 14),
            ),
          );
  }
}
