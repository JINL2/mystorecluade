import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/constants/ui_constants.dart';

/// Toss-style profile avatar component with consistent sizing and styling
/// 
/// Usage:
/// ```dart
/// TossProfileAvatar(
///   imageUrl: user.profileImage,
///   initials: user.initials,
///   size: UIConstants.avatarSizeLarge,
/// )
/// ```
class TossProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final bool showEditIcon;
  final VoidCallback? onEditTap;

  const TossProfileAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.size = UIConstants.avatarSizeMedium,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 1.0,
    this.showEditIcon = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Main avatar container
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TossColors.primary.withOpacity(0.1),
              border: showBorder
                  ? Border.all(
                      color: borderColor ?? TossColors.primary.withOpacity(0.2),
                      width: borderWidth,
                    )
                  : null,
            ),
            child: _buildAvatarContent(),
          ),
          
          // Edit icon overlay
          if (showEditIcon && onEditTap != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEditTap,
                child: Container(
                  width: UIConstants.profileEditIconSize,
                  height: UIConstants.profileEditIconSize,
                  decoration: BoxDecoration(
                    color: TossColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: TossColors.surface,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: TossColors.surface,
                    size: UIConstants.profileEditIconInnerSize,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildInitialsContent();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildLoadingContent();
          },
        ),
      );
    } else {
      return _buildInitialsContent();
    }
  }

  Widget _buildInitialsContent() {
    return Center(
      child: Text(
        initials,
        style: _getInitialsTextStyle(),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Center(
      child: SizedBox(
        width: size * 0.3,
        height: size * 0.3,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            TossColors.primary.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  TextStyle _getInitialsTextStyle() {
    if (size <= UIConstants.avatarSizeSmall) {
      return TossTextStyles.body.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w600,
      );
    } else if (size <= UIConstants.avatarSizeMedium) {
      return TossTextStyles.bodyLarge.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w600,
      );
    } else if (size <= UIConstants.avatarSizeLarge) {
      return TossTextStyles.h3.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w600,
      );
    } else {
      return TossTextStyles.h2.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w600,
      );
    }
  }
}

/// Pre-configured avatar variants for common use cases
class TossProfileAvatarVariants {
  const TossProfileAvatarVariants._();

  /// Small avatar for lists and compact layouts
  static Widget small({
    String? imageUrl,
    required String initials,
    VoidCallback? onTap,
  }) {
    return TossProfileAvatar(
      imageUrl: imageUrl,
      initials: initials,
      size: UIConstants.avatarSizeSmall,
      onTap: onTap,
    );
  }

  /// Medium avatar for standard profile displays
  static Widget medium({
    String? imageUrl,
    required String initials,
    VoidCallback? onTap,
    bool showBorder = false,
  }) {
    return TossProfileAvatar(
      imageUrl: imageUrl,
      initials: initials,
      size: UIConstants.avatarSizeMedium,
      onTap: onTap,
      showBorder: showBorder,
    );
  }

  /// Large avatar for profile headers
  static Widget large({
    String? imageUrl,
    required String initials,
    VoidCallback? onTap,
    bool showBorder = true,
  }) {
    return TossProfileAvatar(
      imageUrl: imageUrl,
      initials: initials,
      size: UIConstants.avatarSizeLarge,
      onTap: onTap,
      showBorder: showBorder,
    );
  }

  /// Extra large avatar for edit profile or detailed views
  static Widget extraLarge({
    String? imageUrl,
    required String initials,
    VoidCallback? onTap,
    bool showEditIcon = false,
    VoidCallback? onEditTap,
  }) {
    return TossProfileAvatar(
      imageUrl: imageUrl,
      initials: initials,
      size: UIConstants.avatarSizeXLarge,
      onTap: onTap,
      showBorder: true,
      showEditIcon: showEditIcon,
      onEditTap: onEditTap,
    );
  }

  /// App bar avatar variant
  static Widget appBar({
    String? imageUrl,
    required String initials,
    VoidCallback? onTap,
  }) {
    return TossProfileAvatar(
      imageUrl: imageUrl,
      initials: initials,
      size: UIConstants.profileAvatarSize,
      onTap: onTap,
    );
  }
}