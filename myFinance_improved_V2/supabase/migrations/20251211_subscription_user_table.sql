-- Migration: Create subscription_user table and sync trigger
-- Purpose: Track user subscription status from RevenueCat and sync to owned companies
--
-- Business Logic:
-- 1. Owner purchases Pro subscription via RevenueCat
-- 2. RevenueCat webhook updates subscription_user table
-- 3. Database trigger syncs subscription to all companies owned by the user
-- 4. All employees in those companies inherit Pro features

-- =====================================================
-- 1. Create subscription_user table
-- =====================================================
CREATE TABLE IF NOT EXISTS public.subscription_user (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    plan_type VARCHAR(50) NOT NULL DEFAULT 'free',
    is_active BOOLEAN NOT NULL DEFAULT false,
    product_id VARCHAR(255),
    original_purchase_date TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    is_trial BOOLEAN DEFAULT false,
    store VARCHAR(50),
    environment VARCHAR(50),
    last_event_type VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id)
);

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_subscription_user_user_id ON public.subscription_user(user_id);
CREATE INDEX IF NOT EXISTS idx_subscription_user_plan_type ON public.subscription_user(plan_type);
CREATE INDEX IF NOT EXISTS idx_subscription_user_expires_at ON public.subscription_user(expires_at);

-- Enable RLS
ALTER TABLE public.subscription_user ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- Users can only read their own subscription
CREATE POLICY "Users can view own subscription"
    ON public.subscription_user
    FOR SELECT
    USING (auth.uid() = user_id);

-- Only service role can insert/update (from webhook)
CREATE POLICY "Service role can manage subscriptions"
    ON public.subscription_user
    FOR ALL
    USING (auth.role() = 'service_role');

-- =====================================================
-- 2. Create function to sync subscription to companies
-- =====================================================
CREATE OR REPLACE FUNCTION public.sync_subscription_to_companies()
RETURNS TRIGGER AS $$
DECLARE
    company_record RECORD;
BEGIN
    -- Log the trigger execution
    RAISE NOTICE 'Syncing subscription for user % with plan %', NEW.user_id, NEW.plan_type;

    -- Update all companies where this user is the owner
    FOR company_record IN
        SELECT c.id, c.company_name
        FROM public.companies c
        INNER JOIN public.company_users cu ON c.id = cu.company_id
        WHERE cu.user_id = NEW.user_id AND cu.role = 'owner'
    LOOP
        RAISE NOTICE 'Updating company: % (%)', company_record.company_name, company_record.id;

        -- Update the company's subscription field
        UPDATE public.companies
        SET
            subscription = jsonb_build_object(
                'plan_type', NEW.plan_type,
                'is_active', NEW.is_active,
                'expires_at', NEW.expires_at,
                'is_trial', NEW.is_trial,
                'updated_at', NEW.updated_at
            ),
            updated_at = NOW()
        WHERE id = company_record.id;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 3. Create trigger to auto-sync on subscription changes
-- =====================================================
DROP TRIGGER IF EXISTS trg_sync_subscription_to_companies ON public.subscription_user;

CREATE TRIGGER trg_sync_subscription_to_companies
    AFTER INSERT OR UPDATE ON public.subscription_user
    FOR EACH ROW
    EXECUTE FUNCTION public.sync_subscription_to_companies();

-- =====================================================
-- 4. Add subscription column to companies table if not exists
-- =====================================================
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'companies'
        AND column_name = 'subscription'
    ) THEN
        ALTER TABLE public.companies ADD COLUMN subscription JSONB DEFAULT '{"plan_type": "free", "is_active": false}'::jsonb;
    END IF;
END $$;

-- =====================================================
-- 5. Create helper function to check if user is Pro
-- =====================================================
CREATE OR REPLACE FUNCTION public.is_user_pro(p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_is_pro BOOLEAN;
BEGIN
    SELECT
        (plan_type = 'pro' AND is_active = true AND (expires_at IS NULL OR expires_at > NOW()))
    INTO v_is_pro
    FROM public.subscription_user
    WHERE user_id = p_user_id;

    RETURN COALESCE(v_is_pro, false);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 6. Create helper function to check if company is Pro
-- =====================================================
CREATE OR REPLACE FUNCTION public.is_company_pro(p_company_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_subscription JSONB;
    v_is_pro BOOLEAN;
BEGIN
    SELECT subscription INTO v_subscription
    FROM public.companies
    WHERE id = p_company_id;

    IF v_subscription IS NULL THEN
        RETURN false;
    END IF;

    v_is_pro := (
        (v_subscription->>'plan_type')::TEXT = 'pro' AND
        (v_subscription->>'is_active')::BOOLEAN = true AND
        (
            (v_subscription->>'expires_at') IS NULL OR
            (v_subscription->>'expires_at')::TIMESTAMPTZ > NOW()
        )
    );

    RETURN COALESCE(v_is_pro, false);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 7. Grant permissions
-- =====================================================
GRANT SELECT ON public.subscription_user TO authenticated;
GRANT ALL ON public.subscription_user TO service_role;
GRANT EXECUTE ON FUNCTION public.is_user_pro TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_company_pro TO authenticated;

-- =====================================================
-- 8. Comment on table and columns
-- =====================================================
COMMENT ON TABLE public.subscription_user IS 'Stores user subscription data from RevenueCat webhooks';
COMMENT ON COLUMN public.subscription_user.user_id IS 'Foreign key to auth.users';
COMMENT ON COLUMN public.subscription_user.plan_type IS 'Subscription plan: free, basic, pro';
COMMENT ON COLUMN public.subscription_user.is_active IS 'Whether the subscription is currently active';
COMMENT ON COLUMN public.subscription_user.product_id IS 'RevenueCat product ID';
COMMENT ON COLUMN public.subscription_user.expires_at IS 'When the subscription expires';
COMMENT ON COLUMN public.subscription_user.is_trial IS 'Whether the user is on a trial period';
COMMENT ON COLUMN public.subscription_user.store IS 'App store: app_store, play_store';
COMMENT ON COLUMN public.subscription_user.environment IS 'Environment: production, sandbox';
COMMENT ON COLUMN public.subscription_user.last_event_type IS 'Last RevenueCat event type received';
COMMENT ON FUNCTION public.sync_subscription_to_companies IS 'Syncs subscription status to all companies owned by the user';
