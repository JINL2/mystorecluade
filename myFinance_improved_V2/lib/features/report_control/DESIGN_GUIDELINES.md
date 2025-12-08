# Report Control - Design Guidelines

보고서 기능의 일관된 디자인 시스템 가이드라인

## 🎨 Toss Design System 필수 준수 사항

### ✅ 반드시 사용해야 하는 Shared Resources

#### 📍 위치
```
/lib/shared/
├── themes/               # 디자인 토큰
│   ├── toss_colors.dart        # 색상
│   ├── toss_text_styles.dart   # 타이포그래피
│   ├── toss_spacing.dart       # 간격 시스템
│   ├── toss_border_radius.dart # 둥근 모서리
│   └── toss_shadows.dart       # 그림자
└── widgets/              # 공통 컴포넌트
    ├── toss/
    │   ├── toss_card.dart
    │   ├── toss_button.dart
    │   ├── toss_expandable_card.dart
    │   └── ...
    └── common/
        ├── toss_white_card.dart
        ├── toss_section_header.dart
        └── ...
```

---

## 🎯 핵심 원칙

### 1. **절대 하드코딩 금지**

❌ **Bad** (하드코딩)
```dart
Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 8,
      ),
    ],
  ),
  child: Text(
    'Title',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
)
```

✅ **Good** (Design System)
```dart
Container(
  padding: EdgeInsets.all(TossSpacing.paddingLG),
  decoration: BoxDecoration(
    color: TossColors.white,
    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
    boxShadow: TossShadows.card,
  ),
  child: Text(
    'Title',
    style: TossTextStyles.h4.copyWith(
      color: TossColors.gray900,
    ),
  ),
)
```

---

## 📐 Spacing 시스템 (4px Grid)

### 기본 Spacing
```dart
TossSpacing.space1  // 4px  - 최소 간격
TossSpacing.space2  // 8px  - Tight spacing
TossSpacing.space3  // 12px - Small spacing
TossSpacing.space4  // 16px - Default spacing ⭐
TossSpacing.space5  // 20px - Medium spacing
TossSpacing.space6  // 24px - Large spacing ⭐
TossSpacing.space8  // 32px - Section spacing
```

### Component Spacing
```dart
// Padding
TossSpacing.paddingXS   // 8px  - Small buttons, chips
TossSpacing.paddingSM   // 12px - Input fields
TossSpacing.paddingMD   // 16px - Cards, list items ⭐
TossSpacing.paddingLG   // 20px - Sections ⭐
TossSpacing.paddingXL   // 24px - Page padding

// Margins
TossSpacing.marginXS    // 4px  - Between inline elements
TossSpacing.marginSM    // 8px  - Between related items
TossSpacing.marginMD    // 16px - Between components ⭐

// Gaps (Flex layouts)
TossSpacing.gapXS       // 4px  - Icon-text gap
TossSpacing.gapSM       // 8px  - Button content gap
TossSpacing.gapMD       // 12px - Form field gap
TossSpacing.gapLG       // 16px - Card content gap
```

### 사용 예시
```dart
// ✅ Good
Container(
  margin: EdgeInsets.only(bottom: TossSpacing.marginXS),
  padding: EdgeInsets.symmetric(
    horizontal: TossSpacing.paddingSM,
    vertical: TossSpacing.space2,
  ),
)

// ❌ Bad
Container(
  margin: const EdgeInsets.only(bottom: 4),
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
)
```

---

## 🎨 Color System

### 기본 색상
```dart
TossColors.white      // #FFFFFF
TossColors.black      // #000000
TossColors.primary    // #0064FF (Toss Blue)
```

### Gray Scale
```dart
TossColors.gray50     // 배경색 (매우 밝음)
TossColors.gray100    // 아이콘 박스 배경
TossColors.gray200    // Border
TossColors.gray400    // Disabled
TossColors.gray500    // Secondary icon
TossColors.gray600    // Secondary text ⭐
TossColors.gray700    // Body text ⭐
TossColors.gray800    // Heading text
TossColors.gray900    // Primary text ⭐
```

### 사용 가이드
```dart
// ✅ Good
Text(
  'Title',
  style: TossTextStyles.h4.copyWith(
    color: TossColors.gray900,  // Primary text
  ),
)

Text(
  'Description',
  style: TossTextStyles.caption.copyWith(
    color: TossColors.gray600,  // Secondary text
  ),
)

// ❌ Bad
Text(
  'Title',
  style: TextStyle(color: Colors.black),
)
```

---

## 📝 Typography System

### Headings
```dart
TossTextStyles.display       // 32px/w800 - Hero sections
TossTextStyles.h1            // 28px/w700 - Page titles
TossTextStyles.h2            // 24px/w700 - Section headers
TossTextStyles.h3            // 20px/w600 - Subsection headers
TossTextStyles.h4            // 18px/w600 - Card titles ⭐
```

### Body Text
```dart
TossTextStyles.bodyLarge     // 14px/w400 - Body text
TossTextStyles.bodyMedium    // 14px/w600 - Emphasized ⭐
TossTextStyles.bodySmall     // 13px/w600 - Small text ⭐
```

### Labels
```dart
TossTextStyles.label         // 12px/w500 - UI labels
TossTextStyles.labelMedium   // 12px/w600 - Bold labels
TossTextStyles.caption       // 12px/w400 - Helper text ⭐
TossTextStyles.small         // 11px/w400 - Tiny text ⭐
```

### Financial Numbers
```dart
TossTextStyles.amount        // 20px/JetBrains Mono - 금액 표시
```

### 사용 예시
```dart
// ✅ Good
Text(
  'Transaction History',
  style: TossTextStyles.h4.copyWith(
    color: TossColors.gray900,
  ),
)

Text(
  '19 transactions',
  style: TossTextStyles.bodySmall.copyWith(
    color: TossColors.gray600,
    fontWeight: FontWeight.w400,
  ),
)

// ❌ Bad
Text(
  'Transaction History',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
)
```

---

## 🔲 Border Radius

```dart
TossBorderRadius.sm     // 6px  - Chips, small elements
TossBorderRadius.md     // 8px  - Buttons, inputs ⭐
TossBorderRadius.lg     // 12px - Cards ⭐
TossBorderRadius.xl     // 16px - Large cards, modals ⭐
TossBorderRadius.xxl    // 20px - Bottom sheets
TossBorderRadius.full   // 999px - Circular
```

### 사용 예시
```dart
// ✅ Good
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
  ),
)

// ❌ Bad
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
  ),
)
```

---

## 🌑 Shadow System

```dart
TossShadows.card         // 카드 그림자 (4% opacity) ⭐
TossShadows.elevation1   // Level 1 (barely visible)
TossShadows.elevation2   // Level 2 (subtle lift)
TossShadows.elevation3   // Level 3 (dropdowns)
TossShadows.elevation4   // Level 4 (modals)
```

### 사용 예시
```dart
// ✅ Good
Container(
  decoration: BoxDecoration(
    boxShadow: TossShadows.card,
  ),
)

// ❌ Bad
Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  ),
)
```

---

## 🎯 Icon 사용 가이드

### Icon 크기
```dart
TossSpacing.iconXS      // 16px - Small icons ⭐
TossSpacing.iconSM      // 20px - Default icons ⭐
TossSpacing.iconMD      // 24px - Medium icons
TossSpacing.iconLG      // 32px - Large icons
TossSpacing.iconXL      // 40px - Extra large
```

### Lucide Icons 우선 사용
```dart
// ✅ Good
import 'package:lucide_icons/lucide_icons.dart';

Icon(
  LucideIcons.receipt,
  size: TossSpacing.iconSM,
  color: TossColors.gray600,
)

// ⚠️ Acceptable (Material Icons)
Icon(
  Icons.receipt_long_outlined,
  size: TossSpacing.iconSM,
  color: TossColors.gray600,
)
```

---

## 🏗️ 섹션 헤더 디자인 패턴

모든 섹션은 동일한 헤더 스타일을 사용합니다.

### 표준 섹션 헤더 구조
```dart
Row(
  children: [
    // 1. 아이콘 박스
    Container(
      padding: EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Icon(
        LucideIcons.yourIcon,
        size: TossSpacing.iconSM,
        color: TossColors.gray600,
      ),
    ),
    SizedBox(width: TossSpacing.gapMD),

    // 2. 제목 & 부제목
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Section Title',
            style: TossTextStyles.h4.copyWith(
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            'Subtitle or count',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),

    // 3. 액션 아이콘 (옵션)
    Icon(
      LucideIcons.chevronDown,
      color: TossColors.gray600,
      size: TossSpacing.iconSM,
    ),
  ],
)
```

### 적용된 섹션들
- ✅ Account Changes Section
- ✅ AI Insights Section
- ✅ Red Flags Section
- ✅ **Transaction History Section** (새로 추가)

---

## 📦 Card/Container 디자인 패턴

### 표준 White Card
```dart
Container(
  padding: EdgeInsets.all(TossSpacing.paddingLG),
  decoration: BoxDecoration(
    color: TossColors.white,
    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
    boxShadow: TossShadows.card,
  ),
  child: YourContent(),
)
```

### 작은 카드 (리스트 아이템)
```dart
Container(
  margin: EdgeInsets.only(bottom: TossSpacing.marginXS),
  padding: EdgeInsets.symmetric(
    horizontal: TossSpacing.paddingSM,
    vertical: TossSpacing.space2,
  ),
  decoration: BoxDecoration(
    color: TossColors.gray50,
    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
  ),
  child: YourContent(),
)
```

---

## 🎨 Transaction Card 디자인 스펙

### 구조
```
┌─────────────────────────────────────────┐
│ 14,630,000 ₫  Cash → Sales revenue      │ ← 1줄: 금액 + 계정 흐름
│ Jin2 Lee              "설명 텍스트..."   │ ← 2줄: 직원 + 설명
└─────────────────────────────────────────┘
```

### 스타일 스펙
```dart
// Container
margin: TossSpacing.marginXS         // 4px bottom
padding: horizontal(12px), vertical(8px)
background: TossColors.gray50
borderRadius: TossBorderRadius.sm    // 6px

// 첫 줄
금액: TossTextStyles.bodyMedium      // 14px/w600
계정: TossTextStyles.bodySmall       // 13px/w600
간격: TossSpacing.gapSM              // 8px

// 둘째 줄
직원: TossTextStyles.caption         // 12px/w400
설명: TossTextStyles.small           // 11px/w400/italic
간격: TossSpacing.space2             // 8px
```

### 코드 예시
```dart
class TransactionCard extends StatelessWidget {
  final TransactionEntry transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.marginXS),
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.paddingSM,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 첫 줄: 금액 + 계정 흐름
          Row(
            children: [
              Text(
                transaction.formattedAmount,
                style: TossTextStyles.bodyMedium.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(width: TossSpacing.gapSM),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        transaction.debitAccount,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.gapXS,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: TossSpacing.space3,
                        color: TossColors.gray500,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        transaction.creditAccount,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.gapXS),

          // 둘째 줄: 직원 + 설명
          Row(
            children: [
              Expanded(
                child: Text(
                  transaction.employeeName,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (transaction.description != null) ...[
                SizedBox(width: TossSpacing.space2),
                Flexible(
                  child: Text(
                    transaction.description!,
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.gray500,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## 📊 Section 디자인 스펙

### Transaction History Section

```dart
Container(
  padding: EdgeInsets.all(TossSpacing.paddingLG),  // 20px
  decoration: BoxDecoration(
    color: TossColors.white,
    borderRadius: BorderRadius.circular(TossBorderRadius.xl),  // 16px
    boxShadow: TossShadows.card,
  ),
  child: Column(
    children: [
      // 헤더
      Row(
        children: [
          Container(
            padding: EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              LucideIcons.receipt,
              size: TossSpacing.iconSM,
              color: TossColors.gray600,
            ),
          ),
          SizedBox(width: TossSpacing.gapMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction History',
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  '19 transactions',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronDown,
            color: TossColors.gray600,
            size: TossSpacing.iconSM,
          ),
        ],
      ),

      // Content (expandable)
      if (isExpanded) ...[
        SizedBox(height: TossSpacing.gapLG),
        YourContent(),
      ],
    ],
  ),
)
```

---

## 🏪 Store Header 디자인 스펙

가게별 그룹 헤더는 간단하게 유지합니다.

```dart
Row(
  children: [
    Icon(
      LucideIcons.store,
      size: TossSpacing.iconXS,  // 16px
      color: TossColors.gray600,
    ),
    SizedBox(width: TossSpacing.marginXS),
    Expanded(
      child: Text(
        storeName,
        style: TossTextStyles.bodyMedium.copyWith(
          color: TossColors.gray900,
        ),
      ),
    ),
    Text(
      '7 txs · 88.5M ₫',
      style: TossTextStyles.caption.copyWith(
        color: TossColors.gray600,
      ),
    ),
  ],
)
```

---

## 📏 레이아웃 계층

### 정보 흐름 (Top → Down)
```
1. 회사 전체 요약 (Account Changes)
   └─ TossTextStyles.h4 제목

2. AI 분석 (AI Insights)
   └─ TossTextStyles.h4 제목

3. 경고 사항 (Red Flags)
   └─ TossTextStyles.h4 제목

4. 거래 상세 (Transaction History) ⭐ 맨 아래
   └─ 가게별 그룹 (bodyMedium)
      └─ 거래 카드 (bodyMedium → caption)
```

### Spacing between sections
```dart
const SizedBox(height: TossSpacing.marginLG),  // 24px between sections
```

---

## ✅ 체크리스트

### 새로운 템플릿 개발 시

- [ ] **모든 색상**이 `TossColors.*` 사용
- [ ] **모든 폰트 크기**가 `TossTextStyles.*` 사용
- [ ] **모든 간격**이 `TossSpacing.*` 사용
- [ ] **모든 border radius**가 `TossBorderRadius.*` 사용
- [ ] **모든 그림자**가 `TossShadows.*` 사용
- [ ] **아이콘**은 Lucide Icons 우선 사용
- [ ] **섹션 헤더**가 표준 패턴 사용
- [ ] **하드코딩된 값** 0개
- [ ] **const 생성자** 최대한 사용
- [ ] **4px grid** 준수

---

## 🚫 절대 금지 사항

### ❌ Bad Practices

```dart
// ❌ 하드코딩된 색상
color: Colors.black
color: Color(0xFF000000)
color: Colors.grey[600]

// ❌ 하드코딩된 크기
fontSize: 16
padding: EdgeInsets.all(20)
borderRadius: BorderRadius.circular(12)

// ❌ 하드코딩된 그림자
boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), ...)]

// ❌ 인라인 TextStyle
style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)

// ❌ 매직 넘버
SizedBox(height: 16)
Icon(Icons.star, size: 20)
```

### ✅ Good Practices

```dart
// ✅ Design System 사용
color: TossColors.gray900
fontSize: TossTextStyles.bodyMedium
padding: EdgeInsets.all(TossSpacing.paddingLG)
borderRadius: BorderRadius.circular(TossBorderRadius.xl)
boxShadow: TossShadows.card
style: TossTextStyles.h4.copyWith(color: TossColors.gray900)
SizedBox(height: TossSpacing.gapLG)
Icon(LucideIcons.star, size: TossSpacing.iconSM)
```

---

## 📖 참고 파일

### 완벽한 예시 (100% Design System)
- ✅ `transaction_card.dart` - 2줄 미니멀 카드
- ✅ `all_transactions_section.dart` - 가게별 그룹화 섹션
- ✅ `account_changes_section.dart` - 계정 변경 섹션
- ✅ `ai_insights_section.dart` - AI 분석 섹션

### Design System 파일
- `lib/shared/themes/toss_colors.dart`
- `lib/shared/themes/toss_text_styles.dart`
- `lib/shared/themes/toss_spacing.dart`
- `lib/shared/themes/toss_border_radius.dart`
- `lib/shared/themes/toss_shadows.dart`

---

## 🎯 목표

1. **통일성 증대**: 앱 전체가 동일한 디자인 언어 사용
2. **유지보수성**: 디자인 변경 시 한 곳만 수정
3. **가독성**: 코드의 의도가 명확하게 드러남
4. **확장성**: 새로운 템플릿 추가 시 일관성 유지

---

**Last Updated**: 2025-12-04
**Maintainer**: Development Team
