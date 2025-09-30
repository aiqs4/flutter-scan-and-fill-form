# Supabase Setup Guide

This guide provides detailed instructions for setting up your Supabase backend for the Flutter Scan and Fill Form application.

## Prerequisites

- A Supabase account (sign up at [supabase.com](https://supabase.com))
- Basic understanding of SQL and database concepts

## Step 1: Create a Supabase Project

1. Log in to your Supabase account
2. Click "New Project"
3. Fill in the project details:
   - **Name**: Choose a name (e.g., "flutter-scanner")
   - **Database Password**: Generate a strong password
   - **Region**: Choose the closest region to your users
4. Click "Create new project"
5. Wait 2-3 minutes for the project to be ready

## Step 2: Get Your API Credentials

1. Once your project is ready, go to **Settings** → **API**
2. You'll need two values:
   - **Project URL**: Copy the URL (e.g., `https://xxxxx.supabase.co`)
   - **Anon/Public Key**: Copy the `anon` key (starts with `eyJ...`)

3. Save these values securely - you'll need them for the Flutter app

## Step 3: Create Database Tables

### Option A: Using the SQL Editor (Recommended)

1. In your Supabase dashboard, go to **SQL Editor**
2. Click "New Query"
3. Open the file `supabase/setup.sql` from this repository
4. Copy the entire contents
5. Paste into the SQL Editor
6. Click "Run" to execute the SQL

### Option B: Using the Table Editor

If you prefer a GUI approach:

#### Create Documents Table

1. Go to **Table Editor** → **New table**
2. Configure the table:
   - **Name**: `documents`
   - **Enable Row Level Security (RLS)**: Yes
   
3. Add columns:
   | Column | Type | Default | Nullable |
   |--------|------|---------|----------|
   | id | int8 | Auto-generated | No |
   | extracted_text | text | - | Yes |
   | image_url | text | - | Yes |
   | word_count | int4 | - | Yes |
   | created_at | timestamptz | now() | No |

4. Click "Save"

#### Create Document Fields Table

1. Create a new table: `document_fields`
2. Add columns:
   | Column | Type | Default | Nullable |
   |--------|------|---------|----------|
   | id | int8 | Auto-generated | No |
   | document_id | int8 | - | No |
   | field_type | text | - | No |
   | field_value | text | - | No |
   | created_at | timestamptz | now() | No |

3. Add foreign key:
   - Column: `document_id`
   - References: `documents(id)`
   - On Delete: CASCADE

4. Click "Save"

#### Create Indexes

Go to SQL Editor and run:
```sql
CREATE INDEX idx_document_fields_document_id ON document_fields(document_id);
CREATE INDEX idx_document_fields_type ON document_fields(field_type);
CREATE INDEX idx_document_fields_value ON document_fields(field_value);
```

## Step 4: Configure Row Level Security (RLS)

### For Public Access (No Authentication Required)

If you want to allow uploads without authentication:

1. Go to **Authentication** → **Policies**
2. For the `documents` table, add policies:

```sql
-- Allow anyone to read documents
CREATE POLICY "Enable read access for all users" ON documents
  FOR SELECT USING (true);

-- Allow anyone to insert documents
CREATE POLICY "Enable insert for all users" ON documents
  FOR INSERT WITH CHECK (true);
```

3. Repeat for `document_fields` table

### For Authenticated Users Only

For better security, require authentication:

```sql
-- Documents table policies
CREATE POLICY "Enable read for authenticated users" ON documents
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Enable insert for authenticated users" ON documents
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Document fields table policies
CREATE POLICY "Enable read for authenticated users" ON document_fields
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Enable insert for authenticated users" ON document_fields
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
```

## Step 5: Create Storage Bucket

1. Go to **Storage** in your Supabase dashboard
2. Click "Create bucket"
3. Configure:
   - **Name**: `documents`
   - **Public bucket**: Yes (for easier access)
   - **File size limit**: 50 MB (or as needed)
   - **Allowed MIME types**: image/jpeg, image/png
4. Click "Save"

### Configure Storage Policies

1. Click on the bucket → Policies
2. Add policies for insert, select, and delete
3. Or use SQL:

```sql
-- Allow anyone to read images
CREATE POLICY "Enable read access for all users" ON storage.objects
  FOR SELECT USING (bucket_id = 'documents');

-- Allow anyone to upload images
CREATE POLICY "Enable insert for all users" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'documents');
```

## Step 6: Verify Setup

### Test the Tables

Run this SQL to insert test data:

```sql
-- Insert a test document
INSERT INTO documents (extracted_text, word_count)
VALUES ('Test document content', 3)
RETURNING *;

-- Insert test fields (replace document_id with the ID from above)
INSERT INTO document_fields (document_id, field_type, field_value)
VALUES 
  (1, 'email', 'test@example.com'),
  (1, 'phone', '555-1234');

-- Verify data
SELECT * FROM documents;
SELECT * FROM document_fields;
```

### Check Storage

1. Go to **Storage** → `documents` bucket
2. Try uploading a test image
3. Verify you can view it

## Step 7: Configure Your Flutter App

Now that your Supabase backend is ready, configure your Flutter app:

### Method 1: Edit main.dart Directly

Open `lib/main.dart` and replace the placeholders:

```dart
await Supabase.initialize(
  url: 'https://your-project-id.supabase.co',
  anonKey: 'your-anon-key-here',
);
```

### Method 2: Use Environment Variables

Create a `.env` file (copy from `.env.example`):

```bash
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

Run your app with:
```bash
flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
```

## Step 8: Test the Integration

1. Run your Flutter app
2. Scan a test document
3. Check your Supabase dashboard:
   - Go to **Table Editor** → `documents`
   - You should see the uploaded document
   - Check `document_fields` for extracted data
   - Go to **Storage** → `documents` to see uploaded images

## Troubleshooting

### Error: "Failed to create table"
- Make sure you have permission to create tables
- Check if tables already exist
- Verify your SQL syntax

### Error: "Row level security policy violated"
- Check that RLS policies are correctly configured
- Verify you're using the correct anon key
- Consider temporarily disabling RLS for testing

### Error: "Storage bucket not found"
- Verify the bucket name is exactly `documents`
- Check that the bucket was created successfully
- Ensure storage policies are set up

### No data appears in tables
- Check your internet connection
- Verify Supabase credentials in the app
- Look at the app logs for error messages
- Check Supabase logs in the dashboard

## Advanced Configuration

### Custom Policies

For user-specific data isolation:

```sql
-- Users can only see their own documents
CREATE POLICY "Users can view own documents" ON documents
  FOR SELECT USING (auth.uid() = user_id);

-- Add user_id column first
ALTER TABLE documents ADD COLUMN user_id UUID REFERENCES auth.users(id);
```

### Database Functions

Create helper functions for common queries:

```sql
-- Function to get document statistics
CREATE OR REPLACE FUNCTION get_document_stats()
RETURNS JSON AS $$
BEGIN
  RETURN json_build_object(
    'total_documents', (SELECT COUNT(*) FROM documents),
    'total_fields', (SELECT COUNT(*) FROM document_fields),
    'avg_word_count', (SELECT AVG(word_count) FROM documents)
  );
END;
$$ LANGUAGE plpgsql;
```

### Webhooks

Set up webhooks for notifications:

1. Go to **Database** → **Webhooks**
2. Create a new webhook
3. Configure to trigger on INSERT to `documents` table
4. Add your webhook URL

## Security Best Practices

1. **Never commit your Supabase credentials** to version control
2. **Use environment variables** for sensitive data
3. **Enable RLS** on all tables
4. **Use appropriate policies** based on your use case
5. **Regularly rotate API keys** if they're exposed
6. **Monitor usage** in the Supabase dashboard
7. **Set up alerts** for unusual activity
8. **Use service role key** only in secure backend environments

## Backup and Maintenance

### Automated Backups

Supabase provides automated daily backups (Pro plan and above)

### Manual Backup

Export your data:

```sql
-- Backup documents
COPY documents TO '/path/to/backup/documents.csv' CSV HEADER;

-- Backup document fields
COPY document_fields TO '/path/to/backup/fields.csv' CSV HEADER;
```

### Monitoring

1. Check **Database** → **Usage** for storage and query metrics
2. Monitor **Storage** usage
3. Set up email alerts for quota limits

## Support

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Discord](https://discord.supabase.com)
- [GitHub Issues](https://github.com/aiqs4/flutter-scan-and-fill-form/issues)

## Next Steps

- Configure authentication if needed
- Set up webhooks for notifications
- Explore Supabase Edge Functions for custom logic
- Add realtime subscriptions for live updates
- Implement data analytics and reporting
