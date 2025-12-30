-- Add bank_account_ids column to trade_proforma_invoices
ALTER TABLE trade_proforma_invoices
ADD COLUMN IF NOT EXISTS bank_account_ids uuid[] DEFAULT NULL;

COMMENT ON COLUMN trade_proforma_invoices.bank_account_ids IS 'Selected bank account IDs (cash_location_ids) for PDF display';

-- Add bank_account_ids column to trade_purchase_orders
ALTER TABLE trade_purchase_orders
ADD COLUMN IF NOT EXISTS bank_account_ids uuid[] DEFAULT NULL;

COMMENT ON COLUMN trade_purchase_orders.bank_account_ids IS 'Selected bank account IDs (cash_location_ids) for PDF display';

-- Update trade_pi_convert_to_po RPC to copy bank_account_ids
CREATE OR REPLACE FUNCTION trade_pi_convert_to_po(
    p_pi_id uuid,
    p_created_by uuid DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_pi RECORD;
    v_po_id uuid;
    v_po_number text;
    v_item RECORD;
BEGIN
    -- Get PI data
    SELECT * INTO v_pi
    FROM trade_proforma_invoices
    WHERE pi_id = p_pi_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'PI not found: %', p_pi_id;
    END IF;

    -- Generate PO number
    SELECT 'PO-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' ||
           LPAD((COALESCE(MAX(CAST(SUBSTRING(po_number FROM 'PO-[0-9]{8}-([0-9]+)') AS INTEGER)), 0) + 1)::text, 4, '0')
    INTO v_po_number
    FROM trade_purchase_orders
    WHERE company_id = v_pi.company_id
    AND po_number LIKE 'PO-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-%';

    -- Create PO from PI
    INSERT INTO trade_purchase_orders (
        po_number,
        company_id,
        store_id,
        pi_id,
        supplier_id,
        supplier_info,
        buyer_info,
        currency_id,
        subtotal,
        discount_percent,
        discount_amount,
        tax_percent,
        tax_amount,
        total_amount,
        incoterms_code,
        incoterms_place,
        port_of_loading,
        port_of_discharge,
        final_destination,
        country_of_origin,
        payment_terms_code,
        payment_terms_detail,
        partial_shipment_allowed,
        transshipment_allowed,
        shipping_method_code,
        estimated_shipment_date,
        lead_time_days,
        delivery_date,
        notes,
        internal_notes,
        terms_and_conditions,
        bank_account_ids,
        created_by,
        created_at_utc
    )
    VALUES (
        v_po_number,
        v_pi.company_id,
        v_pi.store_id,
        v_pi.pi_id,
        v_pi.counterparty_id,
        v_pi.counterparty_info,
        v_pi.seller_info,
        v_pi.currency_id,
        v_pi.subtotal,
        v_pi.discount_percent,
        v_pi.discount_amount,
        v_pi.tax_percent,
        v_pi.tax_amount,
        v_pi.total_amount,
        v_pi.incoterms_code,
        v_pi.incoterms_place,
        v_pi.port_of_loading,
        v_pi.port_of_discharge,
        v_pi.final_destination,
        v_pi.country_of_origin,
        v_pi.payment_terms_code,
        v_pi.payment_terms_detail,
        v_pi.partial_shipment_allowed,
        v_pi.transshipment_allowed,
        v_pi.shipping_method_code,
        v_pi.estimated_shipment_date,
        v_pi.lead_time_days,
        v_pi.validity_date,
        v_pi.notes,
        v_pi.internal_notes,
        v_pi.terms_and_conditions,
        v_pi.bank_account_ids,
        COALESCE(p_created_by, v_pi.created_by),
        NOW()
    )
    RETURNING po_id INTO v_po_id;

    -- Copy items from PI to PO
    FOR v_item IN
        SELECT * FROM trade_pi_items WHERE pi_id = p_pi_id ORDER BY sort_order
    LOOP
        INSERT INTO trade_po_items (
            po_id,
            product_id,
            description,
            sku,
            barcode,
            hs_code,
            country_of_origin,
            quantity,
            unit,
            unit_price,
            discount_percent,
            discount_amount,
            total_amount,
            packing_info,
            image_url,
            sort_order,
            created_at_utc
        )
        VALUES (
            v_po_id,
            v_item.product_id,
            v_item.description,
            v_item.sku,
            v_item.barcode,
            v_item.hs_code,
            v_item.country_of_origin,
            v_item.quantity,
            v_item.unit,
            v_item.unit_price,
            v_item.discount_percent,
            v_item.discount_amount,
            v_item.total_amount,
            v_item.packing_info,
            v_item.image_url,
            v_item.sort_order,
            NOW()
        );
    END LOOP;

    -- Update PI status to converted
    UPDATE trade_proforma_invoices
    SET status = 'converted',
        updated_at_utc = NOW()
    WHERE pi_id = p_pi_id;

    RETURN v_po_id;
END;
$$;
