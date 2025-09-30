import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String extractedText;
  final File processedImage;
  final Map<String, dynamic> uploadResult;

  const ResultScreen({
    super.key,
    required this.extractedText,
    required this.processedImage,
    required this.uploadResult,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Results'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Processed Image
            const Text(
              'Processed Document',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                processedImage,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            
            // Extracted Text
            const Text(
              'Extracted Text (OCR)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                extractedText.isEmpty 
                    ? 'No text detected in the document'
                    : extractedText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            
            // Upload Status
            const Text(
              'Upload Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: uploadResult['success'] == true
                    ? Colors.green[50]
                    : Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: uploadResult['success'] == true
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        uploadResult['success'] == true
                            ? Icons.check_circle
                            : Icons.error,
                        color: uploadResult['success'] == true
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        uploadResult['success'] == true
                            ? 'Successfully uploaded to Supabase'
                            : 'Upload failed',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (uploadResult['documentId'] != null) ...[
                    const SizedBox(height: 8),
                    Text('Document ID: ${uploadResult['documentId']}'),
                  ],
                  if (uploadResult['message'] != null) ...[
                    const SizedBox(height: 8),
                    Text(uploadResult['message']),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
