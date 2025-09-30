-- Flutter Scan and Fill Form - Supabase Database Setup
-- Run these SQL commands in your Supabase SQL Editor

-- ========================================
-- 1. CREATE DOCUMENTS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS documents (
  id BIGSERIAL PRIMARY KEY,
  extracted_text TEXT,
  image_url TEXT,
  word_count INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comment to table
COMMENT ON TABLE documents IS 'Stores scanned documents with extracted text';

-- ========================================
-- 2. CREATE DOCUMENT FIELDS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS document_fields (
  id BIGSERIAL PRIMARY KEY,
  document_id BIGINT REFERENCES documents(id) ON DELETE CASCADE,
  field_type TEXT NOT NULL,
  field_value TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comment to table
COMMENT ON TABLE document_fields IS 'Stores structured data extracted from documents';

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_document_fields_document_id 
  ON document_fields(document_id);
CREATE INDEX IF NOT EXISTS idx_document_fields_type 
  ON document_fields(field_type);
CREATE INDEX IF NOT EXISTS idx_document_fields_value 
  ON document_fields(field_value);

-- ========================================
-- 3. ENABLE ROW LEVEL SECURITY
-- ========================================
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_fields ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 4. CREATE POLICIES
-- ========================================

-- Documents table policies
DROP POLICY IF EXISTS "Enable read access for all users" ON documents;
CREATE POLICY "Enable read access for all users" 
  ON documents FOR SELECT 
  USING (true);

DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON documents;
CREATE POLICY "Enable insert for authenticated users only" 
  ON documents FOR INSERT 
  WITH CHECK (true); -- You can add auth.role() = 'authenticated' if you want to restrict to authenticated users

DROP POLICY IF EXISTS "Enable update for authenticated users only" ON documents;
CREATE POLICY "Enable update for authenticated users only" 
  ON documents FOR UPDATE 
  USING (true);

DROP POLICY IF EXISTS "Enable delete for authenticated users only" ON documents;
CREATE POLICY "Enable delete for authenticated users only" 
  ON documents FOR DELETE 
  USING (true);

-- Document fields table policies
DROP POLICY IF EXISTS "Enable read access for all users" ON document_fields;
CREATE POLICY "Enable read access for all users" 
  ON document_fields FOR SELECT 
  USING (true);

DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON document_fields;
CREATE POLICY "Enable insert for authenticated users only" 
  ON document_fields FOR INSERT 
  WITH CHECK (true);

DROP POLICY IF EXISTS "Enable update for authenticated users only" ON document_fields;
CREATE POLICY "Enable update for authenticated users only" 
  ON document_fields FOR UPDATE 
  USING (true);

DROP POLICY IF EXISTS "Enable delete for authenticated users only" ON document_fields;
CREATE POLICY "Enable delete for authenticated users only" 
  ON document_fields FOR DELETE 
  USING (true);

-- ========================================
-- 5. CREATE STORAGE BUCKET
-- ========================================

-- Note: Run this in the Supabase Storage section or via SQL
-- Create bucket for document images
INSERT INTO storage.buckets (id, name, public)
VALUES ('documents', 'documents', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for documents bucket
DROP POLICY IF EXISTS "Enable read access for all users" ON storage.objects;
CREATE POLICY "Enable read access for all users" 
  ON storage.objects FOR SELECT 
  USING (bucket_id = 'documents');

DROP POLICY IF EXISTS "Enable insert for authenticated users" ON storage.objects;
CREATE POLICY "Enable insert for authenticated users" 
  ON storage.objects FOR INSERT 
  WITH CHECK (bucket_id = 'documents');

DROP POLICY IF EXISTS "Enable delete for authenticated users" ON storage.objects;
CREATE POLICY "Enable delete for authenticated users" 
  ON storage.objects FOR DELETE 
  USING (bucket_id = 'documents');

-- ========================================
-- 6. CREATE HELPER FUNCTIONS (OPTIONAL)
-- ========================================

-- Function to get documents with their fields
CREATE OR REPLACE FUNCTION get_document_with_fields(doc_id BIGINT)
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_build_object(
    'document', (SELECT row_to_json(d) FROM documents d WHERE d.id = doc_id),
    'fields', (SELECT json_agg(f) FROM document_fields f WHERE f.document_id = doc_id)
  ) INTO result;
  
  RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Function to search documents by field value
CREATE OR REPLACE FUNCTION search_documents_by_field(
  search_field_type TEXT DEFAULT NULL,
  search_value TEXT DEFAULT NULL
)
RETURNS TABLE (
  document_id BIGINT,
  extracted_text TEXT,
  image_url TEXT,
  word_count INTEGER,
  created_at TIMESTAMP WITH TIME ZONE,
  matching_fields JSON
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    d.id AS document_id,
    d.extracted_text,
    d.image_url,
    d.word_count,
    d.created_at,
    json_agg(
      json_build_object(
        'field_type', df.field_type,
        'field_value', df.field_value
      )
    ) AS matching_fields
  FROM documents d
  INNER JOIN document_fields df ON d.id = df.document_id
  WHERE 
    (search_field_type IS NULL OR df.field_type = search_field_type)
    AND (search_value IS NULL OR df.field_value ILIKE '%' || search_value || '%')
  GROUP BY d.id, d.extracted_text, d.image_url, d.word_count, d.created_at
  ORDER BY d.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- 7. CREATE VIEWS FOR EASY QUERYING
-- ========================================

-- View: Recent documents with field counts
CREATE OR REPLACE VIEW recent_documents_summary AS
SELECT 
  d.id,
  d.extracted_text,
  d.image_url,
  d.word_count,
  d.created_at,
  COUNT(df.id) AS field_count,
  json_agg(DISTINCT df.field_type) AS field_types
FROM documents d
LEFT JOIN document_fields df ON d.id = df.document_id
GROUP BY d.id, d.extracted_text, d.image_url, d.word_count, d.created_at
ORDER BY d.created_at DESC;

-- ========================================
-- 8. INSERT SAMPLE DATA (OPTIONAL)
-- ========================================

-- Uncomment to insert sample data for testing
/*
INSERT INTO documents (extracted_text, word_count) VALUES 
  ('John Doe\nEmail: john@example.com\nPhone: 555-123-4567', 6),
  ('Invoice #12345\nDate: 01/15/2024\nAmount: $250.00', 6);

INSERT INTO document_fields (document_id, field_type, field_value) VALUES 
  (1, 'email', 'john@example.com'),
  (1, 'phone', '555-123-4567'),
  (2, 'date', '01/15/2024'),
  (2, 'number', '12345'),
  (2, 'number', '250.00');
*/

-- ========================================
-- SETUP COMPLETE
-- ========================================
-- All tables, indexes, policies, and functions have been created.
-- You can now use the Flutter app to scan and upload documents!
