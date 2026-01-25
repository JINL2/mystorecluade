import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/themes/index.dart';
import '../../../shared/widgets/index.dart';
import '../entities/subscription_limit_check.dart';

/// Subscription Upgrade Dialog
///
/// Shows when user tries to add a resource (company/store/employee)
/// but has reached their plan limit.
class SubscriptionUpgradeDialog extends StatelessWidget {
  final SubscriptionLimitCheck limitCheck;
  final String resourceType; // 'company', 'store', 'employee'

  const SubscriptionUpgradeDialog({
    super.key,
    required this.limitCheck,
    required this.resourceType,
  });

  /// Show the upgrade dialog
  ///
  /// Returns true if user chose to upgrade, false otherwise.
  static Future<bool?> show(
    BuildContext context, {
    required SubscriptionLimitCheck limitCheck,
    required String resourceType,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => SubscriptionUpgradeDialog(
        limitCheck: limitCheck,
        resourceType: resourceType,
      ),
    );
  }

  String get _resourceDisplayName {
    switch (resourceType) {
      case 'company':
        return 'Company';
      case 'store':
        return 'Store';
      case 'employee':
        return 'Employee';
      default:
        return 'Resource';
    }
  }

  String get _resourcePluralName {
    switch (resourceType) {
      case 'company':
        return 'companies';
      case 'store':
        return 'stores';
      case 'employee':
        return 'employees';
      default:
        return 'resources';
    }
  }

  IconData get _resourceIcon {
    switch (resourceType) {
      case 'company':
        return Icons.business;
      case 'store':
        return Icons.storefront;
      case 'employee':
        return Icons.people;
      default:
        return Icons.block;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xxl),
          topRight: Radius.circular(TossBorderRadius.xxl),
        ),
        boxShadow: TossShadows.bottomSheet,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: TossSpacing.space3),
          Container(
            width: TossSpacing.space9,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(TossSpacing.paddingXL),
            child: Column(
              children: [
                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: TossColors.warning.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _resourceIcon,
                    size: 36,
                    color: TossColors.warning,
                  ),
                ),

                const SizedBox(height: TossSpacing.space5),

                // Title
                Text(
                  '$_resourceDisplayName Limit Reached',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TossColors.gray900,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: TossSpacing.space3),

                // Description
                Text(
                  'You\'ve reached the maximum number of $_resourcePluralName '
                  'allowed on your ${_getPlanDisplayName()} plan.',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: TossSpacing.space4),

                // Current usage card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.paddingMD),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    border: Border.all(color: TossColors.gray200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Plan',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                          Text(
                            _getPlanDisplayName(),
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Usage',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                          Text(
                            limitCheck.limitDisplayText,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: TossSpacing.space4),

                // Upgrade benefits
                _buildUpgradeBenefits(),

                const SizedBox(height: TossSpacing.space5),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: TossButton.secondary(
                        text: 'Maybe Later',
                        onPressed: () => Navigator.pop(context, false),
                        fullWidth: true,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      flex: 2,
                      child: TossButton.primary(
                        text: 'View Plans',
                        onPressed: () {
                          Navigator.pop(context, true);
                          // Navigate to subscription page
                          context.push('/my-page/subscription');
                        },
                        fullWidth: true,
                        leadingIcon: const Icon(Icons.arrow_upward),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).padding.bottom + TossSpacing.space2,
          ),
        ],
      ),
    );
  }

  String _getPlanDisplayName() {
    switch (limitCheck.planName) {
      case 'free':
        return 'Free';
      case 'basic':
        return 'Basic';
      case 'pro':
        return 'Pro';
      default:
        return 'Free';
    }
  }

  Widget _buildUpgradeBenefits() {
    final benefits = <String>[];

    if (limitCheck.planName == 'free') {
      benefits.addAll([
        'Basic: Up to 3 stores, 15 employees',
        'Pro: Unlimited stores & employees',
        'Priority support & advanced features',
      ]);
    } else if (limitCheck.planName == 'basic') {
      benefits.addAll([
        'Unlimited stores & employees',
        'Advanced analytics & reports',
        'Priority support',
      ]);
    }

    if (benefits.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upgrade to get:',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        ...benefits.map((benefit) => Padding(
              padding: const EdgeInsets.only(bottom: TossSpacing.space1),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: TossColors.success,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      benefit,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
