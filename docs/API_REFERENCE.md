# API Reference

Complete API documentation for Flutter Scan and Fill Form services.

## Table of Contents
- [EdgeDetectionService](#edgedetectionservice)
- [OCRService](#ocrservice)
- [SupabaseService](#supabaseservice)

---

## EdgeDetectionService

Service for detecting document edges and processing images.

### Constructor

```dart
EdgeDetectionService()
```

Creates a new instance of the edge detection service.

### Methods

#### detectAndCrop

```dart
Future<File> detectAndCrop(File imageFile) async
```

Detects document edges and crops the image to the document boundaries.

**Parameters:**
- `imageFile` (File): The input image file to process

**Returns:**
- `Future<File>`: Processed image file with document cropped

**Throws:**
- `Exception`: If image decoding or processing fails

**Example:**
```dart
final service = EdgeDetectionService();
final processedImage = await service.detectAndCrop(imageFile);
```

**Processing Steps:**
1. Decode image
2. Convert to grayscale
3. Enhance contrast
4. Detect boundaries
5. Crop to document
6. Apply sharpening
7. Save processed image

#### detectCorners

```dart
Future<List<Offset>> detectCorners(File imageFile) async
```

Detects the four corners of a document in an image.

**Parameters:**
- `imageFile` (File): The input image file

**Returns:**
- `Future<List<Offset>>`: List of 4 corner points [top-left, top-right, bottom-right, bottom-left]

**Throws:**
- `Exception`: If image decoding fails

**Example:**
```dart
final service = EdgeDetectionService();
final corners = await service.detectCorners(imageFile);
print('Top-left corner: ${corners[0].x}, ${corners[0].y}');
```

**Note:** Current implementation returns estimated corners. Production use should implement advanced corner detection algorithms.

---

## OCRService

Service for extracting text from images using Google ML Kit.

### Constructor

```dart
OCRService()
```

Creates a new instance of the OCR service.

### Methods

#### extractText

```dart
Future<String> extractText(File imageFile) async
```

Extracts all text from an image.

**Parameters:**
- `imageFile` (File): The image file to extract text from

**Returns:**
- `Future<String>`: Extracted text as a single string

**Throws:**
- `Exception`: If OCR processing fails

**Example:**
```dart
final ocrService = OCRService();
final text = await ocrService.extractText(imageFile);
print('Extracted text: $text');
```

**Features:**
- Multi-language support
- Text block recognition
- Line-by-line extraction
- Structure preservation

#### extractStructuredData

```dart
Future<Map<String, dynamic>> extractStructuredData(String text) async
```

Extracts structured data from text using pattern matching.

**Parameters:**
- `text` (String): The text to parse

**Returns:**
- `Future<Map<String, dynamic>>`: Dictionary containing:
  - `emails` (List<String>?): Extracted email addresses
  - `phones` (List<String>?): Extracted phone numbers
  - `dates` (List<String>?): Extracted dates
  - `numbers` (List<String>?): Extracted numerical values
  - `rawText` (String): Original text
  - `wordCount` (int): Number of words

**Example:**
```dart
final ocrService = OCRService();
final structuredData = await ocrService.extractStructuredData(text);

print('Found emails: ${structuredData['emails']}');
print('Word count: ${structuredData['wordCount']}');
```

**Supported Patterns:**
- **Emails**: `[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}`
- **Phones**: `\d{3}[-.]?\d{3}[-.]?\d{4}`
- **Dates**: `\d{1,2}[/-]\d{1,2}[/-]\d{2,4}`
- **Numbers**: `\d+\.?\d*`

---

## SupabaseService

Service for uploading and managing documents in Supabase.

### Constructor

```dart
SupabaseService()
```

Creates a new instance of the Supabase service. Uses the globally initialized Supabase client.

### Properties

- `_client`: The Supabase client instance
- `_ocrService`: Internal OCR service for data extraction

### Methods

#### uploadDocument

```dart
Future<Map<String, dynamic>> uploadDocument(
  String extractedText,
  File processedImage,
) async
```

Uploads a document with extracted text and image to Supabase.

**Parameters:**
- `extractedText` (String): The OCR-extracted text
- `processedImage` (File): The processed document image

**Returns:**
- `Future<Map<String, dynamic>>`: Upload result containing:
  - `success` (bool): Whether upload succeeded
  - `documentId` (int?): ID of uploaded document
  - `message` (String): Success or error message
  - `structuredData` (Map?): Extracted structured data

**Example:**
```dart
final service = SupabaseService();
final result = await service.uploadDocument(extractedText, imageFile);

if (result['success']) {
  print('Document ID: ${result['documentId']}');
} else {
  print('Error: ${result['message']}');
}
```

**Process:**
1. Extract structured data from text
2. Upload image to Supabase Storage (if configured)
3. Insert document record in `documents` table
4. Insert extracted fields in `document_fields` table
5. Return result with document ID

#### getDocuments

```dart
Future<List<Map<String, dynamic>>> getDocuments() async
```

Retrieves all documents from the database.

**Returns:**
- `Future<List<Map<String, dynamic>>>`: List of all documents

**Throws:**
- `Exception`: If database query fails

**Example:**
```dart
final service = SupabaseService();
final documents = await service.getDocuments();

for (var doc in documents) {
  print('Document ${doc['id']}: ${doc['extracted_text']}');
}
```

**Sorting:** Results are sorted by `created_at` descending (newest first).

#### getDocument

```dart
Future<Map<String, dynamic>> getDocument(int documentId) async
```

Retrieves a specific document with all its extracted fields.

**Parameters:**
- `documentId` (int): The ID of the document to retrieve

**Returns:**
- `Future<Map<String, dynamic>>`: Dictionary containing:
  - `document` (Map): Document record
  - `fields` (List): List of extracted field records

**Throws:**
- `Exception`: If document not found or query fails

**Example:**
```dart
final service = SupabaseService();
final result = await service.getDocument(123);

print('Document: ${result['document']}');
print('Fields: ${result['fields']}');
```

#### filterDocuments

```dart
Future<List<Map<String, dynamic>>> filterDocuments({
  String? fieldType,
  String? searchValue,
}) async
```

Filters documents by field type and/or value.

**Parameters:**
- `fieldType` (String?, optional): Filter by field type (e.g., 'email', 'phone', 'date')
- `searchValue` (String?, optional): Search for specific value (case-insensitive)

**Returns:**
- `Future<List<Map<String, dynamic>>>`: List of matching documents with their fields

**Throws:**
- `Exception`: If database query fails

**Example:**
```dart
final service = SupabaseService();

// Find all documents with email fields
final emailDocs = await service.filterDocuments(fieldType: 'email');

// Find documents containing a specific email
final specificDocs = await service.filterDocuments(
  fieldType: 'email',
  searchValue: 'john@example.com',
);

// Search all fields for a value
final searchResults = await service.filterDocuments(
  searchValue: '555-1234',
);
```

**Search Features:**
- Case-insensitive search
- Partial matching with wildcards
- Combine field type and value filters
- Returns documents with matching fields

---

## Database Schema

### documents Table

| Column | Type | Description |
|--------|------|-------------|
| id | BIGINT | Primary key, auto-increment |
| extracted_text | TEXT | Full OCR-extracted text |
| image_url | TEXT | URL of uploaded image in storage |
| word_count | INTEGER | Number of words in extracted text |
| created_at | TIMESTAMPTZ | Document creation timestamp |
| updated_at | TIMESTAMPTZ | Last update timestamp |

### document_fields Table

| Column | Type | Description |
|--------|------|-------------|
| id | BIGINT | Primary key, auto-increment |
| document_id | BIGINT | Foreign key to documents table |
| field_type | TEXT | Type of field (email, phone, date, number) |
| field_value | TEXT | Extracted field value |
| created_at | TIMESTAMPTZ | Field creation timestamp |

**Indexes:**
- `idx_document_fields_document_id`: On document_id
- `idx_document_fields_type`: On field_type
- `idx_document_fields_value`: On field_value

---

## Error Handling

All services use exception handling. Wrap calls in try-catch:

```dart
try {
  final result = await service.uploadDocument(text, image);
  // Handle success
} catch (e) {
  print('Error: $e');
  // Handle error
}
```

**Common Exceptions:**
- `Exception('Edge detection failed')`: Image processing error
- `Exception('OCR extraction failed')`: Text recognition error
- `Exception('Upload failed')`: Supabase upload error
- `Exception('Failed to fetch documents')`: Database query error

---

## Usage Examples

### Complete Scanning Workflow

```dart
// 1. Capture image
final XFile image = await _picker.pickImage(source: ImageSource.camera);
final imageFile = File(image.path);

// 2. Detect edges and crop
final edgeService = EdgeDetectionService();
final processedImage = await edgeService.detectAndCrop(imageFile);

// 3. Extract text
final ocrService = OCRService();
final extractedText = await ocrService.extractText(processedImage);

// 4. Upload to Supabase
final supabaseService = SupabaseService();
final result = await supabaseService.uploadDocument(
  extractedText,
  processedImage,
);

// 5. Handle result
if (result['success']) {
  print('Document uploaded! ID: ${result['documentId']}');
} else {
  print('Upload failed: ${result['message']}');
}
```

### Searching Documents

```dart
final service = SupabaseService();

// Get all documents
final allDocs = await service.getDocuments();

// Filter by email addresses
final emailDocs = await service.filterDocuments(fieldType: 'email');

// Search for specific phone number
final phoneDocs = await service.filterDocuments(
  fieldType: 'phone',
  searchValue: '555-1234',
);

// Get specific document with fields
final doc = await service.getDocument(123);
print('Text: ${doc['document']['extracted_text']}');
print('Fields: ${doc['fields']}');
```

---

## Best Practices

1. **Dispose resources:**
   ```dart
   textRecognizer.close(); // In OCRService
   ```

2. **Handle errors gracefully:**
   ```dart
   try {
     final result = await service.method();
   } catch (e) {
     // Show user-friendly error message
   }
   ```

3. **Optimize image size:**
   ```dart
   // Resize before processing
   final resized = img.copyResize(image, width: 1024);
   ```

4. **Clean up temporary files:**
   ```dart
   if (await tempFile.exists()) {
     await tempFile.delete();
   }
   ```

5. **Use appropriate error handling:**
   ```dart
   if (result['success']) {
     // Handle success
   } else {
     // Handle failure
   }
   ```

---

## Performance Considerations

- **Image Size**: Larger images take longer to process
- **OCR Speed**: Typically 1-3 seconds per document
- **Network**: Upload time depends on connection speed
- **Storage**: Consider image compression for large volumes

---

## Future Enhancements

Planned API additions:

1. Batch processing methods
2. Custom pattern recognition
3. Document template matching
4. Real-time edge detection callbacks
5. Progress callbacks for long operations
6. Caching and offline support

---

For more information, see:
- [README.md](../README.md)
- [ARCHITECTURE.md](../ARCHITECTURE.md)
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
