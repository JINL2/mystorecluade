// lib/presentation/pages/delegate_role/widgets/role_filter_panel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/delegate_role_provider.dart';
import '../../../providers/app_state_provider.dart';

class RoleFilterPanel extends ConsumerStatefulWidget {
  final bool isMobile;

  const RoleFilterPanel({
    super.key,
    this.isMobile = false,
  });

  @override
  ConsumerState<RoleFilterPanel> createState() => _RoleFilterPanelState();
}

class _RoleFilterPanelState extends ConsumerState<RoleFilterPanel> {
  bool _isRoleExpanded = true;
  bool _isStoreExpanded = true;

  @override
  Widget build(BuildContext context) {
    final selectedRoleIds = ref.watch(selectedRoleFiltersProvider);
    final selectedStoreIds = ref.watch(selectedStoreFiltersProvider);
    final companyId = ref.watch(appStateProvider).companyChoosen;
    
    if (companyId.isEmpty) {
      return const SizedBox.shrink();
    }

    final rolesAsync = ref.watch(availableRolesProvider(companyId));
    final storesAsync = ref.watch(availableStoresProvider(companyId));

    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                if (selectedRoleIds.isNotEmpty || selectedStoreIds.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      ref.read(selectedRoleFiltersProvider.notifier).clearFilters();
                      ref.read(selectedStoreFiltersProvider.notifier).clearFilters();
                      ref.read(userSearchProvider.notifier).clear();
                    },
                    child: Text(
                      'Clear All',
                      style: TossTextStyles.label.copyWith(
                        color: TossColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: TossSpacing.space4),

            // Role Filter
            _buildCollapsibleSection(
              title: 'Role',
              isExpanded: _isRoleExpanded,
              onToggle: () => setState(() => _isRoleExpanded = !_isRoleExpanded),
              child: _buildRoleFilter(context, ref, selectedRoleIds, rolesAsync),
            ),
            SizedBox(height: TossSpacing.space4),

            // Store Filter
            _buildCollapsibleSection(
              title: 'Store',
              isExpanded: _isStoreExpanded,
              onToggle: () => setState(() => _isStoreExpanded = !_isStoreExpanded),
              child: _buildStoreFilter(context, ref, selectedStoreIds, storesAsync),
            ),
            
            if (widget.isMobile) SizedBox(height: TossSpacing.space8),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TossTextStyles.labelLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: TossColors.gray600,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          SizedBox(height: TossSpacing.space2),
          child,
        ],
      ],
    );
  }

  Widget _buildRoleFilter(
    BuildContext context,
    WidgetRef ref,
    List<String> selectedRoleIds,
    AsyncValue<List<Map<String, dynamic>>> rolesAsync,
  ) {
    return rolesAsync.when(
      data: (roles) => Column(
        children: [
          // All roles checkbox
          _buildCheckboxItem(
            'All Roles',
            selectedRoleIds.isEmpty,
            (value) {
              if (value == true) {
                ref.read(selectedRoleFiltersProvider.notifier).clearFilters();
              }
            },
            null,
          ),
          Divider(height: 1, color: TossColors.gray200),
          SizedBox(height: TossSpacing.space2),
          // Individual role checkboxes
          ...roles.map((role) => _buildCheckboxItem(
            role['role_name'] as String,
            selectedRoleIds.contains(role['role_id']),
            (value) {
              ref.read(selectedRoleFiltersProvider.notifier)
                  .toggleRole(role['role_id'] as String);
            },
            _getRoleColor(role['role_name'] as String),
          )),
        ],
      ),
      loading: () => _buildLoadingPlaceholder(),
      error: (_, __) => _buildErrorPlaceholder('Failed to load roles'),
    );
  }

  Widget _buildCheckboxItem(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
    Color? color,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: value ? (color ?? TossColors.primary) : TossColors.gray400,
                  width: 2,
                ),
                color: value ? (color ?? TossColors.primary) : Colors.transparent,
              ),
              child: value
                  ? Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(width: TossSpacing.space3),
            if (color != null && label != 'All Roles') ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: TossSpacing.space2),
            ],
            Expanded(
              child: Text(
                label,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreFilter(
    BuildContext context,
    WidgetRef ref,
    List<String> selectedStoreIds,
    AsyncValue<List<Map<String, dynamic>>> storesAsync,
  ) {
    return storesAsync.when(
      data: (stores) => Column(
        children: [
          // All stores checkbox
          _buildCheckboxItem(
            'All Stores',
            selectedStoreIds.isEmpty,
            (value) {
              if (value == true) {
                ref.read(selectedStoreFiltersProvider.notifier).clearFilters();
              }
            },
            null,
          ),
          Divider(height: 1, color: TossColors.gray200),
          SizedBox(height: TossSpacing.space2),
          // Individual store checkboxes
          ...stores.map((store) => _buildCheckboxItem(
            store['store_name'] as String,
            selectedStoreIds.contains(store['store_id']),
            (value) {
              ref.read(selectedStoreFiltersProvider.notifier)
                  .toggleStore(store['store_id'] as String);
            },
            TossColors.info,
          )),
        ],
      ),
      loading: () => _buildLoadingPlaceholder(),
      error: (_, __) => _buildErrorPlaceholder('Failed to load stores'),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Text(
        message,
        style: TossTextStyles.bodySmall.copyWith(
          color: TossColors.error,
        ),
      ),
    );
  }

  Color _getRoleColor(String roleName) {
    final Map<String, Color> roleColors = {
      'Owner': TossColors.error,
      'Admin': TossColors.primary,
      'Manager': TossColors.warning,
      'Employee': TossColors.success,
      'Staff': TossColors.info,
    };
    
    return roleColors[roleName] ?? TossColors.gray500;
  }
}