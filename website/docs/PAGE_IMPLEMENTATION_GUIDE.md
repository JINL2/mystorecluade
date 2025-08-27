# Page-by-Page Implementation Guide

## Complete Web Implementation Specifications for Each Page

---

## 1. Authentication Pages

### Login Page
**URL**: `/login.html`
**Purpose**: User authentication and session management

#### Required APIs/RPC:
```javascript
// Supabase Auth
supabase.auth.signInWithPassword({ email, password })
supabase.auth.getSession()
supabase.auth.onAuthStateChange()
```

#### HTML Structure:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login - MyFinance</title>
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/pages/auth.css">
</head>
<body>
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
                <div class="form-group checkbox-group">
                    <input type="checkbox" id="rememberMe">
                    <label for="rememberMe">Remember me</label>
                </div>
                <button type="submit" class="btn btn-primary btn-full">Sign In</button>
            </form>
            <div class="auth-links">
                <a href="/forgot-password.html">Forgot password?</a>
                <a href="/signup.html">Create account</a>
            </div>
        </div>
    </div>
    <script src="js/pages/auth/login.js"></script>
</body>
</html>
```

#### JavaScript Implementation:
```javascript
// js/pages/auth/login.js
class LoginPage {
    constructor() {
        this.form = document.getElementById('loginForm');
        this.init();
    }
    
    init() {
        this.form.addEventListener('submit', (e) => this.handleLogin(e));
        this.checkExistingSession();
    }
    
    async checkExistingSession() {
        const { data: { session } } = await supabase.auth.getSession();
        if (session) {
            window.location.href = '/dashboard.html';
        }
    }
    
    async handleLogin(e) {
        e.preventDefault();
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        
        try {
            const { data, error } = await supabase.auth.signInWithPassword({
                email,
                password
            });
            
            if (error) throw error;
            
            // Store session
            localStorage.setItem('user', JSON.stringify(data.user));
            window.location.href = '/dashboard.html';
        } catch (error) {
            this.showError(error.message);
        }
    }
    
    showError(message) {
        const errorDiv = document.createElement('div');
        errorDiv.className = 'alert alert-error';
        errorDiv.textContent = message;
        this.form.prepend(errorDiv);
        setTimeout(() => errorDiv.remove(), 5000);
    }
}

new LoginPage();
```

---

## 2. Dashboard/Homepage

### Dashboard Page
**URL**: `/dashboard.html` or `/index.html`
**Purpose**: Main hub with feature navigation and company selection

#### Required APIs/RPC:
```javascript
// RPC Functions
await supabase.rpc('get_user_companies_and_stores')
await supabase.rpc('get_categories_with_features', { p_company_id: companyId })

// Direct Queries
await supabase.from('companies').select('*').eq('user_id', userId)
await supabase.from('stores').select('*').eq('company_id', companyId)
```

#### HTML Structure:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Dashboard - MyFinance</title>
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/pages/dashboard.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <img src="assets/images/logo.svg" alt="MyFinance">
                <span>MyFinance</span>
            </div>
            <nav class="sidebar-nav" id="sidebarNav"></nav>
            <div class="sidebar-footer">
                <div class="user-info" id="userInfo"></div>
                <button id="logoutBtn" class="btn-icon">
                    <i class="icon-logout"></i>
                </button>
            </div>
        </aside>
        
        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <header class="app-header">
                <button class="menu-toggle" id="menuToggle">
                    <i class="icon-menu"></i>
                </button>
                <div class="header-controls">
                    <select id="companySelector" class="company-selector"></select>
                    <select id="storeSelector" class="store-selector"></select>
                </div>
            </header>
            
            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <!-- Stats Cards -->
                <div class="stats-grid" id="statsGrid"></div>
                
                <!-- Feature Grid -->
                <section class="feature-section">
                    <h2>Features</h2>
                    <div class="feature-grid" id="featureGrid"></div>
                </section>
                
                <!-- Quick Actions -->
                <section class="quick-actions">
                    <h2>Quick Actions</h2>
                    <div class="action-buttons" id="quickActions"></div>
                </section>
            </div>
        </main>
    </div>
    <script src="js/pages/dashboard.js"></script>
</body>
</html>
```

#### JavaScript Implementation:
```javascript
// js/pages/dashboard.js
class DashboardPage {
    constructor() {
        this.user = JSON.parse(localStorage.getItem('user'));
        this.selectedCompany = null;
        this.selectedStore = null;
        this.features = [];
        this.init();
    }
    
    async init() {
        await this.loadUserContext();
        await this.loadFeatures();
        this.setupEventListeners();
        this.renderDashboard();
    }
    
    async loadUserContext() {
        const { data, error } = await supabase.rpc('get_user_companies_and_stores');
        if (data) {
            this.companies = data.companies;
            this.stores = data.stores;
            this.populateSelectors();
        }
    }
    
    async loadFeatures() {
        if (!this.selectedCompany) return;
        
        const { data, error } = await supabase.rpc('get_categories_with_features', {
            p_company_id: this.selectedCompany.id
        });
        
        if (data) {
            this.features = data;
            this.renderFeatureGrid();
        }
    }
    
    renderFeatureGrid() {
        const grid = document.getElementById('featureGrid');
        grid.innerHTML = this.features.map(category => `
            <div class="feature-category">
                <h3>${category.name}</h3>
                <div class="feature-items">
                    ${category.features.map(feature => `
                        <a href="${feature.route}.html" class="feature-card">
                            <i class="${feature.icon}"></i>
                            <span>${feature.name}</span>
                        </a>
                    `).join('')}
                </div>
            </div>
        `).join('');
    }
}

new DashboardPage();
```

---

## 3. Transaction Management Pages

### Transaction History Page
**URL**: `/transactions.html`
**Purpose**: View and filter all transactions

#### Required APIs/RPC:
```javascript
// RPC Functions
await supabase.rpc('get_transaction_history', {
    p_company_id: companyId,
    p_store_id: storeId,
    p_date_from: dateFrom,
    p_date_to: dateTo,
    p_account_id: accountId,
    p_counterparty_id: counterpartyId,
    p_page: page,
    p_page_size: pageSize
})

await supabase.rpc('get_transaction_filter_options', {
    p_company_id: companyId,
    p_store_id: storeId
})
```

#### HTML Structure:
```html
<div class="page-container">
    <header class="page-header">
        <h1>Transaction History</h1>
        <div class="header-actions">
            <button id="filterBtn" class="btn btn-secondary">
                <i class="icon-filter"></i> Filter
            </button>
            <button id="exportBtn" class="btn btn-secondary">
                <i class="icon-download"></i> Export
            </button>
        </div>
    </header>
    
    <!-- Filter Panel -->
    <div class="filter-panel" id="filterPanel" style="display: none;">
        <div class="filter-row">
            <div class="filter-group">
                <label>Date Range</label>
                <input type="date" id="dateFrom">
                <input type="date" id="dateTo">
            </div>
            <div class="filter-group">
                <label>Account</label>
                <select id="accountFilter"></select>
            </div>
            <div class="filter-group">
                <label>Counter Party</label>
                <select id="counterpartyFilter"></select>
            </div>
        </div>
        <div class="filter-actions">
            <button id="applyFilter" class="btn btn-primary">Apply</button>
            <button id="clearFilter" class="btn btn-secondary">Clear</button>
        </div>
    </div>
    
    <!-- Transaction List -->
    <div class="transaction-list" id="transactionList">
        <div class="loading">Loading transactions...</div>
    </div>
    
    <!-- Pagination -->
    <div class="pagination" id="pagination"></div>
</div>
```

#### JavaScript Implementation:
```javascript
// js/pages/transactions.js
class TransactionHistoryPage {
    constructor() {
        this.filters = {
            dateFrom: null,
            dateTo: null,
            accountId: null,
            counterpartyId: null
        };
        this.currentPage = 1;
        this.pageSize = 50;
        this.init();
    }
    
    async init() {
        await this.loadFilterOptions();
        await this.loadTransactions();
        this.setupEventListeners();
    }
    
    async loadTransactions() {
        const { data, error } = await supabase.rpc('get_transaction_history', {
            p_company_id: this.companyId,
            p_store_id: this.storeId,
            p_date_from: this.filters.dateFrom,
            p_date_to: this.filters.dateTo,
            p_account_id: this.filters.accountId,
            p_counterparty_id: this.filters.counterpartyId,
            p_page: this.currentPage,
            p_page_size: this.pageSize
        });
        
        if (data) {
            this.renderTransactions(data.transactions);
            this.renderPagination(data.total_count);
        }
    }
    
    renderTransactions(transactions) {
        const listEl = document.getElementById('transactionList');
        
        const groupedByDate = this.groupByDate(transactions);
        
        listEl.innerHTML = Object.entries(groupedByDate).map(([date, items]) => `
            <div class="transaction-group">
                <div class="transaction-date">${this.formatDate(date)}</div>
                ${items.map(tx => `
                    <div class="transaction-item">
                        <div class="transaction-info">
                            <span class="transaction-desc">${tx.description}</span>
                            <span class="transaction-account">${tx.account_name}</span>
                        </div>
                        <div class="transaction-amount ${tx.type}">
                            ${tx.type === 'debit' ? '-' : ''}${this.formatCurrency(tx.amount)}
                        </div>
                    </div>
                `).join('')}
            </div>
        `).join('');
    }
}
```

### Journal Entry Page
**URL**: `/journal-entry.html`
**Purpose**: Create double-entry bookkeeping transactions

#### Required APIs/RPC:
```javascript
// Direct Queries
await supabase.from('accounts').select('*').eq('company_id', companyId)
await supabase.from('counterparties').select('*').eq('company_id', companyId)
await supabase.from('cash_locations').select('*').eq('company_id', companyId)

// Transaction Posting
await supabase.from('transactions').insert({
    company_id: companyId,
    store_id: storeId,
    transaction_date: date,
    description: description,
    transaction_lines: lines
})
```

---

## 4. Master Data Management Pages

### Counter Party Management
**URL**: `/counterparty.html`
**Purpose**: Manage customers, suppliers, employees, and other business relationships

#### Required APIs/RPC:
```javascript
// Direct Queries
await supabase.from('counterparties')
    .select('*')
    .eq('company_id', companyId)
    .eq('deleted_at', null)

// RPC Functions
await supabase.rpc('get_unlinked_companies')
await supabase.rpc('update_counterparty', {
    p_counterparty_id: id,
    p_updates: updates
})

// CRUD Operations
await supabase.from('counterparties').insert(data)
await supabase.from('counterparties').update(data).eq('id', id)
await supabase.from('counterparties').update({ deleted_at: new Date() }).eq('id', id)
```

#### Component Structure:
```javascript
// js/pages/counterparty.js
class CounterPartyPage {
    constructor() {
        this.counterPartyTypes = [
            { value: 'my_company', label: 'My Company', icon: 'building', color: 'blue' },
            { value: 'team_member', label: 'Team Member', icon: 'users', color: 'green' },
            { value: 'supplier', label: 'Supplier', icon: 'truck', color: 'orange' },
            { value: 'employee', label: 'Employee', icon: 'user', color: 'purple' },
            { value: 'customer', label: 'Customer', icon: 'shopping-cart', color: 'teal' },
            { value: 'other', label: 'Other', icon: 'folder', color: 'gray' }
        ];
    }
    
    async loadCounterParties() {
        const { data, error } = await supabase.from('counterparties')
            .select('*')
            .eq('company_id', this.companyId)
            .is('deleted_at', null)
            .order('name');
            
        this.renderCounterPartyList(data);
    }
    
    renderStatistics(data) {
        const stats = this.calculateStats(data);
        return `
            <div class="stats-grid">
                ${this.counterPartyTypes.map(type => `
                    <div class="stat-card ${type.color}">
                        <i class="icon-${type.icon}"></i>
                        <div class="stat-value">${stats[type.value] || 0}</div>
                        <div class="stat-label">${type.label}</div>
                    </div>
                `).join('')}
            </div>
        `;
    }
}
```

### Employee Management
**URL**: `/employees.html`
**Purpose**: Manage employee data, salaries, and roles

#### Required APIs/RPC:
```javascript
// Direct Queries
await supabase.from('employees')
    .select(`
        *,
        role:roles(name),
        department:departments(name),
        currency:currency_types(symbol)
    `)
    .eq('company_id', companyId)

// Salary Updates
await supabase.from('employee_salaries').insert({
    employee_id: employeeId,
    amount: amount,
    currency_id: currencyId,
    effective_date: date
})

// Role Management
await supabase.from('employee_roles').insert({
    employee_id: employeeId,
    role_id: roleId
})
```

---

## 5. Financial Reporting Pages

### Balance Sheet Page
**URL**: `/balance-sheet.html`
**Purpose**: Generate balance sheet and income statement reports

#### Required APIs/RPC:
```javascript
// Complex financial calculations would require custom RPC functions
await supabase.rpc('get_balance_sheet_data', {
    p_company_id: companyId,
    p_store_id: storeId,
    p_as_of_date: asOfDate
})

await supabase.rpc('get_income_statement_data', {
    p_company_id: companyId,
    p_store_id: storeId,
    p_date_from: dateFrom,
    p_date_to: dateTo
})
```

#### HTML Structure:
```html
<div class="report-container">
    <header class="report-header">
        <h1>Financial Statements</h1>
        <div class="report-controls">
            <select id="storeSelector">
                <option value="">Headquarters (All Stores)</option>
            </select>
            <input type="date" id="asOfDate">
            <button id="generateReport" class="btn btn-primary">Generate</button>
            <button id="exportReport" class="btn btn-secondary">Export</button>
        </div>
    </header>
    
    <div class="report-tabs">
        <button class="tab-btn active" data-tab="balance-sheet">Balance Sheet</button>
        <button class="tab-btn" data-tab="income-statement">Income Statement</button>
    </div>
    
    <div class="report-content">
        <div id="balance-sheet" class="tab-content active">
            <table class="financial-table">
                <thead>
                    <tr>
                        <th>Account</th>
                        <th class="text-right">Amount</th>
                    </tr>
                </thead>
                <tbody id="balanceSheetBody"></tbody>
            </table>
        </div>
        
        <div id="income-statement" class="tab-content">
            <table class="financial-table">
                <thead>
                    <tr>
                        <th>Account</th>
                        <th class="text-right">Amount</th>
                    </tr>
                </thead>
                <tbody id="incomeStatementBody"></tbody>
            </table>
        </div>
    </div>
</div>
```

---

## 6. Configuration Pages

### Role & Permission Management
**URL**: `/roles.html`
**Purpose**: Manage system roles and permissions

#### Required APIs/RPC:
```javascript
// Role Management
await supabase.from('roles').select('*').eq('company_id', companyId)
await supabase.from('permissions').select('*')
await supabase.from('role_permissions').select('*').eq('role_id', roleId)

// Permission Assignment
await supabase.from('role_permissions').insert({
    role_id: roleId,
    permission_id: permissionId
})

// User Role Assignment
await supabase.from('user_roles').insert({
    user_id: userId,
    role_id: roleId,
    company_id: companyId
})
```

### Currency & Denomination Management
**URL**: `/currency.html`
**Purpose**: Manage currencies and denominations

#### Required APIs/RPC:
```javascript
// Currency Operations
await supabase.from('currency_types').select('*')
await supabase.from('denominations')
    .select('*')
    .eq('currency_id', currencyId)
    .order('value', { ascending: false })

// CRUD Operations
await supabase.from('currency_types').insert(currencyData)
await supabase.from('denominations').insert(denominationData)
await supabase.from('denominations').update(data).eq('id', id)
await supabase.from('denominations').delete().eq('id', id)
```

---

## 7. Attendance & Scheduling Pages

### Attendance Management
**URL**: `/attendance.html`
**Purpose**: Track employee attendance with QR scanning

#### Required APIs/RPC:
```javascript
// Attendance Records
await supabase.from('attendance_records').insert({
    employee_id: employeeId,
    check_in: checkInTime,
    check_out: checkOutTime,
    location: location
})

// QR Code Generation
await supabase.rpc('generate_attendance_qr', {
    p_employee_id: employeeId,
    p_date: date
})
```

### Timetable Management
**URL**: `/timetable.html`
**Purpose**: Manage employee schedules and shifts

#### Required APIs/RPC:
```javascript
// Schedule Management
await supabase.from('schedules').select('*').eq('store_id', storeId)
await supabase.from('employee_shifts').insert({
    employee_id: employeeId,
    schedule_id: scheduleId,
    start_time: startTime,
    end_time: endTime
})
```

---

## 8. Specialized Pages

### Fixed Asset Management
**URL**: `/fixed-assets.html`
**Purpose**: Track and manage company assets with depreciation

#### Required APIs/RPC:
```javascript
// Asset Management
await supabase.from('fixed_assets')
    .select(`
        *,
        category:asset_categories(name),
        location:stores(name)
    `)
    .eq('company_id', companyId)

// Depreciation Calculation
await supabase.rpc('calculate_depreciation', {
    p_asset_id: assetId,
    p_as_of_date: date
})
```

### Cash Location Management
**URL**: `/cash-locations.html`
**Purpose**: Manage cash handling locations and accounts

#### Required APIs/RPC:
```javascript
// Cash Location Operations
await supabase.from('cash_locations').select('*').eq('company_id', companyId)
await supabase.from('cash_accounts')
    .select('*')
    .eq('location_id', locationId)

// Balance Calculations
await supabase.rpc('get_cash_balances', {
    p_location_id: locationId,
    p_date: date
})
```

### Transaction Templates
**URL**: `/transaction-templates.html`
**Purpose**: Create and manage reusable transaction templates

#### Required APIs/RPC:
```javascript
// Template Management
await supabase.from('transaction_templates')
    .select('*')
    .eq('company_id', companyId)

// Template Usage
await supabase.rpc('apply_transaction_template', {
    p_template_id: templateId,
    p_transaction_date: date,
    p_store_id: storeId
})
```

---

## Component Usage Matrix

| Page | Components Used | Priority |
|------|----------------|----------|
| Login | InputField, Button, Alert | High |
| Dashboard | Card, Grid, Select, Sidebar | High |
| Transactions | Table, Filter, Pagination, DatePicker | High |
| Journal Entry | Form, Table, Select, Modal | High |
| Counter Party | Table, Modal, Form, Stats | Medium |
| Employees | Card, Table, Modal, Form | Medium |
| Balance Sheet | Table, DatePicker, Select, Tabs | Medium |
| Roles | Table, Checkbox, Tree, Modal | Low |
| Currency | Grid, Card, Modal, Form | Low |
| Attendance | Calendar, QRScanner, Table | Low |

---

## CSS Files Organization

```
assets/
└── css/
    └── main.css            # Global styles, resets

core/
└── themes/
    ├── toss-variables.css           # CSS variables
    ├── toss-component-variables.css # Component variables
    ├── toss-base.css               # Base styles
    └── toss-typography.css         # Typography styles

components/
├── base/
│   └── toss-button.css    # Button styles
├── form/
│   ├── toss-input.css     # Input styles
│   ├── toss-select.css    # Select styles
│   ├── toss-filter.css    # Filter styles
│   └── toss-store-filter.css # Store filter styles
├── feedback/
│   └── toss-alert.css     # Alert styles
├── layout/
│   └── toss-modal.css     # Modal styles
├── navigation/
│   └── navbar.css         # Navigation styles
└── data/
    └── toss-financial-section-header.css # Financial section styles

pages/
├── auth/assets/
│   └── login.css          # Login page styles
├── dashboard/widgets/
│   └── dashboard-widgets.css # Dashboard specific styles
└── finance/cash-ending/
    └── cash-ending.css    # Cash ending page styles
```

---

## JavaScript Module Organization

```
core/
├── config/
│   ├── supabase.js        # Supabase configuration
│   └── route-mapping.js   # Route mapping configuration
├── constants/
│   └── app-icons.js       # Icon system
├── utils/
│   ├── app-state.js       # State management
│   ├── page-init.js       # Page initialization
│   └── generate-pages.js  # Page generation utility
└── templates/
    └── page-template.html # Base page template

components/
├── base/
│   └── toss-button.js     # Button component
├── form/
│   ├── toss-input.js      # Input component
│   ├── toss-select.js     # Select component
│   ├── toss-filter.js     # Filter component
│   └── toss-store-filter.js # Store filter component
├── feedback/
│   └── toss-alert.js      # Alert component
├── layout/
│   └── toss-modal.js      # Modal component
├── navigation/
│   └── navbar.js          # Navigation component
└── data/
    └── toss-financial-section-header.js # Financial section component

pages/
├── auth/assets/
│   └── login.js           # Login page script
├── dashboard/widgets/
│   ├── dashboard-cards.js # Dashboard cards widget
│   └── dashboard-chart.js # Dashboard chart widget
└── finance/cash-ending/
    └── cash-ending-data.js # Cash ending page logic
```

---

## Implementation Priority

### Phase 1: Core Foundation (Week 1)
1. **Setup**: Project structure, Supabase config
2. **Auth**: Login, signup, session management
3. **Components**: Button, Input, Card, Modal
4. **Routing**: Basic SPA routing

### Phase 2: Essential Features (Week 2-3)
1. **Dashboard**: Homepage with navigation
2. **Transactions**: History view and filtering
3. **Journal Entry**: Basic transaction input
4. **Master Data**: Counter party management

### Phase 3: Business Features (Week 4-5)
1. **Employees**: Employee management
2. **Reports**: Balance sheet, income statement
3. **Currency**: Multi-currency support
4. **Templates**: Transaction templates

### Phase 4: Advanced Features (Week 6-7)
1. **Permissions**: Role-based access
2. **Attendance**: Time tracking
3. **Assets**: Fixed asset management
4. **Cash Management**: Cash locations

### Phase 5: Polish & Optimization (Week 8)
1. **Performance**: Code splitting, lazy loading
2. **UX**: Loading states, error handling
3. **Testing**: Unit and integration tests
4. **Deployment**: Production setup

---

This implementation guide provides the complete technical specifications for converting each Flutter page to its web equivalent using HTML, CSS, and JavaScript.