# Toss Design System Guide

This document outlines the design system used in the myStore web application, based on Toss Korean fintech app's design patterns.

## Design Philosophy

**Core Principles:**
- Minimalist white-dominant interface
- Strategic use of Toss Blue (#0064FF)
- High contrast for financial clarity
- Trust through consistency
- Clean, modern aesthetic with illustrative icons

## Typography

### Font Families

```css
Primary: 'Inter' - Used for all UI text
Korean: 'Pretendard' - Korean text support and financial numbers
```

**Font Imports:**
```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
@import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');
```

**Note:** Pretendard is used for both Korean text and financial numbers to maintain consistency with Toss app's proportional font design philosophy for financial data display.

### Font Sizes

| Usage | Size | Variable |
|-------|------|----------|
| Display | 32px | `--font-display` |
| H1 (Page Title) | 28px | `--font-h1` |
| H2 (Section Title) | 24px | `--font-h2` |
| H3 (Subsection) | 20px | `--font-h3` |
| H4 (Label Group) | 18px | `--font-h4` |
| Body Large | 16px | `--font-body-large` |
| Body (Default) | 14px | `--font-body` |
| Body Small | 13px | `--font-body-small` |
| Label | 12px | `--font-label` |
| Small | 11px | `--font-small` |

### Font Weights

| Weight | Value | Variable | When to Use |
|--------|-------|----------|-------------|
| Regular | 400 | `--font-regular` | Body text, descriptions |
| Medium | 500 | `--font-medium` | Labels, secondary emphasis |
| Semibold | 600 | `--font-semibold` | Buttons, important labels |
| Bold | 700 | `--font-bold` | Page titles (H1, H2), emphasis |
| Extrabold | 800 | `--font-extrabold` | Display text, hero sections |

### Typography Usage Examples (Invoice Page)

**Page Title:**
```css
font-size: 32px;
font-weight: 700; /* Bold */
color: var(--color-gray-900);
```

**Subtitle:**
```css
font-size: 16px;
font-weight: 400; /* Regular */
color: var(--color-gray-600);
```

**Table Headers:**
```css
font-size: 12px;
font-weight: 600; /* Semibold */
color: #6c757d;
letter-spacing: 0.5px;
text-transform: uppercase;
```

**Invoice Number (Primary Data):**
```css
font-size: 14px;
font-weight: 700; /* Bold */
color: #212529;
```

**Secondary Data (Dates, Descriptions):**
```css
font-size: 14px;
font-weight: 400; /* Regular */
color: #6c757d;
```

**Modal Title:**
```css
font-size: 24px;
font-weight: 700; /* Bold */
color: #212529;
```

**Section Headers:**
```css
font-size: 12px;
font-weight: 600; /* Semibold */
text-transform: uppercase;
letter-spacing: 0.5px;
color: #6c757d;
```

**Financial Amounts:**
```css
font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;
font-size: 28px;
font-weight: 700; /* Bold */
color: #212529;
```

## Colors

### Brand Colors

```css
Toss Blue (Primary):        #0064FF
Toss Blue Light (Hover):    #4D94FF
Toss Blue Dark (Pressed):   #0050CC
Toss Blue Surface (BG):     #F0F6FF
```

### Grayscale

```css
White:          #FFFFFF
Gray 50:        #F8F9FA  /* Lightest gray, section backgrounds */
Gray 100:       #F1F3F5  /* Background */
Gray 200:       #E9ECEF  /* Light borders */
Gray 300:       #DEE2E6  /* Default borders */
Gray 400:       #CED4DA  /* Disabled states */
Gray 500:       #ADB5BD  /* Placeholders */
Gray 600:       #6C757D  /* Secondary text */
Gray 700:       #495057  /* Body text */
Gray 800:       #343A40  /* Headings */
Gray 900:       #212529  /* Primary text */
Black:          #000000
Dark Gray:      #202632  /* Toss secondary */
```

### Semantic Colors

```css
Success (Toss Green):       #00C896
Success Light:              #E3FFF4
Success Dark:               #00A67E

Error (Toss Red):           #FF5847
Error Light:                #FFEFED
Error Dark:                 #E63E2C

Warning (Toss Orange):      #FF9500
Warning Light:              #FFF4E6
Warning Dark:               #E68600

Info (Toss Blue):           #0064FF
Info Light:                 #F0F6FF
```

### Financial Colors

```css
Profit (Positive):          #00C896  /* Green */
Loss (Negative):            #FF5847  /* Red */
Neutral (No Change):        #6C757D  /* Gray */
```

### Text Colors

```css
Primary Text:               #212529  /* Main text */
Secondary Text:             #6C757D  /* Secondary info */
Tertiary Text:              #ADB5BD  /* Hint text */
Disabled Text:              #CED4DA  /* Disabled */
Inverse Text:               #FFFFFF  /* On dark backgrounds */
Link Text:                  #0064FF  /* Links */
```

## Buttons

### TossButton Component

**Path:** `/src/shared/components/toss/TossButton/TossButton.tsx`

**Import:**
```typescript
import { TossButton } from '@/shared/components/toss/TossButton';
```

### Button Variants

| Variant | Background | Text Color | Border | Usage |
|---------|------------|------------|--------|-------|
| `primary` | #0064FF | White | #0064FF | Primary actions |
| `secondary` | White | #212529 | rgba(0,0,0,0.1) | Secondary actions |
| `outline` | Transparent | #0064FF | #E9ECEF | Alternative actions |
| `ghost` | Transparent | #212529 | Transparent | Subtle actions |
| `text` | Transparent | #0064FF | Transparent | Text-only actions |
| `success` | #00C896 | White | #00C896 | Success confirmations |
| `error` | #FF5847 | White | #FF5847 | Destructive actions |
| `warning` | #FF9500 | #212529 | #FF9500 | Warning actions |
| `info` | #0064FF | White | #0064FF | Informational actions |

### Button Sizes

| Size | Height | Padding | Font Size |
|------|--------|---------|-----------|
| `sm` | 32px | 8px 12px | 12px |
| `md` | 40px | 12px 20px | 14px |
| `lg` | 48px | 16px 24px | 16px |
| `xl` | 56px | 20px 32px | 18px |

### Button Usage Examples (Invoice Page)

**Primary Action Button:**
```tsx
<TossButton variant="primary" size="md">
  <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style={{ marginRight: '8px' }}>
    <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
  </svg>
  New Invoice
</TossButton>
```

**Secondary Action Button:**
```tsx
<TossButton variant="secondary" size="md">
  <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style={{ marginRight: '8px' }}>
    <path d="M14,13V17H10V13H7L12,8L17,13M19.35,10.03C18.67,6.59 15.64,4 12,4C9.11,4 6.6,5.64 5.35,8.03C2.34,8.36 0,10.9 0,14A6,6 0 0,0 6,20H19A5,5 0 0,0 24,15C24,12.36 21.95,10.22 19.35,10.03Z"/>
  </svg>
  Export
</TossButton>
```

**Error/Refund Button:**
```tsx
<TossButton
  variant="error"
  size="md"
  onClick={handleRefund}
  disabled={refunding}
  loading={refunding}
>
  {refunding ? 'Refunding...' : 'Refund Invoice'}
</TossButton>
```

**Pagination Button:**
```tsx
<TossButton
  variant="secondary"
  size="sm"
  onClick={() => changePage(currentPage + 1)}
  disabled={!pagination.has_next}
>
  Next
</TossButton>
```

### Custom Button Styling

The `TossButton` component supports `customStyles` prop for advanced customization:

```tsx
<TossButton
  variant="primary"
  customStyles={{
    backgroundColor: '#FF5847',
    color: '#FFFFFF',
    borderRadius: '12px',
    padding: '16px 24px',
  }}
>
  Custom Styled Button
</TossButton>
```

## Icons

### Icon System Overview

Our project uses **two icon systems**:

1. **Material Design Icons** (16-24px): UI elements like buttons, tables, input fields
2. **Toss Style Illustrations** (64-120px): Empty states, large feedback screens

### 1. Material Design Icons (UI Elements)

**Usage:** All common UI elements including buttons, table actions, navigation, input fields

**Characteristics:**
- Monochrome (fill="currentColor")
- Simple path-based design
- Fast rendering
- Consistent style

**Path:** Inline SVG paths in components

**Icon Sizes & Usage:**

| Size | Usage | Example |
|------|-------|---------|
| 16px | Inline with small text, chips | Table row icons |
| 18px | Button icons (md size) | Primary/Secondary buttons |
| 20px | Table action buttons | View, Edit, Delete |
| 24px | Modal headers, large buttons | Close button, Menu icons |

**Common Material Design Icons Used:**

**Search Icon:**
```tsx
<svg className={styles.searchIcon} viewBox="0 0 24 24" fill="currentColor">
  <path d="M9.5,3A6.5,6.5 0 0,1 16,9.5C16,11.11 15.41,12.59 14.44,13.73L14.71,14H15.5L20.5,19L19,20.5L14,15.5V14.71L13.73,14.44C12.59,15.41 11.11,16 9.5,16A6.5,6.5 0 0,1 3,9.5A6.5,6.5 0 0,1 9.5,3M9.5,5C7,5 5,7 5,9.5C5,12 7,14 9.5,14C12,14 14,12 14,9.5C14,7 12,5 9.5,5Z"/>
</svg>
```

**Add/Plus Icon:**
```tsx
<svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
  <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
</svg>
```

**Close Icon:**
```tsx
<svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
  <path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"/>
</svg>
```

**View/Eye Icon:**
```tsx
<svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
  <path d="M12,9A3,3 0 0,0 9,12A3,3 0 0,0 12,15A3,3 0 0,0 15,12A3,3 0 0,0 12,9M12,17A5,5 0 0,1 7,12A5,5 0 0,1 12,7A5,5 0 0,1 17,12A5,5 0 0,1 12,17M12,4.5C7,4.5 2.73,7.61 1,12C2.73,16.39 7,19.5 12,19.5C17,19.5 21.27,16.39 23,12C21.27,7.61 17,4.5 12,4.5Z"/>
</svg>
```

**Edit/Pencil Icon:**
```tsx
<svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
  <path d="M20.71,7.04C21.1,6.65 21.1,6 20.71,5.63L18.37,3.29C18,2.9 17.35,2.9 16.96,3.29L15.12,5.12L18.87,8.87M3,17.25V21H6.75L17.81,9.93L14.06,6.18L3,17.25Z"/>
</svg>
```

### 2. Toss Style Illustrations (Empty States Only)

**⚠️ Important:** This style is **ONLY used for large feedback screens** such as Empty States, error screens, and success feedback. Do NOT use for buttons or tables!

**Usage:**
- Empty states (when no data is available)
- Error screens (when errors occur)
- Success screens (when operations complete)
- Onboarding illustrations

**Characteristics:**
- Large size (64px - 120px)
- Uses 2-3 colors
- Smooth curves and rounded corners
- Circular background or gradients
- Toss Blue (#0064FF) + Light Blue (#F0F6FF) combination

**Invoice Page Empty State Example:**
```tsx
<div className={styles.emptyState}>
  <svg className={styles.emptyIcon} width="120" height="120" viewBox="0 0 120 120" fill="none">
    {/* Background Circle */}
    <circle cx="60" cy="60" r="50" fill="#F0F6FF"/>

    {/* Document Stack */}
    <rect x="35" y="40" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>
    <rect x="40" y="35" width="50" height="60" rx="4" fill="white" stroke="#0064FF" strokeWidth="2"/>

    {/* Document Lines */}
    <line x1="48" y1="45" x2="75" y2="45" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
    <line x1="48" y1="52" x2="70" y2="52" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>
    <line x1="48" y1="59" x2="72" y2="59" stroke="#E9ECEF" strokeWidth="2" strokeLinecap="round"/>

    {/* Invoice Symbol */}
    <circle cx="60" cy="75" r="12" fill="#0064FF"/>
    <path d="M56 75 L58 77 L64 71" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
  </svg>
  <h3 className={styles.emptyTitle}>No Invoices</h3>
  <p className={styles.emptyText}>No invoice records found for the selected period</p>
</div>
```

**CSS for Empty State Icon:**
```css
.emptyIcon {
  width: 120px;
  height: 120px;
  margin: 0 auto 24px;
  display: block;
}
```

### Icon Selection Guide

**When adding icons to buttons:**
```tsx
{/* ✅ Correct usage - Material Design Icon 18px */}
<TossButton variant="primary" size="md">
  <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
    <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z"/>
  </svg>
  New Invoice
</TossButton>

{/* ❌ Incorrect usage - Toss Illustration cannot be used in buttons */}
<TossButton variant="primary" size="md">
  <svg width="120" height="120" viewBox="0 0 120 120">
    {/* Complex illustration */}
  </svg>
  Button
</TossButton>
```

**When designing Empty States:**
```tsx
{/* ✅ Correct usage - Toss Style Illustration 120px */}
<div className={styles.emptyState}>
  <svg width="120" height="120" viewBox="0 0 120 120">
    {/* Toss style illustration */}
  </svg>
  <h3>No Data</h3>
</div>

{/* ❌ Incorrect usage - Material Icon is too small */}
<div className={styles.emptyState}>
  <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
    <path d="..."/>
  </svg>
  <h3>No Data</h3>
</div>
```

## Spacing

### 4px Grid System

All spacing follows a 4px baseline grid:

```css
--space-0: 0px
--space-1: 4px
--space-2: 8px
--space-3: 12px
--space-4: 16px
--space-5: 20px
--space-6: 24px
--space-8: 32px
--space-10: 40px
--space-12: 48px
--space-16: 64px
--space-20: 80px
```

### Component Spacing

```css
Padding XS:     8px
Padding SM:     12px
Padding MD:     16px
Padding LG:     20px
Padding XL:     24px

Margin XS:      4px
Margin SM:      8px
Margin MD:      16px
Margin LG:      24px
Margin XL:      32px

Gap XS:         4px
Gap SM:         8px
Gap MD:         12px
Gap LG:         16px
Gap XL:         24px
```

### Screen Padding (DEPRECATED - DO NOT USE)

⚠️ **WARNING: This old padding system is DEPRECATED and causes issues when developer console is open.**

```css
❌ DEPRECATED - DO NOT USE THESE VALUES:
Mobile:         16px
Tablet:         24px
Desktop:        32px
```

**Use the new responsive padding system below instead.**

---

### Page Layout with Horizontal Padding (UPDATED STANDARD)

**⭐ ALL PAGES MUST FOLLOW THIS RESPONSIVE PADDING SYSTEM:**

This responsive padding system ensures optimal space usage across all screen sizes, preventing content from being cut off when developer tools or console are open.

**IMPORTANT: Copy this EXACT CSS code to your page:**

```css
/* ⭐ STEP 1: Create .pageLayout wrapper (NOT .container) */
.pageLayout {
  min-height: 100vh;
  background: var(--color-gray-50);
  padding: 0 24px; /* ⭐ DEFAULT: 24px horizontal padding */
  max-width: 100%; /* ⭐ IMPORTANT: 100% not 1400px or 1920px */
  margin: 0 auto;
}

/* ⭐ STEP 2: Add responsive padding media queries */
/* Wider screens - increase padding */
@media (min-width: 1600px) {
  .pageLayout {
    padding: 0 48px; /* ⭐ Increase to 48px on wide screens */
  }
}

/* Extra wide screens - maximum padding with width constraint */
@media (min-width: 2000px) {
  .pageLayout {
    padding: 0 96px; /* ⭐ Maximum 96px on ultra-wide screens */
    max-width: 1920px; /* ⭐ Cap width at 1920px */
  }
}

/* Mobile - reduce padding */
@media (max-width: 768px) {
  .pageLayout {
    padding: 0 16px; /* ⭐ Reduce to 16px on mobile */
  }
}

/* ⭐ STEP 3: Inner container (optional, for content max-width) */
.container {
  padding: 24px 0; /* ⭐ VERTICAL ONLY - no horizontal padding */
  max-width: 100%; /* ⭐ IMPORTANT: Use 100% to match Navbar alignment */
  width: 100%;
}
```

**❌ COMMON MISTAKES TO AVOID:**
```css
/* ❌ WRONG - Fixed padding in .container */
.container {
  padding: 32px; /* This will cause issues! */
}

/* ❌ WRONG - Missing media queries */
.container {
  padding: 0 24px; /* No responsive adjustments! */
}

/* ❌ WRONG - Wrong max-width location */
.pageLayout {
  max-width: 1920px; /* Should be 100% by default! */
}

/* ❌ WRONG - Using old class name */
.container {
  padding: 0 24px; /* Should be .pageLayout! */
}

/* ❌ WRONG - Content width constraint in .container */
.container {
  max-width: 1400px; /* This creates extra margins! Use 100% instead */
  margin: 0 auto;     /* This centers content and breaks Navbar alignment */
}
```

**Padding Strategy:**
- **Default (< 1600px)**: 24px - Optimal for most screens, prevents cutting when console is open
- **Wide (1600px+)**: 48px - More breathing room on larger displays
- **Ultra-wide (2000px+)**: 96px with 1920px max-width - Premium spacing for very large screens
- **Mobile (≤ 768px)**: 16px - Minimal padding for small screens

**Key Benefits:**
✅ Console/DevTools-friendly - Content doesn't get cut off
✅ Responsive across all screen sizes
✅ Consistent spacing throughout the application
✅ Optimal use of available screen space
✅ Perfect alignment with Navbar - No extra margins

**Why `max-width: 100%` in `.container`?**

If you use `max-width: 1400px` in `.container`:
- ❌ Content becomes **centered** on screens wider than 1400px
- ❌ **Extra margins appear** on left and right sides
- ❌ **Navbar and page content misalign** (Navbar stays full-width)
- ❌ Inconsistent layout across different pages

If you use `max-width: 100%` in `.container`:
- ✅ Content uses **full available width** within `.pageLayout` padding
- ✅ **No extra margins** - clean edge-to-edge alignment
- ✅ **Perfect alignment** with Navbar on all screen sizes
- ✅ Consistent layout matching Inventory page reference

### Page Layout with Sidebar (Example: Inventory Page)

**Structure for pages with sidebar:**
```css
/* Page Layout Container */
.pageLayout {
  display: flex;
  min-height: 100vh;
  background: var(--color-gray-50);
  padding: 0 24px; /* Use responsive padding system above */
  max-width: 100%;
  margin: 0 auto;
}

/* Sidebar Wrapper */
.sidebarWrapper {
  flex-shrink: 0;
  margin-right: 24px; /* Gap between sidebar and content */
}

/* Sidebar Component */
Sidebar Width:  240px
Position:       sticky
Top:            64px (below navbar)

/* Main Content Area */
.mainContent {
  flex: 1;
  min-width: 0; /* Allow content to shrink */
  overflow-x: hidden;
}

/* Content Container */
.container {
  padding: 24px 0; /* Vertical only, no horizontal padding */
  width: 100%;
  max-width: 100%;
}
```

**Visual Layout Structure:**
```
┌─────────────────────────────────────────────────────────────┐
│ [24px padding]                                 [24px padding]│
│                                                               │
│  ┌──────────┐  ┌─────────────────────────────────────────┐  │
│  │ Sidebar  │  │         Main Content                    │  │
│  │ (240px)  │  │         (flex: 1)                       │  │
│  │          │  │                                         │  │
│  └──────────┘  └─────────────────────────────────────────┘  │
│      ↑ 24px gap                                              │
└─────────────────────────────────────────────────────────────┘
```

**Mobile Responsive (≤768px):**
```css
.pageLayout {
  padding: 0 16px; /* Reduced padding on mobile */
}

.sidebarWrapper {
  display: none; /* Hide sidebar on mobile */
}

.mobileFilterWrapper {
  display: block; /* Show mobile filter dropdown instead */
}
```

## Border Radius

```css
None:           0px
XS:             4px   /* Badges */
SM:             6px   /* Chips */
MD:             8px   /* Buttons, Inputs */
LG:             12px  /* Cards */
XL:             16px  /* Modals */
XXL:            20px  /* Bottom Sheets */
XXXL:           24px  /* Large Cards */
Full:           999px /* Circular */
```

### Component Radius

```css
Button:         8px
Input:          8px
Card:           12px
Dialog:         16px
Bottom Sheet:   20px
Chip:           6px
Badge:          4px
```

## Shadows

```css
None:           none
Level 1:        0 2px 8px rgba(0, 0, 0, 0.04)   /* Subtle */
Level 2:        0 4px 12px rgba(0, 0, 0, 0.05)  /* Cards */
Level 3:        0 6px 16px rgba(0, 0, 0, 0.06)  /* Dropdowns */
Level 4:        0 8px 24px rgba(0, 0, 0, 0.08)  /* Modals */
```

### Component Shadows

```css
Card:           0 2px 8px rgba(0, 0, 0, 0.04)
Button:         0 2px 8px rgba(0, 100, 255, 0.05)
Dropdown:       0 4px 16px rgba(0, 0, 0, 0.06)
Modal:          0 8px 24px rgba(0, 0, 0, 0.08)
Navbar:         0 1px 4px rgba(0, 0, 0, 0.04)
```

## Other Shared Components

### StoreSelector

**Path:** `/src/shared/components/selectors/StoreSelector/StoreSelector.tsx`

```tsx
import { StoreSelector } from '@/shared/components/selectors/StoreSelector';

<StoreSelector
  stores={stores}
  selectedStoreId={selectedStoreId}
  onStoreSelect={handleStoreChange}
  companyId={companyId}
  width="280px"
/>
```

### TossInput

**Path:** `/src/shared/components/toss/TossInput/TossInput.tsx`

```tsx
import { TossInput } from '@/shared/components/toss/TossInput';

<TossInput
  type="text"
  placeholder="Search..."
  value={value}
  onChange={(e) => setValue(e.target.value)}
/>
```

### Navbar

**Path:** `/src/shared/components/common/Navbar/Navbar.tsx`

```tsx
import { Navbar } from '@/shared/components/common/Navbar';

<Navbar activeItem="product" />
```

## Layout Patterns

### Page Container Standard (UPDATED - MANDATORY)

**⚠️ DEPRECATED: Old fixed padding system**

The old fixed padding system (32px padding with 1400px max-width) has been replaced with a responsive padding system. Please migrate to the new system above.

**New Responsive System (REQUIRED):**

All feature pages MUST use the responsive padding system defined in "Page Layout with Horizontal Padding" section above.

**For pages WITHOUT sidebar (standard pages):**
```css
.pageLayout {
  min-height: 100vh;
  background: var(--color-gray-50);
  padding: 0 24px; /* Responsive padding - see media queries above */
  max-width: 100%;
  margin: 0 auto;
}

.container {
  padding: 24px 0; /* Vertical padding only */
  max-width: 100%; /* ⭐ IMPORTANT: Use 100% to align with Navbar */
  width: 100%;
}
```

**For pages WITH sidebar (e.g., Inventory):**
```css
.pageLayout {
  display: flex;
  min-height: 100vh;
  background: var(--color-gray-50);
  padding: 0 24px; /* Responsive padding - see media queries above */
  max-width: 100%;
  margin: 0 auto;
}
```

**Migration Status:**
- ✅ Inventory Page - Updated with responsive padding + max-width: 100% (REFERENCE THIS)
- ✅ Invoice Page - Updated with responsive padding + max-width: 100%
- ✅ Navbar - Updated with responsive padding (24px → 48px → 96px)
- ⏳ Account Mapping Page - Check max-width setting
- ⏳ Balance Sheet Page - Needs migration
- ⏳ Journal Input Page - Needs migration
- ⏳ All other pages - Needs migration and max-width verification

**⚠️ IMPORTANT CHECKLIST before implementing:**
1. [ ] Use `.pageLayout` as the outer wrapper (NOT `.container`)
2. [ ] Set `padding: 0 24px` in `.pageLayout` (NOT in `.container`)
3. [ ] Set `max-width: 100%` in `.pageLayout` (NOT 1920px or 1400px)
4. [ ] Add ALL THREE media queries (1600px, 2000px, 768px)
5. [ ] Inner `.container` should have `padding: 24px 0` (vertical only)
6. [ ] **CRITICAL**: Inner `.container` must have `max-width: 100%` (NOT 1400px)
7. [ ] Update your JSX to wrap content with `<div className={styles.pageLayout}>`

**Responsive Breakpoints (Apply to .pageLayout):**
```css
/* Default (< 1600px) */
.pageLayout {
  padding: 0 24px;
}

/* Wide screens (1600px+) */
@media (min-width: 1600px) {
  .pageLayout {
    padding: 0 48px;
  }
}

/* Ultra-wide screens (2000px+) */
@media (min-width: 2000px) {
  .pageLayout {
    padding: 0 96px;
    max-width: 1920px;
  }
}

/* Mobile (≤ 768px) */
@media (max-width: 768px) {
  .pageLayout {
    padding: 0 16px;
  }
}
```

**Implementation Example:**

**❌ WRONG - Like Account Mapping Page (DO NOT COPY THIS):**
```css
.container {
  padding: 32px; /* ❌ Fixed horizontal padding - causes cut-off issues */
  max-width: 1400px;
  margin: 0 auto;
}

/* Only mobile media query, missing 1600px and 2000px */
@media (max-width: 768px) {
  .container {
    padding: 16px; /* ❌ Not responsive enough */
  }
}
```

**✅ CORRECT - Like Inventory Page (COPY THIS PATTERN):**
```css
/* Step 1: Outer wrapper with responsive padding */
.pageLayout {
  padding: 0 24px; /* ✅ Horizontal padding only */
  max-width: 100%; /* ✅ Full width by default */
  margin: 0 auto;
  min-height: 100vh;
  background: var(--color-gray-50);
}

/* Step 2: Inner container for content width (optional) */
.container {
  padding: 24px 0; /* ✅ Vertical padding only */
  max-width: 100%; /* ✅ IMPORTANT: Use 100% to align with Navbar */
  width: 100%;
}

/* Step 3: ALL THREE media queries are REQUIRED */
@media (min-width: 1600px) {
  .pageLayout {
    padding: 0 48px; /* ✅ Increase on wide screens */
  }
}

@media (min-width: 2000px) {
  .pageLayout {
    padding: 0 96px; /* ✅ Max padding */
    max-width: 1920px; /* ✅ Cap width on ultra-wide */
  }
}

@media (max-width: 768px) {
  .pageLayout {
    padding: 0 16px; /* ✅ Reduce on mobile */
  }
}
```

**JSX Structure:**
```tsx
// ❌ WRONG
<div className={styles.container}>
  <Navbar />
  {/* content */}
</div>

// ✅ CORRECT
<>
  <Navbar />
  <div className={styles.pageLayout}>
    <div className={styles.container}>
      {/* content */}
    </div>
  </div>
</>
```

### Page Header

```css
.header {
  margin-bottom: 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 16px;
}

.title {
  font-size: 32px;
  font-weight: 700;
  color: var(--color-gray-900);
}

.subtitle {
  font-size: 16px;
  color: var(--color-gray-600);
}
```

### Cards/Sections

```css
.card {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  margin-bottom: 20px;
  border: 1px solid rgba(0, 0, 0, 0.06);
}
```

### Tables

```css
.table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.table thead {
  background: #f8f9fa;
  border-bottom: 1px solid #dee2e6;
}

.table thead th {
  padding: 16px 20px;
  text-align: left;
  font-size: 12px;
  font-weight: 600;
  color: #6c757d;
  letter-spacing: 0.5px;
  text-transform: uppercase;
}

.table tbody td {
  padding: 20px;
  border-bottom: 1px solid #f0f0f0;
  color: #212529;
}

.table tbody tr:hover {
  background-color: #f8f9fa;
}
```

### Modals

```css
.modalOverlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: fadeIn 0.2s ease;
}

.modalContent {
  background: white;
  border-radius: 16px;
  width: 95%;
  max-width: 1200px;
  max-height: 90vh;
  overflow: hidden;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
  animation: slideUp 0.3s ease;
}

.modalHeader {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  padding: 24px;
  border-bottom: 1px solid #f0f0f0;
}
```

## Responsive Design

### Breakpoints

```css
Mobile:         < 768px
Tablet:         768px - 1024px
Desktop:        > 1024px
```

### Mobile-First Approach

Always design for mobile first, then add tablet and desktop enhancements:

```css
/* Mobile (default) */
.container {
  padding: 16px;
}

/* Tablet */
@media (min-width: 768px) {
  .container {
    padding: 24px;
  }
}

/* Desktop */
@media (min-width: 1024px) {
  .container {
    padding: 32px;
  }
}
```

## Animations & Transitions

### Timing

```css
Fast:           150ms ease
Base:           250ms ease
Slow:           350ms ease
```

### Common Animations

**Fade In:**
```css
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
```

**Slide Up:**
```css
@keyframes slideUp {
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}
```

**Pulse:**
```css
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
```

## Accessibility

### Focus States

All interactive elements should have clear focus indicators:

```css
:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 100, 255, 0.15);
}
```

### Color Contrast

- Text on white: Minimum #6C757D (AA compliant)
- Primary text: #212529 (AAA compliant)
- Links: #0064FF (AA compliant)

### ARIA Labels

Always include proper ARIA labels for screen readers:

```tsx
<button aria-label="Close modal" onClick={handleClose}>
  <CloseIcon />
</button>
```

## Best Practices

### Do's ✅

- Use consistent spacing from the 4px grid
- Apply proper font weights for hierarchy
- Use semantic colors (success, error, warning)
- Follow mobile-first responsive design
- Include proper focus states
- Use Toss Blue (#0064FF) for primary actions
- Apply proper shadows for elevation
- Use Pretendard for financial numbers to match Toss app's proportional font design

### Don'ts ❌

- Don't mix spacing values outside the grid system
- Don't use arbitrary font sizes
- Don't ignore mobile breakpoints
- Don't remove focus indicators
- Don't use custom colors without design approval
- Don't overuse shadows
- Don't mix font families inappropriately
- Don't use generic emojis for important UI elements

## Examples from Invoice Page

### Empty State (Current - To Be Updated)

```tsx
<div className={styles.emptyState}>
  <div className={styles.emptyIcon}>📄</div>
  <h3 className={styles.emptyTitle}>No Invoices</h3>
  <p className={styles.emptyText}>No invoice records found</p>
</div>
```

**CSS:**
```css
.emptyState {
  text-align: center;
  padding: 64px 32px;
  background: var(--color-white);
  border-radius: 12px;
}

.emptyIcon {
  font-size: 64px;
  margin-bottom: 24px;
  opacity: 0.5;
}

.emptyTitle {
  font-size: 24px;
  font-weight: 600;
  color: var(--color-gray-900);
}

.emptyText {
  font-size: 16px;
  color: var(--color-gray-600);
}
```

### Status Badges

```css
.statusBadge {
  display: inline-block;
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.statusBadge.completed {
  background: #d1e7dd;
  color: #0f5132;
}

.statusBadge.cancelled {
  background: #f8d7da;
  color: #842029;
}
```

### Payment Badges

```css
.paymentBadge {
  display: inline-block;
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 500;
}

.paymentBadge.paymentPaid {
  background: #d4edda;
  color: #155724;
}

.paymentBadge.paymentPending {
  background: #fff3cd;
  color: #856404;
}
```

## Theme Variables Reference

All design tokens are available in:
- **Colors:** `/src/shared/themes/variables.css`
- **Typography:** `/src/shared/themes/typography.css`
- **Base Styles:** `/src/shared/themes/base.css`
- **Global Styles:** `/src/shared/themes/global.css`

## Component Library

All shared components are located in:
```
/src/shared/components/
├── toss/             # Toss Design System components
│   ├── TossButton/
│   └── TossInput/
├── common/           # Common UI components
│   ├── Navbar/
│   └── ErrorMessage/
├── selectors/        # Selector components
│   ├── StoreSelector/
│   ├── CompanySelector/
│   └── TossSelector/
└── modals/           # Modal components
    ├── AddBrandModal/
    └── AddCategoryModal/
```

---

**Last Updated:** 2025-01-07
**Version:** 1.0.0
**Maintained By:** Development Team
