# MyFinance Web Components Library

## Based on Toss Design System

This component library provides all the UI components needed for the MyFinance web application, based on the Toss (토스) Korean fintech app's design patterns.

---

## 📁 Component Structure

```
website/
├── components/
│   ├── base/           # Core UI components
│   ├── form/           # Form inputs and controls
│   ├── layout/         # Layout components
│   ├── feedback/       # User feedback components
│   ├── data/           # Data display components
│   └── navigation/     # Navigation components
├── css/
│   └── theme/          # Toss design system styles
└── js/
    └── components/     # Component JavaScript
```

---

## 🎨 Theme System

### CSS Variables (`css/theme/toss-variables.css`)
- **Colors**: Primary blue (#0064FF), semantic colors, grayscale
- **Spacing**: 4px grid system (space-1 to space-24)
- **Typography**: Inter font family with defined scales
- **Shadows**: Ultra-subtle shadows (4-8% opacity)
- **Border Radius**: 8px default, various sizes available

### Typography (`css/theme/toss-typography.css`)
- Display, H1-H4 headings
- Body text (large, regular, small)
- Financial amounts (monospace)
- UI labels and captions

### Base Styles (`css/theme/toss-base.css`)
- CSS reset and normalization
- Layout utilities (flexbox, grid)
- Spacing utilities (padding, margin)
- Display and position utilities
- Responsive helpers

---

## 🧩 Available Components

### 1. Base Components

#### **Buttons** (`base/toss-button`)
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

<!-- Icon Button -->
<button class="toss-btn-icon">
  <svg><!-- icon --></svg>
</button>

<!-- Floating Action Button -->
<button class="toss-fab">
  <svg><!-- icon --></svg>
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

---

### 2. Navigation Components

#### **Top Navigation Bar** (`navigation/toss-navbar`)
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
    
    <!-- User Menu -->
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

#### **Sidebar Navigation**
```html
<aside class="toss-sidebar">
  <div class="toss-sidebar-header">
    <img src="logo.svg" class="toss-sidebar-logo">
    <span class="toss-sidebar-title">MyFinance</span>
  </div>
  
  <nav class="toss-sidebar-nav">
    <a href="#" class="toss-sidebar-item active">
      <svg class="toss-sidebar-icon"><!-- icon --></svg>
      <span class="toss-sidebar-text">Dashboard</span>
    </a>
    
    <!-- Collapsible Group -->
    <div class="toss-sidebar-group">
      <button class="toss-sidebar-group-header">
        <svg class="toss-sidebar-icon"><!-- icon --></svg>
        <span class="toss-sidebar-text">Transactions</span>
        <svg class="toss-sidebar-arrow"><!-- arrow --></svg>
      </button>
      <div class="toss-sidebar-group-content">
        <a href="#" class="toss-sidebar-subitem">History</a>
        <a href="#" class="toss-sidebar-subitem">Journal Entry</a>
      </div>
    </div>
  </nav>
</aside>
```

#### **Bottom Navigation (Mobile)**
```html
<nav class="toss-bottom-nav">
  <a href="#" class="toss-bottom-nav-item active">
    <svg><!-- icon --></svg>
    <span>Home</span>
  </a>
  <button class="toss-bottom-nav-fab">
    <svg><!-- plus icon --></svg>
  </button>
  <a href="#" class="toss-bottom-nav-item">
    <svg><!-- icon --></svg>
    <span>More</span>
  </a>
</nav>
```

#### **Tabs**
```html
<div class="toss-tabs">
  <button class="toss-tab active">Overview</button>
  <button class="toss-tab">Details</button>
  <button class="toss-tab">History</button>
  <div class="toss-tab-indicator"></div>
</div>
```

#### **Breadcrumbs**
```html
<nav class="toss-breadcrumb">
  <a href="#" class="toss-breadcrumb-item">Home</a>
  <span class="toss-breadcrumb-separator">/</span>
  <a href="#" class="toss-breadcrumb-item">Transactions</a>
  <span class="toss-breadcrumb-separator">/</span>
  <span class="toss-breadcrumb-current">History</span>
</nav>
```

---

### 3. Form Components (To Be Created)

#### **Text Input**
```html
<div class="toss-input-group">
  <label class="toss-label">Email Address</label>
  <input type="email" class="toss-input" placeholder="Enter email">
  <span class="toss-error">Invalid email address</span>
</div>
```

#### **Select/Dropdown**
```html
<div class="toss-select-group">
  <label class="toss-label">Country</label>
  <select class="toss-select">
    <option>Select a country</option>
    <option>United States</option>
    <option>South Korea</option>
  </select>
</div>
```

#### **Checkbox**
```html
<label class="toss-checkbox">
  <input type="checkbox">
  <span class="toss-checkbox-mark"></span>
  <span>Remember me</span>
</label>
```

#### **Radio Button**
```html
<label class="toss-radio">
  <input type="radio" name="option">
  <span class="toss-radio-mark"></span>
  <span>Option 1</span>
</label>
```

#### **Search Field**
```html
<div class="toss-search">
  <svg class="toss-search-icon"><!-- search icon --></svg>
  <input type="search" class="toss-search-input" placeholder="Search...">
  <button class="toss-search-clear">×</button>
</div>
```

---

### 4. Layout Components (To Be Created)

#### **Card**
```html
<div class="toss-card">
  <div class="toss-card-header">
    <h3 class="toss-card-title">Card Title</h3>
  </div>
  <div class="toss-card-body">
    Card content goes here
  </div>
  <div class="toss-card-footer">
    <button class="toss-btn toss-btn-primary">Action</button>
  </div>
</div>
```

#### **Modal/Dialog**
```html
<div class="toss-modal">
  <div class="toss-modal-backdrop"></div>
  <div class="toss-modal-content">
    <div class="toss-modal-header">
      <h2 class="toss-modal-title">Modal Title</h2>
      <button class="toss-modal-close">×</button>
    </div>
    <div class="toss-modal-body">
      Modal content
    </div>
    <div class="toss-modal-footer">
      <button class="toss-btn toss-btn-secondary">Cancel</button>
      <button class="toss-btn toss-btn-primary">Confirm</button>
    </div>
  </div>
</div>
```

#### **Bottom Sheet**
```html
<div class="toss-bottom-sheet">
  <div class="toss-bottom-sheet-handle"></div>
  <div class="toss-bottom-sheet-content">
    <!-- Content -->
  </div>
</div>
```

---

### 5. Feedback Components (To Be Created)

#### **Toast/Snackbar**
```html
<div class="toss-toast toss-toast-success">
  <svg class="toss-toast-icon"><!-- icon --></svg>
  <span>Operation successful!</span>
  <button class="toss-toast-close">×</button>
</div>
```

#### **Alert**
```html
<div class="toss-alert toss-alert-info">
  <svg class="toss-alert-icon"><!-- icon --></svg>
  <div class="toss-alert-content">
    <strong>Information:</strong> This is an informational message.
  </div>
</div>
```

#### **Loading States**
```html
<!-- Loading Overlay -->
<div class="toss-loading-overlay">
  <div class="toss-spinner-large"></div>
</div>

<!-- Skeleton Loading -->
<div class="toss-skeleton">
  <div class="toss-skeleton-line"></div>
  <div class="toss-skeleton-line short"></div>
</div>
```

#### **Empty State**
```html
<div class="toss-empty">
  <svg class="toss-empty-icon"><!-- icon --></svg>
  <h3 class="toss-empty-title">No Data</h3>
  <p class="toss-empty-text">There are no items to display.</p>
  <button class="toss-btn toss-btn-primary">Add Item</button>
</div>
```

---

### 6. Data Display Components (To Be Created)

#### **Table**
```html
<table class="toss-table">
  <thead>
    <tr>
      <th>Name</th>
      <th>Amount</th>
      <th>Status</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Transaction 1</td>
      <td class="amount">$100.00</td>
      <td><span class="toss-badge toss-badge-success">Completed</span></td>
    </tr>
  </tbody>
</table>
```

#### **List**
```html
<ul class="toss-list">
  <li class="toss-list-item">
    <div class="toss-list-content">
      <div class="toss-list-title">Item Title</div>
      <div class="toss-list-subtitle">Item description</div>
    </div>
    <div class="toss-list-action">
      <button class="toss-btn-icon">
        <svg><!-- icon --></svg>
      </button>
    </div>
  </li>
</ul>
```

#### **Chip/Tag**
```html
<span class="toss-chip">Tag</span>
<span class="toss-chip toss-chip-primary">Primary</span>
<span class="toss-chip toss-chip-removable">
  Removable
  <button class="toss-chip-remove">×</button>
</span>
```

---

## 🚀 Getting Started

### 1. Include CSS Files
```html
<!-- Theme CSS -->
<link rel="stylesheet" href="/css/theme/toss-variables.css">
<link rel="stylesheet" href="/css/theme/toss-base.css">
<link rel="stylesheet" href="/css/theme/toss-typography.css">

<!-- Component CSS -->
<link rel="stylesheet" href="/components/base/toss-button.css">
<link rel="stylesheet" href="/components/navigation/toss-navbar.css">
<!-- Add other component CSS as needed -->
```

### 2. Include JavaScript
```html
<!-- Component JavaScript -->
<script src="/components/base/toss-button.js"></script>
<script src="/components/navigation/toss-navbar.js"></script>
<!-- Add other component JS as needed -->
```

### 3. Initialize Components
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

---

## 📱 Responsive Design

All components are mobile-first and responsive:

- **Mobile** (< 768px): Bottom navigation, collapsed sidebar, full-width buttons
- **Tablet** (768px - 1023px): Top navigation, collapsible sidebar
- **Desktop** (≥ 1024px): Full navigation, expanded sidebar, optimal spacing

---

## 🎯 Design Principles

1. **Minimalist**: Clean, white-dominant interface
2. **Toss Blue**: Strategic use of primary color (#0064FF)
3. **4px Grid**: All spacing follows 4px grid system
4. **Ultra-subtle Shadows**: 4-8% opacity shadows for depth
5. **High Contrast**: Clear hierarchy for financial clarity
6. **Trust Through Consistency**: Predictable interactions

---

## 📝 Component Status

### ✅ Completed Components
- [x] Button Component (with all variants)
- [x] Navigation Bar
- [x] Sidebar Navigation
- [x] Bottom Navigation
- [x] Tabs
- [x] Breadcrumbs
- [x] Theme System (CSS Variables, Typography, Base)

### 🚧 To Be Created
- [ ] Form Components (Input, Select, Checkbox, Radio, Search)
- [ ] Layout Components (Card, Modal, Bottom Sheet)
- [ ] Feedback Components (Toast, Alert, Loading, Empty State)
- [ ] Data Display Components (Table, List, Chip)
- [ ] Advanced Selectors (Multi-select, Date Picker, Time Picker)
- [ ] Charts and Graphs
- [ ] File Upload
- [ ] Progress Indicators

---

## 🔧 Utility Classes

### Spacing
- `p-{0-6}`: Padding (0-24px)
- `m-{0-6}`: Margin (0-24px)
- `gap-{1-6}`: Gap for flex/grid (4-24px)

### Display
- `flex`, `inline-flex`, `grid`, `block`, `inline`, `hidden`
- `flex-col`, `flex-row`, `items-center`, `justify-between`

### Typography
- `text-{size}`: Font sizes
- `font-{weight}`: Font weights
- `text-{color}`: Text colors

### Colors
- `bg-{color}`: Background colors
- `text-{color}`: Text colors
- `border-{color}`: Border colors

---

## 📚 Resources

- [Toss Design System](https://toss.im) - Original inspiration
- [Component Examples](components/) - Individual component implementations
- [Integration Guide](../WEB_DESIGN_PLAN.md) - Full implementation guide

---

## 🤝 Contributing

When creating new components:
1. Follow the Toss design system principles
2. Use CSS variables for all values
3. Ensure mobile-first responsive design
4. Include both CSS and JavaScript files
5. Document usage in this index

---

This component library provides a solid foundation for building the MyFinance web application with a modern, clean, and professional interface inspired by Toss's successful design patterns.