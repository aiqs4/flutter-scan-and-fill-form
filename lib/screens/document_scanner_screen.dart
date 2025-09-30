import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/edge_detection_service.dart';
import '../services/ocr_service.dart';
import '../services/supabase_service.dart';
import 'result_screen.dart';

class DocumentScannerScreen extends StatefulWidget {
  const DocumentScannerScreen({super.key});

  @override
  State<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends State<DocumentScannerScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required')),
        );
      }
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) {
        return;
      }

      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _captureAndProcess() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final image = await _cameraController!.takePicture();
      await _processImage(File(image.path));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _processImage(File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      // Show processing dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing document...'),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      // Step 1: Edge Detection
      final edgeDetectionService = EdgeDetectionService();
      final processedImage = await edgeDetectionService.detectAndCrop(imageFile);

      // Step 2: OCR
      final ocrService = OCRService();
      final extractedText = await ocrService.extractText(processedImage);

      // Step 3: Upload to Supabase
      final supabaseService = SupabaseService();
      final uploadResult = await supabaseService.uploadDocument(
        extractedText,
        processedImage,
      );

      if (mounted) {
        Navigator.pop(context); // Close processing dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              extractedText: extractedText,
              processedImage: processedImage,
              uploadResult: uploadResult,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close processing dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing document: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Document'),
      ),
      body: _isInitialized
          ? Stack(
              children: [
                // Camera Preview
                SizedBox.expand(
                  child: CameraPreview(_cameraController!),
                ),
                // Edge detection overlay guide
                CustomPaint(
                  painter: EdgeGuidelinePainter(),
                  child: Container(),
                ),
                // Instructions
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Position document within the frame',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Capture button
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 'gallery',
                        onPressed: _isProcessing ? null : _pickFromGallery,
                        child: const Icon(Icons.photo_library),
                      ),
                      FloatingActionButton.large(
                        heroTag: 'capture',
                        onPressed: _isProcessing ? null : _captureAndProcess,
                        child: _isProcessing
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Icon(Icons.camera),
                      ),
                      const SizedBox(width: 56), // Spacer for symmetry
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

// Custom painter for edge detection guidelines
class EdgeGuidelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.2,
      size.width * 0.8,
      size.height * 0.6,
    );

    canvas.drawRect(rect, paint);

    // Draw corner markers
    final cornerLength = 20.0;
    final cornerPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Top-left corner
    canvas.drawLine(Offset(rect.left, rect.top), Offset(rect.left + cornerLength, rect.top), cornerPaint);
    canvas.drawLine(Offset(rect.left, rect.top), Offset(rect.left, rect.top + cornerLength), cornerPaint);

    // Top-right corner
    canvas.drawLine(Offset(rect.right, rect.top), Offset(rect.right - cornerLength, rect.top), cornerPaint);
    canvas.drawLine(Offset(rect.right, rect.top), Offset(rect.right, rect.top + cornerLength), cornerPaint);

    // Bottom-left corner
    canvas.drawLine(Offset(rect.left, rect.bottom), Offset(rect.left + cornerLength, rect.bottom), cornerPaint);
    canvas.drawLine(Offset(rect.left, rect.bottom), Offset(rect.left, rect.bottom - cornerLength), cornerPaint);

    // Bottom-right corner
    canvas.drawLine(Offset(rect.right, rect.bottom), Offset(rect.right - cornerLength, rect.bottom), cornerPaint);
    canvas.drawLine(Offset(rect.right, rect.bottom), Offset(rect.right, rect.bottom - cornerLength), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
