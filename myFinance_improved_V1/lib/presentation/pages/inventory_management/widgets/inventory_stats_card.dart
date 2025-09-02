import 'package:flutter/material.dart';
import '../../../../core/themes/index.dart';

class InventoryStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const InventoryStatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: TossSpacing.space16 * 2.5,
      margin: const EdgeInsets.only(right: TossSpacing.paddingSM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.8),
            color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: TossSpacing.space2,
            offset: const Offset(0, TossSpacing.space1),
          ),
        ],
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          onTap: () {
            // Navigate to detailed view
          },
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      icon,
                      color: TossColors.white.withOpacity(0.9),
                      size: TossSpacing.iconMD,
                    ),
                    Icon(
                      TossIcons.forward,
                      color: TossColors.white.withOpacity(0.5),
                      size: TossSpacing.iconXS,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      title,
                      style: TextStyle(
                        color: TossColors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
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