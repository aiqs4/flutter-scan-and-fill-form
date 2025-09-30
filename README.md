# Flutter Scan and Fill Form

A Flutter application that automatically detects document edges using the device's camera, scans documents, performs OCR (Optical Character Recognition), and uploads extracted data to Supabase.

## Features

- **Automatic Document Edge Detection**: Uses camera preview with visual guidelines to help users position documents correctly
- **Document Scanning**: Captures and processes document images with automatic edge detection and image enhancement
- **OCR (Optical Character Recognition)**: Extracts text from scanned documents using Google ML Kit
- **Structured Data Extraction**: Automatically identifies and extracts emails, phone numbers, dates, and other structured data
- **Supabase Integration**: Uploads extracted text and structured data to Supabase for storage and filtering
- **Organized Data Tables**: Filters and organizes data into relevant tables in Supabase

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode (for mobile development)
- A Supabase account and project

## Installation

1. Clone the repository:
```bash
git clone https://github.com/aiqs4/flutter-scan-and-fill-form.git
cd flutter-scan-and-fill-form
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up Supabase:
   - Create a new project at [supabase.com](https://supabase.com)
   - Create the required tables (see Database Schema section below)
   - Copy your project URL and anon key

4. Configure environment variables:

Create a `.env` file in the root directory or pass them as compile-time variables:

```bash
# Using command line
flutter run --dart-define=SUPABASE_URL=your_supabase_url --dart-define=SUPABASE_ANON_KEY=your_anon_key

# Or set in your IDE/editor configuration
```

Alternatively, you can directly edit the `lib/main.dart` file and replace the placeholder values.

## Database Schema

Create the following tables in your Supabase project:

### Documents Table
```sql
CREATE TABLE documents (
  id BIGSERIAL PRIMARY KEY,
  extracted_text TEXT,
  image_url TEXT,
  word_count INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- Create policy for authenticated users
CREATE POLICY "Enable all access for authenticated users" ON documents
  FOR ALL USING (auth.role() = 'authenticated');
```

### Document Fields Table
```sql
CREATE TABLE document_fields (
  id BIGSERIAL PRIMARY KEY,
  document_id BIGINT REFERENCES documents(id) ON DELETE CASCADE,
  field_type TEXT,
  field_value TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE document_fields ENABLE ROW LEVEL SECURITY;

-- Create policy for authenticated users
CREATE POLICY "Enable all access for authenticated users" ON document_fields
  FOR ALL USING (auth.role() = 'authenticated');

-- Create index for faster queries
CREATE INDEX idx_document_fields_document_id ON document_fields(document_id);
CREATE INDEX idx_document_fields_type ON document_fields(field_type);
```

### Storage Bucket
```sql
-- Create a storage bucket for document images
INSERT INTO storage.buckets (id, name, public)
VALUES ('documents', 'documents', true);

-- Create policy for authenticated users
CREATE POLICY "Enable all access for authenticated users" ON storage.objects
  FOR ALL USING (bucket_id = 'documents' AND auth.role() = 'authenticated');
```

## Usage

1. **Launch the app**:
```bash
flutter run
```

2. **Scanning a document**:
   - Tap "Start Scanning" on the home screen
   - Grant camera permissions when prompted
   - Position the document within the on-screen guidelines
   - Tap the camera button to capture
   - Or tap the gallery icon to select an existing image

3. **Processing**:
   - The app will automatically detect document edges
   - Apply image enhancements for better OCR results
   - Extract text using Google ML Kit OCR
   - Parse structured data (emails, phones, dates, numbers)
   - Upload to Supabase

4. **View Results**:
   - See the processed document image
   - Review extracted text
   - Check upload status and document ID

## Project Structure

```
lib/
├── main.dart                           # App entry point and Supabase initialization
├── screens/
│   ├── home_screen.dart               # Home screen with start button
│   ├── document_scanner_screen.dart   # Camera screen with edge detection
│   └── result_screen.dart             # Display scan results
├── services/
│   ├── edge_detection_service.dart    # Document edge detection and cropping
│   ├── ocr_service.dart               # OCR text extraction and parsing
│   └── supabase_service.dart          # Supabase integration
├── models/                            # Data models (if needed)
└── utils/                             # Utility functions (if needed)
```

## Dependencies

- **camera**: Camera access and preview
- **image_picker**: Select images from gallery
- **image**: Image processing and manipulation
- **google_ml_kit**: OCR text recognition
- **supabase_flutter**: Supabase client
- **provider**: State management
- **path_provider**: File system access
- **permission_handler**: Runtime permissions

## Platform-Specific Configuration

### Android
Minimum SDK: 21 (Android 5.0)
Permissions are automatically handled via `AndroidManifest.xml`

### iOS
Minimum iOS: 12.0
Camera and Photo Library permissions are configured in `Info.plist`

## Features Explanation

### Edge Detection
The app uses image processing techniques to:
- Convert images to grayscale
- Apply contrast enhancement
- Detect document boundaries
- Crop and straighten the document
- Apply sharpening for better OCR

### OCR Processing
Using Google ML Kit, the app:
- Recognizes text in multiple languages
- Maintains text structure (blocks, lines)
- Handles various fonts and sizes
- Works in different lighting conditions

### Data Extraction
The app automatically extracts:
- **Emails**: Validates email format
- **Phone Numbers**: Detects various phone formats
- **Dates**: Recognizes date patterns
- **Numbers**: Extracts numerical values
- **Raw Text**: Stores complete extracted text

### Supabase Integration
Data is organized in two tables:
- **documents**: Main document records with full text
- **document_fields**: Filtered and structured data fields

This allows for:
- Easy searching by field type
- Filtering by specific values
- Linking related data
- Scalable data organization

## Troubleshooting

### Camera not working
- Ensure camera permissions are granted
- Check device camera availability
- Restart the app

### OCR not accurate
- Ensure good lighting conditions
- Hold camera steady
- Position document within guidelines
- Try different angles or lighting

### Supabase upload fails
- Check internet connection
- Verify Supabase credentials
- Ensure tables are created
- Check row-level security policies

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Google ML Kit for OCR functionality
- Supabase for backend infrastructure
- Flutter community for excellent packages