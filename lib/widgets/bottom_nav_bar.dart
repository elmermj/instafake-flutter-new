import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/services/connectivity_service.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int index;

  const BottomNavBar({super.key, required this.items, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: kBottomNavigationBarHeight,
      child: context.watch<ConnectivityProvider>().status == ConnectivityStatus.connected
      ? BottomNavigationBar(
          items: items,
        )
      : Column(
          children: [
            BottomNavigationBar(
              items: items,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: context.watch<ConnectivityProvider>().status == ConnectivityStatus.connected? 0 : 20, 
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: AnimationController(
                      vsync: Scaffold.of(context),
                      duration: const Duration(milliseconds: 500),
                    ),
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  color: Get.theme.colorScheme.errorContainer,
                  child: const Center(
                    child: AutoSizeText(
                      "No Internet Connection",
                      minFontSize: 6,
                      maxFontSize: 12,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
