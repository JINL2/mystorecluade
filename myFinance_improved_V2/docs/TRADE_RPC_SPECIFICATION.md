# Trade RPC Specification

> **Project:** myFinance Trade L/C Management
> **Created:** 2025-12-26
> **Version:** 1.0.0

---

## Overview

이 문서는 Trade L/C 관리 시스템의 RPC 함수 스펙과 Flutter 클라이언트에서 예상하는 응답 구조를 정의합니다.

---

## Table of Contents

1. [Dashboard RPCs](#1-dashboard-rpcs)
2. [Alert RPCs](#2-alert-rpcs)
3. [Master Data RPCs](#3-master-data-rpcs)
4. [PI RPCs](#4-pi-rpcs)
5. [PO RPCs](#5-po-rpcs)
6. [L/C RPCs](#6-lc-rpcs)
7. [Shipment RPCs](#7-shipment-rpcs)
8. [Commercial Invoice RPCs](#8-commercial-invoice-rpcs)
9. [Payment RPCs](#9-payment-rpcs)
10. [Document RPCs](#10-document-rpcs)

---

## 1. Dashboard RPCs

### 1.1 trade_dashboard_summary

Dashboard 전체 요약 데이터 조회

**Parameters:**
```sql
p_company_id   UUID      -- Required: 회사 ID
p_store_id     UUID      -- Optional: 매장 ID (NULL이면 전체)
p_date_from    DATE      -- Optional: 시작일
p_date_to      DATE      -- Optional: 종료일
```

**Expected Response (Flutter Client):**
```json
{
  "success": true,
  "data": {
    "overview": {
      "total_pi_count": 10,
      "total_po_count": 8,
      "total_lc_count": 5,
      "total_shipment_count": 3,
      "total_ci_count": 2,
      "active_pos": 5,
      "active_lcs": 3,
      "pending_shipments": 2,
      "in_transit_count": 1,
      "pending_payments": 2,
      "total_trade_volume": 500000.00,
      "total_lc_value": 300000.00,
      "total_received": 100000.00,
      "pending_payment_amount": 200000.00,
      "currency": "USD"
    },
    "by_status": {
      "pi": { "DRAFT": 2, "SENT": 3, "ACCEPTED": 5 },
      "po": { "PENDING": 2, "CONFIRMED": 3, "COMPLETED": 3 },
      "lc": { "ISSUED": 2, "ACCEPTED": 2, "CLOSED": 1 },
      "shipment": { "PREPARING": 1, "IN_TRANSIT": 1, "DELIVERED": 1 }
    },
    "alerts": {
      "expiring_lcs": 2,
      "overdue_shipments": 1,
      "pending_documents": 3,
      "discrepancies": 0,
      "payments_due": 2
    },
    "recent_activities": [
      {
        "id": "uuid-string",
        "entity_type": "LC",
        "entity_id": "uuid-string",
        "entity_number": "LC-2025-001",
        "action": "status_changed",
        "action_detail": "Status changed to ACCEPTED",
        "previous_status": "ISSUED",
        "new_status": "ACCEPTED",
        "user_id": "uuid-string",
        "user_name": "John Doe",
        "created_at": "2025-12-26T10:30:00Z"
      }
    ]
  }
}
```

**Current Issue (Bug to Fix):**
```sql
-- 현재 RPC에서 잘못된 컬럼명 사용
-- expiry_date → expiry_date_utc
-- lc.id → lc.lc_id
```

**Fixed SQL:**
```sql
CREATE OR REPLACE FUNCTION public.trade_dashboard_summary(
  p_company_id uuid,
  p_store_id uuid DEFAULT NULL,
  p_date_from date DEFAULT NULL,
  p_date_to date DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_overview JSONB;
  v_by_status JSONB;
  v_alerts JSONB;
  v_recent_activities JSONB;
BEGIN
  -- Overview stats
  SELECT jsonb_build_object(
    'total_pi_count', (SELECT COUNT(*) FROM trade_proforma_invoices WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)),
    'total_po_count', (SELECT COUNT(*) FROM trade_purchase_orders WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)),
    'total_lc_count', (SELECT COUNT(*) FROM trade_letters_of_credit WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)),
    'total_shipment_count', (SELECT COUNT(*) FROM trade_shipments WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)),
    'total_ci_count', (SELECT COUNT(*) FROM trade_commercial_invoices WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)),
    'active_pos', (SELECT COUNT(*) FROM trade_purchase_orders WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status NOT IN ('COMPLETED', 'CANCELLED')),
    'active_lcs', (SELECT COUNT(*) FROM trade_letters_of_credit WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status NOT IN ('CLOSED', 'CANCELLED', 'EXPIRED')),
    'pending_shipments', (SELECT COUNT(*) FROM trade_shipments WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status IN ('PREPARING', 'BOOKED')),
    'in_transit_count', (SELECT COUNT(*) FROM trade_shipments WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status = 'IN_TRANSIT'),
    'pending_payments', (SELECT COUNT(*) FROM trade_payments WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status = 'PENDING'),
    'total_trade_volume', (SELECT COALESCE(SUM(amount), 0) FROM trade_letters_of_credit WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)),
    'total_lc_value', (SELECT COALESCE(SUM(amount), 0) FROM trade_letters_of_credit WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status NOT IN ('CLOSED', 'CANCELLED', 'EXPIRED')),
    'total_received', (SELECT COALESCE(SUM(amount), 0) FROM trade_payments WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status = 'COMPLETED'),
    'pending_payment_amount', (SELECT COALESCE(SUM(amount), 0) FROM trade_payments WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id) AND status = 'PENDING'),
    'currency', 'USD'
  ) INTO v_overview;

  -- By status
  SELECT jsonb_build_object(
    'pi', COALESCE((
      SELECT jsonb_object_agg(status, cnt) FROM (
        SELECT status, COUNT(*) as cnt FROM trade_proforma_invoices
        WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)
        GROUP BY status
      ) sub
    ), '{}'::jsonb),
    'po', COALESCE((
      SELECT jsonb_object_agg(status, cnt) FROM (
        SELECT status, COUNT(*) as cnt FROM trade_purchase_orders
        WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)
        GROUP BY status
      ) sub
    ), '{}'::jsonb),
    'lc', COALESCE((
      SELECT jsonb_object_agg(status, cnt) FROM (
        SELECT status, COUNT(*) as cnt FROM trade_letters_of_credit
        WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)
        GROUP BY status
      ) sub
    ), '{}'::jsonb),
    'shipment', COALESCE((
      SELECT jsonb_object_agg(status, cnt) FROM (
        SELECT status, COUNT(*) as cnt FROM trade_shipments
        WHERE company_id = p_company_id AND (p_store_id IS NULL OR store_id = p_store_id)
        GROUP BY status
      ) sub
    ), '{}'::jsonb)
  ) INTO v_by_status;

  -- Alerts (FIXED: expiry_date_utc, lc_id)
  SELECT jsonb_build_object(
    'expiring_lcs', (
      SELECT COUNT(*) FROM trade_letters_of_credit
      WHERE company_id = p_company_id
      AND (p_store_id IS NULL OR store_id = p_store_id)
      AND expiry_date_utc::date - CURRENT_DATE <= 14
      AND status NOT IN ('CLOSED', 'CANCELLED', 'EXPIRED')
    ),
    'overdue_shipments', (
      SELECT COUNT(*) FROM trade_shipments
      WHERE company_id = p_company_id
      AND (p_store_id IS NULL OR store_id = p_store_id)
      AND etd < CURRENT_DATE
      AND status = 'PREPARING'
    ),
    'pending_documents', (
      SELECT COUNT(DISTINCT lc.lc_id) FROM trade_letters_of_credit lc
      WHERE lc.company_id = p_company_id
      AND (p_store_id IS NULL OR lc.store_id = p_store_id)
      AND lc.status IN ('ACCEPTED', 'DOCS_IN_PREPARATION')
    ),
    'discrepancies', (
      SELECT COUNT(*) FROM trade_discrepancy_logs
      WHERE company_id = p_company_id
      AND status = 'OPEN'
    ),
    'payments_due', (
      SELECT COUNT(*) FROM trade_payments
      WHERE company_id = p_company_id
      AND (p_store_id IS NULL OR store_id = p_store_id)
      AND status = 'PENDING'
      AND due_date <= CURRENT_DATE + INTERVAL '7 days'
    )
  ) INTO v_alerts;

  -- Recent activities
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'id', log_id::text,
      'entity_type', entity_type,
      'entity_id', entity_id::text,
      'entity_number', entity_number,
      'action', action_type,
      'action_detail', action_description,
      'previous_status', previous_status,
      'new_status', new_status,
      'user_id', performed_by::text,
      'user_name', NULL,
      'created_at', performed_at
    ) ORDER BY performed_at DESC
  ), '[]'::jsonb)
  INTO v_recent_activities
  FROM (
    SELECT log_id, entity_type, entity_id, entity_number, action_type, action_description,
           previous_status, new_status, performed_by, performed_at
    FROM trade_activity_logs
    WHERE company_id = p_company_id
    ORDER BY performed_at DESC
    LIMIT 10
  ) sub;

  RETURN jsonb_build_object(
    'success', true,
    'data', jsonb_build_object(
      'overview', v_overview,
      'by_status', v_by_status,
      'alerts', v_alerts,
      'recent_activities', v_recent_activities
    )
  );
END;
$function$;
```

---

### 1.2 trade_dashboard_timeline

활동 타임라인 조회

**Parameters:**
```sql
p_company_id   UUID      -- Required
p_store_id     UUID      -- Optional
p_entity_type  TEXT      -- Optional: 'PI', 'PO', 'LC', 'SHIPMENT', 'CI'
p_entity_id    UUID      -- Optional: 특정 entity의 활동만
p_limit        INT       -- Default: 20
```

**Expected Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid-string",
      "entity_type": "LC",
      "entity_id": "uuid-string",
      "entity_number": "LC-2025-001",
      "action": "created",
      "action_detail": "Letter of Credit created",
      "previous_status": null,
      "new_status": "DRAFT",
      "user_id": "uuid-string",
      "user_name": "John Doe",
      "created_at": "2025-12-26T10:30:00Z"
    }
  ]
}
```

---

## 2. Alert RPCs

### 2.1 trade_alert_list

알림 목록 조회 (페이지네이션)

**Parameters:**
```sql
p_company_id   UUID      -- Required
p_user_id      UUID      -- Optional: 특정 사용자에게 할당된 알림
p_alert_type   TEXT      -- Optional: 알림 유형 필터
p_priority     TEXT      -- Optional: 'low', 'medium', 'high', 'urgent'
p_is_read      BOOLEAN   -- Optional: 읽음/안읽음 필터
p_page         INT       -- Default: 1
p_page_size    INT       -- Default: 20
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "alerts": [
      {
        "id": "uuid-string",
        "company_id": "uuid-string",
        "entity_type": "LC",
        "entity_id": "uuid-string",
        "entity_number": "LC-2025-001",
        "alert_type": "lc_expiry_warning",
        "title": "L/C Expiring Soon",
        "message": "LC-2025-001 expires in 7 days",
        "action_url": "/trade/lc/uuid-string",
        "due_date": "2025-01-02T00:00:00Z",
        "days_before_due": 7,
        "priority": "high",
        "is_read": false,
        "is_dismissed": false,
        "is_resolved": false,
        "is_system_generated": true,
        "assigned_to": null,
        "created_at": "2025-12-26T10:00:00Z",
        "read_at": null,
        "dismissed_at": null,
        "resolved_at": null
      }
    ],
    "pagination": {
      "current_page": 1,
      "page_size": 20,
      "total_count": 45,
      "total_pages": 3
    },
    "unread_count": 12
  }
}
```

**Alert Types:**
| Code | Description |
|------|-------------|
| `lc_expiry_warning` | L/C 만료 경고 (14일 전) |
| `lc_expired` | L/C 만료됨 |
| `shipment_deadline_warning` | 선적 마감일 경고 (7일 전) |
| `shipment_deadline_passed` | 선적 마감일 초과 |
| `presentation_deadline_warning` | 서류 제출 마감 경고 |
| `presentation_deadline_passed` | 서류 제출 마감 초과 |
| `payment_due_warning` | 결제 예정 경고 |
| `payment_due` | 결제일 도래 |
| `payment_received` | 결제 완료 |
| `document_missing` | 서류 누락 |
| `document_expiring` | 서류 만료 임박 |
| `discrepancy_found` | Discrepancy 발견 |
| `discrepancy_resolved` | Discrepancy 해결 |
| `status_changed` | 상태 변경 |
| `amendment_received` | Amendment 수신 |
| `action_required` | 조치 필요 |

---

### 2.2 trade_alert_mark_read

알림 읽음 처리

**Parameters:**
```sql
p_company_id   UUID      -- Required
p_alert_id     UUID      -- Required
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "alert_id": "uuid-string",
    "read_at": "2025-12-26T10:30:00Z"
  }
}
```

---

### 2.3 trade_alert_mark_all_read

모든 알림 읽음 처리

**Parameters:**
```sql
p_company_id   UUID      -- Required
p_user_id      UUID      -- Required
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "updated_count": 12
  }
}
```

---

### 2.4 trade_alert_dismiss

알림 해제 (삭제가 아닌 숨김)

**Parameters:**
```sql
p_company_id   UUID      -- Required
p_alert_id     UUID      -- Required
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "alert_id": "uuid-string",
    "dismissed_at": "2025-12-26T10:30:00Z"
  }
}
```

---

## 3. Master Data RPCs

### 3.1 trade_master_get_all

모든 마스터 데이터 조회 (앱 초기화용)

**Parameters:** None

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "incoterms": [
      {
        "code": "FOB",
        "name": "Free on Board",
        "description": "위험과 비용이 선적항에서 본선 난간을 통과할 때 이전",
        "category": "SEA",
        "is_active": true,
        "display_order": 1
      }
    ],
    "payment_terms": [
      {
        "code": "AT_SIGHT",
        "name": "At Sight",
        "description": "일람불",
        "days": 0,
        "is_usance": false,
        "is_active": true,
        "display_order": 1
      }
    ],
    "lc_types": [
      {
        "code": "IRREVOCABLE",
        "name": "Irrevocable L/C",
        "description": "취소불능 신용장",
        "is_active": true,
        "display_order": 1
      }
    ],
    "document_types": [
      {
        "code": "BL",
        "name": "Bill of Lading",
        "description": "선하증권",
        "category": "SHIPPING",
        "is_required_for_lc": true,
        "is_active": true,
        "display_order": 1
      }
    ],
    "shipping_methods": [
      {
        "code": "SEA",
        "name": "Sea Freight",
        "description": "해상 운송",
        "is_active": true,
        "display_order": 1
      }
    ],
    "freight_terms": [
      {
        "code": "PREPAID",
        "name": "Freight Prepaid",
        "description": "운임 선불",
        "is_active": true,
        "display_order": 1
      }
    ]
  }
}
```

---

### 3.2 Individual Master Data RPCs

각 마스터 데이터 개별 조회

| RPC Name | Returns |
|----------|---------|
| `trade_master_get_incoterms` | Incoterms 목록 |
| `trade_master_get_payment_terms` | Payment Terms 목록 |
| `trade_master_get_lc_types` | L/C Types 목록 |
| `trade_master_get_document_types` | Document Types 목록 |
| `trade_master_get_shipping_methods` | Shipping Methods 목록 |
| `trade_master_get_freight_terms` | Freight Terms 목록 |
| `trade_master_get_status_definitions` | 각 Entity별 Status 정의 |

---

## 4. PI RPCs

### 4.1 trade_pi_list

Proforma Invoice 목록 조회

**Parameters:**
```sql
p_company_id   UUID
p_store_id     UUID      -- Optional
p_status       TEXT[]    -- Optional: status 배열 필터
p_buyer_id     UUID      -- Optional
p_search       TEXT      -- Optional: PI 번호, 바이어명 검색
p_date_from    DATE      -- Optional
p_date_to      DATE      -- Optional
p_page         INT       -- Default: 1
p_page_size    INT       -- Default: 20
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "pi_id": "uuid",
        "pi_number": "PI-2025-001",
        "company_id": "uuid",
        "store_id": "uuid",
        "buyer_id": "uuid",
        "buyer_name": "ABC Trading Co.",
        "currency_code": "USD",
        "total_amount": 50000.00,
        "valid_until": "2025-01-31",
        "status": "SENT",
        "po_id": null,
        "lc_id": null,
        "item_count": 5,
        "created_at": "2025-12-20T10:00:00Z",
        "updated_at": "2025-12-25T15:30:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "page_size": 20,
      "total_count": 45,
      "total_pages": 3
    }
  }
}
```

---

### 4.2 trade_pi_get

Proforma Invoice 상세 조회

**Parameters:**
```sql
p_company_id   UUID
p_pi_id        UUID
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "pi_id": "uuid",
    "pi_number": "PI-2025-001",
    "company_id": "uuid",
    "store_id": "uuid",
    "revision_number": 1,
    "buyer_id": "uuid",
    "buyer_info": {
      "name": "ABC Trading Co.",
      "address": "123 Trade St.",
      "country": "USA"
    },
    "seller_info": {
      "name": "My Company Ltd.",
      "address": "456 Export Ave.",
      "country": "KR"
    },
    "currency_id": "uuid",
    "currency_code": "USD",
    "incoterms_code": "FOB",
    "incoterms_place": "Busan Port",
    "payment_terms_code": "AT_SIGHT",
    "port_of_loading": "Busan",
    "port_of_discharge": "Los Angeles",
    "shipping_method_code": "SEA",
    "partial_shipment_allowed": true,
    "transshipment_allowed": true,
    "packing_details": "Standard export packing",
    "special_instructions": "Handle with care",
    "valid_until": "2025-01-31",
    "estimated_shipment_date": "2025-02-15",
    "items": [
      {
        "item_id": "uuid",
        "line_number": 1,
        "product_id": "uuid",
        "product_code": "PROD-001",
        "description": "Product A",
        "quantity": 100,
        "unit": "PCS",
        "unit_price": 50.00,
        "total_price": 5000.00,
        "hs_code": "1234.56.78"
      }
    ],
    "subtotal": 50000.00,
    "discount_amount": 0,
    "tax_amount": 0,
    "freight_amount": 0,
    "insurance_amount": 0,
    "total_amount": 50000.00,
    "notes": "Thank you for your order",
    "internal_notes": "Priority customer",
    "status": "SENT",
    "sent_at": "2025-12-25T10:00:00Z",
    "accepted_at": null,
    "po_id": null,
    "lc_id": null,
    "created_by": "uuid",
    "created_at": "2025-12-20T10:00:00Z",
    "updated_at": "2025-12-25T15:30:00Z"
  }
}
```

---

### 4.3 trade_pi_create

Proforma Invoice 생성

**Parameters:**
```sql
p_company_id           UUID
p_store_id             UUID
p_buyer_id             UUID
p_currency_id          UUID
p_incoterms_code       TEXT
p_incoterms_place      TEXT
p_payment_terms_code   TEXT
p_port_of_loading      TEXT
p_port_of_discharge    TEXT
p_shipping_method_code TEXT
p_partial_shipment_allowed BOOLEAN
p_transshipment_allowed    BOOLEAN
p_valid_until          DATE
p_estimated_shipment_date DATE
p_items                JSONB      -- 아이템 배열
p_notes                TEXT
p_created_by           UUID
```

---

## 5. PO RPCs

_(Similar structure to PI)_

---

## 6. L/C RPCs

### 6.1 trade_lc_list

**Parameters:**
```sql
p_company_id   UUID
p_store_id     UUID
p_status       TEXT[]
p_applicant_id UUID
p_search       TEXT
p_date_from    DATE
p_date_to      DATE
p_page         INT
p_page_size    INT
```

### 6.2 trade_lc_get

**Expected Response Data Fields:**
```json
{
  "lc_id": "uuid",
  "lc_number": "LC-2025-001",
  "company_id": "uuid",
  "store_id": "uuid",
  "pi_id": "uuid",
  "po_id": "uuid",
  "lc_type_code": "IRREVOCABLE",
  "applicant_id": "uuid",
  "applicant_info": { ... },
  "beneficiary_info": { ... },
  "issuing_bank_id": "uuid",
  "issuing_bank_info": { ... },
  "advising_bank_id": "uuid",
  "advising_bank_info": { ... },
  "confirming_bank_id": "uuid",
  "confirming_bank_info": { ... },
  "currency_id": "uuid",
  "currency_code": "USD",
  "amount": 100000.00,
  "amount_utilized": 0,
  "tolerance_plus_percent": 5,
  "tolerance_minus_percent": 5,
  "issue_date_utc": "2025-01-01T00:00:00Z",
  "expiry_date_utc": "2025-06-30T00:00:00Z",
  "expiry_place": "Korea",
  "latest_shipment_date_utc": "2025-05-31T00:00:00Z",
  "presentation_period_days": 21,
  "payment_terms_code": "AT_SIGHT",
  "usance_days": 0,
  "usance_from": null,
  "incoterms_code": "FOB",
  "incoterms_place": "Busan Port",
  "port_of_loading": "Busan",
  "port_of_discharge": "Los Angeles",
  "shipping_method_code": "SEA",
  "partial_shipment_allowed": true,
  "transshipment_allowed": true,
  "required_documents": [
    { "document_type_code": "BL", "copies": 3, "originals": 3 }
  ],
  "special_conditions": "...",
  "additional_conditions": [ ... ],
  "status": "ACCEPTED",
  "version": 1,
  "amendment_count": 0,
  "notes": "...",
  "internal_notes": "...",
  "created_by": "uuid",
  "created_at_utc": "...",
  "updated_at_utc": "..."
}
```

---

## 7. Shipment RPCs

### 7.1 trade_shipment_list / trade_shipment_get

**Key Fields:**
```json
{
  "shipment_id": "uuid",
  "shipment_number": "SHP-2025-001",
  "lc_id": "uuid",
  "lc_number": "LC-2025-001",
  "po_id": "uuid",
  "po_number": "PO-2025-001",
  "shipping_method_code": "SEA",
  "carrier_name": "Maersk",
  "vessel_name": "MSC Oscar",
  "voyage_number": "VOY-123",
  "container_numbers": ["MSKU1234567"],
  "port_of_loading": "Busan",
  "port_of_discharge": "Los Angeles",
  "etd": "2025-02-01",
  "eta": "2025-02-20",
  "atd": null,
  "ata": null,
  "freight_terms_code": "PREPAID",
  "freight_amount": 5000.00,
  "insurance_amount": 1000.00,
  "gross_weight_kg": 10000,
  "volume_cbm": 50,
  "packages_count": 100,
  "packaging_type": "CARTON",
  "status": "IN_TRANSIT",
  "bl_number": "MSKU12345678",
  "bl_date": "2025-02-01",
  "tracking_events": [
    {
      "timestamp": "2025-02-01T10:00:00Z",
      "location": "Busan Port",
      "status": "Departed",
      "description": "Vessel departed from port"
    }
  ]
}
```

---

## 8. Commercial Invoice RPCs

### 8.1 trade_ci_list / trade_ci_get

**Key Fields:**
```json
{
  "ci_id": "uuid",
  "ci_number": "CI-2025-001",
  "shipment_id": "uuid",
  "lc_id": "uuid",
  "po_id": "uuid",
  "invoice_date": "2025-02-01",
  "currency_code": "USD",
  "total_amount": 50000.00,
  "items": [ ... ],
  "packing_list_attached": true,
  "weight_certificate_attached": true,
  "status": "FINALIZED",
  "discrepancies": [ ... ]
}
```

---

## 9. Payment RPCs

### 9.1 trade_payment_list / trade_payment_get

**Key Fields:**
```json
{
  "payment_id": "uuid",
  "payment_number": "PAY-2025-001",
  "lc_id": "uuid",
  "ci_id": "uuid",
  "payment_type": "AT_SIGHT",
  "due_date": "2025-03-01",
  "currency_code": "USD",
  "amount": 50000.00,
  "bank_charges": 100.00,
  "net_amount": 49900.00,
  "exchange_rate": null,
  "status": "PENDING",
  "received_date": null,
  "received_amount": null,
  "bank_reference": null
}
```

---

## 10. Document RPCs

### 10.1 trade_document_list

**Parameters:**
```sql
p_company_id   UUID
p_entity_type  TEXT      -- 'PI', 'PO', 'LC', 'SHIPMENT', 'CI'
p_entity_id    UUID
```

**Expected Response:**
```json
{
  "success": true,
  "data": [
    {
      "document_id": "uuid",
      "document_type_code": "BL",
      "document_type_name": "Bill of Lading",
      "file_name": "BL_2025001.pdf",
      "file_url": "https://storage.../BL_2025001.pdf",
      "file_size_bytes": 125000,
      "mime_type": "application/pdf",
      "uploaded_at": "2025-02-01T10:00:00Z",
      "uploaded_by": "uuid",
      "is_original": true,
      "copy_number": null,
      "expiry_date": null,
      "verification_status": "VERIFIED",
      "notes": null
    }
  ]
}
```

---

## Flutter Model Mapping Reference

### Entity to Model Field Mapping

| Entity Field | Model Field (snake_case) | Type |
|--------------|--------------------------|------|
| `entityType` | `entity_type` | String |
| `entityId` | `entity_id` | String (UUID) |
| `entityNumber` | `entity_number` | String? |
| `alertType` | `alert_type` | String |
| `dueDate` | `due_date` | DateTime? |
| `daysBeforeDue` | `days_before_due` | int? |
| `isRead` | `is_read` | bool |
| `isDismissed` | `is_dismissed` | bool |
| `isResolved` | `is_resolved` | bool |
| `isSystemGenerated` | `is_system_generated` | bool |
| `assignedTo` | `assigned_to` | String? |
| `createdAt` | `created_at` | DateTime |
| `readAt` | `read_at` | DateTime? |
| `dismissedAt` | `dismissed_at` | DateTime? |
| `resolvedAt` | `resolved_at` | DateTime? |

---

## Error Response Format

모든 RPC에서 에러 발생 시:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid company_id provided",
    "details": {
      "field": "p_company_id",
      "value": null
    }
  }
}
```

**Common Error Codes:**
| Code | Description |
|------|-------------|
| `VALIDATION_ERROR` | 파라미터 유효성 검사 실패 |
| `NOT_FOUND` | 리소스를 찾을 수 없음 |
| `PERMISSION_DENIED` | 권한 없음 |
| `CONFLICT` | 상태 충돌 (예: 이미 취소된 문서 수정 시도) |
| `INTERNAL_ERROR` | 서버 내부 오류 |

---

## Changelog

| Date | Version | Changes |
|------|---------|---------|
| 2025-12-26 | 1.0.0 | Initial specification |

---

**Document Owner:** Development Team
**Last Updated:** 2025-12-26
