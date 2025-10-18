import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/features/homepage/presentation/widgets/create_company_sheet.dart';
import 'package:myfinance_improved/features/homepage/presentation/widgets/create_store_sheet.dart';
import 'package:myfinance_improved/features/homepage/presentation/widgets/join_by_code_sheet.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/join_result.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/homepage_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'view_invite_codes_sheet.dart';

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
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(
              top: TossSpacing.space2,
              bottom: TossSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: TossColors.textTertiary.withOpacity(0.3),
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
                      // Avatar
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: TossColors.primary.withOpacity(0.2),
                        child: Text(
                          userData['user_first_name'] != null &&
                                  (userData['user_first_name'] as String)
                                      .isNotEmpty
                              ? (userData['user_first_name'] as String)[0]
                                  .toUpperCase()
                              : 'U',
                          style: TossTextStyles.h3.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
                            const SizedBox(height: 2),
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
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Companies & Stores List
          Expanded(
            child: _CompanyStoreList(userData: userData),
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
              child: TossPrimaryButton(
                text: 'Create Company',
                leadingIcon: const Icon(Icons.add, size: 20),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => _CompanyActionsSheet(parentContext: context, ref: ref),
    );
  }
}

/// Company & Store List Widget
class _CompanyStoreList extends ConsumerStatefulWidget {
  final Map<String, dynamic> userData;

  const _CompanyStoreList({required this.userData});

  @override
  ConsumerState<_CompanyStoreList> createState() => _CompanyStoreListState();
}

class _CompanyStoreListState extends ConsumerState<_CompanyStoreList> {
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
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

    return ListView.builder(
      padding: const EdgeInsets.all(TossSpacing.space4),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        final companyId = company['company_id'] as String;
        final companyName = company['company_name'] as String;
        final stores = company['stores'] as List<dynamic>? ?? [];
        final isSelected = expandedCompanyId == companyId;

        return Container(
          margin: const EdgeInsets.only(bottom: TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: isSelected
                  ? TossColors.primary.withOpacity(0.3)
                  : TossColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Header
              InkWell(
                onTap: () {
                  // Toggle expand/collapse of company's store list
                  setState(() {
                    if (expandedCompanyId == companyId) {
                      // If already expanded, collapse it
                      expandedCompanyId = null;
                    } else {
                      // Expand this company
                      expandedCompanyId = companyId;
                    }
                  });
                },
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                child: Padding(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? TossColors.primary
                              : TossColors.gray200,
                          borderRadius:
                              BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Icon(
                          Icons.business,
                          color: isSelected
                              ? TossColors.white
                              : TossColors.textSecondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companyName,
                              style: TossTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${stores.length} ${stores.length == 1 ? 'store' : 'stores'}',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Stores List (if company is selected)
              if (isSelected && stores.isNotEmpty) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(TossSpacing.space3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stores',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      ...stores.map((store) {
                        final storeId = store['store_id'] as String;
                        final storeName = store['store_name'] as String;
                        final isStoreSelected =
                            appState.storeChoosen == storeId;

                        return InkWell(
                          onTap: () {
                            final appStateNotifier =
                                ref.read(appStateProvider.notifier);

                            // Select company first
                            appStateNotifier.selectCompany(
                              companyId,
                              companyName: companyName,
                            );

                            // Then select store
                            appStateNotifier.selectStore(
                              storeId,
                              storeName: storeName,
                            );

                            Navigator.of(context).pop();
                          },
                          borderRadius:
                              BorderRadius.circular(TossBorderRadius.md),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space3,
                              vertical: TossSpacing.space2,
                            ),
                            margin: const EdgeInsets.only(
                              bottom: TossSpacing.space1,
                            ),
                            decoration: BoxDecoration(
                              color: isStoreSelected
                                  ? TossColors.primary.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(TossBorderRadius.md),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.store_outlined,
                                  size: 18,
                                  color: isStoreSelected
                                      ? TossColors.primary
                                      : TossColors.textSecondary,
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Expanded(
                                  child: Text(
                                    storeName,
                                    style: TossTextStyles.body.copyWith(
                                      fontWeight: isStoreSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isStoreSelected
                                          ? TossColors.primary
                                          : TossColors.textPrimary,
                                    ),
                                  ),
                                ),
                                if (isStoreSelected)
                                  const Icon(
                                    Icons.check,
                                    color: TossColors.primary,
                                    size: 18,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: TossSpacing.space2),

                      // View Codes and Create Store buttons side by side
                      Row(
                        children: [
                          // View Codes Button
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showCodesBottomSheet(context, company),
                              icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                              label: const Text('View codes'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: TossColors.textSecondary,
                                side: const BorderSide(color: TossColors.border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space3,
                                  vertical: TossSpacing.space2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          // Create Store Button
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showStoreActionsBottomSheet(context, ref, company),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Create Store'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: TossColors.primary,
                                side: const BorderSide(color: TossColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space3,
                                  vertical: TossSpacing.space2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              // Show Create Store button even if no stores (for selected company)
              if (isSelected && stores.isEmpty) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(TossSpacing.space3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stores',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      Text(
                        'No stores yet',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showStoreActionsBottomSheet(context, ref, company),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Create Store'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: TossColors.primary,
                            side: const BorderSide(color: TossColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space3,
                              vertical: TossSpacing.space2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Show codes bottom sheet
  void _showCodesBottomSheet(BuildContext context, dynamic company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => CodesBottomSheet(company: company),
    );
  }

  /// Show Store Actions Bottom Sheet (for selected company)
  void _showStoreActionsBottomSheet(BuildContext context, WidgetRef ref, dynamic company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => _StoreActionsSheet(
        parentContext: context,
        ref: ref,
        company: company,
      ),
    );
  }
}

/// Company Actions Bottom Sheet (Create or Join Company)
class _CompanyActionsSheet extends StatelessWidget {
  final BuildContext parentContext;
  final WidgetRef ref;

  const _CompanyActionsSheet({
    required this.parentContext,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: TossColors.textTertiary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space6),
            child: Row(
              children: [
                Text(
                  'Company Options',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: TossColors.textSecondary),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          // Options
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space6,
              0,
              TossSpacing.space6,
              TossSpacing.space6,
            ),
            child: Column(
              children: [
                // Create Company
                _buildOptionCard(
                  context,
                  icon: Icons.business,
                  title: 'Create Company',
                  subtitle: 'Start a new company and invite others',
                  onTap: () => _handleCreateCompany(context),
                ),

                const SizedBox(height: TossSpacing.space4),

                // Join Company by Code
                _buildOptionCard(
                  context,
                  icon: Icons.group_add,
                  title: 'Join Company',
                  subtitle: 'Enter company invite code to join',
                  onTap: () => _handleJoinCompany(context),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _handleCreateCompany(BuildContext context) {
    // Close the actions sheet first
    Navigator.of(context).pop();

    // Show create company sheet
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => const CreateCompanySheet(),
    ).then((company) {
      if (company != null && company is Company) {
        _refreshDataAfterCompanyCreation(company);
      }
    });
  }

  Future<void> _refreshDataAfterCompanyCreation(Company company) async {
    // Close the selector drawer (only if context is still mounted)
    if (parentContext.mounted) {
      Navigator.of(parentContext).pop();
    }

    // 1. Add company to user's companies list in AppState (instant UI update)
    ref.read(appStateProvider.notifier).addNewCompanyToUser(
      companyId: company.id,
      companyName: company.name,
      companyCode: company.code,
    );

    // 2. Set the new company as selected
    ref.read(appStateProvider.notifier).selectCompany(
      company.id,
      companyName: company.name,
    );

    // 3. Invalidate providers to refresh data from server (background)
    ref.invalidate(userCompaniesProvider);

    // Show success message immediately
    if (parentContext.mounted) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        SnackBar(
          content: Text('Company "${company.name}" created successfully!'),
          backgroundColor: TossColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
      );
    }
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(icon, color: TossColors.primary, size: 24),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: TossColors.textTertiary),
          ],
        ),
      ),
    );
  }

  void _handleJoinCompany(BuildContext context) {
    // Close the actions sheet first
    Navigator.of(context).pop();

    // Show join by code sheet
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => const JoinByCodeSheet(
        title: 'Join Company',
        subtitle: 'Enter company invite code',
      ),
    ).then((result) {
      if (result != null && result is JoinResult) {
        _refreshDataAfterJoin(result);
      }
    });
  }

  Future<void> _refreshDataAfterJoin(JoinResult result) async {
    // Close the selector drawer (only if context is still mounted)
    if (parentContext.mounted) {
      Navigator.of(parentContext).pop();
    }

    // 1. Add joined company/store to AppState (instant UI update)
    if (result.isCompanyJoin && result.companyId != null) {
      // Joined a company
      ref.read(appStateProvider.notifier).addNewCompanyToUser(
        companyId: result.companyId!,
        companyName: result.companyName ?? 'Company',
        role: {'role_name': result.roleAssigned ?? 'Member', 'permissions': []},
      );
    } else if (result.isStoreJoin && result.storeId != null && result.companyId != null) {
      // Joined a store
      ref.read(appStateProvider.notifier).addNewStoreToCompany(
        companyId: result.companyId!,
        storeId: result.storeId!,
        storeName: result.storeName ?? 'Store',
      );
    }

    // 2. Set the joined company/store as selected
    if (result.companyId != null) {
      ref.read(appStateProvider.notifier).selectCompany(
        result.companyId!,
        companyName: result.companyName,
      );

      // If joined a store, select it too
      if (result.storeId != null) {
        ref.read(appStateProvider.notifier).selectStore(
          result.storeId!,
          storeName: result.storeName,
        );
      }
    }

    // 3. Invalidate providers to refresh data from server (background)
    ref.invalidate(userCompaniesProvider);

    // Show success message immediately
    if (parentContext.mounted) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
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

/// Store Actions Bottom Sheet (Create or Join Store)
class _StoreActionsSheet extends StatelessWidget {
  final BuildContext parentContext;
  final WidgetRef ref;
  final dynamic company;

  const _StoreActionsSheet({
    required this.parentContext,
    required this.ref,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    final companyName = (company['company_name'] ?? '') as String;

    return Container(
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
              color: TossColors.textTertiary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space6),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store Options',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'For $companyName',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: TossColors.textSecondary),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          // Options
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space6,
              0,
              TossSpacing.space6,
              TossSpacing.space6,
            ),
            child: Column(
              children: [
                // Create Store
                _buildOptionCard(
                  context,
                  icon: Icons.store,
                  title: 'Create Store',
                  subtitle: 'Add a new store to $companyName',
                  onTap: () => _handleCreateStore(context),
                ),

                const SizedBox(height: TossSpacing.space4),

                // Join Store by Code
                _buildOptionCard(
                  context,
                  icon: Icons.add_location,
                  title: 'Join Store',
                  subtitle: 'Enter store invite code to join',
                  onTap: () => _handleJoinStore(context),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _handleCreateStore(BuildContext context) {
    // Close the actions sheet first
    Navigator.of(context).pop();

    final companyId = company['company_id'] as String;
    final companyName = company['company_name'] as String;

    // Show create store sheet
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => CreateStoreSheet(
        companyId: companyId,
        companyName: companyName,
      ),
    ).then((store) {
      if (store != null && store is Store) {
        _refreshDataAfterStoreCreation(store, companyId);
      }
    });
  }

  Future<void> _refreshDataAfterStoreCreation(Store store, String companyId) async {
    // Close the selector drawer (only if context is still mounted)
    if (parentContext.mounted) {
      Navigator.of(parentContext).pop();
    }

    // 1. Add store to company's stores list in AppState (instant UI update)
    ref.read(appStateProvider.notifier).addNewStoreToCompany(
      companyId: companyId,
      storeId: store.id,
      storeName: store.name,
      storeCode: store.code,
    );

    // 2. Set the new store as selected
    ref.read(appStateProvider.notifier).selectStore(
      store.id,
      storeName: store.name,
    );

    // 3. Invalidate providers to refresh data from server (background)
    ref.invalidate(userCompaniesProvider);

    // Show success message immediately
    if (parentContext.mounted) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
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

  void _handleJoinStore(BuildContext context) {
    // Close the actions sheet first
    Navigator.of(context).pop();

    // Show join by code sheet
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => const JoinByCodeSheet(
        title: 'Join Store',
        subtitle: 'Enter store invite code',
      ),
    ).then((result) {
      if (result != null && result is JoinResult) {
        _refreshDataAfterJoin(result);
      }
    });
  }

  Future<void> _refreshDataAfterJoin(JoinResult result) async {
    // Close the selector drawer
    Navigator.of(parentContext).pop();

    // If joined a company with a store, select both
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

    // Invalidate providers to refresh data
    ref.invalidate(userCompaniesProvider);

    // Wait for data to reload
    await ref.read(userCompaniesProvider.future);
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(icon, color: TossColors.primary, size: 24),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: TossColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
