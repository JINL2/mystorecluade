import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/session_history_item.dart';
import '../widgets/history_detail/history_comparison_section.dart';
import '../widgets/history_detail/history_counting_info_section.dart';
import '../widgets/history_detail/history_header_section.dart';
import '../widgets/history_detail/history_items_section.dart';
import '../widgets/history_detail/history_members_section.dart';
import '../widgets/history_detail/history_merge_info_section.dart';
import '../widgets/history_detail/history_new_products_section.dart';
import '../widgets/history_detail/history_statistics_summary.dart';

/// Session history detail page - view all details of a past session
/// Supports tabs for different session types:
/// - Counting: No tabs (single view)
/// - Receiving: Items tab + New Products tab
/// - Merged: Sessions tab + Comparison tab
class SessionHistoryDetailPage extends StatefulWidget {
  final SessionHistoryItem session;

  const SessionHistoryDetailPage({
    super.key,
    required this.session,
  });

  @override
  State<SessionHistoryDetailPage> createState() => _SessionHistoryDetailPageState();
}

class _SessionHistoryDetailPageState extends State<SessionHistoryDetailPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  SessionHistoryItem get session => widget.session;

  /// Check if tabs are needed
  bool get _needsTabs => session.isReceiving || session.hasMergeInfo;

  /// Get tab labels based on session type
  List<String> get _tabLabels {
    if (session.hasMergeInfo) {
      return ['Sessions', 'Comparison'];
    } else if (session.isReceiving) {
      return ['Items', 'New'];
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    if (_needsTabs) {
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TossAppBar(
        title: session.sessionName,
      ),
      body: _needsTabs ? _buildTabbedBody() : _buildSingleBody(),
    );
  }

  /// Build body without tabs (for counting sessions)
  Widget _buildSingleBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommonHeader(),

          // v4: Counting info section (if counting session with zeroed items)
          if (session.hasCountingInfo) ...[
            HistoryCountingInfoSection(
              countingInfo: session.countingInfo!,
            ),
            const Divider(height: 1),
          ],

          // Members section
          HistoryMembersSection(members: session.members),
          const Divider(height: 1),

          // Items section
          HistoryItemsSection(
            items: session.items,
            isCounting: session.isCounting,
          ),

          // Bottom padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space6),
        ],
      ),
    );
  }

  /// Build body with tabs (for receiving and merged sessions)
  /// Uses NestedScrollView for full page scroll with sticky tab bar
  Widget _buildTabbedBody() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          // Common header as sliver
          SliverToBoxAdapter(
            child: _buildCommonHeader(),
          ),
          // Sticky tab bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: TossColors.primary,
                unselectedLabelColor: TossColors.textTertiary,
                labelStyle: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.semibold,
                ),
                unselectedLabelStyle: TossTextStyles.body,
                indicatorColor: TossColors.primary,
                indicatorWeight: 2,
                tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: session.hasMergeInfo
            ? _buildMergedTabs()
            : _buildReceivingTabs(),
      ),
    );
  }

  /// Common header sections (shown on all tabs or single view)
  Widget _buildCommonHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Session info header
        HistoryHeaderSection(session: session),
        const Divider(height: 1),

        // Statistics summary
        HistoryStatisticsSummary(session: session),
        const Divider(height: 1),
      ],
    );
  }

  /// Build tabs for receiving session
  /// IMPORTANT: Use CustomScrollView with Slivers inside NestedScrollView's body
  /// to avoid scroll conflicts that cause grey screen
  List<Widget> _buildReceivingTabs() {
    return [
      // Tab 1: Items (scanned products)
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Members section
                HistoryMembersSection(members: session.members),
                const Divider(height: 1),

                // Items section
                HistoryItemsSection(
                  items: session.items,
                  isCounting: session.isCounting,
                ),

                SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space6),
              ],
            ),
          ),
        ],
      ),
      // Tab 2: New Products
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (session.hasReceivingInfo)
                  HistoryNewProductsSection(
                    receivingInfo: session.receivingInfo!,
                  )
                else
                  _buildEmptyState('No receiving info available'),

                SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space6),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  /// Build tabs for merged session
  /// IMPORTANT: Use CustomScrollView with Slivers inside NestedScrollView's body
  /// to avoid scroll conflicts that cause grey screen
  List<Widget> _buildMergedTabs() {
    return [
      // Tab 1: Sessions (which products in which session)
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Merge info section
                if (session.hasMergeInfo) ...[
                  HistoryMergeInfoSection(
                    session: session,
                    mergeInfo: session.mergeInfo!,
                  ),
                  const Divider(height: 1),
                ],

                // Members section
                HistoryMembersSection(members: session.members),
                const Divider(height: 1),

                // Items section
                HistoryItemsSection(
                  items: session.items,
                  isCounting: session.isCounting,
                ),

                SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space6),
              ],
            ),
          ),
        ],
      ),
      // Tab 2: Comparison (unique products in each session)
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (session.hasMergeInfo)
                  HistoryComparisonSection(
                    session: session,
                    mergeInfo: session.mergeInfo!,
                  )
                else
                  _buildEmptyState('No merge info available'),

                SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space6),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space6),
      child: Center(
        child: Text(
          message,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
      ),
    );
  }
}

/// Delegate for sticky tab bar in NestedScrollView
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height + 1; // +1 for divider

  @override
  double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: TossColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          tabBar,
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
