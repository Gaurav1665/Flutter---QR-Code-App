import 'package:qrgen/utils/importExport.dart';

class QrVersionButtonController extends GetxController {
  final RxInt selectedVersion = 2.obs; // Default to Small (version 2)

  void onVersionChanged(int newVersion) {
    selectedVersion.value = newVersion;
  }
}