-- ================================================================
-- MIGRATION: Register features & role_permissions in Ontology
-- Date: 2025-12-16
-- Purpose: AI가 "어떤 역할이 어떤 기능을 할 수 있는지" 이해하도록
--
-- 핵심 개념:
--   features = Action Types (시스템이 제공하는 기능 목록, 고정)
--   roles = features의 조합 (동적, Admin이 자유롭게 생성, 무한 가지)
--   role_permissions = 매핑 테이블
--
-- RUN THIS IN SUPABASE DASHBOARD SQL EDITOR!
-- ================================================================

-- ================================================================
-- PART 1: features 테이블 컬럼 등록
-- features = "시스템이 제공하는 기능" = Palantir의 Action Types
-- 개발자만 추가 가능 (코드에 하드코딩)
-- ================================================================

INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, ai_usage_hint) VALUES
('features', 'feature_id', 'uuid', true,
 '⭐ PK. Feature 고유 ID. role_permissions와 JOIN시 사용'),
('features', 'feature_name', 'varchar', true,
 '⭐⭐ 기능 이름 (Delegate Role, Delete Transaction 등). 시스템이 제공하는 "할 수 있는 일" 목록. 개발자만 추가 가능!'),
('features', 'route', 'varchar', true,
 '앱 내 라우트 경로. NULL이면 UI 없는 권한 (예: Delete Transaction)'),
('features', 'category_id', 'uuid', true,
 'FK → categories. 기능 카테고리 (Finance, HR 등)'),
('features', 'feature_description', 'text', true,
 '기능 설명 (짧은 버전)'),
('features', 'feature_ai_description', 'text', true,
 '⭐⭐ AI용 상세 설명. 권한 정보 포함! (Owner ✅, Manager ✅, Staff ❌ 등)'),
('features', 'is_toggleable', 'boolean', true,
 'true면 role_permissions에서 on/off 가능. false면 필수 기능'),
('features', 'primary_tables', 'jsonb', true,
 '이 기능이 사용하는 주요 테이블 목록 (예: ["journal_entries", "journal_lines"])')
ON CONFLICT (table_name, column_name)
DO UPDATE SET ai_usage_hint = EXCLUDED.ai_usage_hint;

-- ================================================================
-- PART 2: role_permissions 테이블 컬럼 등록
-- role_permissions = Role ↔ Feature 매핑
-- "어떤 역할이 어떤 기능을 사용할 수 있는가"
-- ================================================================

INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, ai_usage_hint) VALUES
('role_permissions', 'role_permission_id', 'uuid', true,
 'PK'),
('role_permissions', 'role_id', 'uuid', true,
 '⭐ FK → roles.role_id. 어떤 역할인지'),
('role_permissions', 'feature_id', 'uuid', true,
 '⭐ FK → features.feature_id. 어떤 기능인지'),
('role_permissions', 'can_access', 'boolean', true,
 '⭐⭐ 핵심! true면 이 역할이 이 기능 사용 가능. 권한 확인의 핵심 컬럼!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET ai_usage_hint = EXCLUDED.ai_usage_hint;

-- ================================================================
-- PART 3: ontology_concepts에 권한 관련 개념 등록
-- Note: column name is "concept_category" not "category"
-- ================================================================

INSERT INTO ontology_concepts (concept_name, concept_category, mapped_table, mapped_column, ai_usage_hint, example_values)
VALUES
('feature', 'access_control', 'features', 'feature_name',
 '⭐⭐ 시스템이 제공하는 기능 목록 (=Action Types). 개발자만 추가 가능. roles는 features의 조합으로 무한 생성 가능!',
 '["Delegate Role", "Delete Transaction", "Edit Employee Salary", "Export Reports", "Debt Control"]'),

('permission', 'access_control', 'role_permissions', 'can_access',
 '⭐⭐ 역할별 기능 접근 권한. role_permissions.can_access = true면 해당 역할이 해당 기능 사용 가능',
 '["true", "false"]'),

('action', 'access_control', 'features', 'feature_name',
 '⭐ "무엇을 할 수 있는가" = features 테이블. Palantir의 Action Types와 동일 개념. 예: Delete Transaction, Approve Shift',
 '["Delete Transaction", "Edit Employee Salary", "Approve Shift"]'),

('role_feature_combination', 'access_control', 'role_permissions', NULL,
 '⭐⭐ roles = features의 조합. Admin이 자유롭게 역할 생성 가능. 같은 features 조합이라도 다른 이름의 role 가능!',
 '["매장장 = [Debt Control, Export Reports, ...]", "회계담당 = [Delete Transaction, ...]"]')

ON CONFLICT (concept_name)
DO UPDATE SET
  concept_category = EXCLUDED.concept_category,
  mapped_table = EXCLUDED.mapped_table,
  mapped_column = EXCLUDED.mapped_column,
  ai_usage_hint = EXCLUDED.ai_usage_hint,
  example_values = EXCLUDED.example_values;

-- ================================================================
-- PART 4: ontology_constraints에 권한 조회 패턴 등록
-- AI가 권한 관련 질문 받았을 때 참고할 SQL 패턴
-- ================================================================

INSERT INTO ontology_constraints (
  constraint_name,
  constraint_type,
  applies_to_table,
  validation_rule,
  severity,
  ai_usage_hint
) VALUES (
  'permission_query_pattern',
  'QUERY_PATTERN',
  'role_permissions',
  'Always JOIN features and roles when querying permissions',
  'critical',
  '## 🔐 권한 시스템 구조

### 핵심 개념
```
features (고정)          roles (동적)
   │                        │
   │    role_permissions    │
   └────────┬───────────────┘
            │
      can_access = true/false
```

- **features** = "시스템이 제공하는 기능" (개발자만 추가)
- **roles** = "features의 조합" (Admin이 자유롭게 생성, 무한 가지)
- **role_permissions** = 매핑 (어떤 role이 어떤 feature 사용 가능)

### ✅ 특정 기능에 접근 가능한 역할 조회
```sql
SELECT r.role_name, r.role_type
FROM roles r
JOIN role_permissions rp ON r.role_id = rp.role_id
JOIN features f ON rp.feature_id = f.feature_id
WHERE f.feature_name = ''Delete Transaction''
  AND rp.can_access = true
  AND r.company_id = $company_id
```

### ✅ 특정 역할이 할 수 있는 모든 기능 조회
```sql
SELECT f.feature_name, f.feature_description
FROM features f
JOIN role_permissions rp ON f.feature_id = rp.feature_id
JOIN roles r ON rp.role_id = r.role_id
WHERE r.role_name = ''매장장''
  AND rp.can_access = true
  AND r.company_id = $company_id
```

### ✅ 특정 사용자가 할 수 있는 기능 조회
```sql
SELECT DISTINCT f.feature_name
FROM features f
JOIN role_permissions rp ON f.feature_id = rp.feature_id
JOIN user_roles ur ON rp.role_id = ur.role_id
WHERE ur.user_id = $user_id
  AND rp.can_access = true
```

### ✅ 기능별 접근 가능한 역할 수 집계
```sql
SELECT f.feature_name, COUNT(DISTINCT r.role_id) as role_count
FROM features f
LEFT JOIN role_permissions rp ON f.feature_id = rp.feature_id AND rp.can_access = true
LEFT JOIN roles r ON rp.role_id = r.role_id AND r.company_id = $company_id
GROUP BY f.feature_id, f.feature_name
ORDER BY role_count DESC
```'
) ON CONFLICT (constraint_name) DO UPDATE SET
  ai_usage_hint = EXCLUDED.ai_usage_hint;

-- ================================================================
-- PART 5: ontology_relationships 업데이트
-- 기존 관계에 더 명확한 힌트 추가
-- ================================================================

UPDATE ontology_relationships
SET ai_usage_hint = '⭐⭐ Role → Feature 권한 매핑. can_access = true면 해당 역할이 기능 사용 가능. roles는 features 조합으로 무한 생성!'
WHERE from_table = 'role_permissions' AND to_table = 'features';

UPDATE ontology_relationships
SET ai_usage_hint = '⭐⭐ Role → Permissions. 한 역할은 여러 features에 대한 권한 보유. roles.company_id로 회사별 필터링!'
WHERE from_table = 'role_permissions' AND to_table = 'roles';

-- ================================================================
-- PART 6: Verification Queries
-- ================================================================

SELECT '=== features columns registered ===' as info;
SELECT table_name, column_name, ai_usage_hint
FROM ontology_columns
WHERE table_name = 'features'
ORDER BY column_name;

SELECT '=== role_permissions columns registered ===' as info;
SELECT table_name, column_name, ai_usage_hint
FROM ontology_columns
WHERE table_name = 'role_permissions'
ORDER BY column_name;

SELECT '=== permission concepts registered ===' as info;
SELECT concept_name, mapped_table, ai_usage_hint
FROM ontology_concepts
WHERE concept_category = 'access_control'
ORDER BY concept_name;

SELECT '=== permission constraint registered ===' as info;
SELECT constraint_name, ai_usage_hint
FROM ontology_constraints
WHERE constraint_name = 'permission_query_pattern';
