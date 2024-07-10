import 'package:flutter/material.dart';
import 'package:instafake_flutter/core/providers/home_provider.dart';

class HomePostScreen extends StatelessWidget {
  final HomeProvider provider;
  const HomePostScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container()
        ),
        Expanded(
          child: Container()
        ),
      ]
    );
  }
}