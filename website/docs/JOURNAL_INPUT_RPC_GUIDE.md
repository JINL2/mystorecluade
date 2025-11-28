# Journal Input RPC Parameter Guide

> **Purpose**: Comprehensive guide for understanding how to construct RPC parameters when calling `insert_journal_with_everything` function.
>
> **Target Audience**: AI assistants, developers working on journal entry features
>
> **Last Updated**: 2025-11-12

---

## Table of Contents

1. [Overview](#overview)
2. [RPC Function Signature](#rpc-function-signature)
3. [Parameter Construction Rules](#parameter-construction-rules)
4. [Cash Location Parameters](#cash-location-parameters)
5. [Counterparty Parameters](#counterparty-parameters)
6. [Complete Case Studies](#complete-case-studies)
7. [Validation Rules](#validation-rules)
8. [Common Mistakes](#common-mistakes)
9. [Data Flow Diagram](#data-flow-diagram)

---

## Overview

The `insert_journal_with_everything_utc` RPC function handles:
- ✅ Basic journal entry creation
- ✅ Cash location tracking (for cash-based accounts)
- ✅ Counterparty relationships (for payable/receivable accounts)
- ✅ Internal transactions between linked companies
- ✅ Automatic mirror journal creation for internal counterparties

**Critical Concept**: There are TWO distinct cash location IDs:
1. **My Company's Cash Location** → Goes in `p_lines[].cash.cash_location_id`
2. **Counterparty's Cash Location** → Goes in `p_if_cash_location_id` (for mirror journal creation)

---

## RPC Function Signature

```sql
insert_journal_with_everything_utc(
  p_base_amount NUMERIC,              -- Total debit amount
  p_company_id UUID,                  -- Current company ID
  p_created_by UUID,                  -- User ID
  p_description TEXT,                 -- Journal description
  p_entry_date_utc TIMESTAMPTZ,       -- Entry date with timezone (UTC)
  p_lines JSONB[],                    -- Array of transaction lines
  p_store_id UUID,                    -- Store ID (nullable)
  p_counterparty_id UUID,             -- Main counterparty ID (nullable)
  p_if_cash_location_id UUID          -- Counterparty's cash location (for mirror journal)
)
```

### Parameter Details

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `p_base_amount` | NUMERIC | ✅ Yes | Sum of all debit amounts |
| `p_company_id` | UUID | ✅ Yes | Current company executing transaction |
| `p_created_by` | UUID | ✅ Yes | User creating the journal entry |
| `p_description` | TEXT | ✅ Yes | Human-readable description |
| `p_entry_date_utc` | TIMESTAMPTZ | ✅ Yes | Entry date in UTC with timezone |
| `p_lines` | JSONB[] | ✅ Yes | Transaction lines with cash/debt objects |
| `p_store_id` | UUID | ❌ No | Store ID (can be null for company-level) |
| `p_counterparty_id` | UUID | ❌ No | First counterparty found in lines |
| `p_if_cash_location_id` | UUID | ❌ No | Counterparty's cash location for mirror journal |

---

## Parameter Construction Rules

### Rule 1: `p_base_amount` Calculation

```typescript
// Sum all DEBIT amounts only
p_base_amount = transactionLines
  .filter(line => line.isDebit)
  .reduce((sum, line) => sum + line.amount, 0);
```

**Example**:
```typescript
// Transaction Lines:
// Debit: Cash Account - 100,000
// Debit: Expense Account - 50,000
// Credit: Revenue Account - 150,000

p_base_amount = 100,000 + 50,000 = 150,000
```

### Rule 2: `p_entry_date_utc` Format

```typescript
// Convert date string to UTC timestamp
const now = new Date();
const [year, month, day] = dateString.split('-').map(Number);
const dateWithTime = new Date(
  year,
  month - 1,
  day,
  now.getHours(),
  now.getMinutes(),
  now.getSeconds()
);

// Use DateTimeUtils.toRpcFormat() for consistent timezone handling
p_entry_date_utc = DateTimeUtils.toRpcFormat(dateWithTime);
```

### Rule 3: `p_counterparty_id` Extraction

```typescript
// Extract FIRST counterparty found in ANY transaction line
p_counterparty_id = transactionLines.find(
  line => line.counterpartyId
)?.counterpartyId || null;
```

**Purpose**: Links the entire journal entry to a primary counterparty for tracking purposes.

### Rule 4: `p_if_cash_location_id` Extraction

```typescript
// Extract counterparty's cash location for mirror journal creation
// ONLY when counterparty has linkedCompanyId (internal counterparty)
const counterpartyWithLinkedCompany = transactionLines.find(
  line => line.counterpartyId && line.linkedCompanyId
);

p_if_cash_location_id = counterpartyWithLinkedCompany?.counterpartyCashLocationId || null;
```

**⚠️ CRITICAL**: This parameter uses `counterpartyCashLocationId`, NOT `cashLocationId`!

**Purpose**: When creating a mirror journal in the linked company, this specifies which cash location to use in the counterparty's company.

---

## Cash Location Parameters

### Concept: Two Cash Locations

```yaml
Scenario: Company A pays Company B with cash

Company A (My Company):
  - cashLocationId: "cash-loc-A-001"           # My company's cash drawer
  - Goes in: p_lines[].cash.cash_location_id

Company B (Counterparty):
  - counterpartyCashLocationId: "cash-loc-B-001"  # Their cash drawer
  - Goes in: p_if_cash_location_id
```

### When to Include Cash Location in `p_lines`

```typescript
// Add cash object to line ONLY if the line has a cash location
if (line.cashLocationId) {
  transformedLine.cash = {
    cash_location_id: line.cashLocationId  // ← My company's cash location
  };
}
```

**Conditions for Cash Location**:
1. ✅ Account is a cash-based account (e.g., Cash on Hand, Petty Cash)
2. ✅ User explicitly selected a cash location in the form
3. ❌ Never include if user didn't select a cash location

---

## Counterparty Parameters

### Concept: Two Counterparty Scenarios

#### 1. External Counterparty (No Mirror Journal)

```yaml
External Counterparty:
  - counterpartyId: "cp-external-001"
  - linkedCompanyId: null                # NOT an internal counterparty
  - Result: No mirror journal created
```

**RPC Parameters**:
```typescript
p_counterparty_id = "cp-external-001"
p_if_cash_location_id = null  // ← No mirror journal, so null
```

#### 2. Internal Counterparty (Mirror Journal Required)

```yaml
Internal Counterparty:
  - counterpartyId: "cp-internal-001"
  - linkedCompanyId: "company-B-uuid"   # Internal counterparty
  - counterpartyCashLocationId: "cash-loc-B-001"  # Their cash location
  - Result: Mirror journal created in Company B
```

**RPC Parameters**:
```typescript
p_counterparty_id = "cp-internal-001"
p_if_cash_location_id = "cash-loc-B-001"  // ← Counterparty's cash location
```

### Debt Object Construction

When a line has a counterparty (for payable/receivable accounts):

```typescript
if (line.counterpartyId) {
  const now = new Date();
  const issueDate = line.issueDate ? new Date(line.issueDate) : now;
  const dueDate = line.dueDate
    ? new Date(line.dueDate)
    : new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000); // +30 days default

  transformedLine.debt = {
    counterparty_id: line.counterpartyId,
    direction: line.isDebit ? 'receivable' : 'payable',
    category: line.debtCategory || 'other',
    original_amount: line.amount.toString(),
    interest_rate: (line.interestRate || 0).toString(),
    interest_account_id: line.interestAccountId || '',
    interest_due_day: line.interestDueDay || 0,
    issue_date: issueDate.toISOString().split('T')[0],  // yyyy-MM-dd
    due_date: dueDate.toISOString().split('T')[0],      // yyyy-MM-dd
    description: line.debtDescription || '',
    linkedCounterparty_store_id: line.counterpartyStoreId || '',
    linkedCounterparty_companyId: line.linkedCompanyId || ''
  };
}
```

---

## Complete Case Studies

### Case 1: Simple Journal Entry (No Cash, No Counterparty)

**Scenario**: Record office supplies expense

**Transaction Lines**:
```typescript
[
  {
    isDebit: true,
    accountId: "acc-expense-001",
    amount: 50000,
    description: "Office supplies",
    cashLocationId: null,          // ← No cash involved
    counterpartyId: null,          // ← No counterparty
  },
  {
    isDebit: false,
    accountId: "acc-bank-001",
    amount: 50000,
    description: "Payment from bank",
    cashLocationId: null,
    counterpartyId: null,
  }
]
```

**RPC Parameters**:
```typescript
{
  p_base_amount: 50000,
  p_company_id: "company-A-uuid",
  p_created_by: "user-001",
  p_description: "Office supplies purchase",
  p_entry_date_utc: "2025-11-12T14:30:00Z",
  p_lines: [
    {
      account_id: "acc-expense-001",
      description: "Office supplies",
      debit: "50000",
      credit: "0"
      // NO cash object
      // NO debt object
    },
    {
      account_id: "acc-bank-001",
      description: "Payment from bank",
      debit: "0",
      credit: "50000"
      // NO cash object
      // NO debt object
    }
  ],
  p_store_id: "store-001",
  p_counterparty_id: null,           // ← No counterparty
  p_if_cash_location_id: null        // ← No mirror journal
}
```

---

### Case 2: Cash Transaction (My Company Only)

**Scenario**: Customer pays cash for sale

**Transaction Lines**:
```typescript
[
  {
    isDebit: true,
    accountId: "acc-cash-001",
    amount: 100000,
    description: "Cash payment received",
    cashLocationId: "cash-loc-A-001",  // ← My company's cash drawer
    counterpartyId: null,              // ← External customer (not tracked)
  },
  {
    isDebit: false,
    accountId: "acc-revenue-001",
    amount: 100000,
    description: "Sales revenue",
    cashLocationId: null,
    counterpartyId: null,
  }
]
```

**RPC Parameters**:
```typescript
{
  p_base_amount: 100000,
  p_company_id: "company-A-uuid",
  p_created_by: "user-001",
  p_description: "Cash sale",
  p_entry_date_utc: "2025-11-12T14:30:00Z",
  p_lines: [
    {
      account_id: "acc-cash-001",
      description: "Cash payment received",
      debit: "100000",
      credit: "0",
      cash: {
        cash_location_id: "cash-loc-A-001"  // ← My company's cash drawer
      }
      // NO debt object (no counterparty)
    },
    {
      account_id: "acc-revenue-001",
      description: "Sales revenue",
      debit: "0",
      credit: "100000"
      // NO cash object
      // NO debt object
    }
  ],
  p_store_id: "store-001",
  p_counterparty_id: null,           // ← No counterparty tracking
  p_if_cash_location_id: null        // ← No mirror journal
}
```

---

### Case 3: External Counterparty (Accounts Receivable)

**Scenario**: Invoice external customer (no mirror journal)

**Transaction Lines**:
```typescript
[
  {
    isDebit: true,
    accountId: "acc-receivable-001",
    amount: 200000,
    description: "Invoice to customer",
    cashLocationId: null,
    counterpartyId: "cp-external-001",      // ← External counterparty
    linkedCompanyId: null,                  // ← NOT internal
    counterpartyCashLocationId: null,       // ← No mirror journal
    debtCategory: "sales",
    issueDate: "2025-11-12",
    dueDate: "2025-12-12",
  },
  {
    isDebit: false,
    accountId: "acc-revenue-001",
    amount: 200000,
    description: "Sales revenue",
    cashLocationId: null,
    counterpartyId: null,
  }
]
```

**RPC Parameters**:
```typescript
{
  p_base_amount: 200000,
  p_company_id: "company-A-uuid",
  p_created_by: "user-001",
  p_description: "Invoice to external customer",
  p_entry_date_utc: "2025-11-12T14:30:00Z",
  p_lines: [
    {
      account_id: "acc-receivable-001",
      description: "Invoice to customer",
      debit: "200000",
      credit: "0",
      // NO cash object (not cash transaction)
      debt: {
        counterparty_id: "cp-external-001",
        direction: "receivable",           // isDebit = true
        category: "sales",
        original_amount: "200000",
        interest_rate: "0",
        interest_account_id: "",
        interest_due_day: 0,
        issue_date: "2025-11-12",
        due_date: "2025-12-12",
        description: "",
        linkedCounterparty_store_id: "",   // ← Empty (not internal)
        linkedCounterparty_companyId: ""   // ← Empty (not internal)
      }
    },
    {
      account_id: "acc-revenue-001",
      description: "Sales revenue",
      debit: "0",
      credit: "200000"
      // NO cash object
      // NO debt object
    }
  ],
  p_store_id: "store-001",
  p_counterparty_id: "cp-external-001",  // ← First counterparty found
  p_if_cash_location_id: null            // ← External counterparty = no mirror
}
```

---

### Case 4: Internal Counterparty + Accounts Receivable (Mirror Journal Required)

**Scenario**: Company A invoices Company B (both companies in same system)

**Transaction Lines**:
```typescript
[
  {
    isDebit: true,
    accountId: "acc-receivable-001",
    amount: 300000,
    description: "Invoice to sister company",
    cashLocationId: null,
    counterpartyId: "cp-internal-001",         // ← Internal counterparty
    linkedCompanyId: "company-B-uuid",         // ← Link to Company B
    counterpartyStoreId: "store-B-001",        // ← Their store
    counterpartyCashLocationId: null,          // ← NOT cash transaction
    debtCategory: "sales",
    issueDate: "2025-11-12",
    dueDate: "2025-12-12",
  },
  {
    isDebit: false,
    accountId: "acc-revenue-001",
    amount: 300000,
    description: "Sales revenue",
    cashLocationId: null,
    counterpartyId: null,
  }
]
```

**RPC Parameters**:
```typescript
{
  p_base_amount: 300000,
  p_company_id: "company-A-uuid",
  p_created_by: "user-001",
  p_description: "Invoice to sister company",
  p_entry_date_utc: "2025-11-12T14:30:00Z",
  p_lines: [
    {
      account_id: "acc-receivable-001",
      description: "Invoice to sister company",
      debit: "300000",
      credit: "0",
      // NO cash object (not cash transaction)
      debt: {
        counterparty_id: "cp-internal-001",
        direction: "receivable",
        category: "sales",
        original_amount: "300000",
        interest_rate: "0",
        interest_account_id: "",
        interest_due_day: 0,
        issue_date: "2025-11-12",
        due_date: "2025-12-12",
        description: "",
        linkedCounterparty_store_id: "store-B-001",      // ← Their store
        linkedCounterparty_companyId: "company-B-uuid"   // ← Their company
      }
    },
    {
      account_id: "acc-revenue-001",
      description: "Sales revenue",
      debit: "0",
      credit: "300000"
      // NO cash object
      // NO debt object
    }
  ],
  p_store_id: "store-A-001",
  p_counterparty_id: "cp-internal-001",  // ← Internal counterparty
  p_if_cash_location_id: null            // ← No cash involved, so null
}
```

**Result**: Mirror journal created in Company B with:
- Debit: Accounts Payable
- Credit: Expense Account
- Links back to Company A

---

### Case 5: Internal Counterparty + Cash Transaction (Mirror Journal with Cash) ⭐

**Scenario**: Company A pays Company B with cash (sister companies)

**Transaction Lines**:
```typescript
[
  {
    isDebit: true,
    accountId: "acc-expense-001",
    amount: 500000,
    description: "Payment to sister company",
    cashLocationId: null,
    counterpartyId: "cp-internal-001",         // ← Internal counterparty
    linkedCompanyId: "company-B-uuid",         // ← Company B
    counterpartyStoreId: "store-B-001",        // ← Their store
    counterpartyCashLocationId: "cash-loc-B-001",  // ⭐ Their cash drawer
    debtCategory: "expense",
  },
  {
    isDebit: false,
    accountId: "acc-cash-001",
    amount: 500000,
    description: "Cash payment",
    cashLocationId: "cash-loc-A-001",          // ⭐ My cash drawer
    counterpartyId: null,
  }
]
```

**RPC Parameters**:
```typescript
{
  p_base_amount: 500000,
  p_company_id: "company-A-uuid",
  p_created_by: "user-001",
  p_description: "Cash payment to sister company",
  p_entry_date_utc: "2025-11-12T14:30:00Z",
  p_lines: [
    {
      account_id: "acc-expense-001",
      description: "Payment to sister company",
      debit: "500000",
      credit: "0",
      // NO cash object (expense account, not cash account)
      debt: {
        counterparty_id: "cp-internal-001",
        direction: "payable",              // isDebit = false (wait, isDebit = true but direction = payable?)
        category: "expense",
        original_amount: "500000",
        interest_rate: "0",
        interest_account_id: "",
        interest_due_day: 0,
        issue_date: "2025-11-12",
        due_date: "2025-12-12",
        description: "",
        linkedCounterparty_store_id: "store-B-001",
        linkedCounterparty_companyId: "company-B-uuid"
      }
    },
    {
      account_id: "acc-cash-001",
      description: "Cash payment",
      debit: "0",
      credit: "500000",
      cash: {
        cash_location_id: "cash-loc-A-001"  // ⭐ My company's cash drawer
      }
      // NO debt object
    }
  ],
  p_store_id: "store-A-001",
  p_counterparty_id: "cp-internal-001",
  p_if_cash_location_id: "cash-loc-B-001"  // ⭐ COUNTERPARTY's cash drawer (for mirror)
}
```

**Critical Points**:
1. ✅ `p_lines[1].cash.cash_location_id` = `"cash-loc-A-001"` (MY company's cash drawer)
2. ✅ `p_if_cash_location_id` = `"cash-loc-B-001"` (COUNTERPARTY's cash drawer)
3. ✅ These are TWO DIFFERENT cash locations!

**Result**:
- Main journal in Company A (debit expense, credit cash from `cash-loc-A-001`)
- Mirror journal in Company B (debit cash to `cash-loc-B-001`, credit revenue)

---

### Case 6: Multiple Counterparties (Complex Journal Entry)

**Scenario**: Split payment between two suppliers

**Transaction Lines**:
```typescript
[
  {
    isDebit: true,
    accountId: "acc-expense-001",
    amount: 100000,
    description: "Payment to Supplier A",
    cashLocationId: null,
    counterpartyId: "cp-supplier-A",           // ← First counterparty
    linkedCompanyId: null,
    counterpartyCashLocationId: null,
    debtCategory: "expense",
  },
  {
    isDebit: true,
    accountId: "acc-expense-001",
    amount: 150000,
    description: "Payment to Supplier B",
    cashLocationId: null,
    counterpartyId: "cp-supplier-B",           // ← Second counterparty
    linkedCompanyId: null,
    counterpartyCashLocationId: null,
    debtCategory: "expense",
  },
  {
    isDebit: false,
    accountId: "acc-bank-001",
    amount: 250000,
    description: "Bank transfer",
    cashLocationId: null,
    counterpartyId: null,
  }
]
```

**RPC Parameters**:
```typescript
{
  p_base_amount: 250000,  // 100000 + 150000
  p_company_id: "company-A-uuid",
  p_created_by: "user-001",
  p_description: "Split payment to suppliers",
  p_entry_date_utc: "2025-11-12T14:30:00Z",
  p_lines: [
    {
      account_id: "acc-expense-001",
      description: "Payment to Supplier A",
      debit: "100000",
      credit: "0",
      debt: {
        counterparty_id: "cp-supplier-A",
        direction: "payable",
        category: "expense",
        original_amount: "100000",
        // ... other debt fields
      }
    },
    {
      account_id: "acc-expense-001",
      description: "Payment to Supplier B",
      debit: "150000",
      credit: "0",
      debt: {
        counterparty_id: "cp-supplier-B",
        direction: "payable",
        category: "expense",
        original_amount: "150000",
        // ... other debt fields
      }
    },
    {
      account_id: "acc-bank-001",
      description: "Bank transfer",
      debit: "0",
      credit: "250000"
    }
  ],
  p_store_id: "store-001",
  p_counterparty_id: "cp-supplier-A",     // ← FIRST counterparty found
  p_if_cash_location_id: null             // ← No internal counterparty
}
```

**Note**: Only the FIRST counterparty (`cp-supplier-A`) is used for `p_counterparty_id`. Each line maintains its own counterparty relationship in the `debt` object.

---

## Validation Rules

### Required Fields Validation

```typescript
// Minimum requirements for RPC call
if (!p_company_id) throw new Error('Company ID required');
if (!p_created_by) throw new Error('User ID required');
if (!p_entry_date) throw new Error('Entry date required');
if (!p_lines || p_lines.length === 0) throw new Error('At least one line required');
```

### Balance Validation

```typescript
// Debits must equal Credits
const totalDebits = p_lines.reduce((sum, line) =>
  sum + parseFloat(line.debit), 0
);
const totalCredits = p_lines.reduce((sum, line) =>
  sum + parseFloat(line.credit), 0
);

if (Math.abs(totalDebits - totalCredits) > 0.01) {
  throw new Error('Journal entry must be balanced');
}
```

### Cash Location Validation

```typescript
// If cash object present, cash_location_id must be valid UUID
p_lines.forEach(line => {
  if (line.cash && !isValidUUID(line.cash.cash_location_id)) {
    throw new Error('Invalid cash location ID');
  }
});
```

### Counterparty Validation

```typescript
// If debt object present, counterparty_id must be valid
p_lines.forEach(line => {
  if (line.debt && !isValidUUID(line.debt.counterparty_id)) {
    throw new Error('Invalid counterparty ID');
  }
});
```

### Mirror Journal Validation

```typescript
// If internal counterparty with cash, p_if_cash_location_id required
const hasInternalCounterparty = p_lines.some(line =>
  line.debt?.linkedCounterparty_companyId
);
const hasCashTransaction = p_lines.some(line => line.cash);

if (hasInternalCounterparty && hasCashTransaction && !p_if_cash_location_id) {
  throw new Error('Counterparty cash location required for internal cash transactions');
}
```

---

## Common Mistakes

### ❌ Mistake 1: Using Wrong Cash Location for Mirror Journal

```typescript
// ❌ WRONG - Using my company's cash location
p_if_cash_location_id = line.cashLocationId;  // This is MY cash drawer!

// ✅ CORRECT - Using counterparty's cash location
p_if_cash_location_id = line.counterpartyCashLocationId;  // Their cash drawer
```

### ❌ Mistake 2: Including Cash Object When Not Needed

```typescript
// ❌ WRONG - Cash object for non-cash account
{
  account_id: "acc-receivable-001",  // Not a cash account!
  debit: "100000",
  credit: "0",
  cash: {
    cash_location_id: "cash-loc-A-001"  // WRONG! Receivable ≠ Cash
  }
}

// ✅ CORRECT - Only include cash for cash accounts
{
  account_id: "acc-receivable-001",
  debit: "100000",
  credit: "0",
  debt: {
    counterparty_id: "cp-001",
    // ... debt fields
  }
  // NO cash object
}
```

### ❌ Mistake 3: Wrong p_counterparty_id Extraction

```typescript
// ❌ WRONG - Using last counterparty
p_counterparty_id = transactionLines[transactionLines.length - 1].counterpartyId;

// ✅ CORRECT - Using FIRST counterparty found
p_counterparty_id = transactionLines.find(
  line => line.counterpartyId
)?.counterpartyId || null;
```

### ❌ Mistake 4: Confusing Debit Direction in Debt Object

```typescript
// Transaction: Debit Accounts Receivable (I'm owed money)
{
  isDebit: true,
  accountId: "acc-receivable-001",
  counterpartyId: "cp-001",
  // ...
}

// ❌ WRONG
debt: {
  direction: "payable"  // WRONG! I'm owed money, not owing
}

// ✅ CORRECT
debt: {
  direction: "receivable"  // Correct! isDebit = true → receivable
}
```

### ❌ Mistake 5: Missing linkedCompanyId for Internal Counterparty

```typescript
// ❌ WRONG - Internal counterparty without linkedCompanyId
debt: {
  counterparty_id: "cp-internal-001",
  linkedCounterparty_companyId: ""  // Empty! No mirror journal will be created
}

// ✅ CORRECT
debt: {
  counterparty_id: "cp-internal-001",
  linkedCounterparty_companyId: "company-B-uuid"  // Mirror journal created!
}
```

---

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│ USER INPUT (TransactionForm)                                        │
├─────────────────────────────────────────────────────────────────────┤
│ • accountId: "acc-cash-001"                                         │
│ • amount: 100000                                                    │
│ • isDebit: true                                                     │
│ • cashLocationId: "cash-loc-A-001"           ← My company's cash   │
│ • counterpartyId: "cp-internal-001"                                │
│ • counterpartyCashLocationId: "cash-loc-B-001"  ← Their cash       │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│ PRESENTATION LAYER (JournalInputPage.tsx)                          │
├─────────────────────────────────────────────────────────────────────┤
│ const transactionLine = new TransactionLine(                       │
│   data.isDebit,                                                     │
│   data.accountId,                                                   │
│   data.cashLocationId,                 ← Store my cash location    │
│   data.counterpartyId,                                              │
│   data.counterpartyCashLocationId      ← Store their cash location │
│ )                                                                   │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│ DOMAIN LAYER (TransactionLine Entity)                              │
├─────────────────────────────────────────────────────────────────────┤
│ TransactionLine {                                                   │
│   cashLocationId: "cash-loc-A-001"           ← My cash             │
│   counterpartyId: "cp-internal-001"                                │
│   linkedCompanyId: "company-B-uuid"                                │
│   counterpartyCashLocationId: "cash-loc-B-001"  ← Their cash       │
│ }                                                                   │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│ REPOSITORY LAYER (JournalInputRepositoryImpl.ts)                   │
├─────────────────────────────────────────────────────────────────────┤
│ submitJournalEntry(entry) {                                         │
│   transactionLines: entry.transactionLines.map(line => ({          │
│     cashLocationId: line.cashLocationId,                           │
│     counterpartyId: line.counterpartyId,                           │
│     linkedCompanyId: line.linkedCompanyId,                         │
│     counterpartyCashLocationId: line.counterpartyCashLocationId    │
│   }))                                                               │
│ }                                                                   │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│ DATA LAYER (JournalInputDataSource.ts)                             │
├─────────────────────────────────────────────────────────────────────┤
│ // Transform lines to p_lines format                                │
│ const lines = params.transactionLines.map(line => {                │
│   const transformedLine: any = {                                    │
│     account_id: line.accountId,                                     │
│     debit: line.isDebit ? line.amount.toString() : '0',            │
│     credit: !line.isDebit ? line.amount.toString() : '0',          │
│   };                                                                │
│                                                                     │
│   if (line.cashLocationId) {                                        │
│     transformedLine.cash = {                                        │
│       cash_location_id: line.cashLocationId  ← My cash in p_lines  │
│     };                                                              │
│   }                                                                 │
│                                                                     │
│   if (line.counterpartyId) {                                        │
│     transformedLine.debt = {                                        │
│       counterparty_id: line.counterpartyId,                        │
│       linkedCounterparty_companyId: line.linkedCompanyId           │
│     };                                                              │
│   }                                                                 │
│                                                                     │
│   return transformedLine;                                           │
│ });                                                                 │
│                                                                     │
│ // Extract counterparty's cash location for mirror journal         │
│ const counterpartyWithLinkedCompany = params.transactionLines.find(│
│   line => line.counterpartyId && line.linkedCompanyId              │
│ );                                                                  │
│ const counterpartyStoreCashLocationId =                             │
│   counterpartyWithLinkedCompany?.counterpartyCashLocationId || null;│
│                                    ↑                                │
│                         Their cash for p_if_cash_location_id        │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│ RPC CALL (insert_journal_with_everything)                          │
├─────────────────────────────────────────────────────────────────────┤
│ supabase.rpc('insert_journal_with_everything', {                   │
│   p_lines: [                                                        │
│     {                                                               │
│       account_id: "acc-cash-001",                                   │
│       debit: "100000",                                              │
│       credit: "0",                                                  │
│       cash: {                                                       │
│         cash_location_id: "cash-loc-A-001"  ← My cash in p_lines   │
│       }                                                             │
│     }                                                               │
│   ],                                                                │
│   p_counterparty_id: "cp-internal-001",                            │
│   p_if_cash_location_id: "cash-loc-B-001"  ← Their cash for mirror │
│ })                                                                  │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│ DATABASE (PostgreSQL)                                               │
├─────────────────────────────────────────────────────────────────────┤
│ 1. Create journal entry in Company A                                │
│    - Debit: Cash Account (cash_loc_A-001)                          │
│    - Credit: Revenue Account                                        │
│                                                                     │
│ 2. Create mirror journal in Company B (if internal counterparty)   │
│    - Debit: Cash Account (cash-loc-B-001)  ← Using their cash!    │
│    - Credit: Expense Account                                        │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Quick Reference Table

| Scenario | `p_lines[].cash` | `p_counterparty_id` | `p_if_cash_location_id` | Mirror Journal |
|----------|------------------|---------------------|-------------------------|----------------|
| Simple entry (no cash, no counterparty) | ❌ null | ❌ null | ❌ null | ❌ No |
| Cash transaction only | ✅ My cash location | ❌ null | ❌ null | ❌ No |
| External counterparty (no cash) | ❌ null | ✅ Counterparty ID | ❌ null | ❌ No |
| Internal counterparty (no cash) | ❌ null | ✅ Counterparty ID | ❌ null | ✅ Yes (no cash) |
| Internal counterparty + cash | ✅ My cash location | ✅ Counterparty ID | ✅ Their cash location | ✅ Yes (with cash) |

---

## Summary Checklist

Before calling `insert_journal_with_everything_utc`, verify:

- [ ] `p_base_amount` = Sum of all debit amounts
- [ ] `p_entry_date_utc` = UTC timestamp with timezone
- [ ] `p_lines` = Balanced array (total debits = total credits)
- [ ] `p_lines[].cash.cash_location_id` = **My company's** cash location (if cash transaction)
- [ ] `p_lines[].debt.counterparty_id` = Counterparty ID (if counterparty involved)
- [ ] `p_lines[].debt.direction` = `"receivable"` (if debit) or `"payable"` (if credit)
- [ ] `p_counterparty_id` = **First** counterparty found in lines
- [ ] `p_if_cash_location_id` = **Counterparty's** cash location (if internal + cash)
- [ ] `p_if_cash_location_id` ≠ `p_lines[].cash.cash_location_id` (these are different!)

---

**Last Updated**: 2025-11-12
**Maintained By**: Development Team
**Related Files**:
- `/website/src/features/journal-input/data/datasources/JournalInputDataSource.ts`
- `/website/src/features/journal-input/domain/entities/TransactionLine.ts`
- `/website/docs/UPDATE_GUIDE.md`
