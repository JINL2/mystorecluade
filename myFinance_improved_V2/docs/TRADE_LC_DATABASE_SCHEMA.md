# L/C Trade Management System - Database Schema

> **Version**: 1.0.0
> **Created**: 2025-12-26
> **Last Updated**: 2025-12-26

---

## 목차

1. [개요](#1-개요)
2. [ERD (Entity Relationship Diagram)](#2-erd-entity-relationship-diagram)
3. [테이블 목록](#3-테이블-목록)
4. [마스터 데이터 테이블](#4-마스터-데이터-테이블)
5. [메인 거래 테이블](#5-메인-거래-테이블)
6. [로깅/감사 테이블](#6-로깅감사-테이블)
7. [알림 테이블](#7-알림-테이블)
8. [인덱스 전략](#8-인덱스-전략)
9. [기존 테이블 연결](#9-기존-테이블-연결)

---

## 1. 개요

### 1.1 설계 원칙

| 원칙 | 설명 |
|------|------|
| **독립성** | 기존 inventory 테이블과 분리하여 안전성 확보 |
| **참조성** | 상품(inventory_products), 거래처(counterparties) 등 공통 데이터는 참조 |
| **추적성** | 모든 변경사항 로깅 |
| **확장성** | 향후 기능 추가를 위한 유연한 구조 |

### 1.2 네이밍 규칙

| 규칙 | 예시 |
|------|------|
| 테이블 접두어 | `trade_*` |
| 기본키 | `{entity}_id` (UUID) |
| 외래키 | `{referenced_entity}_id` |
| 시간 필드 | `*_utc` (TIMESTAMPTZ) |
| 불리언 필드 | `is_*`, `has_*` |
| JSON 필드 | 복잡한 데이터는 JSONB |

### 1.3 총 테이블 수

| 분류 | 개수 | 목적 |
|------|------|------|
| 마스터 데이터 | 7개 | Terms, 상태, 문서 종류 등 |
| 메인 거래 | 12개 | PI, PO, L/C, Shipment, CI 등 |
| 로깅/감사 | 5개 | 활동 로그, 상태 이력 등 |
| 알림 | 1개 | 알림/리마인더 |
| **총계** | **25개** | |

---

## 2. ERD (Entity Relationship Diagram)

### 2.1 전체 관계도

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              MASTER DATA TABLES                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐              │
│  │ trade_incoterms  │  │trade_payment_terms│  │  trade_lc_types  │              │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘              │
│                                                                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐              │
│  │trade_document_   │  │trade_freight_    │  │trade_shipping_   │              │
│  │     types        │  │     terms        │  │    methods       │              │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘              │
│                                                                                 │
│  ┌──────────────────────────────────────────────────────────────┐              │
│  │                   trade_status_definitions                    │              │
│  └──────────────────────────────────────────────────────────────┘              │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            EXISTING TABLES (Reference)                           │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │  companies  │  │   stores    │  │counterparties│  │currency_types│            │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘            │
│         │                │                │                │                    │
│         │    ┌───────────┴────────────────┴────────────────┘                   │
│         │    │                                                                  │
│         ▼    ▼                                                                  │
│  ┌─────────────────────┐                                                        │
│  │ inventory_products  │                                                        │
│  └─────────────────────┘                                                        │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                             MAIN TRANSACTION TABLES                              │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────┐                                                    │
│  │ trade_proforma_invoices │ ◄─── PI (Proforma Invoice)                        │
│  │    + trade_pi_items     │                                                    │
│  └───────────┬─────────────┘                                                    │
│              │ pi_id                                                            │
│              ▼                                                                  │
│  ┌─────────────────────────┐                                                    │
│  │ trade_purchase_orders   │ ◄─── PO (Purchase Order)                          │
│  │    + trade_po_items     │                                                    │
│  └───────────┬─────────────┘                                                    │
│              │ po_id                                                            │
│              ▼                                                                  │
│  ┌─────────────────────────┐                                                    │
│  │ trade_letters_of_credit │ ◄─── L/C (Letter of Credit)                       │
│  │  + trade_lc_amendments  │                                                    │
│  └───────────┬─────────────┘                                                    │
│              │ lc_id                                                            │
│              ▼                                                                  │
│  ┌─────────────────────────┐                                                    │
│  │   trade_shipments       │ ◄─── Shipment                                     │
│  │ + trade_shipment_items  │                                                    │
│  └───────────┬─────────────┘                                                    │
│              │ shipment_id                                                      │
│              ▼                                                                  │
│  ┌─────────────────────────┐                                                    │
│  │trade_commercial_invoices│ ◄─── CI (Commercial Invoice)                      │
│  │   + trade_ci_items      │                                                    │
│  └───────────┬─────────────┘                                                    │
│              │ ci_id                                                            │
│              ▼                                                                  │
│  ┌─────────────────────────┐                                                    │
│  │    trade_payments       │ ◄─── Payment                                      │
│  └─────────────────────────┘                                                    │
│                                                                                 │
│  ┌─────────────────────────┐                                                    │
│  │    trade_documents      │ ◄─── 첨부 서류 (모든 엔티티 공통)                   │
│  └─────────────────────────┘                                                    │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              LOGGING TABLES                                      │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐              │
│  │trade_activity_   │  │trade_status_     │  │trade_document_   │              │
│  │     logs         │  │    history       │  │     logs         │              │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘              │
│                                                                                 │
│  ┌──────────────────┐  ┌──────────────────┐                                    │
│  │trade_discrepancy_│  │ trade_amount_    │                                    │
│  │      logs        │  │    history       │                                    │
│  └──────────────────┘  └──────────────────┘                                    │
│                                                                                 │
│  ┌──────────────────┐                                                          │
│  │  trade_alerts    │ ◄─── 알림/리마인더                                        │
│  └──────────────────┘                                                          │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. 테이블 목록

### 3.1 마스터 데이터 테이블 (7개)

| # | 테이블명 | 설명 | 레코드 수 |
|---|----------|------|----------|
| 1 | `trade_incoterms` | Incoterms 2020 정의 | 11개 고정 |
| 2 | `trade_payment_terms` | 결제 조건 | ~15개 |
| 3 | `trade_lc_types` | L/C 종류 | ~10개 |
| 4 | `trade_document_types` | 서류 종류 | ~25개 |
| 5 | `trade_freight_terms` | 운임 조건 | 4개 고정 |
| 6 | `trade_shipping_methods` | 운송 방법 | 6개 고정 |
| 7 | `trade_status_definitions` | 모든 상태 정의 | ~40개 |

### 3.2 메인 거래 테이블 (12개)

| # | 테이블명 | 설명 | 관계 |
|---|----------|------|------|
| 8 | `trade_proforma_invoices` | PI 헤더 | 1:N → items |
| 9 | `trade_pi_items` | PI 품목 | N:1 → PI |
| 10 | `trade_purchase_orders` | PO 헤더 | 1:N → items |
| 11 | `trade_po_items` | PO 품목 | N:1 → PO |
| 12 | `trade_letters_of_credit` | L/C 정보 | 1:N → amendments |
| 13 | `trade_lc_amendments` | L/C 수정 이력 | N:1 → L/C |
| 14 | `trade_shipments` | 선적 헤더 | 1:N → items |
| 15 | `trade_shipment_items` | 선적 품목 | N:1 → Shipment |
| 16 | `trade_commercial_invoices` | CI 헤더 | 1:N → items |
| 17 | `trade_ci_items` | CI 품목 | N:1 → CI |
| 18 | `trade_documents` | 첨부 서류 | N:1 → any entity |
| 19 | `trade_payments` | 결제 기록 | N:1 → L/C, CI |

### 3.3 로깅/감사 테이블 (5개)

| # | 테이블명 | 설명 |
|---|----------|------|
| 20 | `trade_activity_logs` | 전체 활동 로그 |
| 21 | `trade_status_history` | 상태 변경 이력 |
| 22 | `trade_document_logs` | 서류 활동 로그 |
| 23 | `trade_discrepancy_logs` | 불일치 기록 |
| 24 | `trade_amount_history` | 금액 변경 이력 |

### 3.4 알림 테이블 (1개)

| # | 테이블명 | 설명 |
|---|----------|------|
| 25 | `trade_alerts` | 알림/리마인더 |

---

## 4. 마스터 데이터 테이블

### 4.1 trade_incoterms (거래조건)

```sql
CREATE TABLE trade_incoterms (
  incoterm_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(3) NOT NULL UNIQUE,           -- EXW, FOB, CIF...
  name VARCHAR(100) NOT NULL,                -- Ex Works, Free On Board...
  description TEXT,

  -- 운송 모드
  transport_mode VARCHAR(20) NOT NULL,        -- any, sea_only

  -- 책임 분기점
  risk_transfer_point TEXT,                   -- 위험 이전 시점 설명
  cost_transfer_point TEXT,                   -- 비용 이전 시점 설명

  -- 셀러/바이어 책임
  seller_responsibilities JSONB,              -- ["export_clearance", "loading", ...]
  buyer_responsibilities JSONB,               -- ["import_clearance", "unloading", ...]

  -- 정렬 및 활성화
  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,

  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

-- 기본 데이터
INSERT INTO trade_incoterms (code, name, transport_mode, description, sort_order) VALUES
-- Any Transport Mode (모든 운송 수단)
('EXW', 'Ex Works', 'any', '공장 인도 - 바이어가 모든 비용/위험 부담', 1),
('FCA', 'Free Carrier', 'any', '운송인 인도 - 지정 장소에서 운송인에게 인도', 2),
('CPT', 'Carriage Paid To', 'any', '운송비 지급 인도 - 셀러가 목적지까지 운송비 부담', 3),
('CIP', 'Carriage and Insurance Paid To', 'any', '운송비/보험료 지급 인도 - 셀러가 운송비+보험 부담', 4),
('DAP', 'Delivered at Place', 'any', '목적지 인도 - 하역 전까지 셀러 책임', 5),
('DPU', 'Delivered at Place Unloaded', 'any', '목적지 양하 인도 - 하역까지 셀러 책임', 6),
('DDP', 'Delivered Duty Paid', 'any', '관세 지급 인도 - 관세 포함 모든 비용 셀러 부담', 7),
-- Sea and Inland Waterway Only (해상/내수로 전용)
('FAS', 'Free Alongside Ship', 'sea_only', '선측 인도 - 본선 옆까지 셀러 책임', 8),
('FOB', 'Free On Board', 'sea_only', '본선 인도 - 가장 많이 사용되는 조건', 9),
('CFR', 'Cost and Freight', 'sea_only', '운임 포함 인도 - 셀러가 운임 부담', 10),
('CIF', 'Cost Insurance and Freight', 'sea_only', '운임/보험료 포함 인도 - 셀러가 운임+보험 부담', 11);
```

### 4.2 trade_payment_terms (결제조건)

```sql
CREATE TABLE trade_payment_terms (
  payment_term_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(30) NOT NULL UNIQUE,           -- lc_at_sight, lc_usance_30...
  name VARCHAR(100) NOT NULL,                 -- L/C At Sight, L/C Usance 30 Days...
  description TEXT,

  -- 결제 타이밍
  payment_timing VARCHAR(20) NOT NULL,        -- immediate, deferred
  days_after_shipment INTEGER,                -- usance인 경우 일수 (30, 60, 90...)

  -- L/C 필요 여부
  requires_lc BOOLEAN DEFAULT false,

  -- 정렬 및 활성화
  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,

  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO trade_payment_terms (code, name, payment_timing, days_after_shipment, requires_lc, sort_order) VALUES
-- L/C Terms (신용장 조건)
('lc_at_sight', 'L/C At Sight', 'immediate', NULL, true, 1),
('lc_usance_30', 'L/C Usance 30 Days', 'deferred', 30, true, 2),
('lc_usance_60', 'L/C Usance 60 Days', 'deferred', 60, true, 3),
('lc_usance_90', 'L/C Usance 90 Days', 'deferred', 90, true, 4),
('lc_usance_120', 'L/C Usance 120 Days', 'deferred', 120, true, 5),
('lc_usance_180', 'L/C Usance 180 Days', 'deferred', 180, true, 6),
-- T/T Terms (전신환)
('tt_advance', 'T/T in Advance (100%)', 'immediate', NULL, false, 10),
('tt_advance_30', 'T/T 30% Advance, 70% Before Shipment', 'immediate', NULL, false, 11),
('tt_against_bl', 'T/T Against B/L Copy', 'immediate', NULL, false, 12),
('tt_30', 'T/T 30 Days After Shipment', 'deferred', 30, false, 13),
('tt_60', 'T/T 60 Days After Shipment', 'deferred', 60, false, 14),
-- D/A, D/P Terms (추심)
('da_30', 'D/A 30 Days', 'deferred', 30, false, 20),
('da_60', 'D/A 60 Days', 'deferred', 60, false, 21),
('da_90', 'D/A 90 Days', 'deferred', 90, false, 22),
('dp', 'D/P (Documents against Payment)', 'immediate', NULL, false, 25),
-- Open Account
('open_account_30', 'Open Account 30 Days', 'deferred', 30, false, 30),
('open_account_60', 'Open Account 60 Days', 'deferred', 60, false, 31);
```

### 4.3 trade_lc_types (L/C 종류)

```sql
CREATE TABLE trade_lc_types (
  lc_type_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(30) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  description TEXT,

  -- L/C 특성
  is_revocable BOOLEAN DEFAULT false,         -- 취소 가능 여부
  is_confirmed BOOLEAN DEFAULT false,         -- 확인 신용장 여부
  is_transferable BOOLEAN DEFAULT false,      -- 양도 가능 여부
  is_revolving BOOLEAN DEFAULT false,         -- 회전 신용장 여부
  is_standby BOOLEAN DEFAULT false,           -- 보증 신용장 여부

  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,

  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO trade_lc_types (code, name, description, is_revocable, is_confirmed, is_transferable, is_revolving, is_standby, sort_order) VALUES
('irrevocable', 'Irrevocable L/C', '취소 불가 신용장 - UCP600 기본', false, false, false, false, false, 1),
('confirmed', 'Confirmed L/C', '확인 신용장 - 제3은행이 지급 보증 추가', false, true, false, false, false, 2),
('transferable', 'Transferable L/C', '양도 가능 신용장 - 제3자에게 양도 가능', false, false, true, false, false, 3),
('confirmed_transferable', 'Confirmed & Transferable L/C', '확인 + 양도 가능 신용장', false, true, true, false, false, 4),
('revolving', 'Revolving L/C', '회전 신용장 - 사용 후 자동 복원', false, false, false, true, false, 5),
('standby', 'Standby L/C (SBLC)', '보증 신용장 - 이행보증/지급보증용', false, false, false, false, true, 6),
('red_clause', 'Red Clause L/C', '적색 조항 신용장 - 선수금 지급 가능', false, false, false, false, false, 7),
('green_clause', 'Green Clause L/C', '녹색 조항 신용장 - 선수금 + 창고보관비', false, false, false, false, false, 8),
('back_to_back', 'Back-to-Back L/C', '백투백 신용장 - 원신용장 담보로 새 L/C', false, false, false, false, false, 9),
('deferred', 'Deferred Payment L/C', '연지급 신용장 - 환어음 없이 만기일 지급', false, false, false, false, false, 10);
```

### 4.4 trade_document_types (서류 종류)

```sql
CREATE TABLE trade_document_types (
  document_type_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  name_short VARCHAR(20),                     -- B/L, AWB, CI, PL...
  description TEXT,

  -- 분류
  category VARCHAR(30) NOT NULL,              -- transport, commercial, insurance, certificate, financial, other

  -- L/C 관련
  commonly_required BOOLEAN DEFAULT false,    -- L/C에서 일반적으로 요구됨

  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,

  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO trade_document_types (code, name, name_short, category, commonly_required, sort_order) VALUES
-- Transport Documents (운송 서류)
('bill_of_lading', 'Bill of Lading', 'B/L', 'transport', true, 1),
('airway_bill', 'Air Waybill', 'AWB', 'transport', true, 2),
('sea_waybill', 'Sea Waybill', 'SWB', 'transport', false, 3),
('multimodal_transport', 'Multimodal Transport Document', 'MTD', 'transport', false, 4),
('truck_receipt', 'Truck/CMR Receipt', 'TR', 'transport', false, 5),
('rail_consignment', 'Rail Consignment Note', 'RCN', 'transport', false, 6),
('courier_receipt', 'Courier Receipt', 'CR', 'transport', false, 7),

-- Commercial Documents (상업 서류)
('commercial_invoice', 'Commercial Invoice', 'CI', 'commercial', true, 10),
('proforma_invoice', 'Proforma Invoice', 'PI', 'commercial', false, 11),
('packing_list', 'Packing List', 'PL', 'commercial', true, 12),
('weight_list', 'Weight List', 'WL', 'commercial', false, 13),
('measurement_list', 'Measurement List', 'ML', 'commercial', false, 14),

-- Insurance Documents (보험 서류)
('insurance_certificate', 'Insurance Certificate', 'INS', 'insurance', true, 20),
('insurance_policy', 'Insurance Policy', 'IP', 'insurance', false, 21),
('insurance_endorsement', 'Insurance Endorsement', 'IE', 'insurance', false, 22),

-- Certificates (증명서)
('certificate_of_origin', 'Certificate of Origin', 'COO', 'certificate', true, 30),
('gsp_form_a', 'GSP Form A', 'GSP', 'certificate', false, 31),
('eur1', 'EUR.1 Movement Certificate', 'EUR1', 'certificate', false, 32),
('inspection_certificate', 'Inspection Certificate', 'IC', 'certificate', false, 33),
('quality_certificate', 'Quality Certificate', 'QC', 'certificate', false, 34),
('analysis_certificate', 'Certificate of Analysis', 'COA', 'certificate', false, 35),
('phytosanitary_certificate', 'Phytosanitary Certificate', 'PC', 'certificate', false, 36),
('health_certificate', 'Health Certificate', 'HC', 'certificate', false, 37),
('fumigation_certificate', 'Fumigation Certificate', 'FC', 'certificate', false, 38),
('weight_certificate', 'Weight Certificate', 'WC', 'certificate', false, 39),

-- Financial Documents (금융 서류)
('draft_bill_of_exchange', 'Draft/Bill of Exchange', 'BOE', 'financial', false, 40),
('beneficiary_certificate', 'Beneficiary Certificate', 'BC', 'financial', false, 41),

-- Other Documents (기타)
('customs_declaration', 'Customs Declaration', 'CD', 'other', false, 50),
('export_license', 'Export License', 'EL', 'other', false, 51),
('import_license', 'Import License', 'IL', 'other', false, 52),
('shipping_advice', 'Shipping Advice', 'SA', 'other', false, 53),
('other', 'Other Document', 'OTH', 'other', false, 99);
```

### 4.5 trade_freight_terms (운임 조건)

```sql
CREATE TABLE trade_freight_terms (
  freight_term_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(30) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  description TEXT,

  -- 지불자
  payer VARCHAR(20) NOT NULL,                 -- seller, buyer, third_party

  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,

  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO trade_freight_terms (code, name, payer, description, sort_order) VALUES
('prepaid', 'Freight Prepaid', 'seller', '셀러가 운임 선불 - B/L에 "FREIGHT PREPAID" 표기', 1),
('collect', 'Freight Collect', 'buyer', '바이어가 운임 후불 - B/L에 "FREIGHT COLLECT" 표기', 2),
('prepaid_and_add', 'Prepaid and Add', 'seller', '셀러 선불 후 인보이스에 추가 청구', 3),
('third_party', 'Third Party Freight', 'third_party', '제3자(포워더 등)가 지불', 4);
```

### 4.6 trade_shipping_methods (운송 방법)

```sql
CREATE TABLE trade_shipping_methods (
  shipping_method_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  description TEXT,

  -- 관련 운송 서류
  transport_document_code VARCHAR(50),        -- trade_document_types.code 참조

  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,

  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO trade_shipping_methods (code, name, transport_document_code, description, sort_order) VALUES
('sea', 'Sea Freight (FCL/LCL)', 'bill_of_lading', '해상 운송 - 컨테이너/벌크', 1),
('air', 'Air Freight', 'airway_bill', '항공 운송', 2),
('road', 'Road/Truck', 'truck_receipt', '육로/트럭 운송', 3),
('rail', 'Rail', 'rail_consignment', '철도 운송', 4),
('multimodal', 'Multimodal', 'multimodal_transport', '복합 운송 (2개 이상 수단)', 5),
('courier', 'Courier/Express', 'courier_receipt', '특송/퀵 서비스', 6);
```

### 4.7 trade_status_definitions (상태 정의)

```sql
CREATE TABLE trade_status_definitions (
  status_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type VARCHAR(30) NOT NULL,           -- pi, po, lc, shipment, ci, payment
  code VARCHAR(30) NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT,

  -- 상태 속성
  is_initial BOOLEAN DEFAULT false,           -- 초기 상태인가?
  is_final BOOLEAN DEFAULT false,             -- 최종 상태인가?
  is_cancelled BOOLEAN DEFAULT false,         -- 취소 상태인가?
  is_error BOOLEAN DEFAULT false,             -- 오류 상태인가?

  -- UI 표시
  color VARCHAR(20),                          -- primary, success, warning, danger, secondary
  icon VARCHAR(50),                           -- 아이콘 이름

  sort_order INTEGER DEFAULT 0,

  created_at_utc TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(entity_type, code)
);

-- PI 상태
INSERT INTO trade_status_definitions (entity_type, code, name, is_initial, is_final, is_cancelled, color, sort_order) VALUES
('pi', 'draft', 'Draft', true, false, false, 'secondary', 1),
('pi', 'sent', 'Sent to Buyer', false, false, false, 'primary', 2),
('pi', 'negotiating', 'Under Negotiation', false, false, false, 'warning', 3),
('pi', 'accepted', 'Accepted by Buyer', false, false, false, 'success', 4),
('pi', 'rejected', 'Rejected', false, true, true, 'danger', 5),
('pi', 'expired', 'Expired', false, true, false, 'secondary', 6),
('pi', 'converted', 'Converted to PO', false, true, false, 'success', 7);

-- PO 상태
INSERT INTO trade_status_definitions (entity_type, code, name, is_initial, is_final, is_cancelled, color, sort_order) VALUES
('po', 'draft', 'Draft', true, false, false, 'secondary', 1),
('po', 'confirmed', 'Confirmed', false, false, false, 'primary', 2),
('po', 'in_production', 'In Production', false, false, false, 'warning', 3),
('po', 'ready_to_ship', 'Ready to Ship', false, false, false, 'info', 4),
('po', 'partially_shipped', 'Partially Shipped', false, false, false, 'warning', 5),
('po', 'shipped', 'Fully Shipped', false, false, false, 'success', 6),
('po', 'completed', 'Completed', false, true, false, 'success', 7),
('po', 'cancelled', 'Cancelled', false, true, true, 'danger', 8);

-- L/C 상태
INSERT INTO trade_status_definitions (entity_type, code, name, is_initial, is_final, is_cancelled, is_error, color, sort_order) VALUES
('lc', 'draft', 'Draft', true, false, false, false, 'secondary', 1),
('lc', 'pending', 'Pending Issuance', false, false, false, false, 'warning', 2),
('lc', 'issued', 'Issued', false, false, false, false, 'primary', 3),
('lc', 'advised', 'Advised', false, false, false, false, 'primary', 4),
('lc', 'confirmed', 'Confirmed', false, false, false, false, 'success', 5),
('lc', 'amendment_requested', 'Amendment Requested', false, false, false, false, 'warning', 6),
('lc', 'amended', 'Amended', false, false, false, false, 'primary', 7),
('lc', 'partially_shipped', 'Partially Shipped', false, false, false, false, 'info', 8),
('lc', 'fully_shipped', 'Fully Shipped', false, false, false, false, 'success', 9),
('lc', 'documents_presented', 'Documents Presented', false, false, false, false, 'info', 10),
('lc', 'under_examination', 'Under Bank Examination', false, false, false, false, 'warning', 11),
('lc', 'discrepancy', 'Discrepancy Found', false, false, false, true, 'danger', 12),
('lc', 'accepted', 'Documents Accepted', false, false, false, false, 'success', 13),
('lc', 'payment_pending', 'Payment Pending', false, false, false, false, 'warning', 14),
('lc', 'paid', 'Paid', false, true, false, false, 'success', 15),
('lc', 'expired', 'Expired', false, true, false, false, 'secondary', 16),
('lc', 'cancelled', 'Cancelled', false, true, true, false, 'danger', 17);

-- Shipment 상태
INSERT INTO trade_status_definitions (entity_type, code, name, is_initial, is_final, is_cancelled, color, sort_order) VALUES
('shipment', 'draft', 'Draft', true, false, false, 'secondary', 1),
('shipment', 'booked', 'Booking Confirmed', false, false, false, 'primary', 2),
('shipment', 'at_origin_port', 'At Origin Port', false, false, false, 'info', 3),
('shipment', 'loaded', 'Loaded/On Board', false, false, false, 'primary', 4),
('shipment', 'departed', 'Departed', false, false, false, 'info', 5),
('shipment', 'in_transit', 'In Transit', false, false, false, 'warning', 6),
('shipment', 'at_destination_port', 'At Destination Port', false, false, false, 'info', 7),
('shipment', 'customs_clearance', 'Customs Clearance', false, false, false, 'warning', 8),
('shipment', 'out_for_delivery', 'Out for Delivery', false, false, false, 'info', 9),
('shipment', 'delivered', 'Delivered', false, true, false, 'success', 10),
('shipment', 'cancelled', 'Cancelled', false, true, true, 'danger', 11);

-- CI (Commercial Invoice) 상태
INSERT INTO trade_status_definitions (entity_type, code, name, is_initial, is_final, is_cancelled, is_error, color, sort_order) VALUES
('ci', 'draft', 'Draft', true, false, false, false, 'secondary', 1),
('ci', 'finalized', 'Finalized', false, false, false, false, 'primary', 2),
('ci', 'submitted', 'Submitted to Bank', false, false, false, false, 'info', 3),
('ci', 'under_review', 'Under Bank Review', false, false, false, false, 'warning', 4),
('ci', 'discrepancy', 'Discrepancy Found', false, false, false, true, 'danger', 5),
('ci', 'discrepancy_resolved', 'Discrepancy Resolved', false, false, false, false, 'warning', 6),
('ci', 'accepted', 'Accepted by Bank', false, false, false, false, 'success', 7),
('ci', 'payment_pending', 'Payment Pending', false, false, false, false, 'warning', 8),
('ci', 'paid', 'Paid', false, true, false, false, 'success', 9),
('ci', 'rejected', 'Rejected', false, true, false, true, 'danger', 10);

-- Payment 상태
INSERT INTO trade_status_definitions (entity_type, code, name, is_initial, is_final, color, sort_order) VALUES
('payment', 'pending', 'Pending', true, false, 'secondary', 1),
('payment', 'processing', 'Processing', false, false, 'warning', 2),
('payment', 'partial', 'Partially Received', false, false, 'info', 3),
('payment', 'completed', 'Completed', false, true, 'success', 4),
('payment', 'failed', 'Failed', false, true, 'danger', 5),
('payment', 'refunded', 'Refunded', false, true, 'secondary', 6);
```

---

## 5. 메인 거래 테이블

### 5.1 trade_proforma_invoices (PI - 견적서)

```sql
CREATE TABLE trade_proforma_invoices (
  pi_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pi_number VARCHAR(50) NOT NULL,             -- PI-2025-0001
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 바이어 정보
  buyer_id UUID REFERENCES counterparties(counterparty_id),
  buyer_info JSONB,                           -- 스냅샷: {name, address, contact_person, email, phone}

  -- 셀러(우리) 정보
  seller_info JSONB,                          -- {name, address, contact_person, email, phone, bank_details}

  -- 금액
  currency_id UUID REFERENCES currency_types(currency_id),
  subtotal NUMERIC(15,2) DEFAULT 0,
  discount_percent NUMERIC(5,2) DEFAULT 0,
  discount_amount NUMERIC(15,2) DEFAULT 0,
  tax_percent NUMERIC(5,2) DEFAULT 0,
  tax_amount NUMERIC(15,2) DEFAULT 0,
  total_amount NUMERIC(15,2) DEFAULT 0,

  -- 거래 조건 (Incoterms)
  incoterms_code VARCHAR(3),                  -- FOB, CIF...
  incoterms_place VARCHAR(200),               -- FOB Ho Chi Minh Port

  -- 항구/공항
  port_of_loading VARCHAR(200),
  port_of_discharge VARCHAR(200),
  final_destination VARCHAR(200),
  country_of_origin VARCHAR(100),

  -- 결제 조건
  payment_terms_code VARCHAR(30),             -- lc_at_sight, lc_usance_60...
  payment_terms_detail TEXT,                  -- 추가 설명

  -- 선적 조건
  partial_shipment_allowed BOOLEAN DEFAULT true,
  transshipment_allowed BOOLEAN DEFAULT true,
  shipping_method_code VARCHAR(20),           -- sea, air...
  estimated_shipment_date TIMESTAMPTZ,
  lead_time_days INTEGER,                     -- 생산 소요일

  -- 유효기간
  validity_date TIMESTAMPTZ,

  -- 상태
  status VARCHAR(30) DEFAULT 'draft',

  -- 추가 정보
  notes TEXT,
  internal_notes TEXT,                        -- 내부 메모 (바이어에게 안 보임)
  terms_and_conditions TEXT,

  -- 메타
  created_by UUID REFERENCES users(user_id),
  created_at_utc TIMESTAMPTZ DEFAULT NOW(),
  updated_at_utc TIMESTAMPTZ DEFAULT NOW(),

  -- 제약 조건
  CONSTRAINT chk_pi_amounts CHECK (total_amount >= 0)
);

CREATE INDEX idx_trade_pi_company ON trade_proforma_invoices(company_id);
CREATE INDEX idx_trade_pi_buyer ON trade_proforma_invoices(buyer_id);
CREATE INDEX idx_trade_pi_status ON trade_proforma_invoices(status);
CREATE INDEX idx_trade_pi_number ON trade_proforma_invoices(pi_number);
CREATE INDEX idx_trade_pi_date ON trade_proforma_invoices(created_at_utc);
```

### 5.2 trade_pi_items (PI 품목)

```sql
CREATE TABLE trade_pi_items (
  item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pi_id UUID NOT NULL REFERENCES trade_proforma_invoices(pi_id) ON DELETE CASCADE,

  -- 상품 참조
  product_id UUID REFERENCES inventory_products(product_id),

  -- 품목 정보 (L/C 문구용 - 스냅샷)
  description TEXT NOT NULL,                  -- L/C에 들어갈 정확한 문구
  sku VARCHAR(100),
  barcode VARCHAR(100),

  -- 분류
  hs_code VARCHAR(20),                        -- 관세 코드 (예: 6204.62)
  country_of_origin VARCHAR(100),

  -- 수량/단위
  quantity NUMERIC(15,3) NOT NULL,
  unit VARCHAR(50),                           -- PCS, SET, KG, MTR, DOZ...

  -- 가격
  unit_price NUMERIC(15,4) NOT NULL,
  discount_percent NUMERIC(5,2) DEFAULT 0,
  discount_amount NUMERIC(15,2) DEFAULT 0,
  total_amount NUMERIC(15,2) NOT NULL,

  -- 포장 정보
  packing_info TEXT,                          -- 예: "12 pcs/polybag, 60 pcs/carton"

  -- 정렬
  sort_order INTEGER DEFAULT 0,

  -- 메타
  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_pi_items_pi ON trade_pi_items(pi_id);
CREATE INDEX idx_trade_pi_items_product ON trade_pi_items(product_id);
```

### 5.3 trade_purchase_orders (PO - 주문서)

```sql
CREATE TABLE trade_purchase_orders (
  po_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  po_number VARCHAR(50) NOT NULL,             -- TPO-2025-0001 (우리가 생성한 번호)
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- PI 연결
  pi_id UUID REFERENCES trade_proforma_invoices(pi_id),

  -- 바이어 정보
  buyer_id UUID REFERENCES counterparties(counterparty_id),
  buyer_po_number VARCHAR(100),               -- 바이어가 발행한 PO 번호
  buyer_info JSONB,

  -- 금액
  currency_id UUID REFERENCES currency_types(currency_id),
  total_amount NUMERIC(15,2) DEFAULT 0,

  -- 거래 조건 (PI에서 복사 또는 수정)
  incoterms_code VARCHAR(3),
  incoterms_place VARCHAR(200),
  payment_terms_code VARCHAR(30),

  -- 날짜
  order_date_utc TIMESTAMPTZ,
  required_shipment_date_utc TIMESTAMPTZ,

  -- 선적 조건
  partial_shipment_allowed BOOLEAN DEFAULT true,
  transshipment_allowed BOOLEAN DEFAULT true,

  -- 상태
  status VARCHAR(30) DEFAULT 'draft',

  -- 진행률
  shipped_percent NUMERIC(5,2) DEFAULT 0,     -- 선적 완료 비율

  notes TEXT,

  -- 메타
  created_by UUID REFERENCES users(user_id),
  created_at_utc TIMESTAMPTZ DEFAULT NOW(),
  updated_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_po_company ON trade_purchase_orders(company_id);
CREATE INDEX idx_trade_po_pi ON trade_purchase_orders(pi_id);
CREATE INDEX idx_trade_po_buyer ON trade_purchase_orders(buyer_id);
CREATE INDEX idx_trade_po_status ON trade_purchase_orders(status);
```

### 5.4 trade_po_items (PO 품목)

```sql
CREATE TABLE trade_po_items (
  item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  po_id UUID NOT NULL REFERENCES trade_purchase_orders(po_id) ON DELETE CASCADE,

  -- PI 아이템 연결
  pi_item_id UUID REFERENCES trade_pi_items(item_id),
  product_id UUID REFERENCES inventory_products(product_id),

  -- 품목 정보
  description TEXT NOT NULL,
  sku VARCHAR(100),
  hs_code VARCHAR(20),

  -- 수량
  quantity_ordered NUMERIC(15,3) NOT NULL,
  quantity_shipped NUMERIC(15,3) DEFAULT 0,   -- 선적 완료 수량
  quantity_remaining NUMERIC(15,3) GENERATED ALWAYS AS (quantity_ordered - quantity_shipped) STORED,

  unit VARCHAR(50),
  unit_price NUMERIC(15,4) NOT NULL,
  total_amount NUMERIC(15,2) NOT NULL,

  sort_order INTEGER DEFAULT 0,
  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_po_items_po ON trade_po_items(po_id);
```

### 5.5 trade_letters_of_credit (L/C - 신용장)

```sql
CREATE TABLE trade_letters_of_credit (
  lc_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lc_number VARCHAR(100) NOT NULL,            -- 은행에서 받은 L/C 번호
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 연결
  pi_id UUID REFERENCES trade_proforma_invoices(pi_id),
  po_id UUID REFERENCES trade_purchase_orders(po_id),

  -- L/C 종류
  lc_type_code VARCHAR(30) DEFAULT 'irrevocable',

  -- 신청인 (Applicant = 바이어)
  applicant_id UUID REFERENCES counterparties(counterparty_id),
  applicant_info JSONB,                       -- {name, address}

  -- 수익자 (Beneficiary = 우리)
  beneficiary_info JSONB,                     -- {name, address}

  -- 개설은행 (Issuing Bank)
  issuing_bank_id UUID REFERENCES counterparties(counterparty_id),
  issuing_bank_info JSONB,                    -- {name, address, swift_code}

  -- 통지은행 (Advising Bank)
  advising_bank_id UUID REFERENCES counterparties(counterparty_id),
  advising_bank_info JSONB,

  -- 확인은행 (Confirming Bank) - confirmed L/C인 경우
  confirming_bank_id UUID REFERENCES counterparties(counterparty_id),
  confirming_bank_info JSONB,

  -- 금액
  currency_id UUID REFERENCES currency_types(currency_id),
  amount NUMERIC(15,2) NOT NULL,
  amount_utilized NUMERIC(15,2) DEFAULT 0,    -- 사용된 금액
  tolerance_plus_percent NUMERIC(5,2) DEFAULT 0,
  tolerance_minus_percent NUMERIC(5,2) DEFAULT 0,

  -- 날짜
  issue_date_utc TIMESTAMPTZ,
  expiry_date_utc TIMESTAMPTZ NOT NULL,
  expiry_place VARCHAR(200),                  -- 만료 장소 (보통 통지은행 소재지)
  latest_shipment_date_utc TIMESTAMPTZ,
  presentation_period_days INTEGER DEFAULT 21,

  -- 결제 조건
  payment_terms_code VARCHAR(30),
  usance_days INTEGER,                        -- usance인 경우
  usance_from VARCHAR(50),                    -- 'bl_date', 'shipment_date'...

  -- 거래 조건
  incoterms_code VARCHAR(3),
  incoterms_place VARCHAR(200),

  -- 선적 정보
  port_of_loading VARCHAR(200),
  port_of_discharge VARCHAR(200),
  shipping_method_code VARCHAR(20),
  partial_shipment_allowed BOOLEAN DEFAULT true,
  transshipment_allowed BOOLEAN DEFAULT true,

  -- 요구 서류 (체크리스트)
  required_documents JSONB,                   -- [{code, copies, original_copies, notes}, ...]

  -- 특별 조건
  special_conditions TEXT,
  additional_conditions JSONB,                -- 추가 조건들

  -- 상태
  status VARCHAR(30) DEFAULT 'draft',

  -- Amendment
  amendment_count INTEGER DEFAULT 0,

  notes TEXT,
  internal_notes TEXT,

  -- 메타
  created_by UUID REFERENCES users(user_id),
  created_at_utc TIMESTAMPTZ DEFAULT NOW(),
  updated_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_lc_company ON trade_letters_of_credit(company_id);
CREATE INDEX idx_trade_lc_number ON trade_letters_of_credit(lc_number);
CREATE INDEX idx_trade_lc_status ON trade_letters_of_credit(status);
CREATE INDEX idx_trade_lc_expiry ON trade_letters_of_credit(expiry_date_utc);
CREATE INDEX idx_trade_lc_pi ON trade_letters_of_credit(pi_id);
CREATE INDEX idx_trade_lc_po ON trade_letters_of_credit(po_id);
```

### 5.6 trade_lc_amendments (L/C 수정 이력)

```sql
CREATE TABLE trade_lc_amendments (
  amendment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lc_id UUID NOT NULL REFERENCES trade_letters_of_credit(lc_id) ON DELETE CASCADE,

  amendment_number INTEGER NOT NULL,          -- 1, 2, 3...
  amendment_date_utc TIMESTAMPTZ,

  -- 변경 내용
  changes_summary TEXT NOT NULL,              -- 변경 요약
  changes_detail JSONB,                       -- {field: {old_value, new_value}}

  -- 수수료
  amendment_fee NUMERIC(15,2),
  amendment_fee_currency_id UUID REFERENCES currency_types(currency_id),

  -- 상태
  status VARCHAR(20) DEFAULT 'pending',       -- pending, accepted, rejected

  -- 메타
  requested_by UUID REFERENCES users(user_id),
  requested_at_utc TIMESTAMPTZ DEFAULT NOW(),
  processed_at_utc TIMESTAMPTZ
);

CREATE INDEX idx_trade_lc_amendments_lc ON trade_lc_amendments(lc_id);
```

### 5.7 trade_shipments (선적)

```sql
CREATE TABLE trade_shipments (
  shipment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shipment_number VARCHAR(50) NOT NULL,       -- TS-2025-0001
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 연결
  lc_id UUID REFERENCES trade_letters_of_credit(lc_id),
  po_id UUID REFERENCES trade_purchase_orders(po_id),

  -- 운송 정보
  shipping_method_code VARCHAR(20),           -- sea, air...
  carrier_name VARCHAR(200),                  -- 선사/항공사명

  -- 해상 운송
  vessel_name VARCHAR(200),
  voyage_number VARCHAR(50),
  bl_number VARCHAR(100),                     -- B/L 번호
  bl_date_utc TIMESTAMPTZ,                    -- B/L 날짜 (On Board Date)
  bl_type VARCHAR(30),                        -- original, surrendered, express
  container_numbers JSONB,                    -- ["ABCD1234567", "EFGH7654321"]
  container_count INTEGER,

  -- 항공 운송
  awb_number VARCHAR(100),
  flight_number VARCHAR(50),

  -- 항구/공항
  port_of_loading VARCHAR(200),
  port_of_discharge VARCHAR(200),
  place_of_receipt VARCHAR(200),
  place_of_delivery VARCHAR(200),

  -- 날짜
  booking_date_utc TIMESTAMPTZ,
  shipped_date_utc TIMESTAMPTZ,               -- On-board date
  eta_utc TIMESTAMPTZ,                        -- 예정 도착일
  ata_utc TIMESTAMPTZ,                        -- 실제 도착일

  -- 화물 정보
  total_packages INTEGER,
  package_type VARCHAR(50),                   -- carton, pallet, drum...
  total_gross_weight_kg NUMERIC(15,3),
  total_net_weight_kg NUMERIC(15,3),
  total_cbm NUMERIC(15,3),

  -- 운임
  freight_terms_code VARCHAR(30),             -- prepaid, collect
  freight_amount NUMERIC(15,2),
  freight_currency_id UUID REFERENCES currency_types(currency_id),

  -- 마크
  shipping_marks TEXT,

  -- 보험
  insurance_value NUMERIC(15,2),
  insurance_currency_id UUID REFERENCES currency_types(currency_id),
  insurance_policy_number VARCHAR(100),

  -- 상태
  status VARCHAR(30) DEFAULT 'draft',

  notes TEXT,

  -- 메타
  created_by UUID REFERENCES users(user_id),
  created_at_utc TIMESTAMPTZ DEFAULT NOW(),
  updated_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_shipment_company ON trade_shipments(company_id);
CREATE INDEX idx_trade_shipment_lc ON trade_shipments(lc_id);
CREATE INDEX idx_trade_shipment_po ON trade_shipments(po_id);
CREATE INDEX idx_trade_shipment_status ON trade_shipments(status);
CREATE INDEX idx_trade_shipment_date ON trade_shipments(shipped_date_utc);
```

### 5.8 trade_shipment_items (선적 품목)

```sql
CREATE TABLE trade_shipment_items (
  item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shipment_id UUID NOT NULL REFERENCES trade_shipments(shipment_id) ON DELETE CASCADE,

  -- PO 아이템 연결
  po_item_id UUID REFERENCES trade_po_items(item_id),
  product_id UUID REFERENCES inventory_products(product_id),

  -- 품목 정보
  description TEXT NOT NULL,
  sku VARCHAR(100),
  hs_code VARCHAR(20),
  country_of_origin VARCHAR(100),

  -- 수량
  quantity_shipped NUMERIC(15,3) NOT NULL,
  unit VARCHAR(50),

  -- 포장
  carton_count INTEGER,
  net_weight_kg NUMERIC(15,3),
  gross_weight_kg NUMERIC(15,3),
  cbm NUMERIC(15,3),

  -- 금액 (CI용)
  unit_price NUMERIC(15,4),
  total_amount NUMERIC(15,2),

  sort_order INTEGER DEFAULT 0,
  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_shipment_items_shipment ON trade_shipment_items(shipment_id);
CREATE INDEX idx_trade_shipment_items_po_item ON trade_shipment_items(po_item_id);
```

### 5.9 trade_commercial_invoices (CI - 은행 제출용 인보이스)

```sql
CREATE TABLE trade_commercial_invoices (
  ci_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ci_number VARCHAR(50) NOT NULL,             -- TCI-2025-0001
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 연결
  lc_id UUID REFERENCES trade_letters_of_credit(lc_id),
  shipment_id UUID REFERENCES trade_shipments(shipment_id),

  -- 당사자 정보
  buyer_id UUID REFERENCES counterparties(counterparty_id),
  buyer_info JSONB,
  seller_info JSONB,

  -- 금액
  currency_id UUID REFERENCES currency_types(currency_id),
  subtotal NUMERIC(15,2) DEFAULT 0,
  discount_amount NUMERIC(15,2) DEFAULT 0,
  tax_amount NUMERIC(15,2) DEFAULT 0,
  freight_amount NUMERIC(15,2) DEFAULT 0,
  insurance_amount NUMERIC(15,2) DEFAULT 0,
  total_amount NUMERIC(15,2) NOT NULL,

  -- 거래 조건
  incoterms_code VARCHAR(3),
  incoterms_place VARCHAR(200),
  payment_terms_code VARCHAR(30),

  -- L/C 참조 (은행 제출 시 필수)
  lc_number VARCHAR(100),
  lc_date TIMESTAMPTZ,
  issuing_bank_name VARCHAR(200),

  -- 인보이스 날짜
  invoice_date_utc TIMESTAMPTZ DEFAULT NOW(),

  -- 은행 제출
  bank_submission_date_utc TIMESTAMPTZ,
  bank_status VARCHAR(30) DEFAULT 'pending',
  bank_reference_number VARCHAR(100),

  -- 불일치 (Discrepancy)
  has_discrepancy BOOLEAN DEFAULT false,
  discrepancy_count INTEGER DEFAULT 0,
  discrepancy_notes TEXT,

  -- 결제
  payment_due_date_utc TIMESTAMPTZ,
  payment_received_date_utc TIMESTAMPTZ,
  payment_amount NUMERIC(15,2),

  -- 상태
  status VARCHAR(30) DEFAULT 'draft',

  notes TEXT,

  -- 메타
  created_by UUID REFERENCES users(user_id),
  created_at_utc TIMESTAMPTZ DEFAULT NOW(),
  updated_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_ci_company ON trade_commercial_invoices(company_id);
CREATE INDEX idx_trade_ci_lc ON trade_commercial_invoices(lc_id);
CREATE INDEX idx_trade_ci_shipment ON trade_commercial_invoices(shipment_id);
CREATE INDEX idx_trade_ci_status ON trade_commercial_invoices(status);
CREATE INDEX idx_trade_ci_bank_status ON trade_commercial_invoices(bank_status);
```

### 5.10 trade_ci_items (CI 품목)

```sql
CREATE TABLE trade_ci_items (
  item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ci_id UUID NOT NULL REFERENCES trade_commercial_invoices(ci_id) ON DELETE CASCADE,

  -- 선적 아이템 연결
  shipment_item_id UUID REFERENCES trade_shipment_items(item_id),
  product_id UUID REFERENCES inventory_products(product_id),

  -- 품목 정보 (L/C 문구와 정확히 일치해야 함!)
  description TEXT NOT NULL,
  sku VARCHAR(100),
  hs_code VARCHAR(20),
  country_of_origin VARCHAR(100),

  -- 수량/금액
  quantity NUMERIC(15,3) NOT NULL,
  unit VARCHAR(50),
  unit_price NUMERIC(15,4) NOT NULL,
  total_amount NUMERIC(15,2) NOT NULL,

  sort_order INTEGER DEFAULT 0,
  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_ci_items_ci ON trade_ci_items(ci_id);
```

### 5.11 trade_documents (첨부 서류)

```sql
CREATE TABLE trade_documents (
  document_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 연결 (어떤 것에 첨부?)
  reference_type VARCHAR(30) NOT NULL,        -- pi, po, lc, shipment, ci
  reference_id UUID NOT NULL,

  -- 서류 종류
  document_type_code VARCHAR(50) NOT NULL,    -- trade_document_types.code

  -- 서류 정보
  document_number VARCHAR(100),
  document_date TIMESTAMPTZ,

  -- 원본/사본
  is_original BOOLEAN DEFAULT false,
  original_copies INTEGER DEFAULT 0,          -- 원본 부수
  copy_copies INTEGER DEFAULT 0,              -- 사본 부수

  -- 파일
  file_name VARCHAR(500),
  file_url TEXT,
  file_size_bytes BIGINT,
  mime_type VARCHAR(100),

  -- 검증
  is_verified BOOLEAN DEFAULT false,
  verified_by UUID REFERENCES users(user_id),
  verified_at_utc TIMESTAMPTZ,
  verification_notes TEXT,

  notes TEXT,

  -- 메타
  uploaded_by UUID REFERENCES users(user_id),
  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_documents_company ON trade_documents(company_id);
CREATE INDEX idx_trade_documents_ref ON trade_documents(reference_type, reference_id);
CREATE INDEX idx_trade_documents_type ON trade_documents(document_type_code);
```

### 5.12 trade_payments (결제 기록)

```sql
CREATE TABLE trade_payments (
  payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 연결
  lc_id UUID REFERENCES trade_letters_of_credit(lc_id),
  ci_id UUID REFERENCES trade_commercial_invoices(ci_id),

  -- 결제 정보
  payment_type VARCHAR(30),                   -- lc_at_sight, lc_usance, tt, advance
  payment_method VARCHAR(30),                 -- wire_transfer, check, cash
  payment_date_utc TIMESTAMPTZ,

  -- 금액
  currency_id UUID REFERENCES currency_types(currency_id),
  amount NUMERIC(15,2) NOT NULL,

  -- 수수료/공제
  bank_charges NUMERIC(15,2) DEFAULT 0,
  other_deductions NUMERIC(15,2) DEFAULT 0,
  net_amount NUMERIC(15,2),                   -- 실수령액

  -- 환율 (외화인 경우)
  exchange_rate NUMERIC(15,6),
  base_currency_id UUID REFERENCES currency_types(currency_id),
  base_currency_amount NUMERIC(15,2),

  -- 은행 정보
  remitting_bank VARCHAR(200),
  receiving_bank VARCHAR(200),
  reference_number VARCHAR(100),

  -- 회계 연결
  journal_id UUID REFERENCES journal_entries(journal_id),

  -- 상태
  status VARCHAR(20) DEFAULT 'pending',

  notes TEXT,

  -- 메타
  created_by UUID REFERENCES users(user_id),
  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_payments_company ON trade_payments(company_id);
CREATE INDEX idx_trade_payments_lc ON trade_payments(lc_id);
CREATE INDEX idx_trade_payments_ci ON trade_payments(ci_id);
CREATE INDEX idx_trade_payments_status ON trade_payments(status);
CREATE INDEX idx_trade_payments_date ON trade_payments(payment_date_utc);
```

---

## 6. 로깅/감사 테이블

### 6.1 trade_activity_logs (전체 활동 로그)

```sql
CREATE TABLE trade_activity_logs (
  log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 대상
  entity_type VARCHAR(30) NOT NULL,           -- pi, po, lc, shipment, ci, payment, document
  entity_id UUID NOT NULL,
  entity_number VARCHAR(100),                 -- PI-2025-0001 등

  -- 활동
  action VARCHAR(50) NOT NULL,                -- created, updated, deleted, viewed,
                                              -- status_changed, submitted, approved, rejected,
                                              -- document_uploaded, document_deleted,
                                              -- amount_changed, amendment_requested, etc.

  -- 상세
  action_detail TEXT,

  -- 상태 변경 (status_changed인 경우)
  previous_status VARCHAR(30),
  new_status VARCHAR(30),

  -- 변경된 필드들 (update인 경우)
  changes JSONB,                              -- {"field": {"old": "...", "new": "..."}}

  -- 접속 정보
  ip_address INET,
  user_agent TEXT,
  session_id VARCHAR(100),

  -- 메타
  created_by UUID REFERENCES users(user_id),
  created_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_logs_company ON trade_activity_logs(company_id);
CREATE INDEX idx_trade_logs_entity ON trade_activity_logs(entity_type, entity_id);
CREATE INDEX idx_trade_logs_action ON trade_activity_logs(action);
CREATE INDEX idx_trade_logs_date ON trade_activity_logs(created_at_utc);
CREATE INDEX idx_trade_logs_user ON trade_activity_logs(created_by);
```

### 6.2 trade_status_history (상태 변경 이력)

```sql
CREATE TABLE trade_status_history (
  history_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 대상
  entity_type VARCHAR(30) NOT NULL,
  entity_id UUID NOT NULL,
  entity_number VARCHAR(100),

  -- 상태 변경
  from_status VARCHAR(30),
  to_status VARCHAR(30) NOT NULL,

  -- 사유
  reason VARCHAR(100),                        -- user_action, system_auto, external_update
  notes TEXT,

  -- 관련 문서 (있는 경우)
  related_document_id UUID,

  -- 지속 시간 (이전 상태에서 머문 시간)
  duration_minutes INTEGER,

  -- 메타
  changed_by UUID REFERENCES users(user_id),
  changed_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_status_history_entity ON trade_status_history(entity_type, entity_id);
CREATE INDEX idx_trade_status_history_date ON trade_status_history(changed_at_utc);
CREATE INDEX idx_trade_status_history_status ON trade_status_history(to_status);
```

### 6.3 trade_document_logs (서류 활동 로그)

```sql
CREATE TABLE trade_document_logs (
  log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 문서 정보
  document_id UUID NOT NULL,
  document_type_code VARCHAR(50),
  document_number VARCHAR(100),

  -- 연결된 엔티티
  entity_type VARCHAR(30),
  entity_id UUID,

  -- 활동
  action VARCHAR(30) NOT NULL,                -- uploaded, downloaded, viewed, deleted,
                                              -- verified, rejected, sent_to_bank,
                                              -- revision_uploaded

  action_detail TEXT,

  -- 메타
  performed_by UUID REFERENCES users(user_id),
  performed_at_utc TIMESTAMPTZ DEFAULT NOW(),
  ip_address INET
);

CREATE INDEX idx_trade_doc_logs_document ON trade_document_logs(document_id);
CREATE INDEX idx_trade_doc_logs_entity ON trade_document_logs(entity_type, entity_id);
CREATE INDEX idx_trade_doc_logs_date ON trade_document_logs(performed_at_utc);
```

### 6.4 trade_discrepancy_logs (불일치 기록)

```sql
CREATE TABLE trade_discrepancy_logs (
  discrepancy_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 연결
  lc_id UUID REFERENCES trade_letters_of_credit(lc_id),
  ci_id UUID REFERENCES trade_commercial_invoices(ci_id),
  document_id UUID REFERENCES trade_documents(document_id),

  -- 불일치 유형
  discrepancy_type VARCHAR(50) NOT NULL,
    -- amount_mismatch: 금액 불일치
    -- quantity_mismatch: 수량 불일치
    -- description_mismatch: 품목 설명 불일치
    -- date_expired: 날짜 만료 (선적일, 만료일 등)
    -- date_late: 서류 제출 지연
    -- document_missing: 필수 서류 누락
    -- document_inconsistent: 서류 간 불일치
    -- name_mismatch: 상호/이름 불일치
    -- address_mismatch: 주소 불일치
    -- weight_mismatch: 중량 불일치
    -- port_mismatch: 항구명 불일치
    -- signature_missing: 서명 누락
    -- endorsement_missing: 배서 누락
    -- bl_clause_issue: B/L 조항 문제
    -- other: 기타

  -- 심각도
  severity VARCHAR(20) DEFAULT 'major',       -- minor, major, fatal

  -- 불일치 상세
  field_name VARCHAR(100),                    -- 문제가 된 필드명
  document_name VARCHAR(100),                 -- 문제가 된 서류명
  expected_value TEXT,                        -- L/C에 명시된 값
  actual_value TEXT,                          -- 실제 서류의 값

  description TEXT,                           -- 상세 설명
  bank_comment TEXT,                          -- 은행 코멘트

  -- 해결
  resolution_status VARCHAR(20) DEFAULT 'open',
    -- open: 미해결
    -- in_progress: 처리 중
    -- resolved: 해결됨
    -- waived: 면제됨 (바이어 승인)
    -- rejected: 거절됨

  resolution_method VARCHAR(50),
    -- document_corrected: 서류 수정
    -- amendment_issued: L/C 조건변경
    -- buyer_waiver: 바이어 면제 승인
    -- bank_acceptance: 은행 수용
    -- not_applicable: 해당없음

  resolution_notes TEXT,

  resolved_by UUID REFERENCES users(user_id),
  resolved_at_utc TIMESTAMPTZ,

  -- 비용 (수수료 등)
  discrepancy_fee NUMERIC(15,2),
  discrepancy_fee_currency_id UUID REFERENCES currency_types(currency_id),

  -- 메타
  reported_by UUID REFERENCES users(user_id),
  reported_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_discrepancy_lc ON trade_discrepancy_logs(lc_id);
CREATE INDEX idx_trade_discrepancy_ci ON trade_discrepancy_logs(ci_id);
CREATE INDEX idx_trade_discrepancy_status ON trade_discrepancy_logs(resolution_status);
CREATE INDEX idx_trade_discrepancy_type ON trade_discrepancy_logs(discrepancy_type);
```

### 6.5 trade_amount_history (금액 변경 이력)

```sql
CREATE TABLE trade_amount_history (
  history_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 대상
  entity_type VARCHAR(30) NOT NULL,
  entity_id UUID NOT NULL,
  entity_number VARCHAR(100),

  -- 금액 변경
  currency_id UUID REFERENCES currency_types(currency_id),
  field_name VARCHAR(50),                     -- total_amount, discount_amount, freight_amount...
  previous_amount NUMERIC(15,2),
  new_amount NUMERIC(15,2),
  difference NUMERIC(15,2),

  -- 사유
  reason VARCHAR(50),
    -- quantity_change: 수량 변경
    -- price_change: 단가 변경
    -- discount_applied: 할인 적용
    -- discount_removed: 할인 제거
    -- amendment: L/C 조건변경
    -- correction: 오류 수정
    -- freight_added: 운임 추가
    -- insurance_added: 보험료 추가

  notes TEXT,

  -- 메타
  changed_by UUID REFERENCES users(user_id),
  changed_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_trade_amount_history_entity ON trade_amount_history(entity_type, entity_id);
CREATE INDEX idx_trade_amount_history_date ON trade_amount_history(changed_at_utc);
```

---

## 7. 알림 테이블

### 7.1 trade_alerts (알림/리마인더)

```sql
CREATE TABLE trade_alerts (
  alert_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(company_id),

  -- 대상
  entity_type VARCHAR(30) NOT NULL,
  entity_id UUID NOT NULL,
  entity_number VARCHAR(100),

  -- 알림 종류
  alert_type VARCHAR(50) NOT NULL,
    -- lc_expiry_warning: L/C 만료 임박
    -- lc_expired: L/C 만료됨
    -- shipment_deadline_warning: 선적 기한 임박
    -- shipment_deadline_passed: 선적 기한 경과
    -- presentation_deadline_warning: 서류제출 기한 임박
    -- presentation_deadline_passed: 서류제출 기한 경과
    -- payment_due_warning: 결제일 임박
    -- payment_due: 결제일 도래
    -- payment_received: 결제 수령됨
    -- document_missing: 필수 서류 누락
    -- document_expiring: 서류 유효기간 만료 임박
    -- discrepancy_found: 불일치 발견
    -- discrepancy_resolved: 불일치 해결됨
    -- status_changed: 상태 변경됨
    -- amendment_received: L/C 조건변경 수신
    -- action_required: 조치 필요

  -- 알림 내용
  title VARCHAR(200) NOT NULL,
  message TEXT,
  action_url VARCHAR(500),                    -- 클릭 시 이동할 경로

  -- 마감 날짜
  due_date_utc TIMESTAMPTZ,
  days_before_due INTEGER,                    -- 며칠 전 알림인지

  -- 우선순위
  priority VARCHAR(10) DEFAULT 'medium',      -- low, medium, high, urgent

  -- 상태
  is_read BOOLEAN DEFAULT false,
  is_dismissed BOOLEAN DEFAULT false,
  is_resolved BOOLEAN DEFAULT false,

  -- 자동 생성 여부
  is_system_generated BOOLEAN DEFAULT true,

  -- 대상 사용자
  assigned_to UUID REFERENCES users(user_id),

  -- 반복 알림 방지
  alert_key VARCHAR(200),                     -- 중복 방지 키 (entity_type + entity_id + alert_type)

  -- 메타
  created_at_utc TIMESTAMPTZ DEFAULT NOW(),
  read_at_utc TIMESTAMPTZ,
  dismissed_at_utc TIMESTAMPTZ,
  resolved_at_utc TIMESTAMPTZ,

  UNIQUE(company_id, alert_key, is_resolved)  -- 미해결 알림 중복 방지
);

CREATE INDEX idx_trade_alerts_company ON trade_alerts(company_id);
CREATE INDEX idx_trade_alerts_user ON trade_alerts(assigned_to);
CREATE INDEX idx_trade_alerts_unread ON trade_alerts(company_id, is_read, is_dismissed) WHERE is_read = false AND is_dismissed = false;
CREATE INDEX idx_trade_alerts_due ON trade_alerts(due_date_utc);
CREATE INDEX idx_trade_alerts_priority ON trade_alerts(priority);
CREATE INDEX idx_trade_alerts_entity ON trade_alerts(entity_type, entity_id);
```

---

## 8. 인덱스 전략

### 8.1 인덱스 요약

| 테이블 | 인덱스 | 용도 |
|--------|--------|------|
| 모든 테이블 | `company_id` | 회사별 필터링 |
| 거래 테이블 | `status` | 상태별 조회 |
| 거래 테이블 | `*_number` | 문서 번호 검색 |
| L/C | `expiry_date_utc` | 만료일 알림 |
| Shipment | `shipped_date_utc` | 선적일 기준 조회 |
| 로그 테이블 | `created_at_utc` | 시간순 조회 |
| 로그 테이블 | `entity_type, entity_id` | 엔티티별 로그 조회 |
| Alerts | `is_read, is_dismissed` | 미확인 알림 조회 |

### 8.2 복합 인덱스

```sql
-- 자주 사용되는 복합 조건
CREATE INDEX idx_trade_pi_company_status ON trade_proforma_invoices(company_id, status);
CREATE INDEX idx_trade_lc_company_status ON trade_letters_of_credit(company_id, status);
CREATE INDEX idx_trade_ci_company_bank_status ON trade_commercial_invoices(company_id, bank_status);
CREATE INDEX idx_trade_alerts_company_unresolved ON trade_alerts(company_id, priority) WHERE is_resolved = false;
```

---

## 9. 기존 테이블 연결

### 9.1 참조 테이블

| 기존 테이블 | 용도 | 연결 필드 |
|------------|------|----------|
| `companies` | 회사 | `company_id` |
| `stores` | 매장/창고 | `store_id` |
| `counterparties` | 거래처 (바이어, 은행) | `*_id` |
| `currency_types` | 통화 | `currency_id` |
| `inventory_products` | 상품 | `product_id` |
| `users` | 사용자 | `created_by`, `*_by` |
| `journal_entries` | 분개장 | `journal_id` |

### 9.2 counterparties 확장

L/C 시스템을 위해 `counterparties` 테이블의 `type` 필드에 추가 값이 필요합니다:

```sql
-- counterparties.type에 추가할 값들
-- 'Buyer' - 바이어
-- 'Supplier' - 공급자/공장
-- 'Bank' - 은행 (개설은행, 통지은행, 확인은행)
-- 'Shipping_Company' - 선사/운송사
-- 'Insurance_Company' - 보험사
-- 'Inspection_Agency' - 검사기관
```

---

## 변경 이력

| 버전 | 날짜 | 변경 내용 |
|------|------|----------|
| 1.0.0 | 2025-12-26 | 최초 작성 |

---

> **다음 단계**: [WORKFLOW](./TRADE_LC_WORKFLOW.md)를 참조하여 상태 흐름을 확인하세요.
