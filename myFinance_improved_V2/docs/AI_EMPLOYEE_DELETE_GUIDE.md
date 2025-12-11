# AI용 직원 삭제 가이드 (안전한 버전)

## 핵심 원칙

```
1. users 테이블은 절대 삭제하지 않음 (다른 회사 소속 가능)
2. 회사 연결만 끊음 (user_companies, user_stores, user_roles → Soft Delete)
3. created_by 등 FK 참조는 그대로 유지 (users가 남아있으므로 유효함)
4. 히스토리 데이터는 보존 (shift_requests, journal_entries 등)
```

---

## 데이터베이스 연결 구조

```
users (직원) ← 삭제하지 않음!
  │
  ├── user_companies ──► Soft Delete (is_deleted = true)
  │     └── company_id → companies
  │
  ├── user_stores ─────► Soft Delete (is_deleted = true)
  │     └── store_id → stores → company_id
  │
  ├── user_roles ──────► Soft Delete (is_deleted = true)
  │     └── role_id → roles → company_id
  │
  ├── user_salaries ───► Hard Delete (실제 삭제, 선택적)
  │     └── company_id → companies
  │
  ├── shift_requests ──► 유지 (근무 히스토리)
  │
  └── created_by 참조들 → 유지 (FK 유효)
        ├── journal_entries.created_by
        ├── cash_amount_entries.created_by
        ├── cashier_amount_lines.created_by (NOT NULL)
        ├── inventory_invoice.created_by
        └── ... 기타
```

---

## 삭제 전략

### Soft Delete (is_deleted = true)
| 테이블 | 이유 |
|--------|------|
| user_companies | 복구 가능, 소속 이력 보존 |
| user_stores | 복구 가능, 매장 배정 이력 보존 |
| user_roles | 복구 가능, 역할 이력 보존 |

### Hard Delete (실제 삭제)
| 테이블 | 이유 |
|--------|------|
| user_salaries | 회사별 급여 정보, 선택적 삭제 |

### 유지 (삭제하지 않음)
| 테이블 | 이유 |
|--------|------|
| users | 다른 회사 소속 가능 |
| shift_requests | 근무 히스토리 보존 필수 |
| journal_entries | 회계 기록 보존 필수 |
| cash_amount_entries | 현금 거래 기록 보존 |
| cashier_amount_lines | NOT NULL 컬럼, 수정 불가 |
| 기타 created_by 참조 | 히스토리 보존 |

---

## NOT NULL FK 컬럼 (절대 건드리지 않음)

```sql
-- 이 컬럼들은 NULL로 설정할 수 없음!
-- users 테이블을 유지하므로 문제없음

cash_control.created_by          -- NOT NULL
cashier_amount_lines.created_by  -- NOT NULL
book_exchange_rates.created_by   -- NOT NULL
cash_amount_stock_flow.created_by -- NOT NULL
cash_amount_entries.created_by   -- NOT NULL
inventory_session_members.user_id -- NOT NULL
vault_amount_line.created_by     -- NOT NULL (SET NULL 시도 시 에러!)
```

---

## RPC 함수 사용법

### 1. validate_employee_delete - 삭제 전 검증

```sql
SELECT validate_employee_delete(
    'company_uuid',
    'employee_uuid'
);
```

**반환값:**
```json
{
    "success": true,
    "message": "삭제 가능합니다.",
    "employee": {
        "user_id": "...",
        "name": "홍길동",
        "email": "hong@example.com"
    },
    "data_summary": {
        "will_soft_delete": {
            "user_companies": 1,
            "user_stores": 2,
            "user_roles": 1
        },
        "will_hard_delete": {
            "user_salaries": 1
        },
        "will_preserve": {
            "shift_requests": 45,
            "journal_entries_created": 10,
            "cash_amount_entries": 5,
            "inventory_invoice": 3
        }
    }
}
```

**에러 코드:**
| error | 의미 |
|-------|------|
| NOT_OWNER | 요청자가 회사 Owner가 아님 |
| EMPLOYEE_NOT_FOUND | 직원이 해당 회사에 소속되어 있지 않음 |
| CANNOT_DELETE_SELF | 자기 자신은 삭제 불가 |

---

### 2. delete_employee - 직원 삭제 실행

```sql
-- 급여 정보도 삭제 (기본값)
SELECT delete_employee(
    'company_uuid',
    'employee_uuid',
    true
);

-- 급여 정보 유지
SELECT delete_employee(
    'company_uuid',
    'employee_uuid',
    false
);
```

**반환값:**
```json
{
    "success": true,
    "message": "직원이 회사에서 제거되었습니다.",
    "employee_id": "...",
    "company_id": "...",
    "affected": {
        "user_stores_soft_deleted": 2,
        "user_roles_soft_deleted": 1,
        "user_companies_soft_deleted": 1,
        "user_salaries_deleted": 1
    },
    "deleted_at": "2025-12-10T...",
    "note": "users 테이블은 유지됩니다. 근무 기록 등 히스토리 데이터도 보존됩니다."
}
```

---

## Flutter 사용 예시

```dart
// 1. 삭제 전 검증
final validation = await supabase.rpc('validate_employee_delete', params: {
    'p_company_id': companyId,
    'p_employee_user_id': employeeId,
});

if (validation['success']) {
    final summary = validation['data_summary'];
    final employee = validation['employee'];

    // 확인 다이얼로그 표시
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('${employee['name']} 직원 삭제'),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text('Soft Delete: ${summary['will_soft_delete']}'),
                    Text('Hard Delete: ${summary['will_hard_delete']}'),
                    Text('보존됨: ${summary['will_preserve']}'),
                ],
            ),
            actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: Text('취소')),
                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('삭제')),
            ],
        ),
    );

    if (confirmed == true) {
        // 2. 삭제 실행
        final result = await supabase.rpc('delete_employee', params: {
            'p_company_id': companyId,
            'p_employee_user_id': employeeId,
            'p_delete_salary': true,  // 급여 정보도 삭제
        });

        if (result['success']) {
            print('삭제 완료: ${result['affected']}');
        }
    }
} else {
    print('에러: ${validation['message']}');
}
```

---

## 안전성 체크리스트

```
✅ users 테이블 삭제하지 않음 (다른 회사 소속 가능)
✅ NOT NULL FK 컬럼 건드리지 않음 (에러 방지)
✅ created_by 참조 유지 (히스토리 보존)
✅ shift_requests 유지 (근무 기록 보존)
✅ journal_entries 유지 (회계 기록 보존)
✅ Soft Delete 사용 (복구 가능)
✅ Owner 권한 검증
✅ 자기 자신 삭제 차단
✅ 삭제 전 검증 함수 제공
✅ 영향받는 데이터 카운트 반환
```

---

## 이전 버전과의 차이점

| 항목 | 이전 버전 (위험) | 현재 버전 (안전) |
|------|------------------|------------------|
| created_by 처리 | NULL로 설정 시도 | 그대로 유지 |
| NOT NULL 컬럼 | 에러 발생 | 건드리지 않음 |
| shift_requests | 삭제 | 보존 |
| journal_entries | created_by = NULL | 보존 |
| 파라미터 | p_hard_delete | p_delete_salary |

---

## 주의사항

### 직원이 다른 회사에도 소속된 경우
- users 테이블은 삭제하지 않으므로 문제없음
- 해당 회사의 연결(user_companies)만 Soft Delete됨

### 삭제된 직원의 근무 기록 조회
- shift_requests는 유지되므로 히스토리 조회 가능
- users 테이블도 유지되므로 직원 이름 등 조회 가능

### 복구가 필요한 경우
- user_companies, user_stores, user_roles의 is_deleted = false로 변경
- user_salaries는 Hard Delete되므로 복구 불가 (p_delete_salary = false로 유지 가능)
