import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossBottomSheetComponent = WidgetbookComponent(
  name: 'TossBottomSheet',
  useCases: [
    // Basic Bottom Sheet
    WidgetbookUseCase(
      name: 'Basic',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              TossBottomSheet.show(
                context: context,
                title: 'Basic Bottom Sheet',
                content: Padding(
                  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  child: Text(
                    'This is a basic bottom sheet with title and content.',
                    style: TossTextStyles.body,
                  ),
                ),
              );
            },
            child: const Text('Show Basic Bottom Sheet'),
          ),
        ),
      ),
    ),

    // With Actions
    WidgetbookUseCase(
      name: 'With Actions',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              TossBottomSheet.show(
                context: context,
                title: 'Actions Bottom Sheet',
                content: Text(
                  'Select an action below:',
                  style: TossTextStyles.body,
                ),
                actions: [
                  TossActionItem(
                    title: 'Edit',
                    icon: Icons.edit_outlined,
                    onTap: () {},
                  ),
                  TossActionItem(
                    title: 'Share',
                    icon: Icons.share_outlined,
                    onTap: () {},
                  ),
                  TossActionItem(
                    title: 'Delete',
                    icon: Icons.delete_outline,
                    onTap: () {},
                    isDestructive: true,
                  ),
                ],
              );
            },
            child: const Text('Show With Actions'),
          ),
        ),
      ),
    ),

    // Custom Builder
    WidgetbookUseCase(
      name: 'Custom Builder',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              TossBottomSheet.showWithBuilder(
                context: context,
                heightFactor: 0.6,
                builder: (context) => Container(
                  decoration: const BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(TossBorderRadius.xxl),
                      topRight: Radius.circular(TossBorderRadius.xxl),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: TossSpacing.space3),
                      Container(
                        width: TossSpacing.space9,
                        height: 4,
                        decoration: BoxDecoration(
                          color: TossColors.gray300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space5),
                      Text('Custom Builder Content', style: TossTextStyles.h3),
                      const SizedBox(height: TossSpacing.space4),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) => ListTile(
                            leading: const Icon(Icons.star),
                            title: Text('Item ${index + 1}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: const Text('Show Custom Builder'),
          ),
        ),
      ),
    ),

    // Fullscreen
    WidgetbookUseCase(
      name: 'Fullscreen',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              TossBottomSheet.showFullscreen(
                context: context,
                builder: (context) => Container(
                  decoration: const BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(TossBorderRadius.xxl),
                      topRight: Radius.circular(TossBorderRadius.xxl),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: TossSpacing.space3),
                      Container(
                        width: TossSpacing.space9,
                        height: 4,
                        decoration: BoxDecoration(
                          color: TossColors.gray300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space5),
                      Text('Fullscreen (95% height)', style: TossTextStyles.h3),
                      const Spacer(),
                      Text('Swipe down to close', style: TossTextStyles.caption),
                      const SizedBox(height: TossSpacing.space10),
                    ],
                  ),
                ),
              );
            },
            child: const Text('Show Fullscreen'),
          ),
        ),
      ),
    ),

    // Compact
    WidgetbookUseCase(
      name: 'Compact',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              TossBottomSheet.showCompact(
                context: context,
                builder: (context) => Container(
                  decoration: const BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(TossBorderRadius.xxl),
                      topRight: Radius.circular(TossBorderRadius.xxl),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: TossSpacing.space3),
                      Container(
                        width: TossSpacing.space9,
                        height: 4,
                        decoration: BoxDecoration(
                          color: TossColors.gray300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space5),
                      Text('Compact (60% height)', style: TossTextStyles.h3),
                      const SizedBox(height: TossSpacing.space4),
                      Padding(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        child: Text(
                          'This is a compact bottom sheet useful for quick actions or confirmations.',
                          textAlign: TextAlign.center,
                          style: TossTextStyles.body,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: const Text('Show Compact'),
          ),
        ),
      ),
    ),
  ],
);
