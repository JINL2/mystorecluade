import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';

class EmployeeLoadingShimmer extends StatelessWidget {
  const EmployeeLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: TossColors.gray100,
      highlightColor: TossColors.gray50,
      child: ListView.builder(
        padding: EdgeInsets.all(TossSpacing.space4),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: TossSpacing.space3),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              child: Row(
                children: [
                  // Profile Image Placeholder
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: TossColors.gray200,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  
                  // Content Placeholder
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 16,
                          decoration: BoxDecoration(
                            color: TossColors.gray200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 20,
                              decoration: BoxDecoration(
                                color: TossColors.gray200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            SizedBox(width: TossSpacing.space2),
                            Container(
                              width: 80,
                              height: 14,
                              decoration: BoxDecoration(
                                color: TossColors.gray200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // More Icon Placeholder
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: TossColors.gray200,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}