# Design Implementation Guide

## Store Settings Page Design Language

Based on the Store Settings page analysis, here's how to implement the consistent visual design across your app:

## Key Design Elements

### 1. **Page Structure**
```dart
Scaffold(
  backgroundColor: TossColors.gray100,  // Light gray background
  appBar: TossAppBar(...),
  body: SingleChildScrollView(
    padding: EdgeInsets.all(TossSpacing.paddingMD),  // 16px padding
    child: Column(
      children: [
        // Content cards with spacing
      ],
    ),
  ),
)
```

### 2. **Card Components**
```dart
// Use TossCard or TossPageStyles.card()
TossCard(
  padding: EdgeInsets.all(TossSpacing.space5),  // 20px internal padding
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Card content
    ],
  ),
)
```

### 3. **Section Headers**
```dart
Text(
  'Section Title',
  style: TossTextStyles.bodyLarge.copyWith(
    color: TossColors.gray900,
    fontWeight: FontWeight.w700,
  ),
)
```

### 4. **List Items with Icons**
```dart
Container(
  padding: EdgeInsets.all(TossSpacing.space3),
  decoration: BoxDecoration(
    color: TossColors.gray50,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
  ),
  child: Row(
    children: [
      // Icon container
      Container(
        width: TossSpacing.iconXL,
        height: TossSpacing.iconXL,
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Icon(
          icon,
          color: TossColors.primary,
          size: TossSpacing.iconSM,
        ),
      ),
      SizedBox(width: TossSpacing.space3),
      // Text content
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Subtitle',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      ),
      // Chevron
      Icon(
        Icons.chevron_right,
        color: TossColors.gray400,
        size: TossSpacing.iconSM,
      ),
    ],
  ),
)
```

### 5. **Detail Rows**
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      'Label',
      style: TossTextStyles.body.copyWith(
        color: TossColors.gray600,
      ),
    ),
    Text(
      'Value',
      style: TossTextStyles.body.copyWith(
        color: TossColors.gray900,
        fontWeight: FontWeight.w600,
      ),
    ),
  ],
)
```

## Color Usage

| Element | Color | Usage |
|---------|-------|-------|
| Page Background | `TossColors.gray100` | Main scaffold background |
| Card Background | `TossColors.white` | Content cards |
| Primary Actions | `TossColors.primary` | Icons, buttons, links |
| Headers | `TossColors.gray900` | Section titles, important text |
| Body Text | `TossColors.gray700` | Regular content |
| Subtitles | `TossColors.gray600` | Secondary information |
| Disabled | `TossColors.gray400` | Inactive elements |
| Success | `TossColors.success` | Active status, positive states |
| List Item Background | `TossColors.gray50` | Clickable list items |
| Icon Container | `primary.withOpacity(0.1)` | Light blue background for icons |

## Spacing Guidelines

- **Between Cards**: `TossSpacing.space5` (20px)
- **Card Padding**: `TossSpacing.space5` (20px)
- **Between List Items**: `TossSpacing.space3` (12px)
- **Between Detail Rows**: `TossSpacing.space2` (8px)
- **Icon to Text**: `TossSpacing.space3` (12px)

## Typography Hierarchy

1. **Page Title**: (in AppBar)
   - Font: Default AppBar style
   - Color: `TossColors.gray900`

2. **Section Headers**: 
   - Style: `TossTextStyles.bodyLarge`
   - Weight: `FontWeight.w700`
   - Color: `TossColors.gray900`

3. **List Item Titles**:
   - Style: `TossTextStyles.body`
   - Weight: `FontWeight.w600`
   - Color: `TossColors.gray900`

4. **Subtitles/Descriptions**:
   - Style: `TossTextStyles.caption`
   - Weight: `FontWeight.w400`
   - Color: `TossColors.gray600`

5. **Values**:
   - Style: `TossTextStyles.body`
   - Weight: `FontWeight.w600`
   - Color: `TossColors.gray900` (or status color)

## Implementation Example

```dart
import 'package:flutter/material.dart';
import 'core/themes/toss_page_styles.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TossPageStyles.pageScaffold(
      appBar: TossAppBar(title: 'My Page'),
      body: SingleChildScrollView(
        padding: TossPageStyles.pagePadding,
        child: Column(
          children: [
            // Information Card
            TossPageStyles.card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Section Title', style: TossPageStyles.sectionTitleStyle),
                  SizedBox(height: TossSpacing.space4),
                  TossPageStyles.detailRow(
                    label: 'Status',
                    value: 'Active',
                    valueColor: TossColors.success,
                  ),
                ],
              ),
            ),
            SizedBox(height: TossPageStyles.sectionSpacing),
            
            // Configuration Options
            TossPageStyles.card(
              child: Column(
                children: [
                  TossPageStyles.listItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'Configure app settings',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Applying to Cash Ending Page

To make the Cash Ending page follow this design:

1. Change background from `TossColors.background` to `TossColors.gray100`
2. Wrap content sections in white cards with padding
3. Use the consistent typography hierarchy
4. Apply proper spacing between sections
5. Style list items with gray50 background and proper padding
6. Use blue accent colors for interactive elements

This creates a cohesive, professional look that matches the Store Settings page aesthetic.