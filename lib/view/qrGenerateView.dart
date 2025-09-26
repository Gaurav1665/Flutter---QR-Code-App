import 'package:flutter/material.dart';
import 'package:qrgen/controller/qrGenerateController.dart';
import 'package:qrgen/utils/importExport.dart';
import 'package:qrgen/model/qrGenerateModel.dart';
import 'package:qrgen/view/qrVersionButtonView.dart';

class QrGenerateScreen extends StatelessWidget {
  const QrGenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(QrVersionButtonController(), tag: 'QrVersionButtonController');
    final QrGenerateController controller = Get.put(QrGenerateController());
    final QrGenerateModel model = QrGenerateModel();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Theme(
      data: Theme.of(context).copyWith(
        useMaterial3: true,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // M3 recommends 16dp for body padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2, // M3 elevation level 2 for cards
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // M3 medium shape
                ),
                color: colorScheme.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Text or URL',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8), // M3 spacing scale
                      Obx(
                        () => TextField(
                          focusNode: controller.textFocusNode,
                          controller: controller.textController,
                          decoration: InputDecoration(
                            hintText: 'Enter text or URL (e.g., https://example.com)',
                            hintStyle: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // M3 medium shape
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            suffixIcon: controller.inputText.value.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: colorScheme.onSurfaceVariant,
                                      size: 24, // M3 icon size
                                    ),
                                    onPressed: controller.clearInput,
                                  )
                                : null,
                          ),
                          style: textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 16),
                      QrVersionButtonView(
                        onVersionChanged: (version) {
                          // Handled by versionController listener
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: controller.generateQr,
                          icon: Icon(
                            Icons.qr_code,
                            size: 24,
                          ),
                          label: Text(
                            'Generate QR Code',
                            style: textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size.fromHeight(48),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => controller.qrData.value.isNotEmpty
                    ? Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: colorScheme.surfaceContainerLow,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Generated QR Code',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: controller.transparentBackground.value
                                  ? Colors.transparent
                                  : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant,
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: RepaintBoundary(
                                  key: model.repaintBoundaryKey,
                                  child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Obx(
                                      () => QrImageView(
                                        data: controller.qrData.value,
                                        version: controller.versionController.selectedVersion.value,
                                        size: 200,
                                        backgroundColor: controller.transparentBackground.value ? Colors.transparent : Colors.white,
                                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                                        padding: const EdgeInsets.all(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () {
                                  if (controller.qrData.value.isNotEmpty) {
                                    controller.showShareOptionsDialog(context, model);
                                  }
                                },
                                icon: Icon(
                                  Icons.share,
                                  size: 20,
                                ),
                                label: Text(
                                  'Share',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(100, 48),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}