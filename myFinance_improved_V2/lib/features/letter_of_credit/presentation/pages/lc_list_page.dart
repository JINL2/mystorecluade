import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../domain/entities/letter_of_credit.dart';
import '../../domain/repositories/lc_repository.dart';
import '../providers/lc_providers.dart';

class LCListPage extends ConsumerStatefulWidget {
  const LCListPage({super.key});

  @override
  ConsumerState<LCListPage> createState() => _LCListPageState();
}

class _LCListPageState extends ConsumerState<LCListPage> {
  final _searchController = TextEditingController();
  List<LCStatus>? _selectedStatuses;
  String? _searchQuery;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId =
        appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;

    if (companyId.isEmpty) {
      return TossScaffold(
        appBar: TossAppBar1(
          title: 'Letter of Credit',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _navigateBack(context),
          ),
        ),
        body: const Center(child: Text('Please select a company')),
      );
    }

    final params = LCListParams(
      companyId: companyId,
      storeId: storeId,
      statuses: _selectedStatuses,
      searchQuery: _searchQuery,
    );

    final lcListAsync = ref.watch(lcListProvider(params));

    return TossScaffold(
      appBar: TossAppBar1(
        title: 'Letter of Credit',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _navigateBack(context),
        ),
        primaryActionIcon: Icons.add,
        primaryActionText: 'New',
        onPrimaryAction: () => context.push('/letter-of-credit/new'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by LC number...',
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
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.isEmpty ? null : value;
                });
              },
            ),
          ),

          // Filter chips
          _buildFilterChips(),

          const SizedBox(height: TossSpacing.space2),

          // List
          Expanded(
            child: lcListAsync.when(
              loading: () => const TossLoadingView(message: 'Loading...'),
              error: (error, _) => _buildErrorView(error.toString()),
              data: (response) => _buildList(response),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  Widget _buildFilterChips() {
    final allStatuses = [
      LCStatus.draft,
      LCStatus.issued,
      LCStatus.advised,
      LCStatus.confirmed,
      LCStatus.amended,
      LCStatus.utilized,
      LCStatus.expired,
    ];

    final isActiveSelected = _selectedStatuses != null &&
        _selectedStatuses!.contains(LCStatus.issued) &&
        _selectedStatuses!.contains(LCStatus.advised);

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        children: [
          // All filter
          _buildFilterChip(
            label: 'All',
            isSelected: _selectedStatuses == null,
            onTap: () => setState(() => _selectedStatuses = null),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Active filter
          _buildFilterChip(
            label: 'Active',
            isSelected: isActiveSelected,
            selectedColor: TossColors.success,
            onTap: () {
              setState(() {
                _selectedStatuses = [
                  LCStatus.issued,
                  LCStatus.advised,
                  LCStatus.confirmed,
                  LCStatus.amended,
                ];
              });
            },
          ),
          const SizedBox(width: TossSpacing.space2),
          // Individual status filters
          ...allStatuses.map((status) {
            final isSelected = _selectedStatuses != null &&
                _selectedStatuses!.length == 1 &&
                _selectedStatuses!.first == status;
            return Padding(
              padding: const EdgeInsets.only(right: TossSpacing.space2),
              child: _buildFilterChip(
                label: status.label,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedStatuses = isSelected ? null : [status];
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? selectedColor,
  }) {
    final bgColor = isSelected ? (selectedColor ?? TossColors.primary) : TossColors.gray200;
    final textColor = isSelected ? Colors.white : TossColors.gray600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check, size: 14, color: textColor),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String error) {
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
          Text(
            error,
            style:
                TossTextStyles.caption.copyWith(color: TossColors.gray500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TossSpacing.space4),
          TextButton(
            onPressed: () => ref.invalidate(lcListProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildList(PaginatedLCResponse response) {
    if (response.data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_outlined,
                size: 64, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No Letters of Credit',
              style: TossTextStyles.h3.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Create your first LC to get started',
              style:
                  TossTextStyles.bodyMedium.copyWith(color: TossColors.gray500),
            ),
            const SizedBox(height: TossSpacing.space4),
            ElevatedButton.icon(
              onPressed: () => context.push('/letter-of-credit/new'),
              icon: const Icon(Icons.add),
              label: const Text('Create LC'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(lcListProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        itemCount: response.data.length,
        itemBuilder: (context, index) {
          final item = response.data[index];
          return _LCListItemWidget(
            item: item,
            onTap: () async {
              final result =
                  await context.push<bool>('/letter-of-credit/${item.id}');
              if (result == true) {
                ref.invalidate(lcListProvider);
              }
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(LCStatus status) {
    switch (status) {
      case LCStatus.draft:
        return TossColors.gray500;
      case LCStatus.applied:
        return TossColors.warning;
      case LCStatus.issued:
        return TossColors.primary;
      case LCStatus.advised:
        return TossColors.info;
      case LCStatus.confirmed:
        return TossColors.success;
      case LCStatus.amended:
        return TossColors.warning;
      case LCStatus.documentsSubmitted:
        return TossColors.info;
      case LCStatus.utilized:
        return TossColors.success;
      case LCStatus.expired:
        return TossColors.error;
      case LCStatus.closed:
        return TossColors.gray600;
      case LCStatus.cancelled:
        return TossColors.gray400;
    }
  }
}

class _LCListItemWidget extends StatelessWidget {
  final LCListItem item;
  final VoidCallback onTap;

  const _LCListItemWidget({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final amountFormat = NumberFormat('#,##0.00');

    return Card(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.lcNumber,
                          style: TossTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (item.applicantName != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.applicantName!,
                            style: TossTextStyles.bodyMedium.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _buildStatusBadge(item.status),
                ],
              ),

              const SizedBox(height: TossSpacing.space3),

              // Amount and utilization
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                        Text(
                          '${item.currencyCode} ${amountFormat.format(item.amount)}',
                          style: TossTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.amountUtilized > 0)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Utilized',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                          Text(
                            '${item.utilizationPercent.toStringAsFixed(1)}%',
                            style: TossTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: TossSpacing.space3),

              // Dates and related docs
              Row(
                children: [
                  // Expiry date
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.event,
                          size: 16,
                          color: item.isExpired
                              ? TossColors.error
                              : item.isExpiryApproaching
                                  ? TossColors.warning
                                  : TossColors.gray500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Exp: ${dateFormat.format(item.expiryDateUtc)}',
                          style: TossTextStyles.caption.copyWith(
                            color: item.isExpired
                                ? TossColors.error
                                : item.isExpiryApproaching
                                    ? TossColors.warning
                                    : TossColors.gray600,
                            fontWeight: item.isExpired ||
                                    item.isExpiryApproaching
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Related PO/PI
                  if (item.poNumber != null || item.piNumber != null)
                    Row(
                      children: [
                        Icon(
                          Icons.link,
                          size: 14,
                          color: TossColors.gray500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.poNumber ?? item.piNumber ?? '',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              // Issuing bank
              if (item.issuingBankName != null) ...[
                const SizedBox(height: TossSpacing.space2),
                Row(
                  children: [
                    Icon(
                      Icons.account_balance,
                      size: 14,
                      color: TossColors.gray500,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.issuingBankName!,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              // Warning badges
              if (item.isExpired || item.isExpiryApproaching) ...[
                const SizedBox(height: TossSpacing.space2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: item.isExpired
                        ? TossColors.error.withOpacity(0.1)
                        : TossColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.isExpired
                            ? Icons.error_outline
                            : Icons.warning_amber,
                        size: 14,
                        color: item.isExpired
                            ? TossColors.error
                            : TossColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.isExpired
                            ? 'Expired'
                            : 'Expires in ${item.daysUntilExpiry} days',
                        style: TossTextStyles.caption.copyWith(
                          color: item.isExpired
                              ? TossColors.error
                              : TossColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(LCStatus status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case LCStatus.draft:
        bgColor = TossColors.gray200;
        textColor = TossColors.gray700;
        break;
      case LCStatus.applied:
        bgColor = TossColors.warning.withOpacity(0.1);
        textColor = TossColors.warning;
        break;
      case LCStatus.issued:
        bgColor = TossColors.primary.withOpacity(0.1);
        textColor = TossColors.primary;
        break;
      case LCStatus.advised:
        bgColor = TossColors.info.withOpacity(0.1);
        textColor = TossColors.info;
        break;
      case LCStatus.confirmed:
        bgColor = TossColors.success.withOpacity(0.1);
        textColor = TossColors.success;
        break;
      case LCStatus.amended:
        bgColor = TossColors.warning.withOpacity(0.1);
        textColor = TossColors.warning;
        break;
      case LCStatus.documentsSubmitted:
        bgColor = TossColors.info.withOpacity(0.1);
        textColor = TossColors.info;
        break;
      case LCStatus.utilized:
        bgColor = TossColors.success.withOpacity(0.2);
        textColor = TossColors.success;
        break;
      case LCStatus.expired:
        bgColor = TossColors.error.withOpacity(0.1);
        textColor = TossColors.error;
        break;
      case LCStatus.closed:
        bgColor = TossColors.gray300;
        textColor = TossColors.gray700;
        break;
      case LCStatus.cancelled:
        bgColor = TossColors.gray200;
        textColor = TossColors.gray500;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        status.label,
        style: TossTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
