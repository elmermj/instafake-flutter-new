import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCardWidget extends StatelessWidget{
  final Widget child;
  const CustomCardWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    //get context height
    
    return Container(
      constraints: BoxConstraints(
        maxWidth: Get.width * 0.8,
        minWidth: Get.width * 0.1,
        maxHeight: Get.height * 0.3,
        minHeight: Get.height * 0.1,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Get.theme.colorScheme.onSurface,
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ]
      ),
      child: child,
    );
  }

}