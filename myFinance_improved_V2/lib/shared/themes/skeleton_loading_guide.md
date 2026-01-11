# Skeletonizer 자동 스켈레톤 로딩 가이드 (2026)

> Flutter Skeletonizer 패키지를 사용한 스케일러블 스켈레톤 로딩 시스템 구축 가이드

## 목차
1. [개요](#개요)
2. [아키텍처](#아키텍처)
3. [Mock 데이터 패턴](#mock-데이터-패턴)
4. [파일 구조](#파일-구조)
5. [구현 가이드](#구현-가이드)
6. [Annotation 활용](#annotation-활용)
7. [테마 설정](#테마-설정)
8. [Feature별 마이그레이션 현황](#feature별-마이그레이션-현황)
9. [마이그레이션 체크리스트](#마이그레이션-체크리스트)

---

## 개요

### Skeletonizer란?
[Skeletonizer](https://pub.dev/packages/skeletonizer)는 기존 위젯을 **자동으로** 스켈레톤 로더로 변환하는 패키지입니다.

### 수동 vs 자동 방식

| 구분 | 수동 템플릿 방식 | 자동 스켈레톤화 방식 (권장) |
|-----|---------------|------------------------|
| 원리 | 별도의 스켈레톤 UI를 수동으로 제작 | 실제 UI + Mock 데이터로 자동 생성 |
| 유지보수 | UI 변경 시 스켈레톤도 별도 수정 필요 | UI 변경 시 자동으로 반영 |
| 파일 | `TossListSkeleton`, `TossDetailSkeleton` 등 | Entity의 `.mock()` factory만 필요 |
| 일치도 | 실제 UI와 불일치 가능 | 100% 일치 보장 |

---

## 아키텍처

### Clean Architecture와 Mock 데이터

```
lib/
├── features/
│   └── {feature_name}/
│       ├── domain/
│       │   └── entities/
│       │       └── {entity}.dart          # ✅ mock() factory 추가
│       │       └── {entity}.freezed.dart
│       ├── data/
│       │   └── models/
│       │       └── {entity}_model.dart
│       └── presentation/
│           └── pages/
│               └── {page}.dart            # ✅ Skeletonizer 적용
```

### 핵심 원칙

1. **Mock 데이터는 Domain Layer (Entity)에 위치**
   - Entity는 순수 Dart 클래스 → Flutter 의존성 없음
   - 테스트와 스켈레톤 로딩에서 재사용 가능

2. **Presentation Layer에서 Skeletonizer 적용**
   - AsyncValue.when() 또는 조건부 렌더링에서 사용
   - 실제 UI 위젯을 그대로 사용

---

## Mock 데이터 패턴

### 패턴 1: Entity에 static mock() 추가 (Freezed)

```dart
// domain/entities/shift_card.dart
@freezed
class ShiftCard with _$ShiftCard {
  const ShiftCard._();

  const factory ShiftCard({
    required String id,
    required String shiftName,
    required String startTime,
    required String endTime,
    // ... 기타 필드
  }) = _ShiftCard;

  // ============================================
  // Mock Factory (for skeleton loading & testing)
  // ============================================

  /// 스켈레톤 로딩용 Mock 데이터
  static ShiftCard mock() => const ShiftCard(
    id: 'mock-id',
    shiftName: 'Morning Shift',
    startTime: '09:00',
    endTime: '17:00',
  );

  /// Mock 리스트 생성
  static List<ShiftCard> mockList([int count = 3]) =>
      List.generate(count, (_) => mock());
}
```

### 패턴 2: BoneMock 유틸리티 활용

```dart
import 'package:skeletonizer/skeletonizer.dart';

static User mock() => User(
  name: BoneMock.name,           // "John Doe" 형태
  email: BoneMock.email,         // "email@example.com" 형태
  bio: BoneMock.words(10),       // 10단어 텍스트
  joinDate: BoneMock.date,       // "Jan 1, 2025" 형태
);
```

### 패턴 3: 중첩 Entity Mock

```dart
@freezed
class Order with _$Order {
  // ...

  static Order mock() => Order(
    id: 'mock-id',
    customer: Customer.mock(),      // 중첩 Entity도 mock() 호출
    items: OrderItem.mockList(3),   // 리스트도 mockList() 호출
    totalAmount: 100000,
  );
}
```

---

## 파일 구조

### Mock 데이터 위치

```
lib/features/{feature}/domain/entities/
├── shift_card.dart              # Entity + mock() factory
├── shift_card.freezed.dart      # Freezed 생성 파일
├── user_shift_stats.dart        # Entity + mock() factory
└── user_shift_stats.freezed.dart
```

### 테마 설정 위치

```
lib/shared/themes/
├── toss_skeleton_theme.dart     # Skeletonizer 테마 설정
├── app_theme.dart               # ThemeData extensions에 포함
└── skeleton_loading_guide.md    # 이 가이드 문서
```

### 기존 수동 템플릿 (제거 대상)

```
lib/shared/widgets/organisms/skeleton/
├── toss_list_skeleton.dart      # ❌ 제거 또는 deprecated
├── toss_detail_skeleton.dart    # ❌ 제거 또는 deprecated
├── toss_schedule_skeleton.dart  # ❌ 제거 또는 deprecated
└── toss_grid_skeleton.dart      # ❌ 제거 또는 deprecated
```

---

## 구현 가이드

### Step 1: Entity에 mock() 추가

```dart
// 기존 Entity 파일에 추가
@freezed
class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    required String name,
    required double price,
    String? imageUrl,
  }) = _Product;

  // Mock factory 추가
  static Product mock() => const Product(
    id: 'mock',
    name: 'Product Name',
    price: 10000,
    imageUrl: null,  // 이미지는 null로 처리
  );

  static List<Product> mockList([int count = 5]) =>
      List.generate(count, (_) => mock());
}
```

### Step 2: Page에서 Skeletonizer 적용

```dart
// 방법 1: AsyncValue.when() 패턴
Widget build(BuildContext context) {
  final asyncProducts = ref.watch(productsProvider);

  return asyncProducts.when(
    data: (products) => ProductList(products: products),
    loading: () => Skeletonizer(
      enabled: true,
      child: ProductList(products: Product.mockList(8)),
    ),
    error: (e, _) => ErrorView(error: e),
  );
}
```

```dart
// 방법 2: enabled 플래그 패턴 (위젯 트리 재사용)
Widget build(BuildContext context) {
  final asyncProducts = ref.watch(productsProvider);
  final isLoading = asyncProducts.isLoading;
  final products = asyncProducts.valueOrNull ?? Product.mockList(8);

  return Skeletonizer(
    enabled: isLoading,
    child: ProductList(products: products),
  );
}
```

### Step 3: 이미지 처리 (Skeleton.replace)

```dart
// 네트워크 이미지는 Skeleton.replace로 대체
Widget build(BuildContext context) {
  return Row(
    children: [
      Skeleton.replace(
        replacement: const Bone.square(size: 56),  // 대체 Bone
        child: imageUrl != null
            ? Image.network(imageUrl!, width: 56, height: 56)
            : const Icon(Icons.image, size: 56),
      ),
      // ...
    ],
  );
}
```

---

## Annotation 활용

### 주요 Annotation

| Annotation | 용도 | 예시 |
|-----------|-----|-----|
| `Skeleton.ignore` | 스켈레톤화 제외 | AppBar, 고정 헤더 |
| `Skeleton.keep` | 원본 그대로 유지 | 아이콘, 로고 |
| `Skeleton.shade` | 스켈레톤화 없이 음영만 | 배경 컨테이너 |
| `Skeleton.replace` | 다른 위젯으로 대체 | 네트워크 이미지 |
| `Skeleton.unite` | 인접 요소 병합 | 작은 텍스트 그룹 |
| `Skeleton.leaf` | 리프 노드로 표시 | 커스텀 페인터 |

### 사용 예시

```dart
Widget build(BuildContext context) {
  return Column(
    children: [
      // AppBar는 스켈레톤화하지 않음
      Skeleton.keep(child: const TossAppBar(title: 'Products')),

      // 컨텐츠는 스켈레톤화
      Expanded(
        child: ProductList(products: products),
      ),

      // 하단 버튼은 음영만
      Skeleton.shade(
        child: BottomButton(onPressed: () {}),
      ),
    ],
  );
}
```

---

## 테마 설정

### toss_skeleton_theme.dart

```dart
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'toss_colors.dart';
import 'toss_animations.dart';
import 'toss_border_radius.dart';

/// Toss 디자인 시스템 Skeletonizer 테마
class TossSkeletonTheme {
  TossSkeletonTheme._();

  static const Color baseColor = TossColors.gray100;
  static const Color highlightColor = TossColors.gray200;

  static SkeletonizerConfigData get light => SkeletonizerConfigData(
    effect: ShimmerEffect(
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: TossAnimations.loadingPulse,  // 1200ms
    ),
    textBoneBorderRadius: TextBoneBorderRadius(
      BorderRadius.circular(TossBorderRadius.xs),
    ),
    justifyMultiLineText: true,
    containersColor: baseColor,
    enableSwitchAnimation: true,
    switchAnimationConfig: const SwitchAnimationConfig(
      duration: Duration(milliseconds: 300),
    ),
  );

  static SkeletonizerConfigData get dark => SkeletonizerConfigData.dark(
    effect: ShimmerEffect(
      baseColor: TossColors.gray800,
      highlightColor: TossColors.gray700,
      duration: TossAnimations.loadingPulse,
    ),
  );
}
```

### app_theme.dart에 통합

```dart
ThemeData get lightTheme => ThemeData(
  // ... 기존 테마 설정
  extensions: [
    TossSkeletonTheme.light,  // Skeletonizer 테마 추가
  ],
);
```

---

## 마이그레이션 체크리스트

### Feature별 마이그레이션

각 Feature를 자동 스켈레톤화로 전환할 때 다음을 확인:

- [ ] **Entity에 mock() factory 추가**
  - [ ] 기본 Entity
  - [ ] 중첩 Entity (있는 경우)
  - [ ] mockList() 헬퍼 (리스트 필요 시)

- [ ] **Page에서 Skeletonizer 적용**
  - [ ] AsyncValue.when() loading: 부분 수정
  - [ ] 또는 enabled 플래그 패턴 적용

- [ ] **이미지 처리**
  - [ ] 네트워크 이미지에 Skeleton.replace 적용
  - [ ] 또는 mock에서 imageUrl을 null로 설정

- [ ] **수동 템플릿 제거**
  - [ ] TossListSkeleton → 제거
  - [ ] TossDetailSkeleton → 제거
  - [ ] Feature별 커스텀 스켈레톤 → 제거

### 테스트

```dart
// Entity mock 테스트
test('ShiftCard.mock() creates valid instance', () {
  final mock = ShiftCard.mock();
  expect(mock.id, isNotEmpty);
  expect(mock.shiftName, isNotEmpty);
});

// Widget 스켈레톤 테스트
testWidgets('shows skeleton when loading', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Skeletonizer(
        enabled: true,
        child: ProductList(products: Product.mockList()),
      ),
    ),
  );

  expect(find.byType(Skeletonizer), findsOneWidget);
});
```

---

## Feature별 마이그레이션 현황

### 1. attendance (16 Entities) ✅ 완료

| Entity | mock() | mockList() | 비고 |
|--------|--------|------------|------|
| ShiftCard | ✅ | ✅ | Freezed |
| UserShiftStats | ✅ | - | Freezed, 중첩 클래스 포함 |
| SalaryInfo | ✅ | - | UserShiftStats 중첩 |
| PeriodStats | ✅ | - | UserShiftStats 중첩 |
| WeeklyPayments | ✅ | - | UserShiftStats 중첩 |
| ReliabilityScore | ✅ | - | UserShiftStats 중첩 |
| MonthlyShiftStatus | ✅ | ✅ | Freezed |
| DailyShift | ✅ | ✅ | MonthlyShiftStatus 중첩 |
| EmployeeStatus | ✅ | ✅ | MonthlyShiftStatus 중첩 |
| ProblemDetails | ✅ | - | Freezed |
| ManagerMemo | ✅ | ✅ | Freezed |

### 2. time_table_manage (26 Entities) ✅ 핵심 완료

| Entity | mock() | mockList() | 비고 |
|--------|--------|------------|------|
| Shift | ✅ | ✅ | copyWith 있음 |
| ShiftMetadata | ✅ | - | 중첩 포함 |
| ShiftMetadataItem | ✅ | ✅ | ShiftMetadata 중첩 |
| ManagerOverview | ✅ | - | 통계 getter 많음 |
| ShiftCard | ✅ | ✅ | 복잡한 중첩 구조 |
| EmployeeInfo | ✅ | ✅ | ShiftCard 중첩 |
| Tag | ✅ | ✅ | ShiftCard 중첩 |
| ManagerMemo | ✅ | ✅ | ShiftCard 중첩 |
| ProblemDetails | ✅ | - | ShiftCard 중첩 |

### 3. sale_product (7 Entities) ✅ 완료

| Entity | mock() | mockList() | 비고 |
|--------|--------|------------|------|
| SalesProduct | ✅ (ext) | ✅ | Extension mock 패턴 |
| ProductPricing | ✅ (ext) | - | Extension mock |
| TotalStockSummary | ✅ (ext) | - | Extension mock |
| ProductImages | ✅ (ext) | - | Extension mock |
| ProductStatus | ✅ (ext) | - | Extension mock |
| StoreStock | ✅ (ext) | ✅ | Extension mock |
| Stock | ✅ (ext) | - | Extension mock |
| Valuation | ✅ (ext) | - | Extension mock |
| StockSettings | ✅ | - | static mock |

### 4. inventory_management (4 Entities) ✅ 완료

| Entity | mock() | mockList() | 비고 |
|--------|--------|------------|------|
| Product | ✅ (ext) | ✅ | Extension mock 패턴 |
| InventoryMetadata | ✅ (ext) | - | Extension mock |
| InventoryStats | ✅ (ext) | - | InventoryMetadata 중첩 |
| Brand | ✅ (ext) | ✅ | InventoryMetadata 중첩 |
| Currency | ✅ (ext) | - | InventoryMetadata 중첩 |
| Category | ✅ (ext) | ✅ | InventoryMetadata 중첩 |
| StoreInfo | ✅ (ext) | - | InventoryMetadata 중첩 |
| ProductType | ✅ (ext) | ✅ | InventoryMetadata 중첩 |
| ValidationRules | ✅ (ext) | - | InventoryMetadata 중첩 |
| AllowCustomValues | ✅ (ext) | - | InventoryMetadata 중첩 |
| StockStatusLevel | ✅ | - | static mock |

---

## 참고 자료

- [Skeletonizer Package](https://pub.dev/packages/skeletonizer)
- [Flutter Clean Architecture 2025](https://coding-studio.com/clean-architecture-in-flutter-a-complete-guide-with-code-examples-2025-edition/)
- [Flutter Architecture Patterns](https://yshean.com/flutter-architecture-patterns-clean-architecture-vs-feature-first)
- [Building Scalable Flutter Apps](https://medium.com/@survildhaduk/building-scalable-flutter-apps-with-clean-architecture-9395f0537d5b)

---

## 변경 이력

| 날짜 | 버전 | 내용 |
|-----|-----|-----|
| 2026-01-11 | 1.0 | 초기 가이드 작성 |
| 2026-01-11 | 1.1 | Feature별 마이그레이션 현황 추가, Option 2 (Entity 내 mock) 채택 |
| 2026-01-11 | 1.2 | 4개 Feature 모든 핵심 Entity에 mock factory 추가 완료 |
