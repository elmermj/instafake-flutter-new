import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SizedBox(
      height: 45,
      width: 45,
      child: RiveAnimation.asset(
        'assets/animations/hexasphere_loading.riv',
        artboard: isDarkMode? 'Hexasphere Dark' : 'Hexasphere Light',
        fit: BoxFit.contain,
      ),
    );
  }
}