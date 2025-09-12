# 💙 MyFinance - Powered by Toss Design System

> **Modern Financial Management App** with Toss's clean, minimalist design language
> 
> **AI INSTRUCTION**: Start here. This README provides complete project navigation.

---

## 🎨 NEW: Toss Design System Integration

**MyFinance now uses the Toss (토스) Design System** - Korea's leading fintech app design:
- ✨ Clean, minimalist interface
- 🎯 Single-action focus per screen  
- ⚡ 200-250ms smooth animations
- 📐 Strict 4px grid spacing
- 💙 Strategic use of Toss Blue (#0064FF)

**Quick Links:**
- 📖 [Toss Style Guide](/docs/design-system/TOSS_STYLE_GUIDE.md)
- 🎨 [Design Tokens](/lib/core/themes/toss_design_system.dart)
- 🧩 [Component Library](/lib/presentation/widgets/toss/)
- ⚡ [Animation System](/lib/core/themes/toss_animations.dart)

---

## 🎯 What Are You Trying To Do?

```yaml
CREATE_NEW_PAGE:
  read_first: Section 2 (Critical Rules)
  then_go_to: /docs/DOCUMENTATION_INDEX.md → "CREATE A NEW PAGE"

MODIFY_UI:
  read_first: Section 3 (Component Rules)  
  then_go_to: /docs/DOCUMENTATION_INDEX.md → "MODIFY UI/DESIGN"

WORK_WITH_DATA:
  read_first: Section 4 (Data Rules)
  then_go_to: /docs/DOCUMENTATION_INDEX.md → "WORK WITH DATA/BACKEND"

FIX_ROUTES:
  go_directly_to: /docs/DOCUMENTATION_INDEX.md → "FIX ROUTING ISSUES"

UNDERSTAND_PROJECT:
  go_directly_to: /docs/DOCUMENTATION_INDEX.md → "UNDERSTAND THE PROJECT"
```

**📚 COMPLETE DOC MAP**: `/docs/DOCUMENTATION_INDEX.md`

---

## 🔴 2. Critical Project Rules

```yaml
PROJECT:
  location: /Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1
  framework: Flutter 3.0+
  state: Riverpod (NO setState)
  backend: Supabase ONLY (NO local SQL)

SUPABASE:
  project: Lux
  id: atkekzwgukdvucqntryo
  
ROUTES:
  source: Supabase features table
  rule: MUST match in app_router.dart
  convention: camelCase (no 'Page' suffix)
```

---

## 🎨 3. Toss Design System - MANDATORY Usage Rules

```yaml
DESIGN_SYSTEM_ENFORCEMENT:
  rule: "ALWAYS use Toss design tokens - NO exceptions"
  priority: "Consistency > Custom styling"
  validation: "Check existing components before creating new ones"

REQUIRED_COMPONENTS:
  Colors: 
    - ALWAYS: TossColors.primary (never Theme.of(context).colorScheme.primary)
    - Text: TossColors.textPrimary, .textSecondary, .gray900
    - States: TossColors.error, .success, .warning
    - Surfaces: TossColors.surface, .background, .border
  
  Typography:
    - ALWAYS: TossTextStyles.body (14px), .bodyLarge (16px), .h3 (20px)
    - Financial: TossTextStyles.amount, .amountLarge for money display
    - NEVER: Custom fontSize values (no 13px, 15px, 17px etc.)
  
  Spacing:
    - ALWAYS: TossSpacing.space1-space10 (4px grid system)
    - Common: space2 (8px), space3 (12px), space4 (16px), space6 (24px)
    - NEVER: Custom padding/margin values
  
  Animations:
    - ALWAYS: TossAnimations.normal (200ms), .medium (250ms)
    - Curve: TossAnimations.easeCurve (easeInOutCubic)
    - NEVER: Bouncy animations (elasticOut, bounceOut)

MANDATORY_REPLACEMENTS:
  - TextField → TossTextField
  - ElevatedButton → TossPrimaryButton  
  - TextButton → TossSecondaryButton
  - AppBar → TossAppBar
  - Scaffold → TossScaffold
  - showModalBottomSheet → TossBottomSheet.show()
  - Custom checkboxes → TossCheckbox
  - Standard dropdowns → TossDropdown/TossMultiSelectDropdown

COMPONENT_HIERARCHY:
  1. CHECK: /lib/presentation/widgets/toss/ (Toss UI components)
  2. THEN: /lib/presentation/widgets/common/ (layout & states)  
  3. LAST: Create using ONLY Toss design tokens

FINANCIAL_COMPONENTS:
  - TossAccountSelector, TossAccountMultiSelector
  - TossCashLocationSelector, TossCounterPartySelector
  - TossEntitySelector, TossSearchField

STRICT_PROHIBITIONS:
  - Hardcode colors, fonts, spacing, animations
  - Use Theme.of(context).colorScheme.primary (use TossColors.primary)
  - Use custom fontSize values (use TossTextStyles)
  - Create custom TextField/Button when Toss equivalents exist
  - Modify core design system files without approval
  - Break the 4px grid system (TossSpacing only)
  - Use bouncy animations or heavy shadows

AI_INSTRUCTIONS:
  before_coding: "Check /lib/presentation/widgets/toss/ for existing components"
  design_validation: "Ensure ALL styling uses Toss design tokens"
  component_check: "Use Toss components instead of Flutter defaults"
  consistency_rule: "Match existing app patterns and design language"

STYLE_GUIDE: /docs/design-system/TOSS_STYLE_GUIDE.md
```

---

## 💾 4. Data & State Rules

```yaml
STATE_MANAGEMENT:
  type: Riverpod
  app_state: /READMEAppState.md
  
DATABASE:
  type: Supabase PostgreSQL
  schema: /docs/database/SUPABASE_datastructure.md
  
PATTERN:
  UI → Provider → Repository → Supabase
```

---

## 📍 5. Quick References

### Toss Design Values
```yaml
Colors:
  primary: "#0064FF"    # Toss Blue
  success: "#00C896"    # Toss Green
  error: "#FF5847"      # Toss Red
  text: "#212529"       # Primary text
  border: "#E9ECEF"     # Default border

Spacing (4px grid):
  space1: 4px
  space2: 8px
  space3: 12px
  space4: 16px    # Default ⭐
  space6: 24px    # Large ⭐

Border Radius:
  button: 8px
  card: 12px
  input: 8px

Animation:
  normal: 200ms
  medium: 250ms
  curve: easeInOutCubic

Shadow: 0 2px 8px rgba(0,0,0,0.04)
Font: Inter + JetBrains Mono
```

### File Locations
```yaml
Pages: /lib/presentation/pages/[feature]/
Toss Components: /lib/presentation/widgets/toss/
Common Widgets: /lib/presentation/widgets/common/
Themes: /lib/core/themes/
  - toss_colors.dart
  - toss_text_styles.dart
  - toss_spacing.dart
  - toss_animations.dart
  - toss_shadows.dart
  - toss_border_radius.dart
  - toss_design_system.dart
  - app_theme.dart
Services: /lib/data/services/
Router: /lib/presentation/app/app_router.dart
```

---

## ✅ 6. Pre-Task Checklist

```yaml
BEFORE_CREATING_PAGE:
  □ Check /docs/ROUTE_MAPPING_TABLE.md (exists already?)
  □ Check /widgets/toss/ (components exist?)
  □ Read task-specific docs in DOCUMENTATION_INDEX

BEFORE_MODIFYING:
  □ Check COMPONENT_REUSE_GUIDE (use existing?)
  □ Check THEME_SYSTEM (correct values?)
  
BEFORE_ADDING_ROUTE:
  □ Check ROUTE_MAPPING_TABLE (duplicate?)
  □ Add to BOTH Supabase AND router
```

---

## 🚀 7. Commands

```bash
# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

---

## 📂 8. Complete Project Structure

```
myFinance_improved_V1/
│
├── 📱 lib/
│   ├── 🎨 core/
│   │   ├── themes/                    # TOSS DESIGN SYSTEM
│   │   │   ├── toss_colors.dart       # Color palette
│   │   │   ├── toss_text_styles.dart  # Typography
│   │   │   ├── toss_spacing.dart      # 4px grid spacing
│   │   │   ├── toss_animations.dart   # 200-250ms animations
│   │   │   ├── toss_shadows.dart      # Subtle shadows
│   │   │   ├── toss_border_radius.dart # Border radius
│   │   │   ├── toss_design_system.dart # Master reference ⭐
│   │   │   └── app_theme.dart         # Theme configuration
│   │   │
│   │   ├── constants/
│   │   ├── utils/
│   │   └── extensions/
│   │
│   ├── 📊 data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── services/
│   │       └── supabase_service.dart
│   │
│   └── 🖼️ presentation/
│       ├── app/
│       │   └── app_router.dart
│       │
│       ├── pages/                    # Feature pages
│       │   ├── homepage/
│       │   ├── transactions/
│       │   ├── journal_input/
│       │   ├── delegate_role/         # Team roles & permissions
│       │   │   ├── delegate_role_page.dart
│       │   │   │   └── 3-step role creation flow:
│       │   │   │       - Step 1: Role name & description
│       │   │   │       - Step 2: Permission selection
│       │   │   │       - Step 3: Tags (optional)
│       │   │   └── widgets/
│       │   │       └── role_management_sheet.dart
│       │   │           └── Edit role details, permissions, tags
│       │   └── [other_features]/
│       │
│       └── widgets/
│           ├── 💙 toss/              # TOSS COMPONENTS ⭐
│           │   ├── toss_primary_button.dart
│           │   ├── toss_secondary_button.dart
│           │   ├── toss_text_field.dart
│           │   ├── toss_card.dart
│           │   ├── toss_list_tile.dart
│           │   ├── toss_bottom_sheet.dart
│           │   ├── toss_dropdown.dart
│           │   ├── toss_multi_select_dropdown.dart
│           │   ├── toss_checkbox.dart
│           │   ├── toss_chip.dart
│           │   ├── toss_icon_button.dart
│           │   ├── toss_search_field.dart
│           │   ├── toss_loading_overlay.dart
│           │   ├── toss_refresh_indicator.dart
│           │   ├── toss_account_selector.dart
│           │   ├── toss_cash_location_selector.dart
│           │   ├── toss_counter_party_selector.dart
│           │   └── toss_entity_selector.dart
│           │
│           └── common/               # Layout & utility widgets
│               ├── toss_app_bar.dart      # App bar component
│               ├── toss_scaffold.dart     # Scaffold wrapper
│               ├── toss_empty_view.dart   # Empty state
│               ├── toss_error_view.dart   # Error state
│               ├── toss_loading_view.dart # Loading state
│               ├── feature_grid_item.dart
│               └── selector_usage_example.dart
│
├── 📚 docs/
│   ├── DOCUMENTATION_INDEX.md
│   ├── ROUTE_MAPPING_TABLE.md
│   │
│   ├── design-system/
│   │   ├── 🎨 TOSS_STYLE_GUIDE.md   # Complete style guide ⭐
│   │   ├── COMPONENT_REUSE_GUIDE.md
│   │   └── THEME_SYSTEM.md
│   │
│   ├── getting-started/
│   ├── architecture/
│   └── database/
│
├── 🗄️ sql/                          # Database scripts
├── 🧪 test/
├── 📦 pubspec.yaml
└── 📖 README.md                      # You are here!
```

---

## 🚀 9. Quick Start with Toss Design

### Import Toss Design System
```dart
import 'package:myfinance/core/themes/toss_colors.dart';
import 'package:myfinance/core/themes/toss_text_styles.dart';
import 'package:myfinance/core/themes/toss_spacing.dart';
import 'package:myfinance/core/themes/toss_animations.dart';
import 'package:myfinance/core/themes/toss_design_system.dart';
```

### Use Toss Components
```dart
// PRIMARY ACTIONS
TossPrimaryButton(
  text: 'Continue',
  onPressed: () {},
)

TossSecondaryButton(
  text: 'Cancel',
  onPressed: () {},
)

TossIconButton(
  icon: Icons.edit,
  onPressed: () {},
)

// INPUT COMPONENTS
TossTextField(
  label: 'Email',
  onChanged: (value) {},
)

TossSearchField(
  hintText: 'Search transactions...',
  onChanged: (value) {},
)

TossDropdown<String>(
  items: ['Option 1', 'Option 2'],
  onChanged: (value) {},
)

TossCheckbox(
  value: isChecked,
  onChanged: (value) {},
)

// LAYOUT COMPONENTS
TossCard(
  child: Text('Content'),
  onTap: () {},
)

TossListTile(
  title: 'Transaction',
  subtitle: 'Details',
  onTap: () {},
)

// FINANCIAL SELECTORS
TossAccountSelector(
  accounts: accountList,
  onSelected: (account) {},
)

TossCashLocationSelector(
  locations: locationList,
  onSelected: (location) {},
)

TossCounterPartySelector(
  parties: partyList,
  onSelected: (party) {},
)

// MODAL COMPONENTS
TossBottomSheet.show(
  context: context,
  child: MyContent(),
)

// STATE COMPONENTS
TossLoadingOverlay(
  isLoading: isLoading,
  child: MyWidget(),
)
```

### Apply Toss Styling
```dart
Container(
  padding: EdgeInsets.all(TossSpacing.paddingMD),  // 16px
  decoration: BoxDecoration(
    color: TossColors.surface,                     // White
    borderRadius: BorderRadius.circular(
      TossBorderRadius.card,                       // 12px
    ),
    boxShadow: TossShadows.card,                  // Subtle
  ),
  child: Text(
    'Hello',
    style: TossTextStyles.body,                   // 14px/20px
  ),
)
```

---

---

## 📋 Component Usage Guide

### 🎯 Component Selection Priority

**1. Layout & Structure** (check `/lib/presentation/widgets/common/` first):
```dart
TossScaffold(           // Standard page layout
  appBar: TossAppBar(title: 'Page Title'),
  body: content,
)

// State Management
TossLoadingView()       // Loading state
TossErrorView()         // Error state  
TossEmptyView()         // Empty state
```

**2. UI Components** (check `/lib/presentation/widgets/toss/`):
```dart
// For forms and input
TossTextField()         // Text input
TossSearchField()       // Search functionality
TossDropdown()          // Single selection
TossMultiSelectDropdown() // Multiple selection
TossCheckbox()          // Boolean input

// For navigation and actions
TossPrimaryButton()     // Main CTA
TossSecondaryButton()   // Secondary actions
TossIconButton()        // Icon-only actions
TossListTile()          // List navigation

// For financial data
TossAccountSelector()   // Account selection
TossCashLocationSelector() // Location selection
TossCounterPartySelector() // Party selection
```

**3. Financial App Patterns**:
```dart
// Transaction list
TossCard(
  child: TossListTile(
    title: 'Transaction name',
    subtitle: 'Details',
    trailing: TossChip(label: 'Amount'),
  ),
)

// Account selection in forms
TossAccountSelector(
  accounts: accounts,
  selectedAccount: selectedAccount,
  onSelected: (account) => setState(() => selectedAccount = account),
)

// Search functionality
TossSearchField(
  hintText: 'Search transactions...',
  onChanged: (query) => filterTransactions(query),
)
```

---

## 🎨 Color System Guidelines - Big Picture

### **Color Hierarchy & Usage**

```yaml
BACKGROUND_LAYERS:
  scaffold_background: TossColors.gray100    # Main app background (#F1F3F5)
  section_background: TossColors.gray100     # Headers, search bars (same as scaffold)
  card_background: TossColors.surface        # White cards on gray background (#FFFFFF)
  modal_background: TossColors.surface       # Modal/dialog backgrounds
  overlay_background: TossColors.overlay     # Semi-transparent overlays

TEXT_HIERARCHY:
  primary_text: TossColors.textPrimary      # Main content, headings (#212529)
  secondary_text: TossColors.textSecondary  # Descriptions, metadata (#6C757D)
  tertiary_text: TossColors.textTertiary    # Hints, placeholders (#ADB5BD)
  disabled_text: TossColors.textDisabled    # Disabled state (#CED4DA)
  inverse_text: TossColors.textInverse      # Text on dark backgrounds (#FFFFFF)

SEMANTIC_COLORS:
  primary_action: TossColors.primary        # CTAs, links, focus (#0064FF)
  success_state: TossColors.success         # Positive feedback (#00C896)
  error_state: TossColors.error             # Errors, warnings (#FF5847)
  warning_state: TossColors.warning         # Cautions (#FF9500)

BORDER_SYSTEM:
  default_border: TossColors.border         # Standard borders (#E9ECEF)
  light_border: TossColors.borderLight      # Subtle dividers (#F1F3F5)
  dark_border: TossColors.borderDark        # Strong emphasis (#DEE2E6)
```

### **Page Structure Color Pattern**

```yaml
STANDARD_PAGE_LAYOUT:
  1_scaffold:
    background: TossColors.gray100          # Gray background for depth
    
  2_app_bar:
    background: TossColors.gray100          # Same as scaffold (seamless)
    border_bottom: TossColors.borderLight   # Subtle separation
    title: TossColors.textPrimary           # Dark text
    icons: TossColors.textSecondary         # Gray icons
    
  3_search_bar:
    container: TossColors.gray100           # Same as background
    field_background: TossColors.surface    # White input field
    placeholder: TossColors.textTertiary    # Light gray hint text
    
  4_content_cards:
    background: TossColors.surface          # White cards stand out
    border: TossColors.borderLight          # Optional subtle border
    shadow: TossShadows.card                # Subtle elevation
    
  5_list_items:
    background: TossColors.surface          # White background
    divider: TossColors.borderLight         # Between items
    hover: TossColors.surfaceHover          # Interaction feedback
    pressed: TossColors.surfacePressed      # Touch feedback
```

### **Component Color Rules**

```yaml
BUTTONS:
  primary_button:
    background: TossColors.primary          # Blue background
    text: TossColors.textInverse            # White text
    disabled_bg: TossColors.gray200         # Gray when disabled
    disabled_text: TossColors.gray400       # Darker gray text
    
  secondary_button:
    background: TossColors.surface          # White/transparent
    text: TossColors.primary                # Blue text
    border: TossColors.border               # Gray border
    
  text_button:
    background: TossColors.transparent      # No background
    text: TossColors.primary                # Blue text

INPUT_FIELDS:
  background: TossColors.surface            # White background
  border: TossColors.border                 # Default gray border
  focus_border: TossColors.primary          # Blue when focused
  error_border: TossColors.error            # Red for errors
  placeholder: TossColors.textTertiary      # Light gray hints

CARDS_AND_TILES:
  background: TossColors.surface            # White background
  border: TossColors.borderLight            # Optional subtle border
  hover: TossColors.surfaceHover            # Gray tint on hover
  selected: TossColors.primarySurface       # Blue tint when selected

NAVIGATION:
  active_tab: TossColors.primary            # Blue for active
  inactive_tab: TossColors.textTertiary     # Gray for inactive
  tab_indicator: TossColors.primary         # Blue underline/indicator

STATES:
  loading: TossColors.gray100               # Gray skeleton screens
  error: TossColors.errorLight              # Light red background
  success: TossColors.successLight          # Light green background
  warning: TossColors.warningLight          # Light orange background
  info: TossColors.primarySurface           # Light blue background
```

### **Color Usage Best Practices**

```yaml
DO_USE:
  ✅ TossColors.gray100 for all page backgrounds
  ✅ TossColors.surface for content cards and modals
  ✅ TossColors.primary sparingly for key actions only
  ✅ Semantic colors for their intended purpose
  ✅ Text hierarchy colors consistently
  ✅ BorderLight for subtle separations
  
NEVER_USE:
  ❌ Hardcoded hex colors (#FFFFFF, #000000, etc.)
  ❌ Colors.white, Colors.black, Colors.grey directly
  ❌ Multiple shades of blue (only TossColors.primary)
  ❌ Custom opacity values (use predefined colors)
  ❌ Dark backgrounds except for overlays
  ❌ Bright/saturated colors outside the palette

CONSISTENCY_RULES:
  - All pages must have gray100 background
  - All cards must be white (surface) on gray
  - All primary actions must use Toss Blue
  - All text must follow the hierarchy
  - All borders must use defined border colors
  - All states must use semantic colors
```

### **Financial App Specific Patterns**

```yaml
MONEY_DISPLAY:
  positive_amount: TossColors.textPrimary   # Black for normal
  negative_amount: TossColors.error         # Red for negative
  zero_amount: TossColors.textTertiary      # Gray for zero
  
TRANSACTION_STATES:
  pending: TossColors.warning               # Orange
  completed: TossColors.success             # Green
  failed: TossColors.error                  # Red
  cancelled: TossColors.textTertiary        # Gray

ACCOUNT_TYPES:
  asset: TossColors.success                 # Green (positive)
  liability: TossColors.error               # Red (debt)
  income: TossColors.primary                # Blue (earnings)
  expense: TossColors.warning               # Orange (spending)
  equity: TossColors.textPrimary            # Black (neutral)
```

### **Migration Checklist**

```yaml
WHEN_UPDATING_EXISTING_PAGES:
  1. Replace all Colors.* with TossColors.*
  2. Replace all hardcoded hex with named colors
  3. Ensure scaffold uses gray100 background
  4. Ensure cards use surface (white) color
  5. Update all text colors to hierarchy system
  6. Replace custom borders with border system
  7. Update button colors to match patterns
  8. Apply semantic colors for states
  9. Remove all custom opacity/withOpacity calls
  10. Test in light and dark modes
```

---

## ✅ Toss Style Compliance

### **STRICT ADHERENCE** ✅
- 4px grid spacing system (TossSpacing.space4 = 16px default)
- Toss Blue (#0064FF) for primary actions only
- 200-250ms animation timing (TossAnimations.normal/medium)
- Minimal shadows (4-6% opacity max)
- Professional, clean aesthetic
- Single focus per screen

### **COMPONENT BEST PRACTICES** ✅
- Use TossAppBar instead of AppBar
- Use TossScaffold instead of Scaffold
- Use Toss selectors for financial data
- Use TossCard for grouped content
- Use TossBottomSheet for modals
- Use state components (TossLoadingView, etc.)

### **NEVER DO** ❌
- Hardcode colors, spacing, or animations
- Use bouncy animations (elasticOut, bounceOut)
- Create custom components when Toss equivalents exist
- Break the 4px grid system
- Use heavy shadows or effects
- Change core design token values

---

**🎯 AI WORKFLOW**:
1. Always check common/ for layout components first
2. Use toss/ components for UI elements
3. Follow financial app patterns with selectors
4. Maintain Toss design system compliance
5. Use `/docs/design-system/TOSS_STYLE_GUIDE.md` for reference

---

## 🎨 Cash Location ListView Design Pattern

**Adopted by**: Employee Settings, Team Roles (with 3-step role creation), and other list-based pages

### **Design Philosophy**
The Cash Location pattern follows Toss design principles with section-based layouts that eliminate card borders in favor of clean content separation using background colors and spacing.

### **Key Pattern Elements**

```yaml
LAYOUT_STRUCTURE:
  scaffold_background: TossColors.backgroundGray  # Light gray background (#F7F8FA)
  header: Clean header with back button, title, and action button
  content_sections: White rounded containers on gray background
  separation: Spacing between sections instead of borders
  
VISUAL_HIERARCHY:
  background_depth: Gray background provides visual depth
  content_elevation: White sections appear elevated
  clean_separation: No card borders, using color contrast
  rounded_corners: 12px border radius for modern look
  
INTERACTION_PATTERNS:
  header_actions: Add button in top-right for primary actions
  list_items: Individual items with chevron indicators
  tap_targets: Full-width tappable areas
  visual_feedback: Subtle hover/press states
```

### **Implementation Pattern**

#### **1. Page Structure**
```dart
Scaffold(
  backgroundColor: TossColors.backgroundGray,  // Gray background
  body: SafeArea(
    child: Column(
      children: [
        _buildHeader(context),                   // Fixed header
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(TossSpacing.space4),  // 16px padding
            child: Column(
              children: [
                _buildSearchSection(),           // Search & filters
                SizedBox(height: TossSpacing.space4),
                _buildContentSection(data),      // Main content
              ],
            ),
          ),
        ),
      ],
    ),
  ),
)
```

#### **2. Header Component**
```dart
Widget _buildHeader(BuildContext context) {
  return Container(
    height: 56,
    padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
    decoration: BoxDecoration(
      color: TossColors.background,               // White header
      border: Border(
        bottom: BorderSide(
          color: TossColors.gray200,
          width: 0.5,                            // Subtle bottom border
        ),
      ),
    ),
    child: Row(
      children: [
        // Back button
        IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20, color: TossColors.gray900),
          onPressed: () => context.pop(),
        ),
        // Centered title
        Expanded(
          child: Text(
            'Page Title',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Action button
        IconButton(
          icon: Icon(Icons.add, size: 24, color: TossColors.primary),
          onPressed: () => addAction(),
        ),
      ],
    ),
  );
}
```

#### **3. Section Container**
```dart
Widget _buildSection({required String title, required List<Widget> children}) {
  return Container(
    padding: EdgeInsets.all(TossSpacing.space5),     // 20px padding
    decoration: BoxDecoration(
      color: TossColors.surface,                     // White background
      borderRadius: BorderRadius.circular(12),       // Rounded corners
      // NO border or shadow - clean separation through color contrast
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          title,
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: TossColors.gray900,
          ),
        ),
        SizedBox(height: TossSpacing.space3),
        // Section content
        ...children,
      ],
    ),
  );
}
```

#### **4. List Item Pattern**
```dart
Widget _buildListItem({
  required String title,
  String? subtitle,
  Widget? leading,
  Widget? trailing,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),  // 12px vertical
      child: Row(
        children: [
          // Leading icon/image (44x44)
          if (leading != null) ...[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),  // Slightly rounded
              ),
              child: leading,
            ),
            SizedBox(width: TossSpacing.space3),
          ],
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    subtitle,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Trailing content + chevron
          if (trailing != null) trailing,
          SizedBox(width: TossSpacing.space2),
          Icon(
            Icons.chevron_right,
            color: TossColors.gray400,
            size: 20,
          ),
        ],
      ),
    ),
  );
}
```

#### **5. Item Separation**
```dart
// Between list items (instead of dividers)
Container(
  margin: EdgeInsets.symmetric(vertical: TossSpacing.space2),
  height: 0.5,
  color: TossColors.gray200,  // Subtle separator line
),
```

### **Color Usage in Pattern**

```yaml
BACKGROUND_LAYERS:
  scaffold: TossColors.backgroundGray     # Light gray (#F7F8FA)
  sections: TossColors.surface            # Pure white (#FFFFFF)
  header: TossColors.background           # White header
  
VISUAL_SEPARATION:
  section_spacing: TossSpacing.space4     # 16px between sections
  no_borders: Clean separation through color contrast
  subtle_separators: TossColors.gray200 for item dividers
  
INTERACTIVE_ELEMENTS:
  primary_actions: TossColors.primary     # Blue for add buttons
  icons: TossColors.gray600               # Medium gray for icons
  chevrons: TossColors.gray400            # Light gray for navigation
```

### **Benefits of This Pattern**

```yaml
VISUAL_BENEFITS:
  - Clean, modern appearance without visual clutter
  - Better focus on content through color contrast
  - Consistent with Toss minimalist design philosophy
  - Improved visual hierarchy through spacing
  
USABILITY_BENEFITS:
  - Clear section separation without borders
  - Consistent navigation patterns
  - Better touch targets with full-width tappable areas
  - Improved readability with proper contrast
  
MAINTENANCE_BENEFITS:
  - Reusable section and item patterns
  - Consistent styling across similar pages
  - Easy to extend with additional sections
  - Follows established design system tokens
```

### **Implementation Guidelines**

```yaml
WHEN_TO_USE:
  ✅ List-based pages with multiple sections
  ✅ Pages with search/filter functionality
  ✅ Content that needs clear visual grouping
  ✅ Management/settings pages
  
REQUIRED_ELEMENTS:
  ✅ Gray background (backgroundGray)
  ✅ White section containers (surface)
  ✅ 12px rounded corners
  ✅ No borders on section containers
  ✅ Consistent header with back/action buttons
  ✅ 44px leading icons/images
  ✅ Chevron right indicators for navigation
  
AVOID:
  ❌ Card borders or heavy shadows
  ❌ Mixed background colors within sections
  ❌ Inconsistent spacing patterns
  ❌ Missing chevron indicators for navigation
  ❌ Non-standard header layouts
```

---

## 🎨 Team Roles Page - 3-Step Role Creation Flow (Implemented)

**Location**: `/lib/presentation/pages/delegate_role/delegate_role_page.dart`
**Status**: ✅ Fully implemented with tag support

### **Role Creation Modal Structure**

```yaml
3_STEP_FLOW:
  step_1_basic_info:
    - Role Name (required)
    - Description (optional, multiline)
    
  step_2_permissions:
    - Category-based permission selection
    - Expandable categories with checkboxes
    - Select All functionality per category
    - Visual count indicators
    
  step_3_tags:
    - Optional tags for categorization
    - Maximum 5 tags limitation
    - Suggested tags with one-click addition
    - Custom tag validation (2-20 chars)
    - Color-coded tag display

DESIGN_FEATURES:
  - Step indicators with progress visualization
  - Back navigation between steps
  - Validation at each step
  - Clean Toss design system compliance
  - Larger UI elements for better accessibility
  - White modals on gray backgrounds
```

### **Tag System Implementation**

```yaml
TAG_FEATURES:
  validation:
    - Maximum 5 tags per role
    - 2-20 character limit per tag
    - Forbidden characters validation
    - Real-time error feedback
    
  display:
    - Color-coded by tag type (Critical=red, Support=blue, etc.)
    - Chip-style display with remove buttons
    - Overflow handling with "+N" indicator
    - Bullet-separated text display in lists
    
  storage:
    - PostgreSQL JSONB column
    - Array format ["tag1", "tag2"]
    - Database cleanup for legacy data
```

### **Role Management Sheet**

```yaml
FEATURES:
  - Three tabs: Details, Permissions, Members
  - Inline tag editing with validation
  - Permission management by category
  - Member count display
  - Save changes functionality
  - Owner role protection (read-only)
```

---

## 🎨 Default Page Layout Settings

**Standard Page Background Colors** (Applied to all pages):

```yaml
APP_BAR_BACKGROUND:
  color: TossColors.gray100           # #F1F3F5 - Light gray background
  description: "Consistent app bar background across all pages"
  usage: "TossAppBar default background color"

PAGE_BODY_BACKGROUND:  
  color: TossColors.gray100           # #F1F3F5 - Light gray background
  description: "Standard page body background for all screens"
  usage: "TossScaffold backgroundColor property"

DESIGN_CONSISTENCY:
  principle: "App bar and body use identical gray100 background"
  benefit: "Seamless visual flow between header and content"
  implementation: "Hardcoded in TossAppBar component"
```

**Implementation Example**:
```dart
// Standard page structure
TossScaffold(
  backgroundColor: TossColors.gray100,  // Body background
  appBar: TossAppBar(                   // App bar (also gray100 by default)
    title: 'Page Title',
    // ... other properties
  ),
  body: PageContent(),
)
```

**Color Reference**:
- `TossColors.gray100 = Color(0xFFF1F3F5)` - Light gray background
- Applied consistently across Employee Settings, Team Roles, and all other pages
- Creates unified visual experience throughout the application
