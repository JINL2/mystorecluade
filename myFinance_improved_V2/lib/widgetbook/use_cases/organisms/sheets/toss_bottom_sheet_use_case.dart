import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossBottomSheetComponent = WidgetbookComponent(
  name: 'TossBottomSheet',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            TossBottomSheet.show(
              context: context,
              title: context.knobs.string(
                label: 'Title',
                initialValue: 'Select Option',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'This is the bottom sheet content.',
                    style: TossTextStyles.body,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You can put any widget here.',
                    style: TossTextStyles.caption,
                  ),
                ],
              ),
            );
          },
          child: const Text('Show Bottom Sheet'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Actions',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            TossBottomSheet.show(
              context: context,
              title: 'Actions',
              content: const Text('Choose an action below:'),
              actions: [
                TossActionItem(
                  title: 'Edit',
                  icon: Icons.edit,
                  onTap: () {},
                ),
                TossActionItem(
                  title: 'Share',
                  icon: Icons.share,
                  onTap: () {},
                ),
                TossActionItem(
                  title: 'Delete',
                  icon: Icons.delete,
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
    WidgetbookUseCase(
      name: 'Fullscreen',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            TossBottomSheet.showFullscreen(
              context: context,
              builder: (_) => Container(
                decoration: const BoxDecoration(
                  color: TossColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: TossColors.gray300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Fullscreen Bottom Sheet', style: TossTextStyles.h3),
                    const Spacer(),
                    Text('Content goes here', style: TossTextStyles.body),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
          child: const Text('Show Fullscreen'),
        ),
      ),
    ),
  ],
);
