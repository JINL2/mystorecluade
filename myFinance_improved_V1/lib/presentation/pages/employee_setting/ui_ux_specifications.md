# Employee Setting UI/UX Specifications

## Layout Structure

### Page Hierarchy
```
TossScaffold
├── TossAppBar
│   ├── Back Button
│   ├── Title: "Employee Setting"
│   └── Actions: Sync Button
├── Search Section
│   └── TossSearchField
└── Employee List
    ├── Loading View
    ├── Empty View
    ├── Error View
    └── Employee Cards (ListView)
```

## Component Specifications

### 1. App Bar
**Component**: `TossAppBar`
- **Height**: 56px
- **Background**: TossColors.background
- **Shadow**: TossShadows.shadow1
- **Elements**:
  - Back icon: Icons.arrow_back_ios (20px)
  - Title: TossTextStyles.h3
  - Sync icon: Icons.sync with rotation animation

### 2. Search Section
**Component**: `TossSearchField`
- **Margin**: TossSpacing.space5 (20px all sides)
- **Height**: 48px
- **Properties**:
  ```dart
  hintText: "Search employees by name or role"
  prefixIcon: Icons.search
  borderRadius: TossBorderRadius.md (12px)
  debounceDelay: 300ms
  ```

### 3. Employee Card
**Component**: `EmployeeCard`
- **Height**: 72px
- **Margin**: Horizontal 20px, Vertical 6px
- **Border Radius**: TossBorderRadius.md (12px)
- **Background**: TossColors.surface
- **Shadow**: TossShadows.shadow1
- **Padding**: 12px all sides

#### Card Layout (Row):
```
[Avatar] [Employee Info] [Salary] [Edit Icon]
  40px      Expanded       Auto     32px
```

#### Sub-components:
1. **Avatar**
   - Size: 40x40px
   - Border radius: Circular
   - Placeholder: Person icon on gray100 background

2. **Employee Info** (Column)
   - Name: TossTextStyles.titleSmall (w500)
   - Role: TossTextStyles.labelMedium (primary color)
   - Spacing: 4px between elements

3. **Salary Display**
   - Style: TossTextStyles.bodyMedium
   - Format: "{amount}{symbol}"
   - Text align: Right

4. **Edit Button**
   - Icon: Icons.edit_outlined
   - Size: 24px
   - Color: TossColors.primary
   - Tap area: 44x44px (accessibility)

### 4. Loading States
**Component**: `TossLoadingView`
- Circular progress indicator
- Color: TossColors.primary
- Optional message below

### 5. Empty State
**Component**: `TossEmptyView`
- Icon: Icons.people_outline (48px, gray400)
- Title: "No employees found"
- Description: "Add employees to manage their salaries"
- Action button: "Add Employee" (if permitted)

### 6. Error State
**Component**: `TossErrorView`
- Icon: Icons.error_outline (48px, error color)
- Title: "Something went wrong"
- Description: Error message
- Retry button: "Try Again"

## Salary Edit Modal

### Modal Structure
**Component**: `TossBottomSheet`
- **Border Radius**: Top 24px
- **Max Height**: 80% of screen
- **Padding**: 24px top, 16px horizontal

### Form Fields

1. **Salary Type Dropdown**
   ```dart
   TossDropdown(
     label: "Salary Type",
     options: ["Monthly", "Hourly"],
     value: currentType,
   )
   ```

2. **Currency Dropdown**
   ```dart
   TossDropdown(
     label: "Currency",
     options: currencyList,
     value: currentCurrency,
     showFlag: true,
   )
   ```

3. **Salary Amount Field**
   ```dart
   TossTextField(
     label: "Salary Amount",
     keyboardType: TextInputType.numberWithOptions(decimal: true),
     inputFormatters: [DecimalTextInputFormatter()],
     prefixText: selectedCurrencySymbol,
   )
   ```

4. **Action Buttons**
   ```dart
   Row(
     children: [
       Expanded(
         child: TossButton.secondary(
           text: "Cancel",
           onPressed: () => Navigator.pop(context),
         ),
       ),
       SizedBox(width: 12),
       Expanded(
         child: TossButton.primary(
           text: "Update",
           onPressed: _updateSalary,
         ),
       ),
     ],
   )
   ```

## Animations & Transitions

### Page Transitions
- **Entry**: Slide from right (iOS) / Fade up (Android)
- **Exit**: Slide to right (iOS) / Fade down (Android)
- **Duration**: 300ms with ease-in-out

### List Animations
- **Initial Load**: Staggered fade in (50ms delay per item)
- **Search Results**: Fade transition (200ms)
- **Pull to Refresh**: Toss-style elastic bounce

### Micro-interactions
- **Card Tap**: Scale down to 0.98 with shadow reduction
- **Edit Button**: Rotate 15° on tap
- **Sync Icon**: Continuous rotation when syncing
- **Success Feedback**: Green checkmark animation

## Responsive Design

### Mobile (Default)
- Single column layout
- Full-width cards with 20px margins
- Bottom sheet for editing

### Tablet (>600px)
- Optional: 2-column grid for employee cards
- Side panel for editing (instead of bottom sheet)
- Increased spacing between elements

### Desktop (>1024px)
- 3-column grid for employee cards
- Inline editing in expanded card
- Fixed search bar at top

## Touch Targets & Accessibility

### Minimum Sizes
- Buttons: 44x44px
- Cards: Full width, 72px height
- Dropdowns: 48px height
- Text fields: 48px height

### Focus Indicators
- Border: 2px solid TossColors.primary
- Border radius: Matches component
- Animation: Fade in 150ms

### Screen Reader Labels
```dart
Semantics(
  label: "${employee.name}, ${employee.role}, salary ${employee.salary}",
  hint: "Tap to edit salary",
  child: EmployeeCard(...),
)
```

## Performance Optimizations

### Image Loading
```dart
CachedNetworkImage(
  imageUrl: employee.profileUrl,
  placeholder: CircularProgressIndicator(),
  errorWidget: Icon(Icons.person),
  fadeInDuration: Duration(milliseconds: 200),
)
```

### List Performance
```dart
ListView.builder(
  itemCount: employees.length,
  cacheExtent: 1000, // Pre-render buffer
  itemBuilder: (context, index) => EmployeeCard(
    key: ValueKey(employees[index].id),
    employee: employees[index],
  ),
)
```

## Color Scheme

### Light Mode
- Background: #FFFFFF
- Surface: #FBFBFB
- Primary: #0066FF
- Text Primary: #171717
- Text Secondary: #737373
- Divider: #E5E5E5

### Dark Mode (Future)
- Background: #000000
- Surface: #1A1A1A
- Primary: #4D94FF
- Text Primary: #FFFFFF
- Text Secondary: #A3A3A3
- Divider: #262626

## Typography Scale

| Element | Style | Size | Weight | Color |
|---------|-------|------|--------|-------|
| Page Title | h3 | 20px | 600 | gray900 |
| Employee Name | titleSmall | 16px | 500 | gray900 |
| Role | labelMedium | 13px | 400 | primary |
| Salary | bodyMedium | 15px | 400 | gray900 |
| Search Hint | body | 15px | 400 | gray500 |
| Button Text | body | 15px | 500 | white/primary |

## Spacing Guidelines

- **Page Padding**: 20px horizontal
- **Section Spacing**: 24px
- **Card Spacing**: 12px
- **Internal Card Padding**: 12px
- **Form Field Spacing**: 16px
- **Button Spacing**: 12px