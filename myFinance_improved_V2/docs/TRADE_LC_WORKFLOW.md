# L/C Trade Management System - Workflow & Status

> **Version**: 1.0.0
> **Created**: 2025-12-26
> **Last Updated**: 2025-12-26

---

## 목차

1. [전체 워크플로우](#1-전체-워크플로우)
2. [PI (Proforma Invoice) 워크플로우](#2-pi-proforma-invoice-워크플로우)
3. [PO (Purchase Order) 워크플로우](#3-po-purchase-order-워크플로우)
4. [L/C (Letter of Credit) 워크플로우](#4-lc-letter-of-credit-워크플로우)
5. [Shipment 워크플로우](#5-shipment-워크플로우)
6. [CI (Commercial Invoice) 워크플로우](#6-ci-commercial-invoice-워크플로우)
7. [Payment 워크플로우](#7-payment-워크플로우)
8. [상태 전이 규칙](#8-상태-전이-규칙)
9. [자동화 트리거](#9-자동화-트리거)

---

## 1. 전체 워크플로우

### 1.1 End-to-End 프로세스

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           L/C TRADE WORKFLOW                                     │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   PHASE 1: PRE-SHIPMENT (선적 전)                                               │
│   ════════════════════════════════                                              │
│                                                                                 │
│   ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐                 │
│   │  Start  │────▶│ Create  │────▶│  Send   │────▶│ Buyer   │                 │
│   │         │     │   PI    │     │ to Buyer│     │ Review  │                 │
│   └─────────┘     └─────────┘     └─────────┘     └────┬────┘                 │
│                                                        │                        │
│                          ┌──────────────┬──────────────┤                        │
│                          ▼              ▼              ▼                        │
│                   ┌──────────┐   ┌──────────┐   ┌──────────┐                   │
│                   │ Accepted │   │Negotiating│   │ Rejected │                   │
│                   └────┬─────┘   └──────────┘   └──────────┘                   │
│                        │                                                        │
│                        ▼                                                        │
│                   ┌──────────┐                                                  │
│                   │ Create   │◀── (바이어가 PO 발행 또는 우리가 생성)              │
│                   │   PO     │                                                  │
│                   └────┬─────┘                                                  │
│                        │                                                        │
│                        ▼                                                        │
│                   ┌──────────┐                                                  │
│                   │ Receive  │◀── 바이어가 은행에서 L/C 오픈                       │
│                   │   L/C    │                                                  │
│                   └────┬─────┘                                                  │
│                        │                                                        │
│                        ▼                                                        │
│                   ┌──────────┐                                                  │
│                   │ Verify   │── L/C 조건 확인 (PI/PO와 일치?)                    │
│                   │   L/C    │                                                  │
│                   └────┬─────┘                                                  │
│                        │                                                        │
│         ┌──────────────┼──────────────┐                                         │
│         ▼              ▼              ▼                                         │
│   ┌──────────┐   ┌──────────┐   ┌──────────┐                                   │
│   │   OK     │   │ Request  │   │ Cannot   │                                   │
│   │          │   │Amendment │   │ Accept   │                                   │
│   └────┬─────┘   └────┬─────┘   └──────────┘                                   │
│        │              │                                                         │
│        ▼              ▼                                                         │
│   ┌──────────┐   ┌──────────┐                                                  │
│   │   Start  │   │ Amended  │                                                  │
│   │Production│   │   L/C    │                                                  │
│   └────┬─────┘   └────┬─────┘                                                  │
│        │              │                                                         │
│        └──────────────┘                                                         │
│                │                                                                │
│                ▼                                                                │
│                                                                                 │
│   PHASE 2: SHIPMENT (선적)                                                      │
│   ════════════════════════                                                      │
│                                                                                 │
│   ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐             │
│   │Production│────▶│  Ready   │────▶│  Book    │────▶│  Load    │             │
│   │ Complete │     │ to Ship  │     │ Shipping │     │ Cargo    │             │
│   └──────────┘     └──────────┘     └──────────┘     └────┬─────┘             │
│                                                           │                    │
│                                                           ▼                    │
│                                           ┌──────────────────────────┐         │
│                                           │  Get B/L (On Board Date) │         │
│                                           │  ⚠️ L/C 최종선적일 확인!  │         │
│                                           └────────────┬─────────────┘         │
│                                                        │                       │
│                                                        ▼                       │
│                                                                                 │
│   PHASE 3: DOCUMENT PRESENTATION (서류 제출)                                    │
│   ══════════════════════════════════════════                                    │
│                                                                                 │
│   ┌──────────┐     ┌──────────┐     ┌──────────┐                               │
│   │ Prepare  │────▶│  Create  │────▶│  Verify  │                               │
│   │  Docs    │     │   CI     │     │  Match   │                               │
│   └──────────┘     └──────────┘     └────┬─────┘                               │
│                                          │                                      │
│         ┌─────────────────────┬──────────┤                                      │
│         ▼                     ▼          ▼                                      │
│   ┌──────────┐         ┌──────────┐  ┌──────────┐                              │
│   │ All Match│         │Discrepancy│  │  Fatal   │                              │
│   │    ✓     │         │  Found   │  │  Error   │                              │
│   └────┬─────┘         └────┬─────┘  └──────────┘                              │
│        │                    │                                                   │
│        ▼                    ▼                                                   │
│   ┌──────────┐         ┌──────────┐                                            │
│   │ Submit   │         │  Fix &   │                                            │
│   │ to Bank  │         │ Re-check │                                            │
│   └────┬─────┘         └──────────┘                                            │
│        │                                                                        │
│        ▼                                                                        │
│   ┌──────────┐                                                                  │
│   │   Bank   │                                                                  │
│   │Examination│                                                                 │
│   └────┬─────┘                                                                  │
│        │                                                                        │
│        ├───────────────────────────────────┐                                    │
│        ▼                                   ▼                                    │
│   ┌──────────┐                       ┌──────────┐                              │
│   │ Accepted │                       │Discrepancy│                              │
│   │    ✓     │                       │  Notice  │                              │
│   └────┬─────┘                       └────┬─────┘                              │
│        │                                  │                                     │
│        │                    ┌─────────────┼─────────────┐                       │
│        │                    ▼             ▼             ▼                       │
│        │             ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│        │             │  Buyer   │  │  Correct │  │ Rejected │                  │
│        │             │  Waiver  │  │  & Resub │  │          │                  │
│        │             └────┬─────┘  └────┬─────┘  └──────────┘                  │
│        │                  │             │                                       │
│        └──────────────────┴─────────────┘                                       │
│                           │                                                     │
│                           ▼                                                     │
│                                                                                 │
│   PHASE 4: PAYMENT (결제)                                                       │
│   ═══════════════════════                                                       │
│                                                                                 │
│   ┌──────────────────────────────────────────────────────────────┐             │
│   │                                                              │             │
│   │  At Sight:  Documents OK ──────────▶ Immediate Payment      │             │
│   │                                                              │             │
│   │  Usance:    Documents OK ──────────▶ Wait X Days ──▶ Payment│             │
│   │                                                              │             │
│   └──────────────────────────────────────────────────────────────┘             │
│                           │                                                     │
│                           ▼                                                     │
│                      ┌──────────┐                                               │
│                      │   Done   │                                               │
│                      │    ✓     │                                               │
│                      └──────────┘                                               │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 타임라인 예시 (At Sight, FOB 기준)

```
Day 0      : PI 발송
Day 3      : 바이어 PI 승인
Day 5      : 바이어 PO 발행
Day 10     : L/C 수령
Day 12     : L/C 조건 확인 완료
Day 30-60  : 생산
Day 65     : 선적 완료 (B/L 발행)
Day 66-70  : 서류 준비 및 검토
Day 72     : 은행 서류 제출
Day 75-80  : 은행 심사
Day 82     : 서류 승인 → 결제 (At Sight)

※ Usance 60 Days인 경우: Day 82 + 60 = Day 142에 결제
```

---

## 2. PI (Proforma Invoice) 워크플로우

### 2.1 상태 흐름도

```
                    ┌──────────┐
                    │  draft   │◀──── 초기 상태
                    └────┬─────┘
                         │ [Send to Buyer]
                         ▼
                    ┌──────────┐
                    │   sent   │
                    └────┬─────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼
    ┌──────────┐   ┌──────────┐   ┌──────────┐
    │ accepted │   │negotiating│   │ rejected │
    └────┬─────┘   └──────────┘   └──────────┘
         │                             (최종)
         │ [Create PO]
         ▼
    ┌──────────┐
    │converted │ ──── 최종 상태
    └──────────┘

    * expired: 유효기간 경과 시 자동 전환
```

### 2.2 상태 정의

| 상태 | 설명 | 다음 가능 상태 |
|------|------|---------------|
| `draft` | 작성 중 | `sent` |
| `sent` | 바이어에게 발송됨 | `accepted`, `negotiating`, `rejected`, `expired` |
| `negotiating` | 협상 중 | `accepted`, `rejected`, `expired` |
| `accepted` | 바이어 승인 | `converted` |
| `rejected` | 거절됨 (최종) | - |
| `expired` | 유효기간 만료 (최종) | - |
| `converted` | PO로 전환됨 (최종) | - |

### 2.3 액션 및 트리거

| 액션 | 트리거 | 결과 |
|------|--------|------|
| 발송 | 사용자 클릭 | `draft` → `sent` |
| 승인 | 사용자 입력 | `sent/negotiating` → `accepted` |
| 협상 시작 | 사용자 입력 | `sent` → `negotiating` |
| 거절 | 사용자 입력 | `sent/negotiating` → `rejected` |
| 만료 | 스케줄러 (매일) | `sent/negotiating` → `expired` |
| PO 전환 | PO 생성 완료 | `accepted` → `converted` |

---

## 3. PO (Purchase Order) 워크플로우

### 3.1 상태 흐름도

```
                    ┌──────────┐
                    │  draft   │◀──── 초기 상태
                    └────┬─────┘
                         │ [Confirm]
                         ▼
                    ┌──────────┐
                    │confirmed │
                    └────┬─────┘
                         │ [Start Production]
                         ▼
                    ┌──────────┐
                    │   in_    │
                    │production│
                    └────┬─────┘
                         │ [Production Complete]
                         ▼
                    ┌──────────┐
                    │ready_to_ │
                    │  ship    │
                    └────┬─────┘
                         │
         ┌───────────────┴───────────────┐
         │ [Partial Ship]                │ [Full Ship]
         ▼                               ▼
    ┌──────────┐                   ┌──────────┐
    │partially_│                   │ shipped  │
    │ shipped  │──────────────────▶│          │
    └──────────┘  [Remaining]      └────┬─────┘
                                        │ [All Complete]
                                        ▼
                                   ┌──────────┐
                                   │completed │ ──── 최종 상태
                                   └──────────┘

    * cancelled: 어느 단계에서든 취소 가능
```

### 3.2 상태 정의

| 상태 | 설명 | 다음 가능 상태 |
|------|------|---------------|
| `draft` | 작성 중 | `confirmed`, `cancelled` |
| `confirmed` | 주문 확정 | `in_production`, `cancelled` |
| `in_production` | 생산 중 | `ready_to_ship`, `cancelled` |
| `ready_to_ship` | 선적 대기 | `partially_shipped`, `shipped`, `cancelled` |
| `partially_shipped` | 부분 선적 | `shipped` |
| `shipped` | 선적 완료 | `completed` |
| `completed` | 완료 (최종) | - |
| `cancelled` | 취소됨 (최종) | - |

---

## 4. L/C (Letter of Credit) 워크플로우

### 4.1 상태 흐름도

```
                         ┌──────────┐
                         │  draft   │◀──── 초기 (L/C 정보 입력 시작)
                         └────┬─────┘
                              │ [Submit L/C Info]
                              ▼
                         ┌──────────┐
                         │ pending  │◀──── L/C 발행 대기
                         └────┬─────┘
                              │ [L/C Issued by Bank]
                              ▼
                         ┌──────────┐
                         │  issued  │
                         └────┬─────┘
                              │ [Advising Bank Notification]
                              ▼
                         ┌──────────┐
                         │ advised  │
                         └────┬─────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
              ▼               ▼               ▼
        ┌──────────┐   ┌──────────┐   ┌──────────┐
        │ confirmed│   │amendment_│   │   [Go to │
        │ (선택적)  │   │requested │   │ Shipment]│
        └────┬─────┘   └────┬─────┘   └──────────┘
             │              │
             │              ▼
             │         ┌──────────┐
             │         │ amended  │
             │         └────┬─────┘
             │              │
             └──────────────┴──────────────┐
                                           │
                           ┌───────────────┴───────────────┐
                           │                               │
                           ▼                               ▼
                    ┌──────────────┐               ┌──────────┐
                    │ partially_   │               │  fully_  │
                    │   shipped    │──────────────▶│ shipped  │
                    └──────────────┘               └────┬─────┘
                                                        │
                                                        ▼
                                                  ┌──────────┐
                                                  │documents_│
                                                  │presented │
                                                  └────┬─────┘
                                                       │
                                                       ▼
                                                  ┌──────────┐
                                                  │  under_  │
                                                  │examination│
                                                  └────┬─────┘
                                                       │
                           ┌───────────────────────────┼───────────────────────────┐
                           │                           │                           │
                           ▼                           ▼                           ▼
                    ┌──────────┐               ┌──────────┐               ┌──────────┐
                    │ accepted │               │discrepancy│               │ (rare)   │
                    │          │               │          │               │ rejected │
                    └────┬─────┘               └────┬─────┘               └──────────┘
                         │                          │
                         │         ┌────────────────┴────────────────┐
                         │         │                                 │
                         │         ▼                                 ▼
                         │   ┌──────────┐                     ┌──────────┐
                         │   │  waived  │                     │corrected │
                         │   │(바이어승인)│                     │ & resub  │
                         │   └────┬─────┘                     └────┬─────┘
                         │        │                                │
                         └────────┴────────────────────────────────┘
                                           │
                                           ▼
                                    ┌──────────┐
                                    │ payment_ │
                                    │ pending  │
                                    └────┬─────┘
                                         │
                                         │ [At Sight: 즉시]
                                         │ [Usance: X일 후]
                                         ▼
                                    ┌──────────┐
                                    │   paid   │ ──── 최종 상태
                                    └──────────┘

    * expired: 만료일 경과 시
    * cancelled: 취소 시
```

### 4.2 상태 정의

| 상태 | 설명 | 다음 가능 상태 |
|------|------|---------------|
| `draft` | 입력 중 | `pending` |
| `pending` | 발행 대기 | `issued`, `cancelled` |
| `issued` | 발행됨 | `advised` |
| `advised` | 통지됨 | `confirmed`, `amendment_requested`, `partially_shipped`, `fully_shipped` |
| `confirmed` | 확인됨 | `amendment_requested`, `partially_shipped`, `fully_shipped` |
| `amendment_requested` | 조건변경 요청 | `amended` |
| `amended` | 조건변경 완료 | `partially_shipped`, `fully_shipped` |
| `partially_shipped` | 부분 선적 | `fully_shipped` |
| `fully_shipped` | 전체 선적 | `documents_presented` |
| `documents_presented` | 서류 제출됨 | `under_examination` |
| `under_examination` | 은행 심사 중 | `accepted`, `discrepancy` |
| `discrepancy` | 불일치 발견 | `accepted` (waiver), `documents_presented` (수정 후) |
| `accepted` | 승인됨 | `payment_pending` |
| `payment_pending` | 결제 대기 | `paid` |
| `paid` | 결제 완료 (최종) | - |
| `expired` | 만료 (최종) | - |
| `cancelled` | 취소 (최종) | - |

### 4.3 중요 날짜 체크

| 날짜 | 체크 시점 | 조치 |
|------|----------|------|
| **Latest Shipment Date** | 선적 전 | 선적일이 이 날짜 이전이어야 함 |
| **Expiry Date** | 서류 제출 전 | 서류 제출이 이 날짜 이전이어야 함 |
| **Presentation Period** | 서류 제출 전 | 선적일 + N일 이내 제출 |

---

## 5. Shipment 워크플로우

### 5.1 상태 흐름도

```
              ┌──────────┐
              │  draft   │◀──── 초기 상태
              └────┬─────┘
                   │ [Confirm Booking]
                   ▼
              ┌──────────┐
              │  booked  │
              └────┬─────┘
                   │ [Cargo at Port]
                   ▼
              ┌──────────┐
              │at_origin_│
              │   port   │
              └────┬─────┘
                   │ [Loaded on Vessel]
                   ▼
              ┌──────────┐
              │  loaded  │◀──── B/L 발행 시점
              └────┬─────┘
                   │ [Vessel Departed]
                   ▼
              ┌──────────┐
              │ departed │
              └────┬─────┘
                   │
                   ▼
              ┌──────────┐
              │in_transit│
              └────┬─────┘
                   │ [Arrived at Destination]
                   ▼
              ┌──────────────┐
              │at_destination│
              │    _port     │
              └────┬─────────┘
                   │ [Customs Clearance]
                   ▼
              ┌──────────┐
              │ customs_ │
              │clearance │
              └────┬─────┘
                   │ [Out for Delivery]
                   ▼
              ┌──────────┐
              │out_for_  │
              │delivery  │
              └────┬─────┘
                   │ [Delivered]
                   ▼
              ┌──────────┐
              │delivered │ ──── 최종 상태
              └──────────┘

    * cancelled: 어느 단계에서든 취소 가능
```

### 5.2 상태 정의

| 상태 | 설명 | B/L 관련 |
|------|------|---------|
| `draft` | 선적 정보 입력 중 | - |
| `booked` | 부킹 확정 | - |
| `at_origin_port` | 출발항 도착 | - |
| `loaded` | 선적 완료 | **B/L On Board Date** |
| `departed` | 출항 | - |
| `in_transit` | 운송 중 | - |
| `at_destination_port` | 도착항 도착 | - |
| `customs_clearance` | 통관 중 | - |
| `out_for_delivery` | 배송 중 | - |
| `delivered` | 배송 완료 | - |

---

## 6. CI (Commercial Invoice) 워크플로우

### 6.1 상태 흐름도

```
              ┌──────────┐
              │  draft   │◀──── 초기 상태
              └────┬─────┘
                   │ [Finalize]
                   ▼
              ┌──────────┐
              │finalized │
              └────┬─────┘
                   │ [Submit to Bank]
                   ▼
              ┌──────────┐
              │submitted │
              └────┬─────┘
                   │
                   ▼
              ┌──────────┐
              │under_    │
              │review    │
              └────┬─────┘
                   │
       ┌───────────┴───────────┐
       │                       │
       ▼                       ▼
  ┌──────────┐          ┌──────────┐
  │ accepted │          │discrepancy│
  └────┬─────┘          └────┬─────┘
       │                     │
       │         ┌───────────┴───────────┐
       │         │                       │
       │         ▼                       ▼
       │   ┌──────────┐          ┌──────────┐
       │   │discrepancy│          │ rejected │
       │   │_resolved │          │          │
       │   └────┬─────┘          └──────────┘
       │        │                  (최종)
       └────────┴────────────┐
                             │
                             ▼
                       ┌──────────┐
                       │payment_  │
                       │pending   │
                       └────┬─────┘
                            │
                            ▼
                       ┌──────────┐
                       │   paid   │ ──── 최종 상태
                       └──────────┘
```

### 6.2 서류 일치 검증 체크리스트

CI 생성 시 자동 검증해야 할 항목:

| 검증 항목 | L/C 조건 | CI 실제 값 | 결과 |
|----------|---------|-----------|------|
| 금액 | ≤ L/C Amount (+ Tolerance) | CI Total | ✓/✗ |
| 수량 | Within Tolerance | Shipped Qty | ✓/✗ |
| 품목 설명 | 정확히 일치 | Item Description | ✓/✗ |
| Beneficiary | 정확히 일치 | Seller Info | ✓/✗ |
| Applicant | 정확히 일치 | Buyer Info | ✓/✗ |
| Incoterms | 일치 | CI Incoterms | ✓/✗ |
| 선적일 | ≤ Latest Shipment Date | B/L Date | ✓/✗ |
| 선적항 | 일치 | Port of Loading | ✓/✗ |
| 도착항 | 일치 | Port of Discharge | ✓/✗ |
| 부분선적 | Allowed? | Partial? | ✓/✗ |

---

## 7. Payment 워크플로우

### 7.1 At Sight vs Usance

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           PAYMENT TIMING                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  AT SIGHT (일람불)                                                       │
│  ════════════════                                                       │
│                                                                         │
│  Documents Accepted ──────────────────────────────▶ Payment             │
│       (Day 0)                                      (Day 0-5)            │
│                                                                         │
│  ───────────────────────────────────────────────────────────────────    │
│                                                                         │
│  USANCE (기한부)                                                         │
│  ════════════════                                                       │
│                                                                         │
│  Documents     ────────── Waiting Period ──────────▶ Payment            │
│  Accepted                                                               │
│  (Day 0)                                             (Day X)            │
│                                                                         │
│  Examples:                                                              │
│  • Usance 30 Days: Day 0 ──────[30 days]──────▶ Day 30                 │
│  • Usance 60 Days: Day 0 ──────[60 days]──────▶ Day 60                 │
│  • Usance 90 Days: Day 0 ──────[90 days]──────▶ Day 90                 │
│                                                                         │
│  Note: "Days from" can be:                                              │
│  • B/L Date (선하증권일)                                                 │
│  • Shipment Date (선적일)                                               │
│  • Sight Date (일람일)                                                   │
│  • Invoice Date (인보이스일)                                             │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 7.2 상태 정의

| 상태 | 설명 |
|------|------|
| `pending` | 결제 대기 (서류 승인 전) |
| `processing` | 결제 처리 중 |
| `partial` | 부분 결제 |
| `completed` | 결제 완료 |
| `failed` | 결제 실패 |
| `refunded` | 환불됨 |

---

## 8. 상태 전이 규칙

### 8.1 전이 매트릭스

**허용된 상태 전이만 가능** - 아래 표에 없는 전이는 거부됨

```sql
-- 상태 전이 규칙 테이블 (개념적)
-- PI 예시
VALID_TRANSITIONS = {
  'pi': {
    'draft': ['sent'],
    'sent': ['accepted', 'negotiating', 'rejected', 'expired'],
    'negotiating': ['accepted', 'rejected', 'expired'],
    'accepted': ['converted'],
    'rejected': [],  -- 최종 상태
    'expired': [],   -- 최종 상태
    'converted': []  -- 최종 상태
  }
}
```

### 8.2 전이 시 필수 조건

| Entity | From | To | 필수 조건 |
|--------|------|-----|----------|
| PI | `draft` | `sent` | buyer_id 필수, items 1개 이상 |
| PO | `confirmed` | `in_production` | L/C issued 상태 확인 (선택) |
| L/C | `advised` | `partially_shipped` | Shipment 존재 |
| L/C | `documents_presented` | `under_examination` | CI submitted 상태 |
| CI | `draft` | `finalized` | 모든 필수 필드 입력 |
| CI | `finalized` | `submitted` | L/C presentation period 내 |

---

## 9. 자동화 트리거

### 9.1 스케줄 기반 트리거 (Daily Job)

| 트리거 | 조건 | 액션 |
|--------|------|------|
| PI 만료 | `validity_date < NOW()` AND `status IN ('sent', 'negotiating')` | `status = 'expired'` |
| L/C 만료 경고 | `expiry_date - 7 days` | Alert 생성 |
| L/C 만료 | `expiry_date < NOW()` AND `status NOT IN ('paid', 'cancelled')` | `status = 'expired'` |
| 선적 기한 경고 | `latest_shipment_date - 7 days` | Alert 생성 |
| 서류 제출 기한 | `shipped_date + presentation_period - 3 days` | Alert 생성 |
| Usance 결제일 | `acceptance_date + usance_days` | Alert 생성 |

### 9.2 이벤트 기반 트리거

| 이벤트 | 트리거 | 액션 |
|--------|--------|------|
| PO 생성 | PI에서 PO 생성 | PI.status → `converted` |
| Shipment 생성 | L/C에 연결된 Shipment | PO.status → `shipped` or `partially_shipped` |
| CI 제출 | CI status → `submitted` | L/C.status → `documents_presented` |
| Payment 완료 | Payment.status → `completed` | L/C.status → `paid`, CI.status → `paid` |

### 9.3 알림 자동 생성 규칙

```sql
-- 알림 생성 규칙 (예시)
ALERT_RULES = [
  {
    entity: 'lc',
    condition: 'expiry_date - INTERVAL ''7 days'' <= NOW()',
    alert_type: 'lc_expiry_warning',
    priority: 'high',
    title_template: 'L/C {lc_number} expires in 7 days'
  },
  {
    entity: 'lc',
    condition: 'latest_shipment_date - INTERVAL ''7 days'' <= NOW()',
    alert_type: 'shipment_deadline_warning',
    priority: 'urgent',
    title_template: 'Shipment deadline for L/C {lc_number} in 7 days'
  },
  {
    entity: 'ci',
    condition: "status = 'discrepancy'",
    alert_type: 'discrepancy_found',
    priority: 'urgent',
    title_template: 'Discrepancy found in CI {ci_number}'
  }
]
```

---

## 변경 이력

| 버전 | 날짜 | 변경 내용 |
|------|------|----------|
| 1.0.0 | 2025-12-26 | 최초 작성 |

---

> **다음 단계**: [TERMS_REFERENCE](./TRADE_LC_TERMS_REFERENCE.md)를 참조하여 용어 정의를 확인하세요.
