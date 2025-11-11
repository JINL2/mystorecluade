# Cash Ending UI 문제점 분석
## 스크린샷 기반 사용자 경험 이슈

**분석일**: 2025-11-11
**분석 대상**: Cash Ending 페이지 (Cash/Bank/Vault 탭)
**심각도**: 🟡 중간 (UX 개선 필요)

---

## 🔍 발견된 문제점

### 1️⃣ **Cash vs Bank UI 불일치** 🔴

#### 스크린샷 1: Bank Tab (현재)
```
┌─────────────────────────────────────┐
│  Select Bank Account                │
├─────────────────────────────────────┤
│  🏦 TP bank - (Nhat Chieu)      ✓  │
│      Currency: 93f9bc80-eb8c-...    │ ← ❌ UUID 표시
├─────────────────────────────────────┤
│  🏦 Cherry Business Account         │
│      Currency: 93f9bc80-eb8c-...    │ ← ❌ UUID 표시
├─────────────────────────────────────┤
│  🏦 Card- Nhat Chieu company...     │
│      Currency: 93f9bc80-eb8c-...    │ ← ❌ UUID 표시
└─────────────────────────────────────┘
```

#### 스크린샷 2: Cash Tab (현재)
```
┌─────────────────────────────────────┐
│  Select Cash Location               │
├─────────────────────────────────────┤
│  💰 Cashier HN Nhat Chieu       ✓  │
│      (subtitle 없음)                 │ ← ✅ 깔끔함
└─────────────────────────────────────┘
```

**문제점:**
- ❌ Bank는 UUID를 보여주지만, Cash는 subtitle이 없음
- ❌ 일관성 없는 UI/UX
- ❌ UUID는 사용자에게 의미 없는 정보

---

### 2️⃣ **UUID 노출 문제** 🔴 심각

#### 현재 코드 (Line 234)
```dart
// location_selector_sheet.dart:234
Text(
  'Currency: ${location.currencyId}', // ❌ UUID 그대로 표시
  style: TossTextStyles.caption.copyWith(
    color: TossColors.gray500,
  ),
),
```

**출력 예시:**
```
Currency: 93f9bc80-eb8c-4e3e-b214-50db1699b7b6
```

**문제점:**
1. ❌ **사용자 친화적이지 않음**: UUID는 의미 없음
2. ❌ **가독성 저하**: 긴 문자열이 UI를 복잡하게 만듦
3. ❌ **보안 이슈**: 내부 ID 노출
4. ❌ **TODO 주석만 있고 미구현**: `// TODO: Show currency code`

**기대되는 표시:**
```
Currency: USD  ✅
Currency: VND  ✅
Currency: KRW  ✅
```

---

### 3️⃣ **데이터 구조 문제**

#### Location Entity 분석
```dart
// domain/entities/location.dart
class Location {
  final String locationId;
  final String locationName;
  final String? currencyId;  // ❌ UUID만 저장
  // currencyCode, currencySymbol 없음
}
```

**문제:**
- `currencyId`만 있고, 실제 표시할 `currencyCode` (USD, VND 등)가 없음
- Currency 정보를 가져오려면 별도 조회 필요

---

## 🎯 해결 방안

### 방안 1: Currency 정보 조인 (권장) ⭐

#### 수정 위치
```dart
// location_selector_sheet.dart:234
```

#### Before (현재)
```dart
Text(
  'Currency: ${location.currencyId}', // ❌
  style: TossTextStyles.caption.copyWith(
    color: TossColors.gray500,
  ),
),
```

#### After (개선)
```dart
// Option A: State에서 Currency 매핑
final currencyCode = _getCurrencyCode(location.currencyId, ref);

Text(
  'Currency: $currencyCode',  // ✅ USD, VND 등
  style: TossTextStyles.caption.copyWith(
    color: TossColors.gray500,
  ),
),

// Helper method
String _getCurrencyCode(String? currencyId, WidgetRef ref) {
  if (currencyId == null || currencyId.isEmpty) return 'N/A';

  final currencies = ref.watch(
    cashEndingProvider.select((state) => state.currencies)
  );

  final currency = currencies.firstWhere(
    (c) => c.currencyId == currencyId,
    orElse: () => null,
  );

  return currency?.currencyCode ?? 'Unknown';
}
```

---

### 방안 2: Location Entity 확장 (근본적 해결)

#### 수정할 파일
1. `domain/entities/location.dart`
2. `data/models/location_model.dart`
3. `data/datasources/location_remote_datasource.dart`

#### Location Entity 개선
```dart
// domain/entities/location.dart
class Location {
  final String locationId;
  final String locationName;
  final String? currencyId;
  final String? currencyCode;    // 🆕 추가
  final String? currencySymbol;  // 🆕 추가

  // Helper method
  String get displayCurrency => currencyCode ?? 'N/A';
}
```

#### DataSource Query 수정
```dart
// location_remote_datasource.dart
Future<List<Map<String, dynamic>>> getLocationsByType(...) async {
  final response = await _client
      .from('cash_location')
      .select('''
        location_id,
        location_name,
        currency_id,
        currencies:currency_id (       -- 🆕 JOIN
          currency_code,
          currency_symbol
        )
      ''')
      .eq('company_id', companyId)
      .eq('location_type', locationType);

  return List<Map<String, dynamic>>.from(response);
}
```

---

### 방안 3: 조건부 표시 (임시 방안)

Bank/Vault만 Currency 표시하고, 정보가 없으면 숨기기:

```dart
// location_selector_sheet.dart
if ((locationType == 'bank' || locationType == 'vault') &&
    location.currencyCode != null &&  // ✅ Code로 체크
    location.currencyCode!.isNotEmpty) {
  Text(
    'Currency: ${location.currencyCode}',  // ✅ USD, VND
    style: TossTextStyles.caption.copyWith(
      color: TossColors.gray500,
    ),
  );
}
```

---

## 📊 문제 우선순위

| # | 문제 | 심각도 | 영향 | 우선순위 |
|---|------|--------|------|----------|
| 1 | UUID 노출 | 🔴 높음 | UX 저하, 보안 | P0 (즉시) |
| 2 | Cash vs Bank UI 불일치 | 🟡 중간 | 혼란 유발 | P1 (높음) |
| 3 | TODO 미구현 | 🟡 중간 | 기술 부채 | P1 (높음) |

---

## 🔧 권장 수정 순서

### 단계 1: 빠른 수정 (5분)
```dart
// location_selector_sheet.dart:234
// UUID 표시 → 숨기기
if ((locationType == 'bank' || locationType == 'vault') &&
    location.currencyCode != null &&
    location.currencyCode!.isNotEmpty) {
  Text('Currency: ${location.currencyCode}', ...);
}
```

### 단계 2: State에서 매핑 (15분)
- `_getCurrencyCode()` 헬퍼 메서드 추가
- State의 currencies 리스트에서 조회
- UUID → Currency Code 변환

### 단계 3: 근본적 해결 (30분)
- Location Entity에 currencyCode, currencySymbol 추가
- DB Query에 JOIN 추가
- Model 변환 로직 수정

---

## 🎨 최종 기대 UI

### Cash Tab
```
┌─────────────────────────────────────┐
│  Select Cash Location               │
├─────────────────────────────────────┤
│  💰 Cashier HN Nhat Chieu       ✓  │
└─────────────────────────────────────┘
```

### Bank Tab (개선 후)
```
┌─────────────────────────────────────┐
│  Select Bank Account                │
├─────────────────────────────────────┤
│  🏦 TP bank - (Nhat Chieu)      ✓  │
│      Currency: USD                   │ ✅ 깔끔함
├─────────────────────────────────────┤
│  🏦 Cherry Business Account         │
│      Currency: VND                   │ ✅ 읽기 쉬움
├─────────────────────────────────────┤
│  🏦 Card- Nhat Chieu company...     │
│      Currency: USD                   │ ✅ 의미 있음
└─────────────────────────────────────┘
```

### Vault Tab (개선 후)
```
┌─────────────────────────────────────┐
│  Select Vault Location              │
├─────────────────────────────────────┤
│  🔒 Main Vault                  ✓  │
│      Currency: USD                   │ ✅ 일관성
└─────────────────────────────────────┘
```

---

## 📝 코드 위치

### 수정 필요 파일
1. **location_selector_sheet.dart:234** (즉시 수정)
   - UUID → Currency Code 변환

2. **cash_ending_selection_helpers.dart:183** (동일 이슈)
   - 같은 패턴 반복됨

### 영향받는 파일 (참고)
- `domain/entities/location.dart`
- `data/models/location_model.dart`
- `data/datasources/location_remote_datasource.dart`

---

## ✅ 체크리스트

수정 완료 후 확인사항:

- [ ] Bank 선택 시 "Currency: USD" 형식으로 표시
- [ ] Vault 선택 시 "Currency: KRW" 형식으로 표시
- [ ] Cash 선택 시 subtitle 없음 (기존 유지)
- [ ] UUID 노출 완전 제거
- [ ] Cash/Bank/Vault UI 일관성 유지
- [ ] TODO 주석 제거
- [ ] 전체 기능 테스트 통과

---

## 🎬 결론

### 현재 상태
- ❌ UUID 노출로 사용자 혼란
- ❌ Cash vs Bank UI 불일치
- ❌ TODO 미구현 (기술 부채)

### 개선 후 기대 효과
- ✅ 사용자 친화적 UI (USD, VND 표시)
- ✅ 일관된 UX
- ✅ 코드 품질 향상 (TODO 제거)
- ✅ 보안 개선 (내부 ID 숨김)

---

**분석자**: 30년차 Flutter 개발자
**우선순위**: P0 (즉시 수정 권장)
**예상 소요 시간**: 15-30분
