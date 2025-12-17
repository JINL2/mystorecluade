# AI SQL Generator Debugging Manual

## Overview

This manual provides a systematic workflow for debugging AI SQL generation failures. The AI uses a Knowledge Graph (ontology) to understand table structures and generate correct SQL queries.

---

## Quick Reference: Error Types

| Error Pattern | Root Cause | Solution |
|---------------|------------|----------|
| `column X.Y does not exist` | Column not in table OR not registered in ontology | Check actual table → Add deprecated hint |
| `relation "X" does not exist` | Table not registered in ontology | Register table in ontology_tables |
| `column X.Y is ambiguous` | Missing table alias in JOIN | Update ai_usage_hint with proper JOIN pattern |
| Connection/timeout errors | Network issue | Ignore, retry test |

---

## Step-by-Step Debugging Workflow

### Step 1: Collect Failed Tests

```sql
-- Get recent failures with error details
SELECT
  question,
  error_message,
  created_at
FROM ai_sql_logs
WHERE success = false
  AND created_at > NOW() - INTERVAL '1 hour'
ORDER BY created_at DESC;
```

### Step 2: Categorize Errors

Group errors by pattern:

```sql
-- Categorize errors
SELECT
  CASE
    WHEN error_message LIKE '%does not exist%' THEN 'COLUMN_NOT_EXIST'
    WHEN error_message LIKE '%relation%does not exist%' THEN 'TABLE_NOT_EXIST'
    WHEN error_message LIKE '%ambiguous%' THEN 'AMBIGUOUS_COLUMN'
    WHEN error_message LIKE '%TypeError%' OR error_message LIKE '%connection%' THEN 'NETWORK_ERROR'
    ELSE 'OTHER'
  END as error_type,
  COUNT(*) as cnt,
  ARRAY_AGG(DISTINCT SUBSTRING(error_message, 1, 80)) as examples
FROM ai_sql_logs
WHERE success = false
  AND created_at > NOW() - INTERVAL '1 hour'
GROUP BY error_type
ORDER BY cnt DESC;
```

### Step 3: Extract Problem Columns

For "column does not exist" errors, extract the table.column:

```sql
-- Extract table.column from error messages
SELECT DISTINCT
  REGEXP_MATCHES(error_message, 'column ([a-z_]+)\.([a-z_]+) does not exist', 'i') as matches,
  error_message
FROM ai_sql_logs
WHERE success = false
  AND error_message LIKE '%does not exist%'
  AND created_at > NOW() - INTERVAL '1 hour';
```

---

## Step 4: Diagnose Each Column Error

For each problematic `table.column`, run this diagnostic:

### 4.1 Check if Column Actually Exists in Database

```sql
-- Replace 'TABLE_NAME' and 'COLUMN_NAME'
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'TABLE_NAME'
  AND column_name = 'COLUMN_NAME';
```

**Results:**
- ✅ **Column exists** → Problem is in ontology hints (AI using wrong alias or JOIN)
- ❌ **Column doesn't exist** → AI is hallucinating this column → Add as DEPRECATED

### 4.2 Check Ontology Registration Status

```sql
-- Check if column is in ontology_columns
SELECT table_name, column_name, is_deprecated, ai_usage_hint
FROM ontology_columns
WHERE table_name = 'TABLE_NAME'
  AND column_name = 'COLUMN_NAME';
```

**Results:**
- ❌ **Not registered** → AI doesn't know this column doesn't exist → INSERT as deprecated
- ✅ **Registered but is_deprecated = false** → Need to set deprecated = true
- ✅ **Registered and is_deprecated = true** → Check if hint is clear enough

### 4.3 Check Embeddings

```sql
-- Check if column is in ontology_embeddings
SELECT table_name, column_name, text_content
FROM ontology_embeddings
WHERE table_name = 'TABLE_NAME'
  AND column_name = 'COLUMN_NAME';
```

**Results:**
- ❌ **Not in embeddings** → Sync needed (will be auto-synced on next trigger)
- ✅ **In embeddings but wrong text** → UPDATE text_content with warning

---

## Step 5: Apply Fixes

### Fix Type A: Non-existent Column (AI Hallucination)

When AI tries to use a column that doesn't exist in the actual table:

```sql
-- 1. Add to ontology_columns as DEPRECATED
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('TABLE_NAME', 'FAKE_COLUMN', 'text', true, true,
        '⛔⛔ DOES NOT EXIST! [Explain correct alternative here]')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- 2. Update embeddings
UPDATE ontology_embeddings
SET text_content = 'TABLE_NAME.FAKE_COLUMN: ⛔⛔ DOES NOT EXIST! [Explain correct alternative]'
WHERE table_name = 'TABLE_NAME' AND column_name = 'FAKE_COLUMN';

-- If not in embeddings, it will be synced automatically via trigger
```

### Fix Type B: Wrong Column Name

When AI uses wrong column name (e.g., `name` instead of `account_name`):

```sql
-- 1. Add wrong column as deprecated
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('accounts', 'name', 'text', true, true,
        '⛔⛔ DOES NOT EXIST! Use account_name instead!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- 2. Strengthen correct column hint
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ Account name. ⛔ accounts.name does NOT exist! Must use account_name!'
WHERE table_name = 'accounts' AND column_name = 'account_name';
```

### Fix Type C: Missing JOIN (Column in Different Table)

When AI tries to access column directly but needs JOIN:

```sql
-- Example: users.role_type doesn't exist, need to JOIN via user_roles → roles
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('users', 'role_type', 'text', true, true,
        '⛔⛔ DOES NOT EXIST! users has NO role_type! Use: users → user_roles → roles.role_type OR use v_user_role_info view')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- Also update the correct table's hint
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ Role type (admin/manager/employee). ⛔ users.role_type does NOT exist! Must JOIN: users → user_roles → roles. Or use v_user_role_info view!'
WHERE table_name = 'roles' AND column_name = 'role_type';
```

### Fix Type D: Missing company_id in Child Table

When table doesn't have company_id directly:

```sql
-- Example: journal_lines has no company_id
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('journal_lines', 'company_id', 'uuid', true, true,
        '⛔⛔ DOES NOT EXIST! Must JOIN parent table: JOIN journal_entries je ON jl.journal_id = je.journal_id WHERE je.company_id = $company_id')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;
```

---

## Step 6: Verify Fixes

After applying fixes, verify:

```sql
-- Check deprecated columns are registered
SELECT table_name, column_name, is_deprecated, ai_usage_hint
FROM ontology_columns
WHERE is_deprecated = true
ORDER BY table_name, column_name;

-- Check embeddings are synced
SELECT table_name, column_name, text_content
FROM ontology_embeddings
WHERE text_content LIKE '%DOES NOT EXIST%'
ORDER BY table_name, column_name;
```

---

## Step 7: Re-test

Run the same 30 test questions and compare success rate:

```sql
-- Compare before/after
SELECT
  DATE_TRUNC('hour', created_at) as hour,
  COUNT(*) FILTER (WHERE success = true) as success_cnt,
  COUNT(*) FILTER (WHERE success = false) as fail_cnt,
  ROUND(100.0 * COUNT(*) FILTER (WHERE success = true) / COUNT(*), 1) as success_rate
FROM ai_sql_logs
WHERE created_at > NOW() - INTERVAL '2 hours'
GROUP BY hour
ORDER BY hour;
```

---

## Common Error Patterns & Solutions

### Pattern 1: `u.role_type does not exist`

**Diagnosis:** AI assumes users table has role_type directly

**Root Cause:** role_type is in `roles` table, not `users`

**Solution:**
```sql
-- Add deprecated users.role_type
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('users', 'role_type', 'text', true, true,
        '⛔⛔ DOES NOT EXIST! Use v_user_role_info.role_type or JOIN: users → user_roles → roles.role_type');
```

### Pattern 2: `a.name does not exist`

**Diagnosis:** AI uses `name` instead of `account_name`

**Root Cause:** Column naming convention difference

**Solution:**
```sql
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('accounts', 'name', 'text', true, true,
        '⛔⛔ DOES NOT EXIST! Use account_name instead!');
```

### Pattern 3: `jl.company_id does not exist`

**Diagnosis:** AI tries to filter journal_lines by company_id

**Root Cause:** journal_lines doesn't have company_id, parent table journal_entries does

**Solution:**
```sql
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('journal_lines', 'company_id', 'uuid', true, true,
        '⛔⛔ DOES NOT EXIST! JOIN journal_entries: je ON jl.journal_id = je.journal_id WHERE je.company_id = $company_id');
```

### Pattern 4: `r.user_id does not exist`

**Diagnosis:** AI assumes roles has user_id directly

**Root Cause:** Many-to-many relationship via user_roles junction table

**Solution:**
```sql
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('roles', 'user_id', 'uuid', true, true,
        '⛔⛔ DOES NOT EXIST! Use user_roles: JOIN user_roles ur ON roles.role_id = ur.role_id');
```

### Pattern 5: `jl.journal_entry_id does not exist`

**Diagnosis:** AI uses wrong FK column name

**Root Cause:** Actual column is `journal_id`, not `journal_entry_id`

**Solution:**
```sql
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('journal_lines', 'journal_entry_id', 'uuid', true, true,
        '⛔⛔ DOES NOT EXIST! Use journal_id instead. JOIN: jl.journal_id = je.journal_id');
```

---

## Diagnostic Queries Cheat Sheet

### Find All Non-existent Columns in Ontology

```sql
-- Columns registered in ontology but don't exist in actual tables
SELECT oc.table_name, oc.column_name, oc.is_deprecated
FROM ontology_columns oc
WHERE NOT EXISTS (
  SELECT 1 FROM information_schema.columns ic
  WHERE ic.table_name = oc.table_name
    AND ic.column_name = oc.column_name
)
AND oc.table_name NOT LIKE 'v_%'  -- Exclude views
ORDER BY oc.table_name, oc.column_name;
```

### Find Missing Deprecated Flags

```sql
-- Non-existent columns that should be deprecated but aren't
SELECT oc.table_name, oc.column_name, oc.ai_usage_hint
FROM ontology_columns oc
WHERE NOT EXISTS (
  SELECT 1 FROM information_schema.columns ic
  WHERE ic.table_name = oc.table_name
    AND ic.column_name = oc.column_name
)
AND oc.is_deprecated = false
AND oc.table_name NOT LIKE 'v_%';
```

### Check Embedding Sync Status

```sql
-- Columns in ontology_columns but not in embeddings
SELECT oc.table_name, oc.column_name
FROM ontology_columns oc
WHERE NOT EXISTS (
  SELECT 1 FROM ontology_embeddings oe
  WHERE oe.table_name = oc.table_name
    AND oe.column_name = oc.column_name
)
AND oc.is_active = true;
```

### Full Health Check

```sql
SELECT
  'Total ontology columns' as metric, COUNT(*)::text as value FROM ontology_columns WHERE is_active = true
UNION ALL
SELECT 'Deprecated columns', COUNT(*)::text FROM ontology_columns WHERE is_deprecated = true
UNION ALL
SELECT 'Total embeddings', COUNT(*)::text FROM ontology_embeddings WHERE is_active = true
UNION ALL
SELECT 'Recent test success rate',
  ROUND(100.0 * COUNT(*) FILTER (WHERE success) / NULLIF(COUNT(*), 0), 1)::text || '%'
  FROM ai_sql_logs WHERE created_at > NOW() - INTERVAL '1 hour';
```

---

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    AI SQL ERROR DEBUGGING                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 1: Collect Failed Tests                                    │
│  SELECT question, error_message FROM ai_sql_logs WHERE NOT success│
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 2: Categorize Errors                                       │
│  • COLUMN_NOT_EXIST                                              │
│  • TABLE_NOT_EXIST                                               │
│  • AMBIGUOUS_COLUMN                                              │
│  • NETWORK_ERROR (ignore)                                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 3: For each "column X.Y does not exist"                    │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
┌──────────────────────────┐    ┌──────────────────────────┐
│ Does column exist in DB? │    │ Does column exist in DB? │
│        YES               │    │        NO                │
└──────────────────────────┘    └──────────────────────────┘
              │                               │
              ▼                               ▼
┌──────────────────────────┐    ┌──────────────────────────┐
│ Problem: Wrong JOIN/alias │    │ AI is hallucinating!     │
│ Fix: Update ai_usage_hint │    │ Fix: Add as DEPRECATED   │
│ with correct JOIN pattern │    │ with warning message     │
└──────────────────────────┘    └──────────────────────────┘
              │                               │
              └───────────────┬───────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 4: Check ontology_columns                                  │
│  • Is column registered? → If NO, INSERT as deprecated           │
│  • Is is_deprecated = true? → If NO, UPDATE                      │
│  • Is ai_usage_hint clear? → If NO, UPDATE with ⛔ warning       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 5: Check ontology_embeddings                               │
│  • Is text_content synced? → If NO, UPDATE or trigger sync       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 6: Re-run Tests                                            │
│  Compare success rate before/after                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 7: Iterate until 90%+ success rate                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## Best Practices

1. **Always add non-existent columns as DEPRECATED** - Don't delete them, mark them so AI knows NOT to use them

2. **Use clear warning symbols** - `⛔⛔ DOES NOT EXIST!` is more effective than just "deprecated"

3. **Provide alternatives** - Always tell AI what to use instead: "Use X instead" or "JOIN Y"

4. **Check both tables** - If AI uses wrong table, update BOTH the wrong table (add deprecated) AND the correct table (strengthen hint)

5. **Test incrementally** - Run 30 tests after each fix batch to measure improvement

6. **Monitor embeddings** - Ensure ontology_embeddings stays in sync with ontology_columns

---

## Version History

| Date | Changes |
|------|---------|
| 2025-12-16 | Initial version |
