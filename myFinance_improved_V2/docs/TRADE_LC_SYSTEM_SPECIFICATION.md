# L/C Trade Management System - 완전 명세서

> **Version**: 1.0.0
> **Created**: 2025-12-26
> **Last Updated**: 2025-12-26
> **Author**: System Architect

---

## 목차

1. [개요](#1-개요)
2. [시스템 목표](#2-시스템-목표)
3. [워크플로우 요약](#3-워크플로우-요약)
4. [핵심 개념 (15살도 이해하는 버전)](#4-핵심-개념-15살도-이해하는-버전)
5. [문서 구조](#5-문서-구조)
6. [기술 스택](#6-기술-스택)
7. [관련 문서 링크](#7-관련-문서-링크)

---

## 1. 개요

### 1.1 L/C(Letter of Credit)란?

**한 문장 정의:**
> 바이어의 은행이 돈을 "금고에 잠가두고", 정해진 서류를 정확히 맞춰오면 판매자에게 돈을 풀어주는 결제 시스템

### 1.2 왜 이 시스템이 필요한가?

| 문제 | 해결책 |
|------|--------|
| L/C 워크플로우가 복잡함 | 단계별 가이드 및 자동화 |
| 서류 불일치로 돈 못 받음 | 자동 검증 및 경고 |
| 마감일 놓침 | 알림/리마인더 시스템 |
| 진행 상황 파악 어려움 | 실시간 대시보드 |
| 수작업으로 문서 관리 | 통합 문서 관리 |

### 1.3 시스템 범위

```
┌─────────────────────────────────────────────────────────────────┐
│                    Trade Management System                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ 포함 (In Scope)                                             │
│  ├── PI (Proforma Invoice) 생성/관리                            │
│  ├── PO (Purchase Order) 관리                                   │
│  ├── L/C (Letter of Credit) 등록/추적                           │
│  ├── Shipment (선적) 관리                                       │
│  ├── CI (Commercial Invoice) 생성                               │
│  ├── 서류 첨부/관리                                              │
│  ├── 결제 추적                                                   │
│  ├── 활동 로그 및 감사                                           │
│  └── 알림/리마인더                                               │
│                                                                 │
│  ❌ 제외 (Out of Scope)                                         │
│  ├── 은행 시스템 직접 연동 (SWIFT 등)                            │
│  ├── 실제 결제 처리                                              │
│  └── 통관 시스템 연동                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. 시스템 목표

### 2.1 핵심 목표

| # | 목표 | 측정 지표 |
|---|------|----------|
| 1 | L/C 거래 전체 라이프사이클 관리 | 모든 단계 추적 가능 |
| 2 | 서류 불일치(Discrepancy) 최소화 | 자동 검증으로 오류 감지 |
| 3 | 마감일 준수 | 알림으로 0% 지연 |
| 4 | 투명한 진행 상황 공유 | 실시간 대시보드 |
| 5 | 완전한 감사 추적 | 모든 활동 로깅 |

### 2.2 사용자 역할

| 역할 | 주요 작업 |
|------|----------|
| **영업팀** | PI 생성, 바이어 소통 |
| **무역팀** | L/C 확인, 서류 준비, 은행 제출 |
| **물류팀** | 선적 관리, B/L 입력 |
| **재무팀** | 결제 추적, 회계 연동 |
| **관리자** | 전체 현황 모니터링, 보고서 |

---

## 3. 워크플로우 요약

### 3.1 전체 흐름도

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         L/C Trade 전체 워크플로우                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐              │
│  │   PI    │───▶│   PO    │───▶│   L/C   │───▶│ Shipment│              │
│  │  견적서  │    │  주문서  │    │  신용장  │    │   선적   │              │
│  └─────────┘    └─────────┘    └─────────┘    └─────────┘              │
│       │              │              │              │                    │
│       ▼              ▼              ▼              ▼                    │
│  ┌─────────────────────────────────────────────────────┐               │
│  │                    서류 준비                          │               │
│  │  Commercial Invoice + Packing List + B/L + COO + ... │               │
│  └─────────────────────────────────────────────────────┘               │
│                              │                                          │
│                              ▼                                          │
│                      ┌─────────────┐                                    │
│                      │  CI 생성    │                                    │
│                      │ (은행 제출용) │                                    │
│                      └─────────────┘                                    │
│                              │                                          │
│                              ▼                                          │
│                      ┌─────────────┐                                    │
│                      │  은행 제출   │                                    │
│                      └─────────────┘                                    │
│                              │                                          │
│              ┌───────────────┼───────────────┐                          │
│              ▼               ▼               ▼                          │
│       ┌──────────┐   ┌──────────┐    ┌──────────┐                      │
│       │ Accepted │   │Discrepancy│    │ Rejected │                      │
│       │   승인   │   │  불일치   │    │   거절   │                      │
│       └──────────┘   └──────────┘    └──────────┘                      │
│              │               │                                          │
│              ▼               ▼                                          │
│       ┌──────────┐   ┌──────────┐                                      │
│       │ Payment  │   │  수정 후  │                                      │
│       │  결제    │   │  재제출   │                                      │
│       └──────────┘   └──────────┘                                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2 단계별 상세

| 단계 | 설명 | 생성 문서 | 시스템 기능 |
|------|------|----------|------------|
| **1. PI 생성** | 바이어에게 견적 제시 | Proforma Invoice | 상품 선택, Terms 설정 |
| **2. PO 확정** | 바이어 주문 확정 | Purchase Order | PI 기반 자동 생성 |
| **3. L/C 등록** | 은행에서 L/C 수령 | Letter of Credit | 조건 검증, 요구서류 체크 |
| **4. 선적** | 물건 실제 배송 | B/L, Packing List | 선적 정보 입력 |
| **5. CI 생성** | 은행 제출용 인보이스 | Commercial Invoice | L/C 조건 일치 검증 |
| **6. 서류 제출** | 은행에 서류 세트 제출 | Document Set | 서류 체크리스트 |
| **7. 결제** | 대금 수령 | Payment Record | 회계 연동 |

---

## 4. 핵심 개념 (15살도 이해하는 버전)

### 4.1 L/C가 뭐야?

**비유: 숙제 검사 시스템**

```
일반 거래:
  물건 보냄 → 돈 달라 → (믿을 수 있나...?) → 돈 받음(또는 못 받음)

L/C 거래:
  은행이 돈을 금고에 잠금 → 숙제(서류) 제출 → 검사 통과 → 돈 받음
```

### 4.2 주요 용어 쉬운 설명

| 용어 | 쉬운 설명 | 비유 |
|------|----------|------|
| **PI (Proforma Invoice)** | 가격표 + 조건표 | "이 조건으로 살래요?" |
| **PO (Purchase Order)** | 공식 주문서 | "네, 이걸로 주문할게요" |
| **L/C (Letter of Credit)** | 은행의 규칙서 | "이 서류 맞으면 돈 줄게" |
| **B/L (Bill of Lading)** | 운송 증거 | "물건이 배에 실렸어요" |
| **CI (Commercial Invoice)** | 최종 청구서 | "은행에 제출하는 서류 세트" |
| **Discrepancy** | 서류 불일치 | "숙제 틀린 부분 있어요" |

### 4.3 거래 조건 쉬운 설명

#### Incoterms (누가 배송비/책임 지나?)

| 조건 | 쉬운 설명 | 비유 |
|------|----------|------|
| **FOB** | 배에 실으면 내 할 일 끝 | "택배 편의점에 맡기면 끝" |
| **CIF** | 배송비+보험까지 내가 부담 | "집 앞까지 배달비 포함" |
| **DDP** | 모든 비용 내가 부담 | "관세까지 다 내가 냄" |

#### Payment Terms (돈을 언제 받나?)

| 조건 | 쉬운 설명 | 비유 |
|------|----------|------|
| **At Sight** | 서류 맞으면 바로 돈 | "숙제 통과 = 바로 용돈" |
| **Usance 60** | 서류 OK인데 60일 후 돈 | "숙제 통과, 용돈은 다음 달" |

---

## 5. 문서 구조

### 5.1 관련 문서 목록

```
docs/
├── TRADE_LC_SYSTEM_SPECIFICATION.md    ← 현재 문서 (전체 개요)
├── TRADE_LC_DATABASE_SCHEMA.md         ← 데이터베이스 스키마
├── TRADE_LC_WORKFLOW.md                ← 워크플로우 상세
├── TRADE_LC_TERMS_REFERENCE.md         ← 용어 및 Terms 정의
└── TRADE_LC_API_SPECIFICATION.md       ← RPC 함수 명세
```

### 5.2 각 문서 역할

| 문서 | 대상 독자 | 내용 |
|------|----------|------|
| **SYSTEM_SPECIFICATION** | 모두 | 전체 개요, 목표, 범위 |
| **DATABASE_SCHEMA** | 개발자, DBA | 테이블 구조, ERD, 인덱스 |
| **WORKFLOW** | 기획자, 개발자 | 상태 흐름, 비즈니스 로직 |
| **TERMS_REFERENCE** | 모두 | 모든 Terms 정의, 옵션 값 |
| **API_SPECIFICATION** | 개발자 | RPC 함수, 파라미터, 응답 |

---

## 6. 기술 스택

### 6.1 백엔드

| 기술 | 용도 |
|------|------|
| **Supabase (PostgreSQL)** | 데이터베이스 |
| **Supabase RPC** | 서버 로직 |
| **Supabase Storage** | 문서 파일 저장 |

### 6.2 프론트엔드

| 기술 | 용도 |
|------|------|
| **Flutter** | 모바일 앱 |
| **Riverpod** | 상태 관리 |
| **Freezed** | 불변 상태 객체 |

### 6.3 폴더 구조 (Flutter)

```
lib/features/trade_management/
├── di/
│   └── trade_providers.dart
├── domain/
│   ├── entities/
│   │   ├── proforma_invoice.dart
│   │   ├── purchase_order.dart
│   │   ├── letter_of_credit.dart
│   │   ├── shipment.dart
│   │   ├── commercial_invoice.dart
│   │   └── trade_document.dart
│   ├── repositories/
│   │   ├── pi_repository.dart
│   │   ├── po_repository.dart
│   │   ├── lc_repository.dart
│   │   ├── shipment_repository.dart
│   │   └── ci_repository.dart
│   └── usecases/
│       ├── create_pi_usecase.dart
│       ├── convert_pi_to_po_usecase.dart
│       └── ...
├── data/
│   ├── datasources/
│   │   └── trade_remote_datasource.dart
│   ├── repositories/
│   │   └── *_repository_impl.dart
│   └── models/
│       └── *_model.dart
└── presentation/
    ├── pages/
    │   ├── trade_dashboard_page.dart
    │   ├── pi_list_page.dart
    │   ├── pi_create_page.dart
    │   ├── lc_detail_page.dart
    │   └── ...
    ├── providers/
    │   ├── pi_provider.dart
    │   ├── lc_provider.dart
    │   └── ...
    └── widgets/
        ├── trade_timeline_widget.dart
        ├── document_checklist_widget.dart
        └── ...
```

---

## 7. 관련 문서 링크

### 7.1 내부 문서

- [📊 DATABASE_SCHEMA](./TRADE_LC_DATABASE_SCHEMA.md) - 데이터베이스 스키마
- [🔄 WORKFLOW](./TRADE_LC_WORKFLOW.md) - 워크플로우 상세
- [📖 TERMS_REFERENCE](./TRADE_LC_TERMS_REFERENCE.md) - 용어 정의
- [�� API_SPECIFICATION](./TRADE_LC_API_SPECIFICATION.md) - API 명세

### 7.2 외부 참조

- [Incoterms 2020 - ICC](https://iccwbo.org/business-solutions/incoterms-rules/incoterms-2020/)
- [UCP 600 - Documentary Credits](https://iccwbo.org/business-solutions/banking-finance/ucp-600/)
- [HS Code - WCO](https://www.wcoomd.org/en/topics/nomenclature/overview/what-is-the-harmonized-system.aspx)

---

## 변경 이력

| 버전 | 날짜 | 변경 내용 | 작성자 |
|------|------|----------|--------|
| 1.0.0 | 2025-12-26 | 최초 작성 | System Architect |

---

> **다음 단계**: [DATABASE_SCHEMA](./TRADE_LC_DATABASE_SCHEMA.md)를 참조하여 데이터베이스 구조를 확인하세요.
