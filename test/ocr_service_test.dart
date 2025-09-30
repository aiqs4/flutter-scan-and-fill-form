// This is a basic test file template
// Run: flutter test

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scan_and_fill_form/services/ocr_service.dart';

void main() {
  group('OCR Service Tests', () {
    late OCRService ocrService;

    setUp(() {
      ocrService = OCRService();
    });

    test('extractStructuredData should extract emails', () async {
      const text = 'Contact us at support@example.com or info@test.org';
      final result = await ocrService.extractStructuredData(text);
      
      expect(result['emails'], isNotNull);
      expect(result['emails'], isA<List>());
      expect(result['emails'].length, 2);
      expect(result['emails'], contains('support@example.com'));
    });

    test('extractStructuredData should extract phone numbers', () async {
      const text = 'Call us at 555-123-4567 or 555.987.6543';
      final result = await ocrService.extractStructuredData(text);
      
      expect(result['phones'], isNotNull);
      expect(result['phones'], isA<List>());
      expect(result['phones'].length, 2);
    });

    test('extractStructuredData should extract dates', () async {
      const text = 'Invoice date: 01/15/2024 Due date: 02-20-2024';
      final result = await ocrService.extractStructuredData(text);
      
      expect(result['dates'], isNotNull);
      expect(result['dates'], isA<List>());
      expect(result['dates'].length, 2);
    });

    test('extractStructuredData should count words', () async {
      const text = 'This is a test sentence with seven words';
      final result = await ocrService.extractStructuredData(text);
      
      expect(result['wordCount'], 7);
    });

    test('extractStructuredData should include raw text', () async {
      const text = 'Sample document text';
      final result = await ocrService.extractStructuredData(text);
      
      expect(result['rawText'], text);
    });
  });

  group('Data Pattern Tests', () {
    test('Email pattern should match valid emails', () {
      final emailPattern = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
      
      expect(emailPattern.hasMatch('test@example.com'), true);
      expect(emailPattern.hasMatch('user.name+tag@example.co.uk'), true);
      expect(emailPattern.hasMatch('invalid@'), false);
      expect(emailPattern.hasMatch('@invalid.com'), false);
    });

    test('Phone pattern should match valid phone numbers', () {
      final phonePattern = RegExp(r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b');
      
      expect(phonePattern.hasMatch('555-123-4567'), true);
      expect(phonePattern.hasMatch('555.123.4567'), true);
      expect(phonePattern.hasMatch('5551234567'), true);
      expect(phonePattern.hasMatch('12345'), false);
    });

    test('Date pattern should match valid dates', () {
      final datePattern = RegExp(r'\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b');
      
      expect(datePattern.hasMatch('01/15/2024'), true);
      expect(datePattern.hasMatch('1-5-24'), true);
      expect(datePattern.hasMatch('12-31-2024'), true);
      expect(datePattern.hasMatch('2024'), false);
    });
  });
}
