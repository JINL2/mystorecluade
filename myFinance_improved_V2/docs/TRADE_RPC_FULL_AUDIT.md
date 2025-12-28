# Trade RPC 전체 검증 결과

> 생성일: 2025-12-26
> 검증 대상: 75개 Trade RPC 함수

## 컬럼명 매핑 참조

| 테이블 | 잘못된 컬럼 | 올바른 컬럼 |
|--------|------------|------------|
| trade_letters_of_credit | `id` | `lc_id` |
| trade_letters_of_credit | `expiry_date` | `expiry_date_utc` |
| trade_letters_of_credit | `latest_shipment_date` | `latest_shipment_date_utc` |
| trade_letters_of_credit | `issue_date` | `issue_date_utc` |
| trade_letters_of_credit | `currency` | `currency_id` |
| trade_letters_of_credit | `created_at` | `created_at_utc` |
| trade_purchase_orders | `id` | `po_id` |
| trade_purchase_orders | `counterparty_id` | `buyer_id` |
| trade_purchase_orders | `currency` | `currency_id` |
| trade_purchase_orders | `created_at` | `created_at_utc` |
| trade_proforma_invoices | `id` | `pi_id` |
| trade_proforma_invoices | `created_at` | `created_at_utc` |
| trade_shipments | `id` | `shipment_id` |
| trade_shipments | `etd` | (없음) |
| trade_shipments | `eta` | `eta_utc` |
| trade_shipments | `created_at` | `created_at_utc` |
| trade_commercial_invoices | `id` | `ci_id` |
| trade_payments | `id` | `payment_id` |
| counterparties | `id` | `counterparty_id` |

---

## 버그 있는 함수 목록 (수정 필요)

### CRITICAL (즉시 수정 필요)

| # | 함수명 | 버그 유형 | 상세 |
|---|--------|----------|------|
| 1 | `trade_dashboard_summary` | `expiry_date`, `lc.id`, `etd` | Alerts 섹션 전체 |
| 2 | `trade_lc_list` | `po.id`, `lc.id`, `c.id`, `expiry_date`, `latest_shipment_date`, `currency`, `created_at` | 모든 JOIN 및 SELECT |
| 3 | `trade_alert_generate_daily` | `expiry_date`, `latest_shipment_date`, `id` | INSERT 쿼리 전체 |
| 4 | `trade_lc_check_validity` | `id`, `expiry_date`, `latest_shipment_date` | WHERE 조건 및 비교 |

### HIGH (수정 필요)

| # | 함수명 | 버그 유형 | 상세 |
|---|--------|----------|------|
| 5 | `trade_ci_validate_against_lc` | `ci.id`, `lc.id`, `expiry_date`, `currency`, `tolerance_percent` | LC JOIN 및 비교 |
| 6 | `trade_lc_create` | `po.id`, `counterparty_id`, `expiry_date`, `latest_shipment_date`, `currency`, `issue_date` | INSERT/UPDATE 전체 |
| 7 | `trade_lc_get` | `lc.id`, `expiry_date`, `latest_shipment_date`, `issue_date`, `currency` | SELECT 전체 |
| 8 | `trade_lc_receive_amendment` | `expiry_date` | DATE 타입 캐스팅 |
| 9 | `trade_lc_update` | `expiry_date`, `latest_shipment_date`, `issue_date` | COALESCE UPDATE |
| 10 | `trade_po_get` | `po.id`, `lc.id`, `lc.expiry_date`, `s.etd`, `s.eta` | SELECT 및 JOIN |
| 11 | `trade_report_payment_schedule` | `lc.id`, `lc.expiry_date`, `lc.currency` | SELECT 및 JOIN |

### MEDIUM (수정 권장)

| # | 함수명 | 버그 유형 | 상세 |
|---|--------|----------|------|
| 12 | `trade_ci_get` | `ci.id`, `lc.id`, `s.id`, `lc.currency` | SELECT 및 JOIN |
| 13 | `trade_ci_list` | `ci.id`, `lc.id`, `s.id`, `ci.currency` | SELECT 및 JOIN |
| 14 | `trade_payment_get` | `p.id`, `lc.id`, `ci.id`, `p.currency` | SELECT 및 JOIN |
| 15 | `trade_payment_list` | `p.id`, `lc.id` | SELECT 및 JOIN |
| 16 | `trade_pi_get` | `pi.id`, `c.id`, `po.id` | SELECT 및 JOIN |
| 17 | `trade_pi_list` | `pi.id`, `c.id` | SELECT 및 JOIN |
| 18 | `trade_po_list` | `po.id`, `c.id`, `po.counterparty_id`, `po.currency` | SELECT 및 JOIN |
| 19 | `trade_po_get_shipment_summary` | `po.id`, `s.id`, `s.etd`, `s.eta` | SELECT 및 JOIN |
| 20 | `trade_shipment_get` | `s.id`, `po.id`, `lc.id`, `s.etd`, `s.eta` | SELECT 및 JOIN |
| 21 | `trade_shipment_list` | `s.id`, `po.id`, `lc.id`, `s.etd`, `s.eta` | SELECT 및 JOIN |
| 22 | `trade_report_by_counterparty` | `lc.id` | SELECT 및 GROUP BY |

---

## 버그 없는 함수 (검증 완료)

다음 함수들은 단순 CRUD이거나 마스터 데이터 조회로, 컬럼명 이슈가 없습니다:

- `trade_activity_log_list`
- `trade_alert_dismiss`
- `trade_alert_list`
- `trade_alert_mark_all_read`
- `trade_alert_mark_read`
- `trade_ci_create` (파라미터만 사용)
- `trade_ci_finalize`
- `trade_ci_submit`
- `trade_ci_update`
- `trade_dashboard_timeline`
- `trade_discrepancy_log_list`
- `trade_discrepancy_resolve`
- `trade_document_delete`
- `trade_document_get`
- `trade_document_get_checklist`
- `trade_document_list`
- `trade_document_upload`
- `trade_generate_ci_number`
- `trade_generate_payment_number`
- `trade_generate_pi_number`
- `trade_generate_po_number`
- `trade_generate_shipment_number`
- `trade_lc_calculate_amounts`
- `trade_lc_request_amendment`
- `trade_lc_update_status`
- `trade_master_get_all`
- `trade_master_get_document_types`
- `trade_master_get_freight_terms`
- `trade_master_get_incoterms`
- `trade_master_get_lc_types`
- `trade_master_get_payment_terms`
- `trade_master_get_shipping_methods`
- `trade_master_get_status_definitions`
- `trade_payment_complete`
- `trade_payment_record`
- `trade_payment_summary_by_lc`
- `trade_pi_accept`
- `trade_pi_cancel`
- `trade_pi_convert_to_po`
- `trade_pi_create`
- `trade_pi_duplicate`
- `trade_pi_send`
- `trade_pi_update`
- `trade_po_confirm`
- `trade_po_create`
- `trade_po_update`
- `trade_po_update_status`
- `trade_report_by_period`
- `trade_shipment_create`
- `trade_shipment_update`
- `trade_shipment_update_status`
- `trade_shipment_update_tracking`
- `trade_status_history_list`

---

## 수정 우선순위

1. **CRITICAL 4개** - Dashboard와 Alert 관련, 즉시 에러 발생
2. **HIGH 7개** - 주요 CRUD 함수, 데이터 조회 시 에러
3. **MEDIUM 11개** - 리스트/상세 조회, 일부 필드 누락 가능

---

## 수정 파일

- **[TRADE_RPC_SQL_FIX.sql](./TRADE_RPC_SQL_FIX.sql)** - CRITICAL 4개 함수 수정 SQL
- 추가 수정이 필요한 경우 HIGH/MEDIUM 함수들도 동일한 패턴으로 수정 필요

---

## 근본 원인 분석

RPC 함수가 실제 테이블 스키마와 불일치하는 이유:

1. **스키마 변경 후 RPC 미갱신**: 테이블에 `_utc` suffix가 추가되었으나 RPC는 그대로
2. **PK 네이밍 불일치**: 테이블별 PK가 `lc_id`, `po_id` 등인데 RPC는 `id` 사용
3. **FK 네이밍 변경**: `counterparty_id` → `buyer_id` 변경 반영 안됨
4. **etd/eta 컬럼 제거**: trade_shipments에서 etd/eta가 `eta_utc`, `shipped_date_utc` 등으로 변경

## 권장 조치

1. `TRADE_RPC_SQL_FIX.sql` 파일의 SQL을 Supabase SQL Editor에서 실행
2. HIGH/MEDIUM 함수들도 동일 패턴으로 수정
3. 향후 스키마 변경 시 RPC 함수 동시 업데이트 필수
