import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Role stats header widget
///
/// Displays:
/// - Title and description
/// - Search field
/// - Total role count
class RoleStatsHeader extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onClear;
  final int totalRoles;

  const RoleStatsHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClear,
    required this.totalRoles,
  });

  @override
  Widget build(BuildContext context) {
    return TossSearchField(
      hintText: 'Search roles...',
      controller: searchController,
      prefixIcon: Icons.search,
      onChanged: onSearchChanged,
      onClear: onClear,
    );
  }
}
