import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void openDialog(BuildContext context, String windowTitle, String content,
    {required VoidCallback onConfirm}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      title: Text(windowTitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          )),
      content: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(content),
            ],
          ),
        ),
      ),

      // Buttons
      actions: [
        // Cancel Button
        TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            overlayColor:
                MaterialStatePropertyAll(Colors.grey.withOpacity(0.15)),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),

        // Confirm Button
        TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            overlayColor:
                MaterialStatePropertyAll(Colors.grey.withOpacity(0.15)),
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
