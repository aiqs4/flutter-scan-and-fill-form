# Visual Workflow Guide

This document provides a visual representation of the document scanning workflow.

## Application Flow

```
┌─────────────────────────────────────────────────────────────┐
│                        APP LAUNCH                            │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Initialize Supabase                                  │  │
│  │  • Connect to Supabase backend                        │  │
│  │  • Verify credentials                                 │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      HOME SCREEN                             │
│                                                              │
│  ┌────────────────────────────────────────────────┐         │
│  │  📄 Document Scanner & OCR                      │         │
│  │                                                 │         │
│  │  Scan documents with automatic edge detection  │         │
│  │  Extract text and upload to Supabase           │         │
│  │                                                 │         │
│  │         [Start Scanning] Button                │         │
│  └────────────────────────────────────────────────┘         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                  CAMERA PERMISSIONS                          │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  📷 Camera Permission Required                        │  │
│  │                                                       │  │
│  │  This app needs camera access to scan documents      │  │
│  │                                                       │  │
│  │  [Allow]  [Deny]                                     │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                DOCUMENT SCANNER SCREEN                       │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  ╔═══════════════════════════════════════════════╗  │  │
│  │  ║  CAMERA PREVIEW                               ║  │  │
│  │  ║                                               ║  │  │
│  │  ║    ┌─────────────────────────────────┐       ║  │  │
│  │  ║    │ Position document within frame  │       ║  │  │
│  │  ║    └─────────────────────────────────┘       ║  │  │
│  │  ║                                               ║  │  │
│  │  ║       ╭─────────────────────────╮            ║  │  │
│  │  ║       │                         │            ║  │  │
│  │  ║       │    [Your Document]      │            ║  │  │
│  │  ║       │                         │            ║  │  │
│  │  ║       ╰─────────────────────────╯            ║  │  │
│  │  ║                                               ║  │  │
│  │  ║                                               ║  │  │
│  │  ╚═══════════════════════════════════════════════╝  │  │
│  │                                                      │  │
│  │      [📚 Gallery]   [📷 CAPTURE]                    │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    IMAGE CAPTURED                            │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  ⏳ Processing document...                           │  │
│  │                                                       │  │
│  │  • Detecting edges                                   │  │
│  │  • Enhancing image                                   │  │
│  │  • Extracting text                                   │  │
│  │  • Uploading to Supabase                            │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│               EDGE DETECTION & PROCESSING                    │
│                                                              │
│  Step 1: Convert to Grayscale                               │
│  ┌───────────┐        ┌───────────┐                        │
│  │ Color     │   →    │ Grayscale │                        │
│  │ Image     │        │ Image     │                        │
│  └───────────┘        └───────────┘                        │
│                                                              │
│  Step 2: Enhance Contrast                                   │
│  ┌───────────┐        ┌───────────┐                        │
│  │ Grayscale │   →    │ Enhanced  │                        │
│  │ Image     │        │ Image     │                        │
│  └───────────┘        └───────────┘                        │
│                                                              │
│  Step 3: Detect & Crop Document                             │
│  ┌───────────┐        ┌───────────┐                        │
│  │ Enhanced  │   →    │ Cropped   │                        │
│  │ Image     │        │ Document  │                        │
│  └───────────┘        └───────────┘                        │
│                                                              │
│  Step 4: Sharpen for OCR                                    │
│  ┌───────────┐        ┌───────────┐                        │
│  │ Cropped   │   →    │ Final     │                        │
│  │ Document  │        │ Image     │                        │
│  └───────────┘        └───────────┘                        │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    OCR PROCESSING                            │
│                                                              │
│  Google ML Kit Text Recognition                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  1. Analyze image blocks                             │  │
│  │  2. Identify text lines                              │  │
│  │  3. Recognize characters                             │  │
│  │  4. Extract complete text                            │  │
│  └──────────────────────────────────────────────────────┘  │
│                            │                                 │
│                            ▼                                 │
│  Structured Data Extraction                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  📧 Emails:  john@example.com                        │  │
│  │  📞 Phones:  555-123-4567                            │  │
│  │  📅 Dates:   01/15/2024                              │  │
│  │  🔢 Numbers: 12345, 250.00                           │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                  SUPABASE UPLOAD                             │
│                                                              │
│  Step 1: Upload Image to Storage                           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Storage Bucket: "documents"                         │  │
│  │  File: document_1234567890.jpg                       │  │
│  │  URL: https://...supabase.co/storage/.../image.jpg  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  Step 2: Insert Document Record                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Table: documents                                     │  │
│  │  - extracted_text: "Full text..."                    │  │
│  │  - image_url: "https://..."                          │  │
│  │  - word_count: 142                                   │  │
│  │  - created_at: 2024-01-15 10:30:00                  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  Step 3: Insert Structured Fields                           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Table: document_fields                              │  │
│  │  - document_id: 123                                  │  │
│  │  - field_type: "email"                               │  │
│  │  - field_value: "john@example.com"                   │  │
│  │  (repeated for each extracted field)                 │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    RESULT SCREEN                             │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Processed Document                                   │  │
│  │  ╔═══════════════════════════════════════╗           │  │
│  │  ║                                       ║           │  │
│  │  ║     [Processed Image]                ║           │  │
│  │  ║                                       ║           │  │
│  │  ╚═══════════════════════════════════════╝           │  │
│  │                                                       │  │
│  │  Extracted Text (OCR)                                │  │
│  │  ┌─────────────────────────────────────────┐         │  │
│  │  │ John Doe                                │         │  │
│  │  │ Email: john@example.com                 │         │  │
│  │  │ Phone: 555-123-4567                     │         │  │
│  │  │ Date: 01/15/2024                        │         │  │
│  │  └─────────────────────────────────────────┘         │  │
│  │                                                       │  │
│  │  Upload Status                                       │  │
│  │  ┌─────────────────────────────────────────┐         │  │
│  │  │ ✅ Successfully uploaded to Supabase    │         │  │
│  │  │ Document ID: 123                        │         │  │
│  │  └─────────────────────────────────────────┘         │  │
│  │                                                       │  │
│  │         [🏠 Back to Home]                            │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                         CLIENT (Flutter App)                      │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────────────┐    │
│  │   UI Layer  │  │  Services   │  │   Data Models        │    │
│  │             │  │             │  │                      │    │
│  │ • Home      │→ │ • Edge      │→ │ • Document           │    │
│  │ • Scanner   │  │   Detection │  │ • OCR Result         │    │
│  │ • Result    │  │ • OCR       │  │ • Upload Result      │    │
│  │             │  │ • Supabase  │  │                      │    │
│  └─────────────┘  └─────────────┘  └──────────────────────┘    │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTP/REST API
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                      SUPABASE (Backend)                           │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐  │
│  │   PostgreSQL DB  │  │  Storage Bucket  │  │  Auth        │  │
│  │                  │  │                  │  │              │  │
│  │ • documents      │  │ • document       │  │ • API Keys   │  │
│  │   table          │  │   images         │  │ • RLS        │  │
│  │ • document_      │  │                  │  │   Policies   │  │
│  │   fields table   │  │                  │  │              │  │
│  └──────────────────┘  └──────────────────┘  └──────────────┘  │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

## Database Relationships

```
┌─────────────────────────────────────────┐
│         documents (Main Table)          │
├─────────────────────────────────────────┤
│ • id (PK)                               │
│ • extracted_text                        │
│ • image_url                             │
│ • word_count                            │
│ • created_at                            │
│ • updated_at                            │
└─────────────────────────────────────────┘
                    │
                    │ 1
                    │
                    │ has many
                    │
                    │ n
                    ▼
┌─────────────────────────────────────────┐
│   document_fields (Structured Data)     │
├─────────────────────────────────────────┤
│ • id (PK)                               │
│ • document_id (FK) ───────────────────┐ │
│ • field_type                          │ │
│ • field_value                         │ │
│ • created_at                          │ │
└───────────────────────────────────────┼─┘
                                        │
                    ┌───────────────────┘
                    │
                    └─ References documents(id)
                       ON DELETE CASCADE
```

## State Transitions

```
┌──────────┐
│  Initial │
└────┬─────┘
     │
     │ User taps "Start Scanning"
     ▼
┌─────────────────┐
│ Request         │
│ Permissions     │
└────┬────────────┘
     │
     │ Permission Granted
     ▼
┌─────────────────┐
│ Camera          │
│ Active          │
└────┬────────────┘
     │
     │ User captures image
     ▼
┌─────────────────┐
│ Processing      │
│ (Loading)       │
└────┬────────────┘
     │
     │ Processing complete
     ▼
┌─────────────────┐
│ Results         │
│ Display         │
└────┬────────────┘
     │
     │ User taps "Back to Home"
     ▼
┌──────────┐
│  Initial │
└──────────┘
```

## Error Handling Flow

```
                    ┌─────────────┐
                    │   Action    │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │  Try Block  │
                    └──────┬──────┘
                           │
                    ┌──────▼──────────────────┐
                    │  Success?               │
                    └──┬──────────────────┬───┘
                       │ Yes              │ No
                       │                  │
                 ┌─────▼──────┐    ┌─────▼──────────┐
                 │  Continue  │    │  Catch Block   │
                 │  Workflow  │    └─────┬──────────┘
                 └────────────┘          │
                                         │
                                  ┌──────▼──────────┐
                                  │ Log Error       │
                                  └──────┬──────────┘
                                         │
                                  ┌──────▼──────────┐
                                  │ Show User       │
                                  │ Friendly        │
                                  │ Message         │
                                  └─────────────────┘
```

## Component Interaction

```
HomeScreen
    │
    └──► DocumentScannerScreen
            │
            ├──► CameraController
            │       └──► Camera Hardware
            │
            ├──► ImagePicker
            │       └──► Gallery
            │
            └──► Process Image
                    │
                    ├──► EdgeDetectionService
                    │       └──► Image Processing
                    │
                    ├──► OCRService
                    │       └──► Google ML Kit
                    │
                    └──► SupabaseService
                            └──► Supabase API
                                    │
                                    ├──► PostgreSQL
                                    └──► Storage
                                            │
                                            └──► ResultScreen
```

## Summary

This visual guide illustrates the complete workflow from app launch to result display, showing:
- User interface flow
- Data processing steps
- Backend integration
- Database structure
- Error handling
- Component interactions

Each step is designed to be clear, efficient, and user-friendly, with proper error handling and feedback at every stage.
