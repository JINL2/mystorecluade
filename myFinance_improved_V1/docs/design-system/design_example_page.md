# Design System Reference - Cash Control Page
## UI/UX Consistency Guide for MyFinance App

> **Important**: This document defines the standard UI/UX patterns based on the Cash Control page. All new pages MUST follow these guidelines to maintain consistency throughout the app.

---

## 🎨 Core Design Principles

### Key UI Guidelines
1. **Group Related Items**: Always combine related options/actions in a single container rather than separate cards
2. **Minimize Visual Layers**: Use clean, flat design with minimal backgrounds and borders
3. **Consistent Grouping**: Items with similar functions should share the same container
4. **Clear Hierarchy**: Use section headers to label groups, not individual items

### Background Colors
- **Page Background**: `#F7F8FA` (Light gray background)
- **Container/Card Background**: `Colors.white` (Pure white)
- **Overlay/Modal Background**: `Colors.white` with dark backdrop

### Primary Colors
- **Primary Action/Links**: `Theme.of(context).colorScheme.primary` (Blue)
- **Income/Positive Values**: `Theme.of(context).colorScheme.primary` (Blue)
- **Error/Negative Values**: `#E53935` (Red)
- **Text Primary**: `Colors.black87`
- **Text Secondary**: `Colors.grey[600]`
- **Text Disabled**: `Colors.grey[400]`
- **Icon Colors**: `Colors.grey[400]` for navigation, primary color for actions

---

## 📐 Layout & Spacing

### Page Structure
```dart
Scaffold(
  backgroundColor: const Color(0xFFF7F8FA),
  body: SafeArea(
    child: Column(
      children: [
        // 1. Header (56px height)
        // 2. Tab Bar (if needed)
        // 3. Content Area (Expanded, scrollable)
      ],
    ),
  ),
)
```

### Standard Spacing (Use TossSpacing)
- **Minimal**: `TossSpacing.space1` (4px)
- **Small**: `TossSpacing.space2` (8px)
- **Default**: `TossSpacing.space3` (12px)
- **Standard**: `TossSpacing.space4` (16px)
- **Large**: `TossSpacing.space5` (20px)
- **Section**: `TossSpacing.space6` (24px)

### Container Padding
- **Card Padding**: `EdgeInsets.all(TossSpacing.space5)` (20px)
- **Page Padding**: `EdgeInsets.all(TossSpacing.space4)` (16px)
- **List Item Padding**: `EdgeInsets.symmetric(vertical: TossSpacing.space4)`

---

## 🔤 Typography

### Text Styles (Use TossTextStyles)

#### Headers
- **Page Title**: 
  ```dart
  TossTextStyles.h3.copyWith(
    fontWeight: FontWeight.w600,
  )
  ```
- **Section Title**:
  ```dart
  TossTextStyles.body.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 17,
  )
  ```

#### Body Text
- **Primary Text**:
  ```dart
  TossTextStyles.body.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: Colors.black87,
  )
  ```
- **Secondary Text**:
  ```dart
  TossTextStyles.caption.copyWith(
    color: Colors.grey[600],
    fontSize: 13,
  )
  ```
- **Label Text**:
  ```dart
  TossTextStyles.body.copyWith(
    fontSize: 15,
  )
  ```

#### Special Text
- **Amount/Currency**:
  ```dart
  TossTextStyles.body.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  )
  ```
- **Error Text**:
  ```dart
  TossTextStyles.caption.copyWith(
    color: const Color(0xFFE53935),
    fontSize: 12,
    fontWeight: FontWeight.w500,
  )
  ```

---

## 🎛️ Components

### 1. Header Component
```dart
Container(
  height: 56,
  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
  child: Row(
    children: [
      IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      Expanded(
        child: Text(
          'Page Title',
          style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(width: 48), // Balance the layout
    ],
  ),
)
```

### 2. Search Bar Component (Standard for All Pages)
```dart
// ⚠️ CRITICAL: Search bar MUST have:
// ✅ WHITE background (Colors.white) - same as cards
// ✅ NO borders or decorations
// ✅ NO gray/colored background
// ✅ Simple icon + text field layout
// ❌ DO NOT add borders, shadows, or colored backgrounds!
Container(
  color: Colors.white, // WHITE background - same as cards below
  padding: EdgeInsets.symmetric(
    horizontal: TossSpacing.space4,
    vertical: TossSpacing.space3,
  ),
  child: Row(
    children: [
      // Search Field - NO BORDER, just icon and text
      Expanded(
        child: Container(
          height: 44,
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.grey[400], // Light gray icon
                size: 20,
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search roles...', // Customize based on context
                    hintStyle: TossTextStyles.body.copyWith(
                      color: Colors.grey[400], // Light gray hint text
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none, // NO BORDER
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TossTextStyles.body.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Optional Add Button (include when needed)
      if (showAddButton) ...[
        TextButton(
          onPressed: onAddPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
          ),
          child: Text(
            'Add',
            style: TossTextStyles.body.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    ],
  ),
)

// Helper method - CLEAN SEARCH BAR WITH WHITE BACKGROUND
Widget _buildSearchBarWithAction({
  required String hintText,
  bool showAddButton = false,
  VoidCallback? onAddPressed,
  Function(String)? onSearchChanged,
}) {
  return Container(
    color: Colors.white, // WHITE background matching cards
    padding: EdgeInsets.symmetric(
      horizontal: TossSpacing.space4,
      vertical: TossSpacing.space3,
    ),
    child: Row(
      children: [
        // Search field with NO borders or background decoration
        Expanded(
          child: Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 20,
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: TextField(
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TossTextStyles.body.copyWith(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none, // NO BORDER
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TossTextStyles.body.copyWith(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Add button when needed
        if (showAddButton) ...[
          TextButton(
            onPressed: onAddPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
            ),
            child: Text(
              'Add',
              style: TossTextStyles.body.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
```

### 3. Tab Bar Component
```dart
TabBar(
  indicatorSize: TabBarIndicatorSize.tab,
  indicator: UnderlineTabIndicator(
    borderSide: BorderSide(
      width: 2.0,
      color: Colors.black87,
    ),
  ),
  labelColor: Colors.black87,
  unselectedLabelColor: Colors.grey[400],
  labelStyle: TossTextStyles.body.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 17,
  ),
  tabs: [...],
)
```

### 4. Grouped Card Container (Multiple Items in One Container)
```dart
// Single container for grouped items - reduces visual separation
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg), // 16px
    boxShadow: TossShadows.cardShadow,
  ),
  child: Column(
    children: [
      // First item
      _buildGroupedListItem(
        icon: Icons.account_balance_wallet,
        title: 'Item 1',
        subtitle: 'Description',
        onTap: () {},
        showDivider: true, // Show divider except for last item
      ),
      // Second item
      _buildGroupedListItem(
        icon: Icons.credit_card,
        title: 'Item 2',
        subtitle: 'Description',
        onTap: () {},
        showDivider: true,
      ),
      // Last item
      _buildGroupedListItem(
        icon: Icons.payment,
        title: 'Item 3',
        subtitle: 'Description',
        onTap: () {},
        showDivider: false, // No divider for last item
      ),
    ],
  ),
)

// Helper method for grouped list items
Widget _buildGroupedListItem({
  required IconData icon,
  required String title,
  String? subtitle,
  required VoidCallback onTap,
  bool showDivider = true,
}) {
  return Column(
    children: [
      InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space4), // 16px padding
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        subtitle,
                        style: TossTextStyles.caption.copyWith(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 22,
              ),
            ],
          ),
        ),
      ),
      if (showDivider)
        Container(
          margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          height: 0.5, // Thinner divider
          color: const Color(0xFFE5E8EB),
        ),
    ],
  );
}
```

### 5. Single Card Container (Standalone Item)
```dart
// For individual items that don't need grouping
Container(
  padding: EdgeInsets.all(TossSpacing.space4), // 16px
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg), // 16px
    boxShadow: TossShadows.cardShadow,
  ),
  child: Row(
    children: [
      // Icon Container
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.icon_name,
          color: Theme.of(context).colorScheme.primary,
          size: 22,
        ),
      ),
      SizedBox(width: TossSpacing.space3),
      // Content
      Expanded(child: ...),
      // Arrow
      Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
        size: 22,
      ),
    ],
  ),
)
```

### 6. Section Header (For Grouped Content)
```dart
// Use this to label groups of cards
Padding(
  padding: EdgeInsets.only(
    left: TossSpacing.space4,
    right: TossSpacing.space4,
    top: TossSpacing.space5,
    bottom: TossSpacing.space3,
  ),
  child: Text(
    'Section Title',
    style: TossTextStyles.body.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 17,
      color: Colors.black87,
    ),
  ),
)
```

### 7. Add Button Component
```dart
Container(
  width: 44,
  height: 44,
  decoration: BoxDecoration(
    color: Colors.grey[100],
    borderRadius: BorderRadius.circular(10),
  ),
  child: Icon(
    Icons.add,
    color: Colors.grey[600],
    size: 24,
  ),
)
```

### 8. Thin Divider (For Use Within Grouped Cards)
```dart
Container(
  margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
  height: 0.5, // Thinner for less visual weight
  color: const Color(0xFFE5E8EB),
)
```

---

## 📐 Layout Patterns

### Page Layout with Grouped Cards
```dart
Scaffold(
  backgroundColor: const Color(0xFFF7F8FA),
  body: SafeArea(
    child: Column(
      children: [
        // Header
        _buildHeader(),
        
        // Search Bar with Add Button (positioned below header)
        _buildSearchBarWithAction(
          hintText: 'Search roles...',
          showAddButton: true, // Set to false if Add button not needed
          onAddPressed: () => _handleAddAction(),
          onSearchChanged: (value) => _handleSearch(value),
        ),
        
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: TossSpacing.space4,
              right: TossSpacing.space4,
              bottom: TossSpacing.space4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // Section 1 - Grouped Items
                Text(
                  'Account Options',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: TossSpacing.space3),
                _buildGroupedCard([
                  // Multiple related items in one container
                  {'icon': Icons.wallet, 'title': 'Wallet', 'subtitle': 'Manage funds'},
                  {'icon': Icons.payment, 'title': 'Payments', 'subtitle': 'Transaction history'},
                  {'icon': Icons.savings, 'title': 'Savings', 'subtitle': 'Goals & targets'},
                ]),
                
                SizedBox(height: TossSpacing.space6),
                
                // Section 2 - Another Group
                Text(
                  'Settings',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: TossSpacing.space3),
                _buildGroupedCard([
                  {'icon': Icons.person, 'title': 'Profile', 'subtitle': 'Personal info'},
                  {'icon': Icons.security, 'title': 'Security', 'subtitle': 'Privacy settings'},
                ]),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
)
```

### Spacing Between Elements
```dart
// Between sections
SizedBox(height: TossSpacing.space6), // 24px

// Between section title and card
SizedBox(height: TossSpacing.space3), // 12px

// Between cards in different groups
SizedBox(height: TossSpacing.space5), // 20px

// Within card items - handled by padding
// No additional spacing needed
```

---

## 🔄 Interaction Patterns

### Touch Targets
- **Minimum Touch Target**: 44x44px
- **List Items**: Full row clickable with `HitTestBehavior.opaque`
- **Navigation**: Always include chevron_right icon for navigable items

### Navigation
```dart
// Push Navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TargetPage(),
  ),
)

// GoRouter Navigation
context.push('/route', extra: data)
```

### Loading States
```dart
const Center(child: CircularProgressIndicator())
```

### Error States
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Error message',
        style: TossTextStyles.body.copyWith(
          color: Colors.grey[500],
        ),
      ),
      // Optional detailed error
      Text(
        'Details',
        style: TossTextStyles.caption.copyWith(
          color: Colors.grey[400],
        ),
      ),
    ],
  ),
)
```

---

## 🎨 Border Radius Standards

Use TossBorderRadius constants:
- **Small Elements**: `TossBorderRadius.xs` (6px)
- **Tags/Chips**: `TossBorderRadius.sm` (8px)
- **Inputs/Small Cards**: `TossBorderRadius.md` (12px)
- **Cards/Containers**: `TossBorderRadius.lg` (16px) - **DEFAULT**
- **Large Cards**: `TossBorderRadius.xl` (20px)
- **Bottom Sheets**: `TossBorderRadius.xxl` (24px)
- **Icon Containers**: `10px` (fixed value)

---

## 🌗 Shadows

Use TossShadows constants:
- **Cards**: `TossShadows.cardShadow`
- **Bottom Sheets**: `TossShadows.bottomSheetShadow`
- **Floating Elements**: `TossShadows.floatingShadow`

---

## 📱 Responsive Design

### Safe Areas
- Always wrap main content in `SafeArea()`
- Use `EdgeInsets.symmetric(horizontal: TossSpacing.space4)` for page margins

### Scrollable Content
```dart
SingleChildScrollView(
  padding: EdgeInsets.all(TossSpacing.space4),
  child: Column(...),
)
```

---

## ✅ Checklist for New Pages

When creating a new page, ensure:

### Layout & Grouping
- [ ] Page background is `#F7F8FA`
- [ ] **Related items are grouped in single containers** (not separate cards)
- [ ] Grouped containers use white background with `TossBorderRadius.lg`
- [ ] Cards have `TossShadows.cardShadow`
- [ ] Use thin dividers (0.5px) between items within groups
- [ ] Section headers label groups of content
- [ ] **Search bar has WHITE background (Colors.white) - NO BORDER**
- [ ] **Search bar is a clean white container with just icon and text**
- [ ] **Search bar is 44px height and positioned below header**
- [ ] **Add button (when needed) is positioned to the right of search bar**

### Components
- [ ] Header is 56px height with centered title
- [ ] Back button uses `Icons.arrow_back_ios` at size 20
- [ ] List items have 44x44px icon containers with 10px border radius
- [ ] Navigation arrows use `Icons.chevron_right` in `Colors.grey[400]`
- [ ] Touch targets are minimum 44x44px

### Colors & Typography
- [ ] Primary text uses `Colors.black87`
- [ ] Secondary text uses `Colors.grey[600]`
- [ ] Error/negative values use `#E53935`
- [ ] Positive/income values use primary color
- [ ] All text styles use TossTextStyles

### Spacing & Formatting
- [ ] All spacing uses TossSpacing constants
- [ ] Padding within grouped cards is `TossSpacing.space4` (16px)
- [ ] Currency formatting uses `NumberFormat('#,###', 'en_US')`

---

## 📋 Import Requirements

Always include these imports for consistent styling:
```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
```

---

## 🔍 Quick Reference

### Color Codes
```dart
// Backgrounds
const Color pageBackground = Color(0xFFF7F8FA);
const Color cardBackground = Colors.white;
const Color searchBarBackground = Colors.white; // WHITE - same as cards, NO BORDER

// Text Colors
const Color textPrimary = Colors.black87;
final Color? textSecondary = Colors.grey[600];
final Color? textDisabled = Colors.grey[400];
final Color? searchHintText = Colors.grey[400]; // Light gray for search placeholder

// Status Colors
const Color errorColor = Color(0xFFE53935);
// Primary color from theme for positive values

// Divider
const Color dividerColor = Color(0xFFE5E8EB);
```

### Common Patterns
1. **Currency Display**: Always format with thousands separator
2. **Percentage Display**: Show as "X% of total"
3. **Error Display**: Show absolute value in red
4. **Navigation**: Always include visual indicator (chevron)
5. **Icons**: Use outlined versions for consistency

### Search Bar Usage Examples
```dart
// 1. Search only (no Add button)
_buildSearchBarWithAction(
  hintText: 'Search transactions...',
  showAddButton: false,
  onSearchChanged: (value) => _filterTransactions(value),
)

// 2. Search with Add button
_buildSearchBarWithAction(
  hintText: 'Search accounts...',
  showAddButton: true,
  onAddPressed: () => _navigateToAddAccount(),
  onSearchChanged: (value) => _filterAccounts(value),
)

// 3. Dynamic hint text based on context
_buildSearchBarWithAction(
  hintText: 'Search ${selectedCategory}...',
  showAddButton: hasAddPermission,
  onAddPressed: hasAddPermission ? () => _handleAdd() : null,
  onSearchChanged: (value) => _performSearch(value),
)
```

---

## 📝 Notes for Developers

### Search Bar Specific Rules
1. **DO NOT** add borders to the search bar
2. **DO NOT** use gray/colored backgrounds for search bar - use WHITE
3. **DO NOT** wrap search bar in cards or containers with shadows
4. **DO NOT** use rounded pill-shaped search fields
5. **ALWAYS** use white background matching the cards
6. **ALWAYS** keep search bar clean with minimal styling

### General Rules
1. **DO NOT** create custom colors - use the defined palette
2. **DO NOT** create custom spacing values - use TossSpacing
3. **DO NOT** create custom text styles - extend TossTextStyles
4. **ALWAYS** test on both iOS and Android
5. **ALWAYS** ensure touch targets are accessible
6. **ALWAYS** use the defined component patterns

This design system ensures visual consistency across all pages of the MyFinance app. Any deviation should be discussed with the team first.