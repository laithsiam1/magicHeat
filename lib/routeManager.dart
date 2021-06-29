import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_heat/screens/authentication/signupScreen.dart';
import 'package:magic_heat/screens/home/homeScreen.dart';

class RouteManager {
  static generateRoute(RouteSettings settings, BuildContext context) {
    switch (settings.name) {
      case HomeScreen.routePath:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
          settings: settings,
        );
        break;

      case SignupScreen.routePath:
        return MaterialPageRoute(
          builder: (context) => SignupScreen(),
          settings: settings,
        );
        break;
    }
  }
}
