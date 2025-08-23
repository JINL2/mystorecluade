import 'package:flutter/material.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';

/// SB Common Card Component
/// Reusable card widget with consistent styling matching the employee card design
class SBCommonCard extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String primaryText;
  final String secondaryText;
  final String amountText;
  final String periodText;
  final VoidCallback? onTap;
  final double? iconSize;
  final bool showChevron;
  
  // Enhanced features for role cards
  final IconData? amountIcon;
  final IconData? periodIcon;
  final Color? amountColor;
  final Color? periodColor;

  const SBCommonCard({
    super.key,
    required this.icon,
    required this.primaryText,
    required this.secondaryText,
    required this.amountText,
    required this.periodText,
    this.onTap,
    this.iconColor,
    this.iconBackgroundColor,
    this.iconSize = 24,
    this.showChevron = true,
    this.amountIcon,
    this.periodIcon,
    this.amountColor,
    this.periodColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
          child: Row(
            children: [
              // Icon Container (replaces avatar)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackgroundColor ?? 
                         Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Theme.of(context).colorScheme.primary,
                  size: iconSize,
                ),
              ),
              
              SizedBox(width: TossSpacing.space4),
              
              // Primary Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Primary Text (Name/Title)
                    Text(
                      primaryText,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: TossSpacing.space1),
                    
                    // Secondary Text (Subtitle/Description)
                    Text(
                      secondaryText,
                      style: TossTextStyles.caption.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Amount Info - Better space utilization
              Expanded(
                flex: 0,
                child: Container(
                  constraints: BoxConstraints(minWidth: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Amount Row (with optional icon)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (amountIcon != null) ...[
                            Icon(
                              amountIcon!,
                              size: 16,
                              color: amountColor ?? Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: TossSpacing.space1),
                          ],
                          Text(
                            amountText,
                            style: TossTextStyles.body.copyWith(
                              color: amountColor ?? Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: TossSpacing.space2),
                      
                      // Period Row (with optional icon)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (periodIcon != null) ...[
                            Icon(
                              periodIcon!,
                              size: 16,
                              color: periodColor ?? const Color(0xFFE53935),
                            ),
                            SizedBox(width: TossSpacing.space1),
                          ],
                          Text(
                            periodText,
                            style: TossTextStyles.caption.copyWith(
                              color: periodColor ?? const Color(0xFFE53935),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              if (showChevron) ...[
                SizedBox(width: TossSpacing.space2),
                
                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 22,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// SB Common Card Builder
/// Helper class to create different variations of the SB Common Card
class SBCommonCardBuilder {
  
  /// Employee/Team Member Card
  static Widget employee({
    required String name,
    required String role,
    required String salary,
    required String period,
    VoidCallback? onTap,
  }) {
    return SBCommonCard(
      icon: Icons.person,
      primaryText: name,
      secondaryText: role,
      amountText: salary,
      periodText: period,
      onTap: onTap,
    );
  }
  
  /// Account/Financial Card
  static Widget account({
    required String accountName,
    required String accountType,
    required String balance,
    required String status,
    VoidCallback? onTap,
  }) {
    return SBCommonCard(
      icon: Icons.account_balance_wallet,
      primaryText: accountName,
      secondaryText: accountType,
      amountText: balance,
      periodText: status,
      onTap: onTap,
    );
  }
  
  /// Transaction Card
  static Widget transaction({
    required String title,
    required String description,
    required String amount,
    required String date,
    VoidCallback? onTap,
  }) {
    return SBCommonCard(
      icon: Icons.receipt,
      primaryText: title,
      secondaryText: description,
      amountText: amount,
      periodText: date,
      onTap: onTap,
    );
  }
  
  /// Store/Location Card
  static Widget store({
    required String storeName,
    required String location,
    required String revenue,
    required String status,
    VoidCallback? onTap,
  }) {
    return SBCommonCard(
      icon: Icons.store,
      primaryText: storeName,
      secondaryText: location,
      amountText: revenue,
      periodText: status,
      onTap: onTap,
    );
  }
  
  /// Role Card with member and permission indicators
  static Widget role({
    required IconData icon,
    required String roleName,
    required String description,
    required int memberCount,
    required int permissionCount,
    Color? iconColor,
    Color? iconBackgroundColor,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    return SBCommonCard(
      icon: icon,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      primaryText: roleName,
      secondaryText: description,
      amountText: '$memberCount',
      periodText: '$permissionCount',
      amountIcon: Icons.person_outline,
      periodIcon: Icons.shield_outlined,
      amountColor: iconColor,
      periodColor: Colors.grey[600],
      showChevron: showChevron,
      onTap: onTap,
    );
  }
  
  /// Custom Card with specific icon and colors
  static Widget custom({
    required IconData icon,
    required String primaryText,
    required String secondaryText,
    required String amountText,
    required String periodText,
    Color? iconColor,
    Color? iconBackgroundColor,
    double? iconSize,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    return SBCommonCard(
      icon: icon,
      primaryText: primaryText,
      secondaryText: secondaryText,
      amountText: amountText,
      periodText: periodText,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      iconSize: iconSize,
      showChevron: showChevron,
      onTap: onTap,
    );
  }
}