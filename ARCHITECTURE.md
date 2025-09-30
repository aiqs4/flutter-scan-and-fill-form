# Architecture and Design Documentation

## Overview

This Flutter application implements a complete document scanning and OCR pipeline with cloud storage integration. The architecture follows clean separation of concerns with distinct layers for UI, business logic, and data management.

## Architecture Layers

### 1. Presentation Layer (UI)
- **HomeScreen**: Entry point with navigation to scanner
- **DocumentScannerScreen**: Camera interface with edge detection guidelines
- **ResultScreen**: Display scanned results and upload status

### 2. Service Layer (Business Logic)
- **EdgeDetectionService**: Image processing and document boundary detection
- **OCRService**: Text extraction and structured data parsing
- **SupabaseService**: Cloud storage and data organization

### 3. Data Layer
- Supabase PostgreSQL database
- Supabase Storage for images
- Local file system for temporary image storage

## Key Components

### Document Scanning Flow

```
Camera Capture → Edge Detection → Image Enhancement → OCR → Data Extraction → Upload
```

1. **Camera Capture**
   - Uses Flutter's camera plugin
   - Provides real-time preview
   - Visual guidelines for document positioning

2. **Edge Detection**
   - Grayscale conversion
   - Contrast enhancement
   - Boundary detection
   - Automatic cropping

3. **Image Enhancement**
   - Sharpening for better text clarity
   - Contrast adjustment
   - Color correction

4. **OCR Processing**
   - Google ML Kit text recognition
   - Multi-language support
   - Preserves text structure

5. **Data Extraction**
   - Pattern matching for structured data
   - Automatic field categorization
   - Validation and filtering

6. **Cloud Upload**
   - Document storage in Supabase
   - Structured data in separate table
   - Image storage in Supabase Storage

## Edge Detection Implementation

The edge detection service uses a simplified approach suitable for most documents:

### Preprocessing Steps
1. **Grayscale Conversion**: Reduces color complexity
2. **Contrast Enhancement**: Makes document edges more prominent
3. **Boundary Detection**: Identifies document borders
4. **Perspective Correction**: (Planned) Corrects skewed documents

### Enhancement Steps
1. **Cropping**: Removes background noise
2. **Sharpening**: Improves text clarity
3. **Color Adjustment**: Optimizes for OCR

### Limitations & Future Improvements
- Current implementation uses basic cropping
- Advanced edge detection (Canny, Hough Transform) can be added
- Perspective transformation for skewed documents
- Consider using native libraries for performance

## OCR Implementation

Uses Google ML Kit for on-device text recognition:

### Advantages
- Works offline
- Fast processing
- Good accuracy
- Multi-language support
- Free to use

### Text Processing
1. **Block-based recognition**: Preserves document structure
2. **Line-by-line extraction**: Maintains text flow
3. **Confidence scoring**: (Can be added) Quality metrics

### Structured Data Extraction

Pattern-based extraction for common fields:

```dart
- Emails: /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}/
- Phones: /\d{3}[-.]?\d{3}[-.]?\d{4}/
- Dates: /\d{1,2}[/-]\d{1,2}[/-]\d{2,4}/
- Numbers: /\d+\.?\d*/
```

## Supabase Integration

### Database Schema

**documents** table:
- Stores complete extracted text
- Links to image in storage
- Metadata (word count, timestamps)

**document_fields** table:
- Stores structured data fields
- Links to parent document
- Categorized by field type
- Enables filtering and searching

### Data Organization

Benefits of two-table approach:
1. **Flexibility**: Easy to add new field types
2. **Searchability**: Indexed fields for fast queries
3. **Scalability**: Grows with data complexity
4. **Maintainability**: Clean separation of concerns

### Security

- Row Level Security (RLS) enabled
- Public read, authenticated write (configurable)
- Storage policies for image access
- Secure API key usage

## State Management

Currently uses basic StatefulWidget approach:

### Current Implementation
- Local state in widgets
- Async operations with Future
- Error handling with try-catch

### Future Improvements
- Provider for global state
- Bloc for complex state flows
- Riverpod for modern state management

## Error Handling

### Camera Errors
- Permission denied
- Camera unavailable
- Capture failure

### Processing Errors
- Image decode failure
- OCR failure
- Network errors

### Upload Errors
- Authentication failure
- Network timeout
- Storage quota exceeded

All errors are caught and displayed to user with meaningful messages.

## Performance Considerations

### Image Processing
- Resize large images before processing
- Async operations prevent UI blocking
- Progress indicators for long operations

### Network Operations
- Retry logic for failed uploads
- Timeout handling
- Batch operations for multiple fields

### Memory Management
- Dispose controllers properly
- Clean up temporary files
- Limit image size

## Testing Strategy

### Unit Tests
- Service layer logic
- Data parsing functions
- Pattern matching

### Integration Tests
- Camera integration
- OCR processing
- Supabase operations

### Widget Tests
- UI components
- Navigation flow
- User interactions

## Deployment Considerations

### Android
- minSdk: 21 (Android 5.0+)
- Camera and storage permissions
- Internet permission
- ProGuard rules for release

### iOS
- iOS 12.0+
- Camera usage description
- Photo library access
- Network security configuration

### Environment Configuration
- Use --dart-define for secrets
- Different configs for dev/prod
- Never commit credentials

## Future Enhancements

### Features
1. **Batch Scanning**: Multiple documents in one session
2. **Document Templates**: Predefined extraction patterns
3. **Export Options**: PDF, CSV, JSON
4. **Offline Mode**: Queue uploads for later
5. **Document Management**: Edit, delete, organize
6. **Search Functionality**: Full-text search
7. **Sharing**: Export or share documents
8. **Multi-language UI**: Internationalization

### Technical Improvements
1. **Advanced Edge Detection**: ML-based boundary detection
2. **Better OCR**: Custom ML models for specific document types
3. **Caching**: Local database for offline access
4. **Compression**: Reduce image size before upload
5. **Authentication**: User accounts and data isolation
6. **Analytics**: Track usage and errors
7. **A/B Testing**: Test different OCR engines

### Performance
1. **Image Compression**: Reduce bandwidth usage
2. **Lazy Loading**: Load documents on demand
3. **Pagination**: Handle large document lists
4. **Background Processing**: Upload in background
5. **Web Workers**: Offload heavy processing

## Maintenance

### Regular Updates
- Update dependencies monthly
- Monitor deprecation warnings
- Test on new OS versions

### Monitoring
- Crash reporting (Firebase Crashlytics)
- Performance monitoring
- User feedback collection

### Documentation
- Keep README updated
- Document API changes
- Maintain changelog

## Contributing Guidelines

1. Follow Flutter style guide
2. Write tests for new features
3. Update documentation
4. Use meaningful commit messages
5. Create feature branches
6. Submit pull requests for review

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Google ML Kit](https://developers.google.com/ml-kit)
- [Supabase Documentation](https://supabase.com/docs)
- [Camera Plugin](https://pub.dev/packages/camera)
- [Image Processing in Dart](https://pub.dev/packages/image)
