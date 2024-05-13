import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_tastebud/core/utils/hex_to_color.dart';
import 'package:sp_tastebud/features/navigation/ui/navigation_bar_items.dart';

import '../bloc/app_navigation_bloc.dart';

class AppBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final String appName1;
  final String appName2;

  const AppBottomNavBar(
      {super.key,
      required this.appName1,
      required this.appName2,
      required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppNavigationBloc, AppNavigationState>(
        listener: (context, state) {},
        builder: (context, state) {
          // main scaffold in the app after logging in
          return Scaffold(
              // make background fixed even when keyboard appears
              resizeToAvoidBottomInset: false,

              // extend background up to the top edge of phone for notches
              extendBodyBehindAppBar: true,

              // App Bar
              appBar: AppBar(
                // make background show behind appbar
                backgroundColor: Colors.transparent,
                elevation: 0,

                // App Name
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: appName1,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: '#ECAC70'.toColor(),
                        ),
                      ),
                      TextSpan(
                        text: appName2,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          // fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: '#4AB7B6'.toColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Body
              body: Container(
                // Background Image
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/Background.png'),
                  fit: BoxFit.cover,
                )),

                // SafeArea is for adding marginTop
                child: SafeArea(
                  // Area for page contents
                  child: navigationShell,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: bottomNavItems,
                currentIndex: state.tabIndex,
                selectedItemColor: '#45B5B4'.toColor(),
                unselectedItemColor: '#ECAC70'.toColor(),
                // showUnselectedLabels: false,
                onTap: _goBranch,
              ));
        });
  }
}
