import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/themes/toss_animations.dart';
import 'package:myfinance_improved/core/constants/ui_constants.dart';
import 'models/account_mapping_models.dart';
import 'providers/account_mapping_providers.dart';
import 'widgets/account_mapping_form.dart';
import 'widgets/account_mapping_list_item.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../../core/navigation/safe_navigation.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class DebtAccountSettingsPage extends ConsumerStatefulWidget {
  final String counterpartyId;
  final String counterpartyName;

  const DebtAccountSettingsPage({
    super.key,
    required this.counterpartyId,
    required this.counterpartyName,
  });

  @override
  ConsumerState<DebtAccountSettingsPage> createState() => _DebtAccountSettingsPageState();
}

class _DebtAccountSettingsPageState extends ConsumerState<DebtAccountSettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: TossAnimations.standard),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _refreshMappings() async {
    // Refresh the account mappings provider
    ref.invalidate(accountMappingsProvider(widget.counterpartyId));
  }

  // Common helper method to show modal bottom sheet forms
  void _showMappingFormModal(AccountMapping? mapping) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.overlay,
      enableDrag: true, // Allow swipe-to-dismiss
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: AccountMappingForm(
          counterpartyId: widget.counterpartyId,
          counterpartyName: widget.counterpartyName,
          accountMapping: mapping,
        ),
      ),
    );
  }

  void _showCreateMappingForm() {
    _showMappingFormModal(null);
  }

  void _showEditMappingForm(AccountMapping mapping) {
    _showMappingFormModal(mapping);
  }

  Future<void> _deleteMapping(AccountMapping mapping) async {
    // Immediately remove from UI
    ref.read(accountMappingsProvider(widget.counterpartyId).notifier).removeMapping(mapping.mappingId);
    
    try {
      // Delete from database
      final params = DeleteMappingParams(
        mappingId: mapping.mappingId,
        counterpartyId: widget.counterpartyId,
      );
      
      await ref.read(deleteAccountMappingProvider(params).future);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account mapping deleted'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            duration: TossAnimations.normal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
          ),
        );
      }
    } catch (e) {
      // If deletion failed, refresh to restore the item
      await ref.read(accountMappingsProvider(widget.counterpartyId).notifier).refresh();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete mapping'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            duration: TossAnimations.normal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mappingsAsync = ref.watch(accountMappingsProvider(widget.counterpartyId));

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Debt Account Settings',
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TossColors.textPrimary),
          onPressed: () => context.safePop(),
        ),
        primaryActionText: 'Add',
        primaryActionIcon: Icons.add,
        onPrimaryAction: _showCreateMappingForm,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMappings,
        color: TossColors.primary,
        child: CustomScrollView(
          slivers: [
            // Header Information
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            
            // Account Mappings List
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildMappingsList(mappingsAsync),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.shadow,
            blurRadius: UIConstants.cardShadowBlur * 5,
            offset: Offset(0, UIConstants.cardShadowOffset * 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              Container(
                width: UIConstants.profileAvatarSize,
                height: UIConstants.profileAvatarSize,
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Icon(
                  Icons.account_balance,
                  color: TossColors.primary,
                  size: UIConstants.iconSizeSmall,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.counterpartyName,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Internal Company Account Mappings',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Flow visualization
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'You record',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        'Receivable',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                  child: Icon(
                    Icons.sync_alt,
                    color: TossColors.gray300,
                    size: UIConstants.iconSizeSmall,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'They record',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        'Payable',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Benefits with notice
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: TossColors.success,
                    size: UIConstants.iconSizeXS,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Automatic synchronization for accurate records',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: TossSpacing.space2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: TossColors.info,
                    size: UIConstants.iconSizeXS,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Once mapped, record transactions in one company only. The other company\'s entry is created automatically.',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMappingsList(AsyncValue<List<AccountMapping>> mappingsAsync) {
    return mappingsAsync.when(
      data: (mappings) {
        if (mappings.isEmpty) {
          return Container(
            height: UIConstants.helloSectionHeight * 2.35,
            margin: EdgeInsets.all(TossSpacing.space4),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: UIConstants.emptyStateIconSize,
                    height: UIConstants.emptyStateIconSize,
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_link,
                      color: TossColors.gray400,
                      size: UIConstants.iconSizeLarge,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space3),
                  Text(
                    'No mappings yet',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    'Add your first account mapping',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: TossSpacing.space4,
                  bottom: TossSpacing.space2,
                ),
                child: Text(
                  'Mappings',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ...mappings.map((mapping) => Padding(
                padding: EdgeInsets.only(bottom: TossSpacing.space2),
                child: AccountMappingListItem(
                  mapping: mapping,
                  onEdit: () => _showEditMappingForm(mapping),
                  onDelete: () => _deleteMapping(mapping),
                ),
              )),
              SizedBox(height: TossSpacing.space6),
            ],
          ),
        );
      },
      loading: () => Container(
        margin: EdgeInsets.all(TossSpacing.space4),
        child: Center(
          child: TossLoadingView(),
        ),
      ),
      error: (error, _) => Container(
        margin: EdgeInsets.all(TossSpacing.space4),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: UIConstants.emptyStateIconSize,
                color: TossColors.error,
              ),
              SizedBox(height: TossSpacing.space3),
              Text(
                'Failed to load account mappings',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.error,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              TextButton(
                onPressed: _refreshMappings,
                child: Text(
                  'Retry',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}