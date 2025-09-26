import 'package:flutter/material.dart';
import 'package:qrgen/utils/importExport.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QrScanController controller = Get.put(QrScanController());

    // Use Material 3 theme with dynamic color scheme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Theme(
      data: Theme.of(context).copyWith(
        useMaterial3: true,
      ),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: controller.cameraController,
                    onDetect: controller.onDetect,
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.scrim.withOpacity(0.5), // M3 scrim for overlay
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 250,
                            height: 250,
                            child: Stack(
                              children: [
                                // Top-left corner
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border(
                                        top: BorderSide(
                                          color: colorScheme.primary,
                                          width: 4,
                                        ),
                                        left: BorderSide(
                                          color: colorScheme.primary,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Top-right corner
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border(
                                        top: BorderSide(
                                          color: colorScheme.primary,
                                          width: 4,
                                        ),
                                        right: BorderSide(
                                          color: colorScheme.primary,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Bottom-left corner
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border(
                                        bottom: BorderSide(
                                          color: colorScheme.primary,
                                          width: 4,
                                        ),
                                        left: BorderSide(
                                          color: colorScheme.primary,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Bottom-right corner
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border(
                                        bottom: BorderSide(
                                          color: colorScheme.primary,
                                          width: 4,
                                        ),
                                        right: BorderSide(
                                          color: colorScheme.primary,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 80, // Adjusted for better spacing
                          left: 0,
                          right: 0,
                          child: Text(
                            'Position QR code within the frame',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}