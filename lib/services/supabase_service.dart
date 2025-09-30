import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ocr_service.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  final OCRService _ocrService = OCRService();

  /// Uploads document data to Supabase
  /// Creates both raw document entry and filtered/structured data
  Future<Map<String, dynamic>> uploadDocument(
    String extractedText,
    File processedImage,
  ) async {
    try {
      // Extract structured data from text
      final structuredData = await _ocrService.extractStructuredData(extractedText);
      
      // Upload image to Supabase Storage (if bucket exists)
      String? imageUrl;
      try {
        final imageName = 'document_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final imageBytes = await processedImage.readAsBytes();
        
        await _client.storage
            .from('documents')
            .uploadBinary(imageName, imageBytes);
        
        imageUrl = _client.storage.from('documents').getPublicUrl(imageName);
      } catch (storageError) {
        // Storage might not be configured, continue without image URL
        imageUrl = null;
      }

      // Insert document record
      final documentResponse = await _client
          .from('documents')
          .insert({
            'extracted_text': extractedText,
            'image_url': imageUrl,
            'created_at': DateTime.now().toIso8601String(),
            'word_count': structuredData['wordCount'],
          })
          .select()
          .single();

      final documentId = documentResponse['id'];

      // Insert structured data fields
      if (structuredData['emails'] != null && (structuredData['emails'] as List).isNotEmpty) {
        await _insertDataFields(documentId, 'email', structuredData['emails'] as List);
      }

      if (structuredData['phones'] != null && (structuredData['phones'] as List).isNotEmpty) {
        await _insertDataFields(documentId, 'phone', structuredData['phones'] as List);
      }

      if (structuredData['dates'] != null && (structuredData['dates'] as List).isNotEmpty) {
        await _insertDataFields(documentId, 'date', structuredData['dates'] as List);
      }

      if (structuredData['numbers'] != null && (structuredData['numbers'] as List).isNotEmpty) {
        await _insertDataFields(documentId, 'number', structuredData['numbers'] as List);
      }

      return {
        'success': true,
        'documentId': documentId,
        'message': 'Document uploaded successfully',
        'structuredData': structuredData,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Upload failed: ${e.toString()}',
      };
    }
  }

  /// Helper method to insert extracted data fields
  Future<void> _insertDataFields(int documentId, String fieldType, List values) async {
    final records = values.map((value) => {
      'document_id': documentId,
      'field_type': fieldType,
      'field_value': value.toString(),
      'created_at': DateTime.now().toIso8601String(),
    }).toList();

    await _client.from('document_fields').insert(records);
  }

  /// Retrieves all documents
  Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final response = await _client
          .from('documents')
          .select()
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }

  /// Retrieves a specific document with its fields
  Future<Map<String, dynamic>> getDocument(int documentId) async {
    try {
      final document = await _client
          .from('documents')
          .select()
          .eq('id', documentId)
          .single();

      final fields = await _client
          .from('document_fields')
          .select()
          .eq('document_id', documentId);

      return {
        'document': document,
        'fields': fields,
      };
    } catch (e) {
      throw Exception('Failed to fetch document: $e');
    }
  }

  /// Filters documents by field type and value
  Future<List<Map<String, dynamic>>> filterDocuments({
    String? fieldType,
    String? searchValue,
  }) async {
    try {
      var query = _client.from('document_fields').select('document_id, documents(*)');

      if (fieldType != null) {
        query = query.eq('field_type', fieldType);
      }

      if (searchValue != null) {
        query = query.ilike('field_value', '%$searchValue%');
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to filter documents: $e');
    }
  }
}
