import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../models/sale_product_models.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class DeliveryToggle extends StatelessWidget {
  final bool isDelivery;
  final DeliveryInfo? deliveryInfo;
  final Function(bool) onToggle;

  const DeliveryToggle({
    super.key,
    required this.isDelivery,
    required this.deliveryInfo,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Delivery Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Switch(
              value: isDelivery,
              onChanged: onToggle,
              activeColor: TossColors.primary,
            ),
          ],
        ),
        
        // Delivery Info
        if (isDelivery && deliveryInfo != null) ...[
          const SizedBox(height: TossSpacing.space4),
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: TossColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Text(
                        deliveryInfo!.address ?? 'Giao tới ...',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: TossColors.gray600,
                    ),
                  ],
                ),
                if (deliveryInfo!.district != null || deliveryInfo!.city != null) ...[
                  const SizedBox(height: TossSpacing.space2),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (deliveryInfo!.district != null)
                          Text(
                            deliveryInfo!.district!,
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        if (deliveryInfo!.city != null)
                          Text(
                            deliveryInfo!.city!,
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        if (deliveryInfo!.phone != null)
                          Text(
                            deliveryInfo!.phone!,
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}