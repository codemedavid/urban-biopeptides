-- Create Storage Buckets for Urban Biopeptides
-- Run this in the Supabase SQL Editor

-- 1. Create the menu-images bucket for product images
INSERT INTO storage.buckets (id, name, public)
VALUES ('menu-images', 'menu-images', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Create the payment-proofs bucket for checkout payment proofs
INSERT INTO storage.buckets (id, name, public)
VALUES ('payment-proofs', 'payment-proofs', true)
ON CONFLICT (id) DO NOTHING;

-- 3. Create policies for menu-images bucket
-- Allow public read access
CREATE POLICY "Public Access to menu-images"
ON storage.objects FOR SELECT
USING (bucket_id = 'menu-images');

-- Allow authenticated uploads
CREATE POLICY "Allow uploads to menu-images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'menu-images');

-- Allow updates
CREATE POLICY "Allow updates to menu-images"
ON storage.objects FOR UPDATE
USING (bucket_id = 'menu-images');

-- Allow deletes
CREATE POLICY "Allow deletes from menu-images"
ON storage.objects FOR DELETE
USING (bucket_id = 'menu-images');

-- 4. Create policies for payment-proofs bucket
-- Allow public read access
CREATE POLICY "Public Access to payment-proofs"
ON storage.objects FOR SELECT
USING (bucket_id = 'payment-proofs');

-- Allow uploads
CREATE POLICY "Allow uploads to payment-proofs"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'payment-proofs');
