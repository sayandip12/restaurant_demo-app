-- Create the receipts storage bucket
INSERT INTO storage.buckets (id, name, public) 
VALUES ('receipts', 'receipts', true)
ON CONFLICT (id) DO NOTHING;

-- Set up RLS for the receipts bucket
-- Allow anyone to read receipts (so WhatsApp links work)
CREATE POLICY "Public Access for Receipts" ON storage.objects
FOR SELECT USING (bucket_id = 'receipts');

-- Allow authenticated users to upload receipts (restaurant app)
CREATE POLICY "Auth Users Upload Receipts" ON storage.objects
FOR INSERT TO authenticated WITH CHECK (bucket_id = 'receipts');

-- Add receipt_url column to orders table if it doesn't exist
ALTER TABLE public.orders
ADD COLUMN IF NOT EXISTS receipt_url TEXT;
