// lib/presentation/pages/delegate_role/widgets/user_loading_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';

class UserLoadingShimmer extends StatelessWidget {
  const UserLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: TossColors.gray100,
      highlightColor: TossColors.gray50,
      child: ListView.builder(
        padding: EdgeInsets.all(TossSpacing.space4),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: TossSpacing.space3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray100),
            ),
            padding: EdgeInsets.all(TossSpacing.space3),
            child: Row(
              children: [
                // Profile placeholder
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: TossColors.gray200,
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                
                // Content placeholder
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 150,
                        decoration: BoxDecoration(
                          color: TossColors.gray200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Container(
                        height: 14,
                        width: 200,
                        decoration: BoxDecoration(
                          color: TossColors.gray200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Container(
                        height: 24,
                        width: 80,
                        decoration: BoxDecoration(
                          color: TossColors.gray200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}