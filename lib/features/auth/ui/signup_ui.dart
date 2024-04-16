import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/utils/hex_to_color.dart';

import '../bloc/signup_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {
  // for toggling show password option
  bool _obscureCreatePassword = true;
  bool _obscureConfirmPassword = true;

  // getting text field values
  TextEditingController _emailController = TextEditingController();
  TextEditingController _createPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

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

  Color getColor() {
    return Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    final signupBloc = BlocProvider.of<SignupBloc>(context);

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
            // Navigator.pop(context);
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
                    color: '#ECAC70'.toColor(),
                  ),
                ),

                // hand wave emoji here
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
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white60,
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

            // create password text field
            TextField(
              // obscureText: _isObscure,
              controller: _createPasswordController,
              obscureText: _obscureCreatePassword,
              // keyboardType: TextInputType.visiblePassword,
              // textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white60,
                hintText: 'Must be at least 8 characters',
                contentPadding: const EdgeInsets.all(15),
                // helperText:"Password must contain special character",
                // helperStyle:TextStyle(color:Colors.green),
                border: const OutlineInputBorder(),

                // show password icon
                suffixIcon: IconButton(
                  icon: Icon(_obscureCreatePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: _toggleCreatePassword,
                ),
              ),

              // validator: (val) => val.length < 6 ? 'Password too short.' : null,
              // onSaved: (val) => _password = val,
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
              // obscureText: _isObscure,
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              // keyboardType: TextInputType.visiblePassword,
              // textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white60,
                hintText: 'Confirm Password',
                contentPadding: const EdgeInsets.all(15),
                // helperText:"Passwords must match",
                // helperStyle:TextStyle(color:Colors.green),
                border: const OutlineInputBorder(),

                // show password icon
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: _toggleConfirmPassword,
                ),
              ),

              // validator: (val) => val.length < 6 ? 'Password too short.' : null,
              // onSaved: (val) => _password = val,
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
                      onPressed: () {
                        signupBloc.add(SignUpRequested(
                            email: _emailController.text,
                            password: _confirmPasswordController.text));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: '#F06F6F'.toColor(),
                        foregroundColor: const Color(0xFFF7EBE8),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(7.0),
                        // ),
                      ),
                      child: const Text("Sign Up"),
                    ),
                  ),

                  SizedBox(height: (15.toVHLength).toPX()),

                  // sign up helper text
                  const Text.rich(TextSpan(children: [
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
                    ),
                  ]))
                ],
              ),
            ),

            SizedBox(height: (40.toVHLength).toPX()),

            // Listen to state changes
            BlocListener<SignupBloc, SignupState>(
              listener: (context, state) {
                // If signup is successful, navigate to main menu
                if (state is SignupSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Signup successful!")));
                  context.go('/');

                  // Signup failed
                } else if (state is SignupFailure) {
                  // Show error message
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              // placeholder, typically replaced by the whole signup_ui widget
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
