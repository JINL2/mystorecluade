import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_empty_view.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../domain/entities/work_schedule_template.dart';
import '../../providers/store_shift_providers.dart';
import 'template_card.dart';
import 'template_form_dialog.dart';

/// Schedule Tab
///
/// Company-level work schedule template management.
/// This tab does NOT require store selection since templates are company-wide.
class ScheduleTab extends ConsumerWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final templatesAsync = ref.watch(workScheduleTemplatesProvider);

    // Check if company is selected
    if (appState.companyChoosen.isEmpty) {
      return const Center(
        child: TossEmptyView(
          icon: Icon(
            LucideIcons.building2,
            size: 64,
            color: TossColors.gray400,
          ),
          title: 'No company selected',
          description: 'Please select a company to manage work schedules',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(workScheduleTemplatesProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Info Header (no store selector needed)
            _buildCompanyHeader(context, appState.companyName),
            const SizedBox(height: TossSpacing.space4),

            // Templates List
            templatesAsync.when(
              data: (templates) => _buildTemplatesList(
                context,
                ref,
                templates,
              ),
              loading: () => const TossLoadingView(
                message: 'Loading templates...',
              ),
              error: (error, stack) => TossEmptyView(
                icon: const Icon(
                  LucideIcons.alertCircle,
                  size: 64,
                  color: TossColors.error,
                ),
                title: 'Error loading templates',
                description: error.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader(BuildContext context, String companyName) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const Icon(
              LucideIcons.building2,
              color: TossColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company-wide Schedule Templates',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  companyName.isNotEmpty ? companyName : 'Your Company',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesList(
    BuildContext context,
    WidgetRef ref,
    List<WorkScheduleTemplate> templates,
  ) {
    if (templates.isEmpty) {
      return Column(
        children: [
          const TossEmptyView(
            icon: Icon(
              LucideIcons.calendarClock,
              size: 64,
              color: TossColors.gray400,
            ),
            title: 'No schedule templates',
            description:
                'Create templates to define working hours for monthly employees',
          ),
          const SizedBox(height: TossSpacing.space4),
          ElevatedButton.icon(
            onPressed: () => _showAddTemplateDialog(context, ref),
            icon: const Icon(LucideIcons.plus, size: TossSpacing.iconSM),
            label: const Text('Create Template'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Add Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Work Schedule Templates',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              onPressed: () => _showAddTemplateDialog(context, ref),
              icon: const Icon(
                LucideIcons.plus,
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),

        // Templates List
        ...templates.map(
          (template) => Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space3),
            child: TemplateCard(
              template: template,
              onEdit: () => _showEditTemplateDialog(context, ref, template),
              onDelete: () => _showDeleteConfirmation(context, ref, template),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddTemplateDialog(BuildContext context, WidgetRef ref) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TemplateFormDialog(),
    );
  }

  void _showEditTemplateDialog(
    BuildContext context,
    WidgetRef ref,
    WorkScheduleTemplate template,
  ) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TemplateFormDialog(template: template),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    WorkScheduleTemplate template,
  ) async {
    HapticFeedback.mediumImpact();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Template'),
        content: Text(
          template.employeeCount > 0
              ? 'This template is assigned to ${template.employeeCount} employee(s). '
                  'You must unassign all employees before deleting.'
              : 'Are you sure you want to delete "${template.templateName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          if (template.employeeCount == 0)
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: TossColors.error),
              child: const Text('Delete'),
            ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final result = await ref.read(deleteWorkScheduleTemplateProvider)(
          template.templateId,
        );

        if (result['success'] == true && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Template deleted successfully'),
              backgroundColor: TossColors.success,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete: $e'),
              backgroundColor: TossColors.error,
            ),
          );
        }
      }
    }
  }
}
