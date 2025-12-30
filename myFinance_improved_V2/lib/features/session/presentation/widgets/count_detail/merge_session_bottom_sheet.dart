import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_list_item.dart';
import '../../providers/session_list_provider.dart';

/// Bottom sheet for selecting a session to merge
class MergeSessionBottomSheet extends ConsumerStatefulWidget {
  final String currentSessionId;
  final String sessionType;
  final void Function(SessionListItem session) onSessionSelected;

  const MergeSessionBottomSheet({
    super.key,
    required this.currentSessionId,
    required this.sessionType,
    required this.onSessionSelected,
  });

  @override
  ConsumerState<MergeSessionBottomSheet> createState() =>
      _MergeSessionBottomSheetState();
}

class _MergeSessionBottomSheetState
    extends ConsumerState<MergeSessionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionListNotifierProvider(widget.sessionType));

    // Filter out current session from the list
    final availableSessions = state.sessions
        .where((s) => s.sessionId != widget.currentSessionId && s.isActive)
        .toList();

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.only(top: TossSpacing.space3),
              child: Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Session to Merge',
                      style: TossTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray900,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: TossColors.gray500,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: TossColors.gray200),
            // Content
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.all(TossSpacing.space6),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (availableSessions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(TossSpacing.space6),
                child: Center(
                  child: Text(
                    'No other active sessions available to merge',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    vertical: TossSpacing.space2,
                  ),
                  itemCount: availableSessions.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    color: TossColors.gray100,
                    indent: TossSpacing.space4,
                    endIndent: TossSpacing.space4,
                  ),
                  itemBuilder: (context, index) {
                    final session = availableSessions[index];
                    return _buildSessionItem(session);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionItem(SessionListItem session) {
    // Parse date
    String dateStr = '';
    try {
      final dateTime = DateTime.parse(session.createdAt);
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      dateStr = '$day.$month';
    } catch (_) {
      dateStr = '';
    }

    return GestureDetector(
      onTap: () => widget.onSessionSelected(session),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Date
            SizedBox(
              width: 48,
              child: Text(
                dateStr,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Session info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.sessionName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    session.storeName,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // User avatar
                      Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: TossColors.gray200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            session.createdByName.isNotEmpty
                                ? session.createdByName[0].toUpperCase()
                                : '?',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        session.createdByName,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      const Icon(
                        Icons.people_outline,
                        size: 12,
                        color: TossColors.gray400,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${session.memberCount}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow icon
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
