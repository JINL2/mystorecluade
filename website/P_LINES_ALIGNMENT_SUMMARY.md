# p_lines JSON Structure Alignment Summary

## Comparison Complete: Website vs Flutter App

### ✅ Aligned Structure

The website's TransactionLine.toJson() method now matches the Flutter app exactly:

#### Basic Fields (✅ Aligned)
```javascript
{
    account_id: this.accountId,
    description: this.description,
    debit: this.isDebit ? this.amount.toString() : '0',
    credit: !this.isDebit ? this.amount.toString() : '0'
}
```
- All amounts are strings
- Debit/credit logic matches app

#### Counterparty (✅ Aligned)
```javascript
// Only adds counterparty_id if present
if (this.counterpartyId && this.counterpartyId.length > 0) {
    json.counterparty_id = this.counterpartyId;
}
```
- NO counterparty_store_id at top level
- NO linked_company_id at top level
- Only counterparty_id when present

#### Cash Object (✅ Aligned)
```javascript
if (this.categoryTag === 'cash' && this.cashLocationId) {
    json.cash = {
        cash_location_id: this.cashLocationId
    };
}
```
- Only includes cash_location_id
- NO currency_id in cash object

#### Debt Object (✅ Aligned)
```javascript
if ((this.categoryTag === 'payable' || this.categoryTag === 'receivable') && 
    this.counterpartyId && (this.debtCategory || this.interestRate)) {
    json.debt = {
        direction: this.categoryTag,
        category: this.debtCategory || 'other',
        counterparty_id: this.counterpartyId,
        original_amount: this.amount.toString(),
        interest_rate: (this.interestRate || 0).toString(),
        interest_account_id: '',
        interest_due_day: 0,
        issue_date: issueDate.toISOString().split('T')[0],
        due_date: dueDate.toISOString().split('T')[0],
        description: this.debtDescription || '',
        linkedCounterparty_store_id: this.counterpartyStoreId || '',
        linkedCounterparty_companyId: this.linkedCompanyId || ''
    };
}
```
- All fields match Flutter app
- linkedCounterparty fields included

#### Fixed Asset Object (✅ Aligned)
```javascript
if (this.categoryTag === 'fixedasset' && this.fixedAssetName) {
    json.fix_asset = {  // Note: 'fix_asset' not 'fixed_asset'
        asset_name: this.fixedAssetName,
        salvage_value: (this.salvageValue || 0).toString(),
        acquire_date: acquisitionDate.toISOString().split('T')[0],
        useful_life: (this.usefulLife || 5).toString()
    };
}
```
- Uses 'fix_asset' key (matching app)
- All values as strings

#### Account Mapping (✅ Aligned)
```javascript
if (this.accountMapping) {
    json.account_mapping = this.accountMapping;
}
```
- Added when available

### RPC Parameters (✅ Aligned)

```javascript
const rpcParams = {
    p_base_amount: journalEntry.totalDebits,
    p_company_id: finalCompanyId,
    p_created_by: user.id,
    p_description: journalEntry.overallDescription,
    p_entry_date: entryDate,  // Format: YYYY-MM-DD HH:MM:SS.SSS
    p_lines: pLines,  // Array of JSON objects from toJson()
    p_counterparty_id: mainCounterpartyId,  // Can be null
    p_if_cash_location_id: counterpartyStoreCashLocationId,  // Can be null
    p_store_id: finalStoreId  // Can be null
};
```

### Key Differences Fixed

1. **Removed Extra Fields**: No longer adding extra fields that app doesn't include
2. **Simplified Logic**: Matching app's simpler approach  
3. **Consistent Data Types**: All amounts as strings
4. **Proper Conditionals**: Only add objects when conditions match app

### Testing Checklist

- [ ] Test with cash accounts
- [ ] Test with payable/receivable + counterparty
- [ ] Test with fixed assets
- [ ] Test with internal counterparty + store selection
- [ ] Test with account mappings
- [ ] Verify RPC call succeeds
- [ ] Compare database entries between app and website submissions

## Status: COMPLETE ✅

The p_lines JSON structure now exactly matches the Flutter app implementation.