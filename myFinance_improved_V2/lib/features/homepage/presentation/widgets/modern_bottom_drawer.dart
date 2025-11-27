import 'package:flutter/material.dart' hide DrawerHeader;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../../core/domain/entities/company.dart';
import '../../../../core/domain/entities/store.dart';
import '../../domain/providers/usecase_providers.dart';
import '../../domain/usecases/create_company.dart';
import '../../domain/usecases/create_store.dart';
import '../../domain/usecases/join_by_code.dart';
import '../providers/homepage_providers.dart';
import 'bottom_sheets/codes_display_sheet.dart';
import 'bottom_sheets/company_actions_sheet.dart';
import 'bottom_sheets/input_bottom_sheet.dart';
import 'bottom_sheets/store_actions_sheet.dart';
import 'create_company_sheet.dart';
import 'create_store_sheet.dart';
import 'drawer_sections/drawer_header.dart' as custom;
import 'helpers/snackbar_helpers.dart';

/// Modern bottom drawer using bottom sheet pattern
class ModernBottomDrawer extends ConsumerStatefulWidget {
  const ModernBottomDrawer({
    super.key,
    required this.userData,
  });

  final Map<String, dynamic>? userData;

  /// Show the bottom drawer as a modal bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Map<String, dynamic>? userData,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(TossBorderRadius.bottomSheet),
              topRight: Radius.circular(TossBorderRadius.bottomSheet),
            ),
          ),
          child: ModernBottomDrawer(userData: userData),
        ),
      ),
    );
  }

  @override
  ConsumerState<ModernBottomDrawer> createState() => _ModernBottomDrawerState();
}

class _ModernBottomDrawerState extends ConsumerState<ModernBottomDrawer> {
  final Map<String, bool> _expandedCompanies = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appStateProvider);
    final userCompaniesAsync = ref.watch(userCompaniesProvider);

    // ✅ Get UserWithCompanies entity directly from provider
    final userData = userCompaniesAsync.maybeWhen(
      data: (data) => data ?? widget.userData,
      orElse: () => widget.userData,
    );

    // Get selected company from app state
    final appState = ref.read(appStateProvider);
    final selectedCompanyId = appState.companyChoosen;

    // Find the selected company data from user companies
    Company? selectedCompany;
    if (userData != null) {
      try {
        final companies = (userData['companies'] as List<dynamic>?) ?? [];
        final companyMap = companies.cast<Map<String, dynamic>>().firstWhere(
          (c) => c['company_id'] == selectedCompanyId,
          orElse: () => <String, dynamic>{},
        );

        if (companyMap.isNotEmpty) {
          selectedCompany = Company.fromMap(companyMap);
        }
      } catch (e, stackTrace) {
        // Log error for debugging but don't crash
        debugPrint('❌ Error finding company $selectedCompanyId: $e');
        debugPrint('Stack trace: $stackTrace');
        selectedCompany = null;
      }
    }

    return Column(
      children: [
        // Handle bar
        Container(
          width: TossSpacing.space10,
          height: TossSpacing.space1,
          margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),

        // Header - uses UserWithCompanies entity
        custom.DrawerHeader(userData: userData),

        // Companies Section
        Expanded(
          child: _buildCompaniesSection(context, ref, userData, selectedCompany),
        ),
      ],
    );
  }

  Widget _buildCompaniesSection(
    BuildContext context,
    WidgetRef ref,
    UserWithCompanies? userData,
    Company? selectedCompany,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.fromLTRB(TossSpacing.paddingXL, TossSpacing.paddingXL, TossSpacing.paddingXL, TossSpacing.space4),
          child: Row(
            children: [
              Container(
                width: TossSpacing.space1,
                height: TossSpacing.iconSM,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Text(
                'Companies & Stores',
                style: TossTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        // Companies with Stores Hierarchy
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            children: [
              // Existing Companies with their Stores
              ...() {
                final companies = (userData?['companies'] as List<dynamic>?) ?? [];

                // Remove duplicates (if any)
                final uniqueCompanies = <String, Company>{};
                for (final companyMap in companies) {
                  final company = Company.fromMap(companyMap as Map<String, dynamic>);
                  uniqueCompanies[company.id] = company;
                }

                final companiesList = uniqueCompanies.values.toList();

                // Sort to put selected company first
                companiesList.sort((a, b) {
                  if (a.id == selectedCompany?.id) return -1;
                  if (b.id == selectedCompany?.id) return 1;
                  return 0;
                });

                return companiesList.map((company) => _buildCompanyWithStores(
                  context,
                  ref,
                  company,
                  company.id == selectedCompany?.id,
                  selectedCompany,
                ));
              }(),

              const SizedBox(height: TossSpacing.space20),
            ],
          ),
        ),

        // Create Company Button at bottom
        Container(
          padding: EdgeInsets.only(
            left: TossSpacing.space4,
            right: TossSpacing.space4,
            top: TossSpacing.space4,
            bottom: TossSpacing.space4 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: TossPrimaryButton(
              text: 'Create Company',
              leadingIcon: const Icon(Icons.add, size: TossSpacing.iconSM),
              onPressed: () => _showCompanyActionsBottomSheet(context, ref),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyWithStores(
    BuildContext context,
    WidgetRef ref,
    Company company,
    bool isSelected,
    Company? selectedCompany,
  ) {
    // Get selected store from app state
    final appState = ref.read(appStateProvider);
    final selectedStoreId = appState.storeChoosen;

    // Find the selected store data from company stores
    Store? selectedStore;
    try {
      selectedStore = company.stores.firstWhere(
        (s) => s.id == selectedStoreId,
      );
    } catch (e) {
      selectedStore = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
            : Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.paddingMD),
            child: Row(
              children: [
                // Clickable company area
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      ref.read(appStateProvider.notifier).selectCompany(company.id);

                      if (company.stores.isNotEmpty) {
                        ref.read(appStateProvider.notifier).selectStore(company.stores[0].id);
                      }

                      if (context.mounted) {
                        Navigator.of(context).pop();
                        context.go('/');
                      }
                    },
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    child: Row(
                      children: [
                        // Company Icon
                        Container(
                          width: TossSpacing.iconXL,
                          height: TossSpacing.iconXL,
                          decoration: BoxDecoration(
                            color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: Icon(
                            Icons.business,
                            color: isSelected
                              ? TossColors.white
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                            size: TossSpacing.iconSM,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),

                        // Company Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company.companyName,
                                style: TossTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: TossSpacing.space1/2),
                              Row(
                                children: [
                                  Text(
                                    '${company.stores.length} stores',
                                    style: TossTextStyles.caption.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: TossSpacing.space2),
                                  Text(
                                    '•',
                                    style: TossTextStyles.caption.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: TossSpacing.space2),
                                  Text(
                                    company.role.roleName,
                                    style: TossTextStyles.caption.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expand/collapse button
                Material(
                  color: TossColors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _expandedCompanies[company.id] = !(_expandedCompanies[company.id] ?? isSelected);
                      });
                    },
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space2),
                      decoration: BoxDecoration(
                        color: (_expandedCompanies[company.id] ?? isSelected)
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : TossColors.transparent,
                        borderRadius: BorderRadius.circular(TossBorderRadius.full),
                      ),
                      child: Icon(
                        (_expandedCompanies[company.id] ?? isSelected) ? Icons.expand_less : Icons.expand_more,
                        color: (_expandedCompanies[company.id] ?? isSelected)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                        size: TossSpacing.iconMD,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stores Section
          if (_expandedCompanies[company.id] ?? isSelected) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(TossSpacing.space4, 0, TossSpacing.space4, TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Items
                  ...() {
                    final stores = company.stores;

                    // Remove duplicates (if any)
                    final uniqueStores = <String, Store>{};
                    for (final store in stores) {
                      uniqueStores[store.id] = store;
                    }

                    return uniqueStores.values.map((store) => _buildStoreItem(
                      context, ref, store, selectedStore?.id == store.id, company,
                    )).toList();
                  }(),

                  // Action buttons
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(top: TossSpacing.space2, left: TossSpacing.space3),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildViewCodesButtonCompact(context, ref, company),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: _buildAddStoreSlotCompact(context, ref, company),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStoreItem(BuildContext context, WidgetRef ref, Store store, bool isSelected, Company company) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2/2, left: TossSpacing.space3),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: () async {
            ref.read(appStateProvider.notifier).selectCompany(company.id);
            ref.read(appStateProvider.notifier).selectStore(store.id);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space3/2),
            decoration: BoxDecoration(
              color: isSelected
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.store_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: TossSpacing.iconSM,
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    store.storeName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                    size: TossSpacing.iconSM,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewCodesButtonCompact(BuildContext context, WidgetRef ref, Company company) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => _showCodesBottomSheet(context, company),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space3),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_2,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: TossSpacing.iconSM,
              ),
              const SizedBox(width: TossSpacing.space2),
              Flexible(
                child: Text(
                  'View codes',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddStoreSlotCompact(BuildContext context, WidgetRef ref, Company company) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => _showStoreActionsBottomSheet(context, ref, company),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space3),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
                size: TossSpacing.iconSM,
              ),
              const SizedBox(width: TossSpacing.space2),
              Flexible(
                child: Text(
                  'Create Store',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom Sheet Methods

  void _showCompanyActionsBottomSheet(BuildContext context, WidgetRef ref) {
    CompanyActionsSheet.show(
      context,
      onCreateCompany: () => _handleCreateCompany(context, ref),
      onJoinCompany: () => _handleJoinCompany(context, ref),
    );
  }

  void _showStoreActionsBottomSheet(BuildContext context, WidgetRef ref, Company company) {
    StoreActionsSheet.show(
      context,
      companyName: company.companyName,
      onCreateStore: () => _handleCreateStore(context, ref, company),
      onJoinStore: () => _handleJoinStore(context, ref),
    );
  }

  void _showCodesBottomSheet(BuildContext context, Company company) {
    final stores = company.stores
        .map((s) => {
              'store_name': s.storeName,
              'store_code': s.storeCode,
            })
        .toList();

    CodesDisplaySheet.show(
      context,
      companyName: company.companyName,
      companyCode: company.companyCode,
      stores: stores,
    );
  }

  // Action Handlers

  void _handleCreateCompany(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop(); // Close company actions sheet
    _showCreateCompanyBottomSheet(context, ref);
  }

  void _handleJoinCompany(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop(); // Close company actions sheet
    InputBottomSheet.show(
      context,
      title: 'Join Company',
      subtitle: 'Enter company invite code',
      inputLabel: 'Company Code',
      buttonText: 'Join Company',
      onSubmit: (code) async {
        await _joinCompany(context, ref, code);
      },
    );
  }

  void _handleCreateStore(BuildContext context, WidgetRef ref, Company company) {
    Navigator.of(context).pop(); // Close store actions sheet
    _showCreateStoreBottomSheet(context, ref, company);
  }

  void _handleJoinStore(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop(); // Close store actions sheet
    InputBottomSheet.show(
      context,
      title: 'Join Store',
      subtitle: 'Enter store invite code',
      inputLabel: 'Store Code',
      buttonText: 'Join Store',
      onSubmit: (code) async {
        await _joinStore(context, ref, code);
      },
    );
  }

  void _showCreateCompanyBottomSheet(BuildContext context, WidgetRef ref) {
    // Use existing create_company_sheet.dart which handles submission internally
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => const CreateCompanySheet(),
    );
  }

  void _showCreateStoreBottomSheet(BuildContext context, WidgetRef ref, Company company) {
    // Use existing create_store_sheet.dart which handles submission internally
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => CreateStoreSheet(
        companyId: company.id,
        companyName: company.companyName,
      ),
    );
  }

  // API Call Methods (delegate to helpers)

  Future<void> _createCompany(
    BuildContext context,
    WidgetRef ref,
    String name,
    String companyTypeId,
    String baseCurrencyId,
  ) async {
    // ✅ Capture context-dependent objects before async operations
    if (!context.mounted) return;

    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    SnackbarHelpers.showLoading(scaffoldMessenger, 'Creating company "$name"...');

    try {
      // Use domain use case
      final createCompany = ref.read(createCompanyUseCaseProvider);
      final result = await createCompany(CreateCompanyParams(
        companyName: name,
        companyTypeId: companyTypeId,
        baseCurrencyId: baseCurrencyId,
      ));

      // ✅ Check mounted after async operation
      if (!context.mounted) return;

      SnackbarHelpers.dismiss(scaffoldMessenger);

      result.fold(
        (failure) {
          SnackbarHelpers.showError(
            scaffoldMessenger,
            failure.message,
            onRetry: () {
              if (context.mounted) {
                _createCompany(context, ref, name, companyTypeId, baseCurrencyId);
              }
            },
          );
        },
        (company) async {
          final appStateNotifier = ref.read(appStateProvider.notifier);
          appStateNotifier.selectCompany(company.id);

          // ✅ Check mounted before navigation
          if (context.mounted && navigator.canPop()) navigator.pop();
          if (context.mounted && navigator.canPop()) navigator.pop();

          if (context.mounted) {
            await SnackbarHelpers.navigateToDashboard(context, ref);
          }

          SnackbarHelpers.showSuccess(
            scaffoldMessenger,
            'Company "${company.name}" created successfully!',
            actionLabel: 'Share Code',
            onAction: () {
              if (context.mounted) {
                SnackbarHelpers.copyToClipboard(context, company.code, 'Company code');
              }
            },
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;

      SnackbarHelpers.dismiss(scaffoldMessenger);
      SnackbarHelpers.showError(
        scaffoldMessenger,
        'Error: ${e.toString().replaceAll('Exception: ', '')}',
        onRetry: () {
          if (context.mounted) {
            _createCompany(context, ref, name, companyTypeId, baseCurrencyId);
          }
        },
      );
    }
  }

  Future<void> _joinCompany(BuildContext context, WidgetRef ref, String code) async {
    // ✅ Capture context-dependent objects before async operations
    if (!context.mounted) return;

    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    SnackbarHelpers.showLoading(scaffoldMessenger, 'Joining company...');

    try {
      final joinByCode = ref.read(joinByCodeUseCaseProvider);
      final user = ref.read(currentUserProvider);

      if (user == null) {
        SnackbarHelpers.dismiss(scaffoldMessenger);
        SnackbarHelpers.showError(scaffoldMessenger, 'Please log in first');
        return;
      }

      final result = await joinByCode(JoinByCodeParams(
        userId: user.id,
        code: code,
      ));

      // ✅ Check mounted after async operation
      if (!context.mounted) return;

      result.fold(
        (failure) async {
          SnackbarHelpers.dismiss(scaffoldMessenger);
          if (context.mounted) {
            await TossErrorDialogs.showBusinessJoinFailed(
              context: context,
              error: failure.message,
              onRetry: () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  _joinCompany(context, ref, code);
                }
              },
            );
          }
        },
        (joinResult) async {
          if (context.mounted && navigator.canPop()) navigator.pop();
          if (context.mounted && navigator.canPop()) navigator.pop();

          SnackbarHelpers.dismiss(scaffoldMessenger);

          if (joinResult.companyId != null) {
            final appStateNotifier = ref.read(appStateProvider.notifier);
            appStateNotifier.selectCompany(joinResult.companyId!);

            if (joinResult.storeId != null) {
              appStateNotifier.selectStore(joinResult.storeId!);
            }
          }

          if (context.mounted) {
            await TossSuccessDialogs.showBusinessJoined(
              context: context,
              companyName: joinResult.entityName,
              roleName: joinResult.roleAssigned ?? 'Member',
              onContinue: () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  context.go('/');
                }
              },
            );
          }
        },
      );
    } catch (e) {
      if (!context.mounted) return;

      SnackbarHelpers.dismiss(scaffoldMessenger);
      await TossErrorDialogs.showBusinessJoinFailed(
        context: context,
        error: e.toString().replaceAll('Exception: ', ''),
        onRetry: () {
          if (context.mounted) {
            Navigator.of(context).pop();
            _joinCompany(context, ref, code);
          }
        },
      );
    }
  }

  Future<void> _createStore(
    BuildContext context,
    WidgetRef ref,
    String name,
    dynamic company,
    String? address,
    String? phone,
  ) async {
    // ✅ Capture context-dependent objects before async operations
    if (!context.mounted) return;

    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    SnackbarHelpers.showLoading(scaffoldMessenger, 'Creating store "$name"...');

    try {
      final createStore = ref.read(createStoreUseCaseProvider);
      final result = await createStore(CreateStoreParams(
        storeName: name,
        companyId: company['company_id'] as String,
        storeAddress: address,
        storePhone: phone,
      ));

      // ✅ Check mounted after async operation
      if (!context.mounted) return;

      SnackbarHelpers.dismiss(scaffoldMessenger);

      result.fold(
        (failure) {
          SnackbarHelpers.showError(
            scaffoldMessenger,
            failure.message,
            onRetry: () {
              if (context.mounted) {
                _createStore(context, ref, name, company, address, phone);
              }
            },
          );
        },
        (store) async {
          final appStateNotifier = ref.read(appStateProvider.notifier);
          appStateNotifier.selectCompany(store.companyId);
          appStateNotifier.selectStore(store.id);

          // ✅ Check mounted before navigation
          if (context.mounted && navigator.canPop()) navigator.pop();
          if (context.mounted && navigator.canPop()) navigator.pop();

          if (context.mounted) {
            await SnackbarHelpers.navigateToDashboard(context, ref);
          }

          SnackbarHelpers.showSuccess(
            scaffoldMessenger,
            'Store "${store.name}" created successfully!',
            actionLabel: 'Share Code',
            onAction: () {
              if (context.mounted) {
                SnackbarHelpers.copyToClipboard(context, store.code, 'Store code');
              }
            },
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;

      SnackbarHelpers.dismiss(scaffoldMessenger);
      SnackbarHelpers.showError(
        scaffoldMessenger,
        'Error: ${e.toString().replaceAll('Exception: ', '')}',
        onRetry: () {
          if (context.mounted) {
            _createStore(context, ref, name, company, address, phone);
          }
        },
      );
    }
  }

  Future<void> _joinStore(BuildContext context, WidgetRef ref, String code) async {
    // ✅ Capture context-dependent objects before async operations
    if (!context.mounted) return;

    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    SnackbarHelpers.showLoading(scaffoldMessenger, 'Joining store...');

    try {
      final joinByCode = ref.read(joinByCodeUseCaseProvider);
      final user = ref.read(currentUserProvider);

      if (user == null) {
        SnackbarHelpers.dismiss(scaffoldMessenger);
        SnackbarHelpers.showError(scaffoldMessenger, 'Please log in first');
        return;
      }

      final result = await joinByCode(JoinByCodeParams(
        userId: user.id,
        code: code,
      ));

      // ✅ Check mounted after async operation
      if (!context.mounted) return;

      result.fold(
        (failure) async {
          SnackbarHelpers.dismiss(scaffoldMessenger);
          if (context.mounted) {
            await TossErrorDialogs.showBusinessJoinFailed(
              context: context,
              error: failure.message,
              onRetry: () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  _joinStore(context, ref, code);
                }
              },
            );
          }
        },
        (joinResult) async {
          if (context.mounted && navigator.canPop()) navigator.pop();
          if (context.mounted && navigator.canPop()) navigator.pop();

          SnackbarHelpers.dismiss(scaffoldMessenger);

          await Future<void>.delayed(const Duration(milliseconds: 300));

          // Force comprehensive data refresh
          ref.invalidate(userCompaniesProvider);
          ref.invalidate(categoriesWithFeaturesProvider);

          if (joinResult.companyId != null) {
            final appStateNotifier = ref.read(appStateProvider.notifier);
            appStateNotifier.selectCompany(joinResult.companyId!);

            if (joinResult.storeId != null) {
              appStateNotifier.selectStore(joinResult.storeId!);
            }
          }

          if (context.mounted) {
            await TossSuccessDialogs.showBusinessJoined(
              context: context,
              companyName: joinResult.entityName,
              roleName: joinResult.roleAssigned ?? 'Member',
              onContinue: () {
                if (context.mounted) {
                  Navigator.of(context).pop(true);
                  context.go('/');
                }
              },
            );
          }
        },
      );
    } catch (e) {
      if (!context.mounted) return;

      SnackbarHelpers.dismiss(scaffoldMessenger);
      await TossErrorDialogs.showBusinessJoinFailed(
        context: context,
        error: e.toString().replaceAll('Exception: ', ''),
        onRetry: () {
          if (context.mounted) {
            Navigator.of(context).pop();
            _joinStore(context, ref, code);
          }
        },
      );
    }
  }
}
