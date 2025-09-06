# MyFinance Web Application - Complete Documentation

**Consolidated Documentation** | Generated: January 2025 | Version: 1.0

This document consolidates all MyFinance web application documentation into a single, comprehensive reference covering architecture, implementation guides, component specifications, bug fixes, and project resources.

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [System Architecture](#system-architecture)
3. [Component System](#component-system)
4. [Page Implementation Guide](#page-implementation-guide)
5. [Bug Fixes & Resolutions](#bug-fixes--resolutions)
6. [Design Specifications](#design-specifications)
7. [Development Resources](#development-resources)

---

## 1. Project Overview

### 🎯 Mission Statement
MyFinance is a component-based web application system designed to create reusable UI components for a comprehensive financial management platform. Built with HTML, CSS, and JavaScript (no PHP), following the Toss Design System principles from the original Flutter application.

**Core Goal**: Build once, use everywhere - Create a comprehensive library of components that can be used across all pages of the MyFinance web application.

### 📊 Technology Stack
- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Styling**: Custom CSS with CSS Variables for theming
- **State Management**: Custom JavaScript state manager
- **API Communication**: Fetch API with Supabase JavaScript Client
- **Backend**: Supabase (existing)
- **Build Tools**: Webpack/Vite for bundling (planned)

### 🎨 Design System
Based on the Toss (토스) Korean fintech design system:
- **Colors**: Primary blue (#0064FF), semantic colors, grayscale
- **Spacing**: 4px grid system (space-1 to space-24)
- **Typography**: Inter font family with defined scales
- **Shadows**: Ultra-subtle shadows (4-8% opacity)
- **Border Radius**: 8px default, various sizes available

---

## 2. System Architecture

### 🏗️ Directory Structure

```
website/
├── components/               # Common reusable components
│   ├── base/                # Core UI components
│   │   ├── toss-button.js   # Button component with all variants
│   │   └── toss-button.css  # Complete button styling system
│   ├── navigation/          # Navigation components
│   │   ├── navbar.js        # Main navigation bar component
│   │   └── navbar.css       # Navigation styles
│   ├── form/                # Form components
│   │   ├── toss-input.js    # Input field component
│   │   ├── toss-select.js   # Select/dropdown component
│   │   ├── toss-filter.js   # Filter component
│   │   └── toss-store-filter.js # Store filter component
│   ├── feedback/            # User feedback components
│   │   ├── toss-alert.js    # Alert/toast component
│   │   └── toss-alert.css   # Alert styles
│   ├── layout/              # Layout components
│   │   ├── toss-modal.js    # Modal component
│   │   └── toss-modal.css   # Modal styles
│   └── data/                # Data display components
│       ├── toss-financial-section-header.js
│       └── toss-income-statement-table.css
│
├── core/                    # Core utilities and configuration
│   ├── config/             # Configuration files
│   │   ├── supabase.js     # Supabase authentication config
│   │   └── route-mapping.js # Route mapping configuration
│   ├── constants/          # Application constants
│   │   └── app-icons.js    # Icon system (converted from Flutter)
│   ├── themes/             # Toss design system theme
│   │   ├── toss-variables.css           # CSS variables
│   │   ├── toss-component-variables.css # Component variables
│   │   ├── toss-base.css               # Base styles
│   │   └── toss-typography.css         # Typography styles
│   └── utils/              # Utility functions
│       ├── app-state.js    # Application state management
│       ├── page-init.js    # Page initialization utility
│       └── generate-pages.js # Page generation utility
│
├── pages/                   # Application pages
│   ├── auth/               # Authentication pages
│   ├── dashboard/          # Dashboard page with widgets
│   ├── finance/            # Financial management pages
│   ├── employee/           # Employee management pages
│   ├── marketing/          # Marketing pages
│   ├── product/            # Product pages
│   └── settings/           # Settings pages
│
├── assets/                  # Static assets
│   ├── css/main.css        # Global styles
│   ├── fonts/              # Font files
│   └── images/             # Image assets
│
└── docs/                    # Documentation
    ├── ARCHITECTURE.md      # System architecture (detailed)
    ├── README.md            # Main component system guide
    ├── PAGE_IMPLEMENTATION_GUIDE.md # Page specifications
    ├── WEB_DESIGN_PLAN.md   # Complete design plan
    └── CONSOLIDATED_DOCUMENTATION.md # This file
```

### 🔄 Architecture Principles

#### 1. Component-Based Architecture
Two types of components:

**Common Components (`/components`)**:
- Reusable across multiple pages
- Self-contained with own JS and CSS files
- No page-specific logic
- Follow Toss design system guidelines

**Page Widgets (`/pages/[page]/widgets`)**:
- Page-specific functionality
- Can use common components
- Contain business logic specific to the page
- May interact with APIs directly

#### 2. State Management Flow
```javascript
// Core App States (stored in localStorage)
1. user: Complete user data from get_user_companies_and_stores RPC
2. companyChoosen: Currently selected company ID (persisted)
3. storeChoosen: Currently selected store ID (persisted)
4. categoryFeatures: Categories and features for navigation

// State Management Flow
On page load → Check auth → Fetch user companies → Store in localStorage → 
Load persisted selections → Update UI components

On company change → Update localStorage → Trigger companyChanged event → 
Reload page data → Update dependent components
```

#### 3. Authentication & Security
- **Supabase Integration**: Handles authentication and database operations
- **Session Management**: Automatic session handling with auth state listeners
- **Protected Routes**: All pages check authentication status
- **Secure Storage**: No sensitive data in localStorage except session tokens

---

## 3. Component System

### 🧩 Available Components

#### Base Components
**Buttons** (`base/toss-button`)
```html
<!-- Primary Button -->
<button class="toss-btn toss-btn-primary">Click Me</button>

<!-- Button Variants -->
<button class="toss-btn toss-btn-secondary">Secondary</button>
<button class="toss-btn toss-btn-outline">Outline</button>
<button class="toss-btn toss-btn-ghost">Ghost</button>
<button class="toss-btn toss-btn-text">Text Only</button>

<!-- Semantic Buttons -->
<button class="toss-btn toss-btn-success">Success</button>
<button class="toss-btn toss-btn-error">Delete</button>
<button class="toss-btn toss-btn-warning">Warning</button>

<!-- Button Sizes -->
<button class="toss-btn toss-btn-primary toss-btn-sm">Small</button>
<button class="toss-btn toss-btn-primary toss-btn-lg">Large</button>
<button class="toss-btn toss-btn-primary toss-btn-full">Full Width</button>

<!-- Loading State -->
<button class="toss-btn toss-btn-primary toss-btn-loading">
  <span class="toss-spinner"></span>
  Loading
</button>
```

**JavaScript API:**
```javascript
// Initialize button
const btn = new TossButton(element);

// Set loading state
btn.setLoading(true);

// Update text
btn.setText('New Text');

// Create programmatically
const newBtn = TossButtonUtils.create({
  variant: 'primary',
  text: 'Click Me',
  onClick: () => console.log('Clicked!')
});
```

#### Navigation Components
**Top Navigation Bar** (`navigation/toss-navbar`)
```html
<nav class="toss-navbar">
  <div class="toss-navbar-container">
    <!-- Logo/Brand -->
    <div class="toss-navbar-brand">
      <img src="logo.svg" class="toss-navbar-logo">
      <span class="toss-navbar-title">MyFinance</span>
    </div>
    
    <!-- Navigation Links -->
    <div class="toss-navbar-menu">
      <a href="#" class="toss-navbar-link active">Dashboard</a>
      <a href="#" class="toss-navbar-link">Transactions</a>
    </div>
    
    <!-- User Menu with Company Selector -->
    <div class="toss-navbar-right">
      <div class="toss-navbar-user">
        <button class="toss-navbar-user-btn">
          <img src="avatar.jpg" class="toss-navbar-avatar">
          <span>John Doe</span>
        </button>
      </div>
    </div>
  </div>
</nav>
```

**Company Selection Features:**
- Uses reusable TossSelect component for consistent UI
- Automatically fetches user companies via `get_user_companies_and_stores` RPC
- Stores selected company in localStorage as `companyChoosen`
- Triggers `companyChanged` event when selection changes
- Persists selection across browser sessions

#### Form Components
**Select/Dropdown Component** (`form/toss-select`)
```javascript
// Usage
const select = new TossSelect({
    containerId: 'select-container',
    options: [
        { value: '1', label: 'Option 1', description: 'Description' },
        { value: '2', label: 'Option 2' }
    ],
    value: '1',
    placeholder: 'Select an option',
    searchable: true,
    multiple: false,
    onChange: (value, option) => { ... }
});
select.init();
```

**Configuration Options:**
- `searchable`: Enable search functionality
- `multiple`: Enable multiple selection
- `size`: Component size (sm, default, lg)
- `width`: Component width (default, full, inline)

### 🎨 Theme System

#### CSS Variables (`css/theme/toss-variables.css`)
```css
:root {
  /* Colors */
  --toss-primary: #0064FF;      /* Main brand color */
  --toss-success: #00C896;      /* Success/profit */
  --toss-error: #FF5847;        /* Error/loss */
  
  /* Spacing (4px grid) */
  --space-1: 4px;
  --space-4: 16px;              /* Standard spacing */
  --space-6: 24px;              /* Section spacing */
  
  /* Typography */
  --font-h1: 28px;
  --font-body: 14px;
  --font-small: 11px;
  
  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}
```

#### Utility Classes
```css
/* Layout */
.flex .items-center .justify-between
.grid .grid-cols-3 .gap-4
.p-4 .m-2 .px-6 .py-3

/* Typography */
.text-primary .text-secondary .font-bold
.amount .amount-profit .amount-loss

/* Display */
.hidden .block .mobile-hidden .desktop-only
```

---

## 4. Page Implementation Guide

### 🔐 Authentication Pages

#### Login Page (`/pages/auth/login.html`)
**Purpose**: User authentication and session management

**Required APIs/RPC**:
```javascript
// Supabase Auth
supabase.auth.signInWithPassword({ email, password })
supabase.auth.getSession()
supabase.auth.onAuthStateChange()
```

**HTML Structure**:
```html
<div class="auth-container">
    <div class="auth-card">
        <img src="assets/images/logo.svg" alt="MyFinance" class="auth-logo">
        <h1>Welcome Back</h1>
        <form id="loginForm">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" required>
                <span class="error-message" id="emailError"></span>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" required>
                <span class="error-message" id="passwordError"></span>
            </div>
            <button type="submit" class="btn btn-primary btn-full">Sign In</button>
        </form>
    </div>
</div>
```

**JavaScript Implementation**:
```javascript
class LoginPage {
    async handleLogin(e) {
        e.preventDefault();
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        
        try {
            const { data, error } = await supabase.auth.signInWithPassword({
                email, password
            });
            
            if (error) throw error;
            
            // Store session
            localStorage.setItem('user', JSON.stringify(data.user));
            window.location.href = '/dashboard.html';
        } catch (error) {
            this.showError(error.message);
        }
    }
}
```

### 📊 Dashboard Pages

#### Dashboard Page (`/pages/dashboard/index.html`)
**Purpose**: Main hub with feature navigation and company selection

**Required APIs/RPC**:
```javascript
await supabase.rpc('get_user_companies_and_stores')
await supabase.rpc('get_categories_with_features', { p_company_id: companyId })
```

**Key Features**:
- Company/store selector in navigation
- Feature grid with permissions
- Quick actions
- Statistics cards

### 💰 Finance Pages

#### Transaction History (`/pages/finance/transaction-history/`)
**APIs Required**:
```javascript
await supabase.rpc('get_transaction_history', {
    p_company_id: companyId,
    p_store_id: storeId,
    p_date_from: dateFrom,
    p_date_to: dateTo,
    p_page: page,
    p_page_size: pageSize
})
```

#### Balance Sheet (`/pages/finance/balance-sheet/`)
**APIs Required**:
```javascript
await supabase.rpc('get_balance_sheet_data', {
    p_company_id: companyId,
    p_store_id: storeId,
    p_as_of_date: asOfDate
})
```

### 👥 Employee Pages

#### Employee Management (`/pages/employee/`)
**APIs Required**:
```javascript
await supabase.from('employees')
    .select(`*, role:roles(name), department:departments(name)`)
    .eq('company_id', companyId)
```

### ⚙️ Settings Pages

#### Currency Management (`/pages/settings/currency/`)
**APIs Required**:
```javascript
await supabase.from('currency_types').select('*')
await supabase.from('denominations')
    .select('*')
    .eq('currency_id', currencyId)
```

---

## 5. Bug Fixes & Resolutions

### 🐛 Critical Bug Fixes Implemented

#### 1. Login Redirect Fix
**Problem**: Users redirected to wrong URL after login
- **Original Issue**: `http://localhost/mcparrange-main/pages/auth/login.html` (missing myFinance_claude/website)
- **Root Causes**: 
  1. Relative paths resolved incorrectly
  2. AuthManager competing with login.js
  3. Race condition between redirect mechanisms

**Solutions Applied**:
```javascript
// Fixed getDashboardPath() in login.js
function getDashboardPath() {
    const origin = window.location.origin;
    const pathname = window.location.pathname;
    
    // Build complete path: /mcparrange-main/myFinance_claude/website/pages/dashboard/index.html
    if (pathname.includes('mcparrange-main')) {
        const baseIndex = pathname.indexOf('mcparrange-main');
        const basePath = pathname.substring(0, baseIndex + 'mcparrange-main'.length);
        return `${origin}${basePath}/myFinance_claude/website/pages/dashboard/index.html`;
    }
}

// AuthManager disabled on login page
if (window.location.pathname.includes('/auth/')) {
    return; // Exit early to prevent interference
}
```

**Files Modified**:
- `/pages/auth/assets/login.js` - Fixed getDashboardPath() to use absolute paths
- `/core/config/supabase.js` - Disabled AuthManager redirects on login page
- `/core/utils/page-init.js` - Fixed path calculation for other pages

#### 2. Filter Component Storage Fix
**Problem**: Store filter not showing stores from selected company

**Root Cause**: TossFilter component using wrong storage keys:
- **Incorrect**: `sessionStorage` with keys `selectedCompanyId`, `userData`
- **Correct**: `localStorage` with keys `companyChoosen`, `user`

**Solution**:
```javascript
// Updated TossFilter component
loadStores() {
    // Changed from sessionStorage.getItem('userData')
    const userData = localStorage.getItem('user');
    
    // Changed from sessionStorage.getItem('selectedCompanyId')
    const selectedCompanyId = localStorage.getItem('companyChoosen');
    
    if (userData && selectedCompanyId) {
        const user = JSON.parse(userData);
        const company = user.companies.find(c => c.company_id === selectedCompanyId);
        if (company && company.stores) {
            this.populateStores(company.stores);
        }
    }
}
```

**Affected Pages**:
- ✅ **Balance Sheet** (`/pages/finance/balance-sheet/`) - Fixed
- ✅ **Income Statement** (`/pages/finance/income-statement/`) - Already working correctly

#### 3. Cash Ending Modal Store Selection Fix
**Problem**: Store dropdown not selectable after hard refresh

**Root Cause**: Race condition between page initialization and user interaction
1. Page loading user data
2. User clicking "Cash Ending" button immediately
3. Modal trying to load stores before appState ready

**Solution**:
```javascript
// Added ensureAppStateReady() function
async function ensureAppStateReady() {
    if (!window.appState || typeof window.appState.getCompanyStores !== 'function') {
        console.log('AppState not ready, waiting...');
        return false;
    }
    
    const userData = window.appState.getUserData();
    if (!userData || !userData.companies || userData.companies.length === 0) {
        console.log('User data not loaded, waiting...');
        return false;
    }
    
    return true;
}

// Modified openCashEndingModal()
function openCashEndingModal() {
    const isReady = await ensureAppStateReady();
    if (!isReady) {
        showAlert('Please wait for page to fully load before opening cash ending.', 'warning');
        return;
    }
    // Continue with modal opening...
}

// Enhanced loadModalStores() with retry logic
async function loadModalStores() {
    let attempts = 0;
    const maxAttempts = 3;
    
    while (attempts < maxAttempts) {
        // Try Method 1: appState.getCompanyStores()
        // Try Method 2: appState.getUserData()
        // Try Method 3: localStorage direct access
        
        attempts++;
        if (attempts < maxAttempts) {
            await new Promise(resolve => setTimeout(resolve, 500));
        }
    }
}
```

#### 4. Employee Schedule Height Fix
**Problem**: Excessive vertical height in schedule grid

**Root Cause**: Multiple CSS properties with excessive minimum heights:
- `.schedule-grid` had `min-height: 650px`
- `.time-slot-cell` had `min-height: 100px`
- `.shift-block` had `min-height: 90px`

**Solution**:
```css
/* Before → After */
.schedule-grid { min-height: 650px; → min-height: auto; }
.time-slot-cell { min-height: 100px; → min-height: 80px; }
.shift-block { min-height: 90px; → min-height: 70px; }

/* Mobile optimization */
@media (max-width: 480px) {
    .time-slot-cell { min-height: 60px; }
    .shift-block { min-height: 45px; }
}
```

**Benefits**:
- Better visual balance with content-based height
- Reduced scrolling requirements
- Consistent alignment between elements
- Maintained drag-and-drop functionality

---

## 6. Design Specifications

### 🗓️ Employee Schedule Page Design

#### Key Design Features
1. **Store Filter**: Consistent with employee settings page implementation
2. **Week Navigation**: Previous/Next buttons with current week display
3. **Drag and Drop Interface**: Modern, intuitive scheduling
4. **Responsive Design**: Desktop sidebar, mobile bottom sheet

#### Visual Design Elements
- **Color Scheme**: Toss Blue (#0064FF), Success Green (#00C896), Warning Orange (#FF9500)
- **Typography**: Bold headings, emphasized values, secondary color labels
- **Spacing**: 4px grid system with consistent card-based layout

#### Interaction Patterns
```javascript
// Drag and Drop Flow
1. Initiate: Click and hold on employee card
2. Drag: Visual feedback (opacity, cursor, shadow)  
3. Hover: Drop zones highlight when valid
4. Drop: Smooth animation to final position
5. Confirm: Shift block appears with employee info
```

### 💰 Salary Management Page Design

#### Design Principles
- **Minimalist Interface**: Clean white backgrounds with subtle shadows
- **Strategic Color Usage**: Toss Blue for primary actions and highlights
- **Information Hierarchy**: Summary first, progressive disclosure through expandable cards
- **Trust Through Consistency**: Uniform design patterns

#### Key Components
1. **Summary Cards**: Employee count, total payment, overtime hours, problems
2. **Filter Bar**: Real-time search with filter chips
3. **Employee Cards**: Collapsed/expanded states with detailed breakdown
4. **Responsive Grid**: Auto-adjusting columns based on screen size

### 🏪 Store Filter Modal Component

#### Features
- ✅ **Modal Interface**: Clean overlay design
- ✅ **Multi-select Support**: Multiple or single store selection
- ✅ **Search Functionality**: Filter stores by name
- ✅ **Keyboard Accessibility**: ESC to close, proper focus management

#### Usage Example
```javascript
const storeFilterModal = new TossStoreFilterModal({
    stores: stores,
    selectedStores: [],
    showAllStoresOption: true,
    multiSelect: true,
    onApply: (selectedStoreIds) => {
        console.log('Selected stores:', selectedStoreIds);
    }
});

// Show modal
storeFilterModal.show();
```

---

## 7. Development Resources

### 🚀 Getting Started

#### 1. Project Setup
```bash
# Clone repository
git clone [repository-url]

# Navigate to web directory
cd myFinance_claude/website

# Start local server (XAMPP)
# Access: http://localhost/mcparrange-main/myFinance_claude/website/
```

#### 2. Required Files for All Pages
```html
<!-- Theme CSS -->
<link rel="stylesheet" href="../../css/theme/toss-variables.css">
<link rel="stylesheet" href="../../css/theme/toss-base.css">
<link rel="stylesheet" href="../../css/theme/toss-typography.css">

<!-- Component CSS -->
<link rel="stylesheet" href="../../components/base/toss-button.css">
<link rel="stylesheet" href="../../components/form/toss-input.css">

<!-- Supabase CDN -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

<!-- Component JavaScript -->
<script src="../../components/base/toss-button.js"></script>
<script src="../../core/config/supabase.js"></script>
```

#### 3. Basic Page Template
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MyFinance - Page Title</title>
    <link rel="stylesheet" href="/path/to/css/main.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar Navigation -->
        <aside class="toss-sidebar">
            <!-- Use navigation component -->
        </aside>
        
        <!-- Main Content -->
        <main class="main-content">
            <!-- Top Navigation -->
            <nav class="toss-navbar">
                <!-- Use navbar component -->
            </nav>
            
            <!-- Page Content -->
            <div class="page-container">
                <div class="page-header">
                    <h1 class="page-title">Page Title</h1>
                    <div class="page-actions">
                        <button class="toss-btn toss-btn-primary">Action</button>
                    </div>
                </div>
                
                <!-- Your page content -->
            </div>
        </main>
    </div>
    
    <!-- Component JavaScript -->
    <script src="/path/to/components/base/toss-button.js"></script>
    <script src="/path/to/components/navigation/toss-navbar.js"></script>
</body>
</html>
```

### 📱 Responsive Design Guidelines

#### Breakpoints
- **Mobile**: < 768px (Bottom navigation, full-width buttons, stacked layout)
- **Tablet**: 768px - 1023px (Top navigation, collapsible sidebar)
- **Desktop**: ≥ 1024px (Full navigation, expanded sidebar, optimal spacing)

#### Mobile-First CSS
```css
/* Mobile First Approach */
.container {
  width: 100%;
  padding: var(--spacing-md);
}

@media (min-width: 768px) {
  .container { max-width: 768px; }
  .sidebar { display: block; }
}

@media (min-width: 1024px) {
  .container { max-width: 1024px; }
}
```

### 🔧 Implementation Timeline

#### Phase 1: Foundation (Week 1-2)
- ✅ Project structure setup
- ✅ Supabase integration
- ✅ Base components (Button, Card, Modal)
- ✅ Authentication system

#### Phase 2: Core Features (Week 3-4)
- ✅ Dashboard with company selector
- ✅ Master data (Counter party management)
- ✅ Transaction module (History, filtering)
- ✅ Navigation system

#### Phase 3: Advanced Features (Week 5-6)
- 🚧 Financial reports (Balance sheet, Income statement)
- 🚧 Configuration (Role management, Currency)
- 🚧 Employee management with scheduling

#### Phase 4: Polish & Optimization (Week 7-8)
- ⏳ Performance optimization (Code splitting, lazy loading)
- ⏳ User experience (Loading states, error handling)
- ⏳ Testing and deployment

### 📚 API Reference

#### Core RPC Functions
```javascript
// User and company data
await supabase.rpc('get_user_companies_and_stores')
await supabase.rpc('get_categories_with_features', { p_company_id: companyId })

// Transaction management
await supabase.rpc('get_transaction_history', { ... })
await supabase.rpc('get_transaction_filter_options', { ... })

// Financial reporting
await supabase.rpc('get_balance_sheet_data', { ... })
await supabase.rpc('get_income_statement_data', { ... })

// Salary management
await supabase.rpc('get_salary_data', { ... })
```

#### Direct Table Queries
```javascript
// Employee management
await supabase.from('employees')
    .select('*, role:roles(name), department:departments(name)')
    .eq('company_id', companyId)

// Currency management
await supabase.from('currency_types').select('*')
await supabase.from('denominations')
    .select('*')
    .eq('currency_id', currencyId)
```

### 🧪 Testing Guidelines

#### Local Testing Checklist
1. **Start XAMPP** and ensure Apache is running
2. **Configure Supabase** credentials in `/core/config/supabase.js`
3. **Test Authentication Flow**: Login → Dashboard → Sign out
4. **Test Component Integration**: Navigation, buttons, forms
5. **Test Responsive Design**: Mobile, tablet, desktop views
6. **Test Cross-browser**: Chrome, Firefox, Safari

#### Component Testing
```javascript
// Initialize all components on page load
document.addEventListener('DOMContentLoaded', () => {
    // Initialize buttons
    document.querySelectorAll('.toss-btn').forEach(btn => {
        new TossButton(btn);
    });
    
    // Initialize navigation
    new TossNavbar(document.querySelector('.toss-navbar'));
    new TossSidebar(document.querySelector('.toss-sidebar'));
});
```

### 📈 Performance Metrics
- **Page Load Time**: < 3 seconds
- **Time to Interactive**: < 5 seconds
- **Bundle Size**: < 500KB (initial)
- **Lighthouse Score**: > 90

### 🎯 Success Indicators
- **Reusability**: Each component used in multiple pages
- **Consistency**: Uniform design across entire application
- **Accessibility**: WCAG 2.1 AA compliance
- **Mobile Experience**: Excellent mobile-first experience

---

## 📝 Original Source Files

This consolidated documentation was created from the following source files:

### Architecture & Design Documents
- `docs/ARCHITECTURE.md` - Complete system architecture
- `docs/WEB_DESIGN_PLAN.md` - Comprehensive design plan
- `docs/README.md` - Component system guide
- `docs/PAGE_IMPLEMENTATION_GUIDE.md` - Page specifications

### Bug Fix Documentation
- `LOGIN_REDIRECT_FIX.md` - Login redirect issue resolution
- `LOGIN_FIX_FINAL.md` - Final login fix implementation
- `FILTER_FIX_SUMMARY.md` - Filter component storage fix
- `CASH_ENDING_FIX_SUMMARY.md` - Cash ending modal fix
- `pages/employee/schedule/HEIGHT_FIX_DOCUMENTATION.md` - Schedule height fix

### Component Documentation  
- `components/COMPONENT_INDEX.md` - Component library index
- `components/form/README-store-filter-modal.md` - Store filter modal docs

### Page Documentation
- `pages/README.md` - Page organization structure
- `pages/employee/schedule/DESIGN_SPEC.md` - Schedule page design
- `pages/employee/salary/DESIGN_SPEC.md` - Salary page design

---

**Document Status**: Complete | **Last Updated**: January 2025 | **Version**: 1.0

This consolidated documentation serves as the single source of truth for all MyFinance web application development activities, combining architectural guidance, implementation specifications, bug resolutions, and development resources in one comprehensive reference.