import 'package:qrgen/utils/importExport.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QrGenerateController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFocusNode = FocusNode();
  final RxString inputText = ''.obs;
  final RxString qrData = ''.obs;
  final Rx<QrCode?> qrCode = Rx<QrCode?>(null);
  late final QrVersionButtonController versionController;
  final RxDouble quality = 1.0.obs; // Quality factor (1.0 to 3.0)
  final Rx<QrExportFormat> selectedFormat = QrExportFormat.png.obs;
  final RxBool transparentBackground = false.obs;

  @override
  void onInit() {
    super.onInit();
    versionController = Get.find(tag: 'QrVersionButtonController');
    textController.addListener(() {
      inputText.value = textController.text;
    });
    versionController.selectedVersion.listen((newVersion) {
      if (qrData.value.isNotEmpty) {
        generateQr();
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void generateQr() {
    textFocusNode.unfocus();
    qrData.value = textController.text.trim();
    if (qrData.value.isNotEmpty) {
      qrCode.value = QrCode.fromData(
        data: qrData.value,
        errorCorrectLevel: QrErrorCorrectLevel.M,
      );
    } else {
      qrCode.value = null;
    }
  }

  void clearInput() {
    textController.clear();
    inputText.value = '';
    qrData.value = '';
    qrCode.value = null;
  }

  void copyToClipboard() {
    if (qrData.value.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: qrData.value));
      Get.snackbar(
        'Success',
        'Text copied to clipboard',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        overlayBlur: 0,
        isDismissible: true,
      );
    }
  }

  Future<void> shareQr({required RenderRepaintBoundary boundary, required BuildContext context}) async {
    if (qrData.value.isEmpty || qrCode.value == null) return;

    try {
      ui.Image image = await boundary.toImage(pixelRatio: quality.value);

      ByteData? byteData;
      Uint8List bytes;
      String fileName = 'qr_code${selectedFormat.value.extension}';
      String mimeType = selectedFormat.value.mimeType;

      if (selectedFormat.value == QrExportFormat.png) {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);
        final size = Size(image.width.toDouble(), image.height.toDouble());

        if (!transparentBackground.value) {
          canvas.drawColor(Colors.white, BlendMode.srcOver);
        } else {
          canvas.drawColor(Colors.transparent, BlendMode.clear);
        }

        final paint = Paint()
          ..blendMode = BlendMode.srcOver
          ..isAntiAlias = true;
        canvas.drawImage(image, Offset.zero, paint);

        final picture = recorder.endRecording();
        final img = await picture.toImage(image.width, image.height);
        byteData = await img.toByteData(format: ui.ImageByteFormat.png);
        bytes = byteData!.buffer.asUint8List();
      } else {
        bytes = await createPdfWithQr(image, qrData.value);
      }

      await Share.shareXFiles([
        XFile.fromData(
          bytes,
          name: fileName,
          mimeType: mimeType,
        )
      ]);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing QR code: $e')),
      );
    }
  }

  Future<void> showShareOptionsDialog(BuildContext context, QrGenerateModel model) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxHeight: 400),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share QR Code',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<QrExportFormat>(
                  value: selectedFormat.value,
                  decoration: InputDecoration(
                    labelText: 'Format',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                  ),
                  items: QrGenerateModel.exportFormats.map((format) {
                    return DropdownMenuItem(
                      value: format,
                      child: Text(format.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) selectedFormat.value = value;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: Slider(
                          value: quality.value,
                          min: 1.0,
                          max: 3.0,
                          divisions: 4,
                          label: '${(quality.value).round()}%',
                          onChanged: (value) {
                            quality.value = value;
                          },
                          activeColor: colorScheme.primary,
                          inactiveColor: colorScheme.onSurfaceVariant.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: transparentBackground.value,
                        onChanged: selectedFormat.value == QrExportFormat.png
                            ? (value) {
                                transparentBackground.value = value ?? false;
                              }
                            : null,
                        activeColor: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => transparentBackground.value = !transparentBackground.value,
                      child: Text(
                        'Transparent Background',
                        style: textTheme.bodyLarge?.copyWith(
                          color: selectedFormat.value == QrExportFormat.png
                              ? colorScheme.onSurface
                              : colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Cancel', style: textTheme.labelLarge),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        Get.back();
                        RenderRepaintBoundary? boundary = model.repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
                        if (boundary != null) {
                          shareQr(boundary: boundary, context: context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error: QR code is not ready to share')),
                          );
                        }
                      },
                      child: Text('Share', style: textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary)),
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> createPdfWithQr(ui.Image qrImage, String qrData) async {
    final pdf = pw.Document();
    final ByteData? byteData = await qrImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List imageBytes = byteData!.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('QR Code', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Container(
                  width: 200 * quality.value,
                  height: 200 * quality.value,
                  decoration: transparentBackground.value
                      ? null
                      : pw.BoxDecoration(
                          color: PdfColors.white,
                          border: pw.Border.all(color: PdfColors.grey),
                          borderRadius: pw.BorderRadius.circular(5),
                        ),
                  child: pw.Image(
                    pw.MemoryImage(imageBytes),
                    fit: pw.BoxFit.contain,
                    width: 200 * quality.value,
                    height: 200 * quality.value,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Text(
                    qrData,
                    style: const pw.TextStyle(fontSize: 12),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return await pdf.save();
  }
}