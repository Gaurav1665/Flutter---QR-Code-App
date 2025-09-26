import 'package:qrgen/utils/importExport.dart';

class QrGenerateModel {
  final GlobalKey repaintBoundaryKey = GlobalKey();

  static const List<QrExportFormat> exportFormats = [
    QrExportFormat.png,
    QrExportFormat.pdf,
  ];

  IconData getFormatIcon(QrExportFormat format) {
    switch (format) {
      case QrExportFormat.png:
        return Icons.image;
      case QrExportFormat.pdf:
        return Icons.picture_as_pdf;
    }
  }

  String getFormatDescription(QrExportFormat format) {
    switch (format) {
      case QrExportFormat.png:
        return 'High quality with transparency';
      case QrExportFormat.pdf:
        return 'Document format';
    }
  }
}