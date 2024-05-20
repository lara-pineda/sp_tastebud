import 'package:flutter/material.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';

class CustomFilter extends StatefulWidget {
  final String category;
  final String tag;
  final List<String> options;
  final Set<String> selectedOptions;
  final Function(String, Set<String>) onFilterChanged;
  final Function(String) onFilterCleared;

  const CustomFilter({
    super.key,
    required this.category,
    required this.tag,
    required this.options,
    required this.selectedOptions,
    required this.onFilterChanged,
    required this.onFilterCleared,
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
    if (selectedOptions.contains(option)) {
      selectedOptions.remove(option);
    } else {
      selectedOptions.add(option);
    }
    widget.onFilterChanged(widget.tag, selectedOptions);
  }

  // Builds the option button for a filter
  Widget buildOptionButton(String option) {
    bool isSelected = selectedOptions.contains(option);
    return Padding(
      padding: const EdgeInsets.all(2.5),
      child: IntrinsicWidth(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? AppColors.orangeDisabledColor : null,
            foregroundColor:
                isSelected ? AppColors.orangeDarkerColor : Colors.black87,
            side: BorderSide(
                color:
                    isSelected ? AppColors.orangeDarkerColor : Colors.black87),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: TextStyle(fontSize: 14),
          ),
          onPressed: () {
            toggleOptionSelection(option);
          },
          child: Text(option),
        ),
      ),
    );
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
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Adjust the main axis size based on content
            children: [
              Text(
                widget.category,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.seaGreenColor,
                ),
              ),
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
              Wrap(
                spacing: 8.0, // Horizontal space between buttons
                runSpacing: 4.0, // Vertical space between buttons
                children: widget.options
                    .map((option) => buildOptionButton(option))
                    .toList(),
              ),
              Divider(),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.seaGreenColor,
                    ),
                    onPressed: () {
                      // Clear selected options for this category
                      widget.onFilterCleared(widget.tag);
                      Navigator.pop(context);
                    },
                    child:
                        Text('Clear Filters', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => showFilterOptions(context),
      style: selectedOptions.isNotEmpty
          ? OutlinedButton.styleFrom(
              backgroundColor: AppColors.pastelPinkColor,
              foregroundColor: AppColors.darkerPinkColor,
              side: BorderSide(
                color: AppColors.darkerPinkColor,
              ),
            )
          : OutlinedButton.styleFrom(
              foregroundColor: AppColors.darkerPinkColor,
              side: BorderSide(
                color: AppColors.darkerPinkColor,
              ),
            ),
      child: Text(widget.category),
    );
  }
}
