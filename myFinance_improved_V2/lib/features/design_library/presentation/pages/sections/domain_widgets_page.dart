import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// Domain: Profile
import 'package:myfinance_improved/shared/widgets/organisms/index.dart';

// Atoms
import 'package:myfinance_improved/shared/widgets/atoms/display/employee_profile_avatar.dart';
import 'package:myfinance_improved/shared/widgets/atoms/layout/toss_section_header.dart';

// Molecules
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_white_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/display/avatar_stack_interact.dart';

import '../component_showcase.dart';

/// Domain Widgets Page - Business-specific components (Profile, Finance, Shift)
class DomainWidgetsPage extends StatelessWidget {
  const DomainWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      children: [
        // Section: Profile
        _buildSectionHeader('Profile', Icons.person),

        // EmployeeProfileAvatar
        ComponentShowcase(
          name: 'EmployeeProfileAvatar',
          filename: 'employee_profile_avatar.dart',
          child: const Row(
            children: [
              EmployeeProfileAvatar(name: 'John Doe', size: 40),
              SizedBox(width: TossSpacing.space2),
              EmployeeProfileAvatar(
                name: 'Sarah Smith',
                size: 40,
                showBorder: true,
                borderColor: TossColors.primary,
              ),
              SizedBox(width: TossSpacing.space2),
              EmployeeProfileAvatar(name: 'Mike Chen', size: 40),
            ],
          ),
        ),

        // AvatarStackInteract
        ComponentShowcase(
          name: 'AvatarStackInteract',
          filename: 'avatar_stack_interact.dart',
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarStackInteract(
                users: [
                  AvatarUser(id: '1', name: 'John Doe', subtitle: 'Manager'),
                  AvatarUser(id: '2', name: 'Jane Smith', subtitle: 'Staff'),
                  AvatarUser(id: '3', name: 'Mike Johnson', subtitle: 'Supervisor'),
                ],
                title: 'Team Members',
                countTextFormat: '{count} members',
              ),
              SizedBox(height: TossSpacing.space3),
              AvatarStackInteract(
                users: [
                  AvatarUser(id: '1', name: 'User 1'),
                  AvatarUser(id: '2', name: 'User 2'),
                  AvatarUser(id: '3', name: 'User 3'),
                  AvatarUser(id: '4', name: 'User 4'),
                  AvatarUser(id: '5', name: 'User 5'),
                  AvatarUser(id: '6', name: 'User 6'),
                ],
                title: 'Large Group',
                countTextFormat: '{count} users',
              ),
            ],
          ),
        ),

        // Section: Common Domain Components
        _buildSectionHeader('Common Components', Icons.widgets),

        // TossSectionHeader
        ComponentShowcase(
          name: 'TossSectionHeader',
          filename: 'toss_section_header.dart',
          child: TossSectionHeader(
            title: 'Recent Transactions',
            icon: Icons.receipt_long,
            trailing: TextButton(onPressed: () {}, child: const Text('View All')),
          ),
        ),

        // TossWhiteCard
        ComponentShowcase(
          name: 'TossWhiteCard',
          filename: 'toss_white_card.dart',
          child: TossWhiteCard(
            padding: const EdgeInsets.all(TossSpacing.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Title',
                  style: TossTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'White card with shadow and border',
                  style: TossTextStyles.body.copyWith(color: TossColors.textSecondary),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space8),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: TossSpacing.space4, bottom: TossSpacing.space2),
      child: Row(
        children: [
          Icon(icon, size: 20, color: TossColors.primary),
          const SizedBox(width: TossSpacing.space2),
          Text(
            title,
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
