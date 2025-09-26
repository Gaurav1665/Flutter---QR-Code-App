import 'package:qrgen/utils/importExport.dart';

class QrVersionButtonModel {
  final List<ButtonSegment<int>> segments = const [
    ButtonSegment(value: 2, label: Text('Small')),
    ButtonSegment(value: 5, label: Text('Medium')),
    ButtonSegment(value: 10, label: Text('Large')),
  ];
}