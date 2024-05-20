import 'package:flutter/material.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'custom_checkbox_icon.dart';

class CustomCheckboxListTileModalSheet extends StatefulWidget {
  const CustomCheckboxListTileModalSheet({
    super.key,
    required this.title,
    required this.initialValue,
    this.infoText,
    this.onChanged,
  });

  final String title;
  final bool initialValue;
  final String? infoText;
  final ValueChanged<bool>? onChanged;

  @override
  State<CustomCheckboxListTileModalSheet> createState() =>
      _CustomCheckboxListTileStateModalSheet();
}

class _CustomCheckboxListTileStateModalSheet
    extends State<CustomCheckboxListTileModalSheet> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  void _onChanged(bool? newValue) {
    if (newValue != null) {
      setState(() {
        value = newValue;
        widget.onChanged?.call(value);
      });
    }
  }

  void _showInfoDialog(String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        title: Text(widget.title,
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
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconCheckbox(
          value: value,
          onChanged: (newValue) {
            _onChanged(newValue);
          },
        ),
        Expanded(
            child: Row(
          children: [
            widget.infoText != null
                ? GestureDetector(
                    onTap: () => _showInfoDialog(widget.infoText!),
                    child: RichText(
                      text: TextSpan(
                          // text: widget.title,
                          // style: TextStyle(
                          //   fontSize: 14,
                          //   color: Colors.black87,
                          //   decoration: TextDecoration.underline,
                          //   decorationColor: Colors.blue,
                          //   decorationThickness: 3,
                          //   height: 1, // Adjust height to control spacing
                          // ),
                          // children: const [
                          //   // spacing between text and underline
                          //   WidgetSpan(
                          //     child: SizedBox(width: 8),
                          //   ),
                          // ],
                          children: [
                            TextSpan(
                              text: widget.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Inter',
                                color: Colors.black87,
                              ),
                            ),
                            TextSpan(
                                text: '*',
                                style: TextStyle(
                                    fontSize: 18, color: AppColors.redColor))
                          ]),
                    ),
                  )

                // info text parameter is null, display as normal text
                : Text(
                    widget.title,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
          ],
        )),
      ],
    );
  }
}
