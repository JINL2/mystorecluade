import 'package:flutter/material.dart';

import '../../../../../shared/themes/index.dart';
import 'shift_info_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Staff Grid Section
///
/// Displays assigned staff in a 2-column grid for upcoming shifts.
/// Shows max 4 staff with "show more" button if there are more.
class StaffGridSection extends StatefulWidget {
  final List<StaffMember> staffList;

  const StaffGridSection({
    super.key,
    required this.staffList,
  });

  @override
  State<StaffGridSection> createState() => _StaffGridSectionState();
}

class _StaffGridSectionState extends State<StaffGridSection> {
  static const int _maxVisibleStaff = 4;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final hasMore = widget.staffList.length > _maxVisibleStaff;
    final displayList = _showAll || !hasMore
        ? widget.staffList
        : widget.staffList.take(_maxVisibleStaff).toList();

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4,
            crossAxisSpacing: TossSpacing.space3,
            mainAxisSpacing: TossSpacing.space2,
          ),
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            final staff = displayList[index];
            return _buildStaffItem(staff);
          },
        ),

        // Show more/less button
        if (hasMore) ...[
          const SizedBox(height: TossSpacing.space1),
          _buildShowMoreButton(),
        ],
      ],
    );
  }

  /// Build show more/less button
  Widget _buildShowMoreButton() {
    return Center(
      child: InkWell(
        onTap: () {
          setState(() {
            _showAll = !_showAll;
          });
        },
        child: Icon(
          _showAll ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: TossColors.gray500,
          size: TossSpacing.iconMD,
        ),
      ),
    );
  }

  /// Build a single staff item
  Widget _buildStaffItem(StaffMember staff) {
    return Row(
      children: [
        // Avatar
        EmployeeProfileAvatar(
          imageUrl: staff.avatarUrl,
          name: staff.name,
          size: TossDimensions.avatarXS,
          showBorder: true,
          borderColor: TossColors.gray200,
        ),
        const SizedBox(width: TossSpacing.space2),

        // Name
        Expanded(
          child: Text(
            staff.name,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray900,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
