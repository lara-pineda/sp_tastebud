class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException(
      [this.message =
          "Error: No user found with that email.\nPlease try again."]);

  @override
  String toString() => message;
}
