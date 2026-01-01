import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Model for user data in the avatar stack
class AvatarUser {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? subtitle; // Optional subtitle (e.g., role, department, status)
  final Widget? trailingWidget; // Optional trailing widget (e.g., badge, icon)
  final String? actionState; // Current state for toggle button (e.g., 'pending', 'approved', 'rejected')

  const AvatarUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.subtitle,
    this.trailingWidget,
    this.actionState,
  });
}

/// Model for action button configuration
class UserActionButton {
  final String id;
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const UserActionButton({
    required this.id,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });
}

/// AvatarStackInteract - Configurable avatar stack with interactive bottom sheet
///
/// A reusable component that displays overlapping avatars and shows a bottom sheet
/// with the full list of users when tapped.
///
/// Features:
/// - Displays up to 4 avatars in an overlapping stack
/// - Shows "+N more" indicator if there are more users
/// - Configurable avatar size, overlap, and spacing
/// - Bottom sheet with user list and optional actions
/// - Single pill action button with 2-stage toggle (Approve/Reject, Add/Remove, etc.)
/// - Button automatically switches between states when tapped
/// - Customizable title, user list item rendering
/// - Optional empty state message
///
/// Usage Examples:
///
/// 1. Basic usage:
/// ```dart
/// AvatarStackInteract(
///   users: [
///     AvatarUser(id: '1', name: 'John Doe', avatarUrl: 'https://...'),
///     AvatarUser(id: '2', name: 'Jane Smith', subtitle: 'Manager'),
///   ],
///   title: 'Applied Users',
///   countTextFormat: '{count} applied',
/// )
/// ```
///
/// 2. With action button (single pill with 2 stages - Approve/Reject):
/// ```dart
/// AvatarStackInteract(
///   users: users.map((u) => AvatarUser(
///     id: u.id,
///     name: u.name,
///     avatarUrl: u.avatar,
///     subtitle: u.role,
///     actionState: u.status, // 'approve' or 'reject' (toggles between 2 states)
///   )).toList(),
///   title: 'Pending Applications',
///   actionButtons: [
///     // Define 2 states - button toggles between them
///     UserActionButton(
///       id: 'approve',
///       label: 'Approve',
///       icon: Icons.check,
///       backgroundColor: TossColors.success,
///       textColor: TossColors.white,
///     ),
///     UserActionButton(
///       id: 'reject',
///       label: 'Reject',
///       icon: Icons.close,
///       backgroundColor: TossColors.error,
///       textColor: TossColors.white,
///     ),
///   ],
///   onActionTap: (user, actionId) {
///     // actionId is the NEXT state (button auto-toggles)
///     setState(() {
///       user.actionState = actionId; // Update to next state
///     });
///   },
/// )
/// ```
///
/// 3. With custom builder:
/// ```dart
/// AvatarStackInteract(
///   users: teamMembers,
///   title: 'Team Members',
///   userItemBuilder: (context, user, index) {
///     return CustomUserTile(user: user);
///   },
///   onUserTap: (user) => showUserProfile(user),
/// )
/// ```
class AvatarStackInteract extends StatelessWidget {
  /// List of users to display
  final List<AvatarUser> users;

  /// Maximum number of avatars to show in the stack (default: 4)
  final int maxVisibleAvatars;

  /// Size of each avatar (default: 24)
  final double avatarSize;

  /// Overlap amount between avatars (default: 18)
  final double overlapOffset;

  /// Border width around each avatar (default: 1)
  final double borderWidth;

  /// Border color around each avatar (default: white)
  final Color borderColor;

  /// Title shown in the bottom sheet
  final String title;

  /// Optional subtitle shown below the title in bottom sheet
  final String? subtitle;

  /// Message shown when users list is empty
  final String? emptyMessage;

  /// Optional custom builder for user list items
  /// If null, uses default list tile rendering
  final Widget Function(BuildContext context, AvatarUser user, int index)? userItemBuilder;

  /// Optional callback when a user is tapped in the bottom sheet
  final void Function(AvatarUser user)? onUserTap;

  /// Optional trailing widget shown after the user count text
  final Widget? trailingWidget;

  /// Show user count text next to avatar stack (default: true)
  final bool showCount;

  /// Custom count text format. Use {count} as placeholder (default: "{count} applied")
  final String? countTextFormat;

  /// Optional list of action buttons to display for each user
  /// If provided, shows toggle buttons on the right side of each user card
  final List<UserActionButton>? actionButtons;

  /// Optional callback when an action button is tapped
  /// Returns the user and the selected action button id
  final void Function(AvatarUser user, String actionId)? onActionTap;

  const AvatarStackInteract({
    super.key,
    required this.users,
    required this.title,
    this.maxVisibleAvatars = 4,
    this.avatarSize = 24,
    this.overlapOffset = 18,
    this.borderWidth = 1,
    this.borderColor = TossColors.white,
    this.subtitle,
    this.emptyMessage,
    this.userItemBuilder,
    this.onUserTap,
    this.actionButtons,
    this.onActionTap,
    this.trailingWidget,
    this.showCount = true,
    this.countTextFormat,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty && !showCount) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => _showUsersBottomSheet(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar stack
          if (users.isNotEmpty)
            _buildAvatarStack(),

          // User count text
          if (showCount) ...[
            if (users.isNotEmpty) const SizedBox(width: 8),
            Text(
              _getCountText(),
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray600,
                fontSize: 12,
              ),
            ),
          ],

          // Optional trailing widget
          if (trailingWidget != null) ...[
            const SizedBox(width: 8),
            trailingWidget!,
          ],
        ],
      ),
    );
  }

  /// Build the avatar stack with overlapping circles
  Widget _buildAvatarStack() {
    final displayCount = users.length.clamp(0, maxVisibleAvatars);
    final hasMore = users.length > maxVisibleAvatars;

    return SizedBox(
      height: avatarSize,
      width: (displayCount * overlapOffset).toDouble() + (avatarSize - overlapOffset) + (hasMore ? overlapOffset : 0),
      child: Stack(
        children: [
          // Avatar circles
          ...List.generate(
            displayCount,
            (index) => Positioned(
              left: index * overlapOffset,
              child: _buildAvatarCircle(users[index]),
            ),
          ),

          // "+N more" indicator
          if (hasMore)
            Positioned(
              left: displayCount * overlapOffset,
              child: _buildMoreIndicator(users.length - maxVisibleAvatars),
            ),
        ],
      ),
    );
  }

  /// Build a single avatar circle
  Widget _buildAvatarCircle(AvatarUser user) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: CircleAvatar(
        radius: avatarSize / 2,
        backgroundColor: TossColors.gray200,
        backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
        onBackgroundImageError: user.avatarUrl != null ? (_, __) {} : null,
        child: user.avatarUrl == null
            ? Icon(
                Icons.person,
                size: avatarSize / 2,
                color: TossColors.gray500,
              )
            : null,
      ),
    );
  }

  /// Build "+N more" indicator circle
  Widget _buildMoreIndicator(int count) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: TossColors.gray700,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: TossTextStyles.labelSmall.copyWith(
            color: TossColors.white,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Get formatted count text
  String _getCountText() {
    if (users.isEmpty) {
      return emptyMessage ?? 'No users';
    }

    if (countTextFormat != null) {
      return countTextFormat!.replaceAll('{count}', users.length.toString());
    }

    return '${users.length} applied';
  }

  /// Show bottom sheet with full user list
  void _showUsersBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (sheetContext) => _UsersBottomSheet(
        title: title,
        subtitle: subtitle,
        users: users,
        emptyMessage: emptyMessage,
        userItemBuilder: userItemBuilder,
        onUserTap: onUserTap,
        actionButtons: actionButtons,
        onActionTap: onActionTap != null
            ? (user, actionId) {
                // Call the original callback which updates parent state
                onActionTap!(user, actionId);
                // Close the bottom sheet after action completes
                Navigator.of(sheetContext).pop();
              }
            : null,
      ),
    );
  }
}

/// Bottom sheet widget showing the full list of users
class _UsersBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<AvatarUser> users;
  final String? emptyMessage;
  final Widget Function(BuildContext context, AvatarUser user, int index)? userItemBuilder;
  final void Function(AvatarUser user)? onUserTap;
  final List<UserActionButton>? actionButtons;
  final void Function(AvatarUser user, String actionId)? onActionTap;

  const _UsersBottomSheet({
    required this.title,
    this.subtitle,
    required this.users,
    this.emptyMessage,
    this.userItemBuilder,
    this.onUserTap,
    this.actionButtons,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs / 2), // 2.0 - handle
            ),
          ),

          // Header - centered like TossDropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Subtitle (if provided)
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontSize: 13,
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Divider(height: 1, thickness: 1, color: TossColors.gray100),
          ),
          const SizedBox(height: 8),

          // User list
          Flexible(
            child: users.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    itemCount: users.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: TossColors.gray50,
                      indent: 68,
                    ),
                    itemBuilder: (context, index) {
                      final user = users[index];

                      // Use custom builder if provided
                      if (userItemBuilder != null) {
                        return userItemBuilder!(context, user, index);
                      }

                      // Default list tile
                      return _buildDefaultUserItem(context, user);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Build default user list item
  Widget _buildDefaultUserItem(BuildContext context, AvatarUser user) {
    return InkWell(
      onTap: onUserTap != null ? () => onUserTap!(user) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: TossColors.gray200,
              backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
              onBackgroundImageError: user.avatarUrl != null ? (_, __) {} : null,
              child: user.avatarUrl == null
                  ? Icon(Icons.person, size: TossSpacing.iconSM, color: TossColors.gray500)
                  : null,
            ),
            const SizedBox(width: 12),

            // Name and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (user.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      user.subtitle!,
                      style: TossTextStyles.labelSmall.copyWith(
                        color: TossColors.gray600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing widget or action buttons
            if (user.trailingWidget != null) ...[
              const SizedBox(width: 12),
              user.trailingWidget!,
            ] else if (actionButtons != null && actionButtons!.isNotEmpty) ...[
              const SizedBox(width: 12),
              _buildActionButtons(user),
            ],
          ],
        ),
      ),
    );
  }

  /// Build action button for user (single pill button with 2 stages)
  Widget _buildActionButtons(AvatarUser user) {
    if (actionButtons == null || actionButtons!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get the appropriate button based on current state
    // If actionButtons has 2 items, treat as binary toggle (active/inactive)
    // Otherwise, find the button matching the current actionState
    UserActionButton currentButton;
    String nextActionId;

    if (actionButtons!.length == 2) {
      // Binary toggle: switch between first and second button
      final isFirstState = user.actionState == actionButtons![0].id || user.actionState == null;
      currentButton = isFirstState ? actionButtons![0] : actionButtons![1];
      nextActionId = isFirstState ? actionButtons![1].id : actionButtons![0].id;
    } else {
      // Find current button or use first as default
      currentButton = actionButtons!.firstWhere(
        (btn) => btn.id == user.actionState,
        orElse: () => actionButtons![0],
      );
      // For simplicity, cycle through buttons (can be enhanced later)
      final currentIndex = actionButtons!.indexOf(currentButton);
      final nextIndex = (currentIndex + 1) % actionButtons!.length;
      nextActionId = actionButtons![nextIndex].id;
    }

    final isActive = user.actionState == currentButton.id;

    return GestureDetector(
      onTap: onActionTap != null ? () => onActionTap!(user, nextActionId) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? (currentButton.backgroundColor ?? TossColors.primary)
              : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          border: currentButton.borderColor != null
              ? Border.all(
                  color: isActive
                      ? (currentButton.borderColor ?? TossColors.transparent)
                      : TossColors.gray200,
                  width: 1,
                )
              : Border.all(color: TossColors.gray200, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentButton.icon != null) ...[
              Icon(
                currentButton.icon,
                size: TossSpacing.iconXS - 2, // 14 - compact icon
                color: isActive
                    ? (currentButton.textColor ?? TossColors.white)
                    : TossColors.gray700,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              currentButton.label,
              style: TossTextStyles.labelSmall.copyWith(
                color: isActive
                    ? (currentButton.textColor ?? TossColors.white)
                    : TossColors.gray700,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: TossSpacing.iconLG + TossSpacing.iconXS, // 48 - large display
              color: TossColors.gray400,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage ?? 'No users yet',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
