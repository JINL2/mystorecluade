import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_tab_bar_1.dart';

import '../../domain/entities/template_entity.dart';
import '../../domain/enums/template_constants.dart';
import '../../domain/usecases/delete_template_usecase.dart';
import '../modals/add_template_bottom_sheet.dart';
import '../modals/template_filter_sheet.dart';
import '../modals/template_usage_bottom_sheet.dart';
import '../providers/states/template_state.dart';
import '../providers/template_provider.dart';

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
      ref.read(templateProvider.notifier).loadTemplates(
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
    final templateState = ref.watch(templateProvider);
    final filteredTemplates = ref.watch(filteredTemplatesProvider);
    final companyChoosen = ref.watch(appStateProvider).companyChoosen;
    final storeChoosen = ref.watch(appStateProvider).storeChoosen;

    // 🔄 REACTIVE-LOAD: Reload templates when company/store changes
    ref.listen(
      appStateProvider.select((s) => '${s.companyChoosen}_${s.storeChoosen}'),
      (prev, next) {
        if (companyChoosen.isNotEmpty && storeChoosen.isNotEmpty) {
          ref.read(templateProvider.notifier).loadTemplates(
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
      backgroundColor: TossColors.gray50,
      appBar: TossAppBar1(
        title: 'Transaction Templates',
        backgroundColor: TossColors.gray50,
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
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'New Template',
          style: TossTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(TemplateState state, List<TransactionTemplate> filteredTemplates, bool hasAdminPermission) {
    // Loading state
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error state
    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: TossColors.error,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Error Loading Templates',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
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
              ElevatedButton(
                onPressed: _loadTemplates,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
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
              const Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: TossColors.gray400,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'No Templates Yet',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
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
          TossTabBar1(
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
              const Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: TossColors.gray400,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'No Templates Found',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
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

  Widget _buildFilterButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(
            Icons.filter_list,
            color: TossColors.gray600,
            size: 24,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: TossColors.transparent,
              builder: (context) => const TemplateFilterSheet(),
            );
          },
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
            const Icon(Icons.account_balance_wallet, size: 14, color: TossColors.primary),
            const SizedBox(width: TossSpacing.space1),
            Text(
              'My Cash: ',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
            Flexible(
              child: Text(
                cashLocationName,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
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
            const Icon(Icons.person, size: 14, color: TossColors.warning),
            const SizedBox(width: TossSpacing.space1),
            Text(
              'Party: ',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
            Flexible(
              child: Text(
                counterpartyName,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
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
            const Icon(Icons.store, size: 14, color: TossColors.warning),
            const SizedBox(width: TossSpacing.space1),
            Text(
              'Their Cash: ',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
            Flexible(
              child: Text(
                counterpartyCashLocationName,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
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

    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.borderLight,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.textPrimary.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: TossColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: TossColors.primary,
                        size: 20,
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
                                    fontWeight: FontWeight.w600,
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
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            transactionFlow,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.textSecondary,
                              fontWeight: FontWeight.w500,
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
                        icon: const Icon(
                          Icons.delete_outline,
                          color: TossColors.error,
                          size: 20,
                        ),
                        onPressed: () async {
                          // Get current user ID
                          final userId = ref.read(appStateProvider).user['user_id'] as String? ?? '';

                          // Create delete command
                          final command = DeleteTemplateCommand(
                            templateId: template.templateId,
                            deletedBy: userId,
                          );

                          // Call delete template
                          await ref.read(templateProvider.notifier).deleteTemplate(command);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                    const SizedBox(width: TossSpacing.space2),

                    // Arrow
                    const Icon(
                      Icons.chevron_right,
                      color: TossColors.textTertiary,
                      size: 20,
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
