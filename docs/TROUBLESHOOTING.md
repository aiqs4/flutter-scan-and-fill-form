# Troubleshooting Guide

Common issues and solutions for Flutter Scan and Fill Form.

## Table of Contents
- [Installation Issues](#installation-issues)
- [Camera Issues](#camera-issues)
- [OCR Issues](#ocr-issues)
- [Supabase Issues](#supabase-issues)
- [Build Issues](#build-issues)
- [Runtime Errors](#runtime-errors)

---

## Installation Issues

### Issue: `flutter pub get` fails

**Error Message:**
```
Error: Unable to resolve dependencies
```

**Solutions:**
1. Check your Flutter version:
   ```bash
   flutter --version
   # Ensure you have Flutter 3.0.0 or higher
   ```

2. Update Flutter:
   ```bash
   flutter upgrade
   ```

3. Clean and reinstall:
   ```bash
   flutter clean
   flutter pub get
   ```

4. Check pubspec.yaml for syntax errors

### Issue: Dependency conflicts

**Error Message:**
```
Because package_a depends on package_b...
```

**Solutions:**
1. Update dependencies:
   ```bash
   flutter pub upgrade
   ```

2. Check for package compatibility:
   ```bash
   flutter pub outdated
   ```

3. Manually adjust version constraints in `pubspec.yaml`

---

## Camera Issues

### Issue: Camera permission denied

**Symptoms:**
- App crashes when accessing camera
- "Camera permission required" message

**Solutions:**

**For Android:**
1. Check `AndroidManifest.xml` has camera permissions
2. Manually grant permissions in device settings:
   - Settings → Apps → Your App → Permissions → Camera → Allow
3. Reinstall the app:
   ```bash
   flutter clean
   flutter run
   ```

**For iOS:**
1. Check `Info.plist` has camera usage description
2. Go to Settings → Privacy → Camera → Enable for your app
3. Reinstall the app

### Issue: Camera not initializing

**Error Message:**
```
Error initializing camera
```

**Solutions:**
1. Check if camera is available:
   ```dart
   final cameras = await availableCameras();
   print('Available cameras: ${cameras.length}');
   ```

2. Close other apps using the camera

3. Restart the device

4. Check if running on an emulator without camera support

### Issue: Camera preview is black or frozen

**Solutions:**
1. Ensure proper async initialization:
   ```dart
   await _cameraController!.initialize();
   ```

2. Check camera disposal in `dispose()`:
   ```dart
   @override
   void dispose() {
     _cameraController?.dispose();
     super.dispose();
   }
   ```

3. Try a different resolution:
   ```dart
   CameraController(
     camera,
     ResolutionPreset.medium, // Try different presets
   );
   ```

---

## OCR Issues

### Issue: No text detected

**Symptoms:**
- OCR returns empty string
- "No text detected" message

**Solutions:**
1. **Improve image quality:**
   - Ensure good lighting
   - Hold camera steady
   - Avoid shadows
   - Clean camera lens

2. **Adjust image preprocessing:**
   - Increase contrast
   - Try different image enhancements

3. **Check document type:**
   - Ensure text is clear and readable
   - Try with a different document

### Issue: Poor OCR accuracy

**Symptoms:**
- Text is garbled or incorrect
- Missing characters or words

**Solutions:**
1. **Image quality:**
   - Use higher resolution
   - Better lighting conditions
   - Avoid glare and shadows

2. **Document positioning:**
   - Keep document flat
   - Fill the frame
   - Avoid skewed angles

3. **Text characteristics:**
   - Minimum font size: 12pt
   - Clear, printed text works best
   - Avoid fancy fonts

### Issue: OCR is slow

**Solutions:**
1. Reduce image size before OCR:
   ```dart
   final resized = img.copyResize(image, width: 1024);
   ```

2. Use lower camera resolution

3. Process on background isolate

---

## Supabase Issues

### Issue: "Invalid API key"

**Error Message:**
```
Invalid API key
```

**Solutions:**
1. Verify your Supabase credentials:
   - Project URL is correct
   - Using the anon/public key (not service role key)
   - No extra spaces or characters

2. Check environment variables:
   ```bash
   flutter run --dart-define=SUPABASE_URL=your_url
   ```

3. Regenerate API key if compromised

### Issue: "Row level security policy violated"

**Error Message:**
```
new row violates row-level security policy
```

**Solutions:**
1. Check RLS policies in Supabase dashboard:
   - Table Editor → Your table → Policies
   
2. Add appropriate policy:
   ```sql
   CREATE POLICY "Enable insert for all users" ON documents
     FOR INSERT WITH CHECK (true);
   ```

3. Temporarily disable RLS for testing:
   ```sql
   ALTER TABLE documents DISABLE ROW LEVEL SECURITY;
   ```
   **Note:** Re-enable in production!

### Issue: Upload fails with network error

**Error Message:**
```
Network error
Failed to upload document
```

**Solutions:**
1. **Check internet connection:**
   - Verify device has internet access
   - Try on different network

2. **Check Supabase status:**
   - Visit [status.supabase.com](https://status.supabase.com)

3. **Increase timeout:**
   ```dart
   final client = SupabaseClient(
     url,
     key,
     httpClient: http.Client()..timeout = Duration(seconds: 30),
   );
   ```

4. **Verify table exists:**
   - Check Supabase Table Editor
   - Ensure schema matches expected structure

### Issue: Storage bucket not found

**Error Message:**
```
Bucket not found
```

**Solutions:**
1. Create the `documents` bucket:
   - Go to Storage in Supabase dashboard
   - Create new bucket named `documents`

2. Check bucket name matches code:
   ```dart
   await _client.storage.from('documents').upload(...);
   ```

3. Verify storage policies are set

---

## Build Issues

### Issue: Android build fails

**Error Message:**
```
Execution failed for task ':app:processDebugResources'
```

**Solutions:**
1. **Update Gradle:**
   - Check `android/build.gradle`
   - Update to latest stable versions

2. **Clean build:**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter build apk
   ```

3. **Check minSdkVersion:**
   ```gradle
   defaultConfig {
       minSdk 21  // Required for camera and ML Kit
   }
   ```

### Issue: iOS build fails

**Error Message:**
```
CocoaPods not installed or not in valid state
```

**Solutions:**
1. **Install/Update CocoaPods:**
   ```bash
   sudo gem install cocoapods
   ```

2. **Clean and reinstall:**
   ```bash
   cd ios
   rm -rf Pods Podfile.lock
   pod install
   cd ..
   flutter clean
   flutter build ios
   ```

3. **Update iOS deployment target:**
   - Open `ios/Podfile`
   - Ensure: `platform :ios, '12.0'`

---

## Runtime Errors

### Issue: "Platform exception"

**Error Message:**
```
PlatformException(...)
```

**Solutions:**
1. Check platform-specific permissions

2. Ensure plugin is properly installed:
   ```bash
   flutter clean
   flutter pub get
   ```

3. Check plugin version compatibility

### Issue: App crashes on launch

**Solutions:**
1. **Check logs:**
   ```bash
   flutter logs
   ```

2. **Common causes:**
   - Missing permissions
   - Invalid Supabase credentials
   - Network issues on startup

3. **Debug mode:**
   ```bash
   flutter run --verbose
   ```

### Issue: Memory issues

**Symptoms:**
- App becomes slow
- Crashes after multiple scans

**Solutions:**
1. **Dispose resources properly:**
   ```dart
   @override
   void dispose() {
     _cameraController?.dispose();
     super.dispose();
   }
   ```

2. **Clear temporary files:**
   ```dart
   final tempFile = File('temp.jpg');
   if (await tempFile.exists()) {
     await tempFile.delete();
   }
   ```

3. **Reduce image size:**
   ```dart
   final compressed = img.copyResize(image, width: 1024);
   ```

---

## General Debugging Tips

### Enable verbose logging

```dart
// In main.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable logging
  debugPrint('App starting...');
  
  runApp(MyApp());
}
```

### Check device logs

**Android:**
```bash
adb logcat
```

**iOS:**
```bash
# In Xcode: Window → Devices and Simulators → Your Device → Open Console
```

### Use Flutter DevTools

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### Test on real devices

Emulators may have limitations:
- No camera access
- Different performance characteristics
- Network simulation issues

---

## Getting Help

If you're still experiencing issues:

1. **Search existing issues:**
   - [GitHub Issues](https://github.com/aiqs4/flutter-scan-and-fill-form/issues)

2. **Create a new issue:**
   - Include error messages
   - Device and OS information
   - Steps to reproduce
   - Screenshots if applicable

3. **Community resources:**
   - [Flutter Discord](https://discord.gg/flutter)
   - [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
   - [Supabase Discord](https://discord.supabase.com)

## Reporting Bugs

When reporting bugs, include:

```
### Environment
- Flutter version: 
- Dart version:
- Device: 
- OS version:

### Description
[Clear description of the issue]

### Steps to Reproduce
1. 
2. 
3. 

### Expected Behavior
[What you expected to happen]

### Actual Behavior
[What actually happened]

### Error Messages
```
[Full error message and stack trace]
```

### Screenshots
[If applicable]
```

---

## FAQ

**Q: Does this work offline?**
A: OCR works offline, but upload requires internet connection.

**Q: Which languages are supported for OCR?**
A: Google ML Kit supports 100+ languages. Most common languages work out of the box.

**Q: Can I use a different backend instead of Supabase?**
A: Yes, modify the `SupabaseService` to work with your preferred backend.

**Q: How do I improve OCR accuracy?**
A: Use good lighting, keep document flat, use higher resolution, and ensure text is clear.

**Q: Is this production-ready?**
A: Yes, but test thoroughly with your specific use cases and add error handling as needed.
