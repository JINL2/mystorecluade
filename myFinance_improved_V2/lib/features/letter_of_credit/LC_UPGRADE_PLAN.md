# LC (Letter of Credit) 모듈 업그레이드 계획서

## 현재 상태 분석

### 기존 구현
- ✅ 기본 CRUD 기능 (리스트, 상세, 생성, 수정)
- ✅ LCStatus enum (draft, applied, issued, advised, confirmed, amended, documentsSubmitted, utilized, expired, closed, cancelled)
- ✅ Provider 무한 루프 수정 (LCListParams에 ==, hashCode 구현)
- ✅ 기본 UI (lc_list_page, lc_form_page, lc_detail_page)

### 문제점
1. LC Form이 PO/PI와 제대로 연동되지 않음
2. LC Type 선택 드롭다운이 하드코딩되어 있음 (DB의 trade_lc_types 미사용)
3. Payment Terms가 LC 전용 조건만 필터링하지 않음
4. Bank 선택 기능 없음 (issuing_bank, advising_bank, confirming_bank)
5. Required Documents 관리 기능 없음
6. Beneficiary 정보 입력 기능 미흡

---

## 업그레이드 계획

### Phase 1: 데이터 레이어 개선

#### 1.1 LC Types Provider 추가
```dart
// lib/features/letter_of_credit/presentation/providers/lc_master_data_providers.dart

// trade_lc_types 테이블에서 LC 유형 가져오기
final lcTypesProvider = FutureProvider<List<LCType>>((ref) async {
  // irrevocable, confirmed, transferable, revolving, standby 등
});

// LC 전용 Payment Terms (requires_lc = true)
final lcPaymentTermsProvider = FutureProvider<List<PaymentTerm>>((ref) async {
  // lc_at_sight, lc_usance_30, lc_usance_60 등
});
```

#### 1.2 Bank 선택을 위한 Counterparty 필터
```dart
// counterparty type = 'Bank' 인 것만 필터링
final bankCounterpartiesProvider = FutureProvider<List<Counterparty>>((ref) async {
  // issuing_bank, advising_bank, confirming_bank 선택용
});
```

#### 1.3 Entity 업데이트
```dart
// lib/features/letter_of_credit/domain/entities/lc_type.dart
@freezed
class LCType with _$LCType {
  const factory LCType({
    required String lcTypeId,
    required String code,
    required String name,
    String? description,
    @Default(false) bool isRevocable,
    @Default(false) bool isConfirmed,
    @Default(false) bool isTransferable,
    @Default(false) bool isRevolving,
    @Default(false) bool isStandby,
  }) = _LCType;
}
```

---

### Phase 2: LC Form 페이지 리팩토링

#### 2.1 새로운 폼 구조 (섹션별 분리)

```
lc_form_page.dart (메인)
├── widgets/
│   ├── lc_form_basic_section.dart      // LC번호, 유형, PO/PI 연결
│   ├── lc_form_parties_section.dart    // Applicant, Beneficiary
│   ├── lc_form_banks_section.dart      // Issuing, Advising, Confirming Bank
│   ├── lc_form_amount_section.dart     // Currency, Amount, Tolerance
│   ├── lc_form_dates_section.dart      // Issue, Expiry, Shipment dates
│   ├── lc_form_payment_section.dart    // Payment Terms, Usance
│   ├── lc_form_shipping_section.dart   // Incoterms, Ports, Method
│   └── lc_form_documents_section.dart  // Required Documents
```

#### 2.2 PO/PI 연동 개선
```dart
// PO 선택 시 자동으로 채워지는 필드:
- applicant_id, applicant_info (from PO.buyer_id, buyer_info)
- currency_id (from PO.currency_id)
- amount (from PO.total_amount)
- incoterms_code, incoterms_place (from PO)
- payment_terms_code (from PO)
- latest_shipment_date (from PO.required_shipment_date_utc)
- partial_shipment_allowed (from PO)
- transshipment_allowed (from PO)
```

#### 2.3 LC Type Dropdown 개선
```dart
// DB에서 가져온 LC Types 사용
// 선택 시 관련 설명 표시
TossDropdown<String>(
  label: 'LC Type',
  items: lcTypes.map((t) => TossDropdownItem(
    value: t.code,
    label: t.name,
    subtitle: t.description,
  )).toList(),
);
```

---

### Phase 3: Bank 선택 기능 구현

#### 3.1 Bank Selector Widget
```dart
// lib/features/letter_of_credit/presentation/widgets/bank_selector.dart

class BankSelector extends ConsumerWidget {
  final String? selectedBankId;
  final ValueChanged<String?> onBankSelected;
  final String label; // "Issuing Bank", "Advising Bank", "Confirming Bank"

  // counterparties에서 type = 'Bank' 인 것만 표시
  // 선택 시 bank_info JSONB 자동 생성 (name, swift, address)
}
```

#### 3.2 Bank Info JSONB 구조
```json
{
  "name": "Citibank New York",
  "swift": "CITIUS33",
  "address": "388 Greenwich St, New York, NY"
}
```

---

### Phase 4: Required Documents 관리

#### 4.1 Document Types (하드코딩 - DB 테이블 없음)
```dart
const lcDocumentTypes = [
  LCDocumentType(code: 'commercial_invoice', name: 'Commercial Invoice'),
  LCDocumentType(code: 'packing_list', name: 'Packing List'),
  LCDocumentType(code: 'bill_of_lading', name: 'Bill of Lading'),
  LCDocumentType(code: 'certificate_of_origin', name: 'Certificate of Origin'),
  LCDocumentType(code: 'insurance_certificate', name: 'Insurance Certificate'),
  LCDocumentType(code: 'inspection_certificate', name: 'Inspection Certificate'),
  LCDocumentType(code: 'weight_certificate', name: 'Weight Certificate'),
  LCDocumentType(code: 'quality_certificate', name: 'Quality Certificate'),
  LCDocumentType(code: 'beneficiary_certificate', name: 'Beneficiary Certificate'),
];
```

#### 4.2 Required Documents Widget
```dart
// lib/features/letter_of_credit/presentation/widgets/required_documents_editor.dart

class RequiredDocumentsEditor extends StatefulWidget {
  final List<LCRequiredDocument> documents;
  final ValueChanged<List<LCRequiredDocument>> onChanged;

  // 체크박스로 필요 서류 선택
  // 각 서류별 원본/사본 매수 입력
  // 추가 메모 입력
}
```

---

### Phase 5: Detail Page 개선

#### 5.1 상세 페이지 섹션
```
lc_detail_page.dart
├── Header (LC Number, Status Badge, Actions)
├── Amount Card (Currency, Amount, Utilized, Available)
├── Dates Timeline (Issue → Shipment → Expiry)
├── Parties Section (Applicant, Beneficiary)
├── Banks Section (Issuing, Advising, Confirming)
├── Trade Terms (Incoterms, Ports, Shipping)
├── Payment Terms (At Sight / Usance)
├── Required Documents Checklist
├── Amendments History
└── Related Documents (PO, PI links)
```

#### 5.2 Status 변경 액션
```dart
// Status Flow:
// draft → applied → issued → advised → confirmed → utilized/closed
//                                    ↓
//                               amended (amendment 추가 시)
//                                    ↓
//                          documents_submitted
//                                    ↓
//                               utilized/closed

// 각 상태에서 가능한 액션 버튼 표시
```

---

### Phase 6: 워크플로우 연동

#### 6.1 PO에서 LC 생성
```dart
// PO Detail Page에서 "Create LC" 버튼
// → LC Form으로 이동하며 PO 데이터 자동 로드
context.push('/letter-of-credit/new?poId=${po.poId}');
```

#### 6.2 LC에서 Shipment 연동 (향후)
```dart
// LC가 confirmed 상태일 때 Shipment 생성 가능
// Shipment 완료 시 LC amount_utilized 업데이트
```

---

## 파일 구조 (예정)

```
lib/features/letter_of_credit/
├── domain/
│   ├── entities/
│   │   ├── letter_of_credit.dart       ✅ 기존
│   │   ├── letter_of_credit.freezed.dart
│   │   ├── lc_type.dart                🆕 추가
│   │   ├── lc_type.freezed.dart
│   │   └── lc_document_type.dart       🆕 추가
│   └── repositories/
│       └── lc_repository.dart          ✅ 기존 (업데이트)
├── data/
│   ├── datasources/
│   │   └── lc_remote_datasource.dart   ✅ 기존 (업데이트)
│   └── repositories/
│       └── lc_repository_impl.dart     ✅ 기존
├── presentation/
│   ├── providers/
│   │   ├── lc_providers.dart           ✅ 기존
│   │   └── lc_master_data_providers.dart 🆕 추가
│   ├── pages/
│   │   ├── lc_list_page.dart           ✅ 기존 (디버그 제거)
│   │   ├── lc_form_page.dart           📝 리팩토링
│   │   └── lc_detail_page.dart         📝 리팩토링
│   └── widgets/
│       ├── lc_form/                    🆕 추가
│       │   ├── lc_form_basic_section.dart
│       │   ├── lc_form_parties_section.dart
│       │   ├── lc_form_banks_section.dart
│       │   ├── lc_form_amount_section.dart
│       │   ├── lc_form_dates_section.dart
│       │   ├── lc_form_payment_section.dart
│       │   ├── lc_form_shipping_section.dart
│       │   └── lc_form_documents_section.dart
│       ├── bank_selector.dart          🆕 추가
│       ├── required_documents_editor.dart 🆕 추가
│       └── lc_status_badge.dart        🆕 추가 (공통화)
└── LC_UPGRADE_PLAN.md                  📋 이 문서
```

---

## 우선순위

| 순서 | 작업 | 중요도 | 예상 난이도 |
|------|------|--------|-------------|
| 1 | 디버그 print 제거 | High | Low |
| 2 | LC Types Provider 추가 | High | Medium |
| 3 | LC Form - PO 연동 개선 | High | Medium |
| 4 | Bank Selector 구현 | Medium | Medium |
| 5 | LC Form 섹션 분리 | Medium | High |
| 6 | Required Documents Editor | Medium | Medium |
| 7 | Detail Page 개선 | Low | Medium |
| 8 | Amendment 기능 완성 | Low | High |

---

## 시작하기

다음 명령으로 Phase 1부터 시작:
```
"Phase 1 시작해줘" 또는 "LC Types Provider 추가해줘"
```
