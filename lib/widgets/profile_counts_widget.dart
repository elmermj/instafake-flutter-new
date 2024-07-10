import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProfileCountsWidget extends StatelessWidget {
  const ProfileCountsWidget({
    super.key, required this.count, required this.label,
  });

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    String number = formatCount(count);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText(
            number,
            minFontSize: 24,
            maxFontSize: 32,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          AutoSizeText(
            label,
            minFontSize: 16,
            maxFontSize: 24,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      double formattedCount = count / 1000;
      return '${formattedCount.toStringAsFixed(formattedCount.truncateToDouble() == formattedCount ? 0 : 1)}K';
    } else if (count < 1000000000) {
      double formattedCount = count / 1000000;
      return '${formattedCount.toStringAsFixed(formattedCount.truncateToDouble() == formattedCount ? 0 : 1)}M';
    } else {
      double formattedCount = count / 1000000000;
      return '${formattedCount.toStringAsFixed(formattedCount.truncateToDouble() == formattedCount ? 0 : 1)}B';
    }
  }

}