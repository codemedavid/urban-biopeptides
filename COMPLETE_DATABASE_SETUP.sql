-- ============================================================================
-- URBAN BIOPEPTIDES - COMPLETE DATABASE SETUP
-- Run this in your Supabase SQL Editor to create all required tables
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- 1. COA (CERTIFICATE OF ANALYSIS) TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS coa_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_name TEXT NOT NULL,
  batch TEXT DEFAULT 'Unknown',
  test_date DATE NOT NULL,
  purity_percentage DECIMAL(5,3) NOT NULL,
  quantity TEXT NOT NULL,
  task_number TEXT NOT NULL,
  verification_key TEXT NOT NULL,
  image_url TEXT NOT NULL,
  featured BOOLEAN DEFAULT false,
  manufacturer TEXT DEFAULT 'Urban Biopeptides',
  laboratory TEXT DEFAULT 'Janoshik Analytical',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- COA Indexes
CREATE INDEX IF NOT EXISTS idx_coa_reports_product_name ON coa_reports(product_name);
CREATE INDEX IF NOT EXISTS idx_coa_reports_featured ON coa_reports(featured);

-- COA RLS
ALTER TABLE coa_reports ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can view COA reports" ON coa_reports;
CREATE POLICY "Public can view COA reports" ON coa_reports
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Authenticated can manage COA reports" ON coa_reports;
CREATE POLICY "Authenticated can manage COA reports" ON coa_reports
  FOR ALL USING (true);

-- Grant permissions
GRANT SELECT ON coa_reports TO anon;
GRANT ALL ON coa_reports TO authenticated;

-- ============================================================================
-- 2. FAQ TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS faqs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'GENERAL',
  order_index INTEGER NOT NULL DEFAULT 1,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- FAQ Indexes
CREATE INDEX IF NOT EXISTS faqs_order_idx ON faqs (order_index ASC);
CREATE INDEX IF NOT EXISTS faqs_category_idx ON faqs (category);
CREATE INDEX IF NOT EXISTS faqs_active_idx ON faqs (is_active);

-- FAQ RLS
ALTER TABLE faqs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read access" ON faqs;
CREATE POLICY "Allow public read access" ON faqs
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow authenticated insert" ON faqs;
CREATE POLICY "Allow authenticated insert" ON faqs
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow authenticated update" ON faqs;
CREATE POLICY "Allow authenticated update" ON faqs
  FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Allow authenticated delete" ON faqs;
CREATE POLICY "Allow authenticated delete" ON faqs
  FOR DELETE USING (true);

-- Grant permissions
GRANT SELECT ON faqs TO anon;
GRANT ALL ON faqs TO authenticated;

-- ============================================================================
-- 3. ORDERS TABLE (for Track Order functionality)
-- ============================================================================

CREATE TABLE IF NOT EXISTS orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Customer Information
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  customer_phone TEXT NOT NULL,
  
  -- Shipping Address
  shipping_address TEXT NOT NULL,
  shipping_city TEXT NOT NULL,
  shipping_state TEXT NOT NULL,
  shipping_zip_code TEXT NOT NULL,
  shipping_country TEXT NOT NULL DEFAULT 'Philippines',
  shipping_brgy TEXT,
  
  -- Order Details
  order_items JSONB NOT NULL,
  subtotal DECIMAL(10,2),
  shipping_fee DECIMAL(10,2) DEFAULT 0,
  total_price DECIMAL(10,2) NOT NULL,
  
  -- Promo/Discount
  promo_code TEXT,
  promo_code_id UUID,
  discount_applied DECIMAL(10,2) DEFAULT 0,
  
  -- Payment
  payment_method_id TEXT,
  payment_method_name TEXT,
  payment_status TEXT DEFAULT 'pending',
  payment_proof_url TEXT,
  
  -- Order Status & Tracking
  order_status TEXT DEFAULT 'new',
  tracking_number TEXT,
  shipping_note TEXT,
  notes TEXT,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Orders Indexes
CREATE INDEX IF NOT EXISTS idx_orders_customer_email ON orders(customer_email);
CREATE INDEX IF NOT EXISTS idx_orders_customer_phone ON orders(customer_phone);
CREATE INDEX IF NOT EXISTS idx_orders_order_status ON orders(order_status);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders(payment_status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_tracking_number ON orders(tracking_number);

-- Orders RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can create orders" ON orders;
CREATE POLICY "Anyone can create orders" ON orders
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Anyone can view orders by phone or email" ON orders;
CREATE POLICY "Anyone can view orders by phone or email" ON orders
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Authenticated can manage orders" ON orders;
CREATE POLICY "Authenticated can manage orders" ON orders
  FOR ALL USING (true);

-- Grant permissions
GRANT SELECT, INSERT ON orders TO anon;
GRANT ALL ON orders TO authenticated;

-- Updated at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_orders_updated_at ON orders;
CREATE TRIGGER update_orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- 4. PROMO CODES / VOUCHERS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS promo_codes (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  discount_type TEXT NOT NULL CHECK (discount_type IN ('percentage', 'fixed')),
  discount_value DECIMAL(10, 2) NOT NULL,
  min_purchase_amount DECIMAL(10, 2) DEFAULT 0,
  max_discount_amount DECIMAL(10, 2),
  start_date TIMESTAMPTZ,
  end_date TIMESTAMPTZ,
  usage_limit INTEGER,
  usage_count INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Promo Codes Indexes
CREATE INDEX IF NOT EXISTS idx_promo_codes_code ON promo_codes(code);
CREATE INDEX IF NOT EXISTS idx_promo_codes_active ON promo_codes(active);

-- Promo Codes RLS
ALTER TABLE promo_codes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read active promo codes" ON promo_codes;
CREATE POLICY "Public can read active promo codes" ON promo_codes
  FOR SELECT USING (active = true);

DROP POLICY IF EXISTS "Admins can manage promo codes" ON promo_codes;
CREATE POLICY "Admins can manage promo codes" ON promo_codes
  FOR ALL USING (true);

-- Grant permissions
GRANT SELECT ON promo_codes TO anon;
GRANT ALL ON promo_codes TO authenticated;

-- ============================================================================
-- 5. PEPTALK / GUIDE TOPICS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS guide_topics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  preview TEXT,
  content TEXT NOT NULL,
  cover_image TEXT,
  author TEXT NOT NULL DEFAULT 'Urban Biopeptides Team',
  published_date DATE NOT NULL DEFAULT CURRENT_DATE,
  display_order INTEGER NOT NULL DEFAULT 0,
  is_enabled BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Guide Topics Indexes
CREATE INDEX IF NOT EXISTS idx_guide_topics_display_order ON guide_topics(display_order);
CREATE INDEX IF NOT EXISTS idx_guide_topics_enabled ON guide_topics(is_enabled) WHERE is_enabled = true;

-- Guide Topics RLS
ALTER TABLE guide_topics ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can view enabled articles" ON guide_topics;
CREATE POLICY "Public can view enabled articles" ON guide_topics
  FOR SELECT USING (is_enabled = true);

DROP POLICY IF EXISTS "Authenticated users can manage articles" ON guide_topics;
CREATE POLICY "Authenticated users can manage articles" ON guide_topics
  FOR ALL USING (true);

-- Grant permissions
GRANT SELECT ON guide_topics TO anon;
GRANT ALL ON guide_topics TO authenticated;

-- ============================================================================
-- 6. SITE SETTINGS TABLE (for COA page enabled toggle, etc.)
-- ============================================================================

CREATE TABLE IF NOT EXISTS site_settings (
  id TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  type TEXT DEFAULT 'text',
  description TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Site Settings RLS
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read site settings" ON site_settings;
CREATE POLICY "Public can read site settings" ON site_settings
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Authenticated can manage site settings" ON site_settings;
CREATE POLICY "Authenticated can manage site settings" ON site_settings
  FOR ALL USING (true);

-- Grant permissions
GRANT SELECT ON site_settings TO anon;
GRANT ALL ON site_settings TO authenticated;

-- Insert default site settings
INSERT INTO site_settings (id, value, type, description) VALUES
  ('coa_page_enabled', 'true', 'boolean', 'Enable or disable the COA page'),
  ('site_name', 'Urban Biopeptides', 'text', 'Site name'),
  ('site_logo', '/assets/logo.png', 'text', 'Site logo URL')
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 7. ARTICLE COVERS STORAGE BUCKET
-- ============================================================================

-- Run this separately if needed:
-- INSERT INTO storage.buckets (id, name, public) VALUES ('article-covers', 'article-covers', true);

-- ============================================================================
-- FORCE SCHEMA CACHE RELOAD
-- ============================================================================

NOTIFY pgrst, 'reload schema';

-- ============================================================================
-- DONE! All tables created successfully.
-- ============================================================================
