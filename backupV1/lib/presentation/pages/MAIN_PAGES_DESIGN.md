# MyFinance Main Pages Design Document

## Overview
This document outlines the design for all main pages in the MyFinance application, following Toss design principles for an intuitive and delightful user experience.

## Core Pages Architecture

Based on the feature analysis from the homepage, the application needs the following main pages:

### 1. Authentication Pages
- **Login Page** - Simple, clean login with email/password
- **Sign Up Page** - Minimal registration flow
- **Forgot Password Page** - Password recovery

### 2. Financial Management Pages
- **Cash Balance Page** - Overview of cash positions
- **Bank Vault Page** - Bank account management
- **Transaction History Page** - All financial transactions
- **Journal Entry Page** - Manual journal entries
- **Income Statement Page** - P&L reports
- **Balance Sheet Page** - Financial position

### 3. HR & Operations Pages
- **Time Table Page** - Employee scheduling
- **Attendance Page** - Clock in/out tracking
- **Employee Settings Page** - Staff management
- **Role & Permissions Page** - Access control

### 4. Business Management Pages
- **Company Management Page** - Company settings
- **Store Management Page** - Multiple store handling
- **Counterparty Page** - Customer/vendor management
- **Debt Control Page** - Receivables/payables

### 5. Settings & Profile Pages
- **My Profile Page** - User profile management
- **App Settings Page** - Application preferences

## Detailed Page Designs

### 1. Login Page

```
┌────────────────────────────────────────┐
│                                        │
│                                        │
│         💰 MyFinance                   │ ← App Logo/Name
│                                        │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  Email                           │  │ ← TossTextField
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  Password                    👁   │  │ ← Password toggle
│  └──────────────────────────────────┘  │
│                                        │
│  Forgot Password?                      │ ← Text link
│                                        │
│  ┌──────────────────────────────────┐  │
│  │         Login                     │  │ ← TossPrimaryButton
│  └──────────────────────────────────┘  │
│                                        │
│  ─────────── OR ───────────            │
│                                        │
│  Don't have an account? Sign Up        │ ← Text link
│                                        │
└────────────────────────────────────────┘
```

**Design Principles:**
- Single focus: Login
- Minimal fields
- Clear CTA
- Subtle animations on focus

### 2. Cash Balance Page

```
┌────────────────────────────────────────┐
│  ← Cash Balance            🔄          │ ← Header with sync
├────────────────────────────────────────┤
│                                        │
│  Total Cash Balance                    │
│  ₩ 12,345,600                         │ ← Large amount display
│  ▲ 2.5% from last month               │ ← Change indicator
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  📍 Main Store                   │  │ ← Store selector
│  │  ₩ 5,234,100                    │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  📍 Branch Store                 │  │ ← TossCard
│  │  ₩ 7,111,500                    │  │
│  └──────────────────────────────────┘  │
│                                        │
│  Recent Transactions                   │ ← Section header
│  ┌──────────────────────────────────┐  │
│  │  💰 Cash Sale                    │  │
│  │  Today, 2:30 PM                  │  │ ← TossListItem
│  │                      +₩ 50,000   │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │  💸 Expense Payment              │  │
│  │  Today, 11:00 AM                 │  │
│  │                      -₩ 25,000   │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │    Record Cash Movement          │  │ ← TossPrimaryButton
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

**Key Features:**
- Clear balance overview
- Store-wise breakdown
- Recent activity
- Quick action button

### 3. Transaction History Page

```
┌────────────────────────────────────────┐
│  ← Transactions      🔍 📊             │ ← Search & Filter
├────────────────────────────────────────┤
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  All  Income  Expense            │  │ ← Tab selector
│  └──────────────────────────────────┘  │
│                                        │
│  March 2024                            │ ← Month header
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  📈 Sales Revenue                │  │
│  │  Business Income                 │  │
│  │  Mar 15, 2024                   │  │
│  │                    +₩ 1,234,560  │  │ ← Green for income
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  🏢 Office Rent                  │  │
│  │  Fixed Expense                   │  │
│  │  Mar 10, 2024                   │  │
│  │                      -₩ 800,000  │  │ ← Black for expense
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  💼 Employee Salary              │  │
│  │  Payroll                         │  │
│  │  Mar 5, 2024                    │  │
│  │                    -₩ 2,500,000  │  │
│  └──────────────────────────────────┘  │
│                                        │
│  Load More...                          │ ← Pagination
│                                        │
└────────────────────────────────────────┘

Floating Action Button:
     ┌────┐
     │ ➕ │ ← Add Transaction
     └────┘
```

**Design Elements:**
- Tab-based filtering
- Clear transaction cards
- Color-coded amounts
- Floating action button

### 4. Employee Time Table Page

```
┌────────────────────────────────────────┐
│  ← Time Table         Week ▼          │ ← View selector
├────────────────────────────────────────┤
│                                        │
│  March 18-24, 2024                     │
│  ◀                               ▶     │ ← Week navigation
│                                        │
│  ┌──────────────────────────────────┐  │
│  │     Mon  Tue  Wed  Thu  Fri  Sat │  │ ← Day headers
│  ├──────────────────────────────────┤  │
│  │ Jin  9-6  9-6  OFF  9-6  9-6  9-3│  │
│  │                                  │  │
│  │ Kim  OFF  9-6  9-6  9-6  OFF  9-3│  │ ← Employee rows
│  │                                  │  │
│  │ Lee  9-6  OFF  9-6  9-6  9-6  OFF│  │
│  └──────────────────────────────────┘  │
│                                        │
│  Today's Schedule                      │
│  ┌──────────────────────────────────┐  │
│  │  Morning Shift (9 AM - 3 PM)     │  │
│  │  • Jin Lee                       │  │
│  │  • Kim Park                      │  │
│  ├──────────────────────────────────┤  │
│  │  Evening Shift (3 PM - 9 PM)     │  │
│  │  • Lee Choi                      │  │
│  │  • Park Kim                      │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │     Create Schedule              │  │ ← Primary action
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

**Features:**
- Week view by default
- Easy navigation
- Today's highlight
- Clear shift display

### 5. Company Management Page

```
┌────────────────────────────────────────┐
│  ← Company Settings                    │
├────────────────────────────────────────┤
│                                        │
│  Company Information                   │
│  ┌──────────────────────────────────┐  │
│  │  🏢 Tech Startup Inc.            │  │
│  │  Technology                      │  │
│  │  Since 2020                      │  │
│  │                          Edit ›  │  │
│  └──────────────────────────────────┘  │
│                                        │
│  Stores                                │
│  ┌──────────────────────────────────┐  │
│  │  📍 Main Office                  │  │
│  │  123 Tech Street                 │  │
│  │  Active • 15 employees           │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │  📍 Branch Office                │  │
│  │  456 Innovation Ave              │  │
│  │  Active • 8 employees            │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │  ➕ Add New Store                │  │ ← Dashed border
│  └──────────────────────────────────┘  │
│                                        │
│  Team Members                          │
│  ┌──────────────────────────────────┐  │
│  │  Invite Code: ABC123             │  │
│  │  Share this code ›               │  │
│  └──────────────────────────────────┘  │
│                                        │
│  Danger Zone                           │
│  ┌──────────────────────────────────┐  │
│  │  Delete Company                  │  │ ← Red text
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

### 6. Role & Permissions Page

```
┌────────────────────────────────────────┐
│  ← Roles & Permissions                 │
├────────────────────────────────────────┤
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  👑 Owner                        │  │
│  │  Full access to all features     │  │
│  │  1 member                        │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  👨‍💼 Manager                      │  │
│  │  Manage daily operations          │  │
│  │  3 members                   ›   │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  👤 Employee                      │  │
│  │  Basic access                     │  │
│  │  12 members                  ›   │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │  ➕ Create Custom Role           │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘

Detail View (Manager):
┌────────────────────────────────────────┐
│  ← Manager Role                        │
├────────────────────────────────────────┤
│                                        │
│  Permissions                           │
│                                        │
│  Financial                             │
│  ☑ View transactions                   │
│  ☑ Create transactions                 │
│  ☐ Delete transactions                 │
│  ☑ View reports                        │
│                                        │
│  HR Management                         │
│  ☑ View schedules                      │
│  ☑ Create schedules                    │
│  ☑ Manage attendance                   │
│  ☐ Manage salaries                     │
│                                        │
│  Members (3)                           │
│  ┌──────────────────────────────────┐  │
│  │  👤 Kim Manager                   │  │
│  │  kim@company.com                  │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

## Common UI Components Used

### 1. TossPrimaryButton
- Full-width primary actions
- 56px height
- 16px border radius
- Loading states

### 2. TossCard
- White background
- Subtle shadow (2-5% opacity)
- 16px border radius
- Tap animation (scale 0.95)

### 3. TossTextField
- Minimal borders
- Focus animations
- Clear labels
- Error states

### 4. TossBottomSheet
- Action menus
- Form inputs
- Confirmations

### 5. TossListItem
- Consistent padding
- Chevron indicators
- Tap feedback

## Navigation Patterns

### Bottom Navigation (Main Areas)
```
┌─────┬─────┬─────┬─────┬─────┐
│ 🏠  │ 💰  │ 📊  │ 👥  │ ⚙️  │
│Home │Cash │Report│Team │More │
└─────┴─────┴─────┴─────┴─────┘
```

### Drawer Navigation (Company/Store)
- Company switcher
- Store selector
- Profile access

## Color Usage

- **Primary (#5B5FCF)**: Primary buttons, active states
- **Success (#22C55E)**: Positive amounts, success states
- **Error (#EF4444)**: Negative actions, errors
- **Gray Scale**: Text hierarchy, borders, backgrounds

## Animation Guidelines

1. **Page Transitions**: 300ms slide from right
2. **Card Taps**: 100ms scale to 0.95
3. **Loading**: Shimmer effects
4. **Number Changes**: Count up animation
5. **List Items**: Stagger animation on load

## Responsive Considerations

- **Mobile First**: Designed for phones
- **Tablet**: 2-column layouts where applicable
- **Landscape**: Adjusted layouts
- **Safe Areas**: Proper padding

## Accessibility

- **Touch Targets**: Minimum 48x48
- **Contrast**: WCAG AA compliance
- **Screen Readers**: Semantic labels
- **Focus Indicators**: Clear focus states

## Implementation Priority

### Phase 1 (Core Features)
1. Login/Auth pages
2. Homepage
3. Cash Balance
4. Transaction History

### Phase 2 (Operations)
1. Time Table
2. Attendance
3. Employee Management

### Phase 3 (Advanced)
1. Reports (P&L, Balance Sheet)
2. Role Management
3. Multi-company features

### Phase 4 (Polish)
1. Animations
2. Offline support
3. Performance optimization