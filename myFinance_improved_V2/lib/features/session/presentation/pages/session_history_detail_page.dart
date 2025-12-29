import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../domain/entities/session_history_item.dart';
import '../widgets/history_detail/history_header_section.dart';
import '../widgets/history_detail/history_items_section.dart';
import '../widgets/history_detail/history_members_section.dart';
import '../widgets/history_detail/history_merge_info_section.dart';
import '../widgets/history_detail/history_receiving_info_section.dart';
import '../widgets/history_detail/history_statistics_summary.dart';

/// Session history detail page - view all details of a past session
class SessionHistoryDetailPage extends StatelessWidget {
  final SessionHistoryItem session;

  const SessionHistoryDetailPage({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TossAppBar1(
        title: session.sessionName,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session info header
            HistoryHeaderSection(session: session),
            const Divider(height: 1),

            // Statistics summary
            HistoryStatisticsSummary(session: session),
            const Divider(height: 1),

            // Merge info section (if merged session)
            if (session.hasMergeInfo) ...[
              HistoryMergeInfoSection(
                session: session,
                mergeInfo: session.mergeInfo!,
              ),
              const Divider(height: 1),
            ],

            // Receiving info section (if receiving session with stock snapshot)
            if (session.hasReceivingInfo) ...[
              HistoryReceivingInfoSection(
                receivingInfo: session.receivingInfo!,
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
      ),
    );
  }
}
