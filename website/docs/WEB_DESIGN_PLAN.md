# MyFinance Web Application Design Plan

## 🎯 Project Overview

This document outlines the complete web implementation plan for converting the MyFinance Flutter application to a modern web application using HTML, CSS, and JavaScript (no PHP). The application is a comprehensive financial management system with multi-tenant architecture, role-based permissions, and extensive business functionality.

---

## 📊 System Architecture

### Technology Stack
- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Styling**: Custom CSS with CSS Variables for theming
- **State Management**: Custom JavaScript state manager
- **API Communication**: Fetch API with Supabase JavaScript Client
- **Build Tools**: Webpack/Vite for bundling
- **Backend**: Supabase (existing)

### Directory Structure
```
website/
├── index.html
├── assets/
│   ├── css/
│   │   └── main.css
│   ├── images/
│   └── fonts/
├── components/
│   ├── base/
│   │   ├── toss-button.js
│   │   └── toss-button.css
│   ├── form/
│   │   ├── toss-input.js
│   │   ├── toss-select.js
│   │   ├── toss-filter.js
│   │   └── toss-store-filter.js
│   ├── feedback/
│   │   ├── toss-alert.js
│   │   └── toss-alert.css
│   ├── layout/
│   │   ├── toss-modal.js
│   │   └── toss-modal.css
│   ├── navigation/
│   │   ├── navbar.js
│   │   └── navbar.css
│   └── data/
│       └── toss-financial-section-header.js
├── core/
│   ├── config/
│   │   ├── supabase.js
│   │   └── route-mapping.js
│   ├── constants/
│   │   └── app-icons.js
│   ├── themes/
│   │   ├── toss-variables.css
│   │   ├── toss-typography.css
│   │   ├── toss-base.css
│   │   └── toss-component-variables.css
│   ├── utils/
│   │   ├── app-state.js
│   │   ├── page-init.js
│   │   └── generate-pages.js
│   └── templates/
│       └── page-template.html
├── pages/
│   ├── auth/
│   │   ├── login.html
│   │   └── assets/
│   ├── dashboard/
│   │   ├── index.html
│   │   └── widgets/
│   ├── finance/
│   │   ├── balance-sheet/
│   │   ├── income-statement/
│   │   ├── cash-ending/
│   │   └── transaction-history/
│   ├── employee/
│   ├── marketing/
│   ├── product/
│   └── settings/
└── docs/
    ├── ARCHITECTURE.md
    ├── README.md
    ├── PAGE_IMPLEMENTATION_GUIDE.md
    └── WEB_DESIGN_PLAN.md
```

---

## 🧩 Core Components Design

### 1. Base Components

#### Button Component
```javascript
// components/Button.js
class Button {
  constructor(options) {
    this.text = options.text;
    this.variant = options.variant || 'primary'; // primary, secondary, danger, success
    this.size = options.size || 'medium'; // small, medium, large
    this.onClick = options.onClick;
    this.icon = options.icon;
    this.loading = options.loading || false;
  }
  
  render() {
    return `
      <button class="btn btn-${this.variant} btn-${this.size}" 
              ${this.loading ? 'disabled' : ''}>
        ${this.icon ? `<i class="${this.icon}"></i>` : ''}
        ${this.loading ? '<span class="spinner"></span>' : this.text}
      </button>
    `;
  }
}
```

#### Card Component
```javascript
// components/Card.js
class Card {
  constructor(options) {
    this.title = options.title;
    this.content = options.content;
    this.actions = options.actions || [];
    this.elevated = options.elevated || false;
  }
  
  render() {
    return `
      <div class="card ${this.elevated ? 'card-elevated' : ''}">
        ${this.title ? `<div class="card-header">${this.title}</div>` : ''}
        <div class="card-body">${this.content}</div>
        ${this.actions.length ? 
          `<div class="card-actions">${this.actions.join('')}</div>` : ''}
      </div>
    `;
  }
}
```

#### Modal Component
```javascript
// components/Modal.js
class Modal {
  constructor(options) {
    this.id = options.id;
    this.title = options.title;
    this.content = options.content;
    this.size = options.size || 'medium'; // small, medium, large, fullscreen
    this.onClose = options.onClose;
  }
  
  show() {
    document.getElementById(this.id).classList.add('modal-visible');
  }
  
  hide() {
    document.getElementById(this.id).classList.remove('modal-visible');
    if (this.onClose) this.onClose();
  }
  
  render() {
    return `
      <div id="${this.id}" class="modal">
        <div class="modal-backdrop" onclick="modal.hide('${this.id}')"></div>
        <div class="modal-content modal-${this.size}">
          <div class="modal-header">
            <h3>${this.title}</h3>
            <button class="modal-close" onclick="modal.hide('${this.id}')">&times;</button>
          </div>
          <div class="modal-body">${this.content}</div>
        </div>
      </div>
    `;
  }
}
```

### 2. Form Components

#### Input Field Component
```javascript
// components/InputField.js
class InputField {
  constructor(options) {
    this.type = options.type || 'text';
    this.name = options.name;
    this.label = options.label;
    this.placeholder = options.placeholder;
    this.value = options.value || '';
    this.required = options.required || false;
    this.validation = options.validation;
    this.error = options.error;
  }
  
  render() {
    return `
      <div class="form-group">
        ${this.label ? `<label for="${this.name}">${this.label}
          ${this.required ? '<span class="required">*</span>' : ''}</label>` : ''}
        <input type="${this.type}" 
               name="${this.name}" 
               id="${this.name}"
               class="form-control ${this.error ? 'error' : ''}"
               placeholder="${this.placeholder || ''}"
               value="${this.value}"
               ${this.required ? 'required' : ''}>
        ${this.error ? `<span class="error-message">${this.error}</span>` : ''}
      </div>
    `;
  }
}
```

#### Select Component
```javascript
// components/Select.js
class Select {
  constructor(options) {
    this.name = options.name;
    this.label = options.label;
    this.options = options.options; // [{value, text}]
    this.value = options.value;
    this.multiple = options.multiple || false;
    this.searchable = options.searchable || false;
  }
  
  render() {
    return `
      <div class="form-group">
        ${this.label ? `<label for="${this.name}">${this.label}</label>` : ''}
        <select name="${this.name}" 
                id="${this.name}"
                class="form-control ${this.searchable ? 'select-searchable' : ''}"
                ${this.multiple ? 'multiple' : ''}>
          ${this.options.map(opt => 
            `<option value="${opt.value}" ${opt.value === this.value ? 'selected' : ''}>
              ${opt.text}
            </option>`
          ).join('')}
        </select>
      </div>
    `;
  }
}
```

### 3. Data Display Components

#### Table Component
```javascript
// components/Table.js
class Table {
  constructor(options) {
    this.columns = options.columns; // [{key, label, sortable, width}]
    this.data = options.data;
    this.actions = options.actions; // [{icon, onClick, tooltip}]
    this.pagination = options.pagination;
    this.searchable = options.searchable || false;
    this.selectable = options.selectable || false;
  }
  
  render() {
    return `
      <div class="table-container">
        ${this.searchable ? this.renderSearch() : ''}
        <table class="table">
          <thead>${this.renderHeader()}</thead>
          <tbody>${this.renderRows()}</tbody>
        </table>
        ${this.pagination ? this.renderPagination() : ''}
      </div>
    `;
  }
}
```

### 4. Navigation Components

#### Sidebar Component
```javascript
// components/Sidebar.js
class Sidebar {
  constructor(options) {
    this.items = options.items; // [{icon, text, route, children}]
    this.collapsed = options.collapsed || false;
    this.user = options.user;
  }
  
  render() {
    return `
      <aside class="sidebar ${this.collapsed ? 'sidebar-collapsed' : ''}">
        <div class="sidebar-header">
          <img src="/assets/images/logo.svg" alt="MyFinance">
          ${!this.collapsed ? '<span>MyFinance</span>' : ''}
        </div>
        <nav class="sidebar-nav">
          ${this.items.map(item => this.renderMenuItem(item)).join('')}
        </nav>
        <div class="sidebar-footer">
          ${this.renderUserInfo()}
        </div>
      </aside>
    `;
  }
}
```

---

## 📄 Page Specifications

### 1. Authentication Pages

#### Login Page (`/login`)
**Components Used**: InputField, Button, Card
**API Calls**: 
- `POST /auth/login` - User authentication
**Features**:
- Email/password validation
- Remember me checkbox
- Forgot password link
- Social login options (future)

```javascript
// pages/auth/assets/login.js
class LoginPage {
  constructor() {
    this.form = {
      email: '',
      password: '',
      rememberMe: false
    };
  }
  
  async handleLogin(e) {
    e.preventDefault();
    const { data, error } = await supabase.auth.signInWithPassword({
      email: this.form.email,
      password: this.form.password
    });
    if (error) {
      showError(error.message);
    } else {
      router.navigate('/dashboard');
    }
  }
  
  render() {
    return `
      <div class="auth-container">
        <div class="auth-card">
          <h1>Welcome Back</h1>
          <form onsubmit="loginPage.handleLogin(event)">
            ${new InputField({
              type: 'email',
              name: 'email',
              label: 'Email',
              required: true
            }).render()}
            ${new InputField({
              type: 'password',
              name: 'password',
              label: 'Password',
              required: true
            }).render()}
            <div class="form-group">
              <label>
                <input type="checkbox" name="rememberMe"> Remember me
              </label>
            </div>
            ${new Button({
              text: 'Sign In',
              variant: 'primary',
              type: 'submit'
            }).render()}
          </form>
          <div class="auth-links">
            <a href="/forgot-password">Forgot password?</a>
            <a href="/signup">Create account</a>
          </div>
        </div>
      </div>
    `;
  }
}
```

### 2. Dashboard/Homepage (`/`)
**Components Used**: Card, Button, Table, Select
**API Calls**:
- `get_user_companies_and_stores()` - Load user context
- `get_categories_with_features()` - Load available features
**Features**:
- Company/store selector
- Feature grid with permissions
- Quick actions
- Recent transactions
- Statistics cards

### 3. Transaction Management Pages

#### Transaction History (`/transactions`)
**Components Used**: Table, FilterPanel, DatePicker, Select, Button
**API Calls**:
- `get_transaction_history()` - Paginated transaction list
- `get_transaction_filter_options()` - Filter dropdown data
**Features**:
- Advanced filtering (date, account, counterparty)
- Pagination with infinite scroll
- Search functionality
- Export options

#### Journal Entry (`/journal-entry`)
**Components Used**: Form, Table, Select, InputField, Modal
**API Calls**:
- Account list queries
- Transaction posting
**Features**:
- Double-entry input
- Auto-balancing
- Template usage
- Validation

### 4. Master Data Management

#### Counter Party Management (`/counterparty`)
**Components Used**: Table, Modal, Form, FilterPanel
**API Calls**:
- CRUD operations on counterparties table
- `get_unlinked_companies()` 
- `update_counterparty()`
**Features**:
- Six counter party types
- Search and filter
- Batch operations
- Statistics dashboard

#### Employee Management (`/employees`)
**Components Used**: Card, Table, Modal, Form
**API Calls**:
- Employee CRUD operations
- Salary management
- Role assignments
**Features**:
- Employee cards with details
- Salary editing
- Role management
- Department filtering

### 5. Financial Reports

#### Balance Sheet (`/balance-sheet`)
**Components Used**: Table, DatePicker, Select, Card
**API Calls**:
- Financial data queries
- Store-specific filtering
**Features**:
- Dual-tab interface (Balance Sheet & Income Statement)
- Date range selection
- Store filtering
- Export to Excel/PDF

### 6. Configuration Pages

#### Role & Permissions (`/roles`)
**Components Used**: Table, Checkbox, Modal, Tree
**API Calls**:
- Role management operations
- Permission matrix updates
**Features**:
- Permission matrix
- Role hierarchy
- User assignment

#### Currency & Denominations (`/currency`)
**Components Used**: Grid, Card, Modal, Form
**API Calls**:
- Currency CRUD
- Denomination management
**Features**:
- Multi-currency support
- Denomination grid
- Exchange rates

---

## 🔄 State Management Design

### Global State Manager
```javascript
// core/utils/app-state.js
class StateManager {
  constructor() {
    this.state = {
      user: null,
      company: null,
      store: null,
      permissions: [],
      theme: 'light',
      language: 'en'
    };
    this.subscribers = {};
  }
  
  subscribe(key, callback) {
    if (!this.subscribers[key]) {
      this.subscribers[key] = [];
    }
    this.subscribers[key].push(callback);
  }
  
  setState(key, value) {
    this.state[key] = value;
    if (this.subscribers[key]) {
      this.subscribers[key].forEach(cb => cb(value));
    }
  }
  
  getState(key) {
    return this.state[key];
  }
}

const state = new StateManager();
```

---

## 🛣️ Routing System

### Client-Side Router
```javascript
// core/config/route-mapping.js
class Router {
  constructor() {
    this.routes = {};
    this.currentRoute = null;
    window.addEventListener('popstate', () => this.handleRoute());
  }
  
  register(path, handler) {
    this.routes[path] = handler;
  }
  
  navigate(path) {
    window.history.pushState({}, '', path);
    this.handleRoute();
  }
  
  handleRoute() {
    const path = window.location.pathname;
    const handler = this.routes[path] || this.routes['/404'];
    if (handler) {
      this.currentRoute = path;
      document.getElementById('app').innerHTML = handler();
    }
  }
}

const router = new Router();
```

---

## 🔌 API Integration Layer

### Supabase Configuration
```javascript
// core/config/supabase.js
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'YOUR_SUPABASE_URL';
const supabaseKey = 'YOUR_SUPABASE_ANON_KEY';

export const supabase = createClient(supabaseUrl, supabaseKey);
```

### API Service Base Class
```javascript
// services/BaseService.js
class BaseService {
  constructor(tableName) {
    this.table = tableName;
  }
  
  async getAll(filters = {}) {
    let query = supabase.from(this.table).select('*');
    Object.keys(filters).forEach(key => {
      query = query.eq(key, filters[key]);
    });
    return await query;
  }
  
  async getById(id) {
    return await supabase.from(this.table)
      .select('*')
      .eq('id', id)
      .single();
  }
  
  async create(data) {
    return await supabase.from(this.table)
      .insert(data)
      .select();
  }
  
  async update(id, data) {
    return await supabase.from(this.table)
      .update(data)
      .eq('id', id)
      .select();
  }
  
  async delete(id) {
    return await supabase.from(this.table)
      .update({ deleted_at: new Date() })
      .eq('id', id);
  }
}
```

### RPC Function Calls
```javascript
// api/rpc.js
class RPCService {
  async call(functionName, params = {}) {
    const { data, error } = await supabase.rpc(functionName, params);
    if (error) {
      console.error(`RPC Error (${functionName}):`, error);
      throw error;
    }
    return data;
  }
  
  // Specific RPC functions
  async getUserCompaniesAndStores() {
    return this.call('get_user_companies_and_stores');
  }
  
  async getCategoriesWithFeatures(companyId) {
    return this.call('get_categories_with_features', { p_company_id: companyId });
  }
  
  async getTransactionHistory(params) {
    return this.call('get_transaction_history', params);
  }
  
  async getTransactionFilterOptions(params) {
    return this.call('get_transaction_filter_options', params);
  }
}

const rpc = new RPCService();
```

---

## 🎨 CSS Design System

### CSS Variables (Theme)
```css
/* core/themes/toss-variables.css */
:root {
  /* Colors */
  --primary-color: #4F46E5;
  --secondary-color: #10B981;
  --danger-color: #EF4444;
  --warning-color: #F59E0B;
  --info-color: #3B82F6;
  --success-color: #10B981;
  
  /* Neutrals */
  --gray-50: #F9FAFB;
  --gray-100: #F3F4F6;
  --gray-200: #E5E7EB;
  --gray-300: #D1D5DB;
  --gray-400: #9CA3AF;
  --gray-500: #6B7280;
  --gray-600: #4B5563;
  --gray-700: #374151;
  --gray-800: #1F2937;
  --gray-900: #111827;
  
  /* Typography */
  --font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
  --font-size-xs: 0.75rem;
  --font-size-sm: 0.875rem;
  --font-size-base: 1rem;
  --font-size-lg: 1.125rem;
  --font-size-xl: 1.25rem;
  --font-size-2xl: 1.5rem;
  --font-size-3xl: 1.875rem;
  
  /* Spacing */
  --spacing-xs: 0.25rem;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
  --spacing-lg: 1.5rem;
  --spacing-xl: 2rem;
  --spacing-2xl: 3rem;
  
  /* Border Radius */
  --radius-sm: 0.25rem;
  --radius-md: 0.375rem;
  --radius-lg: 0.5rem;
  --radius-xl: 0.75rem;
  --radius-full: 9999px;
  
  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
  
  /* Transitions */
  --transition-fast: 150ms ease-in-out;
  --transition-base: 250ms ease-in-out;
  --transition-slow: 350ms ease-in-out;
}

/* Dark Theme */
[data-theme="dark"] {
  --bg-primary: var(--gray-900);
  --bg-secondary: var(--gray-800);
  --text-primary: var(--gray-100);
  --text-secondary: var(--gray-300);
}
```

### Component Styles
```css
/* components/base/toss-button.css */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: var(--spacing-sm) var(--spacing-md);
  font-size: var(--font-size-base);
  font-weight: 500;
  border-radius: var(--radius-md);
  border: 1px solid transparent;
  cursor: pointer;
  transition: all var(--transition-fast);
  gap: var(--spacing-xs);
}

.btn-primary {
  background-color: var(--primary-color);
  color: white;
  border-color: var(--primary-color);
}

.btn-primary:hover {
  background-color: #4338CA;
  transform: translateY(-1px);
  box-shadow: var(--shadow-md);
}

.btn-secondary {
  background-color: white;
  color: var(--gray-700);
  border-color: var(--gray-300);
}

.btn-small {
  padding: var(--spacing-xs) var(--spacing-sm);
  font-size: var(--font-size-sm);
}

.btn-large {
  padding: var(--spacing-md) var(--spacing-lg);
  font-size: var(--font-size-lg);
}

/* Loading spinner */
.spinner {
  display: inline-block;
  width: 1em;
  height: 1em;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: white;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
```

---

## 📱 Responsive Design

### Breakpoints
```css
/* Breakpoints */
:root {
  --screen-sm: 640px;
  --screen-md: 768px;
  --screen-lg: 1024px;
  --screen-xl: 1280px;
  --screen-2xl: 1536px;
}

/* Mobile First Approach */
.container {
  width: 100%;
  padding: var(--spacing-md);
}

@media (min-width: 640px) {
  .container { max-width: 640px; }
}

@media (min-width: 768px) {
  .container { max-width: 768px; }
  .sidebar { display: block; }
}

@media (min-width: 1024px) {
  .container { max-width: 1024px; }
}

@media (min-width: 1280px) {
  .container { max-width: 1280px; }
}
```

---

## 🚀 Implementation Phases

### Phase 1: Foundation (Week 1-2)
1. **Setup & Configuration**
   - Project structure setup
   - Build tool configuration
   - Supabase integration
   - Basic routing system

2. **Core Components**
   - Base components (Button, Card, Modal)
   - Form components (Input, Select, Checkbox)
   - Layout components (Header, Sidebar, Footer)

3. **Authentication**
   - Login page
   - Signup page
   - Password reset
   - Auth state management

### Phase 2: Core Features (Week 3-4)
1. **Dashboard**
   - Homepage layout
   - Company/store selector
   - Feature grid
   - Quick actions

2. **Master Data**
   - Counter party management
   - Employee management
   - Basic CRUD operations

3. **Transaction Module**
   - Transaction history
   - Basic filtering
   - Journal entry form

### Phase 3: Advanced Features (Week 5-6)
1. **Financial Reports**
   - Balance sheet
   - Income statement
   - Report filters

2. **Configuration**
   - Role management
   - Permission matrix
   - Currency setup

3. **Advanced Components**
   - Data tables with pagination
   - Advanced filters
   - Charts and graphs

### Phase 4: Polish & Optimization (Week 7-8)
1. **Performance**
   - Code splitting
   - Lazy loading
   - Caching strategies

2. **User Experience**
   - Loading states
   - Error handling
   - Animations

3. **Testing & Deployment**
   - Unit tests
   - Integration tests
   - Deployment setup

---

## 🔒 Security Considerations

### Client-Side Security
1. **Input Validation**: All forms validated before submission
2. **XSS Prevention**: Sanitize all user inputs
3. **CSRF Protection**: Token-based protection
4. **Secure Storage**: Use secure storage for sensitive data

### API Security
1. **Row Level Security**: Implemented in Supabase
2. **Rate Limiting**: Prevent API abuse
3. **Authentication**: JWT-based auth
4. **Authorization**: Role-based access control

---

## 📈 Performance Optimizations

### Loading Strategies
1. **Code Splitting**: Split by routes
2. **Lazy Loading**: Load components on demand
3. **Resource Hints**: Preload, prefetch critical resources
4. **Service Workers**: Offline capability

### Optimization Techniques
1. **Minification**: HTML, CSS, JavaScript
2. **Compression**: Gzip/Brotli
3. **Image Optimization**: WebP format, lazy loading
4. **Caching**: Browser cache, CDN

---

## 🧪 Testing Strategy

### Unit Testing
- Component testing with Jest
- Service layer testing
- Utility function testing

### Integration Testing
- API integration tests
- User flow testing
- Cross-browser testing

### E2E Testing
- Critical user journeys
- Payment flows
- Report generation

---

## 📚 Documentation Requirements

### Code Documentation
- JSDoc for all functions
- Component usage examples
- API documentation

### User Documentation
- User guide
- Admin guide
- API reference

---

## 🎯 Success Metrics

### Performance Metrics
- Page load time < 3 seconds
- Time to Interactive < 5 seconds
- Lighthouse score > 90

### User Experience Metrics
- Task completion rate > 95%
- Error rate < 1%
- User satisfaction score > 4.5/5

### Technical Metrics
- Code coverage > 80%
- Bundle size < 500KB (initial)
- Zero critical security vulnerabilities

---

## 📅 Timeline Summary

- **Week 1-2**: Foundation & Core Components
- **Week 3-4**: Core Features Implementation
- **Week 5-6**: Advanced Features & Reports
- **Week 7-8**: Polish, Testing & Deployment

Total estimated time: 8 weeks for MVP

---

## 🔄 Next Steps

1. **Immediate Actions**:
   - Set up development environment
   - Initialize project structure
   - Configure build tools
   - Set up Supabase connection

2. **Priority Features**:
   - Authentication system
   - Dashboard
   - Transaction management
   - Basic reporting

3. **Technical Decisions**:
   - Choose bundler (Webpack vs Vite)
   - Select testing framework
   - Decide on deployment platform

---

This comprehensive design plan provides a complete roadmap for converting the MyFinance Flutter application to a modern web application using HTML, CSS, and JavaScript.