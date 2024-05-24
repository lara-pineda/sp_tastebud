import 'package:dimension/dimension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:TasteBud/core/themes/app_palette.dart';
import 'package:TasteBud/features/auth/bloc/auth_bloc.dart';
import 'package:TasteBud/shared/connectivity/connectivity_listener_widget.dart';
import '../data/preferences_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {
  // error message variable to display authentication errors
  String? _errorMessage;

  // for toggling show password option
  bool _obscureCreatePassword = true;
  bool _obscureConfirmPassword = true;

  // for password validation
  bool _isPasswordValid = false;
  bool _isPasswordLongEnough = false;
  bool _isPasswordAlphanumeric = false;
  bool _doesPasswordMatch = false;
  bool _showPasswordRequirements = false;
  bool _showConfirmPasswordHelper = false;

  // Initialize FocusNodes
  final FocusNode _createPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  // getting text field values
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _createPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _createPasswordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);

    // Reset Error Message on Retyping
    _emailController.addListener(() {
      if (_errorMessage != null && _emailController.text.isNotEmpty) {
        setState(() {
          // Clear the error message when user starts editing.
          _errorMessage = null;
        });
      }
    });

    // These will trigger a rebuild whenever the focus changes

    // Hide requirements when focus is lost
    _createPasswordFocusNode.addListener(() {
      if (!_createPasswordFocusNode.hasFocus) {
        setState(() {
          _showPasswordRequirements = false;
        });
      }
    });

    // Hide helper text when focus is lost
    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus) {
        setState(() {
          _showConfirmPasswordHelper = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _createPasswordController.dispose();
    _confirmPasswordController.dispose();
    _createPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  // toggles the password show status
  void _toggleCreatePassword() {
    setState(() {
      _obscureCreatePassword = !_obscureCreatePassword;
    });
  }

  // toggles the password show status
  void _toggleConfirmPassword() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  // Define a method to get the appropriate border color
  InputBorder _getInputBorder(bool isValid, bool isFocused,
      [String? errorMessage]) {
    // If there's an error message and the field is focused, show red border
    if (errorMessage != null && isFocused) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      );
    }

    // If no error and field is focused, show border based on validity
    else if (isFocused) {
      Color borderColor = isValid ? Colors.green : Colors.red;
      return OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
      );
    }

    // Default border when not focused
    return const OutlineInputBorder();
  }

  bool isAlphanumericValidate(String input) {
    // This pattern ensures at least one letter and one number are present.
    bool hasLetters = RegExp(r'[a-zA-Z]').hasMatch(input);
    bool hasDigits = RegExp(r'\d').hasMatch(input);
    return hasLetters && hasDigits;
  }

  // password validation function
  void _validatePassword() {
    final password = _createPasswordController.text;
    bool isLongEnough = password.length >= 6;
    bool isAlphanumeric = isAlphanumericValidate(password);

    setState(() {
      _isPasswordValid = isLongEnough && isAlphanumeric;
      _isPasswordLongEnough = isLongEnough;
      _isPasswordAlphanumeric = isAlphanumeric;
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      _doesPasswordMatch =
          _createPasswordController.text == _confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final signupBloc = getIt<AuthBloc>();
    final signupBloc = BlocProvider.of<AuthBloc>(context);

    return ConnectivityListenerWidget(
        child: Scaffold(
      // make widgets fixed even when keyboard appears
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        // arrow back icon
        leadingWidth: 75,
        leading: GestureDetector(
          child: Container(
            margin: const EdgeInsets.only(
              left: 25,
              top: 5,
              bottom: 5,
            ),
            padding: const EdgeInsets.only(
              left: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.black12),
            ),
            width: MediaQuery.of(context).size.width,
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),

          // on click for arrow back icon
          onTap: () {
            context.go('/');
          },
        ),
        actions: [
          SvgPicture.asset(
            'assets/images/MiniStarIcon.svg',
            semanticsLabel: 'Mini Star Icon',
            width: (50.toVHLength).toPX(),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: (40.toVHLength).toPX()),

            Row(
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    color: AppColors.orangeColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: (40.toVHLength).toPX()),

            // email address
            const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 3,
                ),
                child: Column(
                  children: [
                    Text(
                      'Please fill in the following details to get registered.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                )),

            SizedBox(height: (20.toVHLength).toPX()),

            // email address
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Text(
                'Email Address',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
            ),

            // email address text field
            TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white60,
                  errorText: _errorMessage,
                  enabledBorder: _getInputBorder(true, false, _errorMessage),
                  focusedBorder: _getInputBorder(true, true, _errorMessage),
                  hintText: 'example@gmail.com',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(),
                )),

            SizedBox(height: (20.toVHLength).toPX()),

            // create password
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Text(
                'Create Password',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
            ),

            TextField(
              controller: _createPasswordController,
              focusNode: _createPasswordFocusNode,
              obscureText: _obscureCreatePassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white60,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(15),
                hintText: 'Enter your password',

                // Border when the TextField is not focused
                enabledBorder: _getInputBorder(
                    _isPasswordValid, _createPasswordFocusNode.hasFocus),
                // Border when the TextField is focused
                focusedBorder: _getInputBorder(
                    _isPasswordValid, _createPasswordFocusNode.hasFocus),

                // show password icon
                suffixIcon: IconButton(
                  icon: Icon(_obscureCreatePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: _toggleCreatePassword,
                ),

                helperText: _showPasswordRequirements
                    ? "Password must be at least 6 characters and alphanumeric"
                    : null,
                helperStyle: TextStyle(
                    color: _isPasswordValid ? Colors.green : Colors.red),
              ),
              onChanged: (value) {
                _validatePassword();
                setState(() {
                  // Always show password requirements when typing
                  _showPasswordRequirements = true;
                });
              },
            ),

            // conditionally display the password requirements
            if (_createPasswordFocusNode.hasFocus)
              Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        _isPasswordLongEnough ? Icons.check : Icons.close,
                        color:
                            _isPasswordLongEnough ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "At least 6 characters",
                        style: TextStyle(
                            color: _isPasswordLongEnough
                                ? Colors.green
                                : Colors.red),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        _isPasswordAlphanumeric ? Icons.check : Icons.close,
                        color:
                            _isPasswordAlphanumeric ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Alphanumeric",
                        style: TextStyle(
                            color: _isPasswordAlphanumeric
                                ? Colors.green
                                : Colors.red),
                      ),
                    ],
                  ),
                ],
              ),

            SizedBox(height: (20.toVHLength).toPX()),

            // confirm password
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Text(
                'Confirm Password',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
            ),

            // create password text field
            TextField(
              focusNode: _confirmPasswordFocusNode,
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white60,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(15),
                hintText: 'Confirm Password',

                // Border when the TextField is not focused
                enabledBorder: _getInputBorder(
                    _doesPasswordMatch, _confirmPasswordFocusNode.hasFocus),
                // Border when the TextField is focused
                focusedBorder: _getInputBorder(
                    _doesPasswordMatch, _confirmPasswordFocusNode.hasFocus),

                helperText: _showConfirmPasswordHelper
                    ? (_doesPasswordMatch ? null : "Passwords must match")
                    : null,
                helperStyle: TextStyle(
                    color: _doesPasswordMatch ? Colors.green : Colors.red),

                // show password icon
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: _toggleConfirmPassword,
                ),
              ),
              onChanged: (value) {
                _validateConfirmPassword();
                setState(() {
                  // Always show password requirements when typing
                  _showConfirmPasswordHelper = true;
                });
              },
            ),

            const Spacer(),

            // widgets at the bottom of the screen
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  // login button
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: _doesPasswordMatch
                          ? () {
                              // Set remember me regardless of the toggle value
                              PreferencesService().setRememberMe(true);
                              // Dispatch login event
                              signupBloc.add(SignUpRequested(
                                  email: _emailController.text,
                                  password: _confirmPasswordController.text));
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            // Light red when disabled
                            if (states.contains(MaterialState.disabled)) {
                              return AppColors.redDisabledColor;
                            }
                            return AppColors.redColor;
                          },
                        ),
                        // text color for button
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Color(0xFFF7EBE8);
                            }
                            return Color(0xFFF7EBE8);
                          },
                        ),
                      ),
                      child: const Text("Sign Up"),
                    ),
                  ),

                  SizedBox(height: (15.toVHLength).toPX()),

                  // sign up helper text
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "Log in",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        // Navigate when tapped
                        ..onTap = () {
                          context.go('/login');
                        },
                    ),
                  ]))
                ],
              ),
            ),

            SizedBox(height: (40.toVHLength).toPX()),

            // Listen to state changes
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                // If signup is successful, navigate to main menu
                if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Signup successful!")));
                  context.go('/search');

                  // Signup failed
                } else if (state is AuthFailure) {
                  // Show error message
                  setState(() {
                    _errorMessage =
                        state.error; // Set the error message to be displayed
                  });
                }
              },
              // placeholder, typically replaced by the whole signup_ui widget
              child: Container(),
            ),
          ],
        ),
      ),
    ));
  }
}
