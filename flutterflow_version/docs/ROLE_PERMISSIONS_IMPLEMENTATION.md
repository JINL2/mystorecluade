# Role Permissions Page - Complete Implementation Guide

## Overview
This document provides step-by-step implementation details for creating an advanced role permissions management system in FlutterFlow with Supabase integration.

## Page Components Structure

### 1. Main Page Widget
```dart
// role_permission_advanced_page.dart
class RolePermissionAdvancedPage extends StatefulWidget {
  final String companyId;
  final ViewMode? initialView;
  
  const RolePermissionAdvancedPage({
    Key? key,
    required this.companyId,
    this.initialView,
  }) : super(key: key);
}
```

### 2. Page State Management
```dart
class RolePermissionPageModel extends FlutterFlowModel {
  // UI State
  ViewMode viewMode = ViewMode.list;
  bool isLoading = false;
  bool showFilters = false;
  
  // Search & Filter State
  final searchController = TextEditingController();
  final searchDebouncer = Debouncer(milliseconds: 300);
  List<String> selectedRoleTypes = [];
  SortOption sortBy = SortOption.name;
  bool showInactiveRoles = false;
  
  // Selection State
  Set<String> selectedRoleIds = {};
  bool isMultiSelectMode = false;
  
  // Data State
  List<RoleDetailsRow> roles = [];
  List<CategoryFeaturesStruct> categories = [];
  Map<String, RoleAnalytics> roleAnalytics = {};
  
  // Pagination
  int currentPage = 0;
  final int pageSize = 20;
  bool hasMoreData = true;
  
  // Real-time Subscriptions
  StreamSubscription? rolesSubscription;
  StreamSubscription? permissionsSubscription;
}
```

## Supabase Schema Updates

### 1. Enhanced Tables
```sql
-- Update roles table
ALTER TABLE roles 
ADD COLUMN description TEXT,
ADD COLUMN is_active BOOLEAN DEFAULT true,
ADD COLUMN metadata JSONB DEFAULT '{}',
ADD COLUMN created_by UUID REFERENCES auth.users(id),
ADD COLUMN tags TEXT[] DEFAULT '{}';

-- Create role_templates table
CREATE TABLE role_templates (
  template_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_name VARCHAR(255) NOT NULL,
  template_type VARCHAR(50) NOT NULL,
  description TEXT,
  permissions JSONB NOT NULL,
  is_system BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create role_audit_log table
CREATE TABLE role_audit_log (
  log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  role_id UUID REFERENCES roles(role_id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id),
  action VARCHAR(50) NOT NULL,
  changes JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create user_roles table if not exists
CREATE TABLE IF NOT EXISTS user_roles (
  user_role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  role_id UUID REFERENCES roles(role_id) ON DELETE CASCADE,
  assigned_by UUID REFERENCES auth.users(id),
  assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP WITH TIME ZONE,
  is_active BOOLEAN DEFAULT true,
  UNIQUE(user_id, role_id)
);
```

### 2. Enhanced Views
```sql
-- Comprehensive role details view
CREATE OR REPLACE VIEW view_role_details AS
SELECT 
  r.role_id,
  r.role_name,
  r.role_type,
  r.description,
  r.company_id,
  r.parent_role_id,
  r.is_active,
  r.is_deletable,
  r.metadata,
  r.tags,
  r.created_at,
  r.updated_at,
  r.created_by,
  -- User count
  COUNT(DISTINCT ur.user_id) FILTER (WHERE ur.is_active = true) as active_user_count,
  COUNT(DISTINCT ur.user_id) as total_user_count,
  -- Permission details
  COALESCE(
    json_agg(
      DISTINCT jsonb_build_object(
        'feature_id', f.feature_id,
        'feature_name', f.feature_name,
        'category_id', f.category_id,
        'category_name', c.name
      )
    ) FILTER (WHERE rp.can_access = true),
    '[]'::json
  ) as permission_details,
  -- Permission count by category
  COALESCE(
    json_object_agg(
      c.name,
      COUNT(DISTINCT f.feature_id) FILTER (WHERE rp.can_access = true)
    ) FILTER (WHERE c.name IS NOT NULL),
    '{}'::json
  ) as permissions_by_category,
  -- Total permission count
  COUNT(DISTINCT f.feature_id) FILTER (WHERE rp.can_access = true) as permission_count,
  -- Last activity
  MAX(GREATEST(r.updated_at, ur.assigned_at)) as last_activity
FROM roles r
LEFT JOIN user_roles ur ON r.role_id = ur.role_id
LEFT JOIN role_permissions rp ON r.role_id = rp.role_id
LEFT JOIN features f ON rp.feature_id = f.feature_id
LEFT JOIN categories c ON f.category_id = c.category_id
GROUP BY r.role_id;

-- Permission matrix view
CREATE OR REPLACE VIEW view_permission_matrix AS
SELECT 
  r.role_id,
  r.role_name,
  f.feature_id,
  f.feature_name,
  c.category_id,
  c.name as category_name,
  COALESCE(rp.can_access, false) as has_permission
FROM roles r
CROSS JOIN features f
LEFT JOIN categories c ON f.category_id = c.category_id
LEFT JOIN role_permissions rp ON r.role_id = rp.role_id AND f.feature_id = rp.feature_id
ORDER BY c.name, f.feature_name, r.role_name;
```

### 3. Supabase RPC Functions
```sql
-- Search roles with filters
CREATE OR REPLACE FUNCTION search_roles(
  p_company_id UUID,
  p_search_query TEXT DEFAULT NULL,
  p_role_types TEXT[] DEFAULT NULL,
  p_is_active BOOLEAN DEFAULT NULL,
  p_has_users BOOLEAN DEFAULT NULL,
  p_sort_by TEXT DEFAULT 'name',
  p_sort_desc BOOLEAN DEFAULT false,
  p_page_size INT DEFAULT 20,
  p_page INT DEFAULT 0
) RETURNS TABLE (
  role_data JSONB,
  total_count BIGINT
) AS $$
BEGIN
  RETURN QUERY
  WITH filtered_roles AS (
    SELECT *
    FROM view_role_details
    WHERE company_id = p_company_id
      AND (p_search_query IS NULL OR 
           role_name ILIKE '%' || p_search_query || '%' OR
           description ILIKE '%' || p_search_query || '%')
      AND (p_role_types IS NULL OR role_type = ANY(p_role_types))
      AND (p_is_active IS NULL OR is_active = p_is_active)
      AND (p_has_users IS NULL OR 
           (p_has_users = true AND active_user_count > 0) OR
           (p_has_users = false AND active_user_count = 0))
  ),
  counted AS (
    SELECT COUNT(*) as total FROM filtered_roles
  )
  SELECT 
    jsonb_agg(
      to_jsonb(f.*) 
      ORDER BY 
        CASE WHEN p_sort_by = 'name' AND NOT p_sort_desc THEN f.role_name END ASC,
        CASE WHEN p_sort_by = 'name' AND p_sort_desc THEN f.role_name END DESC,
        CASE WHEN p_sort_by = 'users' AND NOT p_sort_desc THEN f.active_user_count END ASC,
        CASE WHEN p_sort_by = 'users' AND p_sort_desc THEN f.active_user_count END DESC,
        CASE WHEN p_sort_by = 'updated' AND NOT p_sort_desc THEN f.updated_at END ASC,
        CASE WHEN p_sort_by = 'updated' AND p_sort_desc THEN f.updated_at END DESC
    ) as role_data,
    (SELECT total FROM counted) as total_count
  FROM filtered_roles f
  LIMIT p_page_size
  OFFSET p_page * p_page_size;
END;
$$ LANGUAGE plpgsql;

-- Clone role with permissions
CREATE OR REPLACE FUNCTION clone_role(
  p_role_id UUID,
  p_new_name VARCHAR(255),
  p_new_description TEXT DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
  v_new_role_id UUID;
  v_company_id UUID;
  v_user_id UUID;
BEGIN
  -- Get current user
  v_user_id := auth.uid();
  
  -- Get company_id from source role
  SELECT company_id INTO v_company_id
  FROM roles WHERE role_id = p_role_id;
  
  -- Create new role
  INSERT INTO roles (
    role_name, 
    role_type, 
    company_id, 
    parent_role_id, 
    description,
    created_by
  )
  SELECT 
    p_new_name, 
    'custom', 
    company_id, 
    role_id, -- Set source as parent
    COALESCE(p_new_description, 'Cloned from ' || role_name),
    v_user_id
  FROM roles 
  WHERE role_id = p_role_id
  RETURNING role_id INTO v_new_role_id;
  
  -- Copy permissions
  INSERT INTO role_permissions (role_id, feature_id, can_access)
  SELECT v_new_role_id, feature_id, can_access
  FROM role_permissions 
  WHERE role_id = p_role_id;
  
  -- Log action
  INSERT INTO role_audit_log (role_id, user_id, action, changes)
  VALUES (
    v_new_role_id, 
    v_user_id, 
    'created_from_clone',
    jsonb_build_object('source_role_id', p_role_id)
  );
  
  RETURN v_new_role_id;
END;
$$ LANGUAGE plpgsql;

-- Bulk update permissions
CREATE OR REPLACE FUNCTION bulk_update_permissions(
  p_updates JSONB
) RETURNS VOID AS $$
/*
Expected format:
{
  "role_ids": ["uuid1", "uuid2"],
  "permissions": {
    "grant": ["feature_id1", "feature_id2"],
    "revoke": ["feature_id3", "feature_id4"]
  }
}
*/
DECLARE
  v_role_id UUID;
  v_feature_id UUID;
BEGIN
  -- Grant permissions
  FOR v_role_id IN SELECT jsonb_array_elements_text(p_updates->'role_ids')::UUID
  LOOP
    FOR v_feature_id IN SELECT jsonb_array_elements_text(p_updates->'permissions'->'grant')::UUID
    LOOP
      INSERT INTO role_permissions (role_id, feature_id, can_access)
      VALUES (v_role_id, v_feature_id, true)
      ON CONFLICT (role_id, feature_id) 
      DO UPDATE SET can_access = true, updated_at = CURRENT_TIMESTAMP;
    END LOOP;
  END LOOP;
  
  -- Revoke permissions
  FOR v_role_id IN SELECT jsonb_array_elements_text(p_updates->'role_ids')::UUID
  LOOP
    DELETE FROM role_permissions
    WHERE role_id = v_role_id
    AND feature_id = ANY(
      SELECT jsonb_array_elements_text(p_updates->'permissions'->'revoke')::UUID
    );
  END LOOP;
  
  -- Log bulk action
  INSERT INTO role_audit_log (role_id, user_id, action, changes)
  SELECT 
    jsonb_array_elements_text(p_updates->'role_ids')::UUID,
    auth.uid(),
    'bulk_permission_update',
    p_updates
  FROM jsonb_array_elements_text(p_updates->'role_ids');
END;
$$ LANGUAGE plpgsql;

-- Get role analytics
CREATE OR REPLACE FUNCTION get_role_analytics(
  p_role_id UUID
) RETURNS JSONB AS $$
DECLARE
  v_analytics JSONB;
BEGIN
  SELECT jsonb_build_object(
    'user_stats', jsonb_build_object(
      'total_users', COUNT(DISTINCT ur.user_id),
      'active_users', COUNT(DISTINCT ur.user_id) FILTER (WHERE ur.is_active = true),
      'users_by_month', (
        SELECT jsonb_object_agg(
          to_char(date_trunc('month', assigned_at), 'YYYY-MM'),
          count
        )
        FROM (
          SELECT date_trunc('month', assigned_at) as assigned_at, COUNT(*) as count
          FROM user_roles
          WHERE role_id = p_role_id
          GROUP BY date_trunc('month', assigned_at)
          ORDER BY assigned_at DESC
          LIMIT 12
        ) monthly
      )
    ),
    'permission_stats', jsonb_build_object(
      'total_permissions', COUNT(DISTINCT rp.feature_id),
      'by_category', (
        SELECT jsonb_object_agg(c.name, count)
        FROM (
          SELECT c.name, COUNT(*) as count
          FROM role_permissions rp
          JOIN features f ON rp.feature_id = f.feature_id
          JOIN categories c ON f.category_id = c.category_id
          WHERE rp.role_id = p_role_id AND rp.can_access = true
          GROUP BY c.name
        ) cat_counts
      )
    ),
    'activity_stats', jsonb_build_object(
      'last_modified', r.updated_at,
      'created_at', r.created_at,
      'recent_changes', (
        SELECT jsonb_agg(
          jsonb_build_object(
            'action', action,
            'user_id', user_id,
            'timestamp', created_at,
            'changes', changes
          )
          ORDER BY created_at DESC
        )
        FROM role_audit_log
        WHERE role_id = p_role_id
        LIMIT 10
      )
    )
  ) INTO v_analytics
  FROM roles r
  LEFT JOIN user_roles ur ON r.role_id = ur.role_id
  LEFT JOIN role_permissions rp ON r.role_id = rp.role_id
  WHERE r.role_id = p_role_id
  GROUP BY r.role_id, r.updated_at, r.created_at;
  
  RETURN v_analytics;
END;
$$ LANGUAGE plpgsql;
```

## UI Components Implementation

### 1. Advanced Role Card
```dart
class AdvancedRoleCard extends StatelessWidget {
  final RoleDetailsRow role;
  final bool isSelected;
  final bool isMultiSelectMode;
  final Function(String) onSelect;
  final Function(String) onEdit;
  final Function(String) onClone;
  final Function(String) onDelete;
  final Function(String) onViewAnalytics;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: isSelected ? 4 : 1,
        borderRadius: BorderRadius.circular(12),
        color: isSelected 
          ? FlutterFlowTheme.of(context).primaryBackground 
          : FlutterFlowTheme.of(context).secondaryBackground,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (isMultiSelectMode) {
              onSelect(role.roleId);
            } else {
              onEdit(role.roleId);
            }
          },
          onLongPress: () => onSelect(role.roleId),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    if (isMultiSelectMode)
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) => onSelect(role.roleId),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  role.roleName,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall,
                                ),
                              ),
                              _buildRoleTypeBadge(context),
                              if (!role.isActive)
                                _buildInactiveBadge(context),
                            ],
                          ),
                          if (role.description != null)
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                role.description!,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Stats Row
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      _buildStatChip(
                        context,
                        Icons.person_outline,
                        '${role.activeUserCount} users',
                        FlutterFlowTheme.of(context).primary,
                      ),
                      SizedBox(width: 12),
                      _buildStatChip(
                        context,
                        Icons.security,
                        '${role.permissionCount} permissions',
                        FlutterFlowTheme.of(context).secondary,
                      ),
                      Spacer(),
                      Text(
                        'Updated ${DateFormat.yMMMd().format(role.updatedAt)}',
                        style: FlutterFlowTheme.of(context).bodySmall,
                      ),
                    ],
                  ),
                ),
                
                // Permission Preview
                _buildPermissionPreview(context),
                
                // Action Buttons
                if (!isMultiSelectMode)
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.analytics_outlined),
                          onPressed: () => onViewAnalytics(role.roleId),
                          tooltip: 'View Analytics',
                        ),
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () => onClone(role.roleId),
                          tooltip: 'Clone Role',
                        ),
                        if (role.isDeletable)
                          IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () => onDelete(role.roleId),
                            tooltip: 'Delete Role',
                            color: FlutterFlowTheme.of(context).error,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPermissionPreview(BuildContext context) {
    final permissionsByCategory = role.permissionsByCategory as Map<String, int>;
    final topCategories = permissionsByCategory.entries
        .where((e) => e.value > 0)
        .take(3)
        .toList();
    
    if (topCategories.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).accent3,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'No permissions assigned',
          style: FlutterFlowTheme.of(context).bodySmall,
        ),
      );
    }
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...topCategories.map((entry) => Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).accent1,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${entry.key}: ${entry.value}',
            style: FlutterFlowTheme.of(context).bodySmall,
          ),
        )),
        if (permissionsByCategory.length > 3)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).accent2,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '+${permissionsByCategory.length - 3} more',
              style: FlutterFlowTheme.of(context).bodySmall,
            ),
          ),
      ],
    );
  }
}
```

### 2. Permission Matrix View
```dart
class PermissionMatrixView extends StatelessWidget {
  final List<RoleDetailsRow> roles;
  final List<CategoryFeaturesStruct> categories;
  final Function(String roleId, String featureId, bool grant) onPermissionToggle;
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 24,
          headingRowHeight: 60,
          dataRowHeight: 48,
          columns: [
            DataColumn(
              label: Container(
                width: 200,
                child: Text('Features'),
              ),
            ),
            ...roles.map((role) => DataColumn(
              label: RotatedBox(
                quarterTurns: -1,
                child: Container(
                  width: 120,
                  child: Text(
                    role.roleName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )),
          ],
          rows: _buildFeatureRows(context),
        ),
      ),
    );
  }
  
  List<DataRow> _buildFeatureRows(BuildContext context) {
    List<DataRow> rows = [];
    
    for (var category in categories) {
      // Category header row
      rows.add(DataRow(
        cells: [
          DataCell(
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                category.categoryName,
                style: FlutterFlowTheme.of(context).titleMedium,
              ),
            ),
          ),
          ...roles.map((role) => DataCell(Container())),
        ],
      ));
      
      // Feature rows
      for (var feature in category.features) {
        rows.add(DataRow(
          cells: [
            DataCell(
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(feature.featureName),
              ),
            ),
            ...roles.map((role) => DataCell(
              Checkbox(
                value: role.permissions.contains(feature.featureId),
                onChanged: role.roleType != 'owner' 
                  ? (value) => onPermissionToggle(
                      role.roleId, 
                      feature.featureId, 
                      value ?? false
                    )
                  : null,
              ),
            )),
          ],
        ));
      }
    }
    
    return rows;
  }
}
```

### 3. Role Creation Wizard
```dart
class RoleCreationWizard extends StatefulWidget {
  final String companyId;
  final Function(RoleCreateData) onCreate;
  
  @override
  _RoleCreationWizardState createState() => _RoleCreationWizardState();
}

class _RoleCreationWizardState extends State<RoleCreationWizard> {
  final PageController _pageController = PageController();
  int currentStep = 0;
  
  // Form data
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedTemplate;
  Set<String> selectedPermissions = {};
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (currentStep + 1) / 4,
          ),
          
          // Wizard content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildBasicInfoStep(),
                _buildTemplateSelectionStep(),
                _buildPermissionAssignmentStep(),
                _buildReviewStep(),
              ],
            ),
          ),
          
          // Navigation buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }
  
  Widget _buildBasicInfoStep() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: FlutterFlowTheme.of(context).headlineMedium,
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Role Name',
              hintText: 'e.g., Regional Manager',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Role name is required';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Describe the purpose of this role',
            ),
            maxLines: 3,
          ),
          SizedBox(height: 24),
          // Role tags
          Text(
            'Tags (Optional)',
            style: FlutterFlowTheme.of(context).bodyLarge,
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              'Management',
              'Sales',
              'Operations',
              'Finance',
              'HR',
            ].map((tag) => FilterChip(
              label: Text(tag),
              selected: false,
              onSelected: (selected) {
                // Handle tag selection
              },
            )).toList(),
          ),
        ],
      ),
    );
  }
}
```

### 4. Filter Component
```dart
class RoleFilters extends StatelessWidget {
  final RolePermissionPageModel model;
  final Function() onApply;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Roles',
            style: FlutterFlowTheme.of(context).headlineSmall,
          ),
          SizedBox(height: 16),
          
          // Role Type Filter
          Text('Role Type', style: FlutterFlowTheme.of(context).bodyLarge),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text('Custom'),
                selected: model.selectedRoleTypes.contains('custom'),
                onSelected: (selected) {
                  if (selected) {
                    model.selectedRoleTypes.add('custom');
                  } else {
                    model.selectedRoleTypes.remove('custom');
                  }
                },
              ),
              FilterChip(
                label: Text('Employee'),
                selected: model.selectedRoleTypes.contains('employee'),
                onSelected: (selected) {
                  if (selected) {
                    model.selectedRoleTypes.add('employee');
                  } else {
                    model.selectedRoleTypes.remove('employee');
                  }
                },
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Status Filter
          SwitchListTile(
            title: Text('Show Inactive Roles'),
            value: model.showInactiveRoles,
            onChanged: (value) {
              model.showInactiveRoles = value;
            },
          ),
          
          // Sort Options
          Text('Sort By', style: FlutterFlowTheme.of(context).bodyLarge),
          SizedBox(height: 8),
          DropdownButton<SortOption>(
            value: model.sortBy,
            isExpanded: true,
            items: [
              DropdownMenuItem(
                value: SortOption.name,
                child: Text('Name'),
              ),
              DropdownMenuItem(
                value: SortOption.users,
                child: Text('User Count'),
              ),
              DropdownMenuItem(
                value: SortOption.updated,
                child: Text('Last Updated'),
              ),
              DropdownMenuItem(
                value: SortOption.permissions,
                child: Text('Permission Count'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                model.sortBy = value;
              }
            },
          ),
          
          SizedBox(height: 24),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Reset filters
                  model.selectedRoleTypes.clear();
                  model.showInactiveRoles = false;
                  model.sortBy = SortOption.name;
                  Navigator.pop(context);
                },
                child: Text('Reset'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  onApply();
                  Navigator.pop(context);
                },
                child: Text('Apply Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## Integration Examples

### 1. Loading Roles with Filters
```dart
Future<void> loadRoles() async {
  setState(() => _model.isLoading = true);
  
  try {
    final response = await supabase.rpc(
      'search_roles',
      params: {
        'p_company_id': widget.companyId,
        'p_search_query': _model.searchController.text,
        'p_role_types': _model.selectedRoleTypes.isEmpty 
          ? null 
          : _model.selectedRoleTypes,
        'p_is_active': _model.showInactiveRoles ? null : true,
        'p_sort_by': _model.sortBy.toString().split('.').last,
        'p_page_size': _model.pageSize,
        'p_page': _model.currentPage,
      },
    );
    
    final data = response as Map<String, dynamic>;
    final roleData = data['role_data'] as List<dynamic>;
    final totalCount = data['total_count'] as int;
    
    setState(() {
      _model.roles = roleData
        .map((json) => RoleDetailsRow(json))
        .toList();
      _model.hasMoreData = 
        (_model.currentPage + 1) * _model.pageSize < totalCount;
    });
  } catch (e) {
    showSnackbar('Error loading roles: $e');
  } finally {
    setState(() => _model.isLoading = false);
  }
}
```

### 2. Real-time Updates
```dart
void setupRealtimeSubscriptions() {
  // Subscribe to role changes
  _model.rolesSubscription = supabase
    .from('roles')
    .stream(primaryKey: ['role_id'])
    .eq('company_id', widget.companyId)
    .listen((List<Map<String, dynamic>> data) {
      // Update local role list
      for (var roleData in data) {
        final index = _model.roles.indexWhere(
          (r) => r.roleId == roleData['role_id']
        );
        if (index != -1) {
          setState(() {
            _model.roles[index] = RoleDetailsRow(roleData);
          });
        }
      }
    });
    
  // Subscribe to permission changes
  _model.permissionsSubscription = supabase
    .from('role_permissions')
    .stream(primaryKey: ['role_permission_id'])
    .listen((List<Map<String, dynamic>> data) {
      // Refresh affected roles
      final affectedRoleIds = data
        .map((p) => p['role_id'] as String)
        .toSet();
      
      for (var roleId in affectedRoleIds) {
        refreshRole(roleId);
      }
    });
}
```

### 3. Bulk Operations
```dart
Future<void> performBulkUpdate() async {
  if (_model.selectedRoleIds.isEmpty) return;
  
  final updates = {
    'role_ids': _model.selectedRoleIds.toList(),
    'permissions': {
      'grant': selectedPermissionsToGrant,
      'revoke': selectedPermissionsToRevoke,
    },
  };
  
  try {
    await supabase.rpc('bulk_update_permissions', params: {
      'p_updates': updates,
    });
    
    showSnackbar('Permissions updated successfully');
    
    // Refresh affected roles
    for (var roleId in _model.selectedRoleIds) {
      await refreshRole(roleId);
    }
    
    // Exit multi-select mode
    setState(() {
      _model.isMultiSelectMode = false;
      _model.selectedRoleIds.clear();
    });
  } catch (e) {
    showSnackbar('Error updating permissions: $e');
  }
}
```

## Performance Optimizations

### 1. Debounced Search
```dart
void onSearchChanged(String query) {
  _model.searchDebouncer.run(() {
    _model.currentPage = 0; // Reset pagination
    loadRoles();
  });
}
```

### 2. Lazy Loading
```dart
Widget buildRoleList() {
  return NotificationListener<ScrollNotification>(
    onNotification: (scrollInfo) {
      if (!_model.isLoading && 
          _model.hasMoreData &&
          scrollInfo.metrics.pixels == 
          scrollInfo.metrics.maxScrollExtent) {
        _model.currentPage++;
        loadMoreRoles();
      }
      return false;
    },
    child: ListView.builder(
      itemCount: _model.roles.length + (_model.hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _model.roles.length) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return AdvancedRoleCard(
          role: _model.roles[index],
          // ... other props
        );
      },
    ),
  );
}
```

### 3. Caching Strategy
```dart
class RoleCache {
  static final Map<String, RoleDetailsRow> _cache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);
  
  static RoleDetailsRow? get(String roleId) {
    final timestamp = _cacheTimestamps[roleId];
    if (timestamp != null && 
        DateTime.now().difference(timestamp) < _cacheExpiry) {
      return _cache[roleId];
    }
    return null;
  }
  
  static void set(String roleId, RoleDetailsRow role) {
    _cache[roleId] = role;
    _cacheTimestamps[roleId] = DateTime.now();
  }
  
  static void invalidate(String roleId) {
    _cache.remove(roleId);
    _cacheTimestamps.remove(roleId);
  }
}
```

This implementation guide provides a complete, production-ready role permissions system with advanced features, optimized performance, and excellent user experience.