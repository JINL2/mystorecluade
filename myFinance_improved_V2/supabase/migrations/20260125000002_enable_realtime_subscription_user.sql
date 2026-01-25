-- Enable Realtime for subscription_user table
--
-- This allows SubscriptionStateNotifier to receive instant updates
-- when subscription status changes from:
-- - RevenueCat webhook (purchase, renewal, cancellation)
-- - Admin manual updates
-- - Another device's SDK sync
--
-- Cross-device sync: When user purchases on Device A,
-- Device B receives Realtime update within seconds.

-- Add subscription_user to Realtime publication
-- This enables Postgres NOTIFY for any INSERT, UPDATE, DELETE on this table
ALTER PUBLICATION supabase_realtime ADD TABLE subscription_user;

-- Note: Only subscription_user needs Realtime
-- Other tables (companies, stores, user_companies) use 7-day cache
-- as they change infrequently and are controlled by the user

COMMENT ON TABLE subscription_user IS
'User subscription records with Realtime enabled.
Changes to this table trigger instant updates to all connected clients via Supabase Realtime.
Used by SubscriptionStateNotifier for cross-device subscription sync.';
