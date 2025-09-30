# Flutter Scan and Fill Form - Project Metadata

## Project Information
- **Name**: Flutter Scan and Fill Form
- **Version**: 1.0.0
- **Description**: A Flutter application for document edge detection, scanning, OCR, and Supabase integration
- **License**: MIT
- **Repository**: https://github.com/aiqs4/flutter-scan-and-fill-form

## Features
- Automatic document edge detection
- Real-time camera scanning
- OCR with Google ML Kit
- Structured data extraction
- Supabase cloud integration
- Cross-platform (Android & iOS)

## Technologies
- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **OCR**: Google ML Kit
- **Backend**: Supabase
- **Database**: PostgreSQL (via Supabase)
- **Storage**: Supabase Storage

## Dependencies
See `pubspec.yaml` for complete list

### Core Dependencies
- camera: ^0.10.5+5
- image_picker: ^1.0.4
- image: ^4.1.3
- google_ml_kit: ^0.16.3
- supabase_flutter: ^2.0.0
- provider: ^6.1.1
- path_provider: ^2.1.1
- permission_handler: ^11.0.1

## Platform Requirements

### Android
- Min SDK: 21 (Android 5.0)
- Target SDK: 34
- Compile SDK: 34

### iOS
- Min Version: 12.0
- Target Version: Latest

## File Structure
```
flutter-scan-and-fill-form/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── document_scanner_screen.dart
│   │   └── result_screen.dart
│   └── services/
│       ├── edge_detection_service.dart
│       ├── ocr_service.dart
│       └── supabase_service.dart
├── android/
├── ios/
├── supabase/
│   └── setup.sql
├── test/
├── pubspec.yaml
├── README.md
├── ARCHITECTURE.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── QUICKSTART.md
└── LICENSE
```

## Development Status
- Status: Active Development
- Stability: Stable (v1.0.0)
- Maintenance: Active

## Contributors
See GitHub contributors page

## Support
- Issues: https://github.com/aiqs4/flutter-scan-and-fill-form/issues
- Discussions: GitHub Discussions

## Tags
#flutter #dart #ocr #document-scanner #supabase #mobile-app #computer-vision #ml-kit
