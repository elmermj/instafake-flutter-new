import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CaptionWidget extends StatelessWidget {
  final String username;
  final String caption;
  final void Function(String) onUsernameTap;
  final int? maxLines;

  const CaptionWidget({
    super.key,
    required this.username,
    required this.caption,
    required this.onUsernameTap,
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines ?? 2,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$username ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => onUsernameTap(username),
          ),
          WidgetSpan(
            child: Text(
              caption,
              overflow: TextOverflow.ellipsis,
            ),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}