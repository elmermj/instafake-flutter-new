import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.errorNotifier, this.keyboardType, this.color, this.prefix, this.maxLines, this.filled
  });

  final String? labelText;
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final ValueNotifier<String?>? errorNotifier;
  final TextInputType? keyboardType;
  final Color? color;
  final Widget? prefix;
  final int? maxLines;
  final bool? filled;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorNotifier ?? ValueNotifier<String?>(null),
      builder: (context, error, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            onSubmitted: onSubmitted,
            obscureText: obscureText,
            controller: controller,
            style: TextStyle(
              color: color ?? Get.theme.colorScheme.surface,
            ),
            minLines: 1,
            maxLines: maxLines ?? 1,
            decoration: InputDecoration(
              filled: filled ?? false,
              prefix: prefix,
              labelText: labelText,
              hintText: hintText,
              fillColor: Get.theme.colorScheme.outlineVariant,
              labelStyle: TextStyle(
                color: color ?? Get.theme.colorScheme.surface,
              ),
              errorText: error,
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Get.theme.colorScheme.errorContainer,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              errorStyle: TextStyle(
                color: Get.theme.colorScheme.errorContainer,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide(
                  color: Get.theme.colorScheme.secondary,
                  width: 1,
                ),
              ),
            ),
            onChanged: onChanged,
            keyboardType: keyboardType,
          ),
        );
      },
    );
  }
}
