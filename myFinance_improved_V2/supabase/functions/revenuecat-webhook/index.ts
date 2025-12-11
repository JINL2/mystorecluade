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

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// CORS headers for preflight requests
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

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

    // Determine subscription status based on event type
    let planType = "free";
    let isActive = false;
    let expiresAt: string | null = null;

    switch (event.type) {
      case "INITIAL_PURCHASE":
      case "RENEWAL":
      case "UNCANCELLATION":
        planType = "pro";
        isActive = true;
        expiresAt = event.expiration_at_ms
          ? new Date(event.expiration_at_ms).toISOString()
          : null;
        console.log(`✅ Activating Pro subscription until ${expiresAt}`);
        break;

      case "CANCELLATION":
        // User cancelled but subscription is still active until expiration
        planType = "pro";
        isActive = true; // Still active until expiration
        expiresAt = event.expiration_at_ms
          ? new Date(event.expiration_at_ms).toISOString()
          : null;
        console.log(`⚠️ Subscription cancelled, expires at ${expiresAt}`);
        break;

      case "EXPIRATION":
      case "BILLING_ISSUE":
        planType = "free";
        isActive = false;
        expiresAt = null;
        console.log(`❌ Subscription expired or billing issue`);
        break;

      case "PRODUCT_CHANGE":
        planType = "pro";
        isActive = true;
        expiresAt = event.expiration_at_ms
          ? new Date(event.expiration_at_ms).toISOString()
          : null;
        console.log(`🔄 Product changed to ${event.product_id}`);
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

    const subscriptionData = {
      user_id: userId,
      plan_type: planType,
      is_active: isActive,
      product_id: event.product_id,
      original_purchase_date: event.purchased_at_ms
        ? new Date(event.purchased_at_ms).toISOString()
        : null,
      expires_at: expiresAt,
      is_trial: event.is_trial_period || false,
      store: event.store,
      environment: event.environment,
      last_event_type: event.type,
      updated_at: new Date().toISOString(),
    };

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
          created_at: new Date().toISOString(),
        });
      upsertError = error;
    }

    if (upsertError) {
      console.error("Error upserting subscription:", upsertError);
      throw upsertError;
    }

    console.log(`✅ Subscription record updated for user ${userId}`);

    // The database trigger (trg_sync_subscription_to_companies) will automatically
    // update all companies owned by this user with the new subscription status

    return new Response(
      JSON.stringify({
        success: true,
        message: `Processed ${event.type} event for user ${userId}`,
        data: {
          userId,
          planType,
          isActive,
          expiresAt,
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
