-- Migration: Rename buyer_id to counterparty_id in trade_proforma_invoices
-- Date: 2025-12-26
-- Description: Change buyer_id/buyer_info to counterparty_id/counterparty_info for consistency
-- Note: RPC functions already use counterparty_id, only table columns need to be renamed

-- ============================================================
-- Rename columns in trade_proforma_invoices table
-- ============================================================

ALTER TABLE trade_proforma_invoices
RENAME COLUMN buyer_id TO counterparty_id;

ALTER TABLE trade_proforma_invoices
RENAME COLUMN buyer_info TO counterparty_info;

-- Migration complete. RPC functions (trade_pi_list, trade_pi_get, trade_pi_create, etc.)
-- already use counterparty_id parameter, so no function changes needed.
