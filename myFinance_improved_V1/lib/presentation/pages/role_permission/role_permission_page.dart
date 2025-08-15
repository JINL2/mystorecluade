import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../delegate_role/providers/delegate_role_providers.dart';
import '../delegate_role/widgets/role_card.dart';
import '../delegate_role/widgets/role_management_sheet.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

class RolePermissionPage extends ConsumerStatefulWidget {
  const RolePermissionPage({super.key});

  @override
  ConsumerState<RolePermissionPage> createState() => _RolePermissionPageState();
}

class _RolePermissionPageState extends ConsumerState<RolePermissionPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes if needed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the app state and providers
    final allRolesAsync = ref.watch(allCompanyRolesProvider);
    final appState = ref.watch(appStateProvider);
    
    // Check if company is selected
    if (appState.companyChoosen.isEmpty) {
      return TossScaffold(
        appBar: const TossAppBar(title: 'Roles & Permissions'),
        body: Center(
          child: TossEmptyView(
            icon: Icon(
              Icons.business_outlined,
              size: 64,
              color: TossColors.gray400,
            ),
            title: 'No company selected',
            description: 'Please select a company to manage roles and permissions',
            action: ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space5,
                  vertical: TossSpacing.space3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
              ),
              child: const Text('Go to Home'),
            ),
          ),
        ),
      );
    }

    return TossScaffold(
      key: _scaffoldKey,
      appBar: const TossAppBar(title: 'Roles & Permissions'),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          right: TossSpacing.space4,
          bottom: TossSpacing.space4,
        ),
        child: FloatingActionButton(
          onPressed: () => _showCreateRoleModal(context),
          backgroundColor: TossColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.add, size: 24),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        color: TossColors.primary,
        child: allRolesAsync.when(
          data: (roles) {
            if (roles.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(TossSpacing.space10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Icon(
                          Icons.admin_panel_settings_outlined,
                          size: 40,
                          color: TossColors.gray400,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space6),
                      Text(
                        'No roles created yet',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Text(
                        'Create roles and manage permissions\nfor your team members',
                        textAlign: TextAlign.center,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            // Filter roles based on search query
            final filteredRoles = _searchQuery.isEmpty 
                ? roles 
                : roles.where((role) => 
                    role['roleName'].toString().toLowerCase().contains(_searchQuery)
                  ).toList();

            return Column(
              children: [
                // Search bar only
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(TossSpacing.space5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      border: Border.all(color: TossColors.gray200),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TossTextStyles.body,
                      decoration: InputDecoration(
                        hintText: 'Search roles...',
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray400,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: TossColors.gray400,
                          size: 20,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: TossColors.gray400,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space4,
                          vertical: TossSpacing.space3,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Roles list
                Expanded(
                  child: filteredRoles.isEmpty && _searchQuery.isNotEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(TossSpacing.space10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: TossColors.gray400,
                                ),
                                SizedBox(height: TossSpacing.space4),
                                Text(
                                  'No roles found',
                                  style: TossTextStyles.h3.copyWith(
                                    color: TossColors.gray700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: TossSpacing.space2),
                                Text(
                                  'Try a different search term',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            bottom: TossSpacing.space10,
                          ),
                          itemCount: filteredRoles.length,
                          itemBuilder: (context, index) {
                            final role = filteredRoles[index];
                            return RoleCard(
                              roleId: role['roleId'],
                              roleName: role['roleName'],
                              description: role['description'],
                              permissions: List<String>.from(role['permissions']),
                              memberCount: role['memberCount'] ?? 0,
                              canEdit: role['canEdit'],
                              canDelegate: role['canDelegate'],
                              onTap: () => _openRoleManagement(role),
                            );
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const TossLoadingView(
            message: 'Loading roles...',
          ),
          error: (error, stack) => TossErrorView(
            error: error,
            title: 'Failed to load roles',
            onRetry: () => ref.invalidate(allCompanyRolesProvider),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    // Invalidate all relevant providers to force a refresh
    ref.invalidate(allCompanyRolesProvider);
    ref.invalidate(delegatableRolesProvider);
    ref.invalidate(activeDelegationsProvider);
  }

  void _openRoleManagement(Map<String, dynamic> role) {
    RoleManagementSheet.show(
      context,
      roleId: role['roleId'],
      roleName: role['roleName'],
      description: role['description'],
      permissions: List<String>.from(role['permissions']),
      memberCount: role['memberCount'] ?? 0,
      canEdit: role['canEdit'],
      canDelegate: role['canDelegate'],
    );
  }

  void _showCreateRoleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateRoleBottomSheet(),
    );
  }
}

// Simple Create Role Bottom Sheet
class _CreateRoleBottomSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateRoleBottomSheet> createState() => _CreateRoleBottomSheetState();
}

class _CreateRoleBottomSheetState extends ConsumerState<_CreateRoleBottomSheet> {
  final TextEditingController _roleNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCreating = false;
  int _currentStep = 0; // 0: Basic Info, 1: Permissions
  Set<String> _selectedPermissions = {};
  Set<String> _expandedCategories = {};
  bool _permissionsInitialized = false;

  @override
  void dispose() {
    _roleNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: TossSpacing.space3),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: EdgeInsets.all(TossSpacing.space5),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: TossColors.gray600),
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                          // Reset permission initialization when going back
                          if (_currentStep == 0) {
                            _permissionsInitialized = false;
                          }
                        });
                      },
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentStep == 0 ? 'Create New Role' : 'Configure Permissions',
                          style: TossTextStyles.h2.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.gray900,
                          ),
                        ),
                        SizedBox(height: TossSpacing.space1),
                        Text(
                          _currentStep == 0 
                              ? 'Define a new role with specific permissions'
                              : 'Select what this role can access and do',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: TossColors.gray600),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Step indicator
            if (_currentStep == 0) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepIndicator(0, true),
                    Container(
                      width: 40,
                      height: 2,
                      color: TossColors.gray200,
                    ),
                    _buildStepIndicator(1, false),
                  ],
                ),
              ),
              SizedBox(height: TossSpacing.space3),
            ],
            
            // Form content
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: _currentStep == 0
                    ? _buildBasicInfoStep()
                    : _buildPermissionsStep(),
              ),
            ),
            
            // Bottom action
            Container(
              padding: EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.background,
                border: Border(top: BorderSide(color: TossColors.gray200)),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isCreating ? null : (_currentStep == 0 ? _goToNextStep : _createRole),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      elevation: 0,
                    ),
                    child: _isCreating
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _currentStep == 0 ? 'Next' : 'Create Role',
                            style: TossTextStyles.body.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? TossColors.primary : TossColors.gray200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${step + 1}',
          style: TossTextStyles.body.copyWith(
            color: isActive ? Colors.white : TossColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role name input
          Text(
            'Role Name',
            style: TossTextStyles.label.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          TextField(
            controller: _roleNameController,
            style: TossTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Enter role name',
              filled: true,
              fillColor: TossColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.gray200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.gray200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.primary),
              ),
            ),
          ),
          
          SizedBox(height: TossSpacing.space5),
          
          // Description input
          Text(
            'Description',
            style: TossTextStyles.label.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            style: TossTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Describe what this role does...',
              filled: true,
              fillColor: TossColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.gray200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.gray200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsStep() {
    final allFeaturesAsync = ref.watch(allFeaturesProvider);
    
    return allFeaturesAsync.when(
      data: (categories) {
        // Initialize all permissions as selected on first load
        if (!_permissionsInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final allFeatureIds = <String>[];
            for (final category in categories) {
              final features = (category['features'] as List? ?? [])
                  .cast<Map<String, dynamic>>();
              for (final feature in features) {
                allFeatureIds.add(feature['feature_id'] as String);
              }
            }
            setState(() {
              _selectedPermissions = Set.from(allFeatureIds);
              _permissionsInitialized = true;
            });
          });
        }
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: Column(
            children: [
              // Quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Permissions',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedPermissions.clear();
                      });
                    },
                    child: Text(
                      'Clear all',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: TossSpacing.space3),
              // Permission categories
              ...categories.map((category) {
                final categoryName = category['category_name'] as String;
                final features = (category['features'] as List? ?? [])
                    .cast<Map<String, dynamic>>();
                
                if (features.isEmpty) return SizedBox.shrink();
                
                return _buildPermissionCategory(categoryName, features);
              }).toList(),
            ],
          ),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: TossColors.primary),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: TossColors.error, size: 48),
            SizedBox(height: TossSpacing.space3),
            Text(
              'Failed to load permissions',
              style: TossTextStyles.body.copyWith(color: TossColors.error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCategory(String title, List<Map<String, dynamic>> features) {
    final isExpanded = _expandedCategories.contains(title);
    final featureIds = features.map((f) => f['feature_id'] as String).toList();
    final selectedCount = featureIds.where((id) => _selectedPermissions.contains(id)).length;
    final allSelected = selectedCount == features.length && features.isNotEmpty;
    final someSelected = selectedCount > 0 && selectedCount < features.length;
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Collapsible header
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(TossBorderRadius.md),
              bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.md),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expandedCategories.remove(title);
                  } else {
                    _expandedCategories.add(title);
                  }
                });
              },
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(TossBorderRadius.md),
                bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.md),
              ),
              child: Container(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Row(
                  children: [
                    // Select all checkbox
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _toggleCategoryPermissions(featureIds, !allSelected);
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: allSelected
                                  ? TossColors.primary
                                  : someSelected
                                      ? TossColors.primary.withOpacity(0.3)
                                      : TossColors.background,
                              border: Border.all(
                                color: allSelected || someSelected
                                    ? TossColors.primary
                                    : TossColors.gray300,
                                width: allSelected || someSelected ? 2 : 1.5,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: allSelected
                                ? Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : someSelected
                                    ? Center(
                                        child: Container(
                                          width: 8,
                                          height: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: TossColors.gray900,
                              fontSize: 16,
                            ),
                          ),
                          if (selectedCount > 0)
                            Text(
                              '$selectedCount of ${features.length} selected',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more,
                        color: TossColors.gray600,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Expanded content
          if (isExpanded) ...[ 
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: TossColors.gray200, width: 1),
                ),
              ),
              child: Column(
                children: features.map((feature) {
                  final featureId = feature['feature_id'] as String;
                  final featureName = feature['feature_name'] as String;
                  final isSelected = _selectedPermissions.contains(featureId);
                  
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _togglePermission(featureId),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space4,
                          vertical: TossSpacing.space3,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: TossColors.gray100,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: TossSpacing.space6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? TossColors.primary
                                    : TossColors.background,
                                border: Border.all(
                                  color: isSelected
                                      ? TossColors.primary
                                      : TossColors.gray300,
                                  width: isSelected ? 2 : 1.5,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            SizedBox(width: TossSpacing.space3),
                            Expanded(
                              child: Text(
                                featureName,
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _togglePermission(String featureId) {
    setState(() {
      if (_selectedPermissions.contains(featureId)) {
        _selectedPermissions.remove(featureId);
      } else {
        _selectedPermissions.add(featureId);
      }
    });
  }

  void _toggleCategoryPermissions(List<String> featureIds, bool select) {
    setState(() {
      if (select) {
        _selectedPermissions.addAll(featureIds);
      } else {
        _selectedPermissions.removeAll(featureIds);
      }
    });
  }

  void _goToNextStep() {
    final roleName = _roleNameController.text.trim();
    if (roleName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a role name'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }

    setState(() {
      _currentStep = 1;
    });
  }

  Future<void> _createRole() async {
    final roleName = _roleNameController.text.trim();
    if (roleName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a role name'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) {
        throw Exception('No company selected');
      }

      // Use the createRoleProvider to create the role with permissions
      final createRole = ref.read(createRoleProvider);
      final roleId = await createRole(
        companyId: companyId,
        roleName: roleName,
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        roleType: 'custom',
      );

      // If permissions were selected, update them
      if (_selectedPermissions.isNotEmpty) {
        final updatePermissions = ref.read(updateRolePermissionsProvider);
        await updatePermissions(roleId, _selectedPermissions);
      }
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role "$roleName" created successfully'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create role: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }
}