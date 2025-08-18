import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_app_bar.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_error_view.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_empty_view.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_list_tile.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_refresh_indicator.dart';
import 'package:myfinance_improved/data/services/supabase_service.dart';
import 'providers/transaction_template_providers.dart';
import 'widgets/add_template_bottom_sheet.dart';
import 'widgets/template_usage_bottom_sheet.dart';

class TransactionTemplatePage extends ConsumerWidget {
  const TransactionTemplatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the templates provider
    final templatesAsync = ref.watch(transactionTemplatesProvider);
    final companyChoosen = ref.watch(templateCompanyChoosenProvider);
    final storeChoosen = ref.watch(templateStoreChoosenProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Transaction Templates',
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: TossColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          templatesAsync.when(
        data: (templates) {
          if (companyChoosen.isEmpty || storeChoosen.isEmpty) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(TossSpacing.space6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 64,
                      color: TossColors.gray400,
                    ),
                    SizedBox(height: TossSpacing.space4),
                    Text(
                      'No Company or Store Selected',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    Text(
                      'Please select a company and store from the menu',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (templates.isEmpty) {
            return TossEmptyView(
              icon: Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: TossColors.gray400,
              ),
              title: 'No Templates Found',
              description: 'Create your first transaction template to get started',
            );
          }

          return TossRefreshIndicator(
            onRefresh: () async {
              // Refresh the provider
              ref.invalidate(transactionTemplatesProvider);
            },
            child: ListView.builder(
              padding: EdgeInsets.all(TossSpacing.space4),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                return _buildTemplateCard(context, template);
              },
            ),
          );
        },
        loading: () => const TossLoadingView(
          message: 'Loading templates...',
        ),
        error: (error, stack) => TossErrorView(
          title: 'Failed to load templates',
          error: error,
          onRetry: () {
            ref.invalidate(transactionTemplatesProvider);
          },
        ),
          ),
          // Floating Action Button
          if (companyChoosen.isNotEmpty && storeChoosen.isNotEmpty)
            Positioned(
              bottom: TossSpacing.space6,
              right: TossSpacing.space6,
              child: _buildFloatingActionButton(context),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: TossColors.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: TossColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            AddTemplateBottomSheet.show(context);
          },
          child: Icon(
            Icons.add,
            color: TossColors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, Map<String, dynamic> template) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        boxShadow: [
          BoxShadow(
            color: TossColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Consumer(
        builder: (context, ref, child) {
          return TossListTile(
            title: template['name'] ?? 'Unnamed Template',
            subtitle: _buildSubtitle(template),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: TossColors.primarySurface,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                Icons.receipt,
                color: TossColors.primary,
                size: 24,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: TossColors.error,
                size: 22,
              ),
              onPressed: () {
                _showDeleteConfirmationDialog(context, ref, template);
              },
            ),
            onTap: () {
              // Show template usage bottom sheet
              TemplateUsageBottomSheet.show(context, template);
            },
            showDivider: false,
          );
        },
      ),
    );
  }

  String _buildSubtitle(Map<String, dynamic> template) {
    final parts = <String>[];
    
    // Add template description if exists
    final description = template['template_description'];
    if (description != null && description.toString().isNotEmpty) {
      parts.add(description.toString());
    }
    
    // Add categories from tags
    final tags = template['tags'];
    if (tags is Map) {
      final categories = tags['categories'];
      if (categories is List && categories.isNotEmpty) {
        // Join categories with slash for display
        final categoryDisplay = categories.join(' / ');
        parts.add('Category: $categoryDisplay');
      }
    }
    
    // Add account count from data
    final data = template['data'];
    if (data is List) {
      parts.add('${data.length} entries');
    }
    
    return parts.isEmpty ? 'No description' : parts.join(' • ');
  }

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref, Map<String, dynamic> template) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: TossColors.errorLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: TossColors.error,
                  size: 24,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  'Delete Template',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete this template?',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textPrimary,
                ),
              ),
              SizedBox(height: TossSpacing.space3),
              Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template['name'] ?? 'Unnamed Template',
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.textPrimary,
                      ),
                    ),
                    if (template['template_description'] != null && 
                        template['template_description'].toString().isNotEmpty) ...[
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        template['template_description'].toString(),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: TossSpacing.space3),
              Text(
                'This action cannot be undone.',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TossTextStyles.button.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteTemplate(context, ref, template);
              },
              child: Text(
                'Delete',
                style: TossTextStyles.button.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTemplate(BuildContext context, WidgetRef ref, Map<String, dynamic> template) async {
    final supabaseService = ref.read(supabaseServiceProvider);
    final templateId = template['template_id'];
    
    if (templateId == null) {
      // Show error if template_id is missing
      _showErrorSnackBar(context, 'Unable to delete template: Invalid template ID');
      return;
    }
    
    try {
      // Update the template to set is_active to false
      await supabaseService.client
          .from('transaction_templates')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('template_id', templateId);
      
      // Refresh the template list
      ref.invalidate(transactionTemplatesProvider);
      
      // Show success message
      if (context.mounted) {
        _showSuccessSnackBar(context, 'Template deleted successfully');
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to delete template: ${e.toString()}');
      }
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: TossColors.white,
              size: 20,
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                message,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: TossColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        margin: EdgeInsets.all(TossSpacing.space4),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: TossColors.white,
              size: 20,
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                message,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: TossColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        margin: EdgeInsets.all(TossSpacing.space4),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}