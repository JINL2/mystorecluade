import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/themes/toss_animations.dart';
import 'package:myfinance_improved/core/constants/ui_constants.dart';
import '../models/account_mapping_models.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class AccountMappingListItem extends StatefulWidget {
  final AccountMapping mapping;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AccountMappingListItem({
    super.key,
    required this.mapping,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<AccountMappingListItem> createState() => _AccountMappingListItemState();
}

class _AccountMappingListItemState extends State<AccountMappingListItem>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TossAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: TossAnimations.standard),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.overlay, // Standard modal overlay color
      enableDrag: true, // Allow swipe-to-dismiss
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: TossSpacing.space2),
                width: UIConstants.modalDragHandleWidth,
                height: UIConstants.modalDragHandleHeight,
                decoration: BoxDecoration(
                  color: TossColors.gray300, // Restore grey handle bar
                  borderRadius: BorderRadius.circular(UIConstants.modalDragHandleBorderRadius),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Text(
                  'Account Mapping Options',
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // Options
              _buildOptionTile(
                icon: Icons.edit,
                title: 'Edit Mapping',
                subtitle: 'Modify account mapping details',
                onTap: () {
                  Navigator.pop(context);
                  widget.onEdit();
                },
              ),
              
              _buildOptionTile(
                icon: Icons.delete,
                title: 'Delete Mapping',
                subtitle: 'Remove this account mapping',
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation();
                },
                isDestructive: true,
              ),
              
              SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              Container(
                width: UIConstants.featureIconContainerSize,
                height: UIConstants.featureIconContainerSize,
                decoration: BoxDecoration(
                  color: isDestructive 
                      ? TossColors.error.withValues(alpha: 0.1)
                      : TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? TossColors.error : TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        color: isDestructive ? TossColors.error : TossColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: TossColors.textTertiary,
                size: TossSpacing.iconSM,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TossColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Text(
          'Delete Account Mapping',
          style: TossTextStyles.h4.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this account mapping? This action cannot be undone.',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            child: Text(
              'Delete',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _animationController.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _animationController.reverse();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _animationController.reverse();
        },
        onTap: _showOptionsBottomSheet,
        child: Container(
          decoration: BoxDecoration(
            color: _isPressed ? TossColors.gray100 : TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: TossColors.borderLight,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(TossSpacing.space2),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Icon(
                        Icons.swap_horiz,
                        color: TossColors.primary,
                        size: TossSpacing.iconSM,
                      ),
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Text(
                        'Account Mapping',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      color: TossColors.textTertiary,
                      size: TossSpacing.iconSM,
                    ),
                  ],
                ),
                
                SizedBox(height: TossSpacing.space3),
                
                // Mapping Flow
                Container(
                  padding: EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Column(
                    children: [
                      // My Account
                      Row(
                        children: [
                          Text(
                            'Your Account:',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: Text(
                              widget.mapping.myAccountName ?? 'Unknown Account',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: TossSpacing.space2),
                      
                      // Arrow
                      Row(
                        children: [
                          SizedBox(width: TossSpacing.space6),
                          Icon(
                            Icons.arrow_downward,
                            color: TossColors.primary,
                            size: TossSpacing.iconSM,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Text(
                            'maps to',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: TossSpacing.space2),
                      
                      // Their Account
                      Row(
                        children: [
                          Text(
                            'Their Account:',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: Text(
                              widget.mapping.linkedAccountName ?? 'Unknown Account',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: TossSpacing.space3),
                
                // Company Info
                Row(
                  children: [
                    Icon(
                      Icons.business,
                      color: TossColors.textTertiary,
                      size: TossSpacing.iconXS,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Expanded(
                      child: Text(
                        widget.mapping.linkedCompanyName ?? 'Unknown Company',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: widget.mapping.isActive 
                            ? TossColors.success.withValues(alpha: 0.1)
                            : TossColors.gray300.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                      ),
                      child: Text(
                        widget.mapping.isActive ? 'Active' : 'Inactive',
                        style: TossTextStyles.caption.copyWith(
                          color: widget.mapping.isActive 
                              ? TossColors.success
                              : TossColors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}