import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import '../../providers/app_state_provider.dart';
import 'providers/transaction_template_providers.dart';
import 'models/transaction_template_model.dart';
import 'template_usage_bottom_sheet.dart';
import 'widgets/transaction_template_form.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../widgets/SB_widget/SB_searchbar_filter.dart';
import '../../widgets/SB_widget/SB_headline_group.dart';
import '../../widgets/toss/toss_primary_button.dart';

class TransactionTemplatePage extends ConsumerStatefulWidget {
  const TransactionTemplatePage({super.key});

  @override
  ConsumerState<TransactionTemplatePage> createState() => _TransactionTemplatePageState();
}

class _TransactionTemplatePageState extends ConsumerState<TransactionTemplatePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedFilter;
  String _selectedSort = 'name_asc';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
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
    
    return TossScaffold(
      key: _scaffoldKey,
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Transaction Templates',
        primaryActionText: 'Add',
        onPrimaryAction: () => _showCreateTemplateBottomSheet(context),
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        color: TossColors.primary,
        child: templatesAsync.when(
          data: (templates) {
            // Filter templates based on search
            var filteredTemplates = templates.where((template) {
              if (_searchQuery.isNotEmpty) {
                final templateName = template.name.toLowerCase();
                if (!templateName.contains(_searchQuery)) {
                  return false;
                }
              }
              
              // Add filter by type if needed
              if (_selectedFilter != null) {
                return template.transactionType == _selectedFilter;
              }
              
              return true;
            }).toList();
            
            // Sort templates based on selected sort option
            filteredTemplates.sort((a, b) {
              switch (_selectedSort) {
                case 'name_asc':
                  return a.name.compareTo(b.name);
                case 'name_desc':
                  return b.name.compareTo(a.name);
                case 'type':
                  return a.transactionType.compareTo(b.transactionType);
                default:
                  return 0;
              }
            });
            
            return CustomScrollView(
              slivers: [
                // Search Section - Always visible
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                    child: Column(
                      children: [
                        SizedBox(height: TossSpacing.space4),
                        _buildSearchSection(),
                        SizedBox(height: TossSpacing.space4),
                      ],
                    ),
                  ),
                ),
                
                // Templates Content
                if (templates.isEmpty)
                  SliverFillRemaining(
                    child: _buildEmptyState(context),
                  )
                else if (filteredTemplates.isEmpty)
                  SliverFillRemaining(
                    child: _buildNoResultsState(context),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildTemplatesSection(filteredTemplates),
                        SizedBox(height: TossSpacing.space20), // Space for bottom padding
                      ]),
                    ),
                  ),
              ],
            );
          },
          loading: () => const TossLoadingView(
            message: 'Loading templates...',
          ),
          error: (error, stack) => TossErrorView(
            error: error,
            title: 'Failed to load templates',
            onRetry: () => ref.invalidate(transactionTemplatesProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SBSearchBarFilter(
      searchController: _searchController,
      searchHint: 'Search templates...',
      onSearchChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase();
        });
      },
      onFilterTap: _showFilterOptions,
    );
  }

  Widget _buildTemplatesSection(List<TransactionTemplate> templates) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        SBHeadlineGroup(
          title: 'Templates',
        ),
        
        // Templates Container
        Container(
          padding: EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Templates List
              ...templates.asMap().entries.map((entry) {
                final index = entry.key;
                final template = entry.value;
                
                return Column(
                  children: [
                    _buildTemplateItem(template),
                    if (index < templates.length - 1) 
                      Container(
                        margin: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                        height: 0.5,
                        color: TossColors.gray200,
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateItem(TransactionTemplate template) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showTemplateUsageBottomSheet(context, template),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getTransactionColor(template.transactionType).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(
                  _getTransactionIcon(template.transactionType),
                  color: _getTransactionColor(template.transactionType),
                  size: 24,
                ),
              ),
              
              SizedBox(width: TossSpacing.space4),
              
              // Primary Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Template Name
                    Text(
                      template.name,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: TossSpacing.space1),
                    
                    // Description
                    Text(
                      template.description,
                      style: TossTextStyles.caption.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              
              // Type Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: _getTransactionColor(template.transactionType).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  border: Border.all(
                    color: _getTransactionColor(template.transactionType).withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  _getTransactionTypeLabel(template.transactionType),
                  style: TextStyle(
                    color: _getTransactionColor(template.transactionType),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              SizedBox(width: TossSpacing.space3),
              
              // Actions
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: TossColors.gray600,
                  size: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmation(context, template.templateId, template.name);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: TossColors.error, size: 20),
                        SizedBox(width: TossSpacing.space2),
                        Text('Delete', style: TextStyle(color: TossColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTransactionColor(String type) {
    switch (type) {
      case 'income':
        return TossColors.success;
      case 'expense':
        return TossColors.error;
      case 'transfer':
        return TossColors.info;
      default:
        return TossColors.gray600;
    }
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'income':
        return Icons.arrow_downward;
      case 'expense':
        return Icons.arrow_upward;
      case 'transfer':
        return Icons.swap_horiz;
      default:
        return Icons.receipt;
    }
  }

  String _getTransactionTypeLabel(String type) {
    switch (type) {
      case 'income':
        return 'Income';
      case 'expense':
        return 'Expense';
      case 'transfer':
        return 'Transfer';
      default:
        return type;
    }
  }


  Widget _buildNoResultsState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              ),
              child: Icon(
                Icons.search_off,
                size: 40,
                color: TossColors.textTertiary,
              ),
            ),
            SizedBox(height: TossSpacing.space6),
            Text(
              'No templates found',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Try a different search term or filter',
              textAlign: TextAlign.center,
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    try {
      // Invalidate provider to refresh data
      ref.invalidate(transactionTemplatesProvider);
      
      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Templates refreshed'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
          ),
        );
      }
    } catch (e) {
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
          ),
        );
      }
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 48,
              height: 4,
              margin: EdgeInsets.only(top: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter & Sort',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_selectedFilter != null || _selectedSort != 'name_asc')
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = null;
                          _selectedSort = 'name_asc';
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Reset',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Filter by Type
            _buildFilterSection(),
            
            Divider(color: TossColors.gray200),
            
            // Sort Options
            _buildSortSection(),
            
            SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    final types = ['income', 'expense', 'transfer'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Text(
            'Filter by Type',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: TossSpacing.space3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Row(
            children: types.map((type) {
              final isSelected = _selectedFilter == type;
              return Padding(
                padding: EdgeInsets.only(right: TossSpacing.space2),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFilter = isSelected ? null : type;
                      });
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? _getTransactionColor(type).withValues(alpha: 0.2)
                            : TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        border: Border.all(
                          color: isSelected
                              ? _getTransactionColor(type)
                              : TossColors.gray300,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getTransactionIcon(type),
                            size: 16,
                            color: isSelected
                                ? _getTransactionColor(type)
                                : TossColors.gray700,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Text(
                            _getTransactionTypeLabel(type),
                            style: TossTextStyles.body.copyWith(
                              color: isSelected
                                  ? _getTransactionColor(type)
                                  : TossColors.gray700,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                          if (isSelected) ...[
                            SizedBox(width: TossSpacing.space2),
                            Icon(
                              Icons.check,
                              size: 16,
                              color: _getTransactionColor(type),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Text(
            'Sort By',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        _buildSortOption('Name (A-Z)', 'name_asc', Icons.sort_by_alpha),
        _buildSortOption('Name (Z-A)', 'name_desc', Icons.sort_by_alpha),
        _buildSortOption('Type', 'type', Icons.category),
      ],
    );
  }

  Widget _buildSortOption(String label, String value, IconData icon) {
    final isSelected = _selectedSort == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSort = value;
          });
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: TossColors.gray600,
              ),
              SizedBox(width: TossSpacing.space3),
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: TossEmptyView(
        icon: Icon(
          Icons.receipt_long_outlined,
          size: 64,
          color: TossColors.textTertiary,
        ),
        title: 'No templates yet',
        description: 'Templates will appear here once they\'re created\nfor your transactions',
        action: TossPrimaryButton(
          text: 'Create Template',
          onPressed: () => _showCreateTemplateBottomSheet(context),
        ),
      ),
    );
  }

  // Removed FAB - now using TossAppBar primaryAction

  // Create Template Bottom Sheet
  void _showCreateTemplateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      enableDrag: false,
      builder: (context) => const TransactionTemplateForm(),
    );
  }
  
  // Template Usage Bottom Sheet
  void _showTemplateUsageBottomSheet(BuildContext context, TransactionTemplate template) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      enableDrag: false,
      builder: (context) => TemplateUsageBottomSheet(template: template),
    );
  }
  
  // Removed error state - using TossErrorView in build method
}
