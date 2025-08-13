# Counter Party Management Design Specification

## 📋 Overview

The Counter Party Management page allows users to manage business relationships including suppliers, customers, employees, internal teams, and other companies that interact with their business. This is a critical feature for tracking financial transactions, managing business contacts, and maintaining inter-company relationships.

## 🎯 Purpose & Business Value

### Why We Need This Page
1. **Transaction Management**: Track who you do business with for accurate accounting
2. **Relationship Management**: Maintain organized records of business contacts
3. **Inter-Company Linking**: Connect multiple companies within the same business group
4. **Financial Categorization**: Properly categorize transactions by counterparty type
5. **Audit Trail**: Maintain records of all business relationships for compliance

### Target Users
- Business owners managing multiple companies
- Accountants tracking transactions
- HR managers managing employee records
- Procurement teams managing suppliers
- Sales teams managing customers

## 🏗️ Architecture

### Page Structure
```
counter_party/
├── counter_party_page.dart          # Main page with list view
├── models/
│   └── counter_party_models.dart    # Data models
├── providers/
│   └── counter_party_providers.dart # State management
└── widgets/
    ├── counter_party_list_item.dart # List item widget
    ├── counter_party_form.dart      # Create/Edit form
    └── counter_party_filter.dart    # Filter/Search widget
```

## 💾 Data Model

### CounterParty Entity
```dart
class CounterParty {
  final String counterpartyId;
  final String companyId;
  final String name;
  final CounterPartyType type;
  final String? email;
  final String? phone;
  final String? address;
  final String? notes;
  final bool isInternal;
  final String? linkedCompanyId;
  final String? createdBy;
  final DateTime createdAt;
  final bool isDeleted;
}

enum CounterPartyType {
  myCompany('My Company'),
  teamMember('Team Member'),
  supplier('Suppliers'),
  employee('Employees'),
  customer('Customers'),
  other('Others');
}
```

## 🎨 UI/UX Design (Toss Style)

### Design Principles
1. **Minimalist Interface**: Clean, white-space focused design
2. **Card-Based Layout**: Each counterparty as a distinct card
3. **Smooth Animations**: 200-300ms transitions
4. **Typography First**: Clear visual hierarchy
5. **Single Primary Action**: One main CTA per screen

### Page Layout

#### 1. App Bar
- **Style**: Simple, clean with minimal height
- **Left**: Back navigation arrow
- **Title**: "Counter Party" (center-aligned)
- **Right**: Filter icon + Add button

#### 2. Stats Summary Card
```
┌─────────────────────────────────────────┐
│  Total: 156                             │
│  ┌──────────┬──────────┬──────────┐    │
│  │Suppliers │Customers │Employees │    │
│  │    45    │    78    │    23    │    │
│  └──────────┴──────────┴──────────┘    │
└─────────────────────────────────────────┘
```

#### 3. Search & Filter Bar
- **Search Field**: Full-width with icon
- **Filter Chips**: Type, Status, Date Range
- **Sort Options**: Name, Type, Recent

#### 4. Counter Party List
```
┌─────────────────────────────────────────┐
│ [Icon] ABC Suppliers Co.                │
│        Supplier • abc@email.com         │
│        Last transaction: 2 days ago     │
│                              [Edit] [→]  │
└─────────────────────────────────────────┘
```

#### 5. Floating Action Button
- **Position**: Bottom right
- **Icon**: Plus (+)
- **Color**: Primary blue (#0066FF)
- **Action**: Opens create form

### Create/Edit Form (Bottom Sheet)

#### Form Fields
1. **Name** (Required)
   - Text input with validation
   - Placeholder: "Enter counterparty name"

2. **Type** (Required)
   - Dropdown with icons
   - Options: My Company, Team Member, Suppliers, Employees, Customers, Others

3. **Is Internal Company?**
   - Toggle switch
   - Shows company selector when enabled

4. **Contact Information**
   - Email (with validation)
   - Phone (with formatting)
   - Address (multiline)

5. **Notes**
   - Multiline text area
   - Character counter

6. **Actions**
   - Cancel (secondary)
   - Save (primary)

### Color Scheme (Toss Style)
```dart
// Primary Actions
primary: Color(0xFF0066FF)      // Toss blue
primaryLight: Color(0xFF4D94FF)

// Status Colors
success: Color(0xFF22C55E)      // Active/Verified
warning: Color(0xFFF59E0B)      // Pending
error: Color(0xFFEF4444)        // Inactive/Error

// Background
background: Color(0xFFFFFFFF)   // Pure white
surface: Color(0xFFFBFBFB)      // Card background

// Text
textPrimary: Color(0xFF171717)  // Main text
textSecondary: Color(0xFF737373) // Secondary text
```

### Typography
```dart
// Headers
h1: 24px, w600 (Page title)
h2: 20px, w600 (Section headers)

// Body
body: 15px, w400 (Regular text)
bodySmall: 13px, w400 (Secondary info)

// Labels
label: 13px, w500 (Form labels)
caption: 11px, w400 (Helper text)
```

### Spacing System
```dart
space1: 4px   // Minimal
space2: 8px   // Tight
space3: 12px  // Small
space4: 16px  // Default
space5: 20px  // Medium
space6: 24px  // Large
```

## 🔄 State Management

### Providers
```dart
// List of counterparties
counterPartiesProvider
  ├── Fetches from Supabase
  ├── Filters by company
  └── Caches results

// Selected counterparty
selectedCounterPartyProvider
  └── For edit operations

// Filter state
counterPartyFilterProvider
  ├── Search query
  ├── Type filter
  └── Sort order

// Form state
counterPartyFormProvider
  ├── Form validation
  ├── Submission state
  └── Error handling
```

## 🗄️ Database Integration

### Supabase Tables
```sql
-- counterparties table
CREATE TABLE counterparties (
  counterparty_id UUID PRIMARY KEY,
  company_id UUID REFERENCES companies(company_id),
  name TEXT NOT NULL,
  type TEXT,
  email TEXT,
  phone TEXT,
  address TEXT,
  notes TEXT,
  is_internal BOOLEAN DEFAULT false,
  linked_company_id UUID,
  created_by UUID,
  created_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT false
);
```

### RPC Functions
```sql
-- Get unlinked companies for internal linking
CREATE FUNCTION get_unlinked_companies(
  p_user_id UUID,
  p_company_id UUID
) RETURNS TABLE(...);

-- Get counterparty statistics
CREATE FUNCTION get_counterparty_stats(
  p_company_id UUID
) RETURNS JSON;
```

## 🚦 User Flow

### Main Flow
1. User navigates to Counter Party from homepage
2. Sees list of existing counterparties
3. Can search/filter the list
4. Tap on item to view details
5. Tap FAB to create new
6. Fill form and save
7. Returns to updated list

### Create Flow
```
[FAB] → [Bottom Sheet Form] → [Validation] → [Save] → [Success] → [List Update]
```

### Edit Flow
```
[List Item] → [Detail View] → [Edit Button] → [Form] → [Save] → [Update]
```

## 📱 Responsive Design

### Mobile (Default)
- Single column list
- Full-width cards
- Bottom sheet forms

### Tablet
- Two-column grid option
- Side panel for details
- Modal dialogs for forms

## ⚡ Performance Optimization

1. **Lazy Loading**: Load 20 items at a time
2. **Search Debouncing**: 300ms delay
3. **Optimistic Updates**: Update UI before server confirms
4. **Caching**: Cache list for 5 minutes
5. **Skeleton Loading**: Show placeholders while loading

## 🔒 Security & Validation

### Field Validation
- **Name**: Required, 2-100 characters
- **Email**: Valid email format
- **Phone**: Valid phone format
- **Type**: Must be from enum

### Permissions
- View: All users with company access
- Create: Users with write permission
- Edit: Users with write permission
- Delete: Admin only (soft delete)

## 📊 Analytics Events

Track these events:
- `counterparty_page_viewed`
- `counterparty_created`
- `counterparty_edited`
- `counterparty_deleted`
- `counterparty_searched`
- `counterparty_filtered`

## 🎯 Success Metrics

1. **Page Load Time**: < 2 seconds
2. **Search Response**: < 500ms
3. **Form Submission**: < 1 second
4. **Error Rate**: < 1%
5. **User Completion Rate**: > 90%

## 🔄 Future Enhancements

1. **Bulk Import**: CSV/Excel import
2. **Export**: Download as CSV/PDF
3. **Duplicate Detection**: Auto-detect similar names
4. **Activity History**: Track all changes
5. **Document Attachments**: Attach contracts/documents
6. **API Integration**: Sync with external CRM
7. **Smart Suggestions**: AI-powered data entry

## 📝 Implementation Checklist

- [ ] Create page structure and routing
- [ ] Implement data models
- [ ] Set up Riverpod providers
- [ ] Design list view with cards
- [ ] Create bottom sheet form
- [ ] Add search functionality
- [ ] Implement filters
- [ ] Add form validation
- [ ] Connect to Supabase
- [ ] Add loading states
- [ ] Implement error handling
- [ ] Add success feedback
- [ ] Test on different devices
- [ ] Add analytics tracking
- [ ] Document API usage