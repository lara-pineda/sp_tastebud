import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/themes/app_palette.dart';

import '../bloc/auth_bloc.dart';
import '../data/preferences_service.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key, required this.appName1, required this.appName2});

  final String appName1;
  final String appName2;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late AuthBloc _authBloc;

  // navigate to signup page
  void signupClicked() {
    context.go("/signup");
  }

  // navigate to login page
  void signinClicked() {
    print("sign in button clicked!");
    context.go("/login");
  }

  @override
  void initState() {
    super.initState();
    _authBloc = GetIt.instance<AuthBloc>();
    _loadRememberMeState();
  }

  // load remember me functionality
  void _loadRememberMeState() async {
    bool rememberMe = await PreferencesService().getRememberMe();
    if (rememberMe) {
      _attemptAutoLogin();
    }
  }

  // auto login user
  void _attemptAutoLogin() {
    _authBloc.add(CheckLoginStatus());
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
                children: [
                  TextSpan(
                    text: widget.appName1,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: AppColors.orangeColor,
                    ),
                  ),
                  TextSpan(
                    text: widget.appName2,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: AppColors.seaGreenColor,
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
                  backgroundColor: AppColors.redColor,
                  foregroundColor: const Color(0xFFF7EBE8),
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
