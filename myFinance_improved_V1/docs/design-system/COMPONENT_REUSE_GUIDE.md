# 🎨 Component Reuse Guide - Achieving Design Coherency

> **PURPOSE**: Ensure UI consistency by reusing existing components. NEVER create custom components without checking this guide first.

---

## 🎯 Why Component Reuse Matters

```yaml
BENEFITS:
  - Consistent user experience across all pages
  - Reduced development time (use, don't build)
  - Unified design language (Toss-style)
  - Easier maintenance (fix once, apply everywhere)
  - Smaller bundle size (no duplicate components)

PHILOSOPHY:
  "Every UI element should look and behave the same way everywhere in the app"
```

---

## 📊 Component Selection Flowchart

```
Need a UI Component?
        ↓
[1] Check /widgets/toss/ 
    Found? → USE IT (don't modify)
        ↓ Not found?
[2] Check /widgets/common/
    Found? → USE IT (don't modify)
        ↓ Not found?
[3] Can you compose from existing?
    Yes? → COMBINE existing components
        ↓ No?
[4] Is it feature-specific?
    Yes? → Create in /widgets/specific/[feature]/
        ↓ No?
[5] Will other features use it?
    Yes? → Create in /widgets/common/ (get approval first)
    No? → Reconsider if really needed
```

---

## 🏗 Toss Component Library

### Available Components & When to Use

#### 1. **TossPrimaryButton** 
```dart
// Location: /widgets/toss/toss_primary_button.dart
// Use for: Main CTA on any page
// DON'T: Create custom primary buttons

USAGE:
TossPrimaryButton(
  text: '다음',  // Korean text
  onPressed: () {},
  isEnabled: true,
)

WHEN_TO_USE:
- Submit forms
- Primary actions
- Navigation to next step
```

#### 2. **TossCard**
```dart
// Location: /widgets/toss/toss_card.dart
// Use for: Any card-based content
// DON'T: Create custom cards with shadows

USAGE:
TossCard(
  child: YourContent(),
  onTap: () {},  // Optional
  padding: EdgeInsets.all(TossSpacing.space4),
)

WHEN_TO_USE:
- List items
- Information cards
- Clickable containers
```

#### 3. **TossBottomSheet**
```dart
// Location: /widgets/toss/toss_bottom_sheet.dart
// Use for: All bottom sheets/modals
// DON'T: Use Material BottomSheet directly

USAGE:
TossBottomSheet.show(
  context: context,
  title: 'Select Option',
  child: YourContent(),
)

WHEN_TO_USE:
- Action menus
- Forms in modal
- Confirmations
```

#### 4. **TossTextField**
```dart
// Location: /widgets/toss/toss_text_field.dart
// Use for: ALL text inputs
// DON'T: Use Material TextField directly

USAGE:
TossTextField(
  label: '이름',
  controller: _controller,
  validator: (value) => validation,
)

WHEN_TO_USE:
- Form inputs
- Search fields
- Any text entry
```

#### 5. **TossDropdown**
```dart
// Location: /widgets/toss/toss_dropdown.dart
// Use for: Selection from options
// DON'T: Create custom dropdowns

USAGE:
TossDropdown<String>(
  label: '선택',
  value: selected,
  items: options,
  onChanged: (value) {},
)
```

#### 6. **TossCheckbox**
```dart
// Location: /widgets/toss/toss_checkbox.dart
// Use for: Boolean selections
// DON'T: Use Material Checkbox directly

USAGE:
TossCheckbox(
  value: isChecked,
  onChanged: (value) {},
  label: '동의합니다',
)
```

#### 7. **TossSearchField**
```dart
// Location: /widgets/toss/toss_search_field.dart
// Use for: Search functionality
// DON'T: Create custom search bars

USAGE:
TossSearchField(
  onSearch: (query) {},
  placeholder: '검색',
)
```

#### 8. **TossLoadingOverlay**
```dart
// Location: /widgets/toss/toss_loading_overlay.dart
// Use for: Loading states
// DON'T: Use CircularProgressIndicator directly

USAGE:
TossLoadingOverlay(
  isLoading: true,
  child: YourContent(),
)
```

---

## 🎨 Theme Constants Usage

### NEVER hardcode values. ALWAYS use theme constants:

#### Colors
```dart
// ❌ WRONG
Container(color: Color(0xFF5B5FCF))

// ✅ CORRECT
Container(color: TossColors.primary)

AVAILABLE_COLORS:
- TossColors.primary      // Main brand color
- TossColors.error        // Error states
- TossColors.success      // Success states
- TossColors.gray50-900   // Gray scale
- TossColors.background   // Page background
- TossColors.surface      // Card background
```

#### Spacing
```dart
// ❌ WRONG
SizedBox(height: 16)
Padding(padding: EdgeInsets.all(20))

// ✅ CORRECT
SizedBox(height: TossSpacing.space4)  // 16px
Padding(padding: EdgeInsets.all(TossSpacing.space5))  // 20px

SPACING_SCALE:
- space1: 4px   // Tiny gaps
- space2: 8px   // Small gaps
- space3: 12px  // Medium gaps
- space4: 16px  // Default padding
- space5: 20px  // Large gaps
- space6: 24px  // Section spacing
- space8: 32px  // Page sections
```

#### Typography
```dart
// ❌ WRONG
Text('Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))

// ✅ CORRECT
Text('Title', style: TossTextStyles.h2)

TEXT_STYLES:
- TossTextStyles.h1      // Page titles
- TossTextStyles.h2      // Section headers
- TossTextStyles.h3      // Subsections
- TossTextStyles.body    // Normal text
- TossTextStyles.caption // Small text
```

#### Shadows
```dart
// ❌ WRONG
BoxShadow(color: Colors.black.withOpacity(0.1), ...)

// ✅ CORRECT
decoration: BoxDecoration(
  boxShadow: TossShadows.small,  // 2% opacity
)

SHADOW_TYPES:
- TossShadows.small   // Cards, buttons
- TossShadows.medium  // Elevated cards
- TossShadows.large   // Modals, sheets
```

---

## 🔄 Common Composition Patterns

### Pattern 1: List Page
```dart
// Compose from existing components
TossScaffold(
  title: 'List Title',
  body: ListView.builder(
    itemBuilder: (context, index) => TossCard(
      child: ListItemContent(),
    ),
  ),
)
```

### Pattern 2: Form Page
```dart
// Compose from existing components
TossScaffold(
  title: 'Form Title',
  body: Column(
    children: [
      TossTextField(label: 'Field 1'),
      TossTextField(label: 'Field 2'),
      TossDropdown(label: 'Selection'),
      TossPrimaryButton(text: '제출'),
    ],
  ),
)
```

### Pattern 3: Detail Page
```dart
// Compose from existing components
TossScaffold(
  title: 'Detail',
  body: Column(
    children: [
      TossCard(child: MainInfo()),
      TossCard(child: SubInfo()),
      TossPrimaryButton(text: '수정'),
    ],
  ),
)
```

---

## 📋 Component Creation Checklist

Before creating ANY new component:

```yaml
□ Did I check /widgets/toss/?
□ Did I check /widgets/common/?
□ Can I compose from existing components?
□ Is this truly feature-specific?
□ Will other features need this?
□ Am I using TossColors (not custom colors)?
□ Am I using TossSpacing (not hardcoded)?
□ Am I using TossTextStyles (not custom)?
□ Does it follow Toss design principles?
```

---

## 🚫 Common Mistakes to Avoid

```yaml
MISTAKE_1:
  wrong: Creating custom button when TossPrimaryButton exists
  right: Use TossPrimaryButton with different text

MISTAKE_2:
  wrong: Hardcoding color values (#5B5FCF)
  right: Use TossColors.primary

MISTAKE_3:
  wrong: Creating new card with custom shadow
  right: Use TossCard component

MISTAKE_4:
  wrong: Using Material widgets directly
  right: Use Toss wrapper components

MISTAKE_5:
  wrong: Custom spacing values (padding: 15)
  right: Use TossSpacing constants
```

---

## 🎯 Decision Tree for Edge Cases

```
Q: Component exists but needs slight modification?
A: Use as-is. Design consistency > perfect fit

Q: Need a very specific feature-only widget?
A: Create in /widgets/specific/[feature]/

Q: Component might be useful elsewhere?
A: Create in /widgets/common/ with team approval

Q: Not sure if component exists?
A: Search by functionality, not by name
   Example: Need a selection? Check dropdown, picker, selector
```

---

## 📚 Related Documentation

- Component Catalog: `/docs/components/TOSS_COMPONENT_LIBRARY.md`
- Theme System: `/docs/design-system/THEME_SYSTEM.md`
- Design Principles: `/docs/design-system/TOSS_STYLE_ANALYSIS.md`

---

**REMEMBER**: Consistency > Customization. A slightly imperfect but consistent UI is better than a perfect but inconsistent one.