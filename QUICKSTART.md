# Quick Start Guide

Get up and running with Flutter Scan and Fill Form in 5 minutes!

## Prerequisites Checklist

- [ ] Flutter SDK installed (run `flutter --version`)
- [ ] Android Studio or Xcode installed
- [ ] Supabase account created
- [ ] Git installed

## Step-by-Step Setup

### 1. Clone the Repository (1 minute)

```bash
git clone https://github.com/aiqs4/flutter-scan-and-fill-form.git
cd flutter-scan-and-fill-form
```

### 2. Install Dependencies (1 minute)

```bash
flutter pub get
```

### 3. Set Up Supabase (2 minutes)

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Wait for your project to be ready (~2 minutes)
3. Go to Settings → API to get your credentials:
   - Project URL (looks like: `https://xxxxx.supabase.co`)
   - Anon/Public key (starts with `eyJ...`)

4. In Supabase SQL Editor, paste and run the contents of `supabase/setup.sql`

### 4. Configure Your App (30 seconds)

Option A - Edit main.dart directly:
```dart
// lib/main.dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL_HERE',
  anonKey: 'YOUR_SUPABASE_ANON_KEY_HERE',
);
```

Option B - Use command line arguments:
```bash
flutter run \
  --dart-define=SUPABASE_URL=your_url \
  --dart-define=SUPABASE_ANON_KEY=your_key
```

### 5. Run the App (30 seconds)

```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For a specific device
flutter devices  # List available devices
flutter run -d <device_id>
```

## First Scan

1. Tap "Start Scanning"
2. Grant camera permissions
3. Position a document within the frame
4. Tap the camera button
5. Wait for processing
6. View your results!

## Verify Upload

Check your Supabase dashboard:
1. Go to Table Editor → `documents`
2. You should see your scanned document
3. Check `document_fields` for extracted data

## Troubleshooting

### Camera not working?
- Check permissions in device settings
- Restart the app
- Try selecting from gallery instead

### Supabase errors?
- Verify your credentials
- Check that SQL setup completed successfully
- Look at Supabase logs in the dashboard

### Build errors?
```bash
flutter clean
flutter pub get
flutter run
```

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Check [ARCHITECTURE.md](ARCHITECTURE.md) to understand the design
- See [CONTRIBUTING.md](CONTRIBUTING.md) to contribute

## Common Commands

```bash
# Run on specific device
flutter run -d <device>

# Run in release mode (faster)
flutter run --release

# Check for issues
flutter analyze

# Format code
dart format .

# Run tests
flutter test

# Build APK
flutter build apk

# Build iOS
flutter build ios
```

## Getting Help

- Check the [Issues](https://github.com/aiqs4/flutter-scan-and-fill-form/issues) page
- Create a new issue if your problem isn't listed
- Include error messages and device info

Happy scanning! 📸📄✨
