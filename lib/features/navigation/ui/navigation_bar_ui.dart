import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_tastebud/core/utils/hex_to_color.dart';
import 'package:sp_tastebud/features/navigation/bloc/app_navigation_bloc.dart';
import 'package:sp_tastebud/features/navigation/ui/navigation_bar_items.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar(
      {super.key, required this.appName1, required this.appName2});

  final String appName1;
  final String appName2;

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
                // style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: appName1,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      // fontSize: 24,
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

            // Pages

            // SafeArea is for adding marginTop
            child: SafeArea(
              child: bottomNavScreen.elementAt(state.tabIndex),
            ),
          ),

          // Bottom Nav Bar
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: '#45B5B4'.toColor(),
            unselectedItemColor: '#ECAC70'.toColor(),
            currentIndex: state.tabIndex,
            // showUnselectedLabels: false,

            // items
            items: bottomNavItems,

            // on click
            onTap: (index) {
              BlocProvider.of<AppNavigationBloc>(context)
                  .add(TabChange(tabIndex: index));
            },
          ),
        );
      },
    );
  }
}
