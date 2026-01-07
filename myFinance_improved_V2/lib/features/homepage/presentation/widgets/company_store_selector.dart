import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/join_result.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/homepage_providers.dart';
import 'package:myfinance_improved/features/homepage/presentation/widgets/create_company_sheet.dart';
import 'package:myfinance_improved/features/homepage/presentation/widgets/join_by_code_sheet.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';

import 'bottom_sheets/company_actions_sheet.dart';
import 'company_store_list.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Company & Store Selector Drawer
///
/// Bottom drawer for selecting company and store.
/// Shows user info, list of companies with their stores, and "View codes" button.
class CompanyStoreSelector extends ConsumerWidget {
  const CompanyStoreSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final userData = appState.user;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.bottomSheet),
          topRight: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: TossSpacing.iconXL,
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

          // Header with user info
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space6,
              0,
              TossSpacing.space6,
              TossSpacing.space4,
            ),
            child: Row(
              children: [
                // User Info
                Expanded(
                  child: Row(
                    children: [
                      // Avatar - Circle profile image
                      EmployeeProfileAvatar(
                        imageUrl: userData['profile_image'] as String?,
                        name: '${userData['user_first_name'] ?? ''} ${userData['user_last_name'] ?? ''}'.trim(),
                        size: 48,
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      // Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userData['user_first_name'] ?? ''} ${userData['user_last_name'] ?? ''}'
                                  .trim(),
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: TossSpacing.space1 / 2),
                            Text(
                              'Select Company & Store',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Close Button
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    LucideIcons.x,
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Companies & Stores List
          Expanded(
            child: CompanyStoreList(userData: userData),
          ),

          // Create Company Button at bottom
          Container(
            padding: EdgeInsets.only(
              left: TossSpacing.space4,
              right: TossSpacing.space4,
              top: TossSpacing.space4,
              bottom: TossSpacing.space4 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: const BoxDecoration(
              color: TossColors.surface,
              border: Border(
                top: BorderSide(
                  color: TossColors.border,
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: TossButton.primary(
                text: 'Add Company',
                leadingIcon: const Icon(LucideIcons.plus, size: TossSpacing.iconMD),
                onPressed: () => _showCompanyActionsBottomSheet(context, ref),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show Company Actions Bottom Sheet (Create or Join)
  void _showCompanyActionsBottomSheet(BuildContext context, WidgetRef ref) {
    CompanyActionsSheet.show(
      context,
      onCreateCompany: () => _handleCreateCompany(context, ref),
      onJoinCompany: () => _handleJoinCompany(context, ref),
    );
  }

  void _handleCreateCompany(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop(); // Close company actions sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      elevation: 0,
      builder: (context) => const CreateCompanySheet(),
    ).then((company) {
      if (company != null && company is Company) {
        _refreshDataAfterCompanyCreation(context, ref, company);
      }
    });
  }

  void _handleJoinCompany(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop(); // Close company actions sheet
    Future.delayed(TossAnimations.quick, () {
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: TossColors.transparent,
          elevation: 0,
          builder: (context) => const JoinByCodeSheet(
            title: 'Join Company',
            subtitle: 'Enter company invite code',
          ),
        ).then((result) {
          if (result != null && result is JoinResult) {
            _refreshDataAfterJoin(context, ref, result);
          }
        });
      }
    });
  }

  Future<void> _refreshDataAfterCompanyCreation(BuildContext context, WidgetRef ref, Company company) async {
    // ✅ CreateCompanySheet에서 이미 AppState 업데이트 완료됨
    // 여기서는 drawer만 닫고 토스트 표시
    if (context.mounted) {
      Navigator.of(context).pop(); // drawer 닫기
      TossToast.success(context, 'Company "${company.name}" created successfully!');
    }
  }

  Future<void> _refreshDataAfterJoin(BuildContext context, WidgetRef ref, JoinResult result) async {
    // ✅ AppState 업데이트 (Hive 캐시도 자동 동기화됨)
    if (result.isCompanyJoin && result.companyId != null) {
      ref.read(appStateProvider.notifier).addNewCompanyToUser(
        companyId: result.companyId!,
        companyName: result.companyName ?? 'Company',
        role: {'role_name': result.roleAssigned ?? 'Member', 'permissions': []},
      );
    } else if (result.isStoreJoin && result.storeId != null && result.companyId != null) {
      ref.read(appStateProvider.notifier).addNewStoreToCompany(
        companyId: result.companyId!,
        storeId: result.storeId!,
        storeName: result.storeName ?? 'Store',
      );
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

    // Drawer 닫기 + 토스트
    if (context.mounted) {
      Navigator.of(context).pop();
      TossToast.success(context, 'Successfully joined ${result.entityName}!');
    }
  }
}
