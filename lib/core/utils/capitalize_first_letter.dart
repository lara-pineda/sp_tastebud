String capitalizeFirstLetters(String input) {
  // This regular expression matches any character following the start of a string,
  // any whitespace, or a slash, ensuring we capitalize after slashes and spaces.
  return input.replaceAllMapped(RegExp(r'(^\w|[\s\/]\w)'), (match) {
    return match.group(0)!.toUpperCase();
  });
}
