# Widget Implementation Plan (Revised)
## 30년차 Flutter Architect의 실사용 데이터 기반 전략

**수정일:** 2026-01-01
**기준:** 실제 프로젝트 사용 빈도 분석 (grep 기반)

---

## 📊 핵심 철학

> **"Don't Wrap, Compose"**
> Flutter 위젯을 무조건 감싸지 말고, ThemeData로 해결 가능한 것은 Theme으로,
> 진짜 중복이 심한 것만 공통 위젯으로 만든다.

---

## 📈 실사용 데이터 분석 결과

| 패턴 | 사용 횟수 | ROI | 결정 |
|------|:--------:|:---:|:----:|
| **_buildInfoRow / _buildDetailRow** | 175회 | ⭐⭐⭐ | ✅ DONE (InfoRow) |
| **IconButton** | 179회 | ⭐ | ❌ Theme |
| **CircleAvatar** | 103회 | ⭐⭐ | ⚠️ 확장 |
| **ListTile** | 42회 | ⭐ | ❌ Theme (이미 listTileTheme 적용) |
| **TabBar** | 40회 | ⭐ | ❌ 이미 TossTabBar 존재 |
| **Shimmer/Skeleton** | 12회 | ⭐ | ✅ DONE (TossSkeleton) |
| **Checkbox** | 10회 | ⭐ | ❌ Theme |
| **Switch** | 8회 | ⭐ | ❌ Theme |
| **Radio** | 0회 | - | ❌ 불필요 |
| **Slider** | 0회 | - | ❌ 불필요 |

---

## 🎯 수정된 전략

### ❌ 만들지 않을 것 (ThemeData로 해결)

| 기존 계획 | 이유 | 대안 |
|-----------|------|------|
| `TossIconButton` | 179회 사용 중 70%가 close/back → TossAppBar가 처리 | `iconButtonTheme` |
| `TossSwitch` | 8회 사용, Theme으로 충분 | `switchTheme` |
| `TossCheckbox` | 10회 사용, Theme으로 충분 | `checkboxTheme` |
| `TossRadio` | 0회 사용 | `radioTheme` |
| `TossSlider` | 0회 사용 | `sliderTheme` |
| `TossListTile` | ListTile 자체가 유연함 | `listTileTheme` |
| `TossDivider` | `gray_divider_space.dart` 이미 존재 | 기존 유지 |
| `TossIcon` | Icon + Theme으로 충분 | 불필요 |
| `TossSpacer` | SizedBox + TossSpacing 상수로 충분 | 불필요 |
| `TossSearchBar` | `TossSearchField` 이미 존재 | 기존 유지 |
| `TossRatingBar` | 사용 빈도 낮음 | 불필요 |
| `TossUserCard` | 도메인 특화, 범용 아님 | feature 내 유지 |

### ✅ 반드시 만들 것 (높은 ROI)

| 위젯 | 카테고리 | 사용 횟수 | 삭제 가능 코드 | 상태 |
|------|----------|:--------:|:-------------:|:--------:|
| `InfoRow` | atoms/display/ | 175회 | ~3,000줄 | ✅ DONE |
| `InfoCard` | molecules/display/ | 10+회 | ~300줄 | ✅ DONE |
| `IconInfoRow` | molecules/display/ | 5+회 | ~150줄 | ✅ DONE |
| `TossSkeleton` | atoms/feedback/ | 12회 | ~500줄 | ✅ DONE |

### ⚠️ 검토 후 결정

| 위젯 | 현재 상태 | 결정 |
|------|----------|------|
| `EmployeeProfileAvatar` | 이미 존재, 20 usages (CircleAvatar 103회) | 범용화 검토 중 |

---

## 1️⃣ Phase 1: Theme 업데이트 (즉시 효과)

### app_theme.dart 수정

```dart
// shared/themes/app_theme.dart

ThemeData get lightTheme => ThemeData(
  // ... 기존 설정 유지

  // ═══════════════════════════════════════════════════
  // IconButton - 전역 스타일 통일
  // ═══════════════════════════════════════════════════
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      foregroundColor: TossColors.gray600,
      iconSize: 24,
      padding: const EdgeInsets.all(8),
    ),
  ),

  // ═══════════════════════════════════════════════════
  // Switch - 전역 스타일 통일
  // ═══════════════════════════════════════════════════
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) =>
      states.contains(WidgetState.selected)
        ? TossColors.primary
        : TossColors.gray300,
    ),
    trackColor: WidgetStateProperty.resolveWith((states) =>
      states.contains(WidgetState.selected)
        ? TossColors.primary.withOpacity(0.5)
        : TossColors.gray200,
    ),
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  ),

  // ═══════════════════════════════════════════════════
  // Checkbox - 전역 스타일 통일
  // ═══════════════════════════════════════════════════
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) =>
      states.contains(WidgetState.selected)
        ? TossColors.primary
        : Colors.transparent,
    ),
    checkColor: WidgetStateProperty.all(TossColors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    side: BorderSide(color: TossColors.gray300, width: 1.5),
  ),

  // ═══════════════════════════════════════════════════
  // ListTile - 전역 스타일 통일
  // ═══════════════════════════════════════════════════
  listTileTheme: ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
    titleTextStyle: TossTextStyles.body.copyWith(
      color: TossColors.gray900,
    ),
    subtitleTextStyle: TossTextStyles.caption.copyWith(
      color: TossColors.gray600,
    ),
    iconColor: TossColors.gray600,
  ),
);
```

**효과:** 앱 전체의 IconButton, Switch, Checkbox, ListTile 스타일 즉시 통일

---

## 2️⃣ Phase 2: 핵심 위젯 구현 (TossInfoRow 계열)

### 2.1 TossInfoRow (Atom)

**위치:** `atoms/display/toss_info_row.dart`

```dart
/// 라벨-값 정보 행 표시
///
/// 175개 이상의 _buildInfoRow, _buildDetailRow 중복 구현을 통합
///
/// ## 사용 예시
/// ```dart
/// // 고정 라벨 너비 (가장 흔한 패턴)
/// TossInfoRow.fixed(label: 'Name', value: 'John Doe')
/// TossInfoRow.fixed(label: 'Email', value: 'john@example.com', labelWidth: 100)
///
/// // 양쪽 정렬 (spaceBetween)
/// TossInfoRow.between(label: 'Total', value: '\$1,234.00')
/// ```
class TossInfoRow extends StatelessWidget {
  final String label;
  final String value;

  // 레이아웃
  final double? labelWidth;  // null = spaceBetween, 값 = fixedWidth
  final CrossAxisAlignment crossAxisAlignment;

  // 스타일
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? valueColor;
  final bool showEmptyStyle;  // 빈값일 때 italic + gray 처리

  // 추가 기능
  final Widget? trailing;
  final EdgeInsets padding;

  const TossInfoRow({...});

  /// 고정 라벨 너비 패턴 (80px 기본)
  factory TossInfoRow.fixed({
    required String label,
    required String value,
    double labelWidth = 80,
    Color? valueColor,
    bool showEmptyStyle = false,
    EdgeInsets padding = EdgeInsets.zero,
  });

  /// spaceBetween 정렬 패턴
  factory TossInfoRow.between({
    required String label,
    required String value,
    TextStyle? valueStyle,
    EdgeInsets padding = EdgeInsets.zero,
  });
}
```

### 2.2 TossInfoCard (Molecule)

**위치:** `molecules/display/toss_info_card.dart`

```dart
/// 배경이 있는 정보 카드
///
/// PIInfoRow 패턴 통합 (gray50 배경 + 라운드 코너)
///
/// ## 사용 예시
/// ```dart
/// TossInfoCard(label: 'PI Number', value: 'PI-2024-001')
/// TossInfoCard(
///   label: 'Amount',
///   value: '\$5,000.00',
///   backgroundColor: TossColors.primarySurface,
/// )
/// ```
class TossInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final Widget? trailing;

  const TossInfoCard({...});
}
```

### 2.3 TossIconInfoRow (Molecule)

**위치:** `molecules/display/toss_icon_info_row.dart`

```dart
/// 아이콘이 포함된 정보 행
///
/// history_header_section 패턴 통합
///
/// ## 사용 예시
/// ```dart
/// TossIconInfoRow(
///   icon: Icons.store_outlined,
///   label: 'Store',
///   value: 'Main Branch',
/// )
/// ```
class TossIconInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const TossIconInfoRow({...});
}
```

---

## 3️⃣ Phase 3: 기존 위젯 정리

### 3.1 EmployeeProfileAvatar → TossAvatar 리네이밍

현재 `EmployeeProfileAvatar`가 범용으로 사용 가능하므로:

```dart
// 변경 전
class EmployeeProfileAvatar extends StatelessWidget { ... }

// 변경 후 (기능 동일, 이름만 변경)
class TossAvatar extends StatelessWidget { ... }

// Backward compatibility를 위한 typedef 추가
typedef EmployeeProfileAvatar = TossAvatar;
```

### 3.2 TossSkeleton (선택적)

12회 shimmer 사용 → 필요시 추가

```dart
/// 스켈레톤 로딩 효과
class TossSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isCircle;

  const TossSkeleton({...});

  factory TossSkeleton.text({double width = 100, double height = 16});
  factory TossSkeleton.circle({double size = 40});
  factory TossSkeleton.card({double height = 80});
}
```

---

## 4️⃣ 최종 파일 구조

```
shared/
├── themes/
│   └── app_theme.dart              ← Theme 업데이트 (Phase 1)
│
└── widgets/
    ├── atoms/
    │   └── display/
    │       ├── toss_info_row.dart      ← NEW (Phase 2)
    │       ├── toss_avatar.dart        ← RENAME (Phase 3)
    │       └── employee_profile_avatar.dart  ← typedef 유지
    │
    └── molecules/
        └── display/
            ├── toss_info_card.dart     ← NEW (Phase 2)
            └── toss_icon_info_row.dart ← NEW (Phase 2)
```

---

## 5️⃣ 마이그레이션 체크리스트

### Phase 1: Theme 업데이트
- [x] `app_theme.dart`에 iconButtonTheme 추가
- [x] `app_theme.dart`에 switchTheme 추가
- [x] `app_theme.dart`에 checkboxTheme 추가
- [x] `app_theme.dart`에 listTileTheme 추가
- [x] 빌드 테스트 통과

### Phase 2: 핵심 위젯 구현
- [x] `InfoRow` 구현 + Widgetbook (atoms/display/)
- [x] `InfoCard` 구현 + Widgetbook (molecules/display/)
- [x] `IconInfoRow` 구현 + Widgetbook (molecules/display/)
- [x] `TossSkeleton` 구현 + Widgetbook (atoms/feedback/)
- [x] atoms/index.dart 업데이트
- [x] molecules/index.dart 업데이트
- [x] 빌드 테스트 통과

### Phase 3: 마이그레이션
- [x] attendance feature 마이그레이션 (_buildInfoRow → InfoRow.between 등)
- [x] employee_setting feature 마이그레이션
- [x] session feature 마이그레이션
- [x] cash_location feature 마이그레이션
- [x] letter_of_credit feature 마이그레이션
- [x] time_table_manage feature 마이그레이션
- [x] TossSkeleton 마이그레이션 (trade_dashboard, cached_product_image)
- [x] CircleAvatar → EmployeeProfileAvatar 마이그레이션 (7개 파일 완료, 3개 특수 케이스 유지)

---

## 6️⃣ ROI 분석

| 작업 | 영향 파일 | 삭제 코드 | 투자 시간 |
|------|:--------:|:--------:|:--------:|
| Theme 업데이트 | 전체 앱 | - | 2시간 |
| TossInfoRow | 50+ 파일 | ~3,000줄 | 4시간 |
| TossInfoCard | 5+ 파일 | ~200줄 | 1시간 |
| TossIconInfoRow | 3+ 파일 | ~100줄 | 1시간 |
| **합계** | **60+ 파일** | **~3,300줄** | **8시간** |

### 기존 계획 대비 절감

| 항목 | 기존 계획 | 수정 계획 | 절감 |
|------|:--------:|:--------:|:----:|
| 새 위젯 개수 | 18개 | 4개 | -78% |
| 예상 작업 시간 | 3주 | 1-2일 | -90% |
| 유지보수 부담 | 높음 | 낮음 | 대폭 감소 |

---

## 7️⃣ 핵심 원칙 요약

1. **Theme First** - 새 위젯 만들기 전에 ThemeData로 해결 시도
2. **ROI 기반** - 10회 미만 사용 패턴은 위젯화하지 않음
3. **Composition over Wrapping** - Flutter 위젯을 감싸지 말고 조합
4. **Progressive Migration** - 한 번에 다 바꾸지 않고 점진적으로
5. **Don't Over-Abstract** - 3개 패턴이면 3개 위젯, 억지로 1개로 합치지 않음

---

## 8️⃣ 완료된 위젯 목록 (2026-01-01 기준)

### Atoms
| 위젯 | 위치 | 설명 |
|------|------|------|
| `InfoRow` | atoms/display/ | 라벨-값 정보 행 (.fixed, .between 팩토리) |
| `TossSkeleton` | atoms/feedback/ | 스켈레톤 로딩 효과 (.card, .circle, .text, .listItem 팩토리) |

### Molecules
| 위젯 | 위치 | 설명 |
|------|------|------|
| `InfoCard` | molecules/display/ | 배경이 있는 정보 카드 |
| `IconInfoRow` | molecules/display/ | 아이콘 포함 정보 행 |
| `TossExpandableCard` | molecules/cards/ | 확장/축소 가능 카드 |
| `TossSelectionCard` | molecules/cards/ | 선택 카드 (.store, .company, .entryType, .expenseSubType 팩토리) |
| `TossSummaryCard` | molecules/cards/ | 선택된 정보 요약 카드 |
| `TossNoticeCard` | molecules/cards/ | 알림/경고 카드 (.warning, .info, .success, .error 팩토리) |
| `TossTransferArrow` | molecules/cards/ | 이동 방향 화살표 |

### 마이그레이션 완료 파일

**InfoRow 마이그레이션:**
- session: count_detail_info_section, session_user_card, history_header_section
- attendance: shift_detail_page, monthly_day_detail, payment_summary_card, report_response_card
- cash_location: denomination_detail_sheet, vault_detail_sheet, transaction_detail_sheet, bank_detail_sheet
- employee_setting: attendance_tab, salary_tab, info_tab
- letter_of_credit: lc_detail_page
- time_table_manage: recorded_attendance_card

**TossSkeleton 마이그레이션:**
- trade_dashboard: trade_dashboard_page
- shared: cached_product_image

**EmployeeProfileAvatar 마이그레이션 (CircleAvatar 대체):**
- employee_setting: employee_detail_sheet_v2
- time_table_manage: staff_timelog_card, problem_card, issue_report_card, snapshot_metrics_section
- session: review_item_detail_sheet, receiving_item_detail_sheet

**CircleAvatar 유지 (특수 케이스):**
- my_page/profile_avatar_section: FileImage 사용 (로컬 이미지 선택)
- homepage/company_store_selector: 회사 아이콘 (직원 아바타 아님)
- attendance/shift_signup_card: URL만 있고 name 없음

---

## 9️⃣ 확장 계획: 프로젝트 완전성을 위한 추가 위젯

### 📊 현재 상태 분석 (2026-01-01)

| 카테고리 | Raw Flutter | Shared 위젯 | 일관성 |
|----------|:-----------:|:-----------:|:------:|
| **Input Fields** | 136개 | 57개 | 30% ❌ |
| **Buttons** | 188개 | 100개 | 35% ⚠️ |
| **Cards/Containers** | 2,031개 | 36개 | 1.8% ❌ |
| **전체** | 2,355개 | 193개 | **7.6%** ❌ |

### 🚨 가장 심각한 불일치 파일

| 파일 | Raw TextFormField | 문제 |
|------|:-----------------:|------|
| `lc_form_page.dart` | 21개 | LC 폼 전체가 raw 위젯 |
| Auth 페이지들 | 25개+ | 로그인/회원가입 불일치 |
| `add_account_page.dart` | 13개 | 계좌 추가 폼 |
| `pi_form_page.dart` | 7개 | PI 폼 |
| `po_form_page.dart` | 4개 | PO 폼 |

---

## 🎯 Phase 4: 입력 위젯 확장 (HIGH ROI)

### 4.1 TossTextField 확장 (prefixIcon 지원)

**현재 문제:** `CounterPartyTextField`가 별도로 존재하는 이유 = prefixIcon 미지원

```dart
// 현재 TossTextField
class TossTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  // ❌ prefixIcon 없음
}

// 확장 후
class TossTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final Widget? prefixIcon;     // ✅ 추가
  final Widget? suffixIcon;     // ✅ 추가
  final String? prefixText;     // ✅ 추가 (통화 기호 등)
}
```

**영향:** CounterPartyTextField 제거 가능, 3개 파일 마이그레이션

### 4.2 TossFormField (Molecule) - NEW

**위치:** `molecules/inputs/toss_form_field.dart`

```dart
/// 라벨 + 입력필드 + 에러메시지 조합
///
/// 폼에서 반복되는 패턴 통합
class TossFormField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Widget child;           // TossTextField, TossDropdown 등
  final String? errorMessage;
  final String? helperText;

  const TossFormField({...});
}

// 사용 예시
TossFormField(
  label: 'Company Name',
  isRequired: true,
  child: TossTextField(
    controller: _nameController,
    hint: 'Enter company name',
  ),
  errorMessage: _nameError,
)
```

**ROI:** 폼 페이지마다 ~50줄 절감, 50+ 파일 영향

### 4.3 TossPasswordField (Molecule) - NEW

**위치:** `molecules/inputs/toss_password_field.dart`

```dart
/// 비밀번호 입력 필드 (visibility toggle 포함)
class TossPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;

  const TossPasswordField({...});
}
```

**영향:** Auth 페이지 5개 파일 마이그레이션

---

## 🎯 Phase 5: 레이아웃 유틸리티 (MEDIUM ROI)

### 5.1 TossSection - NEW

**위치:** `molecules/layout/toss_section.dart`

```dart
/// 섹션 헤더 + 컨텐츠 조합
///
/// 페이지에서 반복되는 "Section Title" + content 패턴
class TossSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;       // "See all" 버튼 등
  final EdgeInsets padding;

  const TossSection({...});
}

// 사용 예시
TossSection(
  title: 'Recent Transactions',
  trailing: TextButton(onPressed: ..., child: Text('See all')),
  child: TransactionList(...),
)
```

**ROI:** 섹션 패턴 ~100개 파일에서 사용

### 5.2 TossFormSection - NEW

**위치:** `molecules/layout/toss_form_section.dart`

```dart
/// 폼 섹션 (여러 입력 필드 그룹)
class TossFormSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final double spacing;

  const TossFormSection({
    this.title,
    required this.children,
    this.spacing = TossSpacing.space3,
  });
}

// 사용 예시
TossFormSection(
  title: 'Basic Information',
  children: [
    TossFormField(label: 'Name', child: TossTextField(...)),
    TossFormField(label: 'Email', child: TossTextField(...)),
  ],
)
```

---

## 🎯 Phase 6: 피드백 & 상태 (LOW-MEDIUM ROI)

### 6.1 TossToast - NEW

**위치:** `atoms/feedback/toss_toast.dart`

```dart
/// 통합 토스트/스낵바 유틸리티
class TossToast {
  static void success(BuildContext context, String message);
  static void error(BuildContext context, String message);
  static void info(BuildContext context, String message);
  static void warning(BuildContext context, String message);
}

// 사용 예시
TossToast.success(context, 'Saved successfully');
TossToast.error(context, 'Failed to save');
```

**ROI:** ScaffoldMessenger 호출 통일, 스타일 일관성

### 6.2 TossProgressIndicator - NEW

**위치:** `atoms/feedback/toss_progress_indicator.dart`

```dart
/// 진행률 표시 (linear/circular)
class TossProgressIndicator extends StatelessWidget {
  final double? value;          // null = indeterminate
  final TossProgressType type;  // linear, circular
  final Color? color;

  const TossProgressIndicator({...});

  factory TossProgressIndicator.linear({double? value});
  factory TossProgressIndicator.circular({double? value, double size = 24});
}
```

---

## 🎯 Phase 7: 데이터 디스플레이 (MEDIUM ROI)

### 7.1 TossListItem - NEW

**위치:** `molecules/display/toss_list_item.dart`

```dart
/// 통합 리스트 아이템 (ListTile 대체)
class TossListItem extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  const TossListItem({...});

  /// 아이콘 + 텍스트 패턴
  factory TossListItem.icon({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  });

  /// 아바타 + 텍스트 패턴
  factory TossListItem.avatar({
    required String imageUrl,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  });
}
```

**ROI:** ListTile 42개 + 커스텀 리스트 아이템 ~100개 통일

### 7.2 TossDataTable - NEW (선택적)

**위치:** `organisms/data/toss_data_table.dart`

```dart
/// 데이터 테이블 (정렬, 페이지네이션 지원)
class TossDataTable<T> extends StatelessWidget {
  final List<TossTableColumn<T>> columns;
  final List<T> data;
  final bool showHeader;
  final bool isLoading;
  final Widget? emptyWidget;

  const TossDataTable({...});
}
```

---

## 📋 확장 마이그레이션 체크리스트

### Phase 4: 입력 위젯 확장
- [ ] TossTextField에 prefixIcon/suffixIcon 추가
- [ ] TossFormField 구현 + Widgetbook
- [ ] TossPasswordField 구현 + Widgetbook
- [ ] Auth 페이지 마이그레이션 (5개 파일)
- [ ] CounterPartyTextField 제거

### Phase 5: 레이아웃 유틸리티
- [ ] TossSection 구현 + Widgetbook
- [ ] TossFormSection 구현 + Widgetbook
- [ ] lc_form_page.dart 마이그레이션 (21개 필드)
- [ ] add_account_page.dart 마이그레이션 (13개 필드)
- [ ] pi_form_page.dart 마이그레이션 (7개 필드)

### Phase 6: 피드백 & 상태
- [ ] TossToast 구현
- [ ] TossProgressIndicator 구현 + Widgetbook
- [ ] ScaffoldMessenger 호출 마이그레이션

### Phase 7: 데이터 디스플레이
- [ ] TossListItem 구현 + Widgetbook
- [ ] ListTile 마이그레이션 (42개)
- [ ] TossDataTable 구현 (선택적)

---

## 📊 확장 ROI 분석

| Phase | 새 위젯 | 영향 파일 | 삭제 코드 | 투자 시간 |
|-------|:-------:|:--------:|:--------:|:---------:|
| Phase 4 | 3개 | 60+ | ~1,500줄 | 8시간 |
| Phase 5 | 2개 | 100+ | ~2,000줄 | 6시간 |
| Phase 6 | 2개 | 50+ | ~500줄 | 4시간 |
| Phase 7 | 2개 | 50+ | ~800줄 | 6시간 |
| **합계** | **9개** | **260+** | **~4,800줄** | **24시간** |

### 전체 일관성 목표

| 현재 | Phase 4 후 | Phase 7 후 |
|:----:|:----------:|:----------:|
| 7.6% | ~25% | ~60% |

---

## 🎯 우선순위 권장

### 즉시 시작 (HIGH ROI)
1. **TossTextField 확장** - prefixIcon 추가만으로 3개 파일 정리
2. **TossFormField** - 폼 페이지 전체 개선
3. **TossPasswordField** - Auth 일관성

### 다음 스프린트 (MEDIUM ROI)
4. **TossSection** - 섹션 패턴 통일
5. **TossListItem** - 리스트 일관성
6. **TossToast** - 피드백 통일

### 나중에 (LOW ROI / 선택적)
7. TossFormSection
8. TossProgressIndicator
9. TossDataTable

---

**작성:** Claude (30년차 Flutter Architect)
**기준:** 실제 프로젝트 사용 빈도 분석 (grep 기반)
**최종 업데이트:** 2026-01-01
