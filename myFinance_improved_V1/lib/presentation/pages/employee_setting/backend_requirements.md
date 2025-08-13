# Backend Requirements & Supabase Integration

## Database Schema

### Tables

#### 1. `users` (existing)
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  profile_image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 2. `user_roles` (existing)
```sql
CREATE TABLE user_roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  store_id UUID REFERENCES stores(id) ON DELETE SET NULL,
  role_name TEXT NOT NULL,
  permissions JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 3. `user_salaries`
```sql
CREATE TABLE user_salaries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  salary_amount DECIMAL(12,2) NOT NULL,
  salary_type TEXT CHECK (salary_type IN ('monthly', 'hourly')) NOT NULL,
  currency_id TEXT REFERENCES currency_types(currency_id),
  effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_active BOOLEAN DEFAULT true
);
```

#### 4. `currency_types`
```sql
CREATE TABLE currency_types (
  currency_id TEXT PRIMARY KEY, -- e.g., 'USD', 'EUR', 'JPY'
  currency_name TEXT NOT NULL,
  symbol TEXT NOT NULL,
  decimal_places INTEGER DEFAULT 2,
  is_active BOOLEAN DEFAULT true
);
```

#### 5. `salary_history`
```sql
CREATE TABLE salary_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  salary_id UUID REFERENCES user_salaries(id),
  user_id UUID REFERENCES users(id),
  previous_amount DECIMAL(12,2),
  new_amount DECIMAL(12,2),
  previous_type TEXT,
  new_type TEXT,
  previous_currency TEXT,
  new_currency TEXT,
  changed_by UUID REFERENCES users(id),
  change_reason TEXT,
  changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Views

#### 1. `v_user_salary` (Main View)
```sql
CREATE VIEW v_user_salary AS
SELECT 
  us.id as salary_id,
  u.id as user_id,
  u.full_name,
  u.email,
  u.profile_image_url as profile_image,
  ur.role_name,
  ur.company_id,
  ur.store_id,
  us.salary_amount,
  us.salary_type,
  us.currency_id,
  ct.currency_name,
  ct.symbol,
  us.effective_date,
  us.is_active,
  us.updated_at
FROM users u
JOIN user_roles ur ON u.id = ur.user_id
LEFT JOIN user_salaries us ON u.id = us.user_id AND us.is_active = true
LEFT JOIN currency_types ct ON us.currency_id = ct.currency_id
WHERE ur.is_active = true;
```

## Supabase Queries

### 1. Fetch Employee Salaries
```dart
// Provider
final employeeSalaryListProvider = FutureProvider.family<List<EmployeeSalary>, String>((ref, companyId) async {
  final supabase = Supabase.instance.client;
  
  final response = await supabase
    .from('v_user_salary')
    .select()
    .eq('company_id', companyId)
    .order('full_name', ascending: true);
    
  return (response as List).map((e) => EmployeeSalary.fromJson(e)).toList();
});
```

### 2. Search Employees
```dart
// Search with debounce
final searchEmployeesProvider = FutureProvider.family<List<EmployeeSalary>, SearchParams>((ref, params) async {
  final supabase = Supabase.instance.client;
  
  var query = supabase
    .from('v_user_salary')
    .select()
    .eq('company_id', params.companyId);
    
  if (params.searchQuery.isNotEmpty) {
    query = query.or('full_name.ilike.%${params.searchQuery}%,role_name.ilike.%${params.searchQuery}%');
  }
  
  if (params.storeId != null) {
    query = query.eq('store_id', params.storeId);
  }
  
  final response = await query.order('full_name', ascending: true);
  
  return (response as List).map((e) => EmployeeSalary.fromJson(e)).toList();
});
```

### 3. Update Employee Salary
```dart
// RPC Function
CREATE OR REPLACE FUNCTION update_user_salary(
  p_salary_id UUID,
  p_salary_amount DECIMAL,
  p_salary_type TEXT,
  p_currency_id TEXT,
  p_user_id UUID
) RETURNS JSON AS $$
DECLARE
  v_result JSON;
  v_previous RECORD;
BEGIN
  -- Get previous values
  SELECT * INTO v_previous FROM user_salaries WHERE id = p_salary_id;
  
  -- Update salary
  UPDATE user_salaries
  SET 
    salary_amount = p_salary_amount,
    salary_type = p_salary_type,
    currency_id = p_currency_id,
    updated_at = NOW()
  WHERE id = p_salary_id
  RETURNING to_json(user_salaries.*) INTO v_result;
  
  -- Log history
  INSERT INTO salary_history (
    salary_id, user_id, 
    previous_amount, new_amount,
    previous_type, new_type,
    previous_currency, new_currency,
    changed_by
  ) VALUES (
    p_salary_id, v_previous.user_id,
    v_previous.salary_amount, p_salary_amount,
    v_previous.salary_type, p_salary_type,
    v_previous.currency_id, p_currency_id,
    p_user_id
  );
  
  RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### 4. Fetch Currency Types
```dart
final currencyTypesProvider = FutureProvider<List<CurrencyType>>((ref) async {
  final supabase = Supabase.instance.client;
  
  final response = await supabase
    .from('currency_types')
    .select()
    .eq('is_active', true)
    .order('currency_name', ascending: true);
    
  return (response as List).map((e) => CurrencyType.fromJson(e)).toList();
});
```

## Data Models

### 1. EmployeeSalary Model
```dart
class EmployeeSalary {
  final String salaryId;
  final String userId;
  final String fullName;
  final String email;
  final String? profileImage;
  final String roleName;
  final String companyId;
  final String? storeId;
  final double salaryAmount;
  final String salaryType;
  final String currencyId;
  final String currencyName;
  final String symbol;
  final DateTime effectiveDate;
  final bool isActive;
  final DateTime updatedAt;
  
  // Constructor, fromJson, toJson, copyWith methods...
}
```

### 2. CurrencyType Model
```dart
class CurrencyType {
  final String currencyId;
  final String currencyName;
  final String symbol;
  final int decimalPlaces;
  final bool isActive;
  
  // Constructor, fromJson, toJson methods...
}
```

### 3. SalaryUpdateRequest Model
```dart
class SalaryUpdateRequest {
  final String salaryId;
  final double salaryAmount;
  final String salaryType;
  final String currencyId;
  final String? changeReason;
  
  // Constructor, toJson method...
}
```

## API Integration

### 1. Update Salary Service
```dart
class SalaryService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  Future<void> updateSalary(SalaryUpdateRequest request) async {
    try {
      final response = await _supabase.rpc(
        'update_user_salary',
        params: {
          'p_salary_id': request.salaryId,
          'p_salary_amount': request.salaryAmount,
          'p_salary_type': request.salaryType,
          'p_currency_id': request.currencyId,
          'p_user_id': _supabase.auth.currentUser!.id,
        },
      );
      
      if (response.error != null) {
        throw Exception(response.error!.message);
      }
    } catch (e) {
      throw Exception('Failed to update salary: $e');
    }
  }
}
```

## Row Level Security (RLS)

### 1. View Permissions
```sql
-- v_user_salary view permissions
CREATE POLICY "view_employee_salaries" ON v_user_salary
  FOR SELECT
  USING (
    -- User can view if they are admin/manager in the company
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_id = auth.uid()
      AND company_id = v_user_salary.company_id
      AND role_name IN ('admin', 'manager', 'owner')
    )
  );
```

### 2. Update Permissions
```sql
-- user_salaries update permissions
CREATE POLICY "update_employee_salaries" ON user_salaries
  FOR UPDATE
  USING (
    -- User can update if they are admin/manager
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_id = auth.uid()
      AND company_id = user_salaries.company_id
      AND role_name IN ('admin', 'manager', 'owner')
    )
  );
```

## Real-time Subscriptions

### 1. Salary Updates Subscription
```dart
final salaryUpdatesSubscription = StreamProvider.family<List<EmployeeSalary>, String>((ref, companyId) {
  final supabase = Supabase.instance.client;
  
  return supabase
    .from('v_user_salary')
    .stream(primaryKey: ['salary_id'])
    .eq('company_id', companyId)
    .map((data) => data.map((e) => EmployeeSalary.fromJson(e)).toList());
});
```

## Error Handling

### Error Types
```dart
enum SalaryErrorType {
  networkError,
  permissionDenied,
  invalidAmount,
  currencyNotFound,
  employeeNotFound,
  duplicateSalary,
}

class SalaryException implements Exception {
  final SalaryErrorType type;
  final String message;
  final dynamic originalError;
  
  SalaryException({
    required this.type,
    required this.message,
    this.originalError,
  });
}
```

## Performance Optimizations

### 1. Indexes
```sql
-- Performance indexes
CREATE INDEX idx_user_salaries_company ON user_salaries(company_id);
CREATE INDEX idx_user_salaries_user ON user_salaries(user_id);
CREATE INDEX idx_user_salaries_active ON user_salaries(is_active);
CREATE INDEX idx_user_roles_company ON user_roles(company_id);
CREATE INDEX idx_salary_history_salary ON salary_history(salary_id);
```

### 2. Caching Strategy
- Cache currency types for 24 hours
- Cache employee list for 5 minutes
- Invalidate cache on salary updates
- Use optimistic updates for better UX

## Migration Scripts

### Initial Setup
```sql
-- Run these migrations in order
-- 1. Create tables
-- 2. Create views
-- 3. Create RPC functions
-- 4. Set up RLS policies
-- 5. Create indexes
-- 6. Insert sample currency data

INSERT INTO currency_types (currency_id, currency_name, symbol) VALUES
  ('USD', 'US Dollar', '$'),
  ('EUR', 'Euro', '€'),
  ('GBP', 'British Pound', '£'),
  ('JPY', 'Japanese Yen', '¥'),
  ('KRW', 'Korean Won', '₩');
```