import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/utils/hex_to_color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  // for toggling show password option
  bool _obscurePassword = true;

  // for remember me functionality
  bool _isChecked = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // getting text field values
  // String _password;

  // toggles the password show status
  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // toggle remember me functionality
  void _toggleRememberMe(bool? value) {
    setState(() {
      _isChecked = value!;
    });
  }

  void loginClicked() {
    print("\nlogin button clicked!");
    print(_emailController.text);
    print(_passwordController.text);
    // launch logic for user auth
    context.go("/search");
  }

  Color getColor() {
    return Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
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
                  'Hi, Welcome back!',
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
                  hintText: 'Email Address',
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
              // obscureText: _isObscure,
              controller: _passwordController,
              obscureText: _obscurePassword,
              // keyboardType: TextInputType.visiblePassword,
              // textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white60,
                hintText: 'Password',
                contentPadding: const EdgeInsets.all(15),
                // helperText:"Password must contain special character",
                // helperStyle:TextStyle(color:Colors.green),
                border: const OutlineInputBorder(),

                // show password icon
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: _togglePassword,
                ),
              ),

              // validator: (val) => val.length < 6 ? 'Password too short.' : null,
              // onSaved: (val) => _password = val,
            ),

            // remember me
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      activeColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      visualDensity: const VisualDensity(horizontal: -3),
                      onChanged: _toggleRememberMe,
                    ),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                  ),
                ),
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
                      onPressed: loginClicked,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: '#F06F6F'.toColor(),
                        foregroundColor: const Color(0xFFF7EBE8),
                      ),
                      child: const Text("Log In"),
                    ),
                  ),

                  SizedBox(height: (15.toVHLength).toPX()),

                  // sign up helper text
                  const Text.rich(TextSpan(children: [
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
