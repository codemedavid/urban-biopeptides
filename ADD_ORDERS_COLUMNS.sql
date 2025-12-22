-- =============================================
-- FIX ORDERS TABLE - ADD ALL MISSING COLUMNS
-- Run this in your Supabase SQL Editor
-- =============================================

-- Add all potentially missing columns to the orders table
-- This handles upgrade from older schema versions

DO $$ 
BEGIN
  -- shipping_barangay
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'shipping_barangay') THEN
    ALTER TABLE orders ADD COLUMN shipping_barangay TEXT DEFAULT '';
  END IF;

  -- shipping_location
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'shipping_location') THEN
    ALTER TABLE orders ADD COLUMN shipping_location TEXT;
  END IF;

  -- shipping_fee
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'shipping_fee') THEN
    ALTER TABLE orders ADD COLUMN shipping_fee DECIMAL(10,2) DEFAULT 0;
  END IF;

  -- payment_method_id
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'payment_method_id') THEN
    ALTER TABLE orders ADD COLUMN payment_method_id TEXT;
  END IF;

  -- payment_method_name
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'payment_method_name') THEN
    ALTER TABLE orders ADD COLUMN payment_method_name TEXT;
  END IF;

  -- payment_proof_url
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'payment_proof_url') THEN
    ALTER TABLE orders ADD COLUMN payment_proof_url TEXT;
  END IF;

  -- contact_method
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'contact_method') THEN
    ALTER TABLE orders ADD COLUMN contact_method TEXT;
  END IF;

  -- promo_code_id
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'promo_code_id') THEN
    ALTER TABLE orders ADD COLUMN promo_code_id UUID;
  END IF;

  -- promo_code
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'promo_code') THEN
    ALTER TABLE orders ADD COLUMN promo_code TEXT;
  END IF;

  -- discount_applied
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'discount_applied') THEN
    ALTER TABLE orders ADD COLUMN discount_applied DECIMAL(10,2) DEFAULT 0;
  END IF;

  -- notes
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'notes') THEN
    ALTER TABLE orders ADD COLUMN notes TEXT;
  END IF;

  -- order_status
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'order_status') THEN
    ALTER TABLE orders ADD COLUMN order_status TEXT DEFAULT 'new';
  END IF;

  -- payment_status
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'payment_status') THEN
    ALTER TABLE orders ADD COLUMN payment_status TEXT DEFAULT 'pending';
  END IF;

  RAISE NOTICE 'All missing columns added successfully!';
END $$;

-- Force schema cache reload (IMPORTANT!)
NOTIFY pgrst, 'reload schema';

-- Show all columns in orders table to verify
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'orders' 
ORDER BY ordinal_position;
