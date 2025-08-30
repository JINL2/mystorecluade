// =====================================================
// SMART ACCOUNT SELECTOR
// Shows quick access accounts + traditional selector
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_design_system.dart';
import '../../../providers/quick_access_provider.dart';
import '../../../providers/app_state_provider.dart';
import '../../../../data/services/supabase_service.dart';
import 'autonomous_account_selector.dart';

/// Smart Account Selector with Quick Access + Traditional Selector
class SmartAccountSelector extends ConsumerStatefulWidget {
  final String? selectedAccountId;
  final Function(String?)? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? contextType;
  final String? accountType;
  final bool showQuickAccess;
  final int maxQuickItems;

  const SmartAccountSelector({
    super.key,
    this.selectedAccountId,
    this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.contextType,
    this.accountType,
    this.showQuickAccess = true,
    this.maxQuickItems = 6,
  });

  @override
  ConsumerState<SmartAccountSelector> createState() => _SmartAccountSelectorState();
}

class _SmartAccountSelectorState extends ConsumerState<SmartAccountSelector> {
  bool _showQuickAccess = true;

  @override
  Widget build(BuildContext context) {
    if (!widget.showQuickAccess || !_showQuickAccess) {
      // Just show traditional selector
      return _buildTraditionalSelector();
    }

    // Watch quick access accounts
    final quickAccessAsync = ref.watch(quickAccessAccountsProvider(
      contextType: widget.contextType,
      limit: widget.maxQuickItems,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Access Section
        quickAccessAsync.when(
          data: (quickAccounts) {
            if (quickAccounts.isEmpty) {
              return const SizedBox.shrink();
            }
            return _buildQuickAccessSection(quickAccounts);
          },
          loading: () => _buildQuickAccessSkeleton(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        
        const SizedBox(height: TossSpacing.space4),
        
        // Traditional Selector
        _buildTraditionalSelector(),
      ],
    );
  }

  Widget _buildQuickAccessSection(List<Map<String, dynamic>> quickAccounts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick Select',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _showQuickAccess = false),
              child: Text(
                'Show all',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: TossSpacing.space2),
        
        // Quick Access Grid
        _buildQuickAccessGrid(quickAccounts),
      ],
    );
  }

  Widget _buildQuickAccessGrid(List<Map<String, dynamic>> accounts) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.2,
        crossAxisSpacing: TossSpacing.space2,
        mainAxisSpacing: TossSpacing.space2,
      ),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        return _buildQuickAccessCard(account);
      },
    );
  }

  Widget _buildQuickAccessCard(Map<String, dynamic> account) {
    final isSelected = account['account_id'] == widget.selectedAccountId;
    final accountName = account['account_name'] ?? 'Unknown Account';
    final usageCount = account['usage_count'] ?? 0;
    final estimatedTime = account['estimated_time'] ?? '📋 First time';
    final categoryTag = account['category_tag'] ?? '';

    return TossDesignSystem.buildCard(
      onTap: () {
        _onQuickAccountSelect(account['account_id']);
      },
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected 
            ? TossColors.primarySurface 
            : TossColors.surface,
          border: Border.all(
            color: isSelected 
              ? TossColors.primary 
              : TossColors.border,
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Account name with usage indicator
          Row(
            children: [
              Expanded(
                child: Text(
                  accountName,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (usageCount > 5)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: TossColors.success,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: const Text(
                    '⚡',
                    style: TossTextStyles.mini,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          // Usage stats
          Row(
            children: [
              Icon(
                _getAccountIcon(categoryTag),
                size: 12,
                color: TossColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  estimatedTime,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textSecondary,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (usageCount > 0)
                Text(
                  '${usageCount}×',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSkeleton() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.2,
        crossAxisSpacing: TossSpacing.space2,
        mainAxisSpacing: TossSpacing.space2,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
        );
      },
    );
  }

  Widget _buildTraditionalSelector() {
    return AutonomousAccountSelector(
      selectedAccountId: widget.selectedAccountId,
      onChanged: widget.onChanged,
      label: widget.label,
      hint: widget.hint ?? 'Select account or choose from frequent ones above',
      errorText: widget.errorText,
      accountType: widget.accountType,
      contextType: widget.contextType,
    );
  }

  void _onQuickAccountSelect(String? accountId) {
    if (accountId != null) {
      // Track quick access usage
      _trackQuickAccessUsage(accountId);
      widget.onChanged?.call(accountId);
    }
  }

  void _trackQuickAccessUsage(String accountId) async {
    if (widget.contextType == null) return;
    
    try {
      final supabase = ref.read(supabaseServiceProvider);
      final appState = ref.read(appStateProvider);
      
      if (appState.companyChoosen.isEmpty) return;

      // Track that this was selected via quick access - using correct RPC parameters
      await supabase.client.rpc('log_account_usage', params: {
        'p_account_id': accountId,
        'p_account_name': 'Quick Access Account',
        'p_company_id': appState.companyChoosen,
        'p_usage_type': 'selected',
        'p_metadata': {
          'context': widget.contextType!,
          'selection_source': 'quick_access',
        },
      });
    } catch (e) {
      // Silent fail
    }
  }

  IconData _getAccountIcon(String? categoryTag) {
    switch (categoryTag?.toLowerCase()) {
      case 'cash':
        return Icons.account_balance_wallet;
      case 'payable':
        return Icons.payment;
      case 'receivable':
        return Icons.payments;
      case 'asset':
        return Icons.business_center;
      case 'liability':
        return Icons.credit_card;
      case 'income':
        return Icons.trending_up;
      case 'expense':
        return Icons.trending_down;
      default:
        return Icons.account_circle;
    }
  }
}