# Supabase 데이터베이스 구조

## 테이블 구조

### users
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### companies
```sql
CREATE TABLE companies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  owner_id UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### stores
```sql
CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  address TEXT,
  phone TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### employees
```sql
CREATE TABLE employees (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  store_id UUID REFERENCES stores(id),
  role_id UUID REFERENCES roles(id),
  salary DECIMAL(10, 2),
  is_active BOOLEAN DEFAULT true,
  hired_date DATE,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### roles
```sql
CREATE TABLE roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  color TEXT DEFAULT '#4184F3',
  permissions JSONB DEFAULT '{}',
  level INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### features
```sql
CREATE TABLE features (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category_id UUID REFERENCES categories(id),
  name TEXT NOT NULL,
  icon TEXT,
  route TEXT,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  order_index INTEGER DEFAULT 0
);
```

### categories
```sql
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  icon TEXT,
  order_index INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true
);
```

### click_history
```sql
CREATE TABLE click_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  feature_id UUID REFERENCES features(id),
  company_id UUID REFERENCES companies(id),
  store_id UUID REFERENCES stores(id),
  clicked_at TIMESTAMP DEFAULT NOW()
);
```

## RPC 함수

### get_categories_with_features
카테고리와 기능 목록 조회
```sql
SELECT * FROM get_categories_with_features()
```

### get_user_companies
사용자의 회사 목록 조회
```sql
SELECT * FROM get_user_companies(user_id UUID)
```

### get_employees_with_details
직원 상세 정보 조회
```sql
SELECT * FROM get_employees_with_details(
  company_id UUID,
  store_id UUID
)
```

### get_roles_with_permissions
역할 및 권한 조회
```sql
SELECT * FROM get_roles_with_permissions(company_id UUID)
```

### track_feature_click
기능 클릭 추적
```sql
SELECT track_feature_click(
  user_id UUID,
  feature_id UUID,
  company_id UUID,
  store_id UUID
)
```

## Row Level Security (RLS)

모든 테이블에 RLS 적용:
- 사용자는 자신이 속한 회사의 데이터만 접근 가능
- company_id 기반 필터링
- owner 또는 employee 권한 체크

### 예시 정책
```sql
-- companies 테이블 RLS
CREATE POLICY "Users can view their own companies" ON companies
  FOR SELECT USING (
    auth.uid() = owner_id OR
    auth.uid() IN (
      SELECT user_id FROM employees 
      WHERE company_id = companies.id
    )
  );
```