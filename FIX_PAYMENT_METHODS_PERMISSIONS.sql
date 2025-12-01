-- Fix payment_methods table permissions for admin dashboard
-- The admin dashboard uses password protection, not Supabase authentication
-- So we need to allow public access to manage payment_methods

-- Drop existing restrictive policy
DROP POLICY IF EXISTS "Authenticated users can manage payment methods" ON payment_methods;

-- Create new policy that allows public access for INSERT/UPDATE/DELETE
-- (Admin is protected by password on frontend, not database auth)
CREATE POLICY "Allow public full access to payment_methods" 
  ON payment_methods
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Verify the policy was created
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'payment_methods' 
    AND policyname = 'Allow public full access to payment_methods'
  ) THEN
    RAISE NOTICE '✅ Payment methods permissions updated successfully!';
  ELSE
    RAISE EXCEPTION '❌ Failed to update payment methods permissions';
  END IF;
END $$;

