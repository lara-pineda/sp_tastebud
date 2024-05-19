import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dimension/dimension.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';
import 'package:sp_tastebud/shared/connectivity/connectivity_listener_widget.dart';
import '../bloc/auth_bloc.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String? _errorMessage; // for displaying authentication errors
  String? _successMessage;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();

  // Retrieve AuthBloc using GetIt
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();

  @override
  void initState() {
    super.initState();
    // Reset Error Message on Retyping on textfield
    _emailController.addListener(() {
      if (_errorMessage != null && _emailController.text.isNotEmpty) {
        setState(() {
          // Clear the error message when user starts editing email.
          _errorMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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

  // Notification and Redirection
  Future<void> notifyAndRedirect(BuildContext context) async {
    // Wait for 10 seconds
    await Future.delayed(Duration(seconds: 10));

    // Check if the widget is still mounted
    if (context.mounted) {
      // Redirect to the main menu or login
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityListenerWidget(
        child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthPasswordResetSuccess) {
                // Show success message
                setState(() {
                  _isLoading = false;
                  _successMessage =
                      "Verification link sent!\nPlease check your email for the link.\n\nRedirecting to main menu in 10 seconds...";
                });
                notifyAndRedirect(context);
              } else if (state is AuthEmailNotFound) {
                // Show error message
                setState(() {
                  _isLoading = false;
                  _errorMessage = state.message;
                });
              } else if (state is AuthFailure) {
                // Show error message
                setState(() {
                  _isLoading = false;
                  _errorMessage = state.error;
                });
              } else if (state is AuthLoading) {
                // Show loading state
                setState(() {
                  _isLoading = true;
                });
              }
            },
            child: _buildResetPasswordUI()));
  }

  Widget _buildResetPasswordUI() {
    return Scaffold(
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
            context.go('/login');
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
                  'Reset Your Password',
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
                      'Enter your registered email address below.',
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

            const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 3,
                ),
                child: Column(
                  children: [
                    Text(
                      'A link will be sent to your email to reset your password.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),

            SizedBox(height: (20.toVHLength).toPX()),

            // email address text field
            TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white60,
                  enabledBorder: _getInputBorder(false, _errorMessage),
                  focusedBorder: _getInputBorder(true, _errorMessage),
                  hintText: 'example@gmail.com',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(),
                )),

            SizedBox(height: (20.toVHLength).toPX()),

            // Conditional message display
            if (_isLoading)
              Center(
                child: Column(
                  children: [
                    SizedBox(height: (40.toVHLength).toPX()),
                    CircularProgressIndicator(),
                    SizedBox(height: (20.toVHLength).toPX()),
                    Text(
                      "Checking database for user...",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else if (_successMessage != null)
              Center(
                child: Column(
                  children: [
                    SizedBox(height: (40.toVHLength).toPX()),
                    CircularProgressIndicator(),
                    SizedBox(height: (20.toVHLength).toPX()),
                    Text(
                      _successMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Column(
                  children: [
                    SizedBox(height: (40.toVHLength).toPX()),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

            const Spacer(),

            // widgets at the bottom of the screen
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  // submit button
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: _emailController.text.isNotEmpty
                          ? () {
                              // Dispatch event here
                              _authBloc.add(
                                PasswordResetRequested(
                                    email: _emailController.text),
                              );
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
                      child: const Text("Reset Password",
                          style: TextStyle(fontSize: 14)),
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
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: "Sign Up",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
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
    );
  }
}
