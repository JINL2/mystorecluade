-- Create function to validate if a counter party can be deleted
-- This function checks for unpaid debts and active transactions

CREATE OR REPLACE FUNCTION can_delete_counterparty(p_counterparty_id UUID)
RETURNS JSON AS $$
DECLARE
  v_unpaid_debt_count INTEGER;
  v_unpaid_debt_amount NUMERIC;
  v_active_transaction_count INTEGER;
  v_journal_entry_count INTEGER;
  v_result JSON;
BEGIN
  -- Check for unpaid debts
  SELECT
    COUNT(*),
    COALESCE(SUM(remaining_amount), 0)
  INTO
    v_unpaid_debt_count,
    v_unpaid_debt_amount
  FROM debts_receivable
  WHERE counterparty_id = p_counterparty_id
    AND is_active = true
    AND remaining_amount > 0;

  -- Check for journal entries
  SELECT COUNT(*)
  INTO v_journal_entry_count
  FROM journal_entries
  WHERE counterparty_id = p_counterparty_id;

  -- Check for journal lines
  SELECT COUNT(*)
  INTO v_active_transaction_count
  FROM journal_lines
  WHERE counterparty_id = p_counterparty_id;

  -- Build result JSON
  v_result := json_build_object(
    'can_delete', (v_unpaid_debt_count = 0 AND v_unpaid_debt_amount = 0),
    'has_unpaid_debts', (v_unpaid_debt_count > 0),
    'unpaid_debt_count', v_unpaid_debt_count,
    'unpaid_debt_amount', v_unpaid_debt_amount,
    'has_active_transactions', (v_journal_entry_count > 0 OR v_active_transaction_count > 0),
    'journal_entry_count', v_journal_entry_count,
    'journal_line_count', v_active_transaction_count,
    'reason', CASE
      WHEN v_unpaid_debt_count > 0 THEN 'Has unpaid debts'
      WHEN v_journal_entry_count > 0 OR v_active_transaction_count > 0 THEN 'Has transaction history'
      ELSE 'Can be deleted'
    END
  );

  RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION can_delete_counterparty(UUID) TO authenticated;
