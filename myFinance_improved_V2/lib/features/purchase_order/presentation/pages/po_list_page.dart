import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/datasources/po_remote_datasource.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../domain/entities/purchase_order.dart';
import '../providers/po_providers.dart';
import '../widgets/po_list_item.dart';
import '../widgets/po_filter_chips.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class POListPage extends ConsumerStatefulWidget {
  const POListPage({super.key});

  @override
  ConsumerState<POListPage> createState() => _POListPageState();
}

class _POListPageState extends ConsumerState<POListPage> {
  final _scrollController = ScrollController();
  List<POStatus>? _selectedStatuses;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(poListProvider.notifier).loadList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(poListProvider.notifier).loadMore();
    }
  }

  void _onFilterChanged(List<POStatus>? statuses) {
    setState(() => _selectedStatuses = statuses);
    ref.read(poListProvider.notifier).loadList(
          statuses: statuses,
          searchQuery: _searchQuery,
        );
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query.isEmpty ? null : query);
    ref.read(poListProvider.notifier).loadList(
          statuses: _selectedStatuses,
          searchQuery: _searchQuery,
        );
  }

  void _showCreatePOOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Create Purchase Order',
                style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'How would you like to create a new PO?',
                style: TossTextStyles.bodyMedium.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              const SizedBox(height: TossSpacing.space5),

              // Option 1: Convert from PI
              _CreateOptionTile(
                icon: Icons.swap_horiz,
                iconColor: TossColors.primary,
                title: 'Convert from PI',
                subtitle: 'Select an accepted Proforma Invoice to convert',
                onTap: () {
                  Navigator.pop(context);
                  _showPISelectionSheet();
                },
              ),

              const SizedBox(height: TossSpacing.space3),

              // Option 2: Create from scratch
              _CreateOptionTile(
                icon: Icons.add_circle_outline,
                iconColor: TossColors.success,
                title: 'Create from scratch',
                subtitle: 'Start with a blank Purchase Order',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/purchase-order/new');
                },
              ),

              const SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }

  void _showPISelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _PISelectionSheet(
          scrollController: scrollController,
          onPISelected: (piId) async {
            // Close the bottom sheet first
            Navigator.pop(sheetContext);

            // Show loading snackbar
            if (mounted) {
              ScaffoldMessenger.of(this.context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Converting PI to PO...'),
                    ],
                  ),
                  duration: Duration(seconds: 30),
                ),
              );
            }

            // Convert PI to PO
            final poId = await ref
                .read(poFormProvider.notifier)
                .convertFromPI(piId);

            if (mounted) {
              ScaffoldMessenger.of(this.context).hideCurrentSnackBar();

              final formState = ref.read(poFormProvider);
              if (formState.error != null) {
                // Show error
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${formState.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (poId != null) {
                // Show success
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('PO created successfully!'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );

                // Refresh PO list
                ref.read(poListProvider.notifier).refresh();

                // Navigate to the new PO detail
                this.context.push('/purchase-order/$poId');
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(poListProvider);

    // 초기 로딩 중일 때 전체 화면 로딩 뷰 표시
    if (state.isLoading && state.items.isEmpty) {
      return TossScaffold(
        appBar: TossAppBar1(
          title: 'Purchase Orders',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
        ),
        body: const TossLoadingView(message: 'Loading...'),
      );
    }

    return TossScaffold(
      appBar: TossAppBar1(
        title: 'Purchase Orders',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        primaryActionIcon: Icons.add,
        primaryActionText: 'New',
        onPrimaryAction: _showCreatePOOptions,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by PO number or buyer...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: TossColors.gray100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
              ),
              onChanged: _onSearch,
            ),
          ),

          // Filter chips
          POFilterChips(
            selectedStatuses: _selectedStatuses,
            onChanged: _onFilterChanged,
          ),

          const SizedBox(height: TossSpacing.space2),

          // List
          Expanded(
            child: _buildContent(state),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(POListState state) {
    // 초기 로딩은 build()에서 처리하므로 여기서는 에러만 처리
    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Failed to load',
              style:
                  TossTextStyles.bodyLarge.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: TossSpacing.space2),
            TextButton(
              onPressed: () => ref.read(poListProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 64, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No Purchase Orders',
              style: TossTextStyles.h3.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Create your first PO to get started',
              style:
                  TossTextStyles.bodyMedium.copyWith(color: TossColors.gray500),
            ),
            const SizedBox(height: TossSpacing.space4),
            ElevatedButton.icon(
              onPressed: () => context.push('/purchase-order/new'),
              icon: const Icon(Icons.add),
              label: const Text('Create PO'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(poListProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final item = state.items[index];
          return POListItemWidget(
            item: item,
            onTap: () => context.push('/purchase-order/${item.poId}'),
          );
        },
      ),
    );
  }
}

// ============================================================================
// Helper Widgets
// ============================================================================

/// Option tile for create PO bottom sheet
class _CreateOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CreateOptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            border: Border.all(color: TossColors.gray200),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: TossColors.gray400),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet for selecting PI to convert to PO
class _PISelectionSheet extends ConsumerWidget {
  final ScrollController scrollController;
  final void Function(String piId) onPISelected;

  const _PISelectionSheet({
    required this.scrollController,
    required this.onPISelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acceptedPIsAsync = ref.watch(acceptedPIsForConversionProvider);

    return Column(
      children: [
        // Handle bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          child: Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Proforma Invoice',
                style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                'Choose an accepted PI to convert to Purchase Order',
                style: TossTextStyles.bodyMedium.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),
        const Divider(height: 1),

        // Content
        Expanded(
          child: acceptedPIsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: TossColors.gray400),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    'Failed to load PIs',
                    style: TossTextStyles.bodyLarge.copyWith(color: TossColors.gray600),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  TextButton(
                    onPressed: () => ref.invalidate(acceptedPIsForConversionProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (piList) {
              if (piList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 64, color: TossColors.gray400),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'No Available PIs',
                        style: TossTextStyles.h3.copyWith(color: TossColors.gray600),
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      Text(
                        'All accepted PIs have been converted to PO\nor there are no accepted PIs yet',
                        textAlign: TextAlign.center,
                        style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray500),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(TossSpacing.space4),
                itemCount: piList.length,
                separatorBuilder: (_, __) => const SizedBox(height: TossSpacing.space3),
                itemBuilder: (context, index) {
                  final item = piList[index];
                  return _PIItemCard(
                    item: item,
                    onTap: () => onPISelected(item.piId),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Card widget for PI item in selection list
class _PIItemCard extends StatelessWidget {
  final AcceptedPIForConversion item;
  final VoidCallback onTap;

  const _PIItemCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            border: Border.all(color: TossColors.gray200),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            children: [
              // PI Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: TossColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.piNumber,
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.buyerName,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.currencySymbol}${_formatAmount(item.totalAmount)}',
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.primary,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Text(
                      'Accepted',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.success,
                        fontWeight: FontWeight.w500,
                      ),
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

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(2);
  }
}
