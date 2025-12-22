-- ============================================================================
-- URBAN BIOPEPTIDES - COMPLETE PRODUCTS SETUP
-- Creates tables if they don't exist, then adds products
-- Run this in Supabase SQL Editor
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- STEP 1: CREATE TABLES (if they don't exist)
-- ============================================================================

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  base_price DECIMAL(10,2) NOT NULL,
  discount_price DECIMAL(10,2),
  discount_start_date TIMESTAMPTZ,
  discount_end_date TIMESTAMPTZ,
  discount_active BOOLEAN DEFAULT false,
  purity_percentage DECIMAL(5,2) DEFAULT 99.00,
  molecular_weight TEXT,
  cas_number TEXT,
  sequence TEXT,
  storage_conditions TEXT DEFAULT 'Store at -20°C',
  inclusions TEXT[],
  stock_quantity INTEGER DEFAULT 0,
  available BOOLEAN DEFAULT true,
  featured BOOLEAN DEFAULT false,
  image_url TEXT,
  safety_sheet_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create product variations table
CREATE TABLE IF NOT EXISTS product_variations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL,
  name TEXT NOT NULL,
  quantity_mg DECIMAL(10,2) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  stock_quantity INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add foreign key if not exists (wrapped in DO block to handle errors)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'product_variations_product_id_fkey'
  ) THEN
    ALTER TABLE product_variations 
    ADD CONSTRAINT product_variations_product_id_fkey 
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
  END IF;
EXCEPTION WHEN others THEN
  NULL; -- Ignore if constraint already exists
END $$;

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_available ON products(available);
CREATE INDEX IF NOT EXISTS idx_products_featured ON products(featured);
CREATE INDEX IF NOT EXISTS idx_product_variations_product_id ON product_variations(product_id);
CREATE INDEX IF NOT EXISTS idx_categories_active ON categories(active);

-- Enable RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_variations ENABLE ROW LEVEL SECURITY;

-- RLS Policies (drop and recreate to avoid conflicts)
DROP POLICY IF EXISTS "Public can view categories" ON categories;
CREATE POLICY "Public can view categories" ON categories FOR SELECT USING (true);

DROP POLICY IF EXISTS "Authenticated can manage categories" ON categories;
CREATE POLICY "Authenticated can manage categories" ON categories FOR ALL USING (true);

DROP POLICY IF EXISTS "Public can view products" ON products;
CREATE POLICY "Public can view products" ON products FOR SELECT USING (true);

DROP POLICY IF EXISTS "Authenticated can manage products" ON products;
CREATE POLICY "Authenticated can manage products" ON products FOR ALL USING (true);

DROP POLICY IF EXISTS "Public can view variations" ON product_variations;
CREATE POLICY "Public can view variations" ON product_variations FOR SELECT USING (true);

DROP POLICY IF EXISTS "Authenticated can manage variations" ON product_variations;
CREATE POLICY "Authenticated can manage variations" ON product_variations FOR ALL USING (true);

-- Grant permissions
GRANT SELECT ON categories TO anon;
GRANT ALL ON categories TO authenticated;
GRANT SELECT ON products TO anon;
GRANT ALL ON products TO authenticated;
GRANT SELECT ON product_variations TO anon;
GRANT ALL ON product_variations TO authenticated;

-- ============================================================================
-- STEP 2: ADD CATEGORIES
-- ============================================================================

INSERT INTO categories (id, name, icon, sort_order, active) VALUES
  ('weight-management', 'Weight Management', 'Scale', 1, true),
  ('cognitive', 'Brain & Focus', 'Brain', 2, true),
  ('anti-aging', 'Anti-Aging & Skin', 'Sparkles', 3, true)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  icon = EXCLUDED.icon,
  active = EXCLUDED.active;

-- ============================================================================
-- STEP 3: ADD PRODUCTS
-- ============================================================================

-- Delete existing products with same names to avoid duplicates
DELETE FROM products WHERE name IN (
  'Tirzepatide 5mg', 'Tirzepatide 10mg', 'Tirzepatide 15mg', 'Tirzepatide 30mg',
  'KLOW', 'SEMAX', 'SELANK', 'SNAP-8'
);

-- TIRZEPATIDE (Weight Management Peptide)
INSERT INTO products (
  name, description, category, base_price, purity_percentage,
  molecular_weight, cas_number, stock_quantity, available, featured, storage_conditions
) VALUES
(
  'Tirzepatide 5mg',
  'Tirzepatide is a dual GIP/GLP-1 receptor agonist peptide for weight management research. This innovative peptide mimics the effects of natural hormones involved in appetite regulation and glucose metabolism.',
  'weight-management',
  2500.00,
  99.5,
  '4813.45 g/mol',
  '2023788-19-2',
  50,
  true,
  true,
  'Store at -20°C. Keep away from light and moisture.'
),
(
  'Tirzepatide 10mg',
  'Tirzepatide is a dual GIP/GLP-1 receptor agonist peptide for weight management research. Higher dose vial for extended research protocols.',
  'weight-management',
  4500.00,
  99.5,
  '4813.45 g/mol',
  '2023788-19-2',
  40,
  true,
  true,
  'Store at -20°C. Keep away from light and moisture.'
),
(
  'Tirzepatide 15mg',
  'Tirzepatide is a dual GIP/GLP-1 receptor agonist peptide for weight management research. Premium dosage for comprehensive studies.',
  'weight-management',
  6500.00,
  99.5,
  '4813.45 g/mol',
  '2023788-19-2',
  35,
  true,
  true,
  'Store at -20°C. Keep away from light and moisture.'
),
(
  'Tirzepatide 30mg',
  'Tirzepatide is a dual GIP/GLP-1 receptor agonist peptide for weight management research. Maximum strength vial for advanced research.',
  'weight-management',
  12000.00,
  99.5,
  '4813.45 g/mol',
  '2023788-19-2',
  25,
  true,
  true,
  'Store at -20°C. Keep away from light and moisture.'
);

-- KLOW (Metabolic Peptide)
INSERT INTO products (
  name, description, category, base_price, purity_percentage,
  stock_quantity, available, featured, storage_conditions
) VALUES
(
  'KLOW',
  'KLOW is an advanced peptide compound designed for metabolic and weight management research. This next-generation formulation supports healthy metabolism studies.',
  'weight-management',
  3500.00,
  99.0,
  30,
  true,
  true,
  'Store refrigerated at 2-8°C. Protect from light.'
);

-- SEMAX (Cognitive Enhancement Peptide)
INSERT INTO products (
  name, description, category, base_price, purity_percentage,
  molecular_weight, cas_number, sequence, stock_quantity, available, featured, storage_conditions
) VALUES
(
  'SEMAX',
  'SEMAX is a nootropic peptide derived from ACTH (4-10) that enhances cognitive function, memory formation, and neuroprotection. Widely researched for brain health and mental clarity.',
  'cognitive',
  1800.00,
  98.8,
  '813.9 g/mol',
  '80714-61-0',
  'Met-Glu-His-Phe-Pro-Gly-Pro',
  60,
  true,
  true,
  'Store at -20°C. Reconstituted solution stable at 4°C for up to 30 days.'
);

-- SELANK (Anxiolytic Nootropic Peptide)
INSERT INTO products (
  name, description, category, base_price, purity_percentage,
  molecular_weight, cas_number, sequence, stock_quantity, available, featured, storage_conditions
) VALUES
(
  'SELANK',
  'SELANK is a powerful anxiolytic nootropic peptide that reduces anxiety, improves mood, and enhances mental clarity. Research shows potential for stress reduction and cognitive enhancement.',
  'cognitive',
  1900.00,
  99.1,
  '751.9 g/mol',
  '129954-34-3',
  'Thr-Lys-Pro-Arg-Pro-Gly-Pro',
  55,
  true,
  true,
  'Store at -20°C. Reconstituted solution stable at 4°C for up to 30 days.'
);

-- SNAP-8 (Anti-Aging Peptide)
INSERT INTO products (
  name, description, category, base_price, purity_percentage,
  molecular_weight, sequence, stock_quantity, available, featured, storage_conditions
) VALUES
(
  'SNAP-8',
  'SNAP-8 (Acetyl Octapeptide-3) is an advanced anti-aging peptide that reduces the appearance of wrinkles by inhibiting muscle contractions. Often called "Botox in a bottle" for its wrinkle-reducing properties.',
  'anti-aging',
  2200.00,
  98.5,
  '1075.29 g/mol',
  'Ac-Glu-Glu-Met-Gln-Arg-Arg-Ala-Asp-NH2',
  45,
  true,
  true,
  'Store at 2-8°C. Protect from light and moisture.'
);

-- ============================================================================
-- STEP 4: ADD PRODUCT VARIATIONS
-- ============================================================================

-- Delete existing variations for these products first
DELETE FROM product_variations WHERE product_id IN (
  SELECT id FROM products WHERE name IN ('SEMAX', 'SELANK', 'SNAP-8')
);

-- Add variations
INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity)
SELECT id, '10mg', 10.0, 1800.00, 60 FROM products WHERE name = 'SEMAX'
UNION ALL
SELECT id, '30mg', 30.0, 4500.00, 30 FROM products WHERE name = 'SEMAX'
UNION ALL
SELECT id, '10mg', 10.0, 1900.00, 55 FROM products WHERE name = 'SELANK'
UNION ALL
SELECT id, '30mg', 30.0, 4800.00, 28 FROM products WHERE name = 'SELANK'
UNION ALL
SELECT id, '10ml', 10.0, 2200.00, 45 FROM products WHERE name = 'SNAP-8'
UNION ALL
SELECT id, '30ml', 30.0, 5500.00, 20 FROM products WHERE name = 'SNAP-8';

-- ============================================================================
-- FORCE SCHEMA CACHE RELOAD
-- ============================================================================

NOTIFY pgrst, 'reload schema';

-- ============================================================================
-- DONE! 
-- Tables: categories, products, product_variations
-- Categories: weight-management, cognitive, anti-aging
-- Products: Tirzepatide (4 sizes), KLOW, SEMAX, SELANK, SNAP-8
-- ============================================================================
