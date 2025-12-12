# 🎯 장기 마이그레이션 전략: created_at 컬럼 제거 계획

## 🤔 질문: "created_at 컬럼은 나중에 지울 건데?"

**답변**: 네, 맞습니다! 하지만 **단계적으로** 진행해야 합니다.

---

## 📅 3단계 마이그레이션 로드맵

### 🟢 Phase 1: Dual-Write (현재 → 3-6개월)
**목표**: 기존 앱과 신규 앱 공존

```sql
-- 두 컬럼 모두 유지
created_at          timestamp       -- 🔴 기존 컬럼 (deprecated 예정)
created_at_utc      timestamptz     -- 🟢 신규 컬럼 (미래 표준)
```

**동작**:
- ✅ 두 컬럼 **모두** 작성 (트리거로 자동)
- ✅ 읽기는 **기존 컬럼** 우선 (하위 호환성)
- ✅ 구 앱: `created_at` 사용
- ✅ 신 앱: `created_at` 사용 (아직 전환 안 함)

**Flutter 코드**:
```dart
// ✅ 현재 그대로
class CompanyDto {
  final DateTime? createdAt;        // 🔴 기존 사용 중
  final DateTime? createdAtUtc;     // 🟢 백업용
}
```

**이유**:
- 모든 사용자가 앱을 업데이트하는 데 **시간이 필요**
- 구 버전 앱도 계속 작동해야 함

---

### 🟡 Phase 2: Dual-Read (3-6개월 후 → 6-12개월)
**목표**: 신규 컬럼으로 점진적 전환

```sql
-- 두 컬럼 모두 유지 (아직 삭제 안 함)
created_at          timestamp       -- 🟡 Deprecated (백업용)
created_at_utc      timestamptz     -- 🟢 주요 사용
```

**동작**:
- ✅ 두 컬럼 **모두** 작성 (트리거로 자동)
- ✅ 읽기는 **UTC 컬럼** 우선, 없으면 기존 컬럼 (Fallback)
- ✅ 구 앱: `created_at` 사용 (여전히 작동)
- ✅ 신 앱: `created_at_utc` 사용 (전환 시작)

**Flutter 코드**:
```dart
// Phase 2에서 수정
class CompanyDto {
  final DateTime? createdAt;        // 🟡 Deprecated
  final DateTime? createdAtUtc;     // 🟢 주요 사용

  // Getter로 우선순위 처리
  DateTime? get effectiveCreatedAt => createdAtUtc ?? createdAt;
}

// 사용
final created = company.effectiveCreatedAt;  // UTC 우선
```

**마이그레이션**:
```sql
-- 기존 NULL 데이터 채우기
UPDATE companies
SET created_at_utc = created_at AT TIME ZONE 'UTC'
WHERE created_at_utc IS NULL;
```

**이유**:
- 데이터 검증 및 모니터링 기간
- 문제 발생 시 기존 컬럼으로 롤백 가능

---

### 🔴 Phase 3: UTC-Only (12개월 후 → 완전 전환)
**목표**: 기존 컬럼 제거

```sql
-- 기존 컬럼 삭제
-- created_at 삭제됨 ❌
created_at_utc      timestamptz     -- 🟢 유일한 컬럼

-- 또는 컬럼명 변경
created_at          timestamptz     -- 🟢 UTC로 타입 변경
```

**동작**:
- ✅ UTC 컬럼만 작성
- ✅ UTC 컬럼만 읽기
- ⚠️ 구 앱: 작동 안 함 (강제 업데이트 필요)
- ✅ 신 앱: 완벽하게 작동

**Flutter 코드**:
```dart
// Phase 3에서 최종 수정
class CompanyDto {
  // created_at 필드 삭제 ❌
  final DateTime createdAt;  // 🟢 UTC만 사용 (이름 그대로 또는 변경)
}
```

**Database 마이그레이션 옵션**:

#### 옵션 A: 컬럼 삭제 후 이름 변경
```sql
-- 1. 기존 컬럼 삭제
ALTER TABLE companies DROP COLUMN created_at;

-- 2. UTC 컬럼 이름 변경
ALTER TABLE companies RENAME COLUMN created_at_utc TO created_at;

-- 3. 타입 확인
-- created_at은 이제 timestamptz 타입
```

#### 옵션 B: 기존 컬럼 유지하되 타입 변경
```sql
-- 1. 데이터 복사
UPDATE companies SET created_at_utc = created_at AT TIME ZONE 'UTC';

-- 2. 기존 컬럼 타입 변경
ALTER TABLE companies
  ALTER COLUMN created_at
  TYPE TIMESTAMPTZ
  USING created_at AT TIME ZONE 'UTC';

-- 3. UTC 컬럼 삭제
ALTER TABLE companies DROP COLUMN created_at_utc;

-- created_at은 이제 timestamptz 타입
```

---

## 🎯 권장 전략: 옵션에 따라 다름

### 🏆 추천: **Phase 3 진행 안 함** (영구 Dual-Column)

#### 이유
1. **하위 호환성**: 언제든 기존 컬럼 참조 가능
2. **안전성**: 데이터 백업 역할
3. **디버깅**: 문제 발생 시 비교 가능
4. **비용**: 컬럼 2개 추가 저장 비용 미미

#### 최종 상태
```sql
-- 영구 유지
created_at          timestamp       -- 백업/참고용
created_at_utc      timestamptz     -- 주요 사용
```

```dart
// Flutter 코드
class CompanyDto {
  final DateTime? createdAt;        // 백업
  final DateTime? createdAtUtc;     // 주요 사용

  DateTime? get effectiveCreatedAt => createdAtUtc ?? createdAt;
}
```

#### 장점
- ✅ 롤백 가능
- ✅ 레거시 시스템 호환
- ✅ 데이터 검증 용이
- ✅ 마이그레이션 리스크 제로

#### 단점
- ⚠️ 저장 공간 약간 증가 (각 row당 8 bytes × 2)
- ⚠️ 컬럼 2개 유지 관리

---

## 📊 각 Phase별 타임라인

```
현재 (2025-11-24)
│
├─ Phase 1: Dual-Write 시작
│  ├─ 트리거 설치
│  ├─ 기존 데이터 마이그레이션
│  └─ 모니터링 (1-3개월)
│
├─ Phase 2: Dual-Read 전환 (2025-02 ~ 2025-08)
│  ├─ Flutter 코드 수정 (effectiveCreatedAt)
│  ├─ 앱 배포 및 모니터링
│  └─ 데이터 일관성 검증
│
└─ Phase 3: 선택적 (2025-08 이후)
   ├─ 옵션 A: 컬럼 삭제 (권장 안 함)
   ├─ 옵션 B: 영구 유지 (권장 ✅)
   └─ 비즈니스 요구사항에 따라 결정
```

---

## 🎯 실무 권장사항

### ✅ 해야 할 것

1. **Phase 1 진행** (즉시)
   - 트리거 설치
   - Dual-Write 시작
   - 모니터링

2. **Phase 2 진행** (3-6개월 후)
   - Flutter 코드 수정
   - Dual-Read 전환
   - 장기 모니터링

3. **Phase 3는 보류** (영구)
   - 두 컬럼 모두 유지
   - 안전성 우선

### ❌ 하지 말아야 할 것

1. **급하게 컬럼 삭제**
   - 데이터 손실 위험
   - 롤백 불가능
   - 레거시 호환성 문제

2. **검증 없이 전환**
   - 충분한 모니터링 기간 필요
   - 데이터 일관성 검증 필수

---

## 🔍 Phase 2 상세 구현

### Flutter 코드 수정

#### Before (Phase 1)
```dart
class CompanyDto {
  final DateTime? createdAt;
  final DateTime? createdAtUtc;

  factory CompanyDto.fromJson(Map<String, dynamic> json) => CompanyDto(
    createdAt: json['created_at'] != null
      ? DateTime.parse(json['created_at'])
      : null,
    createdAtUtc: json['created_at_utc'] != null
      ? DateTime.parse(json['created_at_utc'])
      : null,
  );
}

// 사용
final created = company.createdAt;  // 🔴 기존 컬럼 사용
```

#### After (Phase 2)
```dart
class CompanyDto {
  final DateTime? createdAt;        // Deprecated
  final DateTime? createdAtUtc;     // Primary

  // Getter로 우선순위 처리
  DateTime? get effectiveCreatedAt => createdAtUtc ?? createdAt;

  factory CompanyDto.fromJson(Map<String, dynamic> json) => CompanyDto(
    createdAt: json['created_at'] != null
      ? DateTime.parse(json['created_at'])
      : null,
    createdAtUtc: json['created_at_utc'] != null
      ? DateTime.parse(json['created_at_utc'])
      : null,
  );
}

// 사용
final created = company.effectiveCreatedAt;  // 🟢 UTC 우선
```

---

## 🎉 최종 결론

### 🎯 권장 전략: **"Soft Deprecation"**

1. **Phase 1**: 트리거로 Dual-Write ✅
2. **Phase 2**: Dual-Read로 점진적 전환 ✅
3. **Phase 3**: **컬럼 유지** (삭제 안 함) ✅

### 이유
- ✅ 최소 리스크
- ✅ 최대 안전성
- ✅ 롤백 가능
- ✅ 레거시 지원
- ⚠️ 저장 공간 미미한 증가 (허용 가능)

### 컬럼 삭제가 필요한 경우만
- 저장 공간이 정말 중요한 경우
- 레거시 시스템 완전 폐기
- 최소 12개월 후
- 충분한 검증 후

---

**핵심**: `created_at` 컬럼은 **당분간 유지**하고, `created_at_utc`를 주로 사용하는 방식 추천! 🚀

나중에 삭제는 선택사항이며, **영구 유지도 좋은 전략**입니다.
