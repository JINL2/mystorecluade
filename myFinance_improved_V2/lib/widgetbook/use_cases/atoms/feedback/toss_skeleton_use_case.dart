import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_skeleton.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

final tossSkeletonComponent = WidgetbookComponent(
  name: 'TossSkeleton',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Basic Skeleton:'),
            const SizedBox(height: TossSpacing.space3),
            const TossSkeleton(width: 200, height: 20),
            const SizedBox(height: TossSpacing.space4),

            const Text('Card Skeleton:'),
            const SizedBox(height: TossSpacing.space3),
            TossSkeleton.card(height: 120),
            const SizedBox(height: TossSpacing.space4),

            const Text('Circle Skeleton (Avatar):'),
            const SizedBox(height: TossSpacing.space3),
            Row(
              children: [
                TossSkeleton.circle(size: 32),
                const SizedBox(width: TossSpacing.space2),
                TossSkeleton.circle(size: 48),
                const SizedBox(width: TossSpacing.space2),
                TossSkeleton.circle(size: 64),
              ],
            ),
            const SizedBox(height: TossSpacing.space4),

            const Text('Text Skeleton:'),
            const SizedBox(height: TossSpacing.space3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TossSkeleton.text(width: 150),
                const SizedBox(height: TossSpacing.space2),
                TossSkeleton.text(width: 100),
                const SizedBox(height: TossSpacing.space2),
                TossSkeleton.text(width: 180),
              ],
            ),
            const SizedBox(height: TossSpacing.space4),

            const Text('List Item Skeleton:'),
            const SizedBox(height: TossSpacing.space3),
            TossSkeleton.listItem(),
            const SizedBox(height: TossSpacing.space3),
            TossSkeleton.listItem(),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Without Shimmer',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Static Skeleton (no animation):'),
            const SizedBox(height: TossSpacing.space3),
            const TossSkeleton(
              width: 200,
              height: 20,
              enableShimmer: false,
            ),
            const SizedBox(height: TossSpacing.space3),
            TossSkeleton.card(height: 80, enableShimmer: false),
            const SizedBox(height: TossSpacing.space3),
            TossSkeleton.circle(size: 48, enableShimmer: false),
          ],
        ),
      ),
    ),
  ],
);
