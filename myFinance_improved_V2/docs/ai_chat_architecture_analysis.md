# AI-Chat 마스터 AI 아키텍처 분석

---

## 🎯 현재 구조 분석

### AI-Chat = **마스터 오케스트레이터**

```
사장님 질문
    ↓
┌─────────────────────────────────┐
│   AI-Chat (Master AI)           │
│                                 │
│  1. 질문 분석                    │
│  2. Feature 로드                 │
│  3. 테이블 메타데이터 로드        │
│  4. 적절한 Tool 선택             │
│  5. 결과 해석 & 응답             │
└─────────────────────────────────┘
         ↓
    [5가지 Tools]
    ├─ get_table_schema
    ├─ get_column_meanings
    ├─ resolve_context
    ├─ query_database
    └─ detect_anomalies
```

---

## 📋 핵심 메타데이터 시스템

### 1. `features` 테이블 (기능 정의)

```sql
feature_id: UUID
feature_name: "Cash Ending", "Balance Sheet", etc.
primary_tables: ["cash_control", "bank_amount", ...]  -- 이 기능이 사용하는 테이블들
tables_require_store_filter: ["cash_control", ...]    -- store_id 필터 필수 테이블
store_filter_column: "store_id"                       -- 필터 컬럼명
custom_system_prompt: TEXT                            -- 기능별 특화 프롬프트
sample_questions: ["오늘 마감 금액?", ...]            -- 예시 질문들
```

**예시: Cash Ending Feature**
```json
{
  "feature_name": "Cash Ending",
  "primary_tables": [
    "cash_control",
    "cash_amount_stock_flow",
    "bank_amount",
    "vault_amount_line",
    "cash_locations",
    ...
  ],
  "tables_require_store_filter": [
    "cash_control",
    "cash_amount_stock_flow",
    "bank_amount"
  ],
  "sample_questions": [
    "오늘 마감 금액이 얼마야?",
    "KB은행 잔액이 얼마야?",
    "금고에 얼마나 있어?",
    "이 가게 총 현금이 얼마야?"
  ]
}
```

---

### 2. `table_metadata` 테이블 (컬럼별 의미)

```sql
table_name: "cash_control"
column_name: "total_amount"
meaning: "총 현금 마감 금액"
calculation_formula: "SUM(cash_inflow) - SUM(cash_outflow)"
normal_range: "> 0"
business_rules: "마감 시 실제 현금과 일치해야 함"
fraud_detection_rules: {
  "type": "impossible_amount",
  "condition": "total_amount < 0",
  "severity": "high"
}
severity: "high" | "medium" | "low"
```

---

### 3. `table_business_rules` 테이블 (테이블별 규칙)

```sql
table_name: "cash_control"
description: "일일 현금 마감 관리 테이블"
workflow: "1. 마감 시작 → 2. 실사 → 3. 차액 확인 → 4. 승인"
calculation_logic: "예상 잔액 = 전일 잔액 + 당일 매출 - 당일 지출"
fraud_rules: "마감 차액이 ±10% 이상이면 경고"
```

---

## 🔄 AI-Chat 동작 플로우

### 사장님: "이번 달 매출이 왜 줄었어?"

```
Step 1: 질문 분석
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
AI-Chat (Master):
- 키워드: "매출", "줄었어", "이번 달"
- 의도: 매출 감소 원인 분석
- 필요 데이터: 월별 매출 추이
- 시간 범위: current_date 기준 이번 달 vs 지난 달
- 스코프: context에 store_id 있으면 해당 가게, 없으면 회사 전체

Step 2: Feature 로드
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
GET /features WHERE feature_id = {전달받은 feature_id}

결과:
{
  "feature_name": "Financial Analysis",
  "primary_tables": [
    "company_financial_metrics",
    "journal_entries",
    "accounts"
  ],
  "tables_require_store_filter": ["journal_entries"],
  "custom_system_prompt": "재무 분석 전문가로서..."
}

Step 3: 컨텍스트 파악
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tool: resolve_context()

결과:
{
  "stores": [
    {"store_id": "xxx", "store_name": "강남점"},
    {"store_id": "yyy", "store_name": "홍대점"}
  ],
  "context_store_id": "xxx",  // 사장님이 보고 있는 페이지
  "note": "User is viewing 강남점. Use it unless question specifies different scope."
}

Step 4: 적절한 Tool 선택
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
AI 판단:
"매출 추이 분석 필요 → 타임시리즈 데이터 필요"

현재 가능한 Tool:
❌ get_table_schema → 구조만 알려줌, 데이터 없음
❌ query_database → 복잡한 집계 쿼리 직접 작성해야 함
✅ get_revenue_transaction_timeseries → 딱 맞음! (우리가 추가할 것)

Step 5: Tool 호출
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tool: get_revenue_transaction_timeseries
Parameters: {
  company_id: "ebd66ba7-fde7-4332-b6b5-0d8a7f615497",
  months: 6
}

결과:
[
  {period_month: "2025-11", revenue: 231590000, transaction_count: 11, mom_growth_pct: -55.2},
  {period_month: "2025-10", revenue: 516925000, transaction_count: 29, mom_growth_pct: -28.4},
  {period_month: "2025-09", revenue: 721452000, transaction_count: 31, mom_growth_pct: -21.2},
  ...
]

Step 6: 결과 분석 & 응답
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
AI-Chat (Master):
- 데이터 해석: 11월 급감 (-55%), 거래수 62% 감소
- 원인 분석: 고객 이탈 (거래당 금액은 오히려 증가)
- 응답 생성:

"매출이 줄어든 원인을 찾았어요!

📊 6개월 추이:
8월: 915M → 9월: 721M → 10월: 517M → 11월: 231M

🔍 핵심 원인:
거래 건수가 29건에서 11건으로 62% 감소했어요.
거래당 금액은 오히려 증가했지만, 손님이 안 오는 게 문제예요.

💡 권장 조치:
마케팅 캠페인 필요합니다."
```

---

## 🆕 재무 지표를 추가하는 방법

### 현재 문제점:

```typescript
// 현재 AI-Chat이 매출 추이를 분석하려면...

// 1. get_table_schema("journal_entries")
// 2. get_column_meanings("journal_entries")
// 3. query_database(`
//      복잡한 SQL로 월별 집계...
//      JOIN 3개 테이블...
//      GROUP BY, LAG, ROUND...
//    `)
// 4. 여러 번 시도하며 에러 수정...

→ 비효율적! 느림! 에러 가능성 높음!
```

### 해결책: 전용 Tools 추가

```typescript
// 우리가 추가할 것

// 1. get_revenue_transaction_timeseries(company_id, months)
//    → 즉시 월별 매출, 거래수, 성장률 반환!

// 2. get_operating_cash_flow_timeseries(company_id, months)
//    → 즉시 현금 흐름 반환!

// 3. get_profitability_timeseries(company_id, months)
//    → 즉시 수익성 지표 반환!

// 4. get_efficiency_timeseries(company_id, months)
//    → 즉시 효율성 지표 반환!

→ 빠름! 정확! 에러 없음!
```

---

## 📊 Feature 추가 전략

### 새 Feature 생성: "Financial Dashboard"

```sql
INSERT INTO features (
  feature_id,
  feature_name,
  primary_tables,
  tables_require_store_filter,
  store_filter_column,
  custom_system_prompt,
  sample_questions,
  feature_description
) VALUES (
  gen_random_uuid(),
  'Financial Dashboard',

  -- 사용할 테이블들
  '["company_financial_metrics", "store_financial_metrics", "journal_entries", "accounts"]'::jsonb,

  -- store 필터 필요한 테이블
  '["journal_entries"]'::jsonb,

  'store_id',

  -- 커스텀 프롬프트
  '당신은 30년 경력의 재무 분석 전문가입니다.

   사장님이 재무 질문을 하면:
   1. 질문의 핵심 의도 파악 (매출? 현금? 수익성? 효율성?)
   2. 적절한 타임시리즈 Tool 선택
   3. 트렌드 분석 (증가/감소, 패턴, 이상 징후)
   4. 원인 추론 (거래수? 단가? 비용?)
   5. 실행 가능한 조언 제공

   사용 가능한 재무 Tools:
   - get_revenue_transaction_timeseries: 매출 추이
   - get_operating_cash_flow_timeseries: 현금 흐름
   - get_profitability_timeseries: 수익성 분석
   - get_efficiency_timeseries: 비용 효율성

   항상 구체적인 숫자와 함께 설명하세요.',

  -- 예시 질문들
  '[
    "이번 달 매출이 왜 줄었어?",
    "현금 흐름이 어떻게 되고 있어?",
    "수익성이 나아지고 있어?",
    "인건비가 너무 많은 거 아냐?",
    "지난 6개월 추세 보여줘",
    "언제부터 매출이 떨어졌어?",
    "작년 같은 달이랑 비교하면?",
    "마진이 왜 이렇게 낮아?",
    "고정비를 줄여야 할까?"
  ]'::jsonb,

  '회사/가게의 재무 상태를 분석하고 트렌드를 파악합니다.'
);
```

---

## 🛠️ Edge Function 수정 포인트

### 1. TOOLS 배열에 4개 추가

```typescript
const TOOLS = [
  // ... 기존 5개 ...

  {
    type: "function",
    function: {
      name: "get_revenue_transaction_timeseries",
      description: "월별 매출, 거래 건수, 평균 거래액, 성장률 조회",
      parameters: {
        type: "object",
        properties: {
          company_id: { type: "string" },
          months: { type: "integer", default: 6 }
        },
        required: ["company_id"]
      }
    }
  },
  // ... 나머지 3개 ...
];
```

### 2. Tool 호출 핸들러 추가

```typescript
// Deno.serve() 내부에서

if (toolCall.function.name === 'get_revenue_transaction_timeseries') {
  const args = JSON.parse(toolCall.function.arguments);

  console.log(`[AI] Getting revenue trend: company=${args.company_id}, months=${args.months || 6}`);

  const result = await supabase.rpc('get_revenue_transaction_timeseries', {
    p_company_id: args.company_id,
    p_months: args.months || 6
  });

  if (result.error) throw result.error;
  data = result.data;

  console.log(`[AI] Found ${data.length} months of data`);
}

// 나머지 3개 함수도 동일한 패턴으로 추가
```

---

## 🎯 통합 후 사용자 경험

### Before (현재):

```
사장님: "매출이 왜 줄었어?"

AI-Chat:
1. get_table_schema("journal_entries") 호출
2. get_column_meanings("journal_entries") 호출
3. query_database(복잡한 SQL) 시도 → 에러
4. 다시 시도 → 에러
5. 또 시도 → 성공
6. 결과 해석...

→ 10초 이상 소요, 여러 번 시도
```

### After (개선 후):

```
사장님: "매출이 왜 줄었어?"

AI-Chat:
1. get_revenue_transaction_timeseries() 호출 → 즉시 성공!
2. 결과 해석 & 응답 생성

→ 2-3초 완료!

응답:
"6개월 추이를 보니 8월 peak 후 계속 하락 중이에요.
11월엔 거래 건수가 62% 감소했습니다.
고객 이탈 문제로 보이며, 마케팅이 필요합니다."
```

---

## 📝 메타데이터 추가 (선택사항)

### `table_metadata`에 company_financial_metrics 추가

```sql
-- company_financial_metrics VIEW의 JSONB 컬럼들 문서화
INSERT INTO table_metadata (table_name, column_name, meaning, calculation_formula) VALUES
('company_financial_metrics', 'survival_metrics',
 '생존 지표 (현금, 유동성)',
 'JSONB: {cash_runway_months, quick_ratio, working_capital}'),

('company_financial_metrics', 'profitability_metrics',
 '수익성 지표 (매출, 마진)',
 'JSONB: {revenue, gross_margin_pct, net_margin_pct}'),

('company_financial_metrics', 'efficiency_metrics',
 '효율성 지표 (인건비, 임대료)',
 'JSONB: {labor_cost_ratio, rent_to_revenue_ratio}'),

('company_financial_metrics', 'growth_metrics',
 '성장 지표 (전월대비)',
 'JSONB: {mom_growth_pct}');
```

### `table_business_rules` 추가

```sql
INSERT INTO table_business_rules (table_name, description, calculation_logic) VALUES
('company_financial_metrics',
 '회사의 월별 재무 건강도를 자동으로 계산하는 VIEW',
 '
 1. Cash Runway = 현금 / 월평균비용
 2. Quick Ratio = Quick Assets / Current Liabilities
 3. Gross Margin = (Revenue - COGS) / Revenue
 4. Labor Ratio = Labor Cost / Revenue
 5. MoM Growth = (이번달 - 지난달) / 지난달 × 100
 ');
```

---

## 🚀 구현 우선순위

### Phase 1: Edge Function 수정 (필수)
1. ✅ RPC Functions 생성 완료 (이미 했음!)
2. ⏳ AI-Chat Edge Function에 Tools 추가
3. ⏳ Tool 호출 핸들러 추가

### Phase 2: Feature 생성 (권장)
1. ⏳ "Financial Dashboard" Feature 생성
2. ⏳ Sample questions 추가
3. ⏳ Custom system prompt 작성

### Phase 3: 메타데이터 (선택)
1. ⏳ table_metadata 추가
2. ⏳ table_business_rules 추가

---

**작성**: Claude (Architecture Analyst)
**날짜**: 2025-11-16
**다음 단계**: Edge Function 수정 코드 작성
