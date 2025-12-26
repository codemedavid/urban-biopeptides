-- Urban Biopeptides - Add New Peptides Migration
-- December 27, 2025
-- Adding: SS-31, Tesamorelin, Oxytocin
-- Note: Reta (Retatrutide), PT-141, Kisspeptin, Cargi (Cagrilintide), NAD+ already exist

DO $$
DECLARE
  product_id_ss31 UUID;
  product_id_tesamorelin UUID;
  product_id_oxytocin UUID;
BEGIN
  -- SS-31 (Elamipretide) - Mitochondrial peptide
  SELECT id INTO product_id_ss31 FROM products WHERE LOWER(name) LIKE '%ss-31%' OR LOWER(name) LIKE '%ss31%' OR LOWER(name) LIKE '%elamipretide%' LIMIT 1;
  IF product_id_ss31 IS NULL THEN
    INSERT INTO products (name, description, category, base_price, purity_percentage, stock_quantity, available, featured, storage_conditions, molecular_weight, cas_number, sequence)
    VALUES (
      'SS-31 (Elamipretide)',
      'SS-31 (Elamipretide) is a mitochondria-targeted peptide that helps protect and repair cellular energy systems. Research-grade peptide for anti-aging and mitochondrial function studies.',
      'research',
      2499.00,
      99.0,
      10,
      true,
      true,
      'Store at -20°C. Protect from light.',
      '639.8 g/mol',
      '736992-21-5',
      'D-Arg-Dmt-Lys-Phe-NH2'
    )
    RETURNING id INTO product_id_ss31;
    
    -- Add variations for SS-31
    INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (product_id_ss31, '5mg', 5.0, 2499.00, 5),
    (product_id_ss31, '10mg', 10.0, 3999.00, 5);
    
    RAISE NOTICE '✅ SS-31 (Elamipretide) added successfully';
  ELSE
    RAISE NOTICE 'ℹ️ SS-31 already exists, skipping...';
  END IF;

  -- TESAMORELIN - Growth Hormone Releasing Hormone analog
  SELECT id INTO product_id_tesamorelin FROM products WHERE LOWER(name) LIKE '%tesamorelin%' LIMIT 1;
  IF product_id_tesamorelin IS NULL THEN
    INSERT INTO products (name, description, category, base_price, purity_percentage, stock_quantity, available, featured, storage_conditions, molecular_weight, cas_number, sequence)
    VALUES (
      'Tesamorelin',
      'Tesamorelin is a synthetic growth hormone-releasing hormone (GHRH) analog. Research-grade peptide for metabolic and body composition studies.',
      'research',
      2899.00,
      99.0,
      10,
      true,
      true,
      'Store at -20°C. Reconstituted solution at 2-8°C for up to 30 days.',
      '5135.9 g/mol',
      '218949-48-5',
      'Modified GHRH (1-44) amino acid sequence'
    )
    RETURNING id INTO product_id_tesamorelin;
    
    -- Add variations for Tesamorelin
    INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (product_id_tesamorelin, '2mg', 2.0, 2899.00, 5),
    (product_id_tesamorelin, '5mg', 5.0, 4999.00, 5);
    
    RAISE NOTICE '✅ Tesamorelin added successfully';
  ELSE
    RAISE NOTICE 'ℹ️ Tesamorelin already exists, skipping...';
  END IF;

  -- OXYTOCIN - Neuropeptide hormone
  SELECT id INTO product_id_oxytocin FROM products WHERE LOWER(name) LIKE '%oxytocin%' LIMIT 1;
  IF product_id_oxytocin IS NULL THEN
    INSERT INTO products (name, description, category, base_price, purity_percentage, stock_quantity, available, featured, storage_conditions, molecular_weight, cas_number, sequence)
    VALUES (
      'Oxytocin',
      'Oxytocin is a neuropeptide hormone involved in social bonding, stress response, and various physiological functions. Research-grade peptide for behavioral and neuroendocrine studies.',
      'wellness',
      1299.00,
      99.0,
      10,
      true,
      false,
      'Store at -20°C. Protect from light and moisture.',
      '1007.19 g/mol',
      '50-56-6',
      'Cys-Tyr-Ile-Gln-Asn-Cys-Pro-Leu-Gly-NH2'
    )
    RETURNING id INTO product_id_oxytocin;
    
    -- Add variations for Oxytocin
    INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (product_id_oxytocin, '2mg', 2.0, 1299.00, 5),
    (product_id_oxytocin, '5mg', 5.0, 2499.00, 5);
    
    RAISE NOTICE '✅ Oxytocin added successfully';
  ELSE
    RAISE NOTICE 'ℹ️ Oxytocin already exists, skipping...';
  END IF;

END $$;

-- Verify the migration
DO $$
DECLARE
  new_products_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO new_products_count 
  FROM products 
  WHERE LOWER(name) LIKE '%ss-31%' 
     OR LOWER(name) LIKE '%tesamorelin%' 
     OR LOWER(name) LIKE '%oxytocin%';
  
  RAISE NOTICE '✅ Migration completed!';
  RAISE NOTICE '📦 New products added: %', new_products_count;
END $$;
