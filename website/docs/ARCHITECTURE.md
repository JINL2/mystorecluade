# MyFinance Web Application Architecture

## Overview
MyFinance is a modern financial management web application built with a component-based architecture. The application follows a clear separation of concerns between common reusable components and page-specific widgets.

## Directory Structure

```
website/
├── components/               # Common reusable components
│   ├── navigation/          # Navigation components
│   │   ├── navbar.js        # Main navigation bar component
│   │   └── navbar.css       # Navigation styles
│   ├── base/                # Base UI components
│   │   ├── toss-button.js   # Button component
│   │   └── toss-button.css  # Button styles
│   ├── feedback/            # Feedback components
│   │   ├── toss-alert.js    # Alert/toast component
│   │   └── toss-alert.css   # Alert styles
│   ├── form/                # Form components
│   │   ├── toss-input.js    # Input field component
│   │   ├── toss-input.css   # Input styles
│   │   ├── toss-select.js   # Select/dropdown component
│   │   ├── toss-select.css  # Select styles
│   │   ├── toss-filter.js   # Filter component
│   │   ├── toss-filter.css  # Filter styles
│   │   ├── toss-store-filter.js  # Store filter component
│   │   └── toss-store-filter.css # Store filter styles
│   ├── data/                # Data display components
│   │   ├── toss-financial-section-header.js  # Financial section header
│   │   ├── toss-financial-section-header.css # Section header styles
│   │   └── toss-income-statement-table.css   # Income statement table styles
│   └── layout/              # Layout components
│       ├── toss-modal.js    # Modal component
│       └── toss-modal.css   # Modal styles
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
│   ├── templates/          # Page templates
│   │   └── page-template.html          # Base page template
│   └── utils/              # Utility functions
│       ├── app-state.js    # Application state management
│       ├── page-init.js    # Page initialization utility
│       └── generate-pages.js # Page generation utility
│
├── assets/                  # Static assets
│   ├── css/                # Global styles
│   │   └── main.css        # Main stylesheet
│   ├── fonts/              # Font files
│   └── images/             # Image assets
│
├── pages/                   # Application pages
│   ├── auth/               # Authentication pages
│   │   ├── login.html      # Login/signup page
│   │   └── assets/         # Auth page assets
│   │       ├── login.js    # Login page script
│   │       └── login.css   # Login page styles
│   ├── dashboard/          # Dashboard page
│   │   ├── index.html      # Main dashboard page
│   │   └── widgets/        # Page-specific components
│   │       ├── dashboard-cards.js      # Financial overview cards
│   │       ├── dashboard-chart.js      # Spending chart widget
│   │       └── dashboard-widgets.css   # Dashboard-specific styles
│   ├── finance/            # Finance pages
│   │   ├── balance-sheet/
│   │   │   └── index.html
│   │   ├── income-statement/
│   │   │   └── index.html
│   │   ├── journal-input/
│   │   │   └── index.html
│   │   ├── transaction-history/
│   │   │   └── index.html
│   │   └── cash-ending/
│   │       ├── index.html
│   │       ├── cash-ending.css
│   │       └── cash-ending-data.js
│   ├── employee/           # Employee pages
│   │   ├── schedule/
│   │   │   └── index.html
│   │   ├── employee-setting/
│   │   │   └── index.html
│   │   └── salary/
│   │       └── index.html
│   ├── marketing/          # Marketing pages
│   │   └── marketing-plan/
│   │       └── index.html
│   ├── product/            # Product pages
│   │   └── inventory/
│   │       └── index.html
│   └── settings/           # Settings pages
│       ├── account-mapping/
│       │   └── index.html
│       ├── company-store/
│       │   └── index.html
│       ├── counterparty/
│       │   └── index.html
│       └── currency/
│           └── index.html
│
├── docs/                    # Documentation
│   ├── ARCHITECTURE.md     # This file
│   ├── README.md           # Main documentation
│   ├── PAGE_IMPLEMENTATION_GUIDE.md # Page implementation guide
│   └── WEB_DESIGN_PLAN.md  # Web design specifications
│
└── index.html              # Entry point (redirects to login)
```

## Architecture Principles

### 1. Component-Based Architecture
The application follows a strict component-based architecture with two types of components:

#### Common Components (`/components`)
- **Purpose**: Reusable across multiple pages
- **Examples**: Navigation bar, buttons, alerts, form inputs
- **Characteristics**:
  - Self-contained with their own JS and CSS files
  - No page-specific logic
  - Configurable through options/props
  - Follow Toss design system guidelines

#### Page Widgets (`/pages/[page]/widgets`)
- **Purpose**: Page-specific functionality
- **Examples**: Dashboard cards, spending charts, transaction lists
- **Characteristics**:
  - Specific to a single page
  - Can use common components
  - Contain business logic specific to the page
  - May interact with APIs directly

### 2. Design System Integration
The application uses the Toss design system (Korean fintech design pattern):
- **Variables**: Consistent colors, spacing, typography defined in CSS variables
- **Components**: Follow Toss design patterns for consistency
- **Icons**: Custom icon system converted from Flutter app

### 3. Authentication & Security
- **Supabase Integration**: Handles authentication and database operations
- **Session Management**: Automatic session handling with auth state listeners
- **Protected Routes**: Dashboard and other pages check authentication status
- **Secure Storage**: No sensitive data stored in localStorage except session tokens

## Component Documentation

### Navigation Component (`components/navigation/navbar.js`)
**Purpose**: Provides consistent navigation across all pages with company selection

**Features**:
- Dynamic menu items with dropdown support
- Company selector with automatic data fetching
- User profile display
- Sign out functionality
- Active page highlighting
- Responsive design
- Persistent company selection across sessions

**Usage**:
```javascript
const navBar = new NavBar({
    containerId: 'navbar-container',
    activeItem: 'dashboard',
    user: {
        name: 'John Doe',
        email: 'john@example.com'
    }
});
navBar.init();
```

**Configuration Options**:
- `containerId`: ID of the container element
- `activeItem`: Currently active navigation item
- `user`: User object with name and email
- `onSignOut`: Custom sign out handler

**Company Selection**:
- Uses the reusable TossSelect component for consistent UI
- Automatically fetches user companies via `get_user_companies_and_stores` RPC
- Stores selected company in localStorage as `companyChoosen`
- Stores full user data in localStorage as `user`
- Triggers `companyChanged` event when selection changes
- Persists selection across browser sessions
- Searchable when more than 5 companies available

### Dashboard Widgets

#### Dashboard Cards (`pages/dashboard/widgets/dashboard-cards.js`)
**Purpose**: Display financial overview metrics

**Features**:
- Animated value updates
- Real-time data refresh
- Responsive grid layout
- Change indicators (positive/negative)

#### Dashboard Chart (`pages/dashboard/widgets/dashboard-chart.js`)
**Purpose**: Visualize spending breakdown

**Features**:
- Interactive doughnut chart using Chart.js
- Customizable data and colors
- Responsive design
- Tooltips with percentages

## Data Flow

```
User → Page → Widgets → Supabase API
         ↓
    Navigation
         ↓
    Common Components
```

1. **User Interaction**: User interacts with the page
2. **Page Logic**: Page handles routing and initializes widgets
3. **Widget Logic**: Widgets fetch and display data
4. **API Calls**: Supabase handles data operations
5. **Component Rendering**: Common components provide UI elements

## Navigation Structure

The application uses a hierarchical navigation structure:

```
Dashboard (Home)
├── Product
│   └── Inventory
├── Marketing
│   └── Marketing Plan
├── Finance
│   ├── Balance Sheet
│   ├── Income Statement
│   ├── Journal Input
│   ├── Transaction History
│   └── Cash Ending
├── Employee
│   ├── Schedule
│   ├── Employee Setting
│   └── Salary
└── Setting
    ├── Currency
    ├── Company & Store Setting
    ├── Account Mapping
    └── Counterparty
```

### Select Component (`components/form/toss-select.js`)
**Purpose**: Reusable dropdown/select component following Toss design system

**Features**:
- Single and multiple selection modes
- Searchable options
- Custom option descriptions
- Loading and empty states
- Keyboard navigation support
- Customizable sizes and widths
- Accessible ARIA attributes

**Usage**:
```javascript
const select = new TossSelect({
    containerId: 'select-container',
    options: [
        { value: '1', label: 'Option 1', description: 'Description' },
        { value: '2', label: 'Option 2' }
    ],
    value: '1',
    placeholder: 'Select an option',
    onChange: (value, option) => { ... }
});
select.init();
```

**Configuration Options**:
- `containerId`: Container element ID
- `value`: Selected value(s)
- `options`: Array of option objects
- `placeholder`: Placeholder text
- `searchable`: Enable search functionality
- `multiple`: Enable multiple selection
- `size`: Component size (sm, default, lg)
- `width`: Component width (default, full, inline)
- `onChange`: Change event handler

## Icon System

The application uses a custom icon system (`core/constants/app-icons.js`) converted from the Flutter app:
- **SVG Icons**: Custom SVG generation for scalable icons
- **Font Awesome**: Integration with Font Awesome icons
- **Dynamic Sizing**: Icons can be sized and colored dynamically

**Usage**:
```javascript
// Get Won sign icon
AppIcons.getSVG('wonSign', { 
    size: 20, 
    color: 'white' 
});
```

## State Management

The application uses a simple state management approach following the MyFinance app state pattern:

### Core App States (stored in localStorage)
1. **`user`**: Complete user data from `get_user_companies_and_stores` RPC
   - User profile information
   - Companies array with full details
   - Stores array per company
   - Role and permissions

2. **`companyChoosen`**: Currently selected company ID
   - Persisted across sessions
   - Used for filtering data throughout app
   - Updated via navigation bar company selector

3. **`storeChoosen`**: Currently selected store ID (if applicable)
   - Persisted across sessions
   - Filtered based on selected company

4. **`categoryFeatures`**: Categories and features (when implemented)
   - From `get_categories_with_features` RPC
   - Used for dynamic navigation

### State Management Flow
```javascript
// On page load
1. Check authentication (Supabase)
2. Fetch user companies via RPC
3. Store in localStorage
4. Load persisted company selection
5. Update UI components

// On company change
1. Update localStorage
2. Trigger companyChanged event
3. Reload page-specific data
4. Update all dependent components
```

### Session Management
- **Session State**: Managed by Supabase auth
- **Component State**: Each component manages its own state
- **Page State**: Pages coordinate between widgets
- **Persistent State**: Key selections stored in localStorage

## Performance Considerations

1. **Lazy Loading**: Components loaded only when needed
2. **Efficient Updates**: DOM updates minimized through targeted element updates
3. **Caching**: Supabase handles API response caching
4. **Animation**: CSS transitions for smooth UI updates
5. **Responsive Images**: Icons use SVG for scalability

## Security Best Practices

1. **Authentication**: All protected pages check auth status
2. **API Keys**: Supabase anon key is public-safe
3. **XSS Prevention**: No innerHTML with user content
4. **HTTPS**: Always use secure connections
5. **Session Management**: Automatic token refresh

## Development Guidelines

### Adding a New Page
1. Create folder in `/pages/[pagename]/`
2. Create `index.html` for the page
3. Create `/widgets/` folder for page-specific components (if needed)
4. Use common navigation component
5. Follow existing page structure

### Creating a Common Component
1. Create component in appropriate `/components/` subfolder
2. Include both `.js` and `.css` files
3. Make it configurable through options
4. Document usage in this file
5. Add to `components/COMPONENT_INDEX.md`

### Creating a Page Widget
1. Create in `/pages/[page]/widgets/`
2. Name clearly (e.g., `dashboard-cards.js`)
3. Can depend on common components
4. Should be specific to that page only

## File Path Quick Reference

### Theme System:
- **CSS Variables**: `core/themes/toss-variables.css`
- **Typography**: `core/themes/toss-typography.css`
- **Base Styles**: `core/themes/toss-base.css`
- **Component Variables**: `core/themes/toss-component-variables.css`
- **Main CSS**: `assets/css/main.css`

### Current Components:
- **Buttons**: `components/base/toss-button.js` & `toss-button.css`
- **Navigation**: `components/navigation/navbar.js` & `navbar.css`
- **Forms**: `components/form/` (toss-input, toss-select, toss-filter, toss-store-filter)
- **Alerts**: `components/feedback/toss-alert.js` & `toss-alert.css`
- **Modals**: `components/layout/toss-modal.js` & `toss-modal.css`
- **Data Display**: `components/data/` (financial section headers)

### Live Pages:
- **Landing Page**: `index.html`
- **Login Page**: `pages/auth/login.html`
- **Dashboard**: `pages/dashboard/index.html`
- **Finance Pages**: `pages/finance/` (balance-sheet, income-statement, cash-ending, etc.)
- **Employee Pages**: `pages/employee/` (schedule, employee-setting, salary)
- **Settings Pages**: `pages/settings/` (account-mapping, company-store, counterparty, currency)
- **Component Documentation**: `components/COMPONENT_INDEX.md`

### Documentation:
- **Component Index**: `components/COMPONENT_INDEX.md`
- **Architecture**: `docs/ARCHITECTURE.md` (this file)
- **Design Plan**: `docs/WEB_DESIGN_PLAN.md`
- **Page Specs**: `docs/PAGE_IMPLEMENTATION_GUIDE.md`
- **Main README**: `docs/README.md`

## Testing Strategy

1. **Component Testing**: Test components within their page implementations
2. **Integration Testing**: Test full pages with real data
3. **Authentication Testing**: Test with/without auth
4. **Responsive Testing**: Test on multiple screen sizes
5. **Browser Testing**: Ensure compatibility with modern browsers

## Deployment Considerations

1. **File Structure**: Maintain structure for easy deployment
2. **CDN Usage**: Libraries loaded from CDN for performance
3. **Minification**: Minify JS/CSS for production
4. **Environment Variables**: Use for API endpoints
5. **Error Handling**: Comprehensive error handling with user feedback

## Future Enhancements

1. **Build System**: Add webpack/vite for bundling
2. **TypeScript**: Convert to TypeScript for type safety
3. **Testing Framework**: Add Jest/Mocha for unit tests
4. **Accessibility**: Enhance WCAG compliance
5. **PWA**: Convert to Progressive Web App
6. **Internationalization**: Add multi-language support
7. **State Management**: Consider Zustand if complexity grows
8. **Component Library**: Document with Storybook

## Maintenance

### Regular Tasks
- Update dependencies monthly
- Review and optimize performance quarterly
- Security audit bi-annually
- User feedback integration ongoing

### Version Control
- Use semantic versioning
- Tag releases appropriately
- Maintain changelog
- Document breaking changes

## Conclusion

This architecture provides a scalable, maintainable foundation for the MyFinance application. The separation between common components and page widgets ensures code reusability while maintaining flexibility for page-specific requirements. The integration with Supabase provides robust authentication and data management capabilities.
