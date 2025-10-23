import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../themes/toss_colors.dart';
import '../../themes/toss_text_styles.dart';

/// Employee Profile Avatar
///
/// Reusable widget for displaying employee profile images with fallback.
/// Can be used across multiple features (attendance, time_table, HR, etc.)
class EmployeeProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final VoidCallback? onTap;

  const EmployeeProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 40,
    this.showBorder = false,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: borderColor ?? TossColors.gray300,
                width: 2,
              )
            : null,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildPlaceholder(),
                errorWidget: (context, url, error) => _buildFallback(),
              )
            : _buildFallback(),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: widget,
      );
    }

    return widget;
  }

  Widget _buildPlaceholder() {
    return Container(
      color: TossColors.gray100,
      child: Center(
        child: SizedBox(
          width: size * 0.5,
          height: size * 0.5,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(TossColors.gray400),
          ),
        ),
      ),
    );
  }

  Widget _buildFallback() {
    // Get first character of name for avatar
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      color: TossColors.gray200,
      child: Center(
        child: Text(
          initial,
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray600,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
  }
}

/// Employee Avatar List
///
/// Displays a horizontal list of employee avatars with optional overflow indicator
class EmployeeAvatarList extends StatelessWidget {
  final List<Map<String, dynamic>> employees;
  final double avatarSize;
  final int maxVisible;
  final VoidCallback? onOverflowTap;

  const EmployeeAvatarList({
    super.key,
    required this.employees,
    this.avatarSize = 32,
    this.maxVisible = 5,
    this.onOverflowTap,
  });

  @override
  Widget build(BuildContext context) {
    final visibleEmployees = employees.take(maxVisible).toList();
    final overflowCount = employees.length - maxVisible;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show visible avatars
        ...visibleEmployees.asMap().entries.map((entry) {
          final index = entry.key;
          final employee = entry.value;

          return Padding(
            padding: EdgeInsets.only(
              left: index > 0 ? 4 : 0,
            ),
            child: EmployeeProfileAvatar(
              imageUrl: employee['profile_image'] as String?,
              name: employee['user_name'] as String? ?? 'Unknown',
              size: avatarSize,
              showBorder: true,
              borderColor: TossColors.white,
            ),
          );
        }),

        // Show overflow indicator
        if (overflowCount > 0)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: GestureDetector(
              onTap: onOverflowTap,
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: TossColors.gray300,
                  border: Border.all(
                    color: TossColors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$overflowCount',
                    style: TossTextStyles.labelSmall.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
