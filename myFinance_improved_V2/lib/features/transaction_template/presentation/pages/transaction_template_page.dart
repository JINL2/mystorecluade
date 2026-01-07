import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/template_entity.dart';
import '../../domain/enums/template_constants.dart';
import '../../domain/usecases/delete_template_usecase.dart';
import '../modals/add_template_bottom_sheet.dart';
import '../modals/template_filter_sheet.dart';
import '../modals/template_usage_bottom_sheet.dart';
import '../providers/states/template_state.dart';
import '../providers/template_provider.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class TransactionTemplatePage extends ConsumerStatefulWidget {
  const TransactionTemplatePage({super.key});

  @override
  ConsumerState<TransactionTemplatePage> createState() {
    return _TransactionTemplatePageState();
  }
}

class _TransactionTemplatePageState extends ConsumerState<TransactionTemplatePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool? _lastHasAdminPermission;
  bool _isFilterSheetOpen = false;

  @override
  void initState() {
    super.initState();

    // Load templates after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTemplates();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _loadTemplates() {
    final appState = ref.read(appStateProvider);

    // Get companyId and storeId from appState
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    if (companyId.isNotEmpty) {
      // Load templates using templateProvider
      ref.read(templateNotifierProvider.notifier).loadTemplates(
        companyId: companyId,
        storeId: storeId,
        includeInactive: false,
      );
    }
  }

  bool _hasAdminPermission(WidgetRef ref) {
    // Use canDeleteTemplatesProvider which checks user role
    // Owner and Manager roles have admin permission
    final hasPermission = ref.watch(canDeleteTemplatesProvider);
    return hasPermission;
  }

  void _updateTabController(bool hasAdminPermission) {
    if (_lastHasAdminPermission != hasAdminPermission) {
      _tabController?.dispose();
      _tabController = TabController(
        length: hasAdminPermission ? 2 : 1,
        vsync: this,
      );
      _lastHasAdminPermission = hasAdminPermission;
    }
  }

  @override
  Widget build(BuildContext context) {
    final templateState = ref.watch(templateNotifierProvider);
    final filteredTemplates = ref.watch(filteredTemplatesProvider);
    final companyChoosen = ref.watch(appStateProvider).companyChoosen;
    final storeChoosen = ref.watch(appStateProvider).storeChoosen;

    // 🔄 REACTIVE-LOAD: Reload templates when company/store changes
    ref.listen(
      appStateProvider.select((s) => '${s.companyChoosen}_${s.storeChoosen}'),
      (prev, next) {
        if (companyChoosen.isNotEmpty && storeChoosen.isNotEmpty) {
          ref.read(templateNotifierProvider.notifier).loadTemplates(
            companyId: companyChoosen,
            storeId: storeChoosen,
          );
        }
      },
    );

    // Check if user has admin permission
    final hasAdminPermission = _hasAdminPermission(ref);

    // Initialize or update tab controller
    if (_tabController == null) {
      _tabController = TabController(
        length: hasAdminPermission ? 2 : 1,
        vsync: this,
      );
      _lastHasAdminPermission = hasAdminPermission;
    } else {
      _updateTabController(hasAdminPermission);
    }

    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: TossAppBar(
        title: 'Transaction Templates',
        backgroundColor: TossColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          _buildFilterButton(),
        ],
      ),
      body: _buildBody(templateState, filteredTemplates, hasAdminPermission),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AddTemplateBottomSheet.show(context);
        },
        backgroundColor: TossColors.primary,
        icon: const Icon(Icons.add, color: TossColors.white),
        label: Text(
          'New Template',
          style: TossTextStyles.body.copyWith(
            color: TossColors.white,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(TemplateState state, List<TransactionTemplate> filteredTemplates, bool hasAdminPermission) {
    // Loading state
    if (state.isLoading) {
      return const TossLoadingView();
    }

    // Error state
    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: TossSpacing.icon4XL,
                color: TossColors.error,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Error Loading Templates',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: TossFontWeight.bold,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                state.errorMessage!,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TossSpacing.space4),
              TossButton.primary(
                text: 'Retry',
                onPressed: _loadTemplates,
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (state.templates.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: TossSpacing.icon4XL + TossSpacing.iconSM2, // 80 = 64 + 16
                color: TossColors.gray400,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'No Templates Yet',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: TossFontWeight.bold,
                  color: TossColors.gray700,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Create your first transaction template\nto save time on recurring transactions',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Use filtered templates and separate by permission
    final generalTemplates = filteredTemplates.where((template) {
      return template.permission != TemplateConstants.adminPermissionUUID;
    }).toList();

    final adminTemplates = filteredTemplates.where((template) {
      return template.permission == TemplateConstants.adminPermissionUUID;
    }).toList();

    return Column(
      children: [
        // Tab Bar - show Admin tab only if user has permission
        if (_tabController != null)
          TossTabBar(
            tabs: hasAdminPermission ? const ['General', 'Admin'] : const ['General'],
            controller: _tabController,
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          ),
        // Tab Bar View
        Expanded(
          child: _tabController != null
              ? TabBarView(
                  controller: _tabController,
                  children: hasAdminPermission
                      ? [
                          // General Tab
                          _buildTemplateList(generalTemplates),
                          // Admin Tab
                          _buildTemplateList(adminTemplates),
                        ]
                      : [
                          // Only General Tab
                          _buildTemplateList(generalTemplates),
                        ],
                )
              : _buildTemplateList(generalTemplates),
        ),
      ],
    );
  }

  // Build template list widget
  Widget _buildTemplateList(List<TransactionTemplate> templates) {
    if (templates.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: TossSpacing.icon4XL,
                color: TossColors.gray400,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'No Templates Found',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: TossFontWeight.bold,
                  color: TossColors.gray700,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Create your first transaction template to get started',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(TossSpacing.space4),
      itemCount: templates.length,
      separatorBuilder: (context, index) => const SizedBox(height: TossSpacing.space3),
      itemBuilder: (context, index) {
        final template = templates[index];
        return _TemplateCard(template: template);
      },
    );
  }

  void _showFilterSheet() {
    if (_isFilterSheetOpen) return;
    _isFilterSheetOpen = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => const TemplateFilterSheet(),
    ).whenComplete(() {
      _isFilterSheetOpen = false;
    });
  }

  Widget _buildFilterButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(
            Icons.filter_list,
            color: TossColors.gray600,
            size: TossSpacing.iconMD2,
          ),
          onPressed: _showFilterSheet,
        ),
      ],
    );
  }
}

class _TemplateCard extends ConsumerWidget {
  final TransactionTemplate template;

  const _TemplateCard({required this.template});

  Map<String, dynamic> _templateToMap() {
    return {
      'template_id': template.templateId,
      'name': template.name,
      'template_description': template.templateDescription,
      'data': template.data,
      'tags': template.tags,
      'visibility_level': template.visibilityLevel,
      'permission': template.permission,
      'company_id': template.companyId,
      'store_id': template.storeId,
      'counterparty_id': template.counterpartyId,
      'counterparty_cash_location_id': template.counterpartyCashLocationId,
      'created_by': template.createdBy,
      'created_at': template.createdAt.toIso8601String(),
      'updated_at': template.updatedAt.toIso8601String(),
      'updated_by': template.updatedBy,
      'is_active': template.isActive,
      'required_attachment': template.requiredAttachment, // 🔧 FIXED: Add required_attachment field
    };
  }

  String _buildTransactionFlow() {
    if (template.data.isEmpty) return 'Empty template';

    final accounts = <String>[];
    for (var entry in template.data) {
      final accountName = entry['account_name'] as String? ?? 'Unknown';
      final categoryTag = entry['category_tag'] as String? ?? '';

      // Create display name with emoji indicators
      String displayName = accountName;
      if (categoryTag == 'cash') {
        displayName = '💰 $accountName';
      } else if (categoryTag == 'payable' || categoryTag == 'receivable') {
        displayName = '👤 $accountName';
      }

      if (!accounts.contains(displayName)) {
        accounts.add(displayName);
      }
    }

    return accounts.join(' → ');
  }

  List<Widget> _buildTemplateDetails() {
    final details = <Widget>[];

    // Extract cash location info
    String? cashLocationName;
    String? counterpartyName;
    String? counterpartyCashLocationName;

    for (var entry in template.data) {
      final categoryTag = entry['category_tag'] as String? ?? '';

      if (categoryTag == 'cash') {
        cashLocationName ??= entry['cash_location_name'] as String?;
      }

      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        counterpartyName ??= entry['counterparty_name'] as String?;
      }

      final entryCounterpartyCashLoc = entry['counterparty_cash_location_name'] as String?;
      if (entryCounterpartyCashLoc != null && entryCounterpartyCashLoc != 'none') {
        counterpartyCashLocationName = entryCounterpartyCashLoc;
      }
    }

    // Check template-level data
    counterpartyName ??= template.counterpartyId != null ? 'Counterparty' : null;

    // My cash location
    if (cashLocationName != null) {
      details.add(
        Row(
          children: [
            Icon(Icons.account_balance_wallet, size: TossSpacing.iconXS, color: TossColors.primary),
            const SizedBox(width: TossSpacing.space1),
            Text(
              'My Cash: ',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: TossFontWeight.medium,
              ),
            ),
            Flexible(
              child: Text(
                cashLocationName,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: TossFontWeight.semibold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // Counterparty
    if (counterpartyName != null && counterpartyName != 'none') {
      details.add(
        Row(
          children: [
            Icon(Icons.person, size: TossSpacing.iconXS, color: TossColors.warning),
            const SizedBox(width: TossSpacing.space1),
            Text(
              'Party: ',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: TossFontWeight.medium,
              ),
            ),
            Flexible(
              child: Text(
                counterpartyName,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: TossFontWeight.semibold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // Their cash location
    if (counterpartyCashLocationName != null && counterpartyCashLocationName != 'none') {
      details.add(
        Row(
          children: [
            Icon(Icons.store, size: TossSpacing.iconXS, color: TossColors.warning),
            const SizedBox(width: TossSpacing.space1),
            Text(
              'Their Cash: ',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: TossFontWeight.medium,
              ),
            ),
            Flexible(
              child: Text(
                counterpartyCashLocationName,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: TossFontWeight.semibold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return details;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionFlow = _buildTransactionFlow();
    final details = _buildTemplateDetails();
    final isAdminTemplate = template.permission == TemplateConstants.adminPermissionUUID;
    final canDelete = ref.watch(canDeleteTemplatesProvider);
    // Check edit permission - admin can edit any, creator can edit own
    final canEdit = ref.watch(canEditTemplateProvider(template.createdBy));

    return TossWhiteCard(
      child: Material(
        color: TossColors.transparent,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: InkWell(
          onTap: () {
            // Open template usage modal with edit permission
            TemplateUsageBottomSheet.show(
              context,
              _templateToMap(),
              canEdit: canEdit,
            );
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Icon
                    Container(
                      width: TossSpacing.iconXL,
                      height: TossSpacing.iconXL,
                      decoration: BoxDecoration(
                        color: TossColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Icon(
                        Icons.receipt_long,
                        color: TossColors.primary,
                        size: TossSpacing.iconMD,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),

                    // Title and transaction flow
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  template.name,
                                  style: TossTextStyles.bodyLarge.copyWith(
                                    fontWeight: TossFontWeight.semibold,
                                    color: TossColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isAdminTemplate) ...[
                                const SizedBox(width: TossSpacing.space1),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: TossSpacing.space2,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: TossColors.border,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                  ),
                                  child: Text(
                                    'ADMIN',
                                    style: TossTextStyles.small.copyWith(
                                      color: TossColors.textSecondary,
                                      fontWeight: TossFontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: TossSpacing.space1 / 2),
                          Text(
                            transactionFlow,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.textSecondary,
                              fontWeight: TossFontWeight.medium,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Delete button (if user has permission)
                    if (canDelete)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: TossColors.error,
                          size: TossSpacing.iconMD,
                        ),
                        onPressed: () async {
                          // Show confirmation dialog
                          final confirmed = await TossConfirmCancelDialog.showDelete(
                            context: context,
                            title: 'Delete Template',
                            message: 'Are you sure you want to delete "${template.name}"?\nThis action cannot be undone.',
                          );

                          if (confirmed == true) {
                            // Get current user ID
                            final userId = ref.read(appStateProvider).user['user_id'] as String? ?? '';

                            // Create delete command
                            final command = DeleteTemplateCommand(
                              templateId: template.templateId,
                              deletedBy: userId,
                            );

                            // Call delete template
                            await ref.read(templateNotifierProvider.notifier).deleteTemplate(command);
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                    const SizedBox(width: TossSpacing.space2),

                    // Arrow
                    Icon(
                      Icons.chevron_right,
                      color: TossColors.textTertiary,
                      size: TossSpacing.iconMD,
                    ),
                  ],
                ),

                // Template details
                if (details.isNotEmpty) ...[
                  const SizedBox(height: TossSpacing.space2),
                  ...details.map((detail) => Padding(
                    padding: const EdgeInsets.only(top: TossSpacing.space1),
                    child: detail,
                  ),),
                ],

                // Template description (if exists)
                if (template.templateDescription != null &&
                    template.templateDescription!.isNotEmpty) ...[
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    template.templateDescription!,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
