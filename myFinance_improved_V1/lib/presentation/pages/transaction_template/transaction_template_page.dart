import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import '../../providers/app_state_provider.dart';
import 'providers/transaction_template_providers.dart';
import 'models/transaction_template_model.dart';
import 'transaction_template_page_step_based.dart';
import 'template_usage_bottom_sheet.dart';

class TransactionTemplatePage extends ConsumerStatefulWidget {
  const TransactionTemplatePage({super.key});

  @override
  ConsumerState<TransactionTemplatePage> createState() => _TransactionTemplatePageState();
}

class _TransactionTemplatePageState extends ConsumerState<TransactionTemplatePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    // Load user companies and categories if not already loaded
    final appState = ref.read(appStateProvider);
    
    // Check if we need to load user data
    if (appState.user.isEmpty) {
      await ref.read(userCompaniesProvider.future);
    }
    
    // Check if we need to load categories
    if (appState.categoryFeatures.isEmpty) {
      await ref.read(categoriesWithFeaturesProvider.future);
    }
  }

  Future<void> _deleteTemplate(String templateId) async {
    try {
      final supabase = Supabase.instance.client;
      
      // Soft delete by setting is_active to false
      await supabase
          .from('transaction_templates')
          .update({'is_active': false})
          .eq('template_id', templateId);
      
      // Refresh the templates list
      ref.invalidate(transactionTemplatesProvider);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Template deleted successfully'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete template: $e'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context, String templateId, String templateName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TossColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: TossColors.error,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Delete Template',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "$templateName"?\n\nThis action cannot be undone.',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Cancel',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTemplate(templateId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.error,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Delete',
                style: TossTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(transactionTemplatesProvider);
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Search
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Transaction Templates',
                        style: TossTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(_isSearching ? Icons.close : Icons.search),
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                            if (!_isSearching) {
                              _searchController.clear();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  
                  // Search Bar (shown when searching)
                  if (_isSearching) ...[
                    SizedBox(height: TossSpacing.space3),
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(TossBorderRadius.full),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TossTextStyles.body,
                        decoration: InputDecoration(
                          hintText: 'Search templates...',
                          hintStyle: TossTextStyles.body.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space4,
                            vertical: TossSpacing.space2,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            // Trigger rebuild for filtering
                          });
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Templates List
            Expanded(
              child: Stack(
                children: [
                  templatesAsync.when(
                    data: (templates) {
                      // Filter templates based on search
                      final filteredTemplates = templates.where((template) {
                        if (_searchController.text.isEmpty) return true;
                        return template.name.toLowerCase().contains(_searchController.text.toLowerCase());
                      }).toList();
                      
                      if (filteredTemplates.isEmpty) {
                        return _buildEmptyState(context);
                      }
                      
                      return ListView.separated(
                        padding: EdgeInsets.only(
                          top: TossSpacing.space3,
                          left: TossSpacing.space4,
                          right: TossSpacing.space4,
                          bottom: TossSpacing.space20, // Extra space for FAB
                        ),
                        itemCount: filteredTemplates.length,
                        separatorBuilder: (context, index) => SizedBox(height: TossSpacing.space3),
                        itemBuilder: (context, index) {
                          final template = filteredTemplates[index];
                          return _buildTemplateCard(context, template);
                        },
                      );
                    },
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    error: (error, stack) => _buildErrorState(context, error),
                  ),
                  // FAB is now outside the when() so it's always visible
                  _buildFloatingActionButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Template Card Widget
  Widget _buildTemplateCard(BuildContext context, TransactionTemplate template) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: TossShadows.shadow1,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          onTap: () {
            // Show template usage bottom sheet
            _showTemplateUsageBottomSheet(context, template);
          },
          child: Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                // Icon based on transaction type
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: template.transactionType == 'income'
                        ? Colors.green.withOpacity(0.1)
                        : template.transactionType == 'expense'
                        ? Colors.red.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  ),
                  child: Icon(
                    template.transactionType == 'income'
                        ? Icons.arrow_downward
                        : template.transactionType == 'expense'
                        ? Icons.arrow_upward
                        : Icons.swap_horiz,
                    color: template.transactionType == 'income'
                        ? Colors.green
                        : template.transactionType == 'expense'
                        ? Colors.red
                        : Colors.blue,
                    size: 24,
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                
                // Template Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        template.description,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Delete button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: TossColors.gray600,
                    size: 20,
                  ),
                  onPressed: () {
                    _showDeleteConfirmation(context, template.templateId, template.name);
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
            SizedBox(height: TossSpacing.space6),
            Text(
              'No Templates Yet',
              style: TossTextStyles.h3.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Create your first template to\nspeed up transaction entry',
              style: TossTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: TossSpacing.space8),
            ElevatedButton.icon(
              onPressed: () {
                _showCreateTemplateBottomSheet(context);
              },
              icon: Icon(Icons.add),
              label: Text('Create Template'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space6,
                  vertical: TossSpacing.space3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Floating Action Button
  Widget _buildFloatingActionButton(BuildContext context) {
    return Positioned(
      bottom: TossSpacing.space8, // Increased from space4 to space8 (32px)
      right: TossSpacing.space4,
      child: FloatingActionButton.extended(
        onPressed: () {
          // Show create template bottom sheet
          _showCreateTemplateBottomSheet(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 4,
        icon: Icon(Icons.add),
        label: Text(
          'Add Transaction',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
        ),
      ),
    );
  }

  // Create Template Bottom Sheet
  void _showCreateTemplateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: CreateTemplateContent(),
        );
      },
    );
  }
  
  // Template Usage Bottom Sheet
  void _showTemplateUsageBottomSheet(BuildContext context, TransactionTemplate template) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: TemplateUsageBottomSheet(template: template),
        );
      },
    );
  }
  
  // Error State method
  Widget _buildErrorState(BuildContext context, dynamic error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              'Something went wrong',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              error.toString(),
              style: TossTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}