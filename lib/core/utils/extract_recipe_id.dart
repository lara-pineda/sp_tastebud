String extractRecipeIdUsingRegExp(String uri) {
  RegExp regExp = RegExp(r'#recipe_(\w+)');
  var matches = regExp.firstMatch(uri);
  if (matches != null && matches.groupCount >= 1) {
    return matches
        .group(1)!; // Return the captured group which is the recipe ID
  }
  return ''; // Return an empty string if no match found
}
