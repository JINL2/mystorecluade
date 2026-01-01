import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/index.dart';
import '../../../../domain/entities/manager_memo.dart';

/// Issue report card - Expandable card style with Manager Memo integrated
///
/// Clean, attendance-style design with:
/// - Expandable header with status badge
/// - Employee avatar, name, and report content inside
/// - Manager response section (memo input)
/// - Approve/Reject buttons ALWAYS visible for action
///
/// v6: Combined Report & Response + Manager Memo into one card
/// - isReportedSolved from RPC shows current DB status
/// - issueReportStatus tracks user's pending selection
/// - Buttons always visible so manager can change decision
class IssueReportCard extends StatefulWidget {
  final String employeeName;
  final String? employeeAvatarUrl;
  final String issueReport;
  final bool? isReportedSolved;
  final String? issueReportStatus;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  // Manager Memo fields
  final TextEditingController memoController;
  final ValueChanged<String>? onMemoChanged;
  final List<ManagerMemo> existingMemos;

  const IssueReportCard({
    super.key,
    required this.employeeName,
    this.employeeAvatarUrl,
    required this.issueReport,
    required this.isReportedSolved,
    this.issueReportStatus,
    required this.onApprove,
    required this.onReject,
    // Memo fields
    required this.memoController,
    this.onMemoChanged,
    this.existingMemos = const [],
  });

  @override
  State<IssueReportCard> createState() => _IssueReportCardState();
}

class _IssueReportCardState extends State<IssueReportCard> {
  bool _isExpanded = true;

  /// Get current status for display
  /// Priority: user selection > RPC value
  String get _statusText {
    // User selection takes priority
    if (widget.issueReportStatus == 'approved') return 'Approved';
    if (widget.issueReportStatus == 'rejected') return 'Rejected';

    // Otherwise use RPC value
    if (widget.isReportedSolved == true) return 'Approved';
    if (widget.isReportedSolved == false) return 'Rejected';

    return 'Pending';
  }

  Color get _statusColor {
    if (_statusText == 'Approved') return TossColors.success;
    if (_statusText == 'Rejected') return TossColors.error;
    return TossColors.warning;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray200, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        children: [
          // Header - tappable to expand/collapse
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(TossBorderRadius.lg),
              bottom: _isExpanded
                  ? Radius.zero
                  : const Radius.circular(TossBorderRadius.lg),
            ),
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  // Title
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Report & Response',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status badge in header
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(TossBorderRadius.full),
                          ),
                          child: Text(
                            _statusText,
                            style: TossTextStyles.caption.copyWith(
                              color: _statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expand/collapse icon
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: TossColors.gray500,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (_isExpanded) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: TossColors.gray100,
            ),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Employee report section
                  _buildReportSection(),

                  const SizedBox(height: 16),

                  // 2. Manager response (memo) section
                  _buildManagerResponseSection(),

                  const SizedBox(height: 16),

                  // 3. Action buttons (always visible)
                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Employee report',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar and name
              Row(
                children: [
                  // Avatar
                  EmployeeProfileAvatar(
                    imageUrl: widget.employeeAvatarUrl,
                    name: widget.employeeName,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  // Name
                  Expanded(
                    child: Text(
                      widget.employeeName,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Report content
              Text(
                '"${widget.issueReport}"',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildManagerResponseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manager response',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Existing memos (read-only)
        if (widget.existingMemos.isNotEmpty) ...[
          ...widget.existingMemos.map((memo) => _buildMemoItem(memo)),
          const SizedBox(height: 8),
        ],

        // New memo text field
        TextField(
          controller: widget.memoController,
          maxLines: 2,
          minLines: 1,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
          ),
          decoration: InputDecoration(
            hintText: 'Add response message...',
            hintStyle: TossTextStyles.body.copyWith(
              color: TossColors.gray400,
            ),
            filled: true,
            fillColor: TossColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.gray200, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.gray200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide:
                  const BorderSide(color: TossColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(TossSpacing.space3),
          ),
          onChanged: widget.onMemoChanged,
        ),
      ],
    );
  }

  Widget _buildMemoItem(ManagerMemo memo) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            memo.content,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray800,
            ),
          ),
          if (memo.createdAt != null && memo.createdAt!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              _formatDateString(memo.createdAt!),
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Action buttons - Toggle style selection
  ///
  /// Current selection logic:
  /// 1. issueReportStatus (user's pending selection) takes priority
  /// 2. If null, fall back to isReportedSolved (DB value)
  /// 3. If both null, no selection yet (Pending)
  Widget _buildActionButtons() {
    // Determine current effective selection
    final effectiveStatus = _getEffectiveStatus();
    final isApproved = effectiveStatus == 'approved';
    final isRejected = effectiveStatus == 'rejected';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Decision',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Reject button - selected style when rejected
            Expanded(
              child: _buildToggleButton(
                text: 'Reject',
                isSelected: isRejected,
                selectedColor: TossColors.error,
                onPressed: isRejected ? null : widget.onReject,
              ),
            ),
            const SizedBox(width: 12),
            // Approve button - selected style when approved
            Expanded(
              child: _buildToggleButton(
                text: 'Approve',
                isSelected: isApproved,
                selectedColor: TossColors.success,
                onPressed: isApproved ? null : widget.onApprove,
              ),
            ),
          ],
        ),
        // Show change indicator if user changed from DB value
        if (_hasUserChangedFromDb()) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: TossColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'Changed from ${_getDbStatusText()} → ${_statusText}',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Get effective status: user selection > DB value > null
  String? _getEffectiveStatus() {
    // User selection takes priority
    if (widget.issueReportStatus != null) {
      return widget.issueReportStatus;
    }
    // Fall back to DB value
    if (widget.isReportedSolved == true) return 'approved';
    if (widget.isReportedSolved == false) return 'rejected';
    return null; // Pending
  }

  /// Check if user has changed from DB value
  bool _hasUserChangedFromDb() {
    if (widget.issueReportStatus == null) return false;

    // Convert DB value to string for comparison
    String? dbStatus;
    if (widget.isReportedSolved == true) dbStatus = 'approved';
    if (widget.isReportedSolved == false) dbStatus = 'rejected';

    return widget.issueReportStatus != dbStatus;
  }

  /// Get DB status text for change indicator
  String _getDbStatusText() {
    if (widget.isReportedSolved == true) return 'Approved';
    if (widget.isReportedSolved == false) return 'Rejected';
    return 'Pending';
  }

  /// Build toggle-style button
  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required Color selectedColor,
    required VoidCallback? onPressed,
  }) {
    if (isSelected) {
      // Selected state - filled with color
      return Container(
        height: 44,
        decoration: BoxDecoration(
          color: selectedColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: selectedColor, width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 18,
                    color: selectedColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    text,
                    style: TossTextStyles.body.copyWith(
                      color: selectedColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Unselected state - outlined
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray300, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Format ISO8601 date string for display
  String _formatDateString(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }
}
