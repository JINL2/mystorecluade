# UI/UX Style Guideline - MyFinance Toss Design System

**Version:** 1.0.0
**Last Updated:** December 2025
**Based on:** Toss (토스) Korean Fintech Design Patterns

> 📍 **Location:** All design tokens available in `/lib/shared/themes/`

---

## 📖 Table of Contents

1. [Design Philosophy](#-design-philosophy)
2. [Colors](#-colors)
3. [Typography](#-typography)
4. [Spacing](#-spacing)
5. [Border Radius](#-border-radius)
6. [Shadows](#-shadows)
7. [Animations](#-animations)
8. [Common Components](#-common-components)
9. [Layout Patterns](#-layout-patterns)
10. [Do's and Don'ts](#-dos-and-donts)
11. [Quick Reference](#-quick-reference)
12. [Shared Components](#-shared-components)

---

## 🎯 Design Philosophy

**Core Principles:**

1. ✨ **Minimalist & Clean** - White-dominant with breathing space
2. 🛡️ **Trust & Clarity** - Professional financial interface
3. 🎯 **Single Focus** - One primary action per screen
4. 📏 **Subtle Depth** - Minimal shadows, use borders for definition
5. ⚡ **Smooth Motion** - 200-250ms animations, no bounce
6. 📐 **Consistent Grid** - Strict 4px spacing system
7. 🎨 **Strategic Color** - Blue for CTAs, grayscale for UI

**Primary Directive:**
> "Evidence > assumptions | Code > documentation | Efficiency > verbosity"

---

## 🎨 Colors

**Location:** `/lib/shared/themes/toss_colors.dart`

### Brand Colors

```dart
TossColors.primary       // #0064FF - Toss Blue (CTAs only)
TossColors.primarySurface // #F0F6FF - Blue tinted background
```

### Grayscale Hierarchy

```dart
TossColors.white    // #FFFFFF - Card backgrounds, surfaces
TossColors.gray50   // #F8F9FA - Lightest gray
TossColors.gray100  // #F1F3F5 - Page background (recommended)
TossColors.gray200  // #E9ECEF - Borders, dividers
TossColors.gray300  // #DEE2E6 - Border default
TossColors.gray400  // #CED4DA - Disabled state
TossColors.gray500  // #ADB5BD - Placeholder, secondary labels
TossColors.gray600  // #6C757D - Secondary text
TossColors.gray700  // #495057 - Body text
TossColors.gray800  // #343A40 - Headings
TossColors.gray900  // #212529 - Primary text
```

### Semantic Colors

```dart
// Success (Green)
TossColors.success      // #00C896 - Toss Green
TossColors.successLight // #E3FFF4 - Success background

// Error (Red)
TossColors.error        // #FF5847 - Toss Red
TossColors.errorLight   // #FFEFED - Error background

// Warning (Orange)
TossColors.warning      // #FF9500 - Toss Orange
TossColors.warningLight // #FFF4E6 - Warning background

// Info (Blue)
TossColors.info         // #0064FF - Same as primary
TossColors.infoLight    // #F0F6FF - Info background
```

### Financial Colors

```dart
TossColors.profit  // #00C896 - Positive (green)
TossColors.loss    // #FF5847 - Negative (red)
```

### Surface Colors

```dart
TossColors.background  // #FFFFFF - Main background (white)
TossColors.surface     // #FFFFFF - Card surface (white)
TossColors.border      // #E9ECEF - Default border
TossColors.overlay     // #80000000 - Modal overlay (50% black)
```

### Color Usage Rules

✅ **DO:**
- Use `gray100` or `white` for page backgrounds (visually identical)
- Use `white` for card surfaces
- Use `primary` (#0064FF) **ONLY** for CTAs and important actions
- Use semantic colors for status indicators
- Maintain 4.5:1 contrast ratio for text (WCAG AA)

❌ **DON'T:**
- Don't use multiple bright colors as decoration
- Don't use `primary` as background for large sections
- Don't use colors below gray400 for body text (accessibility)

---

## 📝 Typography

**Location:** `/lib/shared/themes/toss_text_styles.dart`

**Font Families:**
- **Primary:** Inter (Latin), Pretendard (Korean)
- **Monospace:** JetBrains Mono (numbers/amounts)

### Headings

```dart
TossTextStyles.display        // 32px/40px, w800 - Hero sections
TossTextStyles.h1            // 28px/36px, w700 - Page titles
TossTextStyles.h2            // 24px/32px, w700 - Section headers ⭐
TossTextStyles.h3            // 20px/28px, w600 - Subsections ⭐
TossTextStyles.h4            // 18px/24px, w600 - Card titles
TossTextStyles.titleLarge    // 17px/24px, w700 - Major sections
TossTextStyles.titleMedium   // 15px/20px, w700 - Section headers
```

### Body Text

```dart
TossTextStyles.bodyLarge     // 14px/20px, w400 - Default body ⭐
TossTextStyles.bodyMedium    // 14px/20px, w600 - Emphasized text
TossTextStyles.body          // 14px/20px, w400 - Same as bodyLarge
TossTextStyles.bodySmall     // 13px/18px, w600 - Compact text
```

### Labels & UI

```dart
TossTextStyles.button        // 14px/20px, w600 - Button labels
TossTextStyles.labelLarge    // 14px/20px, w500 - Form labels
TossTextStyles.labelMedium   // 12px/16px, w600 - Descriptions
TossTextStyles.label         // 12px/16px, w500 - UI labels
TossTextStyles.labelSmall    // 11px/16px, w600 - Small labels
TossTextStyles.caption       // 12px/16px, w400 - Helper text ⭐
TossTextStyles.small         // 11px/16px, w400 - Tiny text
```

### Financial Numbers

```dart
TossTextStyles.amount        // 20px/24px, w600, JetBrains Mono
```

### Typography Usage

✅ **DO:**
- Use `h2` or `h3` for section headers
- Use `bodyLarge` for default text content
- Use `caption` for secondary/helper text
- Use `amount` for all monetary values
- Maintain 1.4+ line height for readability

❌ **DON'T:**
- Don't use font sizes below 11px
- Don't mix font weights arbitrarily
- Don't use more than 3 font weights on one screen
- Don't use decorative fonts for data

---

## 📐 Spacing

**Location:** `/lib/shared/themes/toss_spacing.dart`

**Philosophy:** Strict 4px grid system - ALL spacing must be multiples of 4px

### Base Spacing (4px Grid)

```dart
TossSpacing.space1  // 4px   - Minimum spacing
TossSpacing.space2  // 8px   - Tight spacing (icon-text gap)
TossSpacing.space3  // 12px  - Small spacing
TossSpacing.space4  // 16px  - Default spacing ⭐
TossSpacing.space5  // 20px  - Medium spacing
TossSpacing.space6  // 24px  - Large spacing ⭐
TossSpacing.space8  // 32px  - Section spacing
TossSpacing.space10 // 40px  - Block spacing
TossSpacing.space12 // 48px  - Container spacing
TossSpacing.space16 // 64px  - Page section spacing
TossSpacing.space20 // 80px  - Major section spacing
```

### Component Spacing

```dart
// Padding (inside components)
TossSpacing.paddingXS  // 8px  - Small buttons, chips
TossSpacing.paddingSM  // 12px - Input fields
TossSpacing.paddingMD  // 16px - Cards, list items ⭐
TossSpacing.paddingLG  // 20px - Sections
TossSpacing.paddingXL  // 24px - Page padding ⭐

// Margins (between components)
TossSpacing.marginXS   // 4px  - Between inline elements
TossSpacing.marginSM   // 8px  - Between related items
TossSpacing.marginMD   // 16px - Between components ⭐
TossSpacing.marginLG   // 24px - Between sections
TossSpacing.marginXL   // 32px - Between major sections

// Gaps (flex layouts)
TossSpacing.gapXS      // 4px  - Icon-text gap
TossSpacing.gapSM      // 8px  - Button content gap
TossSpacing.gapMD      // 12px - Form field gap
TossSpacing.gapLG      // 16px - Card content gap
TossSpacing.gapXL      // 24px - Section gap
```

### Icon & Button Sizes

```dart
// Icons
TossSpacing.iconXS     // 16px
TossSpacing.iconSM     // 20px
TossSpacing.iconMD     // 24px ⭐ (default)
TossSpacing.iconLG     // 32px
TossSpacing.iconXL     // 40px

// Button Heights
TossSpacing.buttonHeightSM  // 32px - Small button
TossSpacing.buttonHeightMD  // 40px - Medium button
TossSpacing.buttonHeightLG  // 48px - Large button ⭐ (default)
TossSpacing.buttonHeightXL  // 56px - Extra large button

// Input Heights
TossSpacing.inputHeightSM   // 36px - Small input
TossSpacing.inputHeightMD   // 44px - Medium input
TossSpacing.inputHeightLG   // 48px - Large input ⭐ (default)
TossSpacing.inputHeightXL   // 56px - Extra large input
```

### Spacing Rules

✅ **DO:**
- Always use multiples of 4px (4, 8, 12, 16, 20, 24, etc.)
- Use `space4` (16px) as default spacing
- Use `space6` (24px) for page padding
- Use `space2` (8px) for icon-text gaps
- Use `space6` (24px) between major sections

❌ **DON'T:**
- Never use arbitrary values like 13px, 22px, 15px
- Don't use spacing smaller than 4px
- Don't mix spacing systems

---

## 🔲 Border Radius

**Location:** `/lib/shared/themes/toss_border_radius.dart`

**Philosophy:** Subtle roundness for approachability while maintaining professionalism

### Radius Values

```dart
TossBorderRadius.none  // 0px   - Sharp corners
TossBorderRadius.xs    // 4px   - Minimal rounding
TossBorderRadius.sm    // 6px   - Small elements (chips)
TossBorderRadius.md    // 8px   - Default radius ⭐
TossBorderRadius.lg    // 12px  - Cards, containers ⭐
TossBorderRadius.xl    // 16px  - Large cards, stat cards
TossBorderRadius.xxl   // 20px  - Bottom sheets
TossBorderRadius.xxxl  // 24px  - Special large elements
TossBorderRadius.full  // 999px - Fully circular
```

### Component-Specific

```dart
// Buttons
TossBorderRadius.button       // 8px  - Standard button ⭐
TossBorderRadius.buttonSmall  // 6px  - Small button
TossBorderRadius.buttonLarge  // 10px - Large button
TossBorderRadius.buttonPill   // 999px - Pill button

// Input Fields
TossBorderRadius.input        // 8px  - Text input ⭐
TossBorderRadius.inputSmall   // 6px  - Small input
TossBorderRadius.inputLarge   // 10px - Large input

// Cards & Containers
TossBorderRadius.card         // 12px - Card radius ⭐
TossBorderRadius.cardSmall    // 8px  - Small card
TossBorderRadius.cardLarge    // 16px - Large card

// Dialogs & Sheets
TossBorderRadius.dialog       // 16px - Dialog/modal
TossBorderRadius.bottomSheet  // 20px - Bottom sheet (top corners)
TossBorderRadius.dropdown     // 8px  - Dropdown menu

// Special Elements
TossBorderRadius.chip         // 6px   - Chip/tag
TossBorderRadius.badge        // 4px   - Badge
TossBorderRadius.avatar       // 999px - Avatar (circular)
TossBorderRadius.thumbnail    // 8px   - Image thumbnail
```

### Border Radius Usage

✅ **DO:**
- Use `lg` (12px) for cards
- Use `xl` (16px) for stat cards and large containers
- Use `md` (8px) for buttons and inputs
- Use `full` (999px) for circular elements

❌ **DON'T:**
- Don't use sharp corners (0px) unless intentional
- Don't mix radius values arbitrarily
- Don't use radius > 24px except for circular elements

---

## 🎭 Shadows

**Location:** `/lib/shared/themes/toss_shadows.dart`

**Philosophy:** Ultra-subtle shadows (2-8% opacity), prefer borders over heavy shadows

### Elevation Levels

```dart
TossShadows.none       // No shadow (flat)
TossShadows.elevation1 // 4% opacity, 0/2/8/0  - Barely visible
TossShadows.elevation2 // 5% opacity, 0/4/12/0 - Subtle lift (hover)
TossShadows.elevation3 // 6% opacity, 0/6/16/0 - Noticeable
TossShadows.elevation4 // 8% opacity, 0/8/24/0 - Prominent
```

### Component Shadows

```dart
TossShadows.card        // 4% opacity, 0/2/8/0  - Default card shadow ⭐
TossShadows.button      // 5% primary color      - Button hover (optional)
TossShadows.dropdown    // 6% opacity, 0/4/16/0 - Dropdowns, menus
TossShadows.bottomSheet // 8% opacity, 0/-4/16/0 - Bottom sheets (upward)
TossShadows.fab         // 10% primary + 5% black - Floating action button
TossShadows.navbar      // 4% opacity, 0/1/4/0  - Navigation bar
```

### Special Effects

```dart
TossShadows.inset  // 4% opacity, inset shadow
TossShadows.glow   // 20% primary, focus glow effect
```

### Shadow Usage

```dart
// Standard card with shadow
Container(
  decoration: BoxDecoration(
    color: TossColors.white,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
    border: Border.all(color: TossColors.border, width: 1),
    boxShadow: TossShadows.card,  // ⭐ Recommended
  ),
)
```

✅ **DO:**
- Use `TossShadows.card` for most cards
- Combine shadows with borders for better definition
- Use subtle shadows (≤8% opacity)
- Use elevation2 for hover states

❌ **DON'T:**
- Don't use heavy shadows (>10% opacity)
- Don't use shadows without borders on white backgrounds
- Don't stack multiple shadow layers

---

## ⚡ Animations

**Location:** `/lib/shared/themes/toss_animations.dart`

**Philosophy:** Smooth, professional, predictable - NO BOUNCE effects

### Duration

```dart
TossAnimations.instant  // 50ms  - Immediate feedback
TossAnimations.quick    // 100ms - Micro-interactions ⭐
TossAnimations.fast     // 150ms - Button presses, hovers
TossAnimations.normal   // 200ms - Default animations ⭐
TossAnimations.medium   // 250ms - Page transitions ⭐
TossAnimations.slow     // 300ms - Complex transitions
TossAnimations.slower   // 400ms - Major scene changes
```

### Curves (NO BOUNCE)

```dart
TossAnimations.standard   // Curves.easeInOutCubic ⭐ (default)
TossAnimations.enter      // Curves.easeOutCubic ⭐ (appearing)
TossAnimations.exit       // Curves.easeInCubic (disappearing)
TossAnimations.emphasis   // Curves.fastOutSlowIn (emphasis)
TossAnimations.decelerate // Curves.easeOut
TossAnimations.linear     // Curves.linear (progress bars)
```

### Common Animation Patterns

```dart
// Button press animation (scale to 95%)
AnimationController _controller = AnimationController(
  duration: TossAnimations.quick,  // 100ms
  vsync: this,
);

Animation<double> _scaleAnimation = Tween<double>(
  begin: 1.0,
  end: 0.95,
).animate(CurvedAnimation(
  parent: _controller,
  curve: TossAnimations.standard,
));

// Usage in widget
Transform.scale(
  scale: _scaleAnimation.value,
  child: widget.child,
)
```

### Animation Rules

✅ **DO:**
- Use 200-250ms for most transitions
- Use `easeInOutCubic` curve as default
- Scale to 95% on button press
- Use 100ms for micro-interactions
- Use fade + slide for page transitions

❌ **DON'T:**
- **NO** bounce or elastic effects (not professional)
- Don't animate longer than 400ms
- Don't use linear curves for UI elements
- Don't animate opacity below 0.3 (accessibility)

---

## 🧩 Common Components

### 1. Stat Card (Hero Stats)

**Visual:** Icon + Label + Large Number + Unit

```dart
Container(
  padding: const EdgeInsets.all(TossSpacing.space4),  // 16px
  decoration: BoxDecoration(
    color: backgroundColor,  // Tinted background (e.g., successLight)
    borderRadius: BorderRadius.circular(TossBorderRadius.xl),  // 16px
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Icon + Label Row
      Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: TossSpacing.space2),  // 8px
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      const SizedBox(height: TossSpacing.space2),  // 8px

      // Value + Unit Row
      Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            value,
            style: TossTextStyles.h2.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: TossSpacing.space1),  // 4px
          Text(
            unit,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    ],
  ),
)
```

**Usage:** Performance metrics, statistics, key numbers

---

### 2. Section Header

**Visual:** Icon + Title with tinted background

```dart
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: TossSpacing.space4,  // 16px
    vertical: TossSpacing.space3,    // 12px
  ),
  decoration: BoxDecoration(
    color: TossColors.primary.withOpacity(0.05),  // 5% blue tint
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),  // 12px
  ),
  child: Row(
    children: [
      Icon(icon, color: TossColors.primary, size: 20),
      const SizedBox(width: TossSpacing.space2),  // 8px
      Expanded(
        child: Text(
          title,
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      if (trailing != null) trailing!,
    ],
  ),
)
```

**Alternative:** Use `TossSectionHeader` widget from `/lib/shared/widgets/common/`

---

### 3. Standard Card

**Visual:** White card with border and subtle shadow

```dart
Container(
  padding: const EdgeInsets.all(TossSpacing.paddingMD),  // 16px
  margin: const EdgeInsets.symmetric(
    horizontal: TossSpacing.marginMD,  // 16px
    vertical: TossSpacing.marginSM,    // 8px
  ),
  decoration: BoxDecoration(
    color: TossColors.white,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),  // 12px
    border: Border.all(color: TossColors.border, width: 1),
    boxShadow: TossShadows.card,
  ),
  child: content,
)
```

**Alternative:** Use `TossCard` widget from `/lib/shared/widgets/toss/`

---

### 4. Primary Button

**Visual:** Blue filled button with white text

```dart
TossButton.primary(
  text: 'Submit',
  onPressed: () {
    // Handle action
  },
  isLoading: false,
  isEnabled: true,
  fullWidth: true,  // Common for CTAs
  leadingIcon: Icon(Icons.check),  // Optional
)
```

**Renders as:**
- Background: `TossColors.primary` (#0064FF)
- Text: `TossColors.white`
- Border radius: 8px
- Height: 48px (from padding)
- Animation: Scale to 95% on press
- Debounced: 300ms protection against rapid taps

---

### 5. Secondary Button

**Visual:** Gray filled button with dark text

```dart
TossButton.secondary(
  text: 'Cancel',
  onPressed: () {
    // Handle action
  },
  isLoading: false,
  isEnabled: true,
)
```

**Renders as:**
- Background: `TossColors.gray100`
- Text: `TossColors.gray900`
- Border radius: 8px
- Height: 48px

---

### 6. List Tile / Row Item

**Visual:** Horizontal layout with icon, text, and trailing element

```dart
Container(
  padding: const EdgeInsets.all(TossSpacing.paddingMD),  // 16px
  decoration: BoxDecoration(
    color: TossColors.white,
    border: Border(
      bottom: BorderSide(color: TossColors.border, width: 1),
    ),
  ),
  child: Row(
    children: [
      // Leading icon/avatar
      Icon(icon, size: TossSpacing.iconMD, color: TossColors.primary),
      const SizedBox(width: TossSpacing.space3),  // 12px

      // Title and subtitle
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TossTextStyles.bodyMedium),
            if (subtitle != null) ...[
              const SizedBox(height: TossSpacing.space1),  // 4px
              Text(
                subtitle,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ],
        ),
      ),

      // Trailing element (arrow, switch, etc.)
      Icon(Icons.chevron_right, size: 20, color: TossColors.gray400),
    ],
  ),
)
```

**Alternative:** Use `TossListTile` widget from `/lib/shared/widgets/toss/`

---

### 7. Bottom Sheet

**Visual:** Modal sheet sliding from bottom with rounded top corners

```dart
showModalBottomSheet(
  context: context,
  backgroundColor: TossColors.transparent,
  isScrollControlled: true,
  builder: (context) => Container(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    decoration: BoxDecoration(
      color: TossColors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(TossBorderRadius.bottomSheet),   // 20px
        topRight: Radius.circular(TossBorderRadius.bottomSheet),  // 20px
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.all(TossSpacing.paddingXL),  // 24px
          child: content,
        ),
      ],
    ),
  ),
);
```

**Alternative:** Use `TossBottomSheet` widget from `/lib/shared/widgets/toss/`

---

### 8. Empty State

**Visual:** Icon + Message + Optional Action

```dart
Center(
  child: Padding(
    padding: const EdgeInsets.all(TossSpacing.paddingXL),  // 24px
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inbox_outlined,
          size: 64,
          color: TossColors.gray300,
        ),
        const SizedBox(height: TossSpacing.space4),  // 16px
        Text(
          'No data available',
          style: TossTextStyles.h4.copyWith(
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),  // 8px
        Text(
          'Try adjusting your filters or create new data',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TossSpacing.space6),  // 24px
        TossButton.primary(
          text: 'Create New',
          onPressed: () {},
        ),
      ],
    ),
  ),
)
```

**Alternative:** Use `TossEmptyView` widget from `/lib/shared/widgets/common/`

---

## 📖 Layout Patterns

### Page Structure

**Standard page layout with gray background and white cards**

```dart
Scaffold(
  backgroundColor: TossColors.gray100,  // Light gray background
  appBar: AppBar(
    backgroundColor: TossColors.white,
    elevation: 0,
    title: Text(
      'Page Title',
      style: TossTextStyles.h3,
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    ),
  ),
  body: SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.paddingXL),  // 24px
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1
          _buildSection1(),
          const SizedBox(height: TossSpacing.space6),  // 24px

          // Section 2
          _buildSection2(),
          const SizedBox(height: TossSpacing.space6),  // 24px

          // Section 3
          _buildSection3(),
        ],
      ),
    ),
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    backgroundColor: TossColors.primary,
    child: const Icon(Icons.add),
  ),
)
```

---

### Card Grid Layout

**2-column grid for stat cards**

```dart
GridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: 2,
  mainAxisSpacing: TossSpacing.space3,   // 12px
  crossAxisSpacing: TossSpacing.space3,  // 12px
  childAspectRatio: 1.5,  // Width/Height ratio
  children: [
    _buildStatCard(
      icon: Icons.access_time,
      iconColor: TossColors.primary,
      backgroundColor: TossColors.primarySurface,
      label: 'Hours',
      value: '40',
      unit: 'hrs',
    ),
    _buildStatCard(
      icon: Icons.check_circle,
      iconColor: TossColors.success,
      backgroundColor: TossColors.successLight,
      label: 'Completed',
      value: '8',
      unit: 'tasks',
    ),
    // More cards...
  ],
)
```

---

### List Layout

**Vertical list with dividers**

```dart
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => Divider(
    height: 1,
    thickness: 0.5,
    color: TossColors.border,
  ),
  itemBuilder: (context, index) {
    final item = items[index];
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),  // 16px
      color: TossColors.white,
      child: Row(
        children: [
          // Item content
        ],
      ),
    );
  },
)
```

---

### Tab Layout

**Tabbed interface with segmented control**

```dart
Column(
  children: [
    // Tab Bar
    TossSegmentedControl(
      segments: ['Tab 1', 'Tab 2', 'Tab 3'],
      selectedIndex: selectedTab,
      onChanged: (index) {
        setState(() => selectedTab = index);
      },
    ),
    const SizedBox(height: TossSpacing.space4),  // 16px

    // Tab Content
    Expanded(
      child: IndexedStack(
        index: selectedTab,
        children: [
          _buildTab1(),
          _buildTab2(),
          _buildTab3(),
        ],
      ),
    ),
  ],
)
```

---

### Form Layout

**Standard form with labels and inputs**

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Field 1
    Text(
      'Label',
      style: TossTextStyles.labelLarge.copyWith(
        color: TossColors.gray700,
      ),
    ),
    const SizedBox(height: TossSpacing.space2),  // 8px
    TossTextField(
      controller: controller1,
      hintText: 'Enter value',
    ),
    const SizedBox(height: TossSpacing.space4),  // 16px

    // Field 2
    Text(
      'Label',
      style: TossTextStyles.labelLarge.copyWith(
        color: TossColors.gray700,
      ),
    ),
    const SizedBox(height: TossSpacing.space2),  // 8px
    TossTextField(
      controller: controller2,
      hintText: 'Enter value',
    ),
    const SizedBox(height: TossSpacing.space6),  // 24px

    // Submit Button
    TossButton.primary(
      text: 'Submit',
      onPressed: _handleSubmit,
      fullWidth: true,
    ),
  ],
)
```

---

## ✅ Do's and Don'ts

### Colors

✅ **DO:**
- Use `gray100` or `white` for page backgrounds
- Use `white` for card surfaces
- Use `primary` (#0064FF) only for CTAs
- Use semantic colors for status (success, error, warning)
- Maintain 4.5:1 contrast for text

❌ **DON'T:**
- Don't use multiple bright colors as decoration
- Don't use `primary` as large section background
- Don't use low contrast text (gray400 on white)
- Don't use custom colors outside design system

---

### Spacing

✅ **DO:**
- Always use 4px multiples (4, 8, 12, 16, 20, 24...)
- Use `space4` (16px) as default
- Use `space6` (24px) for page padding
- Use `space2` (8px) for icon-text gaps
- Use `space6` (24px) between major sections

❌ **DON'T:**
- Don't use arbitrary values (13px, 22px, 15px)
- Don't use spacing smaller than 4px
- Don't inconsistently space similar elements
- Don't cram content without breathing room

---

### Typography

✅ **DO:**
- Use `h2` or `h3` for section headers
- Use `bodyLarge` for default text
- Use `caption` for secondary info
- Use `amount` for monetary values
- Maintain consistent font weights per context

❌ **DON'T:**
- Don't use font sizes below 11px
- Don't mix more than 3 font weights per screen
- Don't use decorative fonts for data
- Don't use all caps for long text

---

### Borders & Shadows

✅ **DO:**
- Use 1px borders with `TossColors.border`
- Use `TossShadows.card` for subtle depth
- Combine borders + shadows for cards
- Use `borderRadius.lg` (12px) for cards

❌ **DON'T:**
- Don't use heavy shadows (>10% opacity)
- Don't skip borders on white backgrounds
- Don't use inconsistent border radius
- Don't overuse shadows

---

### Animations

✅ **DO:**
- Use 200-250ms for transitions
- Use `easeInOutCubic` curve
- Scale to 95% on button press
- Provide immediate feedback (50-100ms)

❌ **DON'T:**
- **NO** bounce or elastic effects
- Don't animate longer than 400ms
- Don't use linear curves for UI
- Don't animate critical data changes

---

### Components

✅ **DO:**
- Use shared components from `/lib/shared/`
- Follow component composition patterns
- Maintain consistent component styling
- Test on different screen sizes

❌ **DON'T:**
- Don't create duplicate components
- Don't hardcode styles in widgets
- Don't ignore responsive design
- Don't skip accessibility considerations

---

## 🚀 Quick Reference Cheat Sheet

### Page Setup

```dart
Scaffold(
  backgroundColor: TossColors.gray100,  // or TossColors.white
  appBar: AppBar(
    backgroundColor: TossColors.white,
    elevation: 0,
  ),
  body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(TossSpacing.paddingXL),  // 24px
      child: content,
    ),
  ),
)
```

---

### Card

```dart
Container(
  padding: const EdgeInsets.all(TossSpacing.paddingMD),  // 16px
  decoration: BoxDecoration(
    color: TossColors.white,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),  // 12px
    border: Border.all(color: TossColors.border, width: 1),
    boxShadow: TossShadows.card,
  ),
)
```

---

### Spacing Between Sections

```dart
const SizedBox(height: TossSpacing.space6)  // 24px
```

---

### Section Header

```dart
Text(
  'Section Title',
  style: TossTextStyles.h3.copyWith(
    color: TossColors.gray900,
    fontWeight: FontWeight.w700,
  ),
)
```

---

### Body Text

```dart
Text(
  'Body content',
  style: TossTextStyles.bodyLarge.copyWith(
    color: TossColors.gray700,
  ),
)
```

---

### Secondary Text

```dart
Text(
  'Helper text',
  style: TossTextStyles.caption.copyWith(
    color: TossColors.gray500,
  ),
)
```

---

### Icon Size

```dart
Icon(
  Icons.check,
  size: TossSpacing.iconMD,  // 24px
  color: TossColors.primary,
)
```

---

### Button

```dart
TossButton.primary(
  text: 'Action',
  onPressed: () {},
  fullWidth: true,
)
```

---

### Animation

```dart
AnimationController(
  duration: TossAnimations.normal,  // 200ms
  vsync: this,
)

// With curve
CurvedAnimation(
  parent: controller,
  curve: TossAnimations.standard,  // easeInOutCubic
)
```

---

## 📦 Shared Components Library

**Location:** `/lib/shared/widgets/`

### Buttons

```dart
// Primary CTA
TossButton.primary(text: 'Submit', onPressed: () {})

// Secondary action
TossButton.secondary(text: 'Cancel', onPressed: () {})

// Icon button
TossIconButton(icon: Icons.settings, onPressed: () {})
```

---

### Cards

```dart
// Animated card with tap feedback
TossCard(
  onTap: () {},
  child: content,
)

// Simple white card
TossWhiteCard(child: content)
```

---

### Headers & Sections

```dart
// Section header with icon
TossSectionHeader(
  title: 'Section Title',
  icon: Icons.star,
  trailing: actionWidget,
)
```

---

### Inputs

```dart
// Text input
TossTextField(
  controller: controller,
  hintText: 'Enter value',
  labelText: 'Label',
)

// Quantity input with +/- buttons
TossQuantityInput(
  value: quantity,
  onChanged: (newValue) {},
  minValue: 0,
  maxValue: 999,
)

// Search field
TossSearchField(
  controller: controller,
  hintText: 'Search...',
  onChanged: (value) {},
)
```

---

### Navigation

```dart
// Week navigation
TossWeekNavigation(
  currentWeek: selectedWeek,
  onWeekChanged: (week) {},
)

// Month navigation
TossMonthNavigation(
  currentMonth: selectedMonth,
  onMonthChanged: (month) {},
)

// Segmented control (tabs)
TossSegmentedControl(
  segments: ['Tab 1', 'Tab 2', 'Tab 3'],
  selectedIndex: currentTab,
  onChanged: (index) {},
)
```

---

### Modals & Sheets

```dart
// Bottom sheet
showTossBottomSheet(
  context: context,
  builder: (context) => content,
)

// Calendar picker
showTossCalendarBottomSheet(
  context: context,
  initialDate: DateTime.now(),
  onDateSelected: (date) {},
)

// Confirm/Cancel dialog
showTossConfirmCancelDialog(
  context: context,
  title: 'Confirm Action',
  message: 'Are you sure?',
  onConfirm: () {},
)

// Success/Error dialog
showTossSuccessErrorDialog(
  context: context,
  isSuccess: true,
  message: 'Operation completed',
)
```

---

### Lists & Display

```dart
// List tile
TossListTile(
  leading: Icon(Icons.person),
  title: 'Title',
  subtitle: 'Subtitle',
  trailing: Icon(Icons.chevron_right),
  onTap: () {},
)

// Empty state
TossEmptyView(
  icon: Icons.inbox,
  title: 'No Data',
  message: 'Try adjusting filters',
  actionText: 'Create New',
  onAction: () {},
)

// Error state
TossErrorView(
  message: 'Something went wrong',
  onRetry: () {},
)

// Loading state
TossLoadingView()
```

---

### Badges & Chips

```dart
// Badge
TossBadge(
  text: 'New',
  color: TossColors.error,
)

// Chip
TossChip(
  label: 'Category',
  onTap: () {},
  selected: false,
)

// Category chip
CategoryChip(
  label: 'Filter',
  isSelected: true,
  onTap: () {},
)
```

---

### Specialized Components

```dart
// Month calendar
TossMonthCalendar(
  selectedDate: DateTime.now(),
  onDateSelected: (date) {},
  markedDates: [date1, date2],
)

// Week shift card
TossWeekShiftCard(
  shifts: weekShifts,
  onShiftTap: (shift) {},
)

// Dropdown
TossDropdown(
  items: ['Option 1', 'Option 2'],
  value: selectedOption,
  onChanged: (value) {},
)

// Expandable card
TossExpandableCard(
  title: 'Expandable Section',
  children: [child1, child2],
)
```

---

## 📚 Additional Resources

### Design System Files

- **Colors:** `/lib/shared/themes/toss_colors.dart`
- **Typography:** `/lib/shared/themes/toss_text_styles.dart`
- **Spacing:** `/lib/shared/themes/toss_spacing.dart`
- **Border Radius:** `/lib/shared/themes/toss_border_radius.dart`
- **Shadows:** `/lib/shared/themes/toss_shadows.dart`
- **Animations:** `/lib/shared/themes/toss_animations.dart`
- **Icons:** `/lib/shared/themes/toss_icons.dart`
- **Master System:** `/lib/shared/themes/toss_design_system.dart`

### Component Libraries

- **Toss Components:** `/lib/shared/widgets/toss/`
- **Common Components:** `/lib/shared/widgets/common/`
- **Selectors:** `/lib/shared/widgets/selectors/`

### Reference Implementations

- **Attendance:** `/lib/features/attendance/presentation/`
- **Cash Ending:** `/lib/features/cash_ending/presentation/`
- **Time Table:** `/lib/features/time_table_manage/presentation/`
- **Employee Settings:** `/lib/features/employee_setting/presentation/`

---

## 🎓 Best Practices Summary

1. **Always use design tokens** - Never hardcode colors, spacing, or typography
2. **Follow 4px grid** - All spacing must be multiples of 4px
3. **Strategic color use** - Blue (#0064FF) only for CTAs
4. **Consistent patterns** - Reuse shared components
5. **Subtle animations** - 200-250ms, no bounce
6. **Minimal shadows** - Prefer borders for definition
7. **Accessibility first** - Maintain contrast, touch targets ≥44px
8. **Responsive design** - Test on multiple screen sizes
9. **Performance** - Optimize images, minimize rebuilds
10. **Documentation** - Comment complex patterns

---

**Last Updated:** December 2025
**Maintained by:** MyFinance Development Team
**Questions?** Refer to `/lib/shared/themes/toss_design_system.dart` for implementation details
for large section, use toss_spacing_6
