import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/account_mapping.dart';
import '../providers/account_mapping_providers.dart';
import '../widgets/debt_account/account_mapping_form_sheet.dart';
import '../widgets/debt_account/account_mapping_list_item.dart';
import '../widgets/debt_account/debt_settings_header.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Debt Account Settings Page
///
/// Manages account mappings between internal companies for automatic debt synchronization.
class DebtAccountSettingsPage extends ConsumerStatefulWidget {
  final String counterpartyId;
  final String counterpartyName;

  const DebtAccountSettingsPage({
    super.key,
    required this.counterpartyId,
    required this.counterpartyName,
  });

  @override
  ConsumerState<DebtAccountSettingsPage> createState() =>
      _DebtAccountSettingsPageState();
}

class _DebtAccountSettingsPageState
    extends ConsumerState<DebtAccountSettingsPage>
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
      CurvedAnimation(
        parent: _animationController,
        curve: TossAnimations.standard,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _refreshMappings() async {
    ref.invalidate(accountMappingsProvider(widget.counterpartyId));
  }

  void _showMappingFormModal(AccountMapping? mapping) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.overlay,
      enableDrag: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: AccountMappingFormSheet(
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
    try {
      await ref.read(
        deleteAccountMappingProvider(DeleteAccountMappingParams(
          mappingId: mapping.mappingId,
          counterpartyId: widget.counterpartyId,
        )).future,
      );

      if (mounted) {
        TossToast.success(context, 'Account mapping deleted');
      }
    } catch (e) {
      if (mounted) {
        TossToast.error(context, 'Failed to delete: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mappingsAsync =
        ref.watch(accountMappingsProvider(widget.counterpartyId));

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Account Settings',
        backgroundColor: TossColors.gray100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TossColors.textPrimary),
          onPressed: () => context.pop(),
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
              child: DebtSettingsHeader(
                counterpartyName: widget.counterpartyName,
              ),
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

  Widget _buildMappingsList(AsyncValue<List<AccountMapping>> mappingsAsync) {
    return mappingsAsync.when(
      data: (mappings) {
        if (mappings.isEmpty) {
          return _buildEmptyState();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: TossSpacing.space1,
                  bottom: TossSpacing.space3,
                ),
                child: Text(
                  'Account Mappings',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ...mappings.map((mapping) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: TossSpacing.space3),
                  child: AccountMappingListItem(
                    mapping: mapping,
                    onEdit: () => _showEditMappingForm(mapping),
                    onDelete: () => _deleteMapping(mapping),
                  ),
                );
              }),
              const SizedBox(height: TossSpacing.space6),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 300,
        alignment: Alignment.center,
        child: const TossLoadingView(),
      ),
      error: (error, stack) => Container(
        height: 300,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: TossColors.error,
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Failed to load mappings',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              error.toString(),
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space3),
            TossButton.textButton(
              text: 'Retry',
              onPressed: _refreshMappings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 350,
      margin: const EdgeInsets.all(TossSpacing.space4),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: TossColors.gray100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_link,
                color: TossColors.gray400,
                size: 40,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No mappings yet',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Add your first account mapping to enable\nautomatic debt synchronization',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
