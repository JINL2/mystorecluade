# 🤖 AI SQL Generator 완벽 가이드

> **버전:** v4.0 (Final)  
> **프로젝트:** Storebase AI Query System  
> **마지막 업데이트:** 2025-12-25  

---

## 📋 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [시스템 아키텍처](#2-시스템-아키텍처)
3. [테이블 구조 (상세)](#3-테이블-구조-상세)
4. [모니터링 뷰 (실시간 대시보드)](#4-모니터링-뷰-실시간-대시보드)
5. [RPC 함수](#5-rpc-함수)
6. [Edge Functions](#6-edge-functions)
7. [테스트 방법](#7-테스트-방법)
8. [트러블슈팅](#8-트러블슈팅)
9. [유지보수](#9-유지보수)
10. [부록: SQL 쿼리 모음](#10-부록-sql-쿼리-모음)

---

## 1. 프로젝트 개요

### 🎯 우리가 하고 있는 것

**AI SQL Generator**는 Storebase 앱에서 사용자의 자연어 질문을 SQL로 변환하여 데이터베이스에서 정보를 조회하는 시스템입니다.

```
┌─────────────────────────────────────────────────────────────┐
│                    사용자 → AI → 데이터                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   👤 "이번 달 지각한 직원 누구야?"                             │
│                    ↓                                        │
│   🤖 AI (Grok-4-fast + Knowledge Graph)                     │
│                    ↓                                        │
│   📝 SELECT user_name, COUNT(*) as late_count               │
│      FROM v_shift_request_ai                                │
│      WHERE problem_details_v2->>'is_late' = 'true'          │
│      AND start_time_utc >= (월초 계산)...                    │
│                    ↓                                        │
│   💬 "이번 달 지각한 직원:                                    │
│       - Nha Xink: 13회                                      │
│       - Tu Thanh: 5회                                       │
│       - Van Tran: 3회"                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 🔑 핵심 구성 요소

| 구성 요소 | 역할 | 위치 |
|----------|------|------|
| **온톨로지** | 비즈니스 개념/동의어/규칙 저장 | ontology_* 테이블 |
| **Knowledge Graph** | 개념 간 관계 탐색 | v_ontology_graph_* 뷰 |
| **벡터 임베딩** | 질문-개념 유사도 매칭 | ontology_embeddings |
| **Edge Function** | AI 호출 + SQL 실행 | ai-respond-user |
| **로그 시스템** | 모든 쿼리 기록 | ai_sql_logs |

### 📊 현재 성능 (2025-12-25 기준)

| 지표 | 값 |
|------|-----|
| 총 누적 쿼리 | 2,069건 |
| 7일 평균 성공률 | 85.7% |
| P50 응답시간 | 13.8초 |
| P90 응답시간 | 21.5초 |
| 온톨로지 개념 수 | 168개 |
| 동의어 수 | 776개 |
| 벡터 임베딩 수 | 1,332개 |

---

## 2. 시스템 아키텍처

### 2.1 전체 데이터 흐름

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         🔄 AI SQL Generator 전체 흐름                     │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  [Flutter 앱 / 테스트]                                                   │
│         │                                                               │
│         │ 1. POST /ai-respond-user                                      │
│         │    { question, company_id, user_id, session_id }              │
│         ▼                                                               │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    Edge Function: ai-respond-user (v29)          │   │
│  │  ┌─────────────────────────────────────────────────────────────┐ │   │
│  │  │ Step 1: 벡터 검색                                            │ │   │
│  │  │  - 질문 임베딩 생성 (OpenAI text-embedding-3-small)          │ │   │
│  │  │  - search_ontology_vector() 호출                             │ │   │
│  │  │  - 상위 5개 유사 개념 추출                                    │ │   │
│  │  └─────────────────────────────────────────────────────────────┘ │   │
│  │                         ↓                                        │   │
│  │  ┌─────────────────────────────────────────────────────────────┐ │   │
│  │  │ Step 2: Knowledge Graph 경로 탐색                            │ │   │
│  │  │  - get_ontology_paths_v2() 호출                              │ │   │
│  │  │  - 매칭된 개념 → 관련 테이블/컬럼/규칙 추출                   │ │   │
│  │  │  - main_tables, main_columns, constraints, rules 반환        │ │   │
│  │  └─────────────────────────────────────────────────────────────┘ │   │
│  │                         ↓                                        │   │
│  │  ┌─────────────────────────────────────────────────────────────┐ │   │
│  │  │ Step 3: AI SQL 생성                                          │ │   │
│  │  │  - 시스템 프롬프트 + 온톨로지 컨텍스트 구성                   │ │   │
│  │  │  - Grok-4-fast API 호출                                      │ │   │
│  │  │  - SQL + 해석 반환                                           │ │   │
│  │  └─────────────────────────────────────────────────────────────┘ │   │
│  │                         ↓                                        │   │
│  │  ┌─────────────────────────────────────────────────────────────┐ │   │
│  │  │ Step 4: SQL 실행 + 검증                                      │ │   │
│  │  │  - execute_sql() RPC 호출                                    │ │   │
│  │  │  - 에러 시 자동 재시도 (최대 2회)                             │ │   │
│  │  │  - 결과 + AI 응답 스트리밍                                    │ │   │
│  │  └─────────────────────────────────────────────────────────────┘ │   │
│  │                         ↓                                        │   │
│  │  ┌─────────────────────────────────────────────────────────────┐ │   │
│  │  │ Step 5: 로깅                                                 │ │   │
│  │  │  - ai_sql_logs 저장 (question, sql, result, graph_paths)     │ │   │
│  │  │  - ai_chat_history 저장 (대화 기록)                          │ │   │
│  │  └─────────────────────────────────────────────────────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                         ↓                                               │
│  [Flutter 앱] ← SSE 스트리밍 응답                                        │
│    - 데이터 테이블 렌더링                                                │
│    - AI 자연어 응답 표시                                                 │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2 테스트 시스템 흐름

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         🧪 테스트 시스템 흐름                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  [테스터 / Claude]                                                       │
│         │                                                               │
│         │ 1. INSERT INTO ai_test_queue                                  │
│         ▼                                                               │
│  ┌──────────────────────┐                                               │
│  │ ai_test_queue        │ ← 질문 저장                                   │
│  │ (session_id, question, company_id, user_id)                          │
│  └──────────┬───────────┘                                               │
│             │                                                           │
│             │ 2. 트리거 자동 실행: trigger_ai_test_on_insert             │
│             ▼                                                           │
│  ┌──────────────────────┐      HTTP POST       ┌─────────────────────┐ │
│  │ pg_net.http_post     │ ─────────────────▶   │ ai-respond-user     │ │
│  │ (Bearer anon_key)    │                      │ Edge Function       │ │
│  └──────────────────────┘                      └──────────┬──────────┘ │
│                                                           │            │
│             3. 응답 저장                                   │            │
│             ▼                                             ▼            │
│  ┌──────────────────────┐                      ┌─────────────────────┐ │
│  │ net._http_response   │                      │ ai_sql_logs         │ │
│  │ (status_code,        │                      │ (question, sql,     │ │
│  │  content: SSE응답)   │                      │  success, result)   │ │
│  └──────────────────────┘                      └─────────────────────┘ │
│             │                                                          │
│             ▼                                                          │
│  [결과 분석]                                                            │
│    - 성공률 계산                                                        │
│    - 에러 유형 분석                                                     │
│    - 실패 질문 개선                                                     │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.3 Knowledge Graph 구조

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     📊 Knowledge Graph 구조                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   [동의어 노드]        [개념 노드]         [테이블 노드]                   │
│   ┌──────────┐        ┌──────────┐        ┌──────────────┐             │
│   │ 지각     │───▶    │ late     │───▶    │ v_shift_     │             │
│   │ late     │        │ (개념)   │        │ request_ai   │             │
│   │ trễ      │        └────┬─────┘        └──────┬───────┘             │
│   └──────────┘             │                     │                     │
│                            │                     ▼                     │
│                            │              [컬럼 노드]                   │
│                            │              ┌──────────────┐             │
│                            └─────────▶    │ problem_     │             │
│                                           │ details_v2   │             │
│                                           └──────────────┘             │
│                                                                         │
│   Edge Types (759개):                                                   │
│   - synonym_to_concept (318) : 동의어 → 개념                            │
│   - table_has_column (211)   : 테이블 → 컬럼                            │
│   - concept_maps_to_table (46): 개념 → 테이블                           │
│   - table_joins_* (53)       : 테이블 ↔ 테이블 (JOIN)                   │
│   - constraint_applies (39)  : 제약조건 → 테이블                        │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. 테이블 구조 (상세)

### 3.1 테이블 분류 개요

```
📁 AI SQL Generator 테이블 구조
│
├── 🟢 온톨로지 (Source of Truth) ─ 9개
│   ├── ontology_concepts      (168 rows) - 비즈니스 개념
│   ├── ontology_synonyms      (776 rows) - 다국어 동의어
│   ├── ontology_columns       (323 rows) - 컬럼 메타데이터
│   ├── ontology_entities      (51 rows)  - 테이블/뷰 정보
│   ├── ontology_relationships (57 rows)  - JOIN 관계
│   ├── ontology_constraints   (60 rows)  - SQL 규칙
│   ├── ontology_calculation_rules (30 rows) - 계산 공식
│   ├── ontology_event_types   (8 rows)   - 이벤트 타입
│   └── ontology_embeddings    (1,332 rows) - 벡터 저장
│
├── 🟢 Knowledge Graph 뷰 ─ 2개
│   ├── v_ontology_graph_nodes (783 rows) - 모든 노드
│   └── v_ontology_graph_edges (759 rows) - 모든 관계
│
├── 🟢 로그/모니터링 ─ 3개
│   ├── ai_sql_logs      (2,069 rows) - SQL 생성 로그 (핵심!)
│   ├── ai_chat_history  (657 rows)   - 대화 기록
│   └── ai_test_queue    (1,888 rows) - 테스트 큐
│
├── 🟡 테스트/분석 ─ 4개
│   ├── ai_test_runs           (1 row)
│   ├── ontology_test_cases    (24 rows)
│   ├── ontology_test_results  (14 rows)
│   └── ontology_concept_relations (42 rows)
│
└── 🔴 미사용 (삭제 권장) ─ 6개
    ├── ai_intents             (36 rows) - 2개월간 미사용
    ├── ai_intent_vectors      (8 rows)
    ├── ai_schema_rules        (8 rows)
    ├── ai_templates           (8 rows)
    ├── ai_conversation_state  (0 rows)
    └── ontology_kpi_rules     (5 rows)
```

### 3.2 핵심 테이블 상세

#### 📊 ontology_concepts (비즈니스 개념 정의)

| 컬럼 | 타입 | 설명 | 예시 |
|------|------|------|------|
| `concept_id` | uuid | PK | - |
| `concept_name` | text | 개념 이름 | '지각', '급여', '초과근무' |
| `concept_category` | text | 카테고리 | 'time', 'payment', 'status' |
| `mapped_table` | text | 매핑 테이블 | 'v_shift_request_ai' |
| `mapped_column` | text | 매핑 컬럼 | 'problem_details_v2' |
| `calculation_rule` | text | 계산 규칙 참조 | 'calc_late_minutes' |
| `definition_ko` | text | 한국어 정의 | - |
| `definition_en` | text | 영어 정의 | - |
| `definition_vi` | text | 베트남어 정의 | - |
| `ai_usage_hint` | text | AI 힌트 | '지각 조회 시 problem_details_v2->''is_late'' 사용' |
| `is_active` | boolean | 활성 여부 | true |

```sql
-- 주요 개념 확인
SELECT concept_name, mapped_table, mapped_column, ai_usage_hint
FROM ontology_concepts 
WHERE concept_category = 'time' AND is_active = true;
```

#### 📊 ontology_synonyms (다국어 동의어)

| 컬럼 | 타입 | 설명 | 예시 |
|------|------|------|------|
| `synonym_id` | uuid | PK | - |
| `concept_id` | uuid | FK → concepts | - |
| `synonym_text` | text | 동의어 텍스트 | '지각', 'late', 'trễ', '늦음' |
| `language_code` | text | 언어 코드 | 'ko', 'en', 'vi' |
| `search_weight` | float | 검색 가중치 | 1.0 |
| `is_active` | boolean | 활성 여부 | true |

```sql
-- "지각" 관련 모든 동의어
SELECT s.synonym_text, s.language_code, c.concept_name
FROM ontology_synonyms s
JOIN ontology_concepts c ON s.concept_id = c.concept_id
WHERE c.concept_name = '지각';
-- 결과: 지각(ko), late(en), trễ(vi), 늦음(ko), 출근지각(ko)...
```

#### 📊 ontology_columns (컬럼 메타데이터)

| 컬럼 | 타입 | 설명 | 예시 |
|------|------|------|------|
| `column_id` | uuid | PK | - |
| `table_name` | text | 테이블명 | 'v_shift_request_ai' |
| `column_name` | text | 컬럼명 | 'problem_details_v2' |
| `data_type` | text | 데이터 타입 | 'jsonb', 'timestamptz' |
| `display_name_ko` | text | 한국어 표시명 | '문제상세' |
| `description_ko` | text | 한국어 설명 | - |
| `ai_usage_hint` | text | AI 힌트 | 'is_late, is_early_leave 등 포함' |
| `is_deprecated` | boolean | ⚠️ 사용금지 | false |
| `replacement_column` | text | 대체 컬럼 | 'problem_details_v2' |
| `is_utc` | boolean | UTC 시간 여부 | true |
| `is_active` | boolean | 활성 여부 | true |

```sql
-- v_shift_request_ai 주요 컬럼
SELECT column_name, data_type, is_deprecated, ai_usage_hint
FROM ontology_columns 
WHERE table_name = 'v_shift_request_ai' AND is_active = true
ORDER BY is_deprecated, column_name;
```

#### 📊 ontology_constraints (SQL 생성 규칙) ⭐중요

| 컬럼 | 타입 | 설명 | 예시 |
|------|------|------|------|
| `constraint_id` | uuid | PK | - |
| `constraint_name` | text | 규칙 이름 | 'use_dynamic_timezone' |
| `constraint_type` | text | 유형 | 'must', 'must_not', 'prefer' |
| `applies_to_table` | text | 적용 테이블 | 'v_shift_request_ai' |
| `validation_rule` | text | 검증 규칙 | 'AT TIME ZONE (SELECT timezone FROM companies...)' |
| `severity` | text | 심각도 | 'critical', 'error', 'warning' |
| `ai_usage_hint` | text | AI 힌트 | '하드코딩 금지, 동적 타임존 사용' |

```sql
-- Critical 제약조건 확인
SELECT constraint_name, validation_rule, ai_usage_hint
FROM ontology_constraints 
WHERE severity = 'critical' AND is_active = true;
```

#### 📊 ai_sql_logs (SQL 생성 로그) ⭐가장 중요

| 컬럼 | 타입 | 설명 |
|------|------|------|
| `log_id` | uuid | PK |
| `company_id` | uuid | 회사 ID |
| `user_id` | uuid | 사용자 ID |
| `session_id` | text | 세션 ID |
| `question` | text | 사용자 질문 |
| `question_language` | text | 질문 언어 (ko/en/vi) |
| `question_category` | text | 질문 카테고리 |
| `generated_sql` | text | 생성된 SQL |
| `interpretation` | text | AI 해석 |
| `success` | boolean | 실행 성공 여부 |
| `row_count` | integer | 결과 행 수 |
| `result_sample` | jsonb | 결과 샘플 (최대 5행) |
| `tables_used` | text[] | 사용된 테이블 목록 |
| `matched_concepts` | text[] | 매칭된 개념 |
| `graph_paths` | jsonb | Knowledge Graph 경로 |
| `error_type` | text | 에러 유형 |
| `error_message` | text | 에러 메시지 |
| `error_detail` | jsonb | 에러 상세 |
| `execution_time_ms` | int | 전체 실행 시간 |
| `context_load_time_ms` | int | 컨텍스트 로드 시간 |
| `ai_call_time_ms` | int | AI API 호출 시간 |
| `sql_execution_time_ms` | int | SQL 실행 시간 |
| `ai_model` | text | 사용 모델 |
| `ai_tokens_used` | int | 토큰 사용량 |
| `created_at` | timestamptz | 생성 시각 |
| `local_date` | date | 로컬 날짜 |
| `local_hour` | int | 로컬 시간 |

```sql
-- 최근 로그 확인
SELECT 
  created_at,
  question,
  success,
  row_count,
  execution_time_ms,
  tables_used
FROM ai_sql_logs
ORDER BY created_at DESC
LIMIT 10;
```

---

## 4. 모니터링 뷰 (실시간 대시보드)

### 4.1 뷰 목록 요약

| 뷰 이름 | 용도 | 핵심 지표 |
|---------|------|----------|
| `v_ai_sql_daily_stats` | 📈 일별 통계 | 쿼리 수, 성공률, 평균 시간 |
| `v_ai_sql_error_stats` | ❌ 에러 분석 | 에러 유형별 집계 |
| `v_ai_sql_failed_questions` | 🔍 실패 상세 | 실패한 질문 전체 |
| `v_ai_sql_table_usage` | 📊 테이블 사용 | 테이블별 사용 빈도 |
| `v_ai_sql_user_stats` | 👤 유저 통계 | 유저별 쿼리 수 |
| `v_ai_sql_category_stats` | 📁 카테고리별 | 질문 유형별 성공률 |
| `v_ai_sql_hourly_stats` | ⏰ 시간대별 | 시간별 쿼리 분포 |
| `v_ai_sql_performance_percentiles` | ⚡ 성능 분석 | P50, P90, P99 |
| `v_ai_sql_problem_columns` | ⚠️ 문제 컬럼 | 에러 유발 컬럼 |
| `v_ontology_deprecated_columns` | ⛔ deprecated | 사용 금지 컬럼 |
| `v_ontology_health_check` | 🏥 헬스체크 | 온톨로지 정합성 |

### 4.2 대시보드 쿼리

#### 📈 일별 성공률 대시보드

```sql
SELECT * FROM v_ai_sql_daily_stats ORDER BY local_date DESC LIMIT 7;

-- 결과 예시:
-- local_date | total_queries | success_count | success_rate | avg_time_ms
-- 2025-12-25 | 4             | 4             | 100.0        | 13863
-- 2025-12-23 | 7             | 7             | 100.0        | 12634
-- 2025-12-22 | 11            | 9             | 81.8         | 17651
```

#### ❌ 에러 유형 분석

```sql
SELECT * FROM v_ai_sql_error_stats;

-- 결과 예시:
-- error_type | error_count | sample_errors
-- unknown    | 4           | ["function timezone() does not exist", ...]
```

#### 📊 테이블 사용 빈도

```sql
SELECT * FROM v_ai_sql_table_usage ORDER BY usage_count DESC LIMIT 5;

-- 결과 예시:
-- table_name         | usage_count | success_rate
-- companies          | 1780        | 79.8
-- v_shift_request_ai | 1619        | 82.8
-- stores             | 500         | 78.6
```

#### ⚡ 성능 분석

```sql
SELECT * FROM v_ai_sql_performance_percentiles;

-- 결과 예시:
-- p50_total | p90_total | p99_total | p50_ai  | p90_ai  | p50_sql | p90_sql
-- 13857     | 21495     | 24969     | 10071   | 16326   | 234     | 611
```

#### 🔍 최근 실패한 질문

```sql
SELECT 
  created_at::date as date,
  question,
  error_type,
  LEFT(error_message, 60) as error
FROM v_ai_sql_failed_questions
ORDER BY created_at DESC
LIMIT 5;
```

#### 🏥 온톨로지 헬스체크

```sql
SELECT * FROM v_ontology_health_check;

-- 결과 해석:
-- PHANTOM: ontology에 있지만 DB에 없음 → 삭제 필요
-- MISSING: DB에 있지만 ontology에 없음 → 추가 필요
```

---

## 5. RPC 함수

### 5.1 핵심 함수

| 함수 | 용도 | Input | Output |
|------|------|-------|--------|
| `search_ontology_vector` | 벡터 유사도 검색 | query_embedding[], threshold, max_results | 매칭된 concepts |
| `get_ontology_paths_v2` | Knowledge Graph 경로 탐색 | start_node_names[], max_depth | main_tables, columns, constraints, rules |
| `execute_sql` | SQL 실행 | query_text | 결과 rows |

### 5.2 사용 예시

```sql
-- Knowledge Graph 경로 탐색
SELECT * FROM get_ontology_paths_v2(
  ARRAY['지각', '직원'], -- 시작 노드
  3                       -- 최대 탐색 깊이
);

-- 결과:
-- {
--   "main_tables": ["v_shift_request_ai"],
--   "main_columns": ["problem_details_v2", "user_name"],
--   "constraints": ["use_dynamic_timezone"],
--   "rules": ["calc_late_minutes"]
-- }
```

---

## 6. Edge Functions

### 6.1 함수 목록

| 함수 | 버전 | 용도 | verify_jwt |
|------|------|------|------------|
| `ai-respond-user` | v29 | 메인 AI 응답 | ✅ ON |
| `ai-sql-generator` | v31 | SQL만 생성 | ✅ ON |
| `embed-single-row` | v4 | 트리거용 임베딩 | ✅ ON |
| `generate-ontology-embeddings` | v7 | 전체 임베딩 | ✅ ON |
| `ai-test-runner` | v2 | 배치 테스트 | ❌ OFF |

### 6.2 ai-respond-user API

**Endpoint:**
```
POST https://atkekzwgukdvucqntryo.supabase.co/functions/v1/ai-respond-user
```

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {anon_key}
```

**Request Body:**
```json
{
  "question": "이번 달 지각한 직원",
  "company_id": "563ad9ff-e17b-49f3-8f4b-de137f025f03",
  "user_id": "0d2e61ad-b169-41de-b637-1d034ca9f75d",
  "store_id": "d7fe7c6b-099e-4c80-bd4b-b6fec1d598e7",
  "session_id": "test-001",
  "role_type": "owner",
  "timezone": "Asia/Ho_Chi_Minh"
}
```

**Response (SSE Stream):**
```
data: {"type":"result","success":true,"data":[{"user_name":"Nha Xink","count":13}],"row_count":3}
data: {"type":"stream","content":"이번"}
data: {"type":"stream","content":" 달"}
data: {"type":"stream","content":" 지각한..."}
data: {"type":"done","session_id":"test-001","execution_time_ms":10234}
```

---

## 7. 테스트 방법

### 7.1 테스트 전 필수 체크 ⚠️

#### Step 1: Anon Key 확인 (매번!)

```sql
-- 트리거에 저장된 키 확인
SELECT substring(prosrc from 'Bearer ([^'']+)') as stored_key
FROM pg_proc WHERE proname = 'trigger_ai_test_on_insert';
```

**Dashboard 확인:** Settings → API → `anon` `public` 키

**키가 다르면 업데이트:**
```sql
CREATE OR REPLACE FUNCTION trigger_ai_test_on_insert()
RETURNS TRIGGER AS $$
DECLARE
  request_id bigint;
BEGIN
  SELECT net.http_post(
    url := 'https://atkekzwgukdvucqntryo.supabase.co/functions/v1/ai-respond-user',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer [새_ANON_KEY]'  -- ⬅️ 여기 교체
    ),
    body := jsonb_build_object(
      'question', NEW.question,
      'company_id', NEW.company_id,
      'user_id', NEW.user_id,
      'session_id', NEW.session_id,
      'store_id', 'd7fe7c6b-099e-4c80-bd4b-b6fec1d598e7',
      'role_type', 'owner',
      'timezone', 'Asia/Ho_Chi_Minh'
    ),
    timeout_milliseconds := 30000
  ) INTO request_id;
  
  UPDATE ai_test_queue SET status = 'sent', sent_at = NOW() WHERE id = NEW.id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

#### Step 2: 단일 테스트 (Ping)

```sql
-- 1건 INSERT
INSERT INTO ai_test_queue (session_id, question, company_id, user_id) 
VALUES (
  'ping-001', 
  '오늘 지각한 직원',
  '563ad9ff-e17b-49f3-8f4b-de137f025f03',
  '0d2e61ad-b169-41de-b637-1d034ca9f75d'
);

-- 10초 후 확인
SELECT 
  status_code,
  CASE 
    WHEN status_code = 200 THEN '✅ 성공 - 배치 테스트 진행 가능'
    WHEN status_code = 401 THEN '❌ 401 - Anon Key 업데이트 필요!'
    WHEN status_code = 503 THEN '⚠️ 503 - 서버 과부하'
    ELSE '❓ 기타'
  END as status
FROM net._http_response
WHERE created >= NOW() - INTERVAL '30 seconds'
ORDER BY id DESC LIMIT 1;
```

### 7.2 배치 테스트

> ⚠️ **주의:** 30개 동시 요청 시 503 에러!  
> **10개씩 나눠서** 30초 간격으로 실행

```sql
-- 배치 1 (1~10)
INSERT INTO ai_test_queue (session_id, question, company_id, user_id) VALUES
('emp-1225-01', '전체 직원 목록', '563ad9ff-e17b-49f3-8f4b-de137f025f03', '0d2e61ad-b169-41de-b637-1d034ca9f75d'),
('emp-1225-02', '이번 달 지각한 직원', '563ad9ff-e17b-49f3-8f4b-de137f025f03', '0d2e61ad-b169-41de-b637-1d034ca9f75d'),
('emp-1225-03', '오늘 근무 예정인 직원', '563ad9ff-e17b-49f3-8f4b-de137f025f03', '0d2e61ad-b169-41de-b637-1d034ca9f75d')
-- ... 10개까지
;

-- ⏳ 30초 대기 후 배치 2 실행
```

### 7.3 결과 확인

#### pg_net 응답 확인 (즉시)

```sql
SELECT 
  id,
  status_code,
  CASE 
    WHEN content::text LIKE '%"success":true%' THEN '✅ SQL성공'
    WHEN content::text LIKE '%"success":false%' THEN '❌ SQL실패'
    ELSE '?'
  END as result,
  (regexp_match(content::text, '"row_count":(\d+)'))[1] as rows,
  (regexp_match(content::text, '"session_id":"([^"]+)"'))[1] as session_id
FROM net._http_response
WHERE created >= NOW() - INTERVAL '10 minutes'
  AND status_code = 200
ORDER BY id DESC;
```

#### 성공률 요약

```sql
SELECT 
  status_code,
  COUNT(*) as cnt,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) as pct
FROM net._http_response
WHERE created >= NOW() - INTERVAL '10 minutes'
GROUP BY status_code;
```

### 7.4 Session ID 네이밍 규칙

```
{카테고리}-{날짜}-{번호}

emp-1225-01     : 직원 관련 (12/25)
salary-1225-01  : 급여 관련
shift-1225-01   : 근무 관련
finance-1225-01 : 재무 관련
ping-001        : 연결 확인
```

---

## 8. 트러블슈팅

### 8.1 에러 코드별 대응

| 에러 | 원인 | 해결 |
|------|------|------|
| **401** | Anon Key 만료/변경 | 트리거 함수 키 업데이트 |
| **503** | 동시 요청 과부하 | 10개씩 나눠서 요청 |
| **unknown** | AI 간헐적 실패 | 자동 재시도됨 |
| **column_not_found** | 잘못된 컬럼 사용 | 온톨로지 확인/수정 |
| **syntax_error** | SQL 문법 오류 | AI 프롬프트 개선 |

### 8.2 흔한 문제 해결

#### 문제: 특정 동의어 인식 실패

```sql
-- 예: "사람"이 "직원"으로 인식 안됨
INSERT INTO ontology_synonyms (concept_id, synonym_text, language_code)
SELECT concept_id, '사람', 'ko'
FROM ontology_concepts WHERE concept_name = '직원';
```

#### 문제: deprecated 컬럼 사용

```sql
-- deprecated 컬럼 확인
SELECT * FROM v_ontology_deprecated_columns;

-- 대체 컬럼 확인
SELECT column_name, replacement_column 
FROM ontology_columns 
WHERE is_deprecated = true;
```

#### 문제: ai_sql_logs에 저장 안됨

- pg_net 응답의 `content`에서 직접 확인

```sql
SELECT id, LEFT(content::text, 500) as response
FROM net._http_response
WHERE created >= NOW() - INTERVAL '5 minutes'
ORDER BY id DESC;
```

---

## 9. 유지보수

### 9.1 일일 체크

```sql
-- 오늘 성공률
SELECT 
  COUNT(*) as total,
  SUM(CASE WHEN success THEN 1 ELSE 0 END) as success_cnt,
  ROUND(100.0 * SUM(CASE WHEN success THEN 1 ELSE 0 END) / COUNT(*), 1) as success_rate
FROM ai_sql_logs
WHERE local_date = CURRENT_DATE;
```

### 9.2 주간 체크

```sql
-- 에러 유형별 분석
SELECT * FROM v_ai_sql_error_stats;

-- 문제 컬럼 확인
SELECT * FROM v_ai_sql_problem_columns;

-- 온톨로지 정합성
SELECT * FROM v_ontology_health_check;
```

### 9.3 월간 정리

```sql
-- 30일 이전 pg_net 응답 삭제
DELETE FROM net._http_response
WHERE created < NOW() - INTERVAL '30 days';

-- 완료된 테스트 큐 정리
DELETE FROM ai_test_queue
WHERE status = 'sent' AND sent_at < NOW() - INTERVAL '7 days';
```

### 9.4 미사용 테이블 삭제 (선택)

```sql
-- FK 의존 테이블 먼저 삭제
DROP TABLE IF EXISTS ai_conversation_state CASCADE;
DROP TABLE IF EXISTS ai_schema_rules CASCADE;
DROP TABLE IF EXISTS ai_templates CASCADE;
DROP TABLE IF EXISTS ai_intent_vectors CASCADE;
DROP TABLE IF EXISTS ai_intents CASCADE;

-- 관련 함수 삭제
DROP FUNCTION IF EXISTS search_intent;
DROP FUNCTION IF EXISTS search_intent_unified;
DROP FUNCTION IF EXISTS get_intent_config;
DROP FUNCTION IF EXISTS get_intent_template;
DROP FUNCTION IF EXISTS get_intent_schema;
DROP FUNCTION IF EXISTS match_documents;
```

---

## 10. 부록: SQL 쿼리 모음

### 10.1 모니터링 쿼리

```sql
-- 📊 일별 통계
SELECT * FROM v_ai_sql_daily_stats LIMIT 7;

-- ❌ 에러 분석
SELECT * FROM v_ai_sql_error_stats;

-- 🔍 실패 질문
SELECT * FROM v_ai_sql_failed_questions LIMIT 10;

-- 📈 테이블 사용
SELECT * FROM v_ai_sql_table_usage ORDER BY usage_count DESC LIMIT 10;

-- ⚡ 성능 분석
SELECT * FROM v_ai_sql_performance_percentiles;

-- 🏥 온톨로지 헬스체크
SELECT * FROM v_ontology_health_check;

-- ⛔ deprecated 컬럼
SELECT * FROM v_ontology_deprecated_columns;
```

### 10.2 테스트 쿼리

```sql
-- Ping 테스트
INSERT INTO ai_test_queue (session_id, question, company_id, user_id) 
VALUES ('ping-001', '오늘 지각한 직원', '563ad9ff-e17b-49f3-8f4b-de137f025f03', '0d2e61ad-b169-41de-b637-1d034ca9f75d');

-- 결과 확인
SELECT status_code, LEFT(content::text, 200)
FROM net._http_response
WHERE created >= NOW() - INTERVAL '30 seconds'
ORDER BY id DESC LIMIT 1;
```

### 10.3 온톨로지 관리 쿼리

```sql
-- 동의어 추가
INSERT INTO ontology_synonyms (concept_id, synonym_text, language_code)
SELECT concept_id, '새동의어', 'ko'
FROM ontology_concepts WHERE concept_name = '개념명';

-- deprecated 마킹
UPDATE ontology_columns 
SET is_deprecated = true, replacement_column = '대체컬럼'
WHERE table_name = '테이블명' AND column_name = '컬럼명';

-- constraint 추가
INSERT INTO ontology_constraints (constraint_name, constraint_type, applies_to_table, validation_rule, severity, ai_usage_hint)
VALUES ('rule_name', 'must', 'table_name', 'rule_text', 'critical', 'AI에게 전달할 힌트');
```

---

## 📎 현재 설정 정보

| 항목 | 값 |
|------|-----|
| Project Ref | `atkekzwgukdvucqntryo` |
| Edge Function | `ai-respond-user` v29 |
| AI Model | `grok-4-fast` |
| 기본 Company ID | `563ad9ff-e17b-49f3-8f4b-de137f025f03` |
| 기본 User ID | `0d2e61ad-b169-41de-b637-1d034ca9f75d` |
| 기본 Store ID | `d7fe7c6b-099e-4c80-bd4b-b6fec1d598e7` |
| Anon Key 마지막 업데이트 | 2025-12-25 |

---

## 📝 변경 이력

| 날짜 | 버전 | 변경 내용 |
|------|------|----------|
| 2025-12-25 | v4.0 | 완벽 종합 가이드 작성 |
| 2025-12-25 | v3.0 | 테이블 구조 상세 추가 |
| 2025-12-25 | v2.0 | 테스트 가이드 개선 |
| 2025-12-14 | v1.0 | 최초 작성 |

---

*이 문서는 AI SQL Generator 시스템의 전체 구조, 운영, 테스트, 유지보수 방법을 담고 있습니다.*