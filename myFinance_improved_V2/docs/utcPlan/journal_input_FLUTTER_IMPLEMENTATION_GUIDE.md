# Journal Input - Flutter 구현 가이드

## 문서 정보
- **대상**: Flutter 개발팀
- **목적**: UTC 마이그레이션 코드 수정 가이드
- **전제 조건**: DB 팀의 RPC 함수 생성 완료
- **작성일**: 2025-11-25

---

## 🎯 수정 대상 파일 (2개)

### 1. `data/models/transaction_line_model.dart`
- **수정 범위**: `toJson()` 메서드
- **변경 내용**: 날짜 형식 변경 (`toDateOnly()` → `toUtc()`)

### 2. `data/datasources/journal_entry_datasource.dart`
- **수정 범위**: `submitJournalEntry()` 메서드
- **변경 내용**: RPC 함수명, 파라미터명, 날짜 형식 변경

---

## 📝 수정 사항 상세

### 파일 1: `transaction_line_model.dart`

**현재 위치**: `lib/features/journal_input/data/models/transaction_line_model.dart`

#### 수정 전 (Line 125-187)
```dart
// Convert to JSON for API submission
Map<String, dynamic> toJson() {
  final json = <String, dynamic>{
    'account_id': accountId,
    'description': description,
    'debit': isDebit ? amount.toString() : '0',
    'credit': !isDebit ? amount.toString() : '0',
  };

  // Add counterparty if present
  if (counterpartyId != null && counterpartyId!.isNotEmpty) {
    json['counterparty_id'] = counterpartyId;
  }

  // Add cash location if it's a cash account
  if (categoryTag == 'cash' && cashLocationId != null) {
    json['cash'] = {
      'cash_location_id': cashLocationId,
    };
  }

  // Add debt information if it's payable/receivable
  if ((categoryTag == 'payable' || categoryTag == 'receivable') &&
      counterpartyId != null &&
      (debtCategory != null || interestRate != null)) {
    json['debt'] = {
      'direction': categoryTag,
      'category': debtCategory ?? 'other',
      'counterparty_id': counterpartyId,
      'original_amount': amount.toString(),
      'interest_rate': (interestRate ?? 0.0).toString(),
      'interest_account_id': '',
      'interest_due_day': 0,
      'issue_date': issueDate != null
          ? DateTimeUtils.toDateOnly(issueDate!)              // ❌ 날짜만 전송
          : DateTimeUtils.toDateOnly(DateTime.now()),
      'due_date': dueDate != null
          ? DateTimeUtils.toDateOnly(dueDate!)                // ❌ 날짜만 전송
          : DateTimeUtils.toDateOnly(DateTime.now().add(const Duration(days: 30))),
      'description': debtDescription ?? '',
      'linkedCounterparty_store_id': counterpartyStoreId ?? '',
      'linkedCounterparty_companyId': linkedCompanyId ?? '',
    };
  }

  // Add fixed asset information if it's a fixed asset
  if (categoryTag == 'fixedasset' && fixedAssetName != null) {
    json['fix_asset'] = {
      'asset_name': fixedAssetName,
      'salvage_value': (salvageValue ?? 0.0).toString(),
      'acquire_date': acquisitionDate != null
          ? DateTimeUtils.toDateOnly(acquisitionDate!)        // ❌ 날짜만 전송
          : DateTimeUtils.toDateOnly(DateTime.now()),
      'useful_life': (usefulLife ?? 5).toString(),
    };
  }

  // Add account mapping if available
  if (accountMapping != null) {
    json['account_mapping'] = accountMapping;
  }

  return json;
}
```

#### 수정 후 (권장)
```dart
// Convert to JSON for API submission
Map<String, dynamic> toJson() {
  final json = <String, dynamic>{
    'account_id': accountId,
    'description': description,
    'debit': isDebit ? amount.toString() : '0',
    'credit': !isDebit ? amount.toString() : '0',
  };

  // Add counterparty if present
  if (counterpartyId != null && counterpartyId!.isNotEmpty) {
    json['counterparty_id'] = counterpartyId;
  }

  // Add cash location if it's a cash account
  if (categoryTag == 'cash' && cashLocationId != null) {
    json['cash'] = {
      'cash_location_id': cashLocationId,
    };
  }

  // Add debt information if it's payable/receivable
  if ((categoryTag == 'payable' || categoryTag == 'receivable') &&
      counterpartyId != null &&
      (debtCategory != null || interestRate != null)) {
    json['debt'] = {
      'direction': categoryTag,
      'category': debtCategory ?? 'other',
      'counterparty_id': counterpartyId,
      'original_amount': amount.toString(),
      'interest_rate': (interestRate ?? 0.0).toString(),
      'interest_account_id': '',
      'interest_due_day': 0,
      'issue_date': issueDate != null
          ? DateTimeUtils.toUtc(issueDate!)              // ✅ UTC ISO8601
          : DateTimeUtils.nowUtc(),
      'due_date': dueDate != null
          ? DateTimeUtils.toUtc(dueDate!)                // ✅ UTC ISO8601
          : DateTimeUtils.toUtc(DateTime.now().add(const Duration(days: 30))),
      'description': debtDescription ?? '',
      'linkedCounterparty_store_id': counterpartyStoreId ?? '',
      'linkedCounterparty_companyId': linkedCompanyId ?? '',
    };
  }

  // Add fixed asset information if it's a fixed asset
  if (categoryTag == 'fixedasset' && fixedAssetName != null) {
    json['fix_asset'] = {
      'asset_name': fixedAssetName,
      'salvage_value': (salvageValue ?? 0.0).toString(),
      'acquire_date': acquisitionDate != null
          ? DateTimeUtils.toUtc(acquisitionDate!)        // ✅ UTC ISO8601
          : DateTimeUtils.nowUtc(),
      'useful_life': (usefulLife ?? 5).toString(),
    };
  }

  // Add account mapping if available
  if (accountMapping != null) {
    json['account_mapping'] = accountMapping;
  }

  return json;
}
```

**변경 요약**:
- Line 157-158: `toDateOnly(issueDate!)` → `toUtc(issueDate!)`
- Line 159: `toDateOnly(DateTime.now())` → `nowUtc()`
- Line 160-161: `toDateOnly(dueDate!)` → `toUtc(dueDate!)`
- Line 162: `toDateOnly(...)` → `toUtc(...)`
- Line 175-176: `toDateOnly(acquisitionDate!)` → `toUtc(acquisitionDate!)`
- Line 177: `toDateOnly(DateTime.now())` → `nowUtc()`

---

### 파일 2: `journal_entry_datasource.dart`

**현재 위치**: `lib/features/journal_input/data/datasources/journal_entry_datasource.dart`

#### 수정 전 (Line 171-212)
```dart
/// Submit journal entry using RPC
Future<void> submitJournalEntry({
  required JournalEntryModel journalEntry,
  required String userId,
  required String companyId,
  String? storeId,
}) async {
  try {
    // Convert entry date to UTC for database storage
    // RPC expects 'yyyy-MM-dd HH:mm:ss' format in UTC
    final entryDate = DateTimeUtils.toRpcFormat(journalEntry.entryDate);  // ❌ RPC 형식

    // Prepare journal lines
    final pLines = journalEntry.getTransactionLinesJson();

    // Get main counterparty ID
    final mainCounterpartyId = journalEntry.getMainCounterpartyId();

    // Calculate total debits for base amount
    final totalDebits = journalEntry.transactionLines
        .where((line) => line.isDebit)
        .fold(0.0, (sum, line) => sum + line.amount);

    // Call the journal RPC
    await _supabase.rpc<void>(
      'insert_journal_with_everything',              // ❌ 구 함수
      params: {
        'p_base_amount': totalDebits,
        'p_company_id': companyId,
        'p_created_by': userId,
        'p_description': journalEntry.overallDescription,
        'p_entry_date': entryDate,                   // ❌ 구 파라미터
        'p_lines': pLines,
        'p_counterparty_id': mainCounterpartyId,
        'p_if_cash_location_id': journalEntry.counterpartyCashLocationId,
        'p_store_id': storeId,
      },
    );
  } catch (e) {
    throw Exception('Failed to create journal entry: $e');
  }
}
```

#### 수정 후 (권장)
```dart
/// Submit journal entry using RPC (UTC version)
Future<void> submitJournalEntry({
  required JournalEntryModel journalEntry,
  required String userId,
  required String companyId,
  String? storeId,
}) async {
  try {
    // Convert entry date to UTC ISO8601 for timestamptz storage
    final entryDateUtc = DateTimeUtils.toUtc(journalEntry.entryDate);  // ✅ ISO8601 UTC

    // Prepare journal lines (이미 toJson()에서 UTC 변환됨)
    final pLines = journalEntry.getTransactionLinesJson();

    // Get main counterparty ID
    final mainCounterpartyId = journalEntry.getMainCounterpartyId();

    // Calculate total debits for base amount
    final totalDebits = journalEntry.transactionLines
        .where((line) => line.isDebit)
        .fold(0.0, (sum, line) => sum + line.amount);

    // Call the new UTC-aware journal RPC
    await _supabase.rpc<void>(
      'insert_journal_with_everything_utc',          // ✅ 신 함수
      params: {
        'p_base_amount': totalDebits,
        'p_company_id': companyId,
        'p_created_by': userId,
        'p_description': journalEntry.overallDescription,
        'p_entry_date_utc': entryDateUtc,            // ✅ 신 파라미터 (timestamptz)
        'p_lines': pLines,
        'p_counterparty_id': mainCounterpartyId,
        'p_if_cash_location_id': journalEntry.counterpartyCashLocationId,
        'p_store_id': storeId,
      },
    );
  } catch (e) {
    throw Exception('Failed to create journal entry: $e');
  }
}
```

**변경 요약**:
- Line 181: `DateTimeUtils.toRpcFormat()` → `DateTimeUtils.toUtc()`
- Line 182 주석: RPC 형식 설명 → ISO8601 설명으로 변경
- Line 195: RPC 함수명 변경
- Line 202: 파라미터명 변경 `p_entry_date` → `p_entry_date_utc`

---

## 🧪 테스트 계획

### 1. 단위 테스트

#### `transaction_line_model_test.dart` (새로 생성)
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:myfinance/features/journal_input/data/models/transaction_line_model.dart';
import 'package:myfinance/core/utils/datetime_utils.dart';

void main() {
  group('TransactionLineModel UTC Migration Tests', () {

    test('toJson should convert debt dates to UTC ISO8601', () {
      final issueDate = DateTime(2025, 1, 15, 14, 30); // Local time
      final dueDate = DateTime(2025, 2, 15, 14, 30);   // Local time

      final model = TransactionLineModel(
        accountId: 'test-account-id',
        amount: 10000,
        isDebit: false,
        categoryTag: 'payable',
        counterpartyId: 'test-counterparty-id',
        debtCategory: 'trade',
        interestRate: 5.5,
        issueDate: issueDate,
        dueDate: dueDate,
      );

      final json = model.toJson();

      expect(json['debt'], isNotNull);
      expect(json['debt']['issue_date'], contains('T'));
      expect(json['debt']['issue_date'], contains('Z'));
      expect(json['debt']['due_date'], contains('T'));
      expect(json['debt']['due_date'], contains('Z'));

      // Verify UTC conversion
      final parsedIssue = DateTime.parse(json['debt']['issue_date']);
      expect(parsedIssue.isUtc, true);
    });

    test('toJson should convert fixed asset acquisition date to UTC ISO8601', () {
      final acquisitionDate = DateTime(2025, 1, 15, 9, 0);

      final model = TransactionLineModel(
        accountId: 'test-account-id',
        amount: 1000000,
        isDebit: true,
        categoryTag: 'fixedasset',
        fixedAssetName: 'Test Equipment',
        salvageValue: 100000,
        acquisitionDate: acquisitionDate,
        usefulLife: 10,
      );

      final json = model.toJson();

      expect(json['fix_asset'], isNotNull);
      expect(json['fix_asset']['acquire_date'], contains('T'));
      expect(json['fix_asset']['acquire_date'], contains('Z'));

      final parsed = DateTime.parse(json['fix_asset']['acquire_date']);
      expect(parsed.isUtc, true);
    });
  });
}
```

### 2. 통합 테스트

#### `journal_entry_datasource_integration_test.dart` (새로 생성)
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance/features/journal_input/data/datasources/journal_entry_datasource.dart';
import 'package:myfinance/features/journal_input/data/models/journal_entry_model.dart';
import 'package:myfinance/features/journal_input/data/models/transaction_line_model.dart';

void main() {
  group('JournalEntryDataSource UTC Integration Tests', () {
    late JournalEntryDataSource dataSource;
    late SupabaseClient supabase;

    setUpAll(() async {
      // Initialize Supabase for testing
      await Supabase.initialize(
        url: 'YOUR_SUPABASE_URL',
        anonKey: 'YOUR_SUPABASE_ANON_KEY',
      );
      supabase = Supabase.instance.client;
      dataSource = JournalEntryDataSource(supabase);
    });

    test('submitJournalEntry should use UTC RPC function', () async {
      final journalEntry = JournalEntryModel(
        entryDate: DateTime(2025, 1, 15, 14, 30),
        overallDescription: 'Test entry',
        transactionLines: [
          TransactionLineModel(
            accountId: 'test-debit-account',
            amount: 10000,
            isDebit: true,
            description: 'Test debit',
          ),
          TransactionLineModel(
            accountId: 'test-credit-account',
            amount: 10000,
            isDebit: false,
            description: 'Test credit',
          ),
        ],
      );

      await dataSource.submitJournalEntry(
        journalEntry: journalEntry,
        userId: 'test-user-id',
        companyId: 'test-company-id',
        storeId: 'test-store-id',
      );

      // Verify in database that _utc columns are populated
      final result = await supabase
          .from('journals')
          .select('entry_date_utc')
          .order('created_at_utc', ascending: false)
          .limit(1)
          .single();

      expect(result['entry_date_utc'], isNotNull);
    });
  });
}
```

### 3. 수동 테스트 체크리스트

#### 기본 분개 입력
- [ ] 분개 날짜 선택 후 저장
- [ ] DB에서 `journal_entries.entry_date_utc` 확인 (✅ 실제 테이블명)
- [ ] 시간대 변환 정확성 확인

#### 채무/채권 분개
- [ ] 채무 계정 선택
- [ ] 발행일, 만기일 입력
- [ ] 저장 후 DB에서 `debts_receivable.issue_date_utc`, `due_date_utc` 확인 (✅ 실제 테이블명)
- [ ] 시간대 변환 정확성 확인

#### 고정자산 취득 분개
- [ ] 고정자산 계정 선택
- [ ] 취득일 입력
- [ ] 저장 후 DB에서 `fixed_assets.acquisition_date_utc` 확인
- [ ] 시간대 변환 정확성 확인

#### 시간대별 테스트
- [ ] 한국 시간대 (UTC+9) 테스트
- [ ] 베트남 시간대 (UTC+7) 테스트
- [ ] 미국 동부 시간대 (UTC-5) 테스트
- [ ] 영국 시간대 (UTC+0) 테스트

---

## 🔍 디버깅 가이드

### 날짜 형식 확인
```dart
// 디버그 모드에서 날짜 형식 출력
debugPrint('Entry Date UTC: ${DateTimeUtils.toUtc(journalEntry.entryDate)}');
debugPrint('Issue Date UTC: ${DateTimeUtils.toUtc(issueDate!)}');
debugPrint('Due Date UTC: ${DateTimeUtils.toUtc(dueDate!)}');
```

### RPC 호출 확인
```dart
// RPC 호출 전 파라미터 출력
debugPrint('🔍 Calling insert_journal_with_everything_utc');
debugPrint('  p_entry_date_utc: $entryDateUtc');
debugPrint('  p_lines: ${jsonEncode(pLines)}');
```

### 데이터베이스 확인
```sql
-- 최근 입력된 분개 확인
SELECT
  journal_id,
  entry_date,              -- date 타입
  entry_date_utc,          -- timestamptz 타입
  entry_date_utc AT TIME ZONE 'Asia/Seoul' AS entry_date_kst,
  entry_date_utc AT TIME ZONE 'Asia/Ho_Chi_Minh' AS entry_date_vn,
  created_at_utc
FROM journal_entries       -- ✅ 실제 테이블명
ORDER BY created_at_utc DESC
LIMIT 10;
```

---

## ⚠️ 주의사항

### 1. DateTimeUtils 사용
- ✅ **올바름**: `DateTimeUtils.toUtc(dateTime)`
- ✅ **올바름**: `DateTimeUtils.nowUtc()`
- ❌ **잘못됨**: `DateTimeUtils.toRpcFormat(dateTime)`
- ❌ **잘못됨**: `DateTimeUtils.toDateOnly(dateTime)`
- ❌ **잘못됨**: `dateTime.toIso8601String()` (로컬 시간 가능성)

### 2. RPC 함수명
- ✅ **올바름**: `insert_journal_with_everything_utc`
- ❌ **잘못됨**: `insert_journal_with_everything`

### 3. 파라미터명
- ✅ **올바름**: `p_entry_date_utc`
- ❌ **잘못됨**: `p_entry_date`

### 4. 날짜 객체 생성
```dart
// ❌ 잘못된 예시 (로컬 시간으로 인식될 수 있음)
final date = DateTime(2025, 1, 15);

// ✅ 올바른 예시 (UTC로 명시)
final date = DateTime.utc(2025, 1, 15);

// ✅ 또는 현재 시간 사용
final date = DateTime.now(); // 로컬 시간 → toUtc()가 UTC로 변환
```

---

## 🚀 배포 프로세스

### 1. 개발 환경
```bash
# 의존성 업데이트
flutter pub get

# 코드 분석
flutter analyze

# 테스트 실행
flutter test

# 빌드 테스트
flutter build apk --debug
```

### 2. 스테이징 환경
```bash
# 스테이징 빌드
flutter build apk --release --flavor staging

# 배포 후 검증
# - 분개 입력 테스트
# - 채무 정보 테스트
# - 고정자산 테스트
```

### 3. 프로덕션 환경
```bash
# 프로덕션 빌드
flutter build apk --release --flavor production
flutter build ios --release --flavor production

# 배포 전 최종 검증
# - 코드 리뷰 완료 확인
# - QA 테스트 통과 확인
# - DB 팀 준비 완료 확인
```

---

## 📊 마이그레이션 영향 분석

### 영향 받는 기능
1. ✅ 분개 입력 (Journal Entry Creation) - `journal_entries` 테이블
2. ✅ 채무/채권 생성 (Debt/Receivable Creation) - `debts_receivable` 테이블
3. ✅ 고정자산 취득 (Fixed Asset Acquisition) - `fixed_assets` 테이블

### 영향 받지 않는 기능
1. ✅ 계정 조회 (Account Lookup)
2. ✅ 거래처 조회 (Counterparty Lookup)
3. ✅ 점포 조회 (Store Lookup)
4. ✅ 계정 매핑 조회 (Account Mapping Lookup)
5. ✅ 현금 위치 조회 (Cash Location Lookup) - `get_cash_locations` RPC
6. ✅ 환율 조회 (Exchange Rate Lookup) - `get_exchange_rate_v2` RPC

### 데이터 읽기 (SELECT)
- ⚠️ **추후 작업 필요**: 분개 조회 기능에서도 `_utc` 컬럼 사용하도록 수정
- 현재는 **입력(INSERT)만 마이그레이션**
- ⚠️ **주의**: 테이블명 변경 (`journals` → `journal_entries`, `debts` → `debts_receivable`)

---

## 🔄 롤백 절차

문제 발생 시 아래 단계로 롤백:

### Step 1: 코드 롤백
```dart
// journal_entry_datasource.dart
// Line 181
final entryDate = DateTimeUtils.toRpcFormat(journalEntry.entryDate);

// Line 195
await _supabase.rpc<void>(
  'insert_journal_with_everything',  // 구 함수로 복구
  params: {
    'p_entry_date': entryDate,       // 구 파라미터로 복구
    // ...
  },
);
```

```dart
// transaction_line_model.dart
// Line 157-162 (debt)
'issue_date': issueDate != null
    ? DateTimeUtils.toDateOnly(issueDate!)
    : DateTimeUtils.toDateOnly(DateTime.now()),
'due_date': dueDate != null
    ? DateTimeUtils.toDateOnly(dueDate!)
    : DateTimeUtils.toDateOnly(DateTime.now().add(const Duration(days: 30))),

// Line 175-177 (fixed asset)
'acquire_date': acquisitionDate != null
    ? DateTimeUtils.toDateOnly(acquisitionDate!)
    : DateTimeUtils.toDateOnly(DateTime.now()),
```

### Step 2: 긴급 배포
```bash
flutter build apk --release
# 배포 시스템을 통해 긴급 배포
```

### Step 3: 원인 분석
- RPC 함수 에러 로그 확인
- 데이터베이스 테이블 상태 확인
- 클라이언트 에러 로그 수집

---

## 📈 모니터링

### 배포 후 모니터링 항목

1. **에러 레이트**
   - RPC 호출 실패율
   - 분개 입력 실패율

2. **성능**
   - RPC 함수 응답 시간
   - 데이터베이스 쿼리 시간

3. **데이터 품질**
   - `_utc` 컬럼 NULL 비율
   - 시간대 변환 오류율

### 알람 설정
```sql
-- _utc 컬럼이 NULL인 새 레코드 모니터링
SELECT COUNT(*)
FROM journal_entries      -- ✅ 실제 테이블명
WHERE created_at_utc > NOW() - INTERVAL '1 hour'
  AND entry_date_utc IS NULL;
```

---

## ✅ 최종 체크리스트

### 코드 수정 완료
- [ ] `transaction_line_model.dart` 수정 완료
- [ ] `journal_entry_datasource.dart` 수정 완료
- [ ] 주석 업데이트 완료

### 테스트 완료
- [ ] 단위 테스트 작성 및 통과
- [ ] 통합 테스트 작성 및 통과
- [ ] 수동 테스트 완료

### 코드 리뷰
- [ ] 코드 리뷰 요청 생성
- [ ] 리뷰어 승인 완료
- [ ] 변경 사항 문서화 완료

### 배포 준비
- [ ] DB 팀 RPC 함수 생성 확인
- [ ] 스테이징 환경 준비 완료
- [ ] 롤백 계획 수립 완료

---

**마지막 업데이트**: 2025-11-25
