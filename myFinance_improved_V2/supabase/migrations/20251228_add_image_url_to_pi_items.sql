-- ============================================================================
-- Migration: Add image_url to trade_pi_items
-- Version: 1.0
-- Created: 2025-12-28
-- Purpose: Allow item images in Proforma Invoice PDF
-- ============================================================================

-- Add image_url column to trade_pi_items table
ALTER TABLE trade_pi_items
ADD COLUMN IF NOT EXISTS image_url TEXT;

-- Add comment for documentation
COMMENT ON COLUMN trade_pi_items.image_url IS 'URL of the product image for PDF display';
