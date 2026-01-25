// RevenueCat Webhook Handler for Supabase Edge Functions
// This handles subscription events from RevenueCat and updates the database
//
// Webhook events handled:
// - INITIAL_PURCHASE: New subscription purchased
// - RENEWAL: Subscription renewed
// - CANCELLATION: Subscription cancelled
// - EXPIRATION: Subscription expired
// - PRODUCT_CHANGE: Plan changed (upgrade/downgrade)
// - BILLING_ISSUE: Payment failed
// - SUBSCRIBER_ALIAS: User alias updated
//
// Updated: 2025-01-22
// - Added Basic/Pro plan detection from product_id
// - Fixed column names to match actual DB schema
// - Added trial_start/trial_end columns
//
// Updated: 2026-01-25
// - Added missing fields: revenuecat_original_app_user_id, revenuecat_entitlement_id,
//   revenuecat_data, original_purchase_date

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// CORS headers for preflight requests
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

// Plan IDs from subscription_plans table in Supabase
const PLAN_IDS = {
  free: "499b821f-c0c3-4eaf-ba4e-c5aaaf9759be",
  basic: "c484321e-99c6-4cd7-af77-e74c325acede",
  pro: "29e2647b-082b-45e9-b228-ac78fc87daec",
} as const;

// RevenueCat event types
type RevenueCatEventType =
  | "INITIAL_PURCHASE"
  | "RENEWAL"
  | "CANCELLATION"
  | "UNCANCELLATION"
  | "EXPIRATION"
  | "PRODUCT_CHANGE"
  | "BILLING_ISSUE"
  | "SUBSCRIBER_ALIAS"
  | "TEST";

interface RevenueCatEvent {
  event: {
    type: RevenueCatEventType;
    app_user_id: string;
    original_app_user_id: string;
    product_id: string;
    entitlement_ids: string[];
    period_type: string;
    purchased_at_ms: number;
    expiration_at_ms: number;
    environment: string;
    is_trial_period?: boolean;
    store: string;
    price?: number;
    currency?: string;
  };
  api_version: string;
}

/**
 * Detect plan type (basic or pro) from product_id
 * Product IDs are like: com.storebase.app.basic.monthly, com.storebase.app.pro.yearly
 */
function detectPlanType(productId: string): "basic" | "pro" | "free" {
  const lowerProductId = productId.toLowerCase();
  if (lowerProductId.includes("basic")) {
    return "basic";
  } else if (lowerProductId.includes("pro")) {
    return "pro";
  }
  return "free";
}

/**
 * Detect billing cycle from product_id
 */
function detectBillingCycle(productId: string): "monthly" | "yearly" {
  const lowerProductId = productId.toLowerCase();
  if (
    lowerProductId.includes("yearly") ||
    lowerProductId.includes("annual")
  ) {
    return "yearly";
  }
  return "monthly";
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Initialize Supabase client with service role key (for admin operations)
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error("Missing Supabase environment variables");
    }

    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Parse the webhook payload
    const payload: RevenueCatEvent = await req.json();
    const event = payload.event;

    console.log(`📨 RevenueCat webhook received: ${event.type}`);
    console.log(`   User ID: ${event.app_user_id}`);
    console.log(`   Product: ${event.product_id}`);
    console.log(`   Environment: ${event.environment}`);

    // The app_user_id is the Supabase user ID (set during RevenueCat login)
    const userId = event.app_user_id;

    // Skip if no valid user ID
    if (!userId || userId.startsWith("$RCAnonymousID:")) {
      console.log("⚠️ Skipping anonymous user event");
      return new Response(
        JSON.stringify({ success: true, message: "Skipped anonymous user" }),
        {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
          status: 200,
        }
      );
    }

    // Detect plan type from product_id (basic or pro)
    const detectedPlanType = detectPlanType(event.product_id);
    const billingCycle = detectBillingCycle(event.product_id);
    const isTrial = event.is_trial_period || false;
    const isSandbox = event.environment === "SANDBOX";

    // Determine subscription status based on event type
    let planType: "free" | "basic" | "pro" = detectedPlanType;
    let status: "active" | "trialing" | "canceled" | "expired" = "active";
    let autoRenew = true;
    let expiresAt: string | null = null;
    let purchasedAt: string | null = null;
    let trialStart: string | null = null;
    let trialEnd: string | null = null;

    // Parse dates
    if (event.expiration_at_ms) {
      expiresAt = new Date(event.expiration_at_ms).toISOString();
    }
    if (event.purchased_at_ms) {
      purchasedAt = new Date(event.purchased_at_ms).toISOString();
    }

    switch (event.type) {
      case "INITIAL_PURCHASE":
      case "RENEWAL":
      case "UNCANCELLATION":
        // Use detected plan type (basic or pro)
        status = isTrial ? "trialing" : "active";
        autoRenew = true;
        if (isTrial) {
          trialStart = purchasedAt;
          trialEnd = expiresAt;
        }
        console.log(`✅ Activating ${planType} subscription until ${expiresAt} (trial: ${isTrial})`);
        break;

      case "CANCELLATION":
        // User cancelled but subscription is still active until expiration
        status = "canceled";
        autoRenew = false;
        console.log(`⚠️ Subscription cancelled, expires at ${expiresAt}`);
        break;

      case "EXPIRATION":
      case "BILLING_ISSUE":
        planType = "free";
        status = "expired";
        autoRenew = false;
        expiresAt = null;
        console.log(`❌ Subscription expired or billing issue`);
        break;

      case "PRODUCT_CHANGE":
        status = isTrial ? "trialing" : "active";
        autoRenew = true;
        if (isTrial) {
          trialStart = purchasedAt;
          trialEnd = expiresAt;
        }
        console.log(`🔄 Product changed to ${event.product_id} (${planType})`);
        break;

      case "TEST":
        console.log("🧪 Test event received");
        return new Response(
          JSON.stringify({ success: true, message: "Test event received" }),
          {
            headers: { ...corsHeaders, "Content-Type": "application/json" },
            status: 200,
          }
        );

      default:
        console.log(`ℹ️ Unhandled event type: ${event.type}`);
    }

    // Get the correct plan_id UUID
    const planId = PLAN_IDS[planType];

    // Update subscription_user table
    // First, check if record exists
    const { data: existingSubscription, error: fetchError } = await supabase
      .from("subscription_user")
      .select("*")
      .eq("user_id", userId)
      .single();

    if (fetchError && fetchError.code !== "PGRST116") {
      // PGRST116 = row not found
      console.error("Error fetching subscription:", fetchError);
    }

    // Prepare subscription data with correct column names matching DB schema
    const now = new Date().toISOString();
    const subscriptionData = {
      user_id: userId,
      plan_id: planId, // UUID reference to subscription_plans table
      status: status, // 'active', 'trialing', 'canceled', 'expired'
      billing_cycle: billingCycle,
      current_period_start: purchasedAt,
      current_period_end: expiresAt,
      trial_start: trialStart,
      trial_end: trialEnd,
      expiration_date: expiresAt,
      revenuecat_app_user_id: userId,
      revenuecat_original_app_user_id: event.original_app_user_id, // ✅ Added
      revenuecat_product_id: event.product_id,
      revenuecat_entitlement_id: event.entitlement_ids?.[0] || null, // ✅ Added
      revenuecat_store: event.store,
      revenuecat_data: payload, // ✅ Added - Full webhook payload for debugging
      original_purchase_date: purchasedAt, // ✅ Added
      is_sandbox: isSandbox,
      auto_renew_status: autoRenew,
      payment_provider: event.store === "APP_STORE" ? "revenuecat_apple" : "revenuecat_google",
      updated_at: now,
    };

    console.log("📝 Subscription data:", JSON.stringify(subscriptionData, null, 2));

    let upsertError;

    if (existingSubscription) {
      // Update existing record
      const { error } = await supabase
        .from("subscription_user")
        .update(subscriptionData)
        .eq("user_id", userId);
      upsertError = error;
    } else {
      // Insert new record
      const { error } = await supabase
        .from("subscription_user")
        .insert({
          ...subscriptionData,
          created_at: now,
        });
      upsertError = error;
    }

    if (upsertError) {
      console.error("Error upserting subscription:", upsertError);
      throw upsertError;
    }

    console.log(`✅ subscription_user record updated for user ${userId}`);

    // Update companies table with inherited_plan_id for this owner
    const { error: companiesError } = await supabase
      .from("companies")
      .update({
        inherited_plan_id: planId,
        plan_updated_at: now,
        updated_at: now,
      })
      .eq("owner_id", userId);

    if (companiesError) {
      console.error("Error updating companies:", companiesError);
      // Don't throw - companies update is secondary
    } else {
      console.log(`✅ companies table updated for owner ${userId}`);
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: `Processed ${event.type} event for user ${userId}`,
        data: {
          userId,
          planType,
          planId,
          status,
          autoRenew,
          expiresAt,
          isTrial,
          trialStart,
          trialEnd,
        },
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error("❌ Webhook error:", error);

    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || "Unknown error",
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 500,
      }
    );
  }
});
