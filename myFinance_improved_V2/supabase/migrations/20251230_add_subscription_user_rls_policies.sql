-- Add INSERT and UPDATE policies for subscription_user table
-- Required for app-side subscription sync (RevenueCat webhook backup)
--
-- Problem: RLS was blocking INSERT operations from the app
-- Error: "new row violates row-level security policy for table subscription_user"
--
-- Root cause: Only SELECT policy existed, no INSERT/UPDATE policies

-- INSERT: Users can create their own subscription record
CREATE POLICY "Users can insert own subscription"
ON public.subscription_user
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

-- UPDATE: Users can update their own subscription record
CREATE POLICY "Users can update own subscription"
ON public.subscription_user
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

COMMENT ON POLICY "Users can insert own subscription" ON public.subscription_user IS
  'Allows authenticated users to create their own subscription record for RevenueCat sync';

COMMENT ON POLICY "Users can update own subscription" ON public.subscription_user IS
  'Allows authenticated users to update their own subscription record for RevenueCat sync';
