# Validation Report: Cash Location RPC Functions with _utc Suffix

## ✅ Validation Date: 2025-01-25

---

## 1. Function Names Verification

### Original Functions (기존 함수)
| Function Name | Status |
|--------------|--------|
| `get_cash_real` | ✅ Exists in DB |
| `get_bank_real` | ✅ Exists in DB |
| `get_vault_real` | ✅ Exists in DB |
| `get_location_stock_flow_v2` | ✅ Exists in DB |

### New Functions with _utc Suffix (새로 생성될 함수)
| Function Name | Status |
|--------------|--------|
| `get_cash_real_utc` | 🆕 Will be created |
| `get_bank_real_utc` | 🆕 Will be created |
| `get_vault_real_utc` | 🆕 Will be created |
| `get_location_stock_flow_v2_utc` | 🆕 Will be created |

**결론**: 함수명 네이밍 ✅ 정확함 (`_utc` 접미사 사용)

---

## 2. Parameters Verification (파라미터 검증)

### Function 1: `get_cash_real` → `get_cash_real_utc`
| Parameter | Type | DEFAULT | Status |
|-----------|------|---------|--------|
| `p_company_id` | uuid | - | ✅ Correct |
| `p_store_id` | uuid | - | ✅ Correct |
| `p_offset` | integer | 0 | ✅ Correct |
| `p_limit` | integer | 10 | ✅ Correct |

**결론**: 파라미터 ✅ 완전히 동일

---

### Function 2: `get_bank_real` → `get_bank_real_utc`
| Parameter | Type | DEFAULT | Status |
|-----------|------|---------|--------|
| `p_company_id` | uuid | - | ✅ Correct |
| `p_store_id` | uuid | - | ✅ Correct |
| `p_offset` | integer | 0 | ✅ Correct |
| `p_limit` | integer | 10 | ✅ Correct |

**결론**: 파라미터 ✅ 완전히 동일

---

### Function 3: `get_vault_real` → `get_vault_real_utc`
| Parameter | Type | DEFAULT | Status |
|-----------|------|---------|--------|
| `p_company_id` | uuid | - | ✅ Correct |
| `p_store_id` | uuid | - | ✅ Correct |
| `p_offset` | integer | 0 | ✅ Correct |
| `p_limit` | integer | 10 | ✅ Correct |

**결론**: 파라미터 ✅ 완전히 동일

---

### Function 4: `get_location_stock_flow_v2` → `get_location_stock_flow_v2_utc`
| Parameter | Type | DEFAULT | Status |
|-----------|------|---------|--------|
| `p_company_id` | uuid | - | ✅ Correct |
| `p_store_id` | uuid | - | ✅ Correct |
| `p_cash_location_id` | uuid | - | ✅ Correct |
| `p_offset` | integer | 0 | ✅ Correct |
| `p_limit` | integer | 20 | ✅ Correct |

**결론**: 파라미터 ✅ 완전히 동일

---

## 3. Table Structure & Column Verification (테이블 구조 및 컬럼 검증)

### Table 1: `cashier_amount_lines`
| Column Name | Data Type | Nullable | Used In Function | Status |
|------------|-----------|----------|-----------------|--------|
| `created_at` | timestamp without time zone | YES | Original | ✅ Exists |
| `created_at_utc` | timestamp with time zone | YES | NEW (_utc) | ✅ Exists |
| `record_date` | date | NO | Original | ✅ Exists |
| `record_date_utc` | timestamp with time zone | YES | NEW (_utc) | ✅ Exists |
| `location_id` | uuid | NO | Both | ✅ Exists |
| `company_id` | uuid | NO | Both | ✅ Exists |
| `store_id` | uuid | YES | Both | ✅ Exists |
| `entry_id` | uuid | YES | Both | ✅ Exists |

**결론**: ✅ 모든 컬럼 존재, `_utc` 컬럼 사용 가능

---

### Table 2: `bank_amount`
| Column Name | Data Type | Nullable | Used In Function | Status |
|------------|-----------|----------|-----------------|--------|
| `created_at` | timestamp without time zone | YES | Original | ✅ Exists |
| `created_at_utc` | timestamp with time zone | YES | NEW (_utc) | ✅ Exists |
| `record_date` | date | NO | Original | ✅ Exists |
| `record_date_utc` | timestamp with time zone | YES | NEW (_utc) | ✅ Exists |
| `location_id` | uuid | NO | Both | ✅ Exists |
| `company_id` | uuid | NO | Both | ✅ Exists |
| `store_id` | uuid | YES | Both | ✅ Exists |
| `entry_id` | uuid | YES | Both | ✅ Exists |

**결론**: ✅ 모든 컬럼 존재, `_utc` 컬럼 사용 가능

---

### Table 3: `vault_amount_line`
| Column Name | Data Type | Nullable | Used In Function | Status |
|------------|-----------|----------|-----------------|--------|
| `created_at` | timestamp without time zone | YES | Original | ✅ Exists |
| `created_at_utc` | timestamp with time zone | YES | NEW (_utc) | ✅ Exists |
| `record_date` | date | NO | Original | ✅ Exists |
| `record_date_utc` | timestamp with time zone | YES | NEW (_utc) | ✅ Exists |
| `location_id` | uuid | NO | Both | ✅ Exists |
| `company_id` | uuid | NO | Both | ✅ Exists |
| `store_id` | uuid | YES | Both | ✅ Exists |
| `entry_id` | uuid | YES | Both | ✅ Exists |

**결론**: ✅ 모든 컬럼 존재, `_utc` 컬럼 사용 가능

---

### Table 4: `cash_amount_entries`
| Column Name | Data Type | Nullable | Used In Function | Status |
|------------|-----------|----------|-----------------|--------|
| `created_at` | timestamp without time zone | YES | Original | ✅ Exists |
| `created_at_utc` | timestamp with time zone | YES | NEW (_utc) | ✅ Exists |
| `record_date` | date | NO | Original | ✅ Exists |
| `record_date_utc` | timestamp with time zone | YES | NEW (_utc) | ✅ Exists |
| `location_id` | uuid | NO | Both | ✅ Exists |
| `company_id` | uuid | NO | Both | ✅ Exists |
| `store_id` | uuid | YES | Both | ✅ Exists |
| `entry_id` | uuid | NO | Both | ✅ Exists |

**결론**: ✅ 모든 컬럼 존재, `_utc` 컬럼 사용 가능

---

### Table 5: `journal_amount_stock_flow`
| Column Name | Data Type | Nullable | Used In Function | Status |
|------------|-----------|----------|-----------------|--------|
| `created_at` | timestamp without time zone | NO | Original | ✅ Exists |
| `created_at_utc` | timestamp with time zone | YES | NEW (_utc) | ✅ Exists |
| `system_time` | timestamp without time zone | NO | Original | ✅ Exists |
| `system_time_utc` | timestamp with time zone | YES | NEW (_utc) | ✅ Exists |
| `cash_location_id` | uuid | NO | Both | ✅ Exists |
| `company_id` | uuid | NO | Both | ✅ Exists |
| `store_id` | uuid | YES | Both | ✅ Exists |
| `flow_id` | uuid | NO | Both | ✅ Exists |

**결론**: ✅ 모든 컬럼 존재, `_utc` 컬럼 사용 가능

---

### Table 6: `cash_locations`
| Column Name | Data Type | Nullable | Used In Function | Status |
|------------|-----------|----------|-----------------|--------|
| `cash_location_id` | uuid | NO | Both | ✅ Exists |
| `company_id` | uuid | NO | Both | ✅ Exists |
| `store_id` | uuid | YES | Both | ✅ Exists |
| `created_at` | timestamp without time zone | YES | Original | ✅ Exists |
| `created_at_utc` | timestamp with time zone | YES | NEW (_utc) | ✅ Exists |

**결론**: ✅ 모든 컬럼 존재

---

## 4. Column Mapping Summary (컬럼 매핑 요약)

### Function: `get_cash_real_utc`
| Original Column | New Column | Conversion | Status |
|----------------|------------|------------|--------|
| `cal.created_at` | `cal.created_at_utc` | Direct | ✅ |
| `cal.record_date` | `cal.record_date_utc` | Direct | ✅ |

### Function: `get_bank_real_utc`
| Original Column | New Column | Conversion | Status |
|----------------|------------|------------|--------|
| `ba.created_at` | `ba.created_at_utc` | Direct | ✅ |
| `ba.record_date` | `ba.record_date_utc` | Direct | ✅ |

### Function: `get_vault_real_utc`
| Original Column | New Column | Conversion | Status |
|----------------|------------|------------|--------|
| `val.record_date` | `val.record_date_utc` | Direct | ✅ |

### Function: `get_location_stock_flow_v2_utc`
| Original Column | New Column | Conversion | Status |
|----------------|------------|------------|--------|
| `cae.created_at` | `cae.created_at_utc` | Direct | ✅ |
| `j.created_at` | `j.created_at_utc` | Direct | ✅ |
| `j.system_time` | `j.system_time_utc` | Direct | ✅ |
| `prev_cae.created_at` | `prev_cae.created_at_utc` | Direct | ✅ |

---

## 5. Security & Permissions (보안 및 권한)

### SECURITY DEFINER Status
| Function | SECURITY DEFINER | Status |
|----------|-----------------|--------|
| `get_cash_real_utc` | ✅ YES | Matches original |
| `get_bank_real_utc` | ✅ YES | Matches original |
| `get_vault_real_utc` | ✅ YES | Matches original |
| `get_location_stock_flow_v2_utc` | ❌ NO | Matches original |

**결론**: ✅ Security settings match original functions

---

## 6. Return Type Verification (반환 타입 검증)

All functions return: `json`

| Function | Return Type | Status |
|----------|------------|--------|
| `get_cash_real_utc` | json | ✅ Correct |
| `get_bank_real_utc` | json | ✅ Correct |
| `get_vault_real_utc` | json | ✅ Correct |
| `get_location_stock_flow_v2_utc` | json | ✅ Correct |

---

## 7. Critical Issues Found (발견된 문제)

### ❌ No Issues Found!

All validations passed successfully.

---

## 8. Final Checklist (최종 체크리스트)

- [x] ✅ Function names have `_utc` suffix
- [x] ✅ Parameters exactly match original functions
- [x] ✅ All `_utc` columns exist in database
- [x] ✅ Data types are correct (timestamp with time zone)
- [x] ✅ All table joins use correct column names
- [x] ✅ WHERE clauses use correct column names
- [x] ✅ ORDER BY clauses use `_utc` columns
- [x] ✅ GROUP BY clauses use `_utc` columns where needed
- [x] ✅ SECURITY DEFINER settings match originals
- [x] ✅ Return types match originals (json)

---

## 9. Deployment Recommendation (배포 권장사항)

### Status: ✅ **READY FOR DEPLOYMENT**

This migration file is safe to deploy:
1. ✅ All column names verified against actual database schema
2. ✅ All parameters match original functions exactly
3. ✅ Function naming follows `_utc` suffix convention
4. ✅ No breaking changes to existing functions
5. ✅ All `_utc` columns already exist in tables

### Deployment Command:
```bash
supabase db push
```

Or manually:
```bash
psql -h your-host -U postgres -d your-db \
  -f supabase/migrations/20250125_update_cash_location_rpc_to_utc.sql
```

---

## 10. Testing Checklist After Deployment (배포 후 테스트 체크리스트)

- [ ] Test `get_cash_real_utc` returns data with UTC timestamps
- [ ] Test `get_bank_real_utc` returns data with UTC timestamps
- [ ] Test `get_vault_real_utc` returns data with UTC timestamps
- [ ] Test `get_location_stock_flow_v2_utc` returns data with UTC timestamps
- [ ] Verify original functions still work (backward compatibility)
- [ ] Compare results between original and `_utc` functions
- [ ] Check timestamps are in UTC format (timezone aware)

---

**Validation Completed**: 2025-01-25
**Validator**: Claude (Sonnet 4.5)
**Conclusion**: ✅ **ALL CHECKS PASSED - SAFE TO DEPLOY**
