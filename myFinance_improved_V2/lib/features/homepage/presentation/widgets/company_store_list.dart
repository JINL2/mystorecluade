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
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/selection_bottom_sheet_common.dart';

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
            style: TossTextStyles.h3Secondary,
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Create or join a company to get started',
            style: TossTextStyles.bodyTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, dynamic company, dynamic appState) {
    final companyId = company['company_id'] as String;
    final companyName = company['company_name'] as String;
    final stores = company['stores'] as List<dynamic>? ?? [];
    final isExpanded = expandedCompanyId == companyId;

    // Find the selected store name for this company (for footer display)
    final selectedStoreId = appState.storeChoosen as String?;
    String? selectedStoreName;
    for (final store in stores) {
      if (store['store_id'] == selectedStoreId) {
        selectedStoreName = store['store_name'] as String?;
        break;
      }
    }

    // Show footer only when collapsed AND a store is selected for this company
    final showFooter = !isExpanded && selectedStoreName != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          border: Border.all(color: TossColors.gray100),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header (always visible, tappable)
            InkWell(
              onTap: () => _toggleCompanyExpansion(companyId),
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(TossBorderRadius.lg),
                bottom: (isExpanded || showFooter) ? Radius.zero : const Radius.circular(TossBorderRadius.lg),
              ),
              child: Padding(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: _buildCompanyHeader(context, company, companyId, companyName, stores, isExpanded),
              ),
            ),

            // Content (only when expanded)
            if (isExpanded) ...[
              Container(height: 1, color: TossColors.gray100),
              stores.isNotEmpty
                  ? _buildStoresList(context, stores, companyId, companyName, appState)
                  : _buildNoStoresMessage(),
            ],

            // Footer (only when collapsed AND store is selected)
            if (showFooter && selectedStoreName != null) ...[
              Container(height: 1, color: TossColors.gray100),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
                child: _buildSelectedStoreFooter(selectedStoreName, stores.length),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Footer showing the selected store (shown only when collapsed and store is selected)
  Widget _buildSelectedStoreFooter(String selectedStoreName, int storeCount) {
    return Row(
      children: [
        const Icon(
          LucideIcons.store,
          size: TossSpacing.iconSM2,
          color: TossColors.textSecondary,
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: Text(
            selectedStoreName,
            style: TossTextStyles.caption, // 12px, default color
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '$storeCount ${storeCount == 1 ? 'store' : 'stores'}',
          style: TossTextStyles.captionTertiary,
        ),
      ],
    );
  }

  Widget _buildCompanyHeader(
    BuildContext context,
    dynamic company,
    String companyId,
    String companyName,
    List<dynamic> stores,
    bool isExpanded,
  ) {
    return Row(
      children: [
        // Company Icon
        Container(
          width: TossSpacing.space8,
          height: TossSpacing.space8,
          decoration: BoxDecoration(
            color: isExpanded ? TossColors.primary : TossColors.gray200,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Icon(
            LucideIcons.building2,
            color: isExpanded ? TossColors.white : TossColors.textSecondary,
            size: TossSpacing.iconSM3,
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        // Company Name and Badge
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  companyName,
                  style: TossTextStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              SubscriptionBadge.fromPlanType(
                (company['subscription'] as Map<String, dynamic>?)?['plan_name'] as String?,
                compact: true,
              ),
            ],
          ),
        ),
        // 3-dot menu (stop propagation to not trigger expand/collapse)
        GestureDetector(
          onTap: () => _showCompanyMenuBottomSheet(context, ref, company),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space1),
            child: Icon(
              LucideIcons.moreHorizontal,
              size: TossSpacing.iconSM3,
              color: TossColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space1),
        // Expand/collapse arrow indicator (using AnimatedRotation like TossExpandableCard)
        AnimatedRotation(
          turns: isExpanded ? 0.5 : 0,
          duration: TossAnimations.fast,
          child: Icon(
            LucideIcons.chevronDown,
            size: TossSpacing.iconMD,
            color: TossColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStoresList(
    BuildContext context,
    List<dynamic> stores,
    String companyId,
    String companyName,
    dynamic appState,
  ) {
    return Column(
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
    // Align store icon with company icon:
    // Company icon starts at space4 (16px) from edge
    // Store item needs same left padding to align icons
    return InkWell(
      onTap: () {
        final appStateNotifier = ref.read(appStateProvider.notifier);
        final currentCompanyId = ref.read(appStateProvider).companyChoosen;

        // ✅ FIX: Only call selectCompany if company actually changed
        if (currentCompanyId != companyId) {
          appStateNotifier.selectCompany(companyId, companyName: companyName);
        }
        appStateNotifier.selectStore(storeId, storeName: storeName);
        context.pop();
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        padding: const EdgeInsets.only(
          left: TossSpacing.space4,  // Align with company icon
          right: TossSpacing.space4,
          top: TossSpacing.space3,
          bottom: TossSpacing.space3,
        ),
        // No background color - transparent for both selected and unselected
        child: Row(
          children: [
            Icon(
              LucideIcons.store,
              size: TossSpacing.iconSM2,
              color: isStoreSelected ? TossColors.primary : TossColors.textSecondary,
            ),
            const SizedBox(width: TossSpacing.space3), // 12px spacing
            Expanded(
              child: Text(
                storeName,
                style: TossTextStyles.body, // 14px, black text for all
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
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      child: Text(
        'No stores available',
        style: TossTextStyles.captionTertiary,
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
    TossBottomSheet.showWithBuilder(
      context: context,
      builder: (context) => CodesBottomSheet(company: company),
    );
  }

  /// Show company menu bottom sheet (3-dot menu)
  void _showCompanyMenuBottomSheet(BuildContext context, WidgetRef ref, dynamic company) {
    final companyName = company['company_name'] as String;
    SelectionBottomSheetCommon.show(
      context: context,
      title: companyName,
      showDividers: true,
      maxHeightRatio: 0.4,
      children: [
        ListTile(
          leading: const Icon(LucideIcons.qrCode, size: TossSpacing.iconMD),
          title: const Text('View Codes'),
          onTap: () {
            Navigator.pop(context);
            _showCodesBottomSheet(context, company);
          },
        ),
        ListTile(
          leading: const Icon(LucideIcons.plus, size: TossSpacing.iconMD),
          title: const Text('Add Store'),
          onTap: () {
            Navigator.pop(context);
            _showStoreActionsBottomSheet(context, ref, company);
          },
        ),
      ],
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
    TossBottomSheet.showWithBuilder(
      context: context,
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
        TossBottomSheet.showWithBuilder(
          context: context,
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
