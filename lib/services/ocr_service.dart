import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';

class OCRService {
  /// Extracts text from an image using Google ML Kit
  Future<String> extractText(File imageFile) async {
    try {
      // Initialize text recognizer
      final textRecognizer = TextRecognizer();
      
      // Process the image
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      // Extract text
      final StringBuffer extractedText = StringBuffer();
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          extractedText.writeln(line.text);
        }
      }
      
      // Clean up
      textRecognizer.close();
      
      return extractedText.toString().trim();
    } catch (e) {
      throw Exception('OCR extraction failed: $e');
    }
  }

  /// Extracts structured data from text
  /// This method can be extended to extract specific fields
  Future<Map<String, dynamic>> extractStructuredData(String text) async {
    final Map<String, dynamic> structuredData = {};
    
    // Example patterns for common document fields
    // You can extend this with more sophisticated parsing
    
    // Email pattern
    final emailPattern = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    final emails = emailPattern.allMatches(text).map((m) => m.group(0)).toList();
    if (emails.isNotEmpty) {
      structuredData['emails'] = emails;
    }
    
    // Phone pattern (simple)
    final phonePattern = RegExp(r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b');
    final phones = phonePattern.allMatches(text).map((m) => m.group(0)).toList();
    if (phones.isNotEmpty) {
      structuredData['phones'] = phones;
    }
    
    // Date pattern (MM/DD/YYYY or similar)
    final datePattern = RegExp(r'\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b');
    final dates = datePattern.allMatches(text).map((m) => m.group(0)).toList();
    if (dates.isNotEmpty) {
      structuredData['dates'] = dates;
    }
    
    // Number patterns (amounts, IDs, etc.)
    final numberPattern = RegExp(r'\b\d+\.?\d*\b');
    final numbers = numberPattern.allMatches(text).map((m) => m.group(0)).toList();
    if (numbers.isNotEmpty && numbers.length < 50) { // Limit to avoid too many numbers
      structuredData['numbers'] = numbers.take(10).toList();
    }
    
    structuredData['rawText'] = text;
    structuredData['wordCount'] = text.split(RegExp(r'\s+')).length;
    
    return structuredData;
  }
}
