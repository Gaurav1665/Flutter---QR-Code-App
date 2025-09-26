import 'package:flutter/material.dart';
import 'package:qrgen/utils/importExport.dart';

class QrVersionButtonView extends StatelessWidget {
  final Function(int)? onVersionChanged;

  const QrVersionButtonView({
    super.key,
    this.onVersionChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Use a unique tag to ensure a single controller instance
    final QrVersionButtonController controller = Get.put(
      QrVersionButtonController(),
      tag: 'QrVersionButtonController',
    );
    final QrVersionButtonModel model = QrVersionButtonModel();

    // Use Material 3 theme with dynamic color scheme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Theme(
      data: Theme.of(context).copyWith(
        useMaterial3: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QR Code Version',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8), // M3 spacing scale
          Obx(
            () => SegmentedButton<int>(
              segments: model.segments,
              selected: {controller.selectedVersion.value},
              onSelectionChanged: (Set<int> newSelection) {
                controller.onVersionChanged(newSelection.first);
                if (onVersionChanged != null) {
                  onVersionChanged!(newSelection.first);
                }
              },
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.onSurfaceVariant,
                selectedBackgroundColor: colorScheme.primary,
                selectedForegroundColor: colorScheme.onPrimary,
                textStyle: textTheme.labelLarge,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // M3 medium shape
                  side: BorderSide(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                minimumSize: const Size(48, 40), // M3 touch target size
              ),
            ),
          ),
        ],
      ),
    );
  }
}