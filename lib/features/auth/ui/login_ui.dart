import 'package:dimension/dimension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/shared/connectivity/connectivity_listener_widget.dart';
import '../bloc/auth_bloc.dart';
import '../data/preferences_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  String?
      _errorMessage; // error message variable to display authentication errors
  bool _obscurePassword = true; // for toggling show password option

  // getting text field values
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reset Error Message on Retyping
    _emailController.addListener(() {
      if (_errorMessage != null && _emailController.text.isNotEmpty) {
        setState(() {
          // Clear the error message when user starts editing email.
          _errorMessage = null;
        });
      }
    });
    _passwordController.addListener(() {
      if (_errorMessage != null && _passwordController.text.isNotEmpty) {
        setState(() {
          // Clear the error message when user starts editing password.
          _errorMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // toggles the password show status
  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Define a method to get the appropriate border color
  InputBorder _getInputBorder(bool isFocused, [String? errorMessage]) {
    // If there's an error message and the field is focused, show red border
    if (errorMessage != null) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      );
    } else if (isFocused) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green),
      );
    }
    // Default border when not focused
    return const OutlineInputBorder();
  }

  @override
  Widget build(BuildContext context) {
    // final loginBloc = getIt<AuthBloc>();
    final loginBloc = BlocProvider.of<AuthBloc>(context);

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
              // Listen to state changes
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  // If login is successful, navigate to search recipe
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Login successful!")),
                    );
                    context.go('/search');
                    // Login failed
                  } else if (state is AuthFailure) {
                    setState(() {
                      _errorMessage =
                          state.error; // Set the error message to be displayed
                    });
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: (40.toVHLength).toPX()),

                    Row(
                      children: [
                        Text(
                          'Hi, Welcome back!',
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
                          enabledBorder: _getInputBorder(false, _errorMessage),
                          focusedBorder: _getInputBorder(true, _errorMessage),
                          hintText: 'example@gmail.com',
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(),
                        )),

                    SizedBox(height: (20.toVHLength).toPX()),

                    // password
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),

                    // password text field
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white60,
                        hintText: 'Password',
                        contentPadding: const EdgeInsets.all(15),
                        border: const OutlineInputBorder(),
                        enabledBorder: _getInputBorder(false, _errorMessage),
                        focusedBorder: _getInputBorder(true, _errorMessage),

                        // show password icon
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: _togglePassword,
                        ),
                      ),
                    ),

                    // forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text.rich(
                            TextSpan(
                              text: "Forgot Password?",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              recognizer: TapGestureRecognizer()
                                // Navigate when tapped
                                ..onTap = () {
                                  context.goNamed('forgotPassword');
                                },
                            ),
                          ),
                        )
                      ],
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
                              onPressed: _emailController.text.isNotEmpty &
                                      _passwordController.text.isNotEmpty
                                  ? () {
                                      // Set remember me regardless of the toggle value
                                      PreferencesService().setRememberMe(true);
                                      // Dispatch login event
                                      loginBloc.add(LoginRequested(
                                          email: _emailController.text,
                                          password: _passwordController.text));
                                    }
                                  : null,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    // Light red when disabled
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return AppColors.redDisabledColor;
                                    }
                                    return AppColors.redColor;
                                  },
                                ),
                                // text color for button
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Color(0xFFF7EBE8);
                                    }
                                    return Color(0xFFF7EBE8);
                                  },
                                ),
                              ),
                              child: const Text("Log In"),
                            ),
                          ),

                          SizedBox(height: (15.toVHLength).toPX()),

                          // sign up helper text
                          Text.rich(TextSpan(children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                // Navigate when tapped
                                ..onTap = () {
                                  context.go('/signup');
                                },
                            ),
                          ]))
                        ],
                      ),
                    ),

                    SizedBox(height: (40.toVHLength).toPX()),
                  ],
                ),
              ),
            )));
  }
}
