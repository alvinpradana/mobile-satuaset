import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'wealth_screen.dart';

class WealthTabNavigator extends StatelessWidget {
  const WealthTabNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) => const WealthScreen(),
        );
      },
    );
  }
}
