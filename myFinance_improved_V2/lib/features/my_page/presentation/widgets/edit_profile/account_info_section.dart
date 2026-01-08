import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';

import 'package:myfinance_improved/features/my_page/domain/entities/user_profile.dart';
import 'profile_form_section.dart';

/// Read-only account information section
class AccountInfoSection extends StatelessWidget {
  final UserProfile profile;

  const AccountInfoSection({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileFormSection(
      icon: Icons.info_outline,
      title: 'Account Information',
      child: Column(
        children: [
          _buildReadOnlyField('Email', profile.email),
          const SizedBox(height: TossSpacing.space4),
          _buildReadOnlyField('Role', profile.displayRole),
          if (profile.companyName?.isNotEmpty == true) ...[
            const SizedBox(height: TossSpacing.space4),
            _buildReadOnlyField('Company', profile.companyName!),
          ],
          if (profile.storeName?.isNotEmpty == true) ...[
            const SizedBox(height: TossSpacing.space4),
            _buildReadOnlyField('Store', profile.storeName!),
          ],
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: TossFontWeight.medium,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: TossSpacing.space3,
            horizontal: TossSpacing.space4,
          ),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray100),
          ),
          child: Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ),
      ],
    );
  }
}
