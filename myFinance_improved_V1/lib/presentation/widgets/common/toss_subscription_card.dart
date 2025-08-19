import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/constants/ui_constants.dart';

/// Toss-style subscription status card component
/// 
/// Usage:
/// ```dart
/// TossSubscriptionCard(
///   planName: 'Premium',
///   planDescription: 'Store Management Pro',
///   status: 'active',
///   expiresAt: DateTime.now().add(Duration(days: 30)),
///   onManageTap: () => navigateToSubscription(),
/// )
/// ```
class TossSubscriptionCard extends StatelessWidget {
  final String planName;
  final String planDescription;
  final String status;
  final DateTime? expiresAt;
  final VoidCallback? onManageTap;

  const TossSubscriptionCard({
    super.key,
    required this.planName,
    required this.planDescription,
    required this.status,
    this.expiresAt,
    this.onManageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.primary.withOpacity(0.05),
            TossColors.primary.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
        border: Border.all(
          color: TossColors.primary.withOpacity(0.1),
          width: UIConstants.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (expiresAt != null) ...[
            SizedBox(height: TossSpacing.space3),
            _buildExpirationInfo(),
          ],
          SizedBox(height: TossSpacing.space3),
          _buildManageButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                planName,
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.primary,
                ),
              ),
              SizedBox(height: TossSpacing.space1),
              Text(
                planDescription,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final isActive = status.toLowerCase() == 'active';
    final badgeColor = isActive ? TossColors.success : TossColors.warning;
    final badgeText = status.toUpperCase();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusXLarge),
      ),
      child: Text(
        badgeText,
        style: TossTextStyles.caption.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildExpirationInfo() {
    if (expiresAt == null) return const SizedBox.shrink();

    final renewalText = status.toLowerCase() == 'active' 
        ? 'Renews on ${_formatDate(expiresAt!)}'
        : 'Expired on ${_formatDate(expiresAt!)}';

    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: UIConstants.iconSizeSmall - 2,
          color: TossColors.gray500,
        ),
        SizedBox(width: TossSpacing.space1),
        Text(
          renewalText,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildManageButton() {
    return TextButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onManageTap?.call();
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Manage Subscription →',
        style: TossTextStyles.body.copyWith(
          color: TossColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Pre-configured subscription card variants
class TossSubscriptionCardVariants {
  const TossSubscriptionCardVariants._();

  /// Active subscription card
  static Widget active({
    required String planName,
    required String planDescription,
    required DateTime expiresAt,
    VoidCallback? onManageTap,
  }) {
    return TossSubscriptionCard(
      planName: planName,
      planDescription: planDescription,
      status: UIConstants.statusActive,
      expiresAt: expiresAt,
      onManageTap: onManageTap,
    );
  }

  /// Inactive subscription card
  static Widget inactive({
    required String planName,
    required String planDescription,
    DateTime? expiresAt,
    VoidCallback? onManageTap,
  }) {
    return TossSubscriptionCard(
      planName: planName,
      planDescription: planDescription,
      status: UIConstants.statusInactive,
      expiresAt: expiresAt,
      onManageTap: onManageTap,
    );
  }

  /// Expired subscription card
  static Widget expired({
    required String planName,
    required String planDescription,
    required DateTime expiredAt,
    VoidCallback? onManageTap,
  }) {
    return TossSubscriptionCard(
      planName: planName,
      planDescription: planDescription,
      status: UIConstants.statusExpired,
      expiresAt: expiredAt,
      onManageTap: onManageTap,
    );
  }

  /// Free plan card
  static Widget free({
    VoidCallback? onUpgradeTap,
  }) {
    return TossSubscriptionCard(
      planName: UIConstants.planFree,
      planDescription: 'Basic Store Management',
      status: UIConstants.statusActive,
      onManageTap: onUpgradeTap,
    );
  }
}