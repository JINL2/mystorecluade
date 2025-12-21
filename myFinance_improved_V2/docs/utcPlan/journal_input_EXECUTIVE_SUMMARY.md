# Journal Input Feature - UTC 마이그레이션 요약 보고서

## 📋 Executive Summary

### 목적
글로벌 서비스 준비를 위해 `journal_input` 피처의 모든 시간 관련 데이터를 `timestamp` → `timestamptz`로 마이그레이션

### 핵심 전략
- ✅ 새 컬럼 (`_utc` 접미사) 추가
- ✅ 새 RPC 함수 (`_utc` 접미사) 생성
- ✅ 기존 시스템 무중단 운영
- ✅ 점진적 전환

---

## 🔍 스캔 결과 요약

### 대상 폴더
```
/lib/features/journal_input
```

### 발견된 의존성

#### RPC 함수 (3개)
| RPC 함수 | 마이그레이션 필요 | 이유 |
|----------|------------------|------|
| `get_cash_locations` | ❌ 불필요 | 시간 데이터 없음 |
| `get_exchange_rate_v2` | ❌ 불필요 | 시간 데이터 없음 |
| `insert_journal_with_everything` | ✅ **필수** | 시간 데이터 4개 포함 |

#### 테이블 쿼리 (4개)
| 테이블 | 마이그레이션 필요 | 이유 |
|--------|------------------|------|
| `accounts` | ❌ 불필요 | 조회만 수행 |
| `counterparties` | ❌ 불필요 | 조회만 수행 |
| `stores` | ❌ 불필요 | 조회만 수행 |
| `account_mappings` | ❌ 불필요 | 조회만 수행 |

#### 시간 관련 컬럼 (4개)
| 컬럼 | 현재 타입 | 목표 타입 | 사용 위치 |
|------|-----------|-----------|----------|
| `entry_date` | timestamp | timestamptz | journals 테이블 |
| `issue_date` | timestamp/date | timestamptz | debts 테이블 |
| `due_date` | timestamp/date | timestamptz | debts 테이블 |
| `acquisition_date` | timestamp/date | timestamptz | fixed_assets 테이블 |

---

## 🎯 작업 범위

### 데이터베이스 팀 (4개 작업)

#### 1. 테이블 스키마 변경
```sql
-- journals 테이블
ALTER TABLE journals ADD COLUMN entry_date_utc timestamptz;

-- debts 테이블
ALTER TABLE debts
ADD COLUMN issue_date_utc timestamptz,
ADD COLUMN due_date_utc timestamptz;

-- fixed_assets 테이블
ALTER TABLE fixed_assets ADD COLUMN acquisition_date_utc timestamptz;
```

#### 2. 기존 데이터 마이그레이션
```sql
UPDATE journals SET entry_date_utc = entry_date AT TIME ZONE 'UTC';
UPDATE debts SET
  issue_date_utc = issue_date AT TIME ZONE 'UTC',
  due_date_utc = due_date AT TIME ZONE 'UTC';
UPDATE fixed_assets SET acquisition_date_utc = acquisition_date AT TIME ZONE 'UTC';
```

#### 3. 신규 RPC 함수 생성
```sql
CREATE OR REPLACE FUNCTION insert_journal_with_everything_utc(
  p_entry_date_utc timestamptz,  -- 변경점
  -- ... 기타 파라미터
)
```

#### 4. 인덱스 생성
```sql
CREATE INDEX idx_journals_entry_date_utc ON journals(entry_date_utc);
CREATE INDEX idx_debts_issue_date_utc ON debts(issue_date_utc);
CREATE INDEX idx_debts_due_date_utc ON debts(due_date_utc);
CREATE INDEX idx_fixed_assets_acquisition_date_utc ON fixed_assets(acquisition_date_utc);
```

### Flutter 개발팀 (2개 파일 수정)

#### 1. `transaction_line_model.dart`
**변경 내용**: 날짜 형식 변경
```dart
// ❌ 기존
'issue_date': DateTimeUtils.toDateOnly(issueDate)

// ✅ 신규
'issue_date': DateTimeUtils.toUtc(issueDate)
```

**영향 범위**:
- Line 157-162: debt 정보 (issue_date, due_date)
- Line 175-177: fixed asset 정보 (acquire_date)

#### 2. `journal_entry_datasource.dart`
**변경 내용**: RPC 함수 및 파라미터 변경
```dart
// ❌ 기존
await _supabase.rpc('insert_journal_with_everything', params: {
  'p_entry_date': DateTimeUtils.toRpcFormat(entryDate),
});

// ✅ 신규
await _supabase.rpc('insert_journal_with_everything_utc', params: {
  'p_entry_date_utc': DateTimeUtils.toUtc(entryDate),
});
```

**영향 범위**:
- Line 181: 날짜 형식 변환
- Line 195: RPC 함수명
- Line 202: 파라미터명

---

## 📊 상세 변경 내역

### 날짜 형식 비교

| 항목 | 기존 형식 | 새 형식 | 예시 |
|------|----------|---------|------|
| entry_date | `yyyy-MM-dd HH:mm:ss` (timestamp) | ISO8601 (timestamptz) | `2025-01-15T05:30:00.000Z` |
| issue_date | `yyyy-MM-dd` (date only) | ISO8601 (timestamptz) | `2025-01-15T00:00:00.000Z` |
| due_date | `yyyy-MM-dd` (date only) | ISO8601 (timestamptz) | `2025-02-15T23:59:59.999Z` |
| acquire_date | `yyyy-MM-dd` (date only) | ISO8601 (timestamptz) | `2025-01-15T09:00:00.000Z` |

### 함수 호출 비교

#### 기존
```dart
// DateTimeUtils 사용
DateTimeUtils.toRpcFormat(DateTime.now())  // "2025-01-15 05:30:00"
DateTimeUtils.toDateOnly(DateTime.now())   // "2025-01-15"
```

#### 신규
```dart
// DateTimeUtils 사용
DateTimeUtils.toUtc(DateTime.now())        // "2025-01-15T05:30:00.000Z"
DateTimeUtils.nowUtc()                     // "2025-01-15T05:30:00.000Z"
```

---

## 🚀 마이그레이션 실행 계획

### Phase 1: 준비 단계 (DB 팀)
**예상 소요**: 2-3일

1. ✅ 테이블 스키마 변경 (개발 환경)
2. ✅ 기존 데이터 마이그레이션 (개발 환경)
3. ✅ 인덱스 생성
4. ✅ RPC 함수 생성
5. ✅ 단위 테스트 (SQL)
6. ✅ 스테이징 환경 배포

### Phase 2: 앱 개발 (Flutter 팀)
**예상 소요**: 1-2일

1. ✅ `transaction_line_model.dart` 수정
2. ✅ `journal_entry_datasource.dart` 수정
3. ✅ 단위 테스트 작성
4. ✅ 통합 테스트 작성
5. ✅ 코드 리뷰

### Phase 3: 통합 테스트 (QA 팀)
**예상 소요**: 2-3일

1. ✅ 스테이징 환경 테스트
   - 기본 분개 입력
   - 채무/채권 분개
   - 고정자산 취득 분개
2. ✅ 다중 시간대 테스트
   - 한국 (UTC+9)
   - 베트남 (UTC+7)
   - 미국 동부 (UTC-5)
3. ✅ 데이터 검증
   - `_utc` 컬럼 값 확인
   - 시간대 변환 정확성 확인

### Phase 4: 프로덕션 배포
**예상 소요**: 1일

1. ✅ DB 스키마 변경 (프로덕션)
2. ✅ 기존 데이터 마이그레이션 (프로덕션)
3. ✅ RPC 함수 배포 (프로덕션)
4. ✅ Flutter 앱 배포
5. ✅ 모니터링 (24시간)

### Phase 5: 검증 및 모니터링
**예상 소요**: 1주일

1. ✅ 에러 레이트 모니터링
2. ✅ 데이터 품질 검증
3. ✅ 사용자 피드백 수집

---

## 🔒 호환성 및 안전성

### 병렬 운영
- ✅ 구 버전 앱과 신 버전 앱 **동시 운영 가능**
- ✅ 구 버전: `insert_journal_with_everything` 사용
- ✅ 신 버전: `insert_journal_with_everything_utc` 사용
- ✅ 두 버전 모두 정상 동작 보장

### 롤백 계획
**문제 발생 시**:
1. Flutter 앱 코드만 롤백 (구 RPC 함수 사용)
2. 데이터베이스는 롤백 불필요 (기존 컬럼 유지)
3. 원인 분석 후 재시도

### 데이터 일관성
- ✅ 기존 컬럼 유지 (삭제하지 않음)
- ✅ 새 컬럼 추가 (`_utc` 접미사)
- ✅ 기존 앱 영향 없음

---

## 📁 산출물

### 1. 기술 문서 (4개)
- ✅ `journal_input_UTC_MIGRATION_PLAN.md` (종합 계획서)
- ✅ `journal_input_RPC_SPECIFICATION.md` (DB 팀용)
- ✅ `journal_input_FLUTTER_IMPLEMENTATION_GUIDE.md` (Flutter 팀용)
- ✅ `journal_input_EXECUTIVE_SUMMARY.md` (요약 보고서)

### 2. 코드 변경 (2개 파일)
- ⏳ `data/models/transaction_line_model.dart` (수정 예정)
- ⏳ `data/datasources/journal_entry_datasource.dart` (수정 예정)

### 3. 테스트 코드 (2개 파일)
- ⏳ `transaction_line_model_test.dart` (신규 작성 예정)
- ⏳ `journal_entry_datasource_integration_test.dart` (신규 작성 예정)

---

## ⚠️ 위험 요소 및 대응

### 위험 1: RPC 함수 생성 지연
**영향**: Flutter 개발 블로킹
**대응**: DB 팀과 일정 사전 조율, 스테이징 환경 먼저 준비

### 위험 2: 시간대 변환 오류
**영향**: 데이터 무결성 문제
**대응**:
- 충분한 단위 테스트 작성
- 다중 시간대 테스트 수행
- 스테이징 환경에서 충분히 검증

### 위험 3: 성능 저하
**영향**: RPC 함수 응답 시간 증가
**대응**:
- 인덱스 생성
- 성능 테스트 수행
- 모니터링 알람 설정

### 위험 4: 데이터 마이그레이션 실패
**영향**: 기존 데이터 `_utc` 컬럼 NULL
**대응**:
- 마이그레이션 스크립트 사전 검증
- 백업 확보
- 단계별 실행 (개발 → 스테이징 → 프로덕션)

---

## ✅ 성공 기준

### 기술적 성공
- [ ] 모든 테스트 통과 (단위, 통합, 수동)
- [ ] `_utc` 컬럼 100% 채워짐 (NULL 없음)
- [ ] 에러 레이트 < 0.1%
- [ ] RPC 함수 응답 시간 < 500ms

### 비즈니스 성공
- [ ] 기존 앱 무중단 운영
- [ ] 사용자 불편 사항 없음
- [ ] 글로벌 서비스 준비 완료

---

## 📞 담당자 및 연락처

### 데이터베이스 팀
- **담당**: RPC 함수 생성, 테이블 스키마 변경
- **문서**: `journal_input_RPC_SPECIFICATION.md`

### Flutter 개발팀
- **담당**: 앱 코드 수정, 테스트 작성
- **문서**: `journal_input_FLUTTER_IMPLEMENTATION_GUIDE.md`

### QA 팀
- **담당**: 통합 테스트, 수동 테스트
- **문서**: 모든 문서 참조

### DevOps 팀
- **담당**: 배포, 모니터링
- **문서**: `journal_input_UTC_MIGRATION_PLAN.md`

---

## 📅 예상 일정

| 단계 | 담당 팀 | 예상 소요 | 상태 |
|------|---------|----------|------|
| DB 스키마 변경 | DB 팀 | 2-3일 | ⏳ 대기 |
| RPC 함수 생성 | DB 팀 | 1일 | ⏳ 대기 |
| Flutter 코드 수정 | 앱 개발팀 | 1-2일 | ⏳ 대기 |
| 단위 테스트 | 앱 개발팀 | 1일 | ⏳ 대기 |
| 통합 테스트 | QA 팀 | 2-3일 | ⏳ 대기 |
| 스테이징 배포 | DevOps | 1일 | ⏳ 대기 |
| 프로덕션 배포 | DevOps | 1일 | ⏳ 대기 |
| 모니터링 | 전체 | 1주일 | ⏳ 대기 |

**총 예상 기간**: 2-3주

---

## 💡 권장 사항

### 우선순위 높음
1. ✅ DB 팀과 일정 조율 (블로킹 요소)
2. ✅ 테스트 커버리지 확보 (데이터 무결성)
3. ✅ 모니터링 알람 설정 (조기 감지)

### 우선순위 중간
1. ✅ 코드 리뷰 프로세스 확립
2. ✅ 문서화 유지보수
3. ✅ 사용자 가이드 업데이트

### 우선순위 낮음
1. ⏳ 구 컬럼 deprecate (6개월 후)
2. ⏳ 구 RPC 함수 제거 (1년 후)
3. ⏳ 성능 최적화 (필요 시)

---

## 📚 참고 자료

### 내부 문서
- `lib/core/utils/datetime_utils.dart` - 날짜 유틸리티
- `lib/features/journal_input/MIGRATION_NOTES.md` - 기존 마이그레이션 노트

### 외부 문서
- [Supabase - Working with Dates and Times](https://supabase.com/docs/guides/database/postgres/dates)
- [PostgreSQL - Timestamp Types](https://www.postgresql.org/docs/current/datatype-datetime.html)
- [ISO 8601 - Date and Time Format](https://en.wikipedia.org/wiki/ISO_8601)

---

## 🎉 결론

### 요약
- ✅ **최소 영향**: 기존 시스템 무중단 운영
- ✅ **안전한 전환**: 점진적 마이그레이션
- ✅ **명확한 계획**: 상세한 문서화 완료
- ✅ **준비 완료**: 즉시 실행 가능

### 다음 단계
1. 관련 팀 미팅 소집
2. 일정 확정
3. 작업 시작

---

**문서 작성일**: 2025-11-25
**작성자**: Claude AI
**버전**: 1.0
**상태**: 검토 대기
