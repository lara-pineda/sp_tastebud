import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sp_tastebud/core/utils/hex_to_color.dart';
import 'package:sp_tastebud/features/auth/ui/login_ui.dart';
// import '../config/themes/app_palette.dart';

import 'package:sp_tastebud/features/auth/ui/signup_ui.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key, required this.appName1, required this.appName2});

  final String appName1;
  final String appName2;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  void signupClicked() {
    print("create account button clicked!");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }

  void signinClicked() {
    print("sign in button clicked!");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        // fruits image
        Container(
          height: MediaQuery.of(context).size.height / 2.85,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage('assets/images/LandingFruits.jpg'),
            ),
          ),
        ),

        // gradient overlay
        Container(
            height: MediaQuery.of(context).size.height / 2.845,
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: const FractionalOffset(0.5, 1.0),
                  colors: [
                    Colors.grey.withOpacity(0.0),
                    Colors.white,
                  ],
                  stops: const [0.0, 1.0],
                ))),

        // other children widgets
        Positioned(
            child: Column(
          children: [
            // empty container to act as marginTop
            SizedBox(height: MediaQuery.of(context).size.height / 2.85),

            // Star Icon
            Center(
              child: SvgPicture.asset(
                'assets/images/StarIcon.svg',
                semanticsLabel: 'Star Icon',
                width: 200,
              ),
            ),

            SizedBox(height: (35.toVHLength).toPX()),

            // app name
            Text.rich(
              TextSpan(
                // style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: widget.appName1,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: '#ECAC70'.toColor(),
                    ),
                  ),
                  TextSpan(
                    text: widget.appName2,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: '#4AB7B6'.toColor(),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: (15.toVHLength).toPX()),

            // app tagline
            SizedBox(
              width: (MediaQuery.of(context).size.width / 6) * 4.5,
              child: const Text(
                'Explore, discover, delight - Your personal food companion is here!',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: (40.toVHLength).toPX()),

            // sign in button
            SizedBox(
              width: (MediaQuery.of(context).size.width / 6) * 4.5,
              child: ElevatedButton(
                onPressed: signinClicked,
                style: ElevatedButton.styleFrom(
                  backgroundColor: '#F06F6F'.toColor(),
                  foregroundColor: const Color(0xFFF7EBE8),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(7.0),
                  // ),
                ),
                child: const Text("Sign In"),
              ),
            ),

            SizedBox(height: (15.toVHLength).toPX()),

            // create account button
            SizedBox(
              width: (MediaQuery.of(context).size.width / 6) * 4.5,
              child: OutlinedButton(
                onPressed: signupClicked,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(7.0),
                  // ),
                  // side: BorderSide(
                  //   color: '#000000'.toColor(),
                  // ),
                ),
                child: const Text("Create Account"),
              ),
            )
          ],
        )),
      ]),
    );
  }
}
