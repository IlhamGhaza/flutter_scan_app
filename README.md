# Flutter Scan App

**Flutter Scan App** is a Flutter application designed to scan and manage documents efficiently using **Google ML Kit Document Scanner** and **Sqflite** for local storage.

## Features

- **Document Scanning**: Capture documents using Google ML Kit's document scanning feature.
- **Document Categorization**: Organize scanned documents into categories.
- **Local Storage**: Store documents locally using Sqflite.
- **Responsive UI**: Optimized for portrait mode with customized app theming using Google Fonts.

## Getting Started

### Prerequisites

Ensure you have Flutter installed. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install) if you don't have it set up.

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/IlhamGhaza/flutter_scan_app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd flutter_scan_app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the Application

To run the app on an emulator or physical device:
```bash
flutter run
```

### Project Structure

- **lib/main.dart**: The entry point of the app.
- **lib/pages**: Contains different page widgets for the app.
- **lib/core**: Core functionalities and utilities such as custom styles and widgets.
- **lib/data**: Contains models and local data sources.

### Key Packages Used

- [google_mlkit_document_scanner](https://pub.dev/packages/google_mlkit_document_scanner) for document scanning.
- [sqflite](https://pub.dev/packages/sqflite) for local data storage.
- [google_fonts](https://pub.dev/packages/google_fonts) for custom fonts.

## Dependencies

- Flutter SDK: ^3.5.3
- cupertino_icons: ^1.0.8
- google_fonts: ^6.2.1
- google_mlkit_document_scanner: ^0.2.1
- sqflite: ^2.3.3+1

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/IlhamGhaza/flutter_scan_app/blob/main/LICENSE) file for details.
