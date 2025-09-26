import 'package:qrgen/utils/importExport.dart';

class QrScanController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController(
    facing: CameraFacing.back, // Explicitly set camera facing
    torchEnabled: false, // Initial torch state
  );
  String? scannedData;
  final RxBool isScanning = true.obs;
  final RxBool isFlashOn = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await _requestCameraPermission();
    cameraController.start();
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      Get.snackbar(
        'Permission Denied',
        'Camera permission is required to scan QR codes.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isScanning.value = false;
    }
  }

  void onDetect(BarcodeCapture capture) {
    if (!isScanning.value) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null && code.isNotEmpty) {
        scannedData = code;
        isScanning.value = false;
        cameraController.stop();
        showResultDialog(code);
      }
    }
  }

  void showResultDialog(String result) {
    Get.dialog(
      AlertDialog(
        title: const Text('QR Code Scanned'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scanned Data:'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SelectableText(
                result,
                style: const TextStyle(fontSize: 16, color: Color(0xFF00363A)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: result));
              Get.snackbar(
                'Success',
                'Copied to clipboard',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Copy'),
          ),
          if (isUrl(result))
            TextButton(
              onPressed: () => launchUrlAction(result),
              child: const Text('Open URL'),
            ),
          TextButton(
            onPressed: () {
              resetScanner();
              Get.back();
            },
            child: const Text('Close'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  bool isUrl(String text) {
    text = text.trim();
    if (text.startsWith('http://') || text.startsWith('https://')) {
      return true;
    }
    if (text.contains('.') && !text.contains(' ')) {
      return true;
    }
    return false;
  }

  Future<void> launchUrlAction(String url) async {
    try {
      String urlToLaunch = url.trim();
      if (!urlToLaunch.startsWith('http://') && !urlToLaunch.startsWith('https://')) {
        urlToLaunch = 'https://$urlToLaunch';
      }
      final Uri uri = Uri.parse(urlToLaunch);
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      try {
        String urlToLaunch = url.trim();
        if (!urlToLaunch.startsWith('http://') && !urlToLaunch.startsWith('https://')) {
          urlToLaunch = 'https://$urlToLaunch';
        }
        final Uri uri = Uri.parse(urlToLaunch);
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e2) {
        Get.snackbar(
          'Error',
          'Could not launch URL: $e2',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void resetScanner() {
    scannedData = null;
    isScanning.value = true;
    cameraController.start(); // Resume scanning
  }

  void toggleFlash() {
    isFlashOn.value = !isFlashOn.value;
    cameraController.toggleTorch();
  }
}