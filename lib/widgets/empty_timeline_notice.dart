import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/widgets/custom_loading_widget.dart';

class EmptyTimelineNotice extends StatelessWidget {
  const EmptyTimelineNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // mainAxisSize: MainAxisSize.min,
      shrinkWrap: true,
      children: [
        const SizedBox(
          height: 100,
          width: 100,
          child: CustomLoadingWidget(),
        ),
        Container(
          margin: const EdgeInsets.all(16),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 16),
              AutoSizeText(
                "Seems like your timeline is too quiet...",
                minFontSize: 24,
                maxFontSize: 32,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 16),
              AutoSizeText(
                "Don't be a loner, go follow someone",
                minFontSize: 6,
                maxFontSize: 12,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Get.theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 8),
              AutoSizeText(
                "or burn someone's house",
                minFontSize: 6,
                maxFontSize: 12,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Get.theme.colorScheme.surface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}