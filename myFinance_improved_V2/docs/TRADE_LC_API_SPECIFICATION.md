# L/C Trade Management System - API Specification (RPC 함수 명세서)

> **Version**: 1.0.0
> **Created**: 2025-12-26
> **Last Updated**: 2025-12-26
> **Related**: [SYSTEM_SPECIFICATION](./TRADE_LC_SYSTEM_SPECIFICATION.md) | [DATABASE_SCHEMA](./TRADE_LC_DATABASE_SCHEMA.md)

---

## 목차

1. [개요](#1-개요)
2. [공통 규칙](#2-공통-규칙)
3. [PI (Proforma Invoice) API](#3-pi-proforma-invoice-api)
4. [PO (Purchase Order) API](#4-po-purchase-order-api)
5. [L/C (Letter of Credit) API](#5-lc-letter-of-credit-api)
6. [Shipment API](#6-shipment-api)
7. [CI (Commercial Invoice) API](#7-ci-commercial-invoice-api)
8. [Document API](#8-document-api)
9. [Payment API](#9-payment-api)
10. [Master Data API](#10-master-data-api)
11. [Dashboard & Reports API](#11-dashboard--reports-api)
12. [Activity Log API](#12-activity-log-api)
13. [Alert API](#13-alert-api)
14. [Error Codes](#14-error-codes)

---

## 1. 개요

### 1.1 API 설계 원칙

| 원칙 | 설명 |
|------|------|
| **RPC 기반** | Supabase RPC 함수 사용 |
| **일관된 응답** | 모든 API는 동일한 응답 구조 |
| **낙관적 잠금** | version 필드로 동시성 제어 |
| **감사 추적** | 모든 변경사항 자동 로깅 |
| **RLS 적용** | Row Level Security로 데이터 접근 제어 |

### 1.2 API 명명 규칙

```
trade_{entity}_{action}

예시:
- trade_pi_create        (PI 생성)
- trade_pi_get           (PI 조회)
- trade_pi_update        (PI 수정)
- trade_pi_list          (PI 목록)
- trade_pi_convert_to_po (PI → PO 변환)
```

---

## 2. 공통 규칙

### 2.1 공통 응답 형식

```typescript
// 성공 응답
{
  "success": true,
  "data": { ... },      // 실제 데이터
  "message": "string"   // 선택적 메시지
}

// 실패 응답
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "에러 설명",
    "details": { ... }  // 선택적 상세 정보
  }
}
```

### 2.2 공통 파라미터

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `p_company_id` | UUID | 회사 ID (필수) |
| `p_user_id` | UUID | 사용자 ID (필수) |
| `p_store_id` | UUID | 매장 ID (선택) |

### 2.3 페이지네이션

```typescript
// 요청
{
  "p_page": 1,           // 페이지 번호 (1부터 시작)
  "p_page_size": 20,     // 페이지 크기 (기본 20, 최대 100)
  "p_sort_by": "created_at",
  "p_sort_order": "desc" // "asc" | "desc"
}

// 응답에 포함
{
  "pagination": {
    "page": 1,
    "page_size": 20,
    "total_count": 150,
    "total_pages": 8,
    "has_next": true,
    "has_prev": false
  }
}
```

### 2.4 필터링

```typescript
// 날짜 범위
{
  "p_date_from": "2025-01-01",
  "p_date_to": "2025-12-31"
}

// 상태 필터
{
  "p_status": ["DRAFT", "SENT"]  // 배열로 여러 상태
}

// 검색
{
  "p_search": "INV-2025"  // 번호, 이름 등 검색
}
```

---

## 3. PI (Proforma Invoice) API

### 3.1 trade_pi_create

**PI 생성**

```sql
CREATE OR REPLACE FUNCTION trade_pi_create(
  p_company_id UUID,
  p_user_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_counterparty_id UUID,
  p_incoterm_code TEXT,
  p_payment_term_code TEXT,
  p_currency TEXT DEFAULT 'USD',
  p_valid_until DATE,
  p_loading_port TEXT DEFAULT NULL,
  p_discharge_port TEXT DEFAULT NULL,
  p_final_destination TEXT DEFAULT NULL,
  p_remarks TEXT DEFAULT NULL,
  p_items JSONB  -- 아이템 배열
) RETURNS JSONB
```

**요청 예시:**
```json
{
  "p_company_id": "uuid",
  "p_user_id": "uuid",
  "p_counterparty_id": "uuid",
  "p_incoterm_code": "FOB",
  "p_payment_term_code": "AT_SIGHT",
  "p_currency": "USD",
  "p_valid_until": "2025-02-28",
  "p_loading_port": "Busan, Korea",
  "p_discharge_port": "Los Angeles, USA",
  "p_items": [
    {
      "product_id": "uuid",
      "product_name": "Widget A",
      "description": "High quality widget",
      "quantity": 1000,
      "unit": "PCS",
      "unit_price": 5.50,
      "hs_code": "8471.30",
      "origin_country": "KR"
    }
  ]
}
```

**응답:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "pi_number": "PI-2025-0001",
    "status": "DRAFT",
    "total_amount": 5500.00,
    "created_at": "2025-12-26T10:00:00Z"
  }
}
```

### 3.2 trade_pi_get

**PI 상세 조회**

```sql
CREATE OR REPLACE FUNCTION trade_pi_get(
  p_company_id UUID,
  p_pi_id UUID
) RETURNS JSONB
```

**응답에 포함되는 데이터:**
- PI 기본 정보
- PI 아이템 목록
- 거래처 정보
- 연결된 PO 정보 (있는 경우)
- 활동 로그

### 3.3 trade_pi_list

**PI 목록 조회**

```sql
CREATE OR REPLACE FUNCTION trade_pi_list(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_status TEXT[] DEFAULT NULL,
  p_counterparty_id UUID DEFAULT NULL,
  p_date_from DATE DEFAULT NULL,
  p_date_to DATE DEFAULT NULL,
  p_search TEXT DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 20
) RETURNS JSONB
```

### 3.4 trade_pi_update

**PI 수정**

```sql
CREATE OR REPLACE FUNCTION trade_pi_update(
  p_company_id UUID,
  p_user_id UUID,
  p_pi_id UUID,
  p_version INT,  -- 낙관적 잠금용
  p_updates JSONB
) RETURNS JSONB
```

**수정 가능한 상태:** `DRAFT`, `REVISED`

### 3.5 trade_pi_send

**PI 발송 (상태 변경: DRAFT → SENT)**

```sql
CREATE OR REPLACE FUNCTION trade_pi_send(
  p_company_id UUID,
  p_user_id UUID,
  p_pi_id UUID
) RETURNS JSONB
```

### 3.6 trade_pi_accept

**PI 승인 (상태 변경: SENT → ACCEPTED)**

```sql
CREATE OR REPLACE FUNCTION trade_pi_accept(
  p_company_id UUID,
  p_user_id UUID,
  p_pi_id UUID,
  p_accepted_at TIMESTAMPTZ DEFAULT NOW()
) RETURNS JSONB
```

### 3.7 trade_pi_convert_to_po

**PI → PO 변환**

```sql
CREATE OR REPLACE FUNCTION trade_pi_convert_to_po(
  p_company_id UUID,
  p_user_id UUID,
  p_pi_id UUID,
  p_po_options JSONB DEFAULT '{}'
) RETURNS JSONB
```

**응답:**
```json
{
  "success": true,
  "data": {
    "pi_id": "uuid",
    "pi_status": "CONVERTED",
    "po_id": "uuid",
    "po_number": "PO-2025-0001"
  }
}
```

### 3.8 trade_pi_cancel

**PI 취소**

```sql
CREATE OR REPLACE FUNCTION trade_pi_cancel(
  p_company_id UUID,
  p_user_id UUID,
  p_pi_id UUID,
  p_reason TEXT DEFAULT NULL
) RETURNS JSONB
```

### 3.9 trade_pi_duplicate

**PI 복제**

```sql
CREATE OR REPLACE FUNCTION trade_pi_duplicate(
  p_company_id UUID,
  p_user_id UUID,
  p_pi_id UUID
) RETURNS JSONB
```

---

## 4. PO (Purchase Order) API

### 4.1 trade_po_create

**PO 생성 (PI 없이 직접 생성)**

```sql
CREATE OR REPLACE FUNCTION trade_po_create(
  p_company_id UUID,
  p_user_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_counterparty_id UUID,
  p_pi_id UUID DEFAULT NULL,  -- 연결된 PI (선택)
  p_incoterm_code TEXT,
  p_payment_term_code TEXT,
  p_currency TEXT DEFAULT 'USD',
  p_loading_port TEXT,
  p_discharge_port TEXT,
  p_final_destination TEXT DEFAULT NULL,
  p_remarks TEXT DEFAULT NULL,
  p_items JSONB
) RETURNS JSONB
```

### 4.2 trade_po_get

**PO 상세 조회**

```sql
CREATE OR REPLACE FUNCTION trade_po_get(
  p_company_id UUID,
  p_po_id UUID
) RETURNS JSONB
```

**응답에 포함:**
- PO 기본 정보
- PO 아이템 목록
- 연결된 PI 정보
- 연결된 L/C 정보
- 연결된 Shipment 목록
- 진행 상황 (shipped_quantity / ordered_quantity)

### 4.3 trade_po_list

**PO 목록 조회**

```sql
CREATE OR REPLACE FUNCTION trade_po_list(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_status TEXT[] DEFAULT NULL,
  p_counterparty_id UUID DEFAULT NULL,
  p_has_lc BOOLEAN DEFAULT NULL,  -- L/C 유무 필터
  p_date_from DATE DEFAULT NULL,
  p_date_to DATE DEFAULT NULL,
  p_search TEXT DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 20
) RETURNS JSONB
```

### 4.4 trade_po_update

**PO 수정**

```sql
CREATE OR REPLACE FUNCTION trade_po_update(
  p_company_id UUID,
  p_user_id UUID,
  p_po_id UUID,
  p_version INT,
  p_updates JSONB
) RETURNS JSONB
```

**수정 가능한 상태:** `DRAFT`, `CONFIRMED`, `LC_PENDING`

### 4.5 trade_po_confirm

**PO 확정**

```sql
CREATE OR REPLACE FUNCTION trade_po_confirm(
  p_company_id UUID,
  p_user_id UUID,
  p_po_id UUID
) RETURNS JSONB
```

### 4.6 trade_po_update_status

**PO 상태 변경**

```sql
CREATE OR REPLACE FUNCTION trade_po_update_status(
  p_company_id UUID,
  p_user_id UUID,
  p_po_id UUID,
  p_new_status TEXT,
  p_notes TEXT DEFAULT NULL
) RETURNS JSONB
```

### 4.7 trade_po_get_shipment_summary

**PO별 선적 요약**

```sql
CREATE OR REPLACE FUNCTION trade_po_get_shipment_summary(
  p_company_id UUID,
  p_po_id UUID
) RETURNS JSONB
```

**응답:**
```json
{
  "success": true,
  "data": {
    "po_id": "uuid",
    "total_ordered": 1000,
    "total_shipped": 600,
    "total_remaining": 400,
    "shipments": [
      {
        "shipment_id": "uuid",
        "shipment_number": "SHP-2025-0001",
        "shipped_quantity": 600,
        "status": "DELIVERED"
      }
    ]
  }
}
```

---

## 5. L/C (Letter of Credit) API

### 5.1 trade_lc_create

**L/C 등록**

```sql
CREATE OR REPLACE FUNCTION trade_lc_create(
  p_company_id UUID,
  p_user_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_po_id UUID,
  p_lc_number TEXT,
  p_lc_type_code TEXT,
  p_issuing_bank TEXT,
  p_advising_bank TEXT DEFAULT NULL,
  p_confirming_bank TEXT DEFAULT NULL,
  p_amount DECIMAL,
  p_currency TEXT DEFAULT 'USD',
  p_tolerance_percent DECIMAL DEFAULT 0,
  p_issue_date DATE,
  p_expiry_date DATE,
  p_latest_shipment_date DATE,
  p_presentation_days INT DEFAULT 21,
  p_partial_shipment_allowed BOOLEAN DEFAULT true,
  p_transshipment_allowed BOOLEAN DEFAULT true,
  p_loading_port TEXT,
  p_discharge_port TEXT,
  p_required_documents JSONB,  -- 요구 서류 목록
  p_special_conditions JSONB DEFAULT NULL,
  p_remarks TEXT DEFAULT NULL
) RETURNS JSONB
```

**required_documents 예시:**
```json
[
  {"type": "BL", "copies": 3, "originals": 3},
  {"type": "CI", "copies": 3, "originals": 1},
  {"type": "PL", "copies": 3, "originals": 1},
  {"type": "COO", "copies": 2, "originals": 1},
  {"type": "INS", "copies": 2, "originals": 1}
]
```

### 5.2 trade_lc_get

**L/C 상세 조회**

```sql
CREATE OR REPLACE FUNCTION trade_lc_get(
  p_company_id UUID,
  p_lc_id UUID
) RETURNS JSONB
```

**응답에 포함:**
- L/C 기본 정보
- 연결된 PO 정보
- 조건변경(Amendment) 이력
- 연결된 Shipment 목록
- 연결된 CI 정보
- 서류 체크리스트
- 결제 정보
- 남은 기한 계산 (유효기간, 선적기한)

### 5.3 trade_lc_list

**L/C 목록 조회**

```sql
CREATE OR REPLACE FUNCTION trade_lc_list(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_status TEXT[] DEFAULT NULL,
  p_counterparty_id UUID DEFAULT NULL,
  p_expiring_within_days INT DEFAULT NULL,  -- N일 내 만료 예정
  p_date_from DATE DEFAULT NULL,
  p_date_to DATE DEFAULT NULL,
  p_search TEXT DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 20
) RETURNS JSONB
```

### 5.4 trade_lc_update

**L/C 수정**

```sql
CREATE OR REPLACE FUNCTION trade_lc_update(
  p_company_id UUID,
  p_user_id UUID,
  p_lc_id UUID,
  p_version INT,
  p_updates JSONB
) RETURNS JSONB
```

### 5.5 trade_lc_update_status

**L/C 상태 변경**

```sql
CREATE OR REPLACE FUNCTION trade_lc_update_status(
  p_company_id UUID,
  p_user_id UUID,
  p_lc_id UUID,
  p_new_status TEXT,
  p_notes TEXT DEFAULT NULL
) RETURNS JSONB
```

### 5.6 trade_lc_request_amendment

**L/C 조건변경 요청**

```sql
CREATE OR REPLACE FUNCTION trade_lc_request_amendment(
  p_company_id UUID,
  p_user_id UUID,
  p_lc_id UUID,
  p_amendment_type TEXT,  -- AMOUNT, DATE, TERMS, DOCUMENTS, OTHER
  p_original_value TEXT,
  p_requested_value TEXT,
  p_reason TEXT
) RETURNS JSONB
```

### 5.7 trade_lc_receive_amendment

**L/C 조건변경 수령**

```sql
CREATE OR REPLACE FUNCTION trade_lc_receive_amendment(
  p_company_id UUID,
  p_user_id UUID,
  p_amendment_id UUID,
  p_received_date DATE,
  p_accepted BOOLEAN,
  p_notes TEXT DEFAULT NULL
) RETURNS JSONB
```

### 5.8 trade_lc_check_validity

**L/C 유효성 검사**

```sql
CREATE OR REPLACE FUNCTION trade_lc_check_validity(
  p_company_id UUID,
  p_lc_id UUID
) RETURNS JSONB
```

**응답:**
```json
{
  "success": true,
  "data": {
    "is_valid": true,
    "warnings": [
      {
        "type": "EXPIRY_WARNING",
        "message": "L/C가 7일 후 만료됩니다",
        "days_remaining": 7
      }
    ],
    "errors": [],
    "document_checklist": {
      "total": 5,
      "uploaded": 3,
      "missing": ["COO", "INS"]
    }
  }
}
```

### 5.9 trade_lc_calculate_amounts

**L/C 금액 계산**

```sql
CREATE OR REPLACE FUNCTION trade_lc_calculate_amounts(
  p_company_id UUID,
  p_lc_id UUID
) RETURNS JSONB
```

**응답:**
```json
{
  "success": true,
  "data": {
    "lc_amount": 100000.00,
    "tolerance_percent": 5,
    "max_drawable": 105000.00,
    "min_drawable": 95000.00,
    "already_drawn": 50000.00,
    "remaining_drawable": 55000.00,
    "currency": "USD"
  }
}
```

---

## 6. Shipment API

### 6.1 trade_shipment_create

**선적 생성**

```sql
CREATE OR REPLACE FUNCTION trade_shipment_create(
  p_company_id UUID,
  p_user_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_po_id UUID,
  p_lc_id UUID DEFAULT NULL,
  p_shipping_method TEXT DEFAULT 'SEA',
  p_freight_term TEXT DEFAULT 'PREPAID',
  p_carrier_name TEXT DEFAULT NULL,
  p_vessel_name TEXT DEFAULT NULL,
  p_voyage_number TEXT DEFAULT NULL,
  p_container_number TEXT DEFAULT NULL,
  p_loading_port TEXT,
  p_discharge_port TEXT,
  p_etd DATE,  -- 출발 예정일
  p_eta DATE,  -- 도착 예정일
  p_remarks TEXT DEFAULT NULL,
  p_items JSONB  -- 선적 아이템
) RETURNS JSONB
```

**items 예시:**
```json
[
  {
    "po_item_id": "uuid",
    "shipped_quantity": 500,
    "package_count": 50,
    "gross_weight": 5000,
    "net_weight": 4500,
    "volume_cbm": 10.5
  }
]
```

### 6.2 trade_shipment_get

**선적 상세 조회**

```sql
CREATE OR REPLACE FUNCTION trade_shipment_get(
  p_company_id UUID,
  p_shipment_id UUID
) RETURNS JSONB
```

### 6.3 trade_shipment_list

**선적 목록 조회**

```sql
CREATE OR REPLACE FUNCTION trade_shipment_list(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_po_id UUID DEFAULT NULL,
  p_lc_id UUID DEFAULT NULL,
  p_status TEXT[] DEFAULT NULL,
  p_shipping_method TEXT DEFAULT NULL,
  p_date_from DATE DEFAULT NULL,
  p_date_to DATE DEFAULT NULL,
  p_search TEXT DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 20
) RETURNS JSONB
```

### 6.4 trade_shipment_update

**선적 수정**

```sql
CREATE OR REPLACE FUNCTION trade_shipment_update(
  p_company_id UUID,
  p_user_id UUID,
  p_shipment_id UUID,
  p_version INT,
  p_updates JSONB
) RETURNS JSONB
```

### 6.5 trade_shipment_update_status

**선적 상태 변경**

```sql
CREATE OR REPLACE FUNCTION trade_shipment_update_status(
  p_company_id UUID,
  p_user_id UUID,
  p_shipment_id UUID,
  p_new_status TEXT,
  p_actual_date TIMESTAMPTZ DEFAULT NULL,  -- ATD/ATA
  p_notes TEXT DEFAULT NULL
) RETURNS JSONB
```

### 6.6 trade_shipment_update_tracking

**선적 추적 정보 업데이트**

```sql
CREATE OR REPLACE FUNCTION trade_shipment_update_tracking(
  p_company_id UUID,
  p_user_id UUID,
  p_shipment_id UUID,
  p_bl_number TEXT DEFAULT NULL,
  p_atd TIMESTAMPTZ DEFAULT NULL,  -- 실제 출발일
  p_ata TIMESTAMPTZ DEFAULT NULL   -- 실제 도착일
) RETURNS JSONB
```

---

## 7. CI (Commercial Invoice) API

### 7.1 trade_ci_create

**Commercial Invoice 생성**

```sql
CREATE OR REPLACE FUNCTION trade_ci_create(
  p_company_id UUID,
  p_user_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_lc_id UUID,
  p_shipment_id UUID,
  p_invoice_date DATE DEFAULT CURRENT_DATE,
  p_remarks TEXT DEFAULT NULL,
  p_items JSONB DEFAULT NULL  -- NULL이면 shipment items에서 자동 복사
) RETURNS JSONB
```

### 7.2 trade_ci_get

**CI 상세 조회**

```sql
CREATE OR REPLACE FUNCTION trade_ci_get(
  p_company_id UUID,
  p_ci_id UUID
) RETURNS JSONB
```

### 7.3 trade_ci_list

**CI 목록 조회**

```sql
CREATE OR REPLACE FUNCTION trade_ci_list(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_lc_id UUID DEFAULT NULL,
  p_status TEXT[] DEFAULT NULL,
  p_date_from DATE DEFAULT NULL,
  p_date_to DATE DEFAULT NULL,
  p_search TEXT DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 20
) RETURNS JSONB
```

### 7.4 trade_ci_update

**CI 수정**

```sql
CREATE OR REPLACE FUNCTION trade_ci_update(
  p_company_id UUID,
  p_user_id UUID,
  p_ci_id UUID,
  p_version INT,
  p_updates JSONB
) RETURNS JSONB
```

### 7.5 trade_ci_finalize

**CI 확정**

```sql
CREATE OR REPLACE FUNCTION trade_ci_finalize(
  p_company_id UUID,
  p_user_id UUID,
  p_ci_id UUID
) RETURNS JSONB
```

### 7.6 trade_ci_submit

**CI 제출 (은행)**

```sql
CREATE OR REPLACE FUNCTION trade_ci_submit(
  p_company_id UUID,
  p_user_id UUID,
  p_ci_id UUID,
  p_submitted_at TIMESTAMPTZ DEFAULT NOW()
) RETURNS JSONB
```

### 7.7 trade_ci_validate_against_lc

**CI ↔ L/C 일치 검증**

```sql
CREATE OR REPLACE FUNCTION trade_ci_validate_against_lc(
  p_company_id UUID,
  p_ci_id UUID
) RETURNS JSONB
```

**응답:**
```json
{
  "success": true,
  "data": {
    "is_valid": false,
    "discrepancies": [
      {
        "field": "amount",
        "lc_value": "100000.00",
        "ci_value": "105500.00",
        "issue": "CI 금액이 L/C 허용 범위 초과 (Tolerance: 5%)"
      },
      {
        "field": "goods_description",
        "lc_value": "Widget Type A",
        "ci_value": "Widget Type-A",
        "issue": "상품 설명 불일치 (하이픈)"
      }
    ],
    "warnings": [
      {
        "field": "shipment_date",
        "message": "선적일이 L/C 기한 2일 전입니다"
      }
    ]
  }
}
```

---

## 8. Document API

### 8.1 trade_document_upload

**서류 업로드**

```sql
CREATE OR REPLACE FUNCTION trade_document_upload(
  p_company_id UUID,
  p_user_id UUID,
  p_entity_type TEXT,  -- PI, PO, LC, SHIPMENT, CI
  p_entity_id UUID,
  p_document_type_code TEXT,  -- BL, CI, PL, COO, INS, etc.
  p_file_name TEXT,
  p_file_path TEXT,  -- Storage path
  p_file_size INT,
  p_mime_type TEXT,
  p_is_original BOOLEAN DEFAULT false,
  p_copy_number INT DEFAULT 1,
  p_remarks TEXT DEFAULT NULL
) RETURNS JSONB
```

### 8.2 trade_document_get

**서류 조회**

```sql
CREATE OR REPLACE FUNCTION trade_document_get(
  p_company_id UUID,
  p_document_id UUID
) RETURNS JSONB
```

### 8.3 trade_document_list

**서류 목록 조회**

```sql
CREATE OR REPLACE FUNCTION trade_document_list(
  p_company_id UUID,
  p_entity_type TEXT DEFAULT NULL,
  p_entity_id UUID DEFAULT NULL,
  p_document_type_code TEXT DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 50
) RETURNS JSONB
```

### 8.4 trade_document_delete

**서류 삭제**

```sql
CREATE OR REPLACE FUNCTION trade_document_delete(
  p_company_id UUID,
  p_user_id UUID,
  p_document_id UUID,
  p_reason TEXT DEFAULT NULL
) RETURNS JSONB
```

### 8.5 trade_document_get_checklist

**L/C 서류 체크리스트**

```sql
CREATE OR REPLACE FUNCTION trade_document_get_checklist(
  p_company_id UUID,
  p_lc_id UUID
) RETURNS JSONB
```

**응답:**
```json
{
  "success": true,
  "data": {
    "lc_id": "uuid",
    "required_documents": [
      {
        "type": "BL",
        "type_name": "Bill of Lading",
        "required_originals": 3,
        "required_copies": 3,
        "uploaded_originals": 3,
        "uploaded_copies": 2,
        "status": "PARTIAL",
        "documents": [...]
      },
      {
        "type": "COO",
        "type_name": "Certificate of Origin",
        "required_originals": 1,
        "required_copies": 2,
        "uploaded_originals": 0,
        "uploaded_copies": 0,
        "status": "MISSING",
        "documents": []
      }
    ],
    "summary": {
      "total_required": 5,
      "complete": 2,
      "partial": 2,
      "missing": 1
    }
  }
}
```

---

## 9. Payment API

### 9.1 trade_payment_record

**결제 기록**

```sql
CREATE OR REPLACE FUNCTION trade_payment_record(
  p_company_id UUID,
  p_user_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_lc_id UUID,
  p_ci_id UUID DEFAULT NULL,
  p_payment_date DATE,
  p_amount DECIMAL,
  p_currency TEXT DEFAULT 'USD',
  p_exchange_rate DECIMAL DEFAULT 1,
  p_payment_method TEXT DEFAULT 'BANK_TRANSFER',
  p_bank_reference TEXT DEFAULT NULL,
  p_remarks TEXT DEFAULT NULL
) RETURNS JSONB
```

### 9.2 trade_payment_get

**결제 상세 조회**

```sql
CREATE OR REPLACE FUNCTION trade_payment_get(
  p_company_id UUID,
  p_payment_id UUID
) RETURNS JSONB
```

### 9.3 trade_payment_list

**결제 목록 조회**

```sql
CREATE OR REPLACE FUNCTION trade_payment_list(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_lc_id UUID DEFAULT NULL,
  p_status TEXT[] DEFAULT NULL,
  p_date_from DATE DEFAULT NULL,
  p_date_to DATE DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 20
) RETURNS JSONB
```

### 9.4 trade_payment_summary_by_lc

**L/C별 결제 요약**

```sql
CREATE OR REPLACE FUNCTION trade_payment_summary_by_lc(
  p_company_id UUID,
  p_lc_id UUID
) RETURNS JSONB
```

**응답:**
```json
{
  "success": true,
  "data": {
    "lc_id": "uuid",
    "lc_amount": 100000.00,
    "currency": "USD",
    "total_paid": 75000.00,
    "total_remaining": 25000.00,
    "payment_status": "PARTIAL",
    "payments": [
      {
        "id": "uuid",
        "date": "2025-01-15",
        "amount": 50000.00,
        "status": "COMPLETED"
      },
      {
        "id": "uuid",
        "date": "2025-02-15",
        "amount": 25000.00,
        "status": "COMPLETED"
      }
    ],
    "expected_payments": [
      {
        "due_date": "2025-03-15",
        "amount": 25000.00,
        "type": "USANCE_60"
      }
    ]
  }
}
```

---

## 10. Master Data API

### 10.1 trade_master_get_incoterms

**Incoterms 목록**

```sql
CREATE OR REPLACE FUNCTION trade_master_get_incoterms()
RETURNS JSONB
```

### 10.2 trade_master_get_payment_terms

**Payment Terms 목록**

```sql
CREATE OR REPLACE FUNCTION trade_master_get_payment_terms()
RETURNS JSONB
```

### 10.3 trade_master_get_lc_types

**L/C Types 목록**

```sql
CREATE OR REPLACE FUNCTION trade_master_get_lc_types()
RETURNS JSONB
```

### 10.4 trade_master_get_document_types

**Document Types 목록**

```sql
CREATE OR REPLACE FUNCTION trade_master_get_document_types()
RETURNS JSONB
```

### 10.5 trade_master_get_freight_terms

**Freight Terms 목록**

```sql
CREATE OR REPLACE FUNCTION trade_master_get_freight_terms()
RETURNS JSONB
```

### 10.6 trade_master_get_shipping_methods

**Shipping Methods 목록**

```sql
CREATE OR REPLACE FUNCTION trade_master_get_shipping_methods()
RETURNS JSONB
```

### 10.7 trade_master_get_status_definitions

**Status 정의 목록**

```sql
CREATE OR REPLACE FUNCTION trade_master_get_status_definitions(
  p_entity_type TEXT DEFAULT NULL  -- PI, PO, LC, SHIPMENT, CI, PAYMENT
) RETURNS JSONB
```

### 10.8 trade_master_get_all

**모든 마스터 데이터**

```sql
CREATE OR REPLACE FUNCTION trade_master_get_all()
RETURNS JSONB
```

**응답:**
```json
{
  "success": true,
  "data": {
    "incoterms": [...],
    "payment_terms": [...],
    "lc_types": [...],
    "document_types": [...],
    "freight_terms": [...],
    "shipping_methods": [...],
    "status_definitions": {...}
  }
}
```

---

## 11. Dashboard & Reports API

### 11.1 trade_dashboard_summary

**대시보드 요약**

```sql
CREATE OR REPLACE FUNCTION trade_dashboard_summary(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_date_from DATE DEFAULT NULL,
  p_date_to DATE DEFAULT NULL
) RETURNS JSONB
```

**응답:**
```json
{
  "success": true,
  "data": {
    "overview": {
      "active_pos": 15,
      "active_lcs": 8,
      "pending_shipments": 5,
      "pending_payments": 3,
      "total_lc_value": 500000.00,
      "total_received": 350000.00
    },
    "by_status": {
      "pi": {"DRAFT": 2, "SENT": 5, "ACCEPTED": 3},
      "po": {"CONFIRMED": 5, "LC_RECEIVED": 8, "SHIPPED": 2},
      "lc": {"ACCEPTED": 3, "DOCS_IN_PREPARATION": 2, "PAYMENT_PENDING": 3}
    },
    "alerts": {
      "expiring_lcs": 2,
      "overdue_shipments": 1,
      "pending_documents": 3
    },
    "recent_activities": [...]
  }
}
```

### 11.2 trade_dashboard_timeline

**거래 타임라인**

```sql
CREATE OR REPLACE FUNCTION trade_dashboard_timeline(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_entity_type TEXT DEFAULT NULL,  -- PI, PO, LC
  p_entity_id UUID DEFAULT NULL,
  p_limit INT DEFAULT 20
) RETURNS JSONB
```

### 11.3 trade_report_by_counterparty

**거래처별 리포트**

```sql
CREATE OR REPLACE FUNCTION trade_report_by_counterparty(
  p_company_id UUID,
  p_date_from DATE,
  p_date_to DATE
) RETURNS JSONB
```

### 11.4 trade_report_by_period

**기간별 리포트**

```sql
CREATE OR REPLACE FUNCTION trade_report_by_period(
  p_company_id UUID,
  p_period_type TEXT,  -- DAILY, WEEKLY, MONTHLY, QUARTERLY, YEARLY
  p_date_from DATE,
  p_date_to DATE
) RETURNS JSONB
```

### 11.5 trade_report_payment_schedule

**결제 일정 리포트**

```sql
CREATE OR REPLACE FUNCTION trade_report_payment_schedule(
  p_company_id UUID,
  p_date_from DATE DEFAULT CURRENT_DATE,
  p_date_to DATE DEFAULT (CURRENT_DATE + INTERVAL '90 days')
) RETURNS JSONB
```

**응답:**
```json
{
  "success": true,
  "data": {
    "schedule": [
      {
        "date": "2025-01-15",
        "lc_id": "uuid",
        "lc_number": "LC-2025-001",
        "amount": 50000.00,
        "currency": "USD",
        "type": "AT_SIGHT"
      },
      {
        "date": "2025-02-15",
        "lc_id": "uuid",
        "lc_number": "LC-2025-002",
        "amount": 30000.00,
        "currency": "USD",
        "type": "USANCE_60"
      }
    ],
    "summary": {
      "total_expected": 250000.00,
      "by_month": {
        "2025-01": 80000.00,
        "2025-02": 100000.00,
        "2025-03": 70000.00
      }
    }
  }
}
```

---

## 12. Activity Log API

### 12.1 trade_activity_log_list

**활동 로그 조회**

```sql
CREATE OR REPLACE FUNCTION trade_activity_log_list(
  p_company_id UUID,
  p_entity_type TEXT DEFAULT NULL,
  p_entity_id UUID DEFAULT NULL,
  p_action_type TEXT DEFAULT NULL,
  p_user_id UUID DEFAULT NULL,
  p_date_from TIMESTAMPTZ DEFAULT NULL,
  p_date_to TIMESTAMPTZ DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 50
) RETURNS JSONB
```

### 12.2 trade_status_history_list

**상태 변경 이력**

```sql
CREATE OR REPLACE FUNCTION trade_status_history_list(
  p_company_id UUID,
  p_entity_type TEXT,
  p_entity_id UUID
) RETURNS JSONB
```

### 12.3 trade_discrepancy_log_list

**불일치 로그 조회**

```sql
CREATE OR REPLACE FUNCTION trade_discrepancy_log_list(
  p_company_id UUID,
  p_lc_id UUID DEFAULT NULL,
  p_ci_id UUID DEFAULT NULL,
  p_resolved BOOLEAN DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 20
) RETURNS JSONB
```

### 12.4 trade_discrepancy_resolve

**불일치 해결 처리**

```sql
CREATE OR REPLACE FUNCTION trade_discrepancy_resolve(
  p_company_id UUID,
  p_user_id UUID,
  p_discrepancy_id UUID,
  p_resolution_type TEXT,  -- CORRECTED, WAIVER_GRANTED, REJECTED
  p_resolution_notes TEXT
) RETURNS JSONB
```

---

## 13. Alert API

### 13.1 trade_alert_list

**알림 목록**

```sql
CREATE OR REPLACE FUNCTION trade_alert_list(
  p_company_id UUID,
  p_user_id UUID DEFAULT NULL,
  p_alert_type TEXT DEFAULT NULL,
  p_priority TEXT DEFAULT NULL,
  p_is_read BOOLEAN DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 20
) RETURNS JSONB
```

### 13.2 trade_alert_mark_read

**알림 읽음 처리**

```sql
CREATE OR REPLACE FUNCTION trade_alert_mark_read(
  p_company_id UUID,
  p_alert_id UUID
) RETURNS JSONB
```

### 13.3 trade_alert_mark_all_read

**모든 알림 읽음 처리**

```sql
CREATE OR REPLACE FUNCTION trade_alert_mark_all_read(
  p_company_id UUID,
  p_user_id UUID
) RETURNS JSONB
```

### 13.4 trade_alert_dismiss

**알림 해제**

```sql
CREATE OR REPLACE FUNCTION trade_alert_dismiss(
  p_company_id UUID,
  p_alert_id UUID
) RETURNS JSONB
```

### 13.5 trade_alert_generate_daily

**일일 알림 생성 (스케줄러용)**

```sql
CREATE OR REPLACE FUNCTION trade_alert_generate_daily(
  p_company_id UUID DEFAULT NULL  -- NULL이면 모든 회사
) RETURNS JSONB
```

---

## 14. Error Codes

### 14.1 공통 에러

| 코드 | 설명 |
|------|------|
| `AUTH_REQUIRED` | 인증 필요 |
| `PERMISSION_DENIED` | 권한 없음 |
| `NOT_FOUND` | 리소스 없음 |
| `VALIDATION_ERROR` | 입력값 오류 |
| `CONFLICT` | 충돌 (동시 수정 등) |
| `VERSION_MISMATCH` | 버전 불일치 (낙관적 잠금) |

### 14.2 PI 에러

| 코드 | 설명 |
|------|------|
| `PI_NOT_FOUND` | PI를 찾을 수 없음 |
| `PI_ALREADY_CONVERTED` | 이미 PO로 변환됨 |
| `PI_EXPIRED` | PI 유효기간 만료 |
| `PI_INVALID_STATUS` | 해당 상태에서 불가능한 작업 |

### 14.3 PO 에러

| 코드 | 설명 |
|------|------|
| `PO_NOT_FOUND` | PO를 찾을 수 없음 |
| `PO_ALREADY_SHIPPED` | 이미 선적됨 |
| `PO_INVALID_STATUS` | 해당 상태에서 불가능한 작업 |

### 14.4 L/C 에러

| 코드 | 설명 |
|------|------|
| `LC_NOT_FOUND` | L/C를 찾을 수 없음 |
| `LC_EXPIRED` | L/C 유효기간 만료 |
| `LC_AMOUNT_EXCEEDED` | L/C 금액 초과 |
| `LC_SHIPMENT_DATE_EXCEEDED` | 선적기일 초과 |
| `LC_INVALID_STATUS` | 해당 상태에서 불가능한 작업 |
| `LC_DOCUMENTS_INCOMPLETE` | 서류 미완성 |

### 14.5 Shipment 에러

| 코드 | 설명 |
|------|------|
| `SHIPMENT_NOT_FOUND` | 선적을 찾을 수 없음 |
| `SHIPMENT_QUANTITY_EXCEEDED` | PO 수량 초과 |
| `SHIPMENT_PARTIAL_NOT_ALLOWED` | 분할선적 불가 |
| `SHIPMENT_INVALID_STATUS` | 해당 상태에서 불가능한 작업 |

### 14.6 CI 에러

| 코드 | 설명 |
|------|------|
| `CI_NOT_FOUND` | CI를 찾을 수 없음 |
| `CI_DISCREPANCY` | L/C 조건 불일치 |
| `CI_INVALID_STATUS` | 해당 상태에서 불가능한 작업 |

### 14.7 Document 에러

| 코드 | 설명 |
|------|------|
| `DOCUMENT_NOT_FOUND` | 서류를 찾을 수 없음 |
| `DOCUMENT_TYPE_INVALID` | 잘못된 서류 유형 |
| `DOCUMENT_UPLOAD_FAILED` | 업로드 실패 |

### 14.8 Payment 에러

| 코드 | 설명 |
|------|------|
| `PAYMENT_NOT_FOUND` | 결제를 찾을 수 없음 |
| `PAYMENT_AMOUNT_EXCEEDED` | 결제 금액 초과 |
| `PAYMENT_ALREADY_COMPLETED` | 이미 완료된 결제 |

---

## 변경 이력

| 버전 | 날짜 | 변경 내용 | 작성자 |
|------|------|----------|--------|
| 1.0.0 | 2025-12-26 | 최초 작성 | System Architect |

---

> **관련 문서**:
> - [SYSTEM_SPECIFICATION](./TRADE_LC_SYSTEM_SPECIFICATION.md) - 전체 개요
> - [DATABASE_SCHEMA](./TRADE_LC_DATABASE_SCHEMA.md) - 데이터베이스 스키마
> - [WORKFLOW](./TRADE_LC_WORKFLOW.md) - 워크플로우 상세
> - [TERMS_REFERENCE](./TRADE_LC_TERMS_REFERENCE.md) - 용어 정의
