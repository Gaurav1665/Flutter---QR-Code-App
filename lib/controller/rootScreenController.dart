import 'package:qrgen/utils/importExport.dart';

class RootScreenController extends GetxController {
  final RxInt bottomNavIndex = 0.obs;

  void changeTabIndex(int index) {
    bottomNavIndex.value = index;
  }
}