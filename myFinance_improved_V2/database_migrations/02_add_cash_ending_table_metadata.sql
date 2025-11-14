-- ============================================================================
-- Migration: Add Table Metadata for Cash Ending Tables
-- Description: Define column meanings, business rules, and fraud detection rules
-- Date: 2025-01-14
-- ============================================================================

-- Delete existing metadata for cash ending tables (if any)
DELETE FROM table_metadata
WHERE table_name IN (
  'cash_control',
  'cash_amount_stock_flow',
  'bank_amount',
  'vault_amount_line',
  'cash_locations',
  'currency_denominations',
  'cashier_amount_lines'
);

-- ============================================================================
-- 1. cash_control (Daily Cash Ending Control Records)
-- ============================================================================

INSERT INTO table_metadata (table_name, column_name, meaning, calculation_formula, normal_range, business_rules, fraud_detection_rules, severity) VALUES

('cash_control', 'control_id', 'Unique identifier for cash control record', NULL, NULL, 'Primary key, auto-generated UUID', NULL, NULL),
('cash_control', 'company_id', 'Company identifier', NULL, NULL, 'Must reference valid company. Required field.', NULL, NULL),
('cash_control', 'store_id', 'Store identifier', NULL, NULL, 'Must reference valid store. Required field. Used for filtering.', NULL, NULL),
('cash_control', 'location_id', 'Cash location identifier', NULL, NULL, 'Must reference valid cash_locations record. Determines where cash is counted.', NULL, NULL),
('cash_control', 'record_date', 'Date of cash ending record', NULL, NULL, 'Cannot be future date. Typically end-of-day.', '{"type": "impossible_date", "check": "record_date > CURRENT_DATE", "message": "Cash ending date cannot be in the future"}'::jsonb, 'high'),
('cash_control', 'actual_amount', 'Total actual cash amount counted', 'SUM of all denominations * quantities from cashier_amount_lines', '>= 0', 'Cannot be negative. Should align with daily sales minus deposits.', '{"type": "negative_amount", "check": "actual_amount < 0", "message": "Actual amount cannot be negative"}'::jsonb, 'critical'),
('cash_control', 'created_by', 'User who created this record', NULL, NULL, 'Must reference valid user. For audit trail.', NULL, NULL),
('cash_control', 'created_at', 'Timestamp when record was created', NULL, NULL, 'Auto-generated timestamp. For audit trail.', NULL, NULL);

-- ============================================================================
-- 2. cashier_amount_lines (Denomination Details for Cash Ending)
-- ============================================================================

INSERT INTO table_metadata (table_name, column_name, meaning, calculation_formula, normal_range, business_rules, fraud_detection_rules, severity) VALUES

('cashier_amount_lines', 'line_id', 'Unique identifier for each denomination line', NULL, NULL, 'Primary key, auto-generated UUID', NULL, NULL),
('cashier_amount_lines', 'company_id', 'Company identifier', NULL, NULL, 'Must reference valid company', NULL, NULL),
('cashier_amount_lines', 'store_id', 'Store identifier', NULL, NULL, 'Must reference valid store', NULL, NULL),
('cashier_amount_lines', 'location_id', 'Cash location identifier', NULL, NULL, 'Links to cash_control record', NULL, NULL),
('cashier_amount_lines', 'currency_id', 'Currency identifier', NULL, NULL, 'Must reference valid currency', NULL, NULL),
('cashier_amount_lines', 'record_date', 'Date of this denomination count', NULL, NULL, 'Must match cash_control.record_date', NULL, NULL),
('cashier_amount_lines', 'denomination_id', 'Specific denomination (e.g., 50000 KRW bill, 500 KRW coin)', NULL, NULL, 'Must reference valid currency_denominations', NULL, NULL),
('cashier_amount_lines', 'quantity', 'Number of pieces for this denomination', NULL, '>= 0', 'Cannot be negative. 0 is valid (no pieces of this denomination).', '{"type": "negative_quantity", "check": "quantity < 0", "message": "Quantity cannot be negative"}'::jsonb, 'high'),
('cashier_amount_lines', 'created_by', 'User who entered this denomination count', NULL, NULL, 'For audit purposes', NULL, NULL),
('cashier_amount_lines', 'created_at', 'Timestamp of entry', NULL, NULL, 'Auto-generated', NULL, NULL);

-- ============================================================================
-- 3. bank_amount (Bank Account Balances)
-- ============================================================================

INSERT INTO table_metadata (table_name, column_name, meaning, calculation_formula, normal_range, business_rules, fraud_detection_rules, severity) VALUES

('bank_amount', 'bank_amount_id', 'Unique identifier for bank balance record', NULL, NULL, 'Primary key, auto-generated UUID', NULL, NULL),
('bank_amount', 'company_id', 'Company identifier', NULL, NULL, 'Must reference valid company', NULL, NULL),
('bank_amount', 'store_id', 'Store identifier', NULL, NULL, 'Must reference valid store. Some banks may be at HQ level.', NULL, NULL),
('bank_amount', 'location_id', 'Bank location identifier', NULL, NULL, 'Must reference cash_locations with type=bank', NULL, NULL),
('bank_amount', 'currency_id', 'Currency of bank account', NULL, NULL, 'Must reference valid currency', NULL, NULL),
('bank_amount', 'record_date', 'Date of bank balance snapshot', NULL, NULL, 'Typically end-of-day balance', '{"type": "impossible_date", "check": "record_date > CURRENT_DATE", "message": "Bank record date cannot be in future"}'::jsonb, 'medium'),
('bank_amount', 'total_amount', 'Total balance in bank account', NULL, 'Can be negative (overdraft)', 'Negative values possible but should be flagged', '{"type": "unusual_balance", "check": "total_amount < -1000000", "message": "Extremely negative bank balance detected"}'::jsonb, 'high'),
('bank_amount', 'created_by', 'User who recorded this balance', NULL, NULL, 'For audit trail', NULL, NULL),
('bank_amount', 'created_at', 'Timestamp of record creation', NULL, NULL, 'Auto-generated', NULL, NULL);

-- ============================================================================
-- 4. vault_amount_line (Vault Deposits/Withdrawals)
-- ============================================================================

INSERT INTO table_metadata (table_name, column_name, meaning, calculation_formula, normal_range, business_rules, fraud_detection_rules, severity) VALUES

('vault_amount_line', 'vault_amount_id', 'Unique identifier for vault transaction', NULL, NULL, 'Primary key, auto-generated UUID', NULL, NULL),
('vault_amount_line', 'company_id', 'Company identifier', NULL, NULL, 'Must reference valid company', NULL, NULL),
('vault_amount_line', 'store_id', 'Store identifier', NULL, NULL, 'Must reference valid store', NULL, NULL),
('vault_amount_line', 'location_id', 'Vault location identifier', NULL, NULL, 'Must reference cash_locations with type=vault', NULL, NULL),
('vault_amount_line', 'currency_id', 'Currency of transaction', NULL, NULL, 'Must reference valid currency', NULL, NULL),
('vault_amount_line', 'debit', 'Deposit amount (money going INTO vault)', NULL, '>= 0', 'Cannot be negative. Use credit for withdrawals.', '{"type": "negative_debit", "check": "debit < 0", "message": "Debit amount cannot be negative"}'::jsonb, 'high'),
('vault_amount_line', 'credit', 'Withdrawal amount (money coming OUT of vault)', NULL, '>= 0', 'Cannot be negative. Use debit for deposits.', '{"type": "negative_credit", "check": "credit < 0", "message": "Credit amount cannot be negative"}'::jsonb, 'high'),
('vault_amount_line', 'record_date', 'Date of vault transaction', NULL, NULL, 'Cannot be future date', '{"type": "future_transaction", "check": "record_date > CURRENT_DATE", "message": "Vault transaction date cannot be in future"}'::jsonb, 'high'),
('vault_amount_line', 'denomination_id', 'Specific denomination involved', NULL, NULL, 'Optional. For denomination-level tracking.', NULL, NULL),
('vault_amount_line', 'created_by', 'User who recorded this transaction', NULL, NULL, 'For audit trail', NULL, NULL),
('vault_amount_line', 'created_at', 'Timestamp of transaction record', NULL, NULL, 'Auto-generated', NULL, NULL);

-- ============================================================================
-- 5. cash_amount_stock_flow (Historical Cash Flow Records)
-- ============================================================================

INSERT INTO table_metadata (table_name, column_name, meaning, calculation_formula, normal_range, business_rules, fraud_detection_rules, severity) VALUES

('cash_amount_stock_flow', 'flow_id', 'Unique identifier for flow record', NULL, NULL, 'Primary key, auto-generated UUID', NULL, NULL),
('cash_amount_stock_flow', 'company_id', 'Company identifier', NULL, NULL, 'Must reference valid company', NULL, NULL),
('cash_amount_stock_flow', 'store_id', 'Store identifier', NULL, NULL, 'Must reference valid store', NULL, NULL),
('cash_amount_stock_flow', 'cash_location_id', 'Cash location identifier', NULL, NULL, 'Where cash movement occurred', NULL, NULL),
('cash_amount_stock_flow', 'location_type', 'Type of location (cash/bank/vault)', NULL, 'cash, bank, vault', 'Must be one of the valid types', NULL, NULL),
('cash_amount_stock_flow', 'currency_id', 'Currency of the flow', NULL, NULL, 'Must reference valid currency', NULL, NULL),
('cash_amount_stock_flow', 'flow_amount', 'Amount of cash movement', NULL, 'Can be positive or negative', 'Positive = inflow, Negative = outflow', '{"type": "extreme_flow", "check": "ABS(flow_amount) > 100000000", "message": "Extremely large cash flow detected"}'::jsonb, 'medium'),
('cash_amount_stock_flow', 'balance_before', 'Balance before this transaction', NULL, '>= 0 (typically)', 'Should not be negative unless overdraft allowed', NULL, NULL),
('cash_amount_stock_flow', 'balance_after', 'Balance after this transaction', 'balance_before + flow_amount', '>= 0 (typically)', 'Should match: balance_before + flow_amount', '{"type": "balance_mismatch", "check": "balance_after != balance_before + flow_amount", "message": "Balance calculation mismatch"}'::jsonb, 'critical'),
('cash_amount_stock_flow', 'denomination_details', 'JSONB containing denomination breakdown', NULL, NULL, 'Optional detailed breakdown by denomination', NULL, NULL),
('cash_amount_stock_flow', 'created_by', 'User who created this flow', NULL, NULL, 'For audit purposes', NULL, NULL),
('cash_amount_stock_flow', 'created_at', 'Timestamp of flow creation', NULL, NULL, 'Auto-generated', NULL, NULL),
('cash_amount_stock_flow', 'system_time', 'System timestamp for temporal queries', NULL, NULL, 'Used for historical tracking', NULL, NULL),
('cash_amount_stock_flow', 'base_currency_id', 'Base currency for multi-currency conversion', NULL, NULL, 'Used when converting to company base currency', NULL, NULL),
('cash_amount_stock_flow', 'applied_exchange_rate', 'Exchange rate applied for conversion', NULL, '> 0', 'Must be positive if used', NULL, NULL),
('cash_amount_stock_flow', 'original_currency_amount', 'Amount in original currency before conversion', NULL, NULL, 'Used for multi-currency tracking', NULL, NULL);

-- ============================================================================
-- 6. cash_locations (Cash Storage Locations)
-- ============================================================================

INSERT INTO table_metadata (table_name, column_name, meaning, calculation_formula, normal_range, business_rules, fraud_detection_rules, severity) VALUES

('cash_locations', 'cash_location_id', 'Unique identifier for cash location', NULL, NULL, 'Primary key, auto-generated UUID', NULL, NULL),
('cash_locations', 'company_id', 'Company identifier', NULL, NULL, 'Must reference valid company', NULL, NULL),
('cash_locations', 'store_id', 'Store identifier', NULL, NULL, 'NULL for HQ-level locations', NULL, NULL),
('cash_locations', 'location_name', 'Descriptive name of location', NULL, NULL, 'E.g., "Main Cash Drawer", "Safe Deposit Box #1"', NULL, NULL),
('cash_locations', 'location_type', 'Type of location', NULL, 'cash, bank, vault', 'Determines which operations are allowed', NULL, NULL),
('cash_locations', 'currency_id', 'Primary currency for this location', NULL, NULL, 'Most locations have a primary currency', NULL, NULL),
('cash_locations', 'currency_code', 'ISO currency code', NULL, NULL, 'E.g., KRW, USD, VND', NULL, NULL),
('cash_locations', 'bank_account', 'Bank account number', NULL, NULL, 'Only for location_type=bank', NULL, NULL),
('cash_locations', 'bank_name', 'Name of bank', NULL, NULL, 'Only for location_type=bank', NULL, NULL),
('cash_locations', 'main_cash_location', 'Is this the main cash location for the store?', NULL, NULL, 'Boolean flag. Typically one per store.', NULL, NULL),
('cash_locations', 'icon', 'Icon identifier for UI', NULL, NULL, 'For visual representation', NULL, NULL),
('cash_locations', 'note', 'Additional notes', NULL, NULL, 'Free text notes', NULL, NULL),
('cash_locations', 'location_info', 'Additional structured information (JSONB)', NULL, NULL, 'Extra metadata as needed', NULL, NULL),
('cash_locations', 'is_deleted', 'Soft delete flag', NULL, NULL, 'True = location is inactive', NULL, NULL),
('cash_locations', 'deleted_at', 'Timestamp of soft deletion', NULL, NULL, 'Set when is_deleted becomes true', NULL, NULL),
('cash_locations', 'created_at', 'Timestamp of location creation', NULL, NULL, 'Auto-generated', NULL, NULL);

-- ============================================================================
-- 7. currency_denominations (Currency Denomination Master Data)
-- ============================================================================

INSERT INTO table_metadata (table_name, column_name, meaning, calculation_formula, normal_range, business_rules, fraud_detection_rules, severity) VALUES

('currency_denominations', 'denomination_id', 'Unique identifier for denomination', NULL, NULL, 'Primary key, auto-generated UUID', NULL, NULL),
('currency_denominations', 'currency_id', 'Currency this denomination belongs to', NULL, NULL, 'Must reference valid currency', NULL, NULL),
('currency_denominations', 'company_id', 'Company identifier', NULL, NULL, 'Company-specific denominations possible', NULL, NULL),
('currency_denominations', 'value', 'Numeric value of denomination', NULL, '> 0', 'E.g., 50000 for 50,000 KRW bill, 0.25 for US quarter', '{"type": "invalid_value", "check": "value <= 0", "message": "Denomination value must be positive"}'::jsonb, 'high'),
('currency_denominations', 'type', 'Type of denomination', NULL, 'bill, coin', 'Either paper bill or metal coin', NULL, NULL),
('currency_denominations', 'is_deleted', 'Soft delete flag', NULL, NULL, 'True = denomination no longer in use', NULL, NULL),
('currency_denominations', 'created_at', 'Timestamp of creation', NULL, NULL, 'Auto-generated', NULL, NULL);

-- Verify inserts
SELECT table_name, COUNT(*) as column_count
FROM table_metadata
WHERE table_name IN (
  'cash_control',
  'cash_amount_stock_flow',
  'bank_amount',
  'vault_amount_line',
  'cash_locations',
  'currency_denominations',
  'cashier_amount_lines'
)
GROUP BY table_name
ORDER BY table_name;
