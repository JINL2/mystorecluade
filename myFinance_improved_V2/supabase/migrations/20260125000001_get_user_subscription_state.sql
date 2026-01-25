-- get_user_subscription_state: Fetch user's subscription state for SubscriptionStateNotifier
--
-- This RPC returns comprehensive subscription information including:
-- - Plan details (name, type, limits)
-- - Subscription status (active, trial, canceled, etc.)
-- - Trial/period dates
-- - RevenueCat customer ID
--
-- NULL values for limits mean UNLIMITED (Pro plan)
--
-- Used by: SubscriptionStateNotifier for real-time subscription management
-- Called after: User login, Realtime update, Force refresh

CREATE OR REPLACE FUNCTION public.get_user_subscription_state(p_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_build_object(
    -- Plan info from subscription_plans
    'plan_id', sp.plan_id,
    'plan_name', sp.plan_name,
    'display_name', sp.display_name,
    'plan_type', sp.plan_type,
    'price_monthly', COALESCE(sp.price_monthly, 0),

    -- Limits (NULL = unlimited for Pro plan)
    'max_companies', sp.max_companies,
    'max_stores', sp.max_stores,
    'max_employees', sp.max_employees,
    'ai_daily_limit', sp.ai_daily_limit,

    -- Features list
    'features', COALESCE(sp.features, '[]'::jsonb),

    -- Subscription status from subscription_user
    'status', COALESCE(su.status, 'active'),
    'billing_cycle', su.billing_cycle,

    -- Period dates
    'current_period_start', su.current_period_start,
    'current_period_end', su.current_period_end,

    -- Trial info
    'trial_start', su.trial_start,
    'trial_end', su.trial_end,

    -- Cancellation info
    'canceled_at', su.canceled_at,
    'cancel_at_period_end', COALESCE(su.cancel_at_period_end, false),

    -- RevenueCat info
    'revenuecat_customer_id', su.revenuecat_app_user_id,
    'revenuecat_product_id', su.revenuecat_product_id,
    'revenuecat_store', su.revenuecat_store,

    -- Expiration/renewal info
    'expiration_date', su.expiration_date,
    'auto_renew_status', COALESCE(su.auto_renew_status, true),
    'is_sandbox', COALESCE(su.is_sandbox, false),

    -- Timestamps
    'created_at', su.created_at,
    'updated_at', su.updated_at
  )
  INTO result
  FROM subscription_user su
  JOIN subscription_plans sp ON sp.plan_id = su.plan_id
  WHERE su.user_id = p_user_id;

  -- If no subscription found, return free plan defaults
  IF result IS NULL THEN
    SELECT jsonb_build_object(
      'plan_id', sp.plan_id,
      'plan_name', sp.plan_name,
      'display_name', sp.display_name,
      'plan_type', sp.plan_type,
      'price_monthly', COALESCE(sp.price_monthly, 0),
      'max_companies', sp.max_companies,
      'max_stores', sp.max_stores,
      'max_employees', sp.max_employees,
      'ai_daily_limit', sp.ai_daily_limit,
      'features', COALESCE(sp.features, '[]'::jsonb),
      'status', 'active',
      'billing_cycle', NULL,
      'current_period_start', NULL,
      'current_period_end', NULL,
      'trial_start', NULL,
      'trial_end', NULL,
      'canceled_at', NULL,
      'cancel_at_period_end', false,
      'revenuecat_customer_id', NULL,
      'revenuecat_product_id', NULL,
      'revenuecat_store', NULL,
      'expiration_date', NULL,
      'auto_renew_status', true,
      'is_sandbox', false,
      'created_at', NULL,
      'updated_at', NULL
    )
    INTO result
    FROM subscription_plans sp
    WHERE sp.plan_name = 'free'
    LIMIT 1;
  END IF;

  RETURN result;
END;
$function$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.get_user_subscription_state(uuid) TO authenticated;

-- Add comment
COMMENT ON FUNCTION public.get_user_subscription_state(uuid) IS
'Get user subscription state for SubscriptionStateNotifier.
Returns comprehensive subscription info including plan limits, status, and RevenueCat data.
NULL values for limits (max_companies, max_stores, max_employees) mean UNLIMITED.';
