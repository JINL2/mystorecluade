# RPC Response Structure vs Flutter Models

## ✅ 실제 RPC 응답 구조 (get_location_stock_flow_v2)

```json
{
  "location": {
    "cash_location_id": "e512d176-a55a-4688-a525-8f02f4a272ee",
    "location_name": "cashtestnewrpc",
    "location_type": "cash",
    "bank_name": null,
    "bank_account": null,
    "currency_id": "93f9bc80-eb8c-4e3e-b214-50db1699b7b6",
    "currency_code": "VND",
    "currency_name": "Vietnamese Dong",
    "base_currency_id": "93f9bc80-eb8c-4e3e-b214-50db1699b7b6",
    "base_currency_code": "VND",
    "base_currency_name": "Vietnamese Dong",
    "base_currency_symbol": "₫"
  },
  "journal_flows": [],
  "actual_flows": [
    {
      "flow_id": "363dba91-eb82-4672-9b03-c615185208c6",
      "created_at": "2025-11-23T11:26:56.716002",
      "system_time": "2025-11-23T11:26:56.716002",
      "balance_before": 117339184,
      "flow_amount": 14667398,
      "balance_after": 132006582,
      "currency_id": "93f9bc80-eb8c-4e3e-b214-50db1699b7b6",
      "currency_code": "VND",
      "currency_name": "Vietnamese Dong",
      "currency_symbol": "₫",
      "created_by": "746b93ab-9ada-43a8-9859-95ac599952b4",
      "created_by_name": "testreal testreal",
      "location_type": "cash",
      "denomination_details": [
        {
          "denomination_id": "4e2d857c-173b-473f-bee0-5322f229fd99",
          "denomination_value": 500000,
          "denomination_type": null,
          "current_quantity": 10,
          "previous_quantity": 10,
          "quantity_change": 0,
          "subtotal": 5000000,
          "currency_id": "93f9bc80-eb8c-4e3e-b214-50db1699b7b6",
          "currency_code": "VND",
          "currency_name": "Vietnamese Dong",
          "currency_symbol": "₫"
        }
      ]
    }
  ],
  "pagination": {
    "offset": 0,
    "limit": 1,
    "total_journal": 0,
    "total_actual": 9
  }
}
```

---

## 🔍 네이밍 비교 분석

### ❌ 문제점 발견:

#### 1. **actual_flows 구조가 완전히 다름**

**RPC 응답 (평면 구조)**:
```json
{
  "flow_id": "...",
  "created_at": "...",
  "currency_id": "...",
  "currency_code": "VND",
  "currency_name": "...",
  "currency_symbol": "₫",
  "created_by": "uuid",
  "created_by_name": "string",
  "denomination_details": [...]
}
```

**Flutter 모델이 기대하는 구조 (중첩 객체)**:
```dart
ActualFlow(
  currency: CurrencyInfo(...),  // ❌ 중첩 객체 기대
  createdBy: CreatedBy(...),     // ❌ 중첩 객체 기대
  currentDenominations: [...]    // ❌ 다른 필드명
)
```

#### 2. **필드명 불일치**

| RPC 응답 | Flutter 모델 | 상태 |
|----------|--------------|------|
| `denomination_details` | `currentDenominations` | ❌ 다름 |
| 평면: `currency_code`, `currency_id`, ... | `currency: CurrencyInfo` | ❌ 구조 다름 |
| 평면: `created_by`, `created_by_name` | `createdBy: CreatedBy` | ❌ 구조 다름 |

#### 3. **StockFlowResponse 구조 불일치**

**RPC 응답**:
```json
{
  "location": {...},
  "journal_flows": [...],
  "actual_flows": [...],
  "pagination": {...}
}
```

**Flutter 모델이 기대하는 구조**:
```dart
StockFlowResponse(
  success: bool,           // ❌ RPC에 없음
  data: StockFlowData(     // ❌ RPC에 'data' wrapper 없음
    locationSummary: ...,  // ❌ 'location'으로 와야 함
    journalFlows: ...,
    actualFlows: ...
  ),
  pagination: ...
)
```

---

## 🔧 필요한 수정사항

### 1. **StockFlowResponseModel.fromJson() 수정**

현재 V1 응답 구조를 파싱하도록 되어 있음:
```dart
// 현재 (V1 구조)
StockFlowResponse.fromJson({
  "success": true,
  "data": {
    "location_summary": {...},
    ...
  }
})
```

수정 필요 (V2 구조):
```dart
// V2 구조
{
  "location": {...},           // 직접 접근
  "journal_flows": [...],      // 직접 접근
  "actual_flows": [...],       // 직접 접근
  "pagination": {...}          // 직접 접근
}
```

### 2. **ActualFlowModel.fromJson() 수정**

평면 구조를 객체로 변환:
```dart
static ActualFlow fromJson(Map<String, dynamic> json) {
  // 평면 필드를 CurrencyInfo 객체로 빌드
  final currencyInfo = CurrencyInfo(
    currencyId: json['currency_id'],
    currencyCode: json['currency_code'],
    currencyName: json['currency_name'],
    symbol: json['currency_symbol'],
  );

  // 평면 필드를 CreatedBy 객체로 빌드
  final createdBy = CreatedBy(
    userId: json['created_by'],
    fullName: json['created_by_name'],
  );

  return ActualFlow(
    currency: currencyInfo,
    createdBy: createdBy,
    currentDenominations: json['denomination_details'], // ✅ 필드명 수정
    ...
  );
}
```

### 3. **LocationSummaryModel.fromJson() 수정**

필드명이 맞는지 확인 필요:
- `base_currency_symbol` ✅ (맞음)

---

## 📋 수정 체크리스트

- [ ] `StockFlowResponseModel.fromJson()` - V2 평면 구조로 수정
- [ ] `ActualFlowModel.fromJson()` - 평면 → 중첩 객체 변환
- [ ] `JournalFlowModel.fromJson()` - 평면 → 중첩 객체 변환
- [ ] Field 이름: `denomination_details` → `currentDenominations`
- [ ] Field 이름: `location` → `locationSummary`

---

## ✅ 올바른 파싱 로직

```dart
class StockFlowResponseModel {
  static StockFlowResponse fromJson(Map<String, dynamic> json) {
    return StockFlowResponse(
      success: true,  // V2는 항상 성공으로 간주 (에러는 exception)
      data: StockFlowData(
        locationSummary: json['location'] != null
            ? LocationSummaryModel.fromJson(json['location'])
            : null,
        journalFlows: (json['journal_flows'] as List?)
            ?.map((e) => JournalFlowModel.fromJson(e))
            .toList() ?? [],
        actualFlows: (json['actual_flows'] as List?)
            ?.map((e) => ActualFlowModel.fromJson(e))
            .toList() ?? [],
      ),
      pagination: json['pagination'] != null
          ? PaginationInfoModel.fromJson(json['pagination'])
          : null,
    );
  }
}
```
