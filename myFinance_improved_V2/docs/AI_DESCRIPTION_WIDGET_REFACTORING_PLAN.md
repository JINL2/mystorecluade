# AI Description Widget Refactoring Plan

## Overview
AI description이 사용되는 3개 feature의 중복 코드를 공통 위젯으로 추출하여 코드 효율성과 디자인 일관성을 확보합니다.

## Current State Analysis

### Features Using AI Description
| Feature | List Item | Detail Sheet | OCR Details |
|---------|-----------|--------------|-------------|
| `transaction_history` | ✅ | ✅ | ✅ |
| `sales_invoice` | ✅ | ✅ | ✅ |
| `cash_location` | ❌ | ✅ | ❌ |

### Current Code Duplication
```dart
// Pattern 1: List Item (compact, 1-2 lines)
Row(
  children: [
    Icon(Icons.auto_awesome, size: 12, color: Colors.amber.shade600),
    const SizedBox(width: 4),
    Expanded(
      child: Text(aiDescription, style: ..., maxLines: 1-2),
    ),
  ],
)

// Pattern 2: Detail Box (full content)
Container(
  decoration: BoxDecoration(
    color: Colors.amber.shade50,
    border: Border.all(color: Colors.amber.shade200),
  ),
  child: Column([
    Row([Icon, Text('AI Summary')]),
    Divider,
    Text(fullContent),
  ]),
)

// Pattern 3: OCR Analysis Details (per-image list)
Container(
  decoration: BoxDecoration(color: amber, border: amber),
  child: Column([
    Header('AI Analysis Details'),
    ...numberedOcrList,
  ]),
)
```

---

## Proposed Architecture

### Directory Structure
```
lib/shared/widgets/ai/
├── index.dart                    # Barrel export
├── ai_description_row.dart       # List item용 (compact)
├── ai_description_box.dart       # Detail sheet용 (full)
└── ai_analysis_details_box.dart  # Attachment OCR용
```

### Design Tokens (Consistent Colors)
```dart
// lib/shared/themes/toss_colors.dart에 추가
class TossColors {
  // AI/Amber colors
  static Color get aiPrimary => Colors.amber.shade600;
  static Color get aiSecondary => Colors.amber.shade700;
  static Color get aiBackground => Colors.amber.shade50;
  static Color get aiBorder => Colors.amber.shade200;
  static Color get aiSurface => Colors.amber.shade100;
  static Color get aiText => Colors.amber.shade800;
}
```

---

## Widget Specifications

### 1. AiDescriptionRow (List Item용)
**Purpose**: 리스트 아이템에서 AI description을 1-2줄로 compact하게 표시

```dart
/// Compact AI description row for list items
///
/// Usage:
/// ```dart
/// if (invoice.hasAiDescription)
///   AiDescriptionRow(text: invoice.aiDescription!),
/// ```
class AiDescriptionRow extends StatelessWidget {
  final String text;
  final int maxLines;        // default: 1
  final double iconSize;     // default: 12
  final double fontSize;     // default: 12
  final CrossAxisAlignment alignment; // default: center

  const AiDescriptionRow({
    required this.text,
    this.maxLines = 1,
    this.iconSize = 12,
    this.fontSize = 12,
    this.alignment = CrossAxisAlignment.center,
  });
}
```

### 2. AiDescriptionBox (Detail Sheet용)
**Purpose**: Detail sheet에서 AI summary를 박스 형태로 표시

```dart
/// AI description box for detail sheets
///
/// Usage:
/// ```dart
/// if (hasAiDescription)
///   AiDescriptionBox(
///     title: 'AI Summary',  // optional, default shown
///     text: aiDescription,
///   ),
/// ```
class AiDescriptionBox extends StatelessWidget {
  final String text;
  final String? title;       // default: 'AI Summary'
  final bool showDivider;    // default: true (when has title)

  const AiDescriptionBox({
    required this.text,
    this.title,
    this.showDivider = true,
  });
}
```

### 3. AiAnalysisDetailsBox (OCR용)
**Purpose**: Attachment의 OCR 결과를 번호가 매겨진 리스트로 표시

```dart
/// AI analysis details for attachments with OCR
///
/// Usage:
/// ```dart
/// if (attachments.any((a) => a.hasOcr))
///   AiAnalysisDetailsBox(
///     items: attachments
///       .where((a) => a.hasOcr)
///       .map((a) => a.ocrText!)
///       .toList(),
///   ),
/// ```
class AiAnalysisDetailsBox extends StatelessWidget {
  final List<String> items;
  final String? title;       // default: 'AI Analysis Details'

  const AiAnalysisDetailsBox({
    required this.items,
    this.title,
  });
}
```

---

## Implementation Steps

### Step 1: Add AI Color Tokens
**File**: `lib/shared/themes/toss_colors.dart`
- Add amber color tokens for AI elements
- Ensures consistent colors across all usages

### Step 2: Create Shared Widgets
**Files**: `lib/shared/widgets/ai/*.dart`
1. Create `ai_description_row.dart`
2. Create `ai_description_box.dart`
3. Create `ai_analysis_details_box.dart`
4. Create `index.dart` barrel export

### Step 3: Refactor transaction_history
**Files**:
- `lib/features/transaction_history/presentation/widgets/transaction_list_item.dart`
- `lib/features/transaction_history/presentation/widgets/transaction_detail_sheet.dart`

### Step 4: Refactor sales_invoice
**Files**:
- `lib/features/sales_invoice/presentation/widgets/invoice_list/invoice_list_item.dart`
- `lib/features/sales_invoice/presentation/modals/invoice_detail_modal.dart`

### Step 5: Refactor cash_location
**Files**:
- `lib/features/cash_location/presentation/widgets/journal_detail_sheet.dart`

---

## Migration Before/After

### Before (transaction_list_item.dart)
```dart
if (transaction.aiDescription != null && transaction.aiDescription!.isNotEmpty)
  Padding(
    padding: const EdgeInsets.only(top: TossSpacing.space2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.auto_awesome, size: 12, color: Colors.amber.shade600),
        const SizedBox(width: TossSpacing.space1),
        Expanded(
          child: Text(
            transaction.aiDescription!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontSize: 11,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  ),
```

### After
```dart
if (transaction.aiDescription != null && transaction.aiDescription!.isNotEmpty)
  Padding(
    padding: const EdgeInsets.only(top: TossSpacing.space2),
    child: AiDescriptionRow(
      text: transaction.aiDescription!,
      maxLines: 2,
      alignment: CrossAxisAlignment.start,
    ),
  ),
```

---

## Benefits
1. **코드 중복 제거**: 3개 feature에서 동일 코드 제거
2. **디자인 일관성**: 모든 AI 요소가 동일한 스타일 사용
3. **유지보수 용이**: 스타일 변경 시 한 곳만 수정
4. **타입 안전성**: 명확한 API로 사용 오류 방지
5. **재사용성**: 새 feature에서 쉽게 사용 가능

---

## Files to Create
1. `lib/shared/widgets/ai/index.dart`
2. `lib/shared/widgets/ai/ai_description_row.dart`
3. `lib/shared/widgets/ai/ai_description_box.dart`
4. `lib/shared/widgets/ai/ai_analysis_details_box.dart`

## Files to Modify
1. `lib/shared/themes/toss_colors.dart` - Add AI color tokens
2. `lib/features/transaction_history/presentation/widgets/transaction_list_item.dart`
3. `lib/features/transaction_history/presentation/widgets/transaction_detail_sheet.dart`
4. `lib/features/sales_invoice/presentation/widgets/invoice_list/invoice_list_item.dart`
5. `lib/features/sales_invoice/presentation/modals/invoice_detail_modal.dart`
6. `lib/features/cash_location/presentation/widgets/journal_detail_sheet.dart`

---

## Notes
- Data/Domain 레이어는 변경 없음 (Presentation 레이어만 리팩토링)
- 기존 기능 100% 유지, 스타일만 통합
- TossChip, TossBadge 패턴 참고하여 일관된 API 설계
