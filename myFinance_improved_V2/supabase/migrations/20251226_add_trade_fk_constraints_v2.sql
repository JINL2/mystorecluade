-- Migration: Add Foreign Key Constraints to Trade Tables (v2 - Idempotent)
-- Date: 2025-12-26
-- Description: Add FK constraints for data integrity and relationship tracking
-- Note: This version drops existing constraints first to avoid conflicts
--
-- Reference Tables:
--   - companies (company_id)
--   - stores (store_id)
--   - counterparties (counterparty_id)
--   - currency_types (currency_id)
--   - inventory_products (product_id)

-- ============================================================
-- DROP EXISTING CONSTRAINTS FIRST (Idempotent)
-- ============================================================

-- PI constraints
ALTER TABLE trade_proforma_invoices DROP CONSTRAINT IF EXISTS fk_pi_company;
ALTER TABLE trade_proforma_invoices DROP CONSTRAINT IF EXISTS fk_pi_store;
ALTER TABLE trade_proforma_invoices DROP CONSTRAINT IF EXISTS fk_pi_counterparty;
ALTER TABLE trade_proforma_invoices DROP CONSTRAINT IF EXISTS fk_pi_currency;

-- PI Items constraints
ALTER TABLE trade_pi_items DROP CONSTRAINT IF EXISTS fk_pi_item_pi;
ALTER TABLE trade_pi_items DROP CONSTRAINT IF EXISTS fk_pi_item_product;

-- PO constraints
ALTER TABLE trade_purchase_orders DROP CONSTRAINT IF EXISTS fk_po_company;
ALTER TABLE trade_purchase_orders DROP CONSTRAINT IF EXISTS fk_po_store;
ALTER TABLE trade_purchase_orders DROP CONSTRAINT IF EXISTS fk_po_pi;
ALTER TABLE trade_purchase_orders DROP CONSTRAINT IF EXISTS fk_po_buyer;
ALTER TABLE trade_purchase_orders DROP CONSTRAINT IF EXISTS fk_po_currency;

-- PO Items constraints
ALTER TABLE trade_po_items DROP CONSTRAINT IF EXISTS fk_po_item_po;
ALTER TABLE trade_po_items DROP CONSTRAINT IF EXISTS fk_po_item_pi_item;
ALTER TABLE trade_po_items DROP CONSTRAINT IF EXISTS fk_po_item_product;

-- LC constraints
ALTER TABLE trade_letters_of_credit DROP CONSTRAINT IF EXISTS fk_lc_company;
ALTER TABLE trade_letters_of_credit DROP CONSTRAINT IF EXISTS fk_lc_store;
ALTER TABLE trade_letters_of_credit DROP CONSTRAINT IF EXISTS fk_lc_pi;
ALTER TABLE trade_letters_of_credit DROP CONSTRAINT IF EXISTS fk_lc_po;
ALTER TABLE trade_letters_of_credit DROP CONSTRAINT IF EXISTS fk_lc_applicant;
ALTER TABLE trade_letters_of_credit DROP CONSTRAINT IF EXISTS fk_lc_issuing_bank;
ALTER TABLE trade_letters_of_credit DROP CONSTRAINT IF EXISTS fk_lc_advising_bank;
ALTER TABLE trade_letters_of_credit DROP CONSTRAINT IF EXISTS fk_lc_confirming_bank;
ALTER TABLE trade_letters_of_credit DROP CONSTRAINT IF EXISTS fk_lc_currency;

-- LC Amendment constraints
ALTER TABLE trade_lc_amendments DROP CONSTRAINT IF EXISTS fk_amendment_lc;
ALTER TABLE trade_lc_amendments DROP CONSTRAINT IF EXISTS fk_amendment_fee_currency;

-- CI constraints
ALTER TABLE trade_commercial_invoices DROP CONSTRAINT IF EXISTS fk_ci_company;
ALTER TABLE trade_commercial_invoices DROP CONSTRAINT IF EXISTS fk_ci_store;
ALTER TABLE trade_commercial_invoices DROP CONSTRAINT IF EXISTS fk_ci_lc;
ALTER TABLE trade_commercial_invoices DROP CONSTRAINT IF EXISTS fk_ci_shipment;
ALTER TABLE trade_commercial_invoices DROP CONSTRAINT IF EXISTS fk_ci_buyer;
ALTER TABLE trade_commercial_invoices DROP CONSTRAINT IF EXISTS fk_ci_currency;

-- CI Items constraints
ALTER TABLE trade_ci_items DROP CONSTRAINT IF EXISTS fk_ci_item_ci;
ALTER TABLE trade_ci_items DROP CONSTRAINT IF EXISTS fk_ci_item_shipment_item;
ALTER TABLE trade_ci_items DROP CONSTRAINT IF EXISTS fk_ci_item_product;

-- Shipment constraints
ALTER TABLE trade_shipments DROP CONSTRAINT IF EXISTS fk_shipment_company;
ALTER TABLE trade_shipments DROP CONSTRAINT IF EXISTS fk_shipment_store;
ALTER TABLE trade_shipments DROP CONSTRAINT IF EXISTS fk_shipment_lc;
ALTER TABLE trade_shipments DROP CONSTRAINT IF EXISTS fk_shipment_po;
ALTER TABLE trade_shipments DROP CONSTRAINT IF EXISTS fk_shipment_freight_currency;
ALTER TABLE trade_shipments DROP CONSTRAINT IF EXISTS fk_shipment_insurance_currency;

-- Shipment Items constraints
ALTER TABLE trade_shipment_items DROP CONSTRAINT IF EXISTS fk_shipment_item_shipment;
ALTER TABLE trade_shipment_items DROP CONSTRAINT IF EXISTS fk_shipment_item_po_item;
ALTER TABLE trade_shipment_items DROP CONSTRAINT IF EXISTS fk_shipment_item_product;

-- Payment constraints
ALTER TABLE trade_payments DROP CONSTRAINT IF EXISTS fk_payment_company;
ALTER TABLE trade_payments DROP CONSTRAINT IF EXISTS fk_payment_store;
ALTER TABLE trade_payments DROP CONSTRAINT IF EXISTS fk_payment_lc;
ALTER TABLE trade_payments DROP CONSTRAINT IF EXISTS fk_payment_ci;
ALTER TABLE trade_payments DROP CONSTRAINT IF EXISTS fk_payment_currency;
ALTER TABLE trade_payments DROP CONSTRAINT IF EXISTS fk_payment_base_currency;

-- Document constraints
ALTER TABLE trade_documents DROP CONSTRAINT IF EXISTS fk_document_company;
ALTER TABLE trade_documents DROP CONSTRAINT IF EXISTS fk_document_store;

-- Activity Log constraints
ALTER TABLE trade_activity_logs DROP CONSTRAINT IF EXISTS fk_activity_company;
ALTER TABLE trade_activity_logs DROP CONSTRAINT IF EXISTS fk_activity_store;

-- Status History constraints
ALTER TABLE trade_status_history DROP CONSTRAINT IF EXISTS fk_status_history_company;
ALTER TABLE trade_status_history DROP CONSTRAINT IF EXISTS fk_status_history_store;

-- Alert constraints
ALTER TABLE trade_alerts DROP CONSTRAINT IF EXISTS fk_alert_company;
ALTER TABLE trade_alerts DROP CONSTRAINT IF EXISTS fk_alert_store;

-- ============================================================
-- 1. PROFORMA INVOICE (trade_proforma_invoices)
-- ============================================================

-- Company (required)
ALTER TABLE trade_proforma_invoices
ADD CONSTRAINT fk_pi_company
FOREIGN KEY (company_id) REFERENCES companies(company_id)
ON DELETE RESTRICT;

-- Store (optional)
ALTER TABLE trade_proforma_invoices
ADD CONSTRAINT fk_pi_store
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE SET NULL;

-- Counterparty (optional - buyer)
ALTER TABLE trade_proforma_invoices
ADD CONSTRAINT fk_pi_counterparty
FOREIGN KEY (counterparty_id) REFERENCES counterparties(counterparty_id)
ON DELETE SET NULL;

-- Currency (optional)
ALTER TABLE trade_proforma_invoices
ADD CONSTRAINT fk_pi_currency
FOREIGN KEY (currency_id) REFERENCES currency_types(currency_id)
ON DELETE SET NULL;

-- ============================================================
-- 2. PI ITEMS (trade_pi_items)
-- ============================================================

-- Parent PI (required, cascade delete)
ALTER TABLE trade_pi_items
ADD CONSTRAINT fk_pi_item_pi
FOREIGN KEY (pi_id) REFERENCES trade_proforma_invoices(pi_id)
ON DELETE CASCADE;

-- Product (optional - can be manual entry)
ALTER TABLE trade_pi_items
ADD CONSTRAINT fk_pi_item_product
FOREIGN KEY (product_id) REFERENCES inventory_products(product_id)
ON DELETE SET NULL;

-- ============================================================
-- 3. PURCHASE ORDER (trade_purchase_orders)
-- ============================================================

-- Company (required)
ALTER TABLE trade_purchase_orders
ADD CONSTRAINT fk_po_company
FOREIGN KEY (company_id) REFERENCES companies(company_id)
ON DELETE RESTRICT;

-- Store (optional)
ALTER TABLE trade_purchase_orders
ADD CONSTRAINT fk_po_store
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE SET NULL;

-- Source PI (optional)
ALTER TABLE trade_purchase_orders
ADD CONSTRAINT fk_po_pi
FOREIGN KEY (pi_id) REFERENCES trade_proforma_invoices(pi_id)
ON DELETE SET NULL;

-- Buyer/Counterparty (optional)
ALTER TABLE trade_purchase_orders
ADD CONSTRAINT fk_po_buyer
FOREIGN KEY (buyer_id) REFERENCES counterparties(counterparty_id)
ON DELETE SET NULL;

-- Currency (optional)
ALTER TABLE trade_purchase_orders
ADD CONSTRAINT fk_po_currency
FOREIGN KEY (currency_id) REFERENCES currency_types(currency_id)
ON DELETE SET NULL;

-- ============================================================
-- 4. PO ITEMS (trade_po_items)
-- ============================================================

-- Parent PO (required, cascade delete)
ALTER TABLE trade_po_items
ADD CONSTRAINT fk_po_item_po
FOREIGN KEY (po_id) REFERENCES trade_purchase_orders(po_id)
ON DELETE CASCADE;

-- Source PI Item (optional)
ALTER TABLE trade_po_items
ADD CONSTRAINT fk_po_item_pi_item
FOREIGN KEY (pi_item_id) REFERENCES trade_pi_items(item_id)
ON DELETE SET NULL;

-- Product (optional)
ALTER TABLE trade_po_items
ADD CONSTRAINT fk_po_item_product
FOREIGN KEY (product_id) REFERENCES inventory_products(product_id)
ON DELETE SET NULL;

-- ============================================================
-- 5. LETTER OF CREDIT (trade_letters_of_credit)
-- ============================================================

-- Company (required)
ALTER TABLE trade_letters_of_credit
ADD CONSTRAINT fk_lc_company
FOREIGN KEY (company_id) REFERENCES companies(company_id)
ON DELETE RESTRICT;

-- Store (optional)
ALTER TABLE trade_letters_of_credit
ADD CONSTRAINT fk_lc_store
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE SET NULL;

-- Source PI (optional)
ALTER TABLE trade_letters_of_credit
ADD CONSTRAINT fk_lc_pi
FOREIGN KEY (pi_id) REFERENCES trade_proforma_invoices(pi_id)
ON DELETE SET NULL;

-- Source PO (optional)
ALTER TABLE trade_letters_of_credit
ADD CONSTRAINT fk_lc_po
FOREIGN KEY (po_id) REFERENCES trade_purchase_orders(po_id)
ON DELETE SET NULL;

-- Applicant (counterparty - optional)
ALTER TABLE trade_letters_of_credit
ADD CONSTRAINT fk_lc_applicant
FOREIGN KEY (applicant_id) REFERENCES counterparties(counterparty_id)
ON DELETE SET NULL;

-- Issuing Bank (counterparty - optional)
ALTER TABLE trade_letters_of_credit
ADD CONSTRAINT fk_lc_issuing_bank
FOREIGN KEY (issuing_bank_id) REFERENCES counterparties(counterparty_id)
ON DELETE SET NULL;

-- Advising Bank (counterparty - optional)
ALTER TABLE trade_letters_of_credit
ADD CONSTRAINT fk_lc_advising_bank
FOREIGN KEY (advising_bank_id) REFERENCES counterparties(counterparty_id)
ON DELETE SET NULL;

-- Confirming Bank (counterparty - optional)
ALTER TABLE trade_letters_of_credit
ADD CONSTRAINT fk_lc_confirming_bank
FOREIGN KEY (confirming_bank_id) REFERENCES counterparties(counterparty_id)
ON DELETE SET NULL;

-- Currency (optional)
ALTER TABLE trade_letters_of_credit
ADD CONSTRAINT fk_lc_currency
FOREIGN KEY (currency_id) REFERENCES currency_types(currency_id)
ON DELETE SET NULL;

-- ============================================================
-- 6. COMMERCIAL INVOICE (trade_commercial_invoices)
-- ============================================================

-- Company (required)
ALTER TABLE trade_commercial_invoices
ADD CONSTRAINT fk_ci_company
FOREIGN KEY (company_id) REFERENCES companies(company_id)
ON DELETE RESTRICT;

-- Store (optional)
ALTER TABLE trade_commercial_invoices
ADD CONSTRAINT fk_ci_store
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE SET NULL;

-- Source LC (optional)
ALTER TABLE trade_commercial_invoices
ADD CONSTRAINT fk_ci_lc
FOREIGN KEY (lc_id) REFERENCES trade_letters_of_credit(lc_id)
ON DELETE SET NULL;

-- Source Shipment (optional)
ALTER TABLE trade_commercial_invoices
ADD CONSTRAINT fk_ci_shipment
FOREIGN KEY (shipment_id) REFERENCES trade_shipments(shipment_id)
ON DELETE SET NULL;

-- Buyer (counterparty - optional)
ALTER TABLE trade_commercial_invoices
ADD CONSTRAINT fk_ci_buyer
FOREIGN KEY (buyer_id) REFERENCES counterparties(counterparty_id)
ON DELETE SET NULL;

-- Currency (optional)
ALTER TABLE trade_commercial_invoices
ADD CONSTRAINT fk_ci_currency
FOREIGN KEY (currency_id) REFERENCES currency_types(currency_id)
ON DELETE SET NULL;

-- ============================================================
-- 7. CI ITEMS (trade_ci_items)
-- ============================================================

-- Parent CI (required, cascade delete)
ALTER TABLE trade_ci_items
ADD CONSTRAINT fk_ci_item_ci
FOREIGN KEY (ci_id) REFERENCES trade_commercial_invoices(ci_id)
ON DELETE CASCADE;

-- Source Shipment Item (optional)
ALTER TABLE trade_ci_items
ADD CONSTRAINT fk_ci_item_shipment_item
FOREIGN KEY (shipment_item_id) REFERENCES trade_shipment_items(item_id)
ON DELETE SET NULL;

-- Product (optional)
ALTER TABLE trade_ci_items
ADD CONSTRAINT fk_ci_item_product
FOREIGN KEY (product_id) REFERENCES inventory_products(product_id)
ON DELETE SET NULL;

-- ============================================================
-- 8. SHIPMENT (trade_shipments)
-- ============================================================

-- Company (required)
ALTER TABLE trade_shipments
ADD CONSTRAINT fk_shipment_company
FOREIGN KEY (company_id) REFERENCES companies(company_id)
ON DELETE RESTRICT;

-- Store (optional)
ALTER TABLE trade_shipments
ADD CONSTRAINT fk_shipment_store
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE SET NULL;

-- Source LC (optional)
ALTER TABLE trade_shipments
ADD CONSTRAINT fk_shipment_lc
FOREIGN KEY (lc_id) REFERENCES trade_letters_of_credit(lc_id)
ON DELETE SET NULL;

-- Source PO (optional)
ALTER TABLE trade_shipments
ADD CONSTRAINT fk_shipment_po
FOREIGN KEY (po_id) REFERENCES trade_purchase_orders(po_id)
ON DELETE SET NULL;

-- Freight Currency (optional)
ALTER TABLE trade_shipments
ADD CONSTRAINT fk_shipment_freight_currency
FOREIGN KEY (freight_currency_id) REFERENCES currency_types(currency_id)
ON DELETE SET NULL;

-- Insurance Currency (optional)
ALTER TABLE trade_shipments
ADD CONSTRAINT fk_shipment_insurance_currency
FOREIGN KEY (insurance_currency_id) REFERENCES currency_types(currency_id)
ON DELETE SET NULL;

-- ============================================================
-- 9. SHIPMENT ITEMS (trade_shipment_items)
-- ============================================================

-- Parent Shipment (required, cascade delete)
ALTER TABLE trade_shipment_items
ADD CONSTRAINT fk_shipment_item_shipment
FOREIGN KEY (shipment_id) REFERENCES trade_shipments(shipment_id)
ON DELETE CASCADE;

-- Source PO Item (optional)
ALTER TABLE trade_shipment_items
ADD CONSTRAINT fk_shipment_item_po_item
FOREIGN KEY (po_item_id) REFERENCES trade_po_items(item_id)
ON DELETE SET NULL;

-- Product (optional)
ALTER TABLE trade_shipment_items
ADD CONSTRAINT fk_shipment_item_product
FOREIGN KEY (product_id) REFERENCES inventory_products(product_id)
ON DELETE SET NULL;

-- ============================================================
-- 10. LC AMENDMENTS (trade_lc_amendments)
-- ============================================================

-- Parent LC (required, cascade delete)
ALTER TABLE trade_lc_amendments
ADD CONSTRAINT fk_amendment_lc
FOREIGN KEY (lc_id) REFERENCES trade_letters_of_credit(lc_id)
ON DELETE CASCADE;

-- Amendment Fee Currency (optional)
ALTER TABLE trade_lc_amendments
ADD CONSTRAINT fk_amendment_fee_currency
FOREIGN KEY (amendment_fee_currency_id) REFERENCES currency_types(currency_id)
ON DELETE SET NULL;

-- ============================================================
-- 11. PAYMENTS (trade_payments)
-- ============================================================

-- Company (required)
ALTER TABLE trade_payments
ADD CONSTRAINT fk_payment_company
FOREIGN KEY (company_id) REFERENCES companies(company_id)
ON DELETE RESTRICT;

-- Store (optional)
ALTER TABLE trade_payments
ADD CONSTRAINT fk_payment_store
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE SET NULL;

-- Source LC (optional)
ALTER TABLE trade_payments
ADD CONSTRAINT fk_payment_lc
FOREIGN KEY (lc_id) REFERENCES trade_letters_of_credit(lc_id)
ON DELETE SET NULL;

-- Source CI (optional)
ALTER TABLE trade_payments
ADD CONSTRAINT fk_payment_ci
FOREIGN KEY (ci_id) REFERENCES trade_commercial_invoices(ci_id)
ON DELETE SET NULL;

-- Currency (optional)
ALTER TABLE trade_payments
ADD CONSTRAINT fk_payment_currency
FOREIGN KEY (currency_id) REFERENCES currency_types(currency_id)
ON DELETE SET NULL;

-- Base Currency (optional)
ALTER TABLE trade_payments
ADD CONSTRAINT fk_payment_base_currency
FOREIGN KEY (base_currency_id) REFERENCES currency_types(currency_id)
ON DELETE SET NULL;

-- ============================================================
-- 12. DOCUMENTS (trade_documents)
-- ============================================================

-- Company (required)
ALTER TABLE trade_documents
ADD CONSTRAINT fk_document_company
FOREIGN KEY (company_id) REFERENCES companies(company_id)
ON DELETE RESTRICT;

-- Store (optional)
ALTER TABLE trade_documents
ADD CONSTRAINT fk_document_store
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE SET NULL;

-- ============================================================
-- 13. ACTIVITY LOGS (trade_activity_logs)
-- ============================================================

-- Company (required)
ALTER TABLE trade_activity_logs
ADD CONSTRAINT fk_activity_company
FOREIGN KEY (company_id) REFERENCES companies(company_id)
ON DELETE CASCADE;

-- Store (optional)
ALTER TABLE trade_activity_logs
ADD CONSTRAINT fk_activity_store
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE SET NULL;

-- ============================================================
-- 14. STATUS HISTORY (trade_status_history)
-- ============================================================

-- Company (required)
ALTER TABLE trade_status_history
ADD CONSTRAINT fk_status_history_company
FOREIGN KEY (company_id) REFERENCES companies(company_id)
ON DELETE CASCADE;

-- Store (optional)
ALTER TABLE trade_status_history
ADD CONSTRAINT fk_status_history_store
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE SET NULL;

-- ============================================================
-- 15. ALERTS (trade_alerts)
-- ============================================================

-- Company (required)
ALTER TABLE trade_alerts
ADD CONSTRAINT fk_alert_company
FOREIGN KEY (company_id) REFERENCES companies(company_id)
ON DELETE CASCADE;

-- Store (optional)
ALTER TABLE trade_alerts
ADD CONSTRAINT fk_alert_store
FOREIGN KEY (store_id) REFERENCES stores(store_id)
ON DELETE SET NULL;

-- ============================================================
-- CREATE INDEXES FOR FK COLUMNS (Performance)
-- ============================================================

-- PI indexes
CREATE INDEX IF NOT EXISTS idx_pi_company ON trade_proforma_invoices(company_id);
CREATE INDEX IF NOT EXISTS idx_pi_store ON trade_proforma_invoices(store_id);
CREATE INDEX IF NOT EXISTS idx_pi_counterparty ON trade_proforma_invoices(counterparty_id);
CREATE INDEX IF NOT EXISTS idx_pi_currency ON trade_proforma_invoices(currency_id);

-- PI Items indexes
CREATE INDEX IF NOT EXISTS idx_pi_item_pi ON trade_pi_items(pi_id);
CREATE INDEX IF NOT EXISTS idx_pi_item_product ON trade_pi_items(product_id);

-- PO indexes
CREATE INDEX IF NOT EXISTS idx_po_company ON trade_purchase_orders(company_id);
CREATE INDEX IF NOT EXISTS idx_po_store ON trade_purchase_orders(store_id);
CREATE INDEX IF NOT EXISTS idx_po_pi ON trade_purchase_orders(pi_id);
CREATE INDEX IF NOT EXISTS idx_po_buyer ON trade_purchase_orders(buyer_id);
CREATE INDEX IF NOT EXISTS idx_po_currency ON trade_purchase_orders(currency_id);

-- PO Items indexes
CREATE INDEX IF NOT EXISTS idx_po_item_po ON trade_po_items(po_id);
CREATE INDEX IF NOT EXISTS idx_po_item_pi_item ON trade_po_items(pi_item_id);
CREATE INDEX IF NOT EXISTS idx_po_item_product ON trade_po_items(product_id);

-- LC indexes
CREATE INDEX IF NOT EXISTS idx_lc_company ON trade_letters_of_credit(company_id);
CREATE INDEX IF NOT EXISTS idx_lc_store ON trade_letters_of_credit(store_id);
CREATE INDEX IF NOT EXISTS idx_lc_pi ON trade_letters_of_credit(pi_id);
CREATE INDEX IF NOT EXISTS idx_lc_po ON trade_letters_of_credit(po_id);
CREATE INDEX IF NOT EXISTS idx_lc_applicant ON trade_letters_of_credit(applicant_id);
CREATE INDEX IF NOT EXISTS idx_lc_issuing_bank ON trade_letters_of_credit(issuing_bank_id);
CREATE INDEX IF NOT EXISTS idx_lc_advising_bank ON trade_letters_of_credit(advising_bank_id);
CREATE INDEX IF NOT EXISTS idx_lc_currency ON trade_letters_of_credit(currency_id);

-- LC Amendment indexes
CREATE INDEX IF NOT EXISTS idx_amendment_lc ON trade_lc_amendments(lc_id);

-- CI indexes
CREATE INDEX IF NOT EXISTS idx_ci_company ON trade_commercial_invoices(company_id);
CREATE INDEX IF NOT EXISTS idx_ci_store ON trade_commercial_invoices(store_id);
CREATE INDEX IF NOT EXISTS idx_ci_lc ON trade_commercial_invoices(lc_id);
CREATE INDEX IF NOT EXISTS idx_ci_shipment ON trade_commercial_invoices(shipment_id);
CREATE INDEX IF NOT EXISTS idx_ci_buyer ON trade_commercial_invoices(buyer_id);
CREATE INDEX IF NOT EXISTS idx_ci_currency ON trade_commercial_invoices(currency_id);

-- CI Items indexes
CREATE INDEX IF NOT EXISTS idx_ci_item_ci ON trade_ci_items(ci_id);
CREATE INDEX IF NOT EXISTS idx_ci_item_shipment_item ON trade_ci_items(shipment_item_id);
CREATE INDEX IF NOT EXISTS idx_ci_item_product ON trade_ci_items(product_id);

-- Shipment indexes
CREATE INDEX IF NOT EXISTS idx_shipment_company ON trade_shipments(company_id);
CREATE INDEX IF NOT EXISTS idx_shipment_store ON trade_shipments(store_id);
CREATE INDEX IF NOT EXISTS idx_shipment_lc ON trade_shipments(lc_id);
CREATE INDEX IF NOT EXISTS idx_shipment_po ON trade_shipments(po_id);

-- Shipment Items indexes
CREATE INDEX IF NOT EXISTS idx_shipment_item_shipment ON trade_shipment_items(shipment_id);
CREATE INDEX IF NOT EXISTS idx_shipment_item_po_item ON trade_shipment_items(po_item_id);
CREATE INDEX IF NOT EXISTS idx_shipment_item_product ON trade_shipment_items(product_id);

-- Payment indexes
CREATE INDEX IF NOT EXISTS idx_payment_company ON trade_payments(company_id);
CREATE INDEX IF NOT EXISTS idx_payment_store ON trade_payments(store_id);
CREATE INDEX IF NOT EXISTS idx_payment_lc ON trade_payments(lc_id);
CREATE INDEX IF NOT EXISTS idx_payment_ci ON trade_payments(ci_id);
CREATE INDEX IF NOT EXISTS idx_payment_currency ON trade_payments(currency_id);

-- Document indexes
CREATE INDEX IF NOT EXISTS idx_document_company ON trade_documents(company_id);
CREATE INDEX IF NOT EXISTS idx_document_store ON trade_documents(store_id);
CREATE INDEX IF NOT EXISTS idx_document_reference ON trade_documents(reference_type, reference_id);

-- Activity Log indexes
CREATE INDEX IF NOT EXISTS idx_activity_company ON trade_activity_logs(company_id);
CREATE INDEX IF NOT EXISTS idx_activity_entity ON trade_activity_logs(entity_type, entity_id);

-- Status History indexes
CREATE INDEX IF NOT EXISTS idx_status_history_company ON trade_status_history(company_id);
CREATE INDEX IF NOT EXISTS idx_status_history_entity ON trade_status_history(entity_type, entity_id);

-- Alert indexes
CREATE INDEX IF NOT EXISTS idx_alert_company ON trade_alerts(company_id);
CREATE INDEX IF NOT EXISTS idx_alert_entity ON trade_alerts(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_alert_priority ON trade_alerts(priority, is_resolved);

-- ============================================================
-- Migration Complete (v2 - Idempotent)
-- ============================================================
-- Total FK constraints: 45
-- Can be run multiple times without errors
-- ============================================================
