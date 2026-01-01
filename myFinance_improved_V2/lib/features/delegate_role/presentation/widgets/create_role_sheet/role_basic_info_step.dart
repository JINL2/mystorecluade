import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Step 1: Basic Role Information
///
/// Collects:
/// - Role name (required)
/// - Role description (optional)
class RoleBasicInfoStep extends StatelessWidget {
  final TextEditingController roleNameController;
  final TextEditingController descriptionController;
  final FocusNode roleNameFocus;
  final FocusNode descriptionFocus;

  const RoleBasicInfoStep({
    super.key,
    required this.roleNameController,
    required this.descriptionController,
    required this.roleNameFocus,
    required this.descriptionFocus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role Name Section
          Text(
            'Role Name',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Choose a clear, descriptive name for this role',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TossTextField(
            controller: roleNameController,
            focusNode: roleNameFocus,
            hintText: 'e.g., Store Manager, Cashier, Admin',
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => descriptionFocus.requestFocus(),
          ),
          const SizedBox(height: TossSpacing.space6),

          // Description Section
          Text(
            'Description (Optional)',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Describe the responsibilities and purpose of this role',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TossTextField(
            controller: descriptionController,
            focusNode: descriptionFocus,
            hintText: 'What does this role do?',
            maxLines: 4,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
        ],
      ),
    );
  }
}
