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
import 'package:myfinance_improved/shared/themes/toss_animations.dart';

import 'bottom_sheets/store_actions_sheet.dart';
import 'view_invite_codes_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
    // ✅ AppState에서 직접 companies 가져오기 (즉시 반영)
    // widget.userData 대신 appState.user 사용 → 새 company/store 추가 시 즉시 UI 업데이트
    final appState = ref.watch(appStateProvider);
    final companies = appState.user['companies'] as List<dynamic>? ?? [];

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
        padding: const EdgeInsets.all(TossSpacing.space1),
        child: Icon(
          isSelected ? LucideIcons.chevronDown : LucideIcons.chevronRight,
          size: TossSpacing.iconSM3,
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
            width: TossSpacing.space8,
            height: TossSpacing.space8,
            decoration: BoxDecoration(
              color: isSelected ? TossColors.primary : TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Icon(
              LucideIcons.building2,
              color: isSelected ? TossColors.white : TossColors.textSecondary,
              size: TossSpacing.iconSM3,
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
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: TossSpacing.space1 + TossSpacing.space1 / 2),
                    SubscriptionBadge.fromPlanType(
                      (company['subscription'] as Map<String, dynamic>?)?['plan_name'] as String?,
                      compact: true,
                    ),
                  ],
                ),
                Text(
                  '${stores.length} ${stores.length == 1 ? 'store' : 'stores'}',
                  style: TossTextStyles.small.copyWith(
                    color: TossColors.textTertiary,
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
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space1),
        child: Icon(
          LucideIcons.moreHorizontal,
          size: TossSpacing.iconSM3,
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
        final currentCompanyId = ref.read(appStateProvider).companyChoosen;

        // ✅ FIX: Only call selectCompany if company actually changed
        // Previously always called selectCompany which triggered provider rebuilds
        // even when selecting a different store within the same company
        if (currentCompanyId != companyId) {
          appStateNotifier.selectCompany(companyId, companyName: companyName);
        }
        appStateNotifier.selectStore(storeId, storeName: storeName);
        context.pop();
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        padding: const EdgeInsets.only(
          left: TossSpacing.space8,
          right: TossSpacing.space2,
          top: TossSpacing.space2,
          bottom: TossSpacing.space2,
        ),
        margin: const EdgeInsets.only(bottom: TossSpacing.space1),
        decoration: BoxDecoration(
          color: isStoreSelected ? TossColors.primarySurface : TossColors.transparent,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.store,
              size: TossSpacing.iconSM2,
              color: isStoreSelected ? TossColors.textPrimary : TossColors.textSecondary,
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                storeName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.textPrimary,
                ),
              ),
            ),
            if (isStoreSelected)
              const Icon(
                LucideIcons.check,
                color: TossColors.primary,
                size: TossSpacing.iconSM2,
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
        padding: const EdgeInsets.only(left: TossSpacing.space8),
        child: Text(
          'No stores',
          style: TossTextStyles.body.copyWith(
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
              width: TossSpacing.space10,
              height: TossSpacing.space1,
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
              leading: const Icon(LucideIcons.qrCode, size: TossSpacing.iconMD),
              title: const Text('View Codes'),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _showCodesBottomSheet(context, company);
              },
            ),
            const Divider(height: 1),
            // Add store option (create or join)
            ListTile(
              leading: const Icon(LucideIcons.plus, size: TossSpacing.iconMD),
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
    Future.delayed(TossAnimations.quick, () {
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
    // ✅ CreateStoreSheet에서 이미 AppState 업데이트 + provider invalidate 완료됨
    // 여기서는 drawer만 닫고 토스트 표시
    if (context.mounted) {
      Navigator.of(context).pop(); // drawer 닫기
      TossToast.success(context, 'Store "${store.name}" created successfully!');
    }
  }

  Future<void> _refreshDataAfterStoreJoin(BuildContext context, WidgetRef ref, JoinResult result) async {
    // ✅ AppState 업데이트 (Hive 캐시도 자동 동기화됨)
    if (result.storeId != null && result.companyId != null) {
      ref.read(appStateProvider.notifier).addNewStoreToCompany(
        companyId: result.companyId!,
        storeId: result.storeId!,
        storeName: result.storeName ?? 'Store',
      );
    }

    if (result.companyId != null) {
      final currentCompanyId = ref.read(appStateProvider).companyChoosen;

      // Only call selectCompany if company actually changed
      if (currentCompanyId != result.companyId) {
        ref.read(appStateProvider.notifier).selectCompany(
          result.companyId!,
          companyName: result.companyName,
        );
      }

      if (result.storeId != null) {
        ref.read(appStateProvider.notifier).selectStore(
          result.storeId!,
          storeName: result.storeName,
        );
      }
    }

    // Drawer 닫기 + 토스트
    if (context.mounted) {
      Navigator.of(context).pop();
      TossToast.success(context, 'Successfully joined ${result.entityName}!');
    }
  }
}
