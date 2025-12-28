# Salary Info Feature 명세서

## 개요
사용자가 소속된 각 회사별로 급여 유형(hourly/monthly)과 통화 정보를 조회할 수 있는 기능 추가.

**작업일**: 2025-12-28

---

## 데이터 흐름

```
Supabase RPC (get_user_companies_with_salary)
    ↓
HomepageDataSource.getUserCompanies()
    ↓
UserCompaniesModel → CompanyModel (freezed)
    ↓
Company Entity (Domain Layer)
    ↓
AppState (via user_entity_mapper)
```

---

## 추가된 필드

### 회사(Company)별 반환 데이터

| 필드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| `salary_type` | `String?` | 급여 유형 | `"hourly"`, `"monthly"` |
| `currency_code` | `String?` | 통화 코드 | `"USD"`, `"VND"`, `"KRW"` |
| `currency_symbol` | `String?` | 통화 기호 | `"$"`, `"₫"`, `"₩"` |

---

## 수정된 파일

### 1. Supabase Migration
**파일**: `supabase/migrations/20251228_add_salary_to_user_companies.sql`

```sql
CREATE OR REPLACE FUNCTION get_user_companies_with_salary(p_user_id uuid)
RETURNS json
```

- 기존 `get_user_companies_with_subscription`와 동일한 구조
- `user_salaries` + `currency_types` 테이블 조인하여 salary 정보 추가

### 2. Data Layer - Model
**파일**: `lib/features/homepage/data/models/user_companies_model.dart`

```dart
@freezed
class CompanyModel {
  const factory CompanyModel({
    // ... 기존 필드들
    String? salaryType,      // 추가
    String? currencyCode,    // 추가
    String? currencySymbol,  // 추가
  }) = _CompanyModel;
}
```

### 3. Data Layer - DataSource
**파일**: `lib/features/homepage/data/datasources/homepage_data_source.dart`

```dart
// RPC 호출 변경
final response = await _supabaseService.client.rpc(
  'get_user_companies_with_salary',  // 변경됨
  params: {'p_user_id': userId},
);
```

### 4. Domain Layer - Entity
**파일**: `lib/core/domain/entities/company.dart`

```dart
class Company {
  // 추가된 필드
  final String? salaryType;
  final String? currencyCode;
  final String? currencySymbol;

  // 추가된 비즈니스 로직
  bool get hasSalaryInfo => salaryType != null;
  bool get isHourlyPaid => salaryType == 'hourly';
  bool get isMonthlyPaid => salaryType == 'monthly';
  String get currencyDisplay => '$currencySymbol $currencyCode';
}
```

### 5. Domain Layer - Mapper
**파일**: `lib/features/homepage/domain/mappers/user_entity_mapper.dart`

```dart
Map<String, dynamic> convertCompanyToMap(Company company) {
  return {
    // ... 기존 필드들
    'salary_type': company.salaryType,
    'currency_code': company.currencyCode,
    'currency_symbol': company.currencySymbol,
  };
}
```

---

## 사용법

### Flutter 앱에서 접근

```dart
// AppState에서 선택된 회사 정보 접근
final companies = appState.user['companies'] as List;
final company = companies.first;

print(company['salary_type']);     // "hourly" or "monthly"
print(company['currency_code']);   // "USD"
print(company['currency_symbol']); // "$"

// Company Entity 사용 시
final companyEntity = Company.fromMap(company);
print(companyEntity.salaryType);       // "hourly"
print(companyEntity.currencyDisplay);  // "$ USD"
print(companyEntity.isHourlyPaid);     // true
print(companyEntity.isMonthlyPaid);    // false
```

---

## DB 테이블 관계

```
users
  └── user_salaries (user_id, company_id)
        ├── salary_type (text): 'hourly' | 'monthly'
        └── currency_id (uuid) → currency_types
                                    ├── currency_code (text): 'USD', 'VND'
                                    └── symbol (text): '$', '₫'
```

---

## 테스트 결과

```
📊 Company: Cameraon&Headsup
   💰 Salary Type: hourly
   💵 Currency: $ USD
📊 Company: Lux Nha Trang
   💰 Salary Type: monthly
   💵 Currency: ₫ VND
📊 Company: Pure Stich Vietnam
   💰 Salary Type: monthly
   💵 Currency: ₫ VND
```

---

## 주의사항

1. **회사별 급여 정보**: 같은 유저라도 회사마다 다른 급여 타입/통화를 가질 수 있음
2. **Nullable**: 급여 정보가 없는 경우 `null` 반환
3. **기존 호환성**: 기존 `get_user_companies_with_subscription` RPC는 그대로 유지 (별도 함수로 생성)
