import 'package:flutter/material.dart';

class IngredientSubstitutesDialog extends StatelessWidget {
  final List<String> substitutes;
  final String message;

  const IngredientSubstitutesDialog({
    super.key,
    required this.substitutes,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Suggested Substitutes',
        style: TextStyle(
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: Colors.black87),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: substitutes.isNotEmpty
              ? substitutes
                  .map((substitute) => Text(
                        substitute,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                            color: Colors.black87),
                      ))
                  .toList()
              : [
                  Text(
                    message.isNotEmpty
                        ? message
                        : "No substitutes found for this ingredient.",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        color: Colors.black87),
                  )
                ],
        ),
      ),
    );
  }
}
