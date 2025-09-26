# Flutter QR Code App

A Flutter app for generating and scanning QR codes, built with a modern Material 3 design for a simple, intuitive, and cross-platform experience.

---

## 🚀 Features

- Generate QR codes from text, URLs, or other data
- Scan QR codes using the device camera
- Save generated QR codes as images
- Copy or share scanned QR code content
- Modern Material 3 UI with tab-based navigation
- Cross-platform support (Android, iOS, web)

---

## 📱 Screenshots

*Replace with your own screenshots*

| Generate View | Scan View |
|---------------|-----------|
| ![generate](screenshots/flutter_01.png) |  ![scan](screenshots/flutter_01.png) |

---

## 🛠️ Tech Stack & Packages

- **Flutter / Dart**: Core framework for cross-platform development
- `qr_flutter`: For generating QR codes
- `mobile_scanner` or `qr_code_scanner`: For QR code scanning
- `path_provider` + `permission_handler`: For file saving and permissions
- `get`: For state management (used in `RootScreenController`)
- Material 3: For modern UI design with dynamic color schemes and typography

*See `pubspec.yaml` for complete dependency list and versions.*

---

## 🧩 Project Structure
```
lib/.
├── main.dart
├── screens/
│ ├── generate_screen.dart
│ └── scan_screen.dart
├── widgets/
│ └── custom_button.dart
└── utils/
└── qr_utils.dart
assets/
ios/
android/
test/
pubspec.yaml
```


You can adjust to match your actual structure.

---

## 🧭 Getting Started

### Prerequisites

- Flutter SDK installed  
- A device / emulator to run the app  
- (Optional) Permissions for camera & storage  

### Setup Instructions

1. Clone the repo:
   ```bash
   git clone https://github.com/Gaurav1665/Flutter---QR-Code-App.git
   cd Flutter---QR-Code-App
   ```
2. Install dependencies:
    ```
    flutter pub get
   ```
3. Run the app:
    ```
    flutter run
   ```
---

## 📂 Usage

- **Generate QR**: Enter text / URL → hit “Generate” → QR is displayed.
- **Save QR**: Use “Save / Download” button to save image.
- **Scan QR**: Navigate to scan screen → allow camera → point at QR.
- **Copy / Share**: After scanning, copy or share the content.

---

## ✅ To-Do / Future Improvements

- Add history for scanned and generated QR codes
- Support additional QR formats (e.g., vCard, Wi-Fi credentials)
- Implement dark theme and dynamic theming
- Enhance error handling with user-friendly UI
- Add unit and widget tests for reliability

---

## 📦 Dependencies

*From `pubspec.yaml` (update versions as needed):*

```yaml
dependencies:
flutter:
 sdk: flutter
qr_flutter: ^4.0.0
qr_code_scanner: ^0.7.0
path_provider: ^2.0.0
permission_handler: ^10.0.0
get: ^4.6.6
# ...other dependencies
```

---

## 📜 License & Attribution

This project is open source. Feel free to fork, modify, and share.
