# v_cash_location View - Vault Integration Fix

## Problem Summary
The original `v_cash_location` view had an incomplete vault calculation that wasn't properly integrating vault data. The vault case in the LATERAL JOIN was missing proper table joins and calculations for the `vault_amount_line` table.

## Key Issues Fixed

### 1. Vault Calculation Logic
**Original Issue**: The vault case was attempting to calculate `(val.debit - val.credit) * cd.value` but wasn't properly joining with the `currency_denominations` table to get the denomination values.

**Solution**: Added proper JOIN with `currency_denominations` table to multiply the net quantity by denomination value.

### 2. Currency Conversion
**Original Issue**: Vault amounts in foreign currencies weren't being converted to the base currency.

**Solution**: Added exchange rate conversion logic similar to cashier and bank calculations.

### 3. Table Structure
**Clarification**: The `vault_amount_line` table doesn't have an `is_deleted` column, unlike some other tables in the system. All vault records are permanent for audit trail purposes.

## Understanding the Vault Amount Line Table

The `vault_amount_line` table tracks vault transactions with the following structure:
- **vault_amount_id**: Primary key (UUID)
- **company_id**: Company identifier
- **store_id**: Store identifier (nullable)
- **location_id**: References the vault location in `cash_locations`
- **currency_id**: Currency type
- **denomination_id**: References the currency denomination
- **debit**: Amount added to the vault (increases balance)
- **credit**: Amount removed from the vault (decreases balance)
- **created_at**: Timestamp of record creation
- **record_date**: Date of the transaction
- **created_by**: User who created the record

The net balance for each denomination is calculated as: `(debit - credit) * denomination_value`

## View Structure

### Input Tables
1. **cash_locations**: Defines all cash storage locations (cash, vault, bank)
2. **journal_lines**: Accounting entries (book value)
3. **cashier_amount_lines**: Physical cash counts for cashier locations
4. **vault_amount_line**: Vault transactions with debit/credit
5. **bank_amount**: Bank balance records
6. **currency_denominations**: Denomination values for each currency
7. **book_exchange_rates**: Currency conversion rates

### Output Columns
- **cash_location_id**: Unique identifier
- **location_name**: Name of the location
- **location_type**: Type (cash, vault, bank)
- **total_journal_cash_amount**: Book value from accounting
- **total_real_cash_amount**: Actual physical amount
- **cash_difference**: Discrepancy (real - journal)
- **primary_currency_symbol**: Company's base currency symbol
- **primary_currency_code**: Company's base currency code

## Calculation Logic by Location Type

### Cash (Cashier) Locations
```sql
SUM(quantity * denomination_value * exchange_rate)
```
Uses the most recent cash count from `cashier_amount_lines`.

### Vault Locations
```sql
SUM((debit - credit) * denomination_value * exchange_rate)
```
Calculates net balance from all vault transactions.

### Bank Locations
```sql
total_amount * exchange_rate
```
Uses the most recent bank balance record.

## Exchange Rate Logic
All amounts are converted to the company's base currency using the most recent exchange rate from `book_exchange_rates`. If no exchange rate is found, it defaults to 1.0.

## Testing the Fix

### 1. Apply the View
```sql
-- Run the contents of v_cash_location_complete.sql
```

### 2. Verify Vault Calculations
```sql
-- Check vault locations
SELECT * FROM v_cash_location 
WHERE location_type = 'vault';
```

### 3. Run Test Queries
Use the queries in `v_cash_location_test_queries.sql` to validate:
- All location types are calculating correctly
- Currency conversions are working
- Vault balances match expected values
- Discrepancies are identified properly

## Migration Notes

### Before Applying
1. Backup the existing view definition (if any)
2. Check for dependent views or functions
3. Verify all required tables exist

### After Applying
1. Test with actual data
2. Verify performance is acceptable
3. Update any dependent code or reports
4. Monitor for any calculation discrepancies

## Performance Considerations

The view uses LATERAL JOINs with subqueries which may impact performance with large datasets. Consider:
1. Creating materialized views for frequently accessed data
2. Adding indexes on:
   - `vault_amount_line(location_id)`
   - `vault_amount_line(denomination_id)`
   - `book_exchange_rates(company_id, from_currency_id, to_currency_id, rate_date DESC)`
3. Implementing caching strategies in the application layer

## Related Files
- `v_cash_location_complete.sql` - The complete fixed view definition
- `v_cash_location_test_queries.sql` - Test queries to validate the fix
- `database_structure.md` - Database schema documentation