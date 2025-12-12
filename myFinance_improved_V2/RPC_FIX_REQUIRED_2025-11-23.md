# RPC Fix Required - Balance Summary

**Date**: 2025-11-23
**Status**: 🔴 **RPC ERROR FOUND - FIX REQUIRED**
**Priority**: HIGH

---

## 🚨 Problem Summary

RPC 함수 `get_cash_location_balance_summary`에 **컬럼명 오류**가 있습니다:
- **Error**: `column "id" does not exist`
- **Root Cause**: `cash_locations` 테이블의 PK가 `id`가 아니라 `cash_location_id`
- **Impact**: Balance Summary 데이터가 조회되지 않음 (Total Journal, Total Real이 모두 0으로 표시)

---

## 🔍 Error Details

### Test Result
```sql
SELECT * FROM get_cash_location_balance_summary('92232210-4223-433e-85fc-36827aa96fac');
```

**Error Response**:
```json
{
  "success": false,
  "error": "column \"id\" does not exist",
  "detail": "42703",
  "location_id": "92232210-4223-433e-85fc-36827aa96fac"
}
```

### Table Structure
`cash_locations` 테이블 컬럼:
- ✅ `cash_location_id` (UUID, PK)
- ❌ `id` (존재하지 않음)

### RPC Error Location
**File**: `GET_BALANCE_SUMMARY_RPC_2025-11-23.sql`
**Line 57**:
```sql
SELECT EXISTS(
  SELECT 1 FROM cash_locations
  WHERE id = p_location_id  -- ❌ WRONG: should be cash_location_id
    AND is_deleted = false
) INTO v_location_exists;
```

---

## ✅ Fix Applied (Code Ready)

### Fixed SQL
**File Created**: `GET_BALANCE_SUMMARY_RPC_FIXED_2025-11-23.sql`

**Change**:
```sql
-- Before (Error)
WHERE id = p_location_id

-- After (Fixed)
WHERE cash_location_id = p_location_id
```

---

## 🔧 Deployment Instructions

### Step 1: Open Supabase SQL Editor
1. Supabase Dashboard 접속
2. SQL Editor로 이동

### Step 2: Run the Fix SQL
아래 SQL을 실행하세요:

```sql
-- Fix Balance Summary RPC Function
CREATE OR REPLACE FUNCTION get_cash_location_balance_summary(
  p_location_id UUID
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_result JSON;
  v_location_exists BOOLEAN;
BEGIN
  -- ✅ FIXED: Changed 'id' to 'cash_location_id'
  SELECT EXISTS(
    SELECT 1 FROM cash_locations
    WHERE cash_location_id = p_location_id
      AND is_deleted = false
  ) INTO v_location_exists;

  IF NOT v_location_exists THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Location not found or deleted',
      'location_id', p_location_id
    );
  END IF;

  -- Get Balance Summary from v_cash_location view
  SELECT json_build_object(
    'success', true,
    'location_id', cash_location_id,
    'location_name', location_name,
    'location_type', location_type,
    'total_journal', COALESCE(total_journal_cash_amount, 0),
    'total_real', COALESCE(total_real_cash_amount, 0),
    'difference', COALESCE(cash_difference, 0),
    'is_balanced', ABS(COALESCE(cash_difference, 0)) < 0.01,
    'has_shortage', COALESCE(cash_difference, 0) < -0.01,
    'has_surplus', COALESCE(cash_difference, 0) > 0.01,
    'currency_symbol', primary_currency_symbol,
    'currency_code', primary_currency_code,
    'last_updated', created_at
  )
  INTO v_result
  FROM v_cash_location
  WHERE cash_location_id = p_location_id
    AND is_deleted = false;

  IF v_result IS NULL THEN
    RETURN json_build_object(
      'success', false,
      'error', 'No balance data found for location',
      'location_id', p_location_id,
      'note', 'Location exists but has no balance data in v_cash_location view'
    );
  END IF;

  RETURN v_result;

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'error', SQLERRM,
      'detail', SQLSTATE,
      'location_id', p_location_id
    );
END;
$$;
```

### Step 3: Test the Fix
수정 후 즉시 테스트:

```sql
-- Test with your location ID
SELECT * FROM get_cash_location_balance_summary('92232210-4223-433e-85fc-36827aa96fac');
```

**Expected Result** (success):
```json
{
  "success": true,
  "location_id": "92232210-4223-433e-85fc-36827aa96fac",
  "location_name": "Cash - test1",
  "location_type": "cash",
  "total_journal": 4622724.00,
  "total_real": 4622724.00,
  "difference": 0.00,
  "is_balanced": true,
  "currency_symbol": "₫",
  "currency_code": "VND"
}
```

---

## 📊 Current Situation Analysis

### What's Showing in the Screenshot

스크린샷의 dialog는 **기존에 있던 dialog**입니다:
- ✅ "Ending Completed!" 타이틀
- ✅ Total amount (₫4,622,724) 표시
- ✅ Currency breakdown (VND, USD)
- ⚠️ **Total Journal: ₫4,622,724.00** (데이터 있음)
- ❌ **Total Real: ₫0.00** (데이터 없음 - RPC 에러 때문)
- ❌ **Difference: ₫0.00** (잘못된 계산)

### Why Total Real is 0

1. **RPC Error**: `get_cash_location_balance_summary` 실행 실패
2. **Fallback**: Dialog가 기본값(0)으로 표시됨
3. **Missing Data**: `v_cash_location` view에서 데이터를 못 가져옴

### v_cash_location View Check Needed

RPC를 고친 후에도 데이터가 안 나오면, `v_cash_location` view 자체에 문제가 있을 수 있습니다.

---

## 🧪 Post-Fix Verification

RPC 수정 후 다음을 확인하세요:

### 1. Direct View Query
```sql
-- Check if v_cash_location has data
SELECT
  cash_location_id,
  location_name,
  total_journal_cash_amount,
  total_real_cash_amount,
  cash_difference
FROM v_cash_location
WHERE cash_location_id = '92232210-4223-433e-85fc-36827aa96fac';
```

**Expected**: Row with actual balance data

### 2. RPC Test
```sql
-- Test RPC function
SELECT * FROM get_cash_location_balance_summary('92232210-4223-433e-85fc-36827aa96fac');
```

**Expected**: JSON with total_journal and total_real values

### 3. Flutter App Test
앱에서 submit 후:
- ✅ Total Journal: (실제 금액)
- ✅ Total Real: (실제 금액)
- ✅ Difference: (계산된 차액)

---

## 🔍 Additional Investigation Needed

### If RPC Still Returns No Data After Fix

1. **Check v_cash_location view definition**:
   ```sql
   SELECT pg_get_viewdef('v_cash_location'::regclass, true);
   ```

2. **Check if cash_amount entries exist**:
   ```sql
   SELECT COUNT(*)
   FROM cash_amount_entries
   WHERE location_id = '92232210-4223-433e-85fc-36827aa96fac'
     AND deleted_at IS NULL;
   ```

3. **Check if legacy cash_amount table has data**:
   ```sql
   SELECT COUNT(*)
   FROM cash_amount
   WHERE location_id = '92232210-4223-433e-85fc-36827aa96fac'
     AND deleted_at IS NULL;
   ```

---

## 📝 Summary

| Item | Status | Action |
|------|--------|--------|
| RPC Error Identified | ✅ | Column 'id' → 'cash_location_id' |
| Fix SQL Created | ✅ | GET_BALANCE_SUMMARY_RPC_FIXED_2025-11-23.sql |
| Fix Deployed | ⏳ | **USER ACTION REQUIRED** |
| Fix Tested | ⏳ | After deployment |
| v_cash_location Verified | ⏳ | After RPC fix |
| Flutter Integration | ⏳ | After RPC fix |

---

## 🚀 Next Steps

1. ✅ **Fix RPC** (highest priority)
   - Copy SQL from this document
   - Run in Supabase SQL Editor
   - Verify success message

2. ⏳ **Test RPC**
   - Run test query
   - Verify JSON response has data

3. ⏳ **Test in App**
   - Submit cash ending
   - Check if Total Real shows correct value

4. ⏳ **UI Integration** (if RPC works)
   - Add dialog trigger to tab widgets
   - Complete the feature

---

**Created**: 2025-11-23
**Status**: Waiting for RPC fix deployment
**File**: [GET_BALANCE_SUMMARY_RPC_FIXED_2025-11-23.sql](GET_BALANCE_SUMMARY_RPC_FIXED_2025-11-23.sql)
