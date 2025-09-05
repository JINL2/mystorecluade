# Salary Management Page - Design Specification

## Overview
Modern, Toss-style salary dashboard for managing employee compensation and payroll with clean, minimal interface focused on clarity and usability.

## Design Principles

### 1. **Toss Design Philosophy**
- **Minimalist Interface**: Clean white backgrounds with subtle shadows
- **Strategic Color Usage**: Toss Blue (#0064FF) for primary actions and highlights
- **High Contrast**: Clear distinction between elements for financial clarity
- **Trust Through Consistency**: Uniform design patterns across components

### 2. **Information Hierarchy**
- **Summary First**: Key metrics displayed prominently at the top
- **Progressive Disclosure**: Details revealed through expandable cards
- **Contextual Information**: Related data grouped logically
- **Visual Indicators**: Color-coded status and quick-glance stats

## Key Features

### Header Section
- **Title & Subtitle**: Clear page identification
- **Period Selector**: Month navigation with previous/next controls
- **Responsive Layout**: Adapts to screen size

### Summary Cards
- **Total Employees**: Count with trend indicator
- **Total Payment**: Highlighted in primary color
- **Overtime Hours**: Performance metric
- **Unsolved Problems**: Warning indicator
- **Hover Effects**: Subtle lift animation for interactivity

### Filter Bar
- **Search Input**: Real-time employee name search
- **Filter Chips**: Quick filters for employee types and status
  - All Employees (default)
  - Monthly/Hourly
  - Has Problems
  - Overtime
- **Active State**: Visual feedback for selected filter

### Employee Cards

#### Collapsed State
- **Employee Avatar**: Initials with colored background
- **Basic Information**:
  - Name and salary type badge
  - Total payment amount
  - Store assignments
- **Quick Stats**: At-a-glance metrics
  - Late count
  - Overtime hours
  - Problems/Bonus
- **Expand Indicator**: Chevron icon for expansion

#### Expanded State
- **Salary Breakdown Table**:
  - Base payment calculation
  - Deductions (late penalties)
  - Additions (overtime, bonuses)
  - Total payment with emphasis
- **Store Assignments**: All assigned stores
- **Problems Section** (if applicable):
  - Date, type, and store
  - Status badges (Solved/Pending)
  - Visual indicators (color-coded borders)

### Visual Design Elements

#### Color Scheme
- **Primary**: Toss Blue (#0064FF)
- **Success**: Green (#00C896) - Positive values
- **Warning**: Orange (#FF9500) - Attention needed
- **Error**: Red (#FF5847) - Negative values
- **Neutral**: Gray scale for UI elements

#### Typography
- **Headings**: Bold, large size for hierarchy
- **Values**: Emphasized with size and weight
- **Labels**: Secondary color for context
- **Badges**: Small, uppercase for categorization

#### Spacing & Layout
- **4px Grid System**: Consistent spacing units
- **Card-Based Layout**: Organized content blocks
- **Responsive Grid**: Auto-adjusting columns
- **White Space**: Breathing room for clarity

## Responsive Design

### Desktop (>768px)
- **4-Column Summary Grid**: All metrics visible
- **Horizontal Filter Bar**: Search and chips inline
- **Side-by-side Information**: Employee details spread horizontally

### Tablet (768px - 480px)
- **2-Column Summary Grid**: Paired metrics
- **Stacked Filter Bar**: Search above chips
- **Adjusted Employee Cards**: Vertical stack for info

### Mobile (<480px)
- **Single Column Layout**: Full-width cards
- **Hidden Store Badges**: Shown only when expanded
- **Compact Typography**: Smaller font sizes
- **Touch-Optimized**: Larger tap targets

## Interaction States

### Loading State
- **Skeleton Screens**: Animated placeholders
- **Progressive Loading**: Content appears as available

### Empty State
- **Informative Message**: Clear explanation
- **Visual Icon**: Friendly illustration
- **Action Guidance**: Next steps for user

### Hover States
- **Cards**: Subtle shadow elevation
- **Buttons**: Background color change
- **Chips**: Darker background shade

### Active States
- **Filter Chips**: Primary color highlight
- **Expanded Cards**: Rotation of chevron icon
- **Search Input**: Primary color border

## Performance Optimizations

### CSS Techniques
- **CSS Variables**: Centralized theming
- **Transitions**: Smooth animations (0.2s)
- **Transform**: Hardware-accelerated animations
- **Will-change**: Optimized for animations

### JavaScript Optimizations
- **Event Delegation**: Efficient event handling
- **Debouncing**: Search input optimization
- **Lazy Loading**: Load data as needed
- **Virtual Scrolling**: (Future) For large lists

## Accessibility Features

### Keyboard Navigation
- **Tab Order**: Logical flow through elements
- **Focus Indicators**: Visible focus states
- **Enter/Space**: Activate expandable cards

### Screen Readers
- **Semantic HTML**: Proper heading structure
- **ARIA Labels**: Descriptive labels for icons
- **Status Messages**: Announce state changes

### Visual Accessibility
- **High Contrast**: WCAG AA compliance
- **Color Independence**: Not relying solely on color
- **Readable Fonts**: Minimum 14px base size

## Future Enhancements

### Data Visualization
- **Charts**: Salary trends over time
- **Comparisons**: Month-over-month analysis
- **Distribution**: Employee type breakdowns

### Advanced Filters
- **Date Range**: Custom period selection
- **Multiple Stores**: Store-specific filtering
- **Salary Range**: Min/max salary filters
- **Problem Types**: Specific issue filtering

### Export Features
- **PDF Reports**: Formatted payroll documents
- **Excel Export**: Spreadsheet downloads
- **Email Integration**: Direct salary slips

### Batch Operations
- **Multi-select**: Handle multiple employees
- **Bulk Actions**: Apply changes to groups
- **Approval Workflow**: Manager review process

## Implementation Notes

### Data Structure
Follows the provided RPC response format with:
- Company and period information
- Employee arrays with salary details
- Summary statistics
- Problem tracking

### Integration Points
- **Supabase RPC**: `get_salary_data` function
- **State Management**: Uses appState utility
- **Navigation**: Integrated with navbar component
- **Theming**: Uses Toss design system variables

### Code Organization
- **Modular CSS**: Organized by component sections
- **Utility Classes**: Reusable helper styles
- **Functional JavaScript**: Clean, purpose-driven functions
- **Comments**: Clear section markers