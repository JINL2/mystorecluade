# Cash Ending - Flutter 개발 가이드

## 문서 정보
- **대상**: Flutter 개발팀
- **목적**: Cash Ending UTC 마이그레이션 코드 수정
- **전제조건**: DB 팀의 RPC 함수 생성 완료
- **작성일**: 2025-11-25

---

## 🎯 작업 범위

### Phase 1: 트리거 확인
❌ **코드 수정 없음** - DB 트리거가 자동으로 `_utc` 컬럼 채움

### Phase 2: 조회 RPC 변경
✅ **수정 필요** - 신규 RPC 호출 + DTO 변경

---

## 📝 수정 대상 파일 (4개)

### 1. `data/datasources/stock_flow_remote_datasource.dart`
**변경 범위**: RPC 함수명

### 2. `data/models/freezed/stock_flow_dto.dart`
**변경 범위**: JSON 파싱 시 `_utc` 컬럼 사용

### 3. `data/datasources/cash_ending_remote_datasource.dart`
**변경 범위**: 잔액 조회 RPC 함수명

### 4. `data/models/freezed/balance_summary_dto.dart`
**변경 범위**: JSON 파싱 로직

---

## 🔧 수정 상세

### 파일 1: `stock_flow_remote_datasource.dart`

**위치**: `lib/features/cash_ending/data/datasources/stock_flow_remote_datasource.dart`

#### 수정 전
```dart
Future<List<StockFlowDto>> getLocationStockFlow({
  required String companyId,
  required String locationId,
  required DateTime startDate,
  required DateTime endDate,
}) async {
  try {
    final result = await _supabase.rpc<List<dynamic>>(
      'get_location_stock_flow',  // ❌ 구 버전
      params: {
        'p_company_id': companyId,
        'p_location_id': locationId,
        'p_start_date': DateTimeUtils.toDateOnly(startDate),
        'p_end_date': DateTimeUtils.toDateOnly(endDate),
      },
    );

    return (result as List)
        .map((json) => StockFlowDto.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception('Failed to get stock flow: $e');
  }
}
```

#### 수정 후
```dart
Future<List<StockFlowDto>> getLocationStockFlow({
  required String companyId,
  required String locationId,
  required DateTime startDate,
  required DateTime endDate,
}) async {
  try {
    final result = await _supabase.rpc<List<dynamic>>(
      'get_location_stock_flow_utc',  // ✅ 신 버전
      params: {
        'p_company_id': companyId,
        'p_location_id': locationId,
        'p_start_date': DateTimeUtils.toDateOnly(startDate),  // 그대로 유지
        'p_end_date': DateTimeUtils.toDateOnly(endDate),      // 그대로 유지
      },
    );

    return (result as List)
        .map((json) => StockFlowDto.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception('Failed to get stock flow: $e');
  }
}
```

**변경 요약**:
- Line: RPC 함수명만 변경 (`_utc` 추가)
- 파라미터 형식은 동일 유지

---

### 파일 2: `stock_flow_dto.dart`

**위치**: `lib/features/cash_ending/data/models/freezed/stock_flow_dto.dart`

#### 수정 전
```dart
factory StockFlowDto.fromJson(Map<String, dynamic> json) {
  return StockFlowDto(
    flowId: json['flow_id'] as String,
    companyId: json['company_id'] as String,
    storeId: json['store_id'] as String?,
    cashLocationId: json['cash_location_id'] as String,
    locationType: json['location_type'] as String,
    currencyId: json['currency_id'] as String,
    flowAmount: (json['flow_amount'] as num).toDouble(),
    balanceBefore: (json['balance_before'] as num).toDouble(),
    balanceAfter: (json['balance_after'] as num).toDouble(),
    denominationDetails: json['denomination_details'],
    createdBy: json['created_by'] as String,
    createdAt: json['created_at'] != null        // ❌ 구 컬럼
        ? DateTime.parse(json['created_at'])
        : DateTime.now(),
    systemTime: json['system_time'] != null      // ❌ 구 컬럼
        ? DateTime.parse(json['system_time'])
        : DateTime.now(),
    baseCurrencyId: json['base_currency_id'] as String?,
    appliedExchangeRate: json['applied_exchange_rate'] != null
        ? (json['applied_exchange_rate'] as num).toDouble()
        : null,
    originalCurrencyAmount: json['original_currency_amount'] != null
        ? (json['original_currency_amount'] as num).toDouble()
        : null,
  );
}
```

#### 수정 후
```dart
factory StockFlowDto.fromJson(Map<String, dynamic> json) {
  return StockFlowDto(
    flowId: json['flow_id'] as String,
    companyId: json['company_id'] as String,
    storeId: json['store_id'] as String?,
    cashLocationId: json['cash_location_id'] as String,
    locationType: json['location_type'] as String,
    currencyId: json['currency_id'] as String,
    flowAmount: (json['flow_amount'] as num).toDouble(),
    balanceBefore: (json['balance_before'] as num).toDouble(),
    balanceAfter: (json['balance_after'] as num).toDouble(),
    denominationDetails: json['denomination_details'],
    createdBy: json['created_by'] as String,
    createdAt: json['created_at'] != null        // ✅ RPC에서 이미 UTC
        ? DateTime.parse(json['created_at'])      // RPC가 created_at_utc를 created_at으로 반환
        : DateTime.now(),
    systemTime: json['system_time'] != null      // ✅ RPC에서 이미 UTC
        ? DateTime.parse(json['system_time'])    // RPC가 system_time_utc를 system_time으로 반환
        : DateTime.now(),
    baseCurrencyId: json['base_currency_id'] as String?,
    appliedExchangeRate: json['applied_exchange_rate'] != null
        ? (json['applied_exchange_rate'] as num).toDouble()
        : null,
    originalCurrencyAmount: json['original_currency_amount'] != null
        ? (json['original_currency_amount'] as num).toDouble()
        : null,
  );
}
```

**변경 요약**:
- 코드는 동일
- RPC가 `created_at_utc`를 `created_at`으로 반환하므로 DTO 변경 불필요
- 주석만 추가하여 UTC 사용을 명확히 함

---

### 파일 3: `cash_ending_remote_datasource.dart`

**위치**: `lib/features/cash_ending/data/datasources/cash_ending_remote_datasource.dart`

#### 수정 전
```dart
Future<BalanceSummaryDto> getLocationBalanceSummary({
  required String companyId,
  required String locationId,
  required DateTime currentDate,
}) async {
  try {
    final result = await _supabase.rpc<Map<String, dynamic>>(
      'get_cash_location_balance_summary_v2',  // ❌ 구 버전
      params: {
        'p_company_id': companyId,
        'p_location_id': locationId,
        'p_current_date': DateTimeUtils.toDateOnly(currentDate),
      },
    );

    return BalanceSummaryDto.fromJson(result);
  } catch (e) {
    throw Exception('Failed to get balance summary: $e');
  }
}

Future<List<BalanceSummaryDto>> getMultipleLocationsBalanceSummary({
  required String companyId,
  required List<String> locationIds,
  required DateTime date,
}) async {
  try {
    final result = await _supabase.rpc<List<dynamic>>(
      'get_multiple_locations_balance_summary',  // ❌ 구 버전
      params: {
        'p_company_id': companyId,
        'p_location_ids': locationIds,
        'p_date': DateTimeUtils.toDateOnly(date),
      },
    );

    return (result as List)
        .map((json) => BalanceSummaryDto.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception('Failed to get multiple balances: $e');
  }
}

Future<Map<String, dynamic>> getCompanyBalanceSummary({
  required String companyId,
  required DateTime date,
}) async {
  try {
    final result = await _supabase.rpc<Map<String, dynamic>>(
      'get_company_balance_summary',  // ❌ 구 버전
      params: {
        'p_company_id': companyId,
        'p_date': DateTimeUtils.toDateOnly(date),
      },
    );

    return result;
  } catch (e) {
    throw Exception('Failed to get company balance: $e');
  }
}
```

#### 수정 후
```dart
Future<BalanceSummaryDto> getLocationBalanceSummary({
  required String companyId,
  required String locationId,
  required DateTime currentDate,
}) async {
  try {
    final result = await _supabase.rpc<Map<String, dynamic>>(
      'get_cash_location_balance_summary_v2_utc',  // ✅ 신 버전
      params: {
        'p_company_id': companyId,
        'p_location_id': locationId,
        'p_current_date': DateTimeUtils.toDateOnly(currentDate),  // 동일 유지
      },
    );

    return BalanceSummaryDto.fromJson(result);
  } catch (e) {
    throw Exception('Failed to get balance summary: $e');
  }
}

Future<List<BalanceSummaryDto>> getMultipleLocationsBalanceSummary({
  required String companyId,
  required List<String> locationIds,
  required DateTime date,
}) async {
  try {
    final result = await _supabase.rpc<List<dynamic>>(
      'get_multiple_locations_balance_summary_utc',  // ✅ 신 버전
      params: {
        'p_company_id': companyId,
        'p_location_ids': locationIds,
        'p_date': DateTimeUtils.toDateOnly(date),  // 동일 유지
      },
    );

    return (result as List)
        .map((json) => BalanceSummaryDto.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception('Failed to get multiple balances: $e');
  }
}

Future<Map<String, dynamic>> getCompanyBalanceSummary({
  required String companyId,
  required DateTime date,
}) async {
  try {
    final result = await _supabase.rpc<Map<String, dynamic>>(
      'get_company_balance_summary_utc',  // ✅ 신 버전
      params: {
        'p_company_id': companyId,
        'p_date': DateTimeUtils.toDateOnly(date),  // 동일 유지
      },
    );

    return result;
  } catch (e) {
    throw Exception('Failed to get company balance: $e');
  }
}
```

**변경 요약**:
- 3개 함수 모두 RPC 함수명에 `_utc` 추가
- 파라미터는 동일 유지

---

### 파일 4: `balance_summary_dto.dart`

**위치**: `lib/features/cash_ending/data/models/freezed/balance_summary_dto.dart`

#### 수정 불필요
```dart
factory BalanceSummaryDto.fromJson(Map<String, dynamic> json) {
  return BalanceSummaryDto(
    currentBalance: (json['current_balance'] as num).toDouble(),
    previousBalance: (json['previous_balance'] as num).toDouble(),
    // 시간 관련 필드 없음 - 수정 불필요
  );
}
```

**변경 요약**: ❌ 변경 없음 (시간 데이터 없음)

---

## 🧪 테스트

### 단위 테스트

#### `stock_flow_dto_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:myfinance/features/cash_ending/data/models/freezed/stock_flow_dto.dart';

void main() {
  group('StockFlowDto UTC Tests', () {
    test('fromJson should parse UTC timestamps correctly', () {
      final json = {
        'flow_id': 'test-id',
        'company_id': 'company-id',
        'cash_location_id': 'location-id',
        'location_type': 'cash',
        'currency_id': 'currency-id',
        'flow_amount': 10000.0,
        'balance_before': 50000.0,
        'balance_after': 60000.0,
        'created_by': 'user-id',
        'created_at': '2025-01-15T05:30:00.000Z',    // UTC
        'system_time': '2025-01-15T05:30:01.234Z',   // UTC
      };

      final dto = StockFlowDto.fromJson(json);

      expect(dto.createdAt, isA<DateTime>());
      expect(dto.createdAt.isUtc, true);  // ✅ UTC 확인
      expect(dto.systemTime.isUtc, true); // ✅ UTC 확인
    });
  });
}
```

### 통합 테스트

#### `stock_flow_datasource_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance/features/cash_ending/data/datasources/stock_flow_remote_datasource.dart';

void main() {
  group('StockFlow DataSource Integration', () {
    late StockFlowRemoteDataSource dataSource;
    late SupabaseClient supabase;

    setUpAll(() async {
      await Supabase.initialize(
        url: 'YOUR_SUPABASE_URL',
        anonKey: 'YOUR_SUPABASE_ANON_KEY',
      );
      supabase = Supabase.instance.client;
      dataSource = StockFlowRemoteDataSource(supabase);
    });

    test('getLocationStockFlow should use UTC RPC', () async {
      final result = await dataSource.getLocationStockFlow(
        companyId: 'test-company',
        locationId: 'test-location',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 31),
      );

      expect(result, isA<List>());
      if (result.isNotEmpty) {
        expect(result.first.createdAt.isUtc, true);
      }
    });
  });
}
```

---

## 🔍 디버깅

### RPC 호출 확인
```dart
// datasource에서 디버그 출력
debugPrint('🔍 Calling get_location_stock_flow_utc');
debugPrint('  Company: $companyId');
debugPrint('  Location: $locationId');
debugPrint('  Start: $startDate');
debugPrint('  End: $endDate');

final result = await _supabase.rpc(...);

debugPrint('✅ Received ${result.length} records');
```

### DTO 파싱 확인
```dart
// DTO에서 디버그 출력
factory StockFlowDto.fromJson(Map<String, dynamic> json) {
  debugPrint('📦 Parsing StockFlowDto');
  debugPrint('  created_at: ${json['created_at']}');
  debugPrint('  system_time: ${json['system_time']}');

  final dto = StockFlowDto(...);

  debugPrint('  ✅ Parsed createdAt: ${dto.createdAt}');
  debugPrint('  ✅ Is UTC: ${dto.createdAt.isUtc}');

  return dto;
}
```

---

## 🚀 배포 순서

### 1. 로컬 테스트
```bash
flutter pub get
flutter analyze
flutter test
```

### 2. 스테이징 배포
```bash
flutter build apk --debug
# 스테이징 환경에서 테스트
# - Stock flow 조회
# - 잔액 요약 조회
# - 시간대 확인
```

### 3. 프로덕션 배포
```bash
flutter build apk --release
flutter build ios --release
```

---

## ⚠️ 주의사항

### 1. RPC 함수명
- ✅ **올바름**: `get_location_stock_flow_utc`
- ❌ **잘못됨**: `get_location_stock_flow`

### 2. DateTime 파싱
```dart
// ✅ 올바른 방식
final dt = DateTime.parse(json['created_at']);  // ISO8601 자동 파싱
expect(dt.isUtc, true);

// ❌ 잘못된 방식 (불필요)
final dt = DateTime.parse(json['created_at']).toUtc();  // 이미 UTC
```

### 3. 로컬 시간 표시
```dart
// UI에서 로컬 시간으로 변환
final localTime = stockFlow.createdAt.toLocal();
print('${localTime.year}-${localTime.month}-${localTime.day}');
```

---

## 📋 체크리스트

### 코드 수정
- [ ] `stock_flow_remote_datasource.dart` 수정
- [ ] `cash_ending_remote_datasource.dart` 수정 (3개 함수)
- [ ] 주석 추가 (UTC 사용 명시)

### 테스트
- [ ] 단위 테스트 작성
- [ ] 통합 테스트 작성
- [ ] 로컬 테스트 통과

### 배포
- [ ] DB 팀 RPC 생성 확인
- [ ] 코드 리뷰 완료
- [ ] 스테이징 배포
- [ ] 프로덕션 배포

---

**문서 작성일**: 2025-11-25
**담당**: Cash Ending Flutter 팀
