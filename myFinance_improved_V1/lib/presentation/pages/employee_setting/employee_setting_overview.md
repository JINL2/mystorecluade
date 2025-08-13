# Employee Setting Page Overview

## Purpose
The Employee Setting page provides comprehensive employee salary management functionality, allowing managers and administrators to view, manage, and update employee compensation information within their organization.

## Core Functionality

### 1. Employee Salary List
- Display all employees with their current salary information
- Filter employees by company/store
- Search functionality to find specific employees
- Real-time data synchronization with Supabase

### 2. Employee Information Display
- Profile picture
- Full name
- Role/position
- Current salary amount with currency symbol
- Employment type (monthly/hourly)

### 3. Salary Management
- Edit individual employee salaries
- Update salary type (monthly/hourly)
- Change currency
- Modify salary amount
- Audit trail for salary changes

## User Roles & Permissions

### Admin/Manager
- View all employee salaries
- Edit salary information
- View salary history
- Export salary data

### Employee
- No access to this page (redirect to dashboard)

## Page States

### Loading States
- Initial data load
- Search/filter operations
- Salary update operations
- Data refresh/sync

### Empty States
- No employees found
- No search results
- No employees in selected filter

### Error States
- Network connection issues
- Permission denied
- Failed salary updates
- Invalid data format

## Data Flow

### On Page Load
1. Verify user permissions
2. Load company/store context
3. Fetch employee salary data
4. Initialize search/filter states

### On Search/Filter
1. Update search query
2. Apply filters (debounced)
3. Refresh employee list
4. Update UI state

### On Salary Edit
1. Open edit modal/sheet
2. Load current salary details
3. Validate input data
4. Submit changes to Supabase
5. Show success/error feedback
6. Refresh employee list

## Performance Considerations

### Optimization Strategies
- Lazy loading for large employee lists
- Debounced search (300ms)
- Cached profile images
- Optimistic UI updates
- Background data sync

### Data Pagination
- Load 20 employees initially
- Infinite scroll for more
- Virtual scrolling for 100+ employees

## Accessibility

### Keyboard Navigation
- Tab through employee cards
- Enter to edit salary
- Escape to close modals
- Arrow keys for list navigation

### Screen Reader Support
- Descriptive labels for all actions
- Salary change announcements
- Error message announcements
- Loading state announcements

## Security Considerations

### Data Protection
- Role-based access control
- Salary data encryption
- Audit logging for all changes
- Session timeout for sensitive operations

### Input Validation
- Salary amount limits
- Currency validation
- Prevent SQL injection
- XSS protection

## Integration Points

### Supabase Tables/Views
- `v_user_salary` - Main employee salary view
- `currency_types` - Available currencies
- `salary_history` - Change audit trail
- `user_roles` - Permission management

### API Endpoints
- `updateUserSalary` - Update employee salary
- `getSalaryHistory` - Fetch change history
- `exportSalaryData` - Generate reports

### Related Pages
- Employee Profile → View detailed employee info
- Payroll Management → Process payments
- Reports → Salary analytics
- Settings → Currency configuration