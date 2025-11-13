/// Unit tests for TemplateLineFactory
///
/// Tests the Domain layer factory for creating template transaction lines
/// Verifies correct data structure generation based on account types
library;

import 'template_line_factory.dart';

void main() {
  testCashAccount();
  testPayableAccount();
  testReceivableAccount();
  testInternalTransaction();
  testMultipleLines();
  testValidation();
}

void testCashAccount() {
  final line = TemplateLineFactory.createLine(
    accountId: 'cash_001',
    accountCategoryTag: 'cash',
    isDebit: true,
    description: 'Cash withdrawal',
    cashLocationId: 'location_001',
  );

  assert(line['account_id'] == 'cash_001', 'Account ID should match');
  assert(line['cash'] != null, 'Cash object should exist');
  assert(line['cash']['cash_location_id'] == 'location_001', 'Cash location should match');
  assert(line['debt'] == null, 'Debt object should not exist for cash account');
}

void testPayableAccount() {
  final line = TemplateLineFactory.createLine(
    accountId: 'payable_001',
    accountCategoryTag: 'payable',
    isDebit: false,
    description: 'Purchase on credit',
    counterpartyId: 'supplier_001',
  );

  assert(line['account_id'] == 'payable_001', 'Account ID should match');
  assert(line['debt'] != null, 'Debt object should exist');
  assert(line['debt']['counterparty_id'] == 'supplier_001', 'Counterparty should match');
  assert(line['debt']['direction'] == 'payable', 'Direction should be payable');
  assert(line['debt']['category'] == 'purchase', 'Category should be purchase');
  assert(line['cash'] == null, 'Cash object should not exist for payable account');
}

void testReceivableAccount() {
  final line = TemplateLineFactory.createLine(
    accountId: 'receivable_001',
    accountCategoryTag: 'receivable',
    isDebit: true,
    description: 'Sale on credit',
    counterpartyId: 'customer_001',
  );

  assert(line['account_id'] == 'receivable_001', 'Account ID should match');
  assert(line['debt'] != null, 'Debt object should exist');
  assert(line['debt']['counterparty_id'] == 'customer_001', 'Counterparty should match');
  assert(line['debt']['direction'] == 'receivable', 'Direction should be receivable');
  assert(line['debt']['category'] == 'sales', 'Category should be sales');
  assert(line['cash'] == null, 'Cash object should not exist for receivable account');
}

void testInternalTransaction() {
  final line = TemplateLineFactory.createLine(
    accountId: 'payable_002',
    accountCategoryTag: 'payable',
    isDebit: false,
    description: 'Internal purchase',
    counterpartyId: 'internal_001',
    isInternalCounterparty: true,
    linkedCompanyId: 'company_002',
    linkedStoreId: 'store_003',
    linkedCashLocationId: 'cash_004',
  );

  assert(line['debt'] != null, 'Debt object should exist');
  assert(line['debt']['linkedCounterparty_companyId'] == 'company_002', 'Linked company should match');
  assert(line['debt']['linkedCounterparty_store_id'] == 'store_003', 'Linked store should match');
  assert(line['debt']['linkedCounterparty_cash_location_id'] == 'cash_004', 'Linked cash location should match');
}

void testMultipleLines() {
  final lines = TemplateLineFactory.createLines(
    templateName: 'Test Template',
    debitAccountId: 'cash_001',
    debitCategoryTag: 'cash',
    debitCashLocationId: 'location_001',
    creditAccountId: 'payable_001',
    creditCategoryTag: 'payable',
    creditCounterpartyId: 'supplier_001',
    creditIsInternal: false,
  );

  assert(lines.length == 2, 'Should create 2 lines');
  assert(lines[0]['account_id'] == 'cash_001', 'First line should be debit');
  assert(lines[0]['cash'] != null, 'Debit line should have cash object');
  assert(lines[1]['account_id'] == 'payable_001', 'Second line should be credit');
  assert(lines[1]['debt'] != null, 'Credit line should have debt object');
  assert(lines[1]['debt']['direction'] == 'payable', 'Credit line should have payable direction');
}

void testValidation() {

  // Test cash account validation
  final cashErrors = TemplateLineFactory.validateLineRequirements(
    accountCategoryTag: 'cash',
    accountName: 'Cash Account',
    cashLocationId: null, // Missing!
  );
  assert(cashErrors.isNotEmpty, 'Should have validation error for missing cash location');
  assert(cashErrors[0].contains('cash location'), 'Error should mention cash location');

  // Test payable account validation
  final payableErrors = TemplateLineFactory.validateLineRequirements(
    accountCategoryTag: 'payable',
    accountName: 'Accounts Payable',
    counterpartyId: null, // Missing!
  );
  assert(payableErrors.isNotEmpty, 'Should have validation error for missing counterparty');
  assert(payableErrors[0].contains('counterparty'), 'Error should mention counterparty');

  // Test internal counterparty validation
  final internalErrors = TemplateLineFactory.validateLineRequirements(
    accountCategoryTag: 'payable',
    accountName: 'Accounts Payable',
    counterpartyId: 'cp_001',
    isInternal: true,
    linkedStoreId: null, // Missing!
  );
  assert(internalErrors.isNotEmpty, 'Should have validation error for missing store');
  assert(internalErrors[0].contains('store'), 'Error should mention store');

  // Test valid data
  final noErrors = TemplateLineFactory.validateLineRequirements(
    accountCategoryTag: 'cash',
    accountName: 'Cash Account',
    cashLocationId: 'location_001',
  );
  assert(noErrors.isEmpty, 'Should have no validation errors for valid data');
}
