import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:qrgen/view/rootScreenView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'QR',
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(brightness: Brightness.light),
      themeMode: ThemeMode.system,
      home: const RootScreen(),
    );
  }

  ThemeData getAppTheme({Brightness brightness = Brightness.light}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF4DD0E1) ,
        onPrimary: Color(0xFF00363A),
        primaryContainer: Color(0xFF004F4E),
        onPrimaryContainer: Color(0xFF9DE7F0),
        secondary: Color(0xFFCCECE8),
        onSecondary: Color(0xFF1A3432),
        secondaryContainer: Color(0xFF324B49),
        onSecondaryContainer: Color(0xFFE8F6F3),
        tertiary: Color(0xFFA8F0C6),
        onTertiary: Color(0xFF0C2B1B),
        tertiaryContainer: Color(0xFF1A4C34),
        onTertiaryContainer: Color(0xFFC5F7D9),
        background: Color(0xFF1A1C1B),
        onBackground: Color(0xFFE2E3E2),
        surface: Color(0xFF1A1C1B),
        onSurface: Color(0xFFE2E3E2),
        surfaceContainer: Color(0xFF2E3130),
        surfaceContainerLow: Color(0xFF262827),
        surfaceContainerLowest: Color(0xFF151716),
        surfaceContainerHigh: Color(0xFF383B3A),
        surfaceContainerHighest: Color(0xFF434645),
        outline: Color(0xFF899391),
        outlineVariant: Color(0xFF3F4947),
        scrim: Color(0xFF000000),
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
      ),
    );
  }
}
