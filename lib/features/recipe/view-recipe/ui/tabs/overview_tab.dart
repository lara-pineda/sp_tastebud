import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/core/utils/capitalize_first_letter.dart';
import '../../model/recipe_model.dart';
import 'info_row.dart';

class OverviewTab extends StatelessWidget {
  final Recipe recipe;

  const OverviewTab({super.key, required this.recipe});

  void _launchURL(BuildContext context, String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            // webview link button here
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.only(right: 0.0),
                    icon: Icon(Icons.link, color: AppColors.orangeDarkerColor),
                    onPressed: () => _launchURL(context, recipe.url),
                  ),
                  TextButton(
                    onPressed: () => _launchURL(context, recipe.url),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(0)),
                    ),
                    child: Text(
                      'View recipe instructions on web',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        color: AppColors.orangeDarkerColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.orangeDarkerColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InfoRow(
              columns: [
                Text(
                  'Source',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.source,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Servings',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.yield.toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Calories',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.calories.toStringAsFixed(0),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Cuisine Type',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.cuisineType
                      .map((type) {
                        return capitalizeFirstLetters(type);
                      })
                      .toList()
                      .join(', '),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Meal Type',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.mealType
                      .map((type) {
                        return capitalizeFirstLetters(type);
                      })
                      .toList()
                      .join(', '),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Dish Type',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.dishType.isNotEmpty
                      ? recipe.dishType
                          .map((type) {
                            return capitalizeFirstLetters(type);
                          })
                          .toList()
                          .join(', ')
                      : 'N/A',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            InfoRow(
              columns: [
                Text(
                  'Tags',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: AppColors.purpleColor,
                  ),
                ),
                Text(
                  recipe.tags.isNotEmpty ? recipe.tags.join(', ') : 'N/A',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: null,
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
