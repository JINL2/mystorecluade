-- ============================================================
-- Fix all trade_master_get_* functions to match actual table columns
-- Date: 2025-12-28
-- Problem: RPC functions were referencing columns that don't exist
-- ============================================================

-- 1. Fix trade_master_get_lc_types
-- Removed: typical_use_case (doesn't exist)
-- Added: is_revolving, is_standby, lc_type_id
CREATE OR REPLACE FUNCTION trade_master_get_lc_types()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN jsonb_build_object(
    'success', true,
    'data', (
      SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
          'lc_type_id', lc_type_id,
          'code', code,
          'name', name,
          'description', description,
          'is_revocable', is_revocable,
          'is_confirmed', is_confirmed,
          'is_transferable', is_transferable,
          'is_revolving', is_revolving,
          'is_standby', is_standby,
          'sort_order', sort_order,
          'is_active', is_active
        ) ORDER BY sort_order, code
      ), '[]'::jsonb)
      FROM trade_lc_types
      WHERE is_active = true
    )
  );
END;
$$;

-- 2. Fix trade_master_get_document_types
-- Removed: name_ko, is_negotiable, typical_required_originals, typical_required_copies, issued_by
-- Added: document_type_id, name_short, commonly_required
CREATE OR REPLACE FUNCTION trade_master_get_document_types()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN jsonb_build_object(
    'success', true,
    'data', (
      SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
          'document_type_id', document_type_id,
          'code', code,
          'name', name,
          'name_short', name_short,
          'description', description,
          'category', category,
          'commonly_required', commonly_required,
          'sort_order', sort_order,
          'is_active', is_active
        ) ORDER BY category, sort_order, code
      ), '[]'::jsonb)
      FROM trade_document_types
      WHERE is_active = true
    )
  );
END;
$$;

-- 3. Fix trade_master_get_shipping_methods
-- Removed: typical_transit_days, bl_type
-- Added: shipping_method_id, transport_document_code
CREATE OR REPLACE FUNCTION trade_master_get_shipping_methods()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN jsonb_build_object(
    'success', true,
    'data', (
      SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
          'shipping_method_id', shipping_method_id,
          'code', code,
          'name', name,
          'description', description,
          'transport_document_code', transport_document_code,
          'sort_order', sort_order,
          'is_active', is_active
        ) ORDER BY sort_order, code
      ), '[]'::jsonb)
      FROM trade_shipping_methods
      WHERE is_active = true
    )
  );
END;
$$;

-- 4. Fix trade_master_get_freight_terms (add freight_term_id)
CREATE OR REPLACE FUNCTION trade_master_get_freight_terms()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN jsonb_build_object(
    'success', true,
    'data', (
      SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
          'freight_term_id', freight_term_id,
          'code', code,
          'name', name,
          'description', description,
          'payer', payer,
          'sort_order', sort_order,
          'is_active', is_active
        ) ORDER BY sort_order, code
      ), '[]'::jsonb)
      FROM trade_freight_terms
      WHERE is_active = true
    )
  );
END;
$$;

COMMENT ON FUNCTION trade_master_get_lc_types IS 'Get all active L/C types. Fixed 2025-12-28.';
COMMENT ON FUNCTION trade_master_get_document_types IS 'Get all active document types. Fixed 2025-12-28.';
COMMENT ON FUNCTION trade_master_get_shipping_methods IS 'Get all active shipping methods. Fixed 2025-12-28.';
COMMENT ON FUNCTION trade_master_get_freight_terms IS 'Get all active freight terms. Fixed 2025-12-28.';
