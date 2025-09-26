import 'package:qrgen/utils/importExport.dart';
import 'package:qrgen/view/qrGenerateView.dart';
import 'package:qrgen/view/qrScanView.dart';

class RootScreenModel {
  final List<Widget> screens = [const QrGenerateScreen(), const QrScanScreen(),];
  final List<IconData> iconList = [Icons.qr_code, Icons.qr_code_scanner_outlined];
  final List<String> labels = ['Generate', 'Scan'];
}