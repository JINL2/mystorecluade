-- RPC Function to get invoice items detail
-- This function retrieves all line items for a specific invoice

CREATE OR REPLACE FUNCTION get_invoice_items(
  p_company_id UUID,
  p_invoice_id UUID
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_result JSON;
  v_items JSON;
BEGIN
  -- Check if user has access to this company
  IF NOT EXISTS (
    SELECT 1
    FROM user_company_access
    WHERE user_id = auth.uid()
      AND company_id = p_company_id
      AND is_active = TRUE
  ) THEN
    RETURN json_build_object(
      'success', FALSE,
      'message', 'Access denied: You do not have permission to view this invoice'
    );
  END IF;

  -- Check if invoice exists and belongs to the company
  IF NOT EXISTS (
    SELECT 1
    FROM invoices
    WHERE invoice_id = p_invoice_id
      AND company_id = p_company_id
  ) THEN
    RETURN json_build_object(
      'success', FALSE,
      'message', 'Invoice not found or does not belong to this company'
    );
  END IF;

  -- Get invoice items with product details
  SELECT json_agg(
    json_build_object(
      'item_id', ii.item_id,
      'product_id', ii.product_id,
      'product_name', p.product_name,
      'sku', p.sku,
      'barcode', p.barcode,
      'brand', b.brand_name,
      'category', c.category_name,
      'unit', p.unit,
      'quantity', ii.quantity,
      'unit_price', ii.unit_price,
      'subtotal', ii.subtotal,
      'discount_amount', ii.discount_amount,
      'discount_percentage', ii.discount_percentage,
      'tax_amount', ii.tax_amount,
      'tax_percentage', ii.tax_percentage,
      'total_amount', ii.total_amount,
      'notes', ii.notes
    )
    ORDER BY ii.line_number, ii.created_at
  ) INTO v_items
  FROM invoice_items ii
  INNER JOIN products p ON p.product_id = ii.product_id
  LEFT JOIN brands b ON b.brand_id = p.brand_id
  LEFT JOIN categories c ON c.category_id = p.category_id
  WHERE ii.invoice_id = p_invoice_id;

  -- Return the result
  RETURN json_build_object(
    'success', TRUE,
    'items', COALESCE(v_items, '[]'::json),
    'message', NULL
  );

EXCEPTION
  WHEN OTHERS THEN
    -- Log error and return failure response
    RAISE LOG 'Error in get_invoice_items: %', SQLERRM;
    RETURN json_build_object(
      'success', FALSE,
      'message', 'An error occurred while fetching invoice items',
      'error', SQLERRM
    );
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_invoice_items(UUID, UUID) TO authenticated;

-- Comment on function
COMMENT ON FUNCTION get_invoice_items(UUID, UUID) IS 'Retrieves all line items for a specific invoice with product details';

-- Example usage:
-- SELECT get_invoice_items('company-uuid-here', 'invoice-uuid-here');