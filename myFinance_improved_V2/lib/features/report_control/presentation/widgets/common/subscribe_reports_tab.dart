// lib/features/report_control/presentation/widgets/subscribe_reports_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/index.dart';
import '../../../domain/entities/template_with_subscription.dart';
import '../../constants/report_strings.dart';
import '../../providers/report_provider.dart';
import '../../providers/report_state.dart';
import 'template_subscription_card.dart';
import 'subscription_dialog.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Tab for subscribing to report templates
/// Shows available templates with category filtering and subscription status sorting
class SubscribeReportsTab extends ConsumerStatefulWidget {
  final String userId;
  final String companyId;

  const SubscribeReportsTab({
    super.key,
    required this.userId,
    required this.companyId,
  });

  @override
  ConsumerState<SubscribeReportsTab> createState() =>
      _SubscribeReportsTabState();
}

class _SubscribeReportsTabState extends ConsumerState<SubscribeReportsTab> {
  String? _selectedCategoryFilter;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportProvider);

    if (state.isLoadingTemplates) {
      return const TossLoadingView(message: 'Loading templates...');
    }

    // Get filtered and sorted templates
    final filteredTemplates = _getFilteredTemplates(state);
    final subscribedTemplates =
        filteredTemplates.where((t) => t.isSubscribed).toList();
    final availableTemplates =
        filteredTemplates.where((t) => !t.isSubscribed).toList();

    return Column(
      children: [
        // Modern filter section
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            border: Border(
              bottom: BorderSide(
                color: TossColors.gray100,
                width: 1,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category chips
              TossChipGroup(
                items: [
                  TossChipItem(
                    value: '',
                    label: ReportStrings.filterAll,
                    count: state.availableTemplates.length,
                  ),
                  ...state.categories.map((category) => TossChipItem(
                        value: category.categoryId,
                        label: category.categoryName,
                        count: _getCategoryTemplateCount(
                            state, category.categoryId),
                      )),
                ],
                selectedValue: _selectedCategoryFilter ?? '',
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryFilter = value == '' ? null : value;
                  });
                },
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
              ),
              SizedBox(height: TossSpacing.space2),
              // Stats row
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: TossColors.primary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Subscribed: ${subscribedTemplates.length}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Icon(
                    Icons.campaign_outlined,
                    size: 16,
                    color: TossColors.gray500,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Available: ${availableTemplates.length}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Templates list
        Expanded(
          child: filteredTemplates.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: TossColors.gray300,
                      ),
                      SizedBox(height: TossSpacing.space4),
                      Text(
                        _selectedCategoryFilter != null
                            ? 'No templates in this category'
                            : 'No report templates available',
                        style: TossTextStyles.bodyMedium.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      if (_selectedCategoryFilter != null) ...[
                        SizedBox(height: TossSpacing.space2),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategoryFilter = null;
                            });
                          },
                          child: const Text('View all templates'),
                        ),
                      ],
                    ],
                  ),
                )
              : ColoredBox(
                  color: TossColors.gray50,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(reportProvider.notifier)
                          .loadAvailableTemplates(
                            userId: widget.userId,
                            companyId: widget.companyId,
                          );
                    },
                    child: ListView(
                      padding: EdgeInsets.only(
                        top: TossSpacing.space3,
                        bottom: TossSpacing.space4,
                      ),
                      children: [
                        // Subscribed templates section
                        if (subscribedTemplates.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space4,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: TossColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                SizedBox(width: TossSpacing.space2),
                                Text(
                                  'Subscribed',
                                  style: TossTextStyles.h4.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: TossSpacing.space2),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: TossSpacing.space2,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TossColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                        TossBorderRadius.xs),
                                  ),
                                  child: Text(
                                    '${subscribedTemplates.length}',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: TossSpacing.space3),
                          ...subscribedTemplates
                              .map((template) => TemplateSubscriptionCard(
                                    template: template,
                                    onTap: () => _showSubscriptionDialog(
                                      context,
                                      ref,
                                      template,
                                    ),
                                  )),
                          SizedBox(height: TossSpacing.space4),
                        ],

                        // Available templates section
                        if (availableTemplates.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space4,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: TossColors.gray400,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                SizedBox(width: TossSpacing.space2),
                                Text(
                                  'Available',
                                  style: TossTextStyles.h4.copyWith(
                                    fontSize: 16,
                                    color: TossColors.gray700,
                                  ),
                                ),
                                SizedBox(width: TossSpacing.space2),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: TossSpacing.space2,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TossColors.gray100,
                                    borderRadius: BorderRadius.circular(
                                        TossBorderRadius.xs),
                                  ),
                                  child: Text(
                                    '${availableTemplates.length}',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray700,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: TossSpacing.space3),
                          ...availableTemplates
                              .map((template) => TemplateSubscriptionCard(
                                    template: template,
                                    onTap: () => _showSubscriptionDialog(
                                      context,
                                      ref,
                                      template,
                                    ),
                                  )),
                        ],
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  /// Get filtered templates by category
  List<TemplateWithSubscription> _getFilteredTemplates(ReportState state) {
    // Always create a new list to avoid modifying unmodifiable list
    List<TemplateWithSubscription> templates;

    if (_selectedCategoryFilter != null) {
      templates = state.availableTemplates
          .where((t) => t.categoryId == _selectedCategoryFilter)
          .toList();
    } else {
      // Create a copy of the list to make it modifiable
      templates = List<TemplateWithSubscription>.from(state.availableTemplates);
    }

    // Sort: Subscribed first, then by template name
    templates.sort((a, b) {
      if (a.isSubscribed != b.isSubscribed) {
        return a.isSubscribed ? -1 : 1;
      }
      return a.templateName.compareTo(b.templateName);
    });

    return templates;
  }

  /// Get template count for a specific category
  int _getCategoryTemplateCount(ReportState state, String categoryId) {
    return state.availableTemplates
        .where((t) => t.categoryId == categoryId)
        .length;
  }

  /// Show subscription dialog
  void _showSubscriptionDialog(
    BuildContext context,
    WidgetRef ref,
    TemplateWithSubscription template,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true, // ✅ Added: Allow dismissing by tapping outside
      enableDrag: true, // ✅ Added: Allow dismissing by dragging down
      backgroundColor: Colors.transparent,
      builder: (context) => SubscriptionDialog(
        template: template,
        userId: widget.userId,
        companyId: widget.companyId,
      ),
    );
  }
}
