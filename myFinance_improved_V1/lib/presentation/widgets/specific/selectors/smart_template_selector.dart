// =====================================================
// SMART TEMPLATE SELECTOR
// Shows quick access templates + traditional template list
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
import '../../../pages/transaction_template/widgets/template_usage_bottom_sheet.dart';

/// Smart Template Selector with Quick Access + Traditional Template List
class SmartTemplateSelector extends ConsumerStatefulWidget {
  final String? title;
  final bool showQuickAccess;
  final int maxQuickItems;
  final Function(Map<String, dynamic>)? onTemplateSelected;

  const SmartTemplateSelector({
    super.key,
    this.title,
    this.showQuickAccess = true,
    this.maxQuickItems = 6,
    this.onTemplateSelected,
  });

  @override
  ConsumerState<SmartTemplateSelector> createState() => _SmartTemplateSelectorState();
}

class _SmartTemplateSelectorState extends ConsumerState<SmartTemplateSelector> {
  bool _showQuickAccess = true;

  @override
  Widget build(BuildContext context) {
    if (!widget.showQuickAccess || !_showQuickAccess) {
      // Just show traditional template list message
      return _buildTraditionalMessage();
    }

    // Watch quick access templates
    final quickAccessAsync = ref.watch(quickAccessTemplatesProvider(
      contextType: 'transaction',
      limit: widget.maxQuickItems,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: TossTextStyles.h4.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
        ],
        
        // Quick Access Section
        quickAccessAsync.when(
          data: (quickTemplates) {
            if (quickTemplates.isEmpty) {
              return _buildEmptyState();
            }
            return _buildQuickAccessSection(quickTemplates);
          },
          loading: () => _buildQuickAccessSkeleton(),
          error: (_, __) => _buildEmptyState(),
        ),
      ],
    );
  }

  Widget _buildQuickAccessSection(List<Map<String, dynamic>> quickTemplates) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick Access Templates',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _showQuickAccess = false),
              child: Text(
                'Hide quick access',
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
        _buildQuickAccessGrid(quickTemplates),
        
        const SizedBox(height: TossSpacing.space4),
        
        // Message for full template list
        _buildTraditionalMessage(),
      ],
    );
  }

  Widget _buildQuickAccessGrid(List<Map<String, dynamic>> templates) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.8,
        crossAxisSpacing: TossSpacing.space2,
        mainAxisSpacing: TossSpacing.space2,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return _buildQuickAccessCard(template);
      },
    );
  }

  Widget _buildQuickAccessCard(Map<String, dynamic> template) {
    final templateName = template['template_name'] ?? 'Unknown Template';
    final usageCount = template['usage_count'] ?? 0;
    final templateType = template['template_type'] ?? 'transaction';

    return TossDesignSystem.buildCard(
      onTap: () {
        _onQuickTemplateSelect(template);
      },
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          border: Border.all(color: TossColors.border),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Template name with usage indicator
            Row(
              children: [
                Expanded(
                  child: Text(
                    templateName,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (usageCount > 3)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: TossColors.success,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '⚡',
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 4),
            
            // Usage stats
            Row(
              children: [
                Icon(
                  _getTemplateIcon(templateType),
                  size: 12,
                  color: TossColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    templateType.toUpperCase(),
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
        childAspectRatio: 2.8,
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.description_outlined,
            size: 48,
            color: TossColors.textSecondary,
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'No frequently used templates yet',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Start using templates to see quick access here',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTraditionalMessage() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primarySurface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: TossColors.primary,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Go to Transaction Templates page to see all available templates',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQuickTemplateSelect(Map<String, dynamic> template) {
    // Track quick access usage
    _trackQuickAccessUsage(template);
    
    // Handle template selection
    if (widget.onTemplateSelected != null) {
      widget.onTemplateSelected!(template);
    } else {
      // Default behavior - show template usage sheet
      TemplateUsageBottomSheet.show(context, template);
    }
  }

  void _trackQuickAccessUsage(Map<String, dynamic> template) async {
    try {
      final supabase = ref.read(supabaseServiceProvider);
      final appState = ref.read(appStateProvider);
      
      if (appState.companyChoosen.isEmpty) return;

      final templateId = template['template_id'] as String?;
      final templateName = template['template_name'] as String? ?? 'Quick Access Template';
      final templateType = template['template_type'] as String? ?? 'transaction';

      if (templateId == null) return;

      // Track that this was selected via quick access - using correct RPC parameters
      await supabase.client.rpc('log_template_usage', params: {
        'p_template_id': templateId,
        'p_template_name': templateName,
        'p_company_id': appState.companyChoosen,
        'p_template_type': templateType,
        'p_usage_type': 'selected',
        'p_metadata': {
          'context': 'quick_access_selection',
          'selection_source': 'smart_template_selector',
        },
      });
    } catch (e) {
      // Silent fail
    }
  }

  IconData _getTemplateIcon(String? templateType) {
    switch (templateType?.toLowerCase()) {
      case 'income':
        return Icons.trending_up;
      case 'expense':
        return Icons.trending_down;
      case 'transfer':
        return Icons.swap_horiz;
      case 'payment':
        return Icons.payment;
      case 'receipt':
        return Icons.receipt;
      default:
        return Icons.description;
    }
  }
}