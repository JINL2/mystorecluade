import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/join_result.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/homepage_providers.dart';
import 'package:myfinance_improved/features/homepage/presentation/widgets/create_store_sheet.dart';
import 'package:myfinance_improved/features/homepage/presentation/widgets/join_by_code_sheet.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_badge.dart';

import 'bottom_sheets/store_actions_sheet.dart';
import 'view_invite_codes_sheet.dart';

/// Company & Store List Widget
///
/// Displays a list of companies with their stores.
/// Extracted from company_store_selector.dart for better maintainability.
class CompanyStoreList extends ConsumerStatefulWidget {
  final Map<String, dynamic> userData;

  const CompanyStoreList({super.key, required this.userData});

  @override
  ConsumerState<CompanyStoreList> createState() => _CompanyStoreListState();
}

class _CompanyStoreListState extends ConsumerState<CompanyStoreList> {
  String? expandedCompanyId;

  @override
  void initState() {
    super.initState();
    // Initially expand the currently selected company
    final appState = ref.read(appStateProvider);
    expandedCompanyId = appState.companyChoosen.isNotEmpty ? appState.companyChoosen : null;
  }

  @override
  Widget build(BuildContext context) {
    final companies = widget.userData['companies'] as List<dynamic>? ?? [];
    final appState = ref.watch(appStateProvider);

    if (companies.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(TossSpacing.space4),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return _buildCompanyCard(context, company, appState);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            LucideIcons.building,
            size: 64,
            color: TossColors.textTertiary,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'No Companies',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Create or join a company to get started',
            style: TossTextStyles.body.copyWith(
              color: TossColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, dynamic company, dynamic appState) {
    final companyId = company['company_id'] as String;
    final companyName = company['company_name'] as String;
    final stores = company['stores'] as List<dynamic>? ?? [];
    final isSelected = expandedCompanyId == companyId;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Header
          _buildCompanyHeader(context, company, companyId, companyName, stores, isSelected),

          // Stores List (if company is selected)
          if (isSelected && stores.isNotEmpty)
            _buildStoresList(context, stores, companyId, companyName, appState),

          // Show empty state if no stores (for selected company)
          if (isSelected && stores.isEmpty)
            _buildNoStoresMessage(),
        ],
      ),
    );
  }

  Widget _buildCompanyHeader(
    BuildContext context,
    dynamic company,
    String companyId,
    String companyName,
    List<dynamic> stores,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          // Expand/Collapse Arrow (on the left)
          _buildExpandCollapseButton(companyId, isSelected),
          const SizedBox(width: TossSpacing.space2),
          // Company Icon and Name
          Expanded(
            child: _buildCompanyInfo(companyId, companyName, stores, isSelected, company),
          ),
          // 3-dot menu (on the right)
          _buildMenuButton(context, company),
        ],
      ),
    );
  }

  Widget _buildExpandCollapseButton(String companyId, bool isSelected) {
    return InkWell(
      onTap: () => _toggleCompanyExpansion(companyId),
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          isSelected ? LucideIcons.chevronDown : LucideIcons.chevronRight,
          size: 18,
          color: TossColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildCompanyInfo(
    String companyId,
    String companyName,
    List<dynamic> stores,
    bool isSelected,
    dynamic company,
  ) {
    return InkWell(
      onTap: () => _toggleCompanyExpansion(companyId),
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected ? TossColors.primary : TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Icon(
              LucideIcons.building2,
              color: isSelected ? TossColors.white : TossColors.textSecondary,
              size: 18,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        companyName,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    SubscriptionBadge.fromPlanType(
                      (company['subscription'] as Map<String, dynamic>?)?['plan_name'] as String?,
                      compact: true,
                    ),
                  ],
                ),
                Text(
                  '${stores.length} ${stores.length == 1 ? 'store' : 'stores'}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, dynamic company) {
    return InkWell(
      onTap: () => _showCompanyMenuBottomSheet(context, ref, company),
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: Icon(
          LucideIcons.moreHorizontal,
          size: 18,
          color: TossColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildStoresList(
    BuildContext context,
    List<dynamic> stores,
    String companyId,
    String companyName,
    dynamic appState,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        top: TossSpacing.space1,
        bottom: TossSpacing.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: stores.map((store) {
          final storeId = store['store_id'] as String;
          final storeName = store['store_name'] as String;
          final isStoreSelected = appState.storeChoosen == storeId;

          return _buildStoreItem(
            context,
            storeId,
            storeName,
            companyId,
            companyName,
            isStoreSelected,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStoreItem(
    BuildContext context,
    String storeId,
    String storeName,
    String companyId,
    String companyName,
    bool isStoreSelected,
  ) {
    return InkWell(
      onTap: () {
        final appStateNotifier = ref.read(appStateProvider.notifier);
        appStateNotifier.selectCompany(companyId, companyName: companyName);
        appStateNotifier.selectStore(storeId, storeName: storeName);
        context.pop();
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        padding: const EdgeInsets.only(
          left: 36,
          right: TossSpacing.space2,
          top: TossSpacing.space2,
          bottom: TossSpacing.space2,
        ),
        margin: const EdgeInsets.only(bottom: TossSpacing.space1),
        decoration: BoxDecoration(
          color: isStoreSelected ? TossColors.primarySurface : Colors.transparent,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.store,
              size: 16,
              color: isStoreSelected ? TossColors.textPrimary : TossColors.textSecondary,
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                storeName,
                style: TossTextStyles.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: TossColors.textPrimary,
                ),
              ),
            ),
            if (isStoreSelected)
              const Icon(
                LucideIcons.check,
                color: TossColors.primary,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoStoresMessage() {
    return Padding(
      padding: const EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        top: TossSpacing.space1,
        bottom: TossSpacing.space2,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 36),
        child: Text(
          'No stores',
          style: TossTextStyles.caption.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: TossColors.textTertiary,
          ),
        ),
      ),
    );
  }

  void _toggleCompanyExpansion(String companyId) {
    setState(() {
      if (expandedCompanyId == companyId) {
        expandedCompanyId = null;
      } else {
        expandedCompanyId = companyId;
      }
    });
  }

  /// Show codes bottom sheet
  void _showCodesBottomSheet(BuildContext context, dynamic company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      elevation: 0,
      builder: (context) => CodesBottomSheet(company: company),
    );
  }

  /// Show company menu bottom sheet (3-dot menu)
  void _showCompanyMenuBottomSheet(BuildContext context, WidgetRef ref, dynamic company) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      elevation: 0,
      builder: (bottomSheetContext) => Container(
        decoration: const BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.bottomSheet),
            topRight: Radius.circular(TossBorderRadius.bottomSheet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(
                top: TossSpacing.space2,
                bottom: TossSpacing.space4,
              ),
              decoration: BoxDecoration(
                color: TossColors.textTertiary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            // View codes option
            ListTile(
              leading: const Icon(LucideIcons.qrCode, size: 20),
              title: const Text('View Codes'),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _showCodesBottomSheet(context, company);
              },
            ),
            const Divider(height: 1),
            // Add store option (create or join)
            ListTile(
              leading: const Icon(LucideIcons.plus, size: 20),
              title: const Text('Add Store'),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _showStoreActionsBottomSheet(context, ref, company);
              },
            ),
            SizedBox(height: MediaQuery.of(bottomSheetContext).padding.bottom),
          ],
        ),
      ),
    );
  }

  /// Show Store Actions Bottom Sheet (for selected company)
  void _showStoreActionsBottomSheet(BuildContext context, WidgetRef ref, dynamic company) {
    final companyId = company['company_id'] as String;
    final companyName = company['company_name'] as String;

    StoreActionsSheet.show(
      context,
      companyName: companyName,
      onCreateStore: () => _handleCreateStore(context, ref, companyId, companyName),
      onJoinStore: () => _handleJoinStore(context, ref),
    );
  }

  void _handleCreateStore(BuildContext context, WidgetRef ref, String companyId, String companyName) {
    Navigator.of(context).pop(); // Close store actions sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      elevation: 0,
      builder: (context) => CreateStoreSheet(
        companyId: companyId,
        companyName: companyName,
      ),
    ).then((store) {
      if (store != null && store is Store) {
        _refreshDataAfterStoreCreation(context, ref, store, companyId);
      }
    });
  }

  void _handleJoinStore(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop(); // Close store actions sheet
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: TossColors.transparent,
          elevation: 0,
          builder: (context) => const JoinByCodeSheet(
            title: 'Join Store',
            subtitle: 'Enter store invite code',
          ),
        ).then((result) {
          if (result != null && result is JoinResult) {
            _refreshDataAfterStoreJoin(context, ref, result);
          }
        });
      }
    });
  }

  Future<void> _refreshDataAfterStoreCreation(BuildContext context, WidgetRef ref, Store store, String companyId) async {
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    ref.read(appStateProvider.notifier).addNewStoreToCompany(
      companyId: companyId,
      storeId: store.id,
      storeName: store.name,
      storeCode: store.code,
    );

    ref.read(appStateProvider.notifier).selectStore(
      store.id,
      storeName: store.name,
    );

    ref.invalidate(userCompaniesProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Store "${store.name}" created successfully!'),
          backgroundColor: TossColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
      );
    }
  }

  Future<void> _refreshDataAfterStoreJoin(BuildContext context, WidgetRef ref, JoinResult result) async {
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    if (result.companyId != null) {
      ref.read(appStateProvider.notifier).selectCompany(
        result.companyId!,
        companyName: result.companyName,
      );

      if (result.storeId != null) {
        ref.read(appStateProvider.notifier).selectStore(
          result.storeId!,
          storeName: result.storeName,
        );
      }
    }

    ref.invalidate(userCompaniesProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully joined ${result.entityName}!'),
          backgroundColor: TossColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
      );
    }
  }
}
