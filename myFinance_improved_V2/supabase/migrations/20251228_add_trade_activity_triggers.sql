-- ============================================================================
-- Migration: Complete Trade Activity Logging System
-- Version: 2.0
-- Created: 2025-12-28
-- Description: Automatic activity logging for all trade documents
--              Based on TRADE_LC_WORKFLOW.md specification
-- ============================================================================

-- ============================================================================
-- PART 1: CORE ACTIVITY LOGGING FUNCTIONS
-- ============================================================================

-- Generic activity logging helper function
CREATE OR REPLACE FUNCTION trade_log_activity(
  p_company_id UUID,
  p_store_id UUID,
  p_entity_type VARCHAR,
  p_entity_id UUID,
  p_entity_number VARCHAR,
  p_action VARCHAR,
  p_action_detail TEXT,
  p_previous_status VARCHAR,
  p_new_status VARCHAR,
  p_created_by UUID DEFAULT NULL,
  p_changes JSONB DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_log_id UUID;
BEGIN
  INSERT INTO trade_activity_logs (
    log_id, company_id, store_id, entity_type, entity_id, entity_number,
    action, action_detail, previous_status, new_status, created_by,
    changes, created_at_utc
  ) VALUES (
    gen_random_uuid(), p_company_id, p_store_id, p_entity_type, p_entity_id, p_entity_number,
    p_action, p_action_detail, p_previous_status, p_new_status, p_created_by,
    p_changes, NOW()
  )
  RETURNING log_id INTO v_log_id;

  RETURN v_log_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- PART 2: PI (Proforma Invoice) TRIGGER
-- Status flow: draft -> sent -> accepted/negotiating/rejected -> converted
-- ============================================================================

CREATE OR REPLACE FUNCTION trade_log_pi_activity()
RETURNS TRIGGER AS $$
DECLARE
  v_action_detail TEXT;
BEGIN
  -- INSERT: New PI created
  IF TG_OP = 'INSERT' THEN
    PERFORM trade_log_activity(
      NEW.company_id, NEW.store_id, 'PI', NEW.pi_id, NEW.pi_number,
      'CREATE', 'New Proforma Invoice created',
      NULL, NEW.status, NEW.created_by
    );
    RETURN NEW;
  END IF;

  -- UPDATE: Check for status changes
  IF TG_OP = 'UPDATE' THEN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
      -- Determine action detail based on status transition
      v_action_detail := CASE
        WHEN NEW.status = 'sent' THEN 'PI sent to buyer'
        WHEN NEW.status = 'accepted' THEN 'PI accepted by buyer'
        WHEN NEW.status = 'rejected' THEN 'PI rejected by buyer'
        WHEN NEW.status = 'negotiating' THEN 'PI under negotiation'
        WHEN NEW.status = 'converted' THEN 'PI converted to Purchase Order'
        WHEN NEW.status = 'expired' THEN 'PI validity expired'
        WHEN NEW.status = 'cancelled' THEN 'PI cancelled'
        ELSE 'PI status changed to ' || NEW.status
      END;

      PERFORM trade_log_activity(
        NEW.company_id, NEW.store_id, 'PI', NEW.pi_id, NEW.pi_number,
        'STATUS_CHANGE', v_action_detail,
        OLD.status, NEW.status, NEW.created_by
      );
    END IF;
    RETURN NEW;
  END IF;

  -- DELETE: PI deleted
  IF TG_OP = 'DELETE' THEN
    PERFORM trade_log_activity(
      OLD.company_id, OLD.store_id, 'PI', OLD.pi_id, OLD.pi_number,
      'DELETE', 'Proforma Invoice deleted',
      OLD.status, NULL, NULL
    );
    RETURN OLD;
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_trade_pi_activity ON trade_proforma_invoices;
CREATE TRIGGER trigger_trade_pi_activity
  AFTER INSERT OR UPDATE OR DELETE ON trade_proforma_invoices
  FOR EACH ROW EXECUTE FUNCTION trade_log_pi_activity();

-- ============================================================================
-- PART 3: PO (Purchase Order) TRIGGER
-- Status flow: draft -> confirmed -> in_production -> ready_to_ship
--              -> partially_shipped/shipped -> completed
-- ============================================================================

CREATE OR REPLACE FUNCTION trade_log_po_activity()
RETURNS TRIGGER AS $$
DECLARE
  v_action_detail TEXT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    PERFORM trade_log_activity(
      NEW.company_id, NEW.store_id, 'PO', NEW.po_id, NEW.po_number,
      'CREATE',
      CASE
        WHEN NEW.pi_id IS NOT NULL THEN 'Purchase Order created from PI'
        ELSE 'New Purchase Order created'
      END,
      NULL, NEW.status, NEW.created_by
    );
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' THEN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
      v_action_detail := CASE
        WHEN NEW.status = 'confirmed' THEN 'PO confirmed'
        WHEN NEW.status = 'in_production' THEN 'Production started'
        WHEN NEW.status = 'ready_to_ship' THEN 'Production complete, ready to ship'
        WHEN NEW.status = 'partially_shipped' THEN 'Partial shipment dispatched'
        WHEN NEW.status = 'shipped' THEN 'All items shipped'
        WHEN NEW.status = 'completed' THEN 'PO completed'
        WHEN NEW.status = 'cancelled' THEN 'PO cancelled'
        ELSE 'PO status changed to ' || NEW.status
      END;

      PERFORM trade_log_activity(
        NEW.company_id, NEW.store_id, 'PO', NEW.po_id, NEW.po_number,
        'STATUS_CHANGE', v_action_detail,
        OLD.status, NEW.status, NEW.created_by
      );
    END IF;
    RETURN NEW;
  END IF;

  IF TG_OP = 'DELETE' THEN
    PERFORM trade_log_activity(
      OLD.company_id, OLD.store_id, 'PO', OLD.po_id, OLD.po_number,
      'DELETE', 'Purchase Order deleted',
      OLD.status, NULL, NULL
    );
    RETURN OLD;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_trade_po_activity ON trade_purchase_orders;
CREATE TRIGGER trigger_trade_po_activity
  AFTER INSERT OR UPDATE OR DELETE ON trade_purchase_orders
  FOR EACH ROW EXECUTE FUNCTION trade_log_po_activity();

-- ============================================================================
-- PART 4: L/C (Letter of Credit) TRIGGER
-- Status flow: draft -> pending -> issued -> advised -> confirmed
--              -> partially_shipped/fully_shipped -> documents_presented
--              -> under_examination -> accepted/discrepancy -> payment_pending -> paid
-- ============================================================================

CREATE OR REPLACE FUNCTION trade_log_lc_activity()
RETURNS TRIGGER AS $$
DECLARE
  v_action_detail TEXT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    PERFORM trade_log_activity(
      NEW.company_id, NEW.store_id, 'LC', NEW.lc_id, NEW.lc_number,
      'CREATE', 'Letter of Credit opened',
      NULL, NEW.status, NEW.created_by
    );
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' THEN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
      v_action_detail := CASE
        WHEN NEW.status = 'pending' THEN 'L/C submitted for issuance'
        WHEN NEW.status = 'issued' THEN 'L/C issued by issuing bank'
        WHEN NEW.status = 'advised' THEN 'L/C advised by advising bank'
        WHEN NEW.status = 'confirmed' THEN 'L/C confirmed by advising bank'
        WHEN NEW.status = 'amendment_requested' THEN 'L/C amendment requested'
        WHEN NEW.status = 'amended' THEN 'L/C amendment completed'
        WHEN NEW.status = 'partially_shipped' THEN 'Partial shipment against L/C'
        WHEN NEW.status = 'fully_shipped' THEN 'Full shipment against L/C completed'
        WHEN NEW.status = 'documents_presented' THEN 'Documents presented to bank'
        WHEN NEW.status = 'under_examination' THEN 'Documents under bank examination'
        WHEN NEW.status = 'accepted' THEN 'Documents accepted by bank'
        WHEN NEW.status = 'discrepancy' THEN 'Discrepancy found in documents'
        WHEN NEW.status = 'payment_pending' THEN 'Payment pending'
        WHEN NEW.status = 'paid' THEN 'L/C payment completed'
        WHEN NEW.status = 'expired' THEN 'L/C expired'
        WHEN NEW.status = 'cancelled' THEN 'L/C cancelled'
        ELSE 'L/C status changed to ' || NEW.status
      END;

      PERFORM trade_log_activity(
        NEW.company_id, NEW.store_id, 'LC', NEW.lc_id, NEW.lc_number,
        'STATUS_CHANGE', v_action_detail,
        OLD.status, NEW.status, NEW.created_by
      );
    END IF;

    -- Log amendment if amendment fields changed
    IF OLD.amendment_count IS DISTINCT FROM NEW.amendment_count THEN
      PERFORM trade_log_activity(
        NEW.company_id, NEW.store_id, 'LC', NEW.lc_id, NEW.lc_number,
        'AMENDMENT', 'L/C amendment #' || NEW.amendment_count || ' applied',
        OLD.status, NEW.status, NEW.created_by
      );
    END IF;

    RETURN NEW;
  END IF;

  IF TG_OP = 'DELETE' THEN
    PERFORM trade_log_activity(
      OLD.company_id, OLD.store_id, 'LC', OLD.lc_id, OLD.lc_number,
      'DELETE', 'Letter of Credit deleted',
      OLD.status, NULL, NULL
    );
    RETURN OLD;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_trade_lc_activity ON trade_letters_of_credit;
CREATE TRIGGER trigger_trade_lc_activity
  AFTER INSERT OR UPDATE OR DELETE ON trade_letters_of_credit
  FOR EACH ROW EXECUTE FUNCTION trade_log_lc_activity();

-- ============================================================================
-- PART 5: SHIPMENT TRIGGER
-- Status flow: draft -> booked -> at_origin_port -> loaded -> departed
--              -> in_transit -> at_destination_port -> customs_clearance
--              -> out_for_delivery -> delivered
-- ============================================================================

CREATE OR REPLACE FUNCTION trade_log_shipment_activity()
RETURNS TRIGGER AS $$
DECLARE
  v_action_detail TEXT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    PERFORM trade_log_activity(
      NEW.company_id, NEW.store_id, 'SHIPMENT', NEW.shipment_id, NEW.shipment_number,
      'CREATE', 'New Shipment created',
      NULL, NEW.status, NEW.created_by
    );
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' THEN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
      v_action_detail := CASE
        WHEN NEW.status = 'booked' THEN 'Shipment booked with carrier'
        WHEN NEW.status = 'at_origin_port' THEN 'Cargo arrived at origin port'
        WHEN NEW.status = 'loaded' THEN 'Cargo loaded on vessel (B/L issued)'
        WHEN NEW.status = 'departed' THEN 'Vessel departed from port'
        WHEN NEW.status = 'in_transit' THEN 'Shipment in transit'
        WHEN NEW.status = 'at_destination_port' THEN 'Arrived at destination port'
        WHEN NEW.status = 'customs_clearance' THEN 'Customs clearance in progress'
        WHEN NEW.status = 'out_for_delivery' THEN 'Out for delivery'
        WHEN NEW.status = 'delivered' THEN 'Shipment delivered'
        WHEN NEW.status = 'cancelled' THEN 'Shipment cancelled'
        ELSE 'Shipment status changed to ' || NEW.status
      END;

      PERFORM trade_log_activity(
        NEW.company_id, NEW.store_id, 'SHIPMENT', NEW.shipment_id, NEW.shipment_number,
        'STATUS_CHANGE', v_action_detail,
        OLD.status, NEW.status, NEW.created_by
      );
    END IF;

    -- Log tracking updates
    IF OLD.tracking_number IS DISTINCT FROM NEW.tracking_number AND NEW.tracking_number IS NOT NULL THEN
      PERFORM trade_log_activity(
        NEW.company_id, NEW.store_id, 'SHIPMENT', NEW.shipment_id, NEW.shipment_number,
        'TRACKING_UPDATE', 'Tracking number updated: ' || NEW.tracking_number,
        NEW.status, NEW.status, NEW.created_by
      );
    END IF;

    RETURN NEW;
  END IF;

  IF TG_OP = 'DELETE' THEN
    PERFORM trade_log_activity(
      OLD.company_id, OLD.store_id, 'SHIPMENT', OLD.shipment_id, OLD.shipment_number,
      'DELETE', 'Shipment deleted',
      OLD.status, NULL, NULL
    );
    RETURN OLD;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_trade_shipment_activity ON trade_shipments;
CREATE TRIGGER trigger_trade_shipment_activity
  AFTER INSERT OR UPDATE OR DELETE ON trade_shipments
  FOR EACH ROW EXECUTE FUNCTION trade_log_shipment_activity();

-- ============================================================================
-- PART 6: CI (Commercial Invoice) TRIGGER
-- Status flow: draft -> finalized -> submitted -> under_review
--              -> accepted/discrepancy -> discrepancy_resolved -> payment_pending -> paid
-- ============================================================================

CREATE OR REPLACE FUNCTION trade_log_ci_activity()
RETURNS TRIGGER AS $$
DECLARE
  v_action_detail TEXT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    PERFORM trade_log_activity(
      NEW.company_id, NEW.store_id, 'CI', NEW.ci_id, NEW.ci_number,
      'CREATE', 'Commercial Invoice created',
      NULL, NEW.status, NEW.created_by
    );
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' THEN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
      v_action_detail := CASE
        WHEN NEW.status = 'finalized' THEN 'CI finalized'
        WHEN NEW.status = 'submitted' THEN 'CI submitted to bank'
        WHEN NEW.status = 'under_review' THEN 'CI under bank review'
        WHEN NEW.status = 'accepted' THEN 'CI accepted by bank'
        WHEN NEW.status = 'discrepancy' THEN 'Discrepancy found in CI'
        WHEN NEW.status = 'discrepancy_resolved' THEN 'CI discrepancy resolved'
        WHEN NEW.status = 'rejected' THEN 'CI rejected'
        WHEN NEW.status = 'payment_pending' THEN 'Payment pending for CI'
        WHEN NEW.status = 'paid' THEN 'CI payment completed'
        ELSE 'CI status changed to ' || NEW.status
      END;

      PERFORM trade_log_activity(
        NEW.company_id, NEW.store_id, 'CI', NEW.ci_id, NEW.ci_number,
        'STATUS_CHANGE', v_action_detail,
        OLD.status, NEW.status, NEW.created_by
      );
    END IF;
    RETURN NEW;
  END IF;

  IF TG_OP = 'DELETE' THEN
    PERFORM trade_log_activity(
      OLD.company_id, OLD.store_id, 'CI', OLD.ci_id, OLD.ci_number,
      'DELETE', 'Commercial Invoice deleted',
      OLD.status, NULL, NULL
    );
    RETURN OLD;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_trade_ci_activity ON trade_commercial_invoices;
CREATE TRIGGER trigger_trade_ci_activity
  AFTER INSERT OR UPDATE OR DELETE ON trade_commercial_invoices
  FOR EACH ROW EXECUTE FUNCTION trade_log_ci_activity();

-- ============================================================================
-- PART 7: PAYMENT TRIGGER
-- Status flow: pending -> processing -> partial/completed/failed -> refunded
-- ============================================================================

CREATE OR REPLACE FUNCTION trade_log_payment_activity()
RETURNS TRIGGER AS $$
DECLARE
  v_action_detail TEXT;
  v_entity_number VARCHAR;
BEGIN
  -- Generate payment reference number
  v_entity_number := COALESCE(NEW.payment_reference, 'PMT-' || SUBSTRING(NEW.payment_id::TEXT FROM 1 FOR 8));

  IF TG_OP = 'INSERT' THEN
    PERFORM trade_log_activity(
      NEW.company_id, NULL, 'PAYMENT', NEW.payment_id, v_entity_number,
      'CREATE', 'Payment record created for amount ' || NEW.amount || ' ' || COALESCE(NEW.currency_code, 'USD'),
      NULL, NEW.status, NEW.created_by
    );
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' THEN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
      v_action_detail := CASE
        WHEN NEW.status = 'processing' THEN 'Payment processing started'
        WHEN NEW.status = 'partial' THEN 'Partial payment received'
        WHEN NEW.status = 'completed' THEN 'Payment completed'
        WHEN NEW.status = 'failed' THEN 'Payment failed'
        WHEN NEW.status = 'refunded' THEN 'Payment refunded'
        ELSE 'Payment status changed to ' || NEW.status
      END;

      PERFORM trade_log_activity(
        NEW.company_id, NULL, 'PAYMENT', NEW.payment_id, v_entity_number,
        'STATUS_CHANGE', v_action_detail,
        OLD.status, NEW.status, NEW.created_by
      );
    END IF;
    RETURN NEW;
  END IF;

  IF TG_OP = 'DELETE' THEN
    v_entity_number := COALESCE(OLD.payment_reference, 'PMT-' || SUBSTRING(OLD.payment_id::TEXT FROM 1 FOR 8));
    PERFORM trade_log_activity(
      OLD.company_id, NULL, 'PAYMENT', OLD.payment_id, v_entity_number,
      'DELETE', 'Payment record deleted',
      OLD.status, NULL, NULL
    );
    RETURN OLD;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_trade_payment_activity ON trade_payments;
CREATE TRIGGER trigger_trade_payment_activity
  AFTER INSERT OR UPDATE OR DELETE ON trade_payments
  FOR EACH ROW EXECUTE FUNCTION trade_log_payment_activity();

-- ============================================================================
-- PART 8: DOCUMENT UPLOAD TRIGGER
-- ============================================================================

CREATE OR REPLACE FUNCTION trade_log_document_activity()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    PERFORM trade_log_activity(
      NEW.company_id, NULL, 'DOCUMENT', NEW.document_id, NEW.file_name,
      'UPLOAD', 'Document uploaded: ' || NEW.document_type || ' for ' || NEW.entity_type || ' ' || COALESCE(NEW.entity_number, ''),
      NULL, 'uploaded', NEW.created_by
    );
    RETURN NEW;
  END IF;

  IF TG_OP = 'DELETE' THEN
    PERFORM trade_log_activity(
      OLD.company_id, NULL, 'DOCUMENT', OLD.document_id, OLD.file_name,
      'DELETE', 'Document deleted: ' || OLD.document_type,
      'uploaded', NULL, NULL
    );
    RETURN OLD;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_trade_document_activity ON trade_documents;
CREATE TRIGGER trigger_trade_document_activity
  AFTER INSERT OR DELETE ON trade_documents
  FOR EACH ROW EXECUTE FUNCTION trade_log_document_activity();

-- ============================================================================
-- PART 9: BACKFILL EXISTING DATA
-- Add activity logs for existing records that don't have CREATE entries
-- ============================================================================

-- Backfill PI
INSERT INTO trade_activity_logs (
  log_id, company_id, store_id, entity_type, entity_id, entity_number,
  action, action_detail, previous_status, new_status, created_by, created_at_utc
)
SELECT
  gen_random_uuid(), pi.company_id, pi.store_id, 'PI', pi.pi_id, pi.pi_number,
  'CREATE', 'New Proforma Invoice created (backfill)', NULL, pi.status,
  pi.created_by, COALESCE(pi.created_at_utc, NOW())
FROM trade_proforma_invoices pi
WHERE NOT EXISTS (
  SELECT 1 FROM trade_activity_logs al
  WHERE al.entity_id = pi.pi_id AND al.entity_type = 'PI' AND al.action = 'CREATE'
);

-- Backfill PO
INSERT INTO trade_activity_logs (
  log_id, company_id, store_id, entity_type, entity_id, entity_number,
  action, action_detail, previous_status, new_status, created_by, created_at_utc
)
SELECT
  gen_random_uuid(), po.company_id, po.store_id, 'PO', po.po_id, po.po_number,
  'CREATE', 'New Purchase Order created (backfill)', NULL, po.status,
  po.created_by, COALESCE(po.created_at_utc, NOW())
FROM trade_purchase_orders po
WHERE NOT EXISTS (
  SELECT 1 FROM trade_activity_logs al
  WHERE al.entity_id = po.po_id AND al.entity_type = 'PO' AND al.action = 'CREATE'
);

-- Backfill LC
INSERT INTO trade_activity_logs (
  log_id, company_id, store_id, entity_type, entity_id, entity_number,
  action, action_detail, previous_status, new_status, created_by, created_at_utc
)
SELECT
  gen_random_uuid(), lc.company_id, lc.store_id, 'LC', lc.lc_id, lc.lc_number,
  'CREATE', 'Letter of Credit opened (backfill)', NULL, lc.status,
  lc.created_by, COALESCE(lc.created_at_utc, NOW())
FROM trade_letters_of_credit lc
WHERE NOT EXISTS (
  SELECT 1 FROM trade_activity_logs al
  WHERE al.entity_id = lc.lc_id AND al.entity_type = 'LC' AND al.action = 'CREATE'
);

-- Backfill Shipment
INSERT INTO trade_activity_logs (
  log_id, company_id, store_id, entity_type, entity_id, entity_number,
  action, action_detail, previous_status, new_status, created_by, created_at_utc
)
SELECT
  gen_random_uuid(), s.company_id, s.store_id, 'SHIPMENT', s.shipment_id, s.shipment_number,
  'CREATE', 'New Shipment created (backfill)', NULL, s.status,
  s.created_by, COALESCE(s.created_at_utc, NOW())
FROM trade_shipments s
WHERE NOT EXISTS (
  SELECT 1 FROM trade_activity_logs al
  WHERE al.entity_id = s.shipment_id AND al.entity_type = 'SHIPMENT' AND al.action = 'CREATE'
);

-- Backfill CI
INSERT INTO trade_activity_logs (
  log_id, company_id, store_id, entity_type, entity_id, entity_number,
  action, action_detail, previous_status, new_status, created_by, created_at_utc
)
SELECT
  gen_random_uuid(), ci.company_id, ci.store_id, 'CI', ci.ci_id, ci.ci_number,
  'CREATE', 'Commercial Invoice created (backfill)', NULL, ci.status,
  ci.created_by, COALESCE(ci.created_at_utc, NOW())
FROM trade_commercial_invoices ci
WHERE NOT EXISTS (
  SELECT 1 FROM trade_activity_logs al
  WHERE al.entity_id = ci.ci_id AND al.entity_type = 'CI' AND al.action = 'CREATE'
);

-- ============================================================================
-- PART 10: GRANT PERMISSIONS
-- ============================================================================

-- Ensure the function can insert into trade_activity_logs
GRANT INSERT ON trade_activity_logs TO authenticated;
GRANT INSERT ON trade_activity_logs TO service_role;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO service_role;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Check triggers are created
DO $$
DECLARE
  trigger_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO trigger_count
  FROM information_schema.triggers
  WHERE trigger_name LIKE 'trigger_trade_%';

  RAISE NOTICE 'Created % trade activity triggers', trigger_count;
END $$;
