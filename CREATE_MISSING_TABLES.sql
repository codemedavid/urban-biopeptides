-- =============================================
-- CREATE MISSING TABLES FOR SLIMDOSE PEPTIDE
-- Run this in your Supabase SQL Editor
-- =============================================

-- 1. Create shipping_locations table
CREATE TABLE IF NOT EXISTS public.shipping_locations (
  id text PRIMARY KEY,
  name text NOT NULL,
  fee numeric(10,2) NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  order_index integer NOT NULL DEFAULT 1,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security for shipping_locations
ALTER TABLE public.shipping_locations ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Allow public read access" ON public.shipping_locations;
DROP POLICY IF EXISTS "Allow authenticated insert" ON public.shipping_locations;
DROP POLICY IF EXISTS "Allow authenticated update" ON public.shipping_locations;
DROP POLICY IF EXISTS "Allow authenticated delete" ON public.shipping_locations;

-- Create policies for shipping_locations
CREATE POLICY "Allow public read access" ON public.shipping_locations
  FOR SELECT USING (true);

CREATE POLICY "Allow authenticated insert" ON public.shipping_locations
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow authenticated update" ON public.shipping_locations
  FOR UPDATE USING (true);

CREATE POLICY "Allow authenticated delete" ON public.shipping_locations
  FOR DELETE USING (true);

-- Create index for shipping_locations
CREATE INDEX IF NOT EXISTS shipping_locations_order_idx ON public.shipping_locations (order_index ASC);

-- Insert default shipping locations
INSERT INTO public.shipping_locations (id, name, fee, is_active, order_index) VALUES
  ('NCR', 'NCR (Metro Manila)', 75, true, 1),
  ('LUZON', 'Luzon (Outside NCR)', 100, true, 2),
  ('VISAYAS_MINDANAO', 'Visayas & Mindanao', 130, true, 3)
ON CONFLICT (id) DO UPDATE SET
  fee = EXCLUDED.fee,
  name = EXCLUDED.name;

-- Grant permissions for shipping_locations
GRANT SELECT ON public.shipping_locations TO anon;
GRANT SELECT ON public.shipping_locations TO authenticated;
GRANT ALL ON public.shipping_locations TO authenticated;


-- 2. Create payment_methods table
CREATE TABLE IF NOT EXISTS public.payment_methods (
  id text PRIMARY KEY,
  name text NOT NULL,
  account_number text NOT NULL,
  account_name text NOT NULL,
  qr_code_url text NOT NULL,
  active boolean DEFAULT true,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS for payment_methods
ALTER TABLE public.payment_methods ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Anyone can read active payment methods" ON public.payment_methods;
DROP POLICY IF EXISTS "Authenticated users can manage payment methods" ON public.payment_methods;
DROP POLICY IF EXISTS "Allow public read payment methods" ON public.payment_methods;
DROP POLICY IF EXISTS "Allow all for authenticated" ON public.payment_methods;

-- Create policies for payment_methods
CREATE POLICY "Allow public read payment methods" ON public.payment_methods
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow all for authenticated" ON public.payment_methods
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Insert default payment methods
INSERT INTO public.payment_methods (id, name, account_number, account_name, qr_code_url, sort_order, active) VALUES
  ('gcash', 'GCash', '09XX XXX XXXX', 'Urban Biopeptides', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg', 1, true),
  ('maya', 'Maya (PayMaya)', '09XX XXX XXXX', 'Urban Biopeptides', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg', 2, true),
  ('bank-transfer', 'Bank Transfer', 'Account: 1234-5678-9012', 'Urban Biopeptides', 'https://images.pexels.com/photos/8867482/pexels-photo-8867482.jpeg', 3, true)
ON CONFLICT (id) DO NOTHING;

-- Grant permissions for payment_methods
GRANT SELECT ON public.payment_methods TO anon;
GRANT ALL ON public.payment_methods TO authenticated;


-- 3. Force schema cache reload
NOTIFY pgrst, 'reload schema';

-- Success message
SELECT 'Tables created successfully! Please reload your app.' as message;
