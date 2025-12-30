import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// Overlays: Sheets
import 'package:myfinance_improved/shared/widgets/overlays/sheets/index.dart';

// Overlays: Pickers
import 'package:myfinance_improved/shared/widgets/overlays/pickers/index.dart';

// Overlays: Menus
import 'package:myfinance_improved/shared/widgets/overlays/menus/index.dart';

// Buttons for demos
import 'package:myfinance_improved/shared/widgets/core/buttons/index.dart';

import '../component_showcase.dart';

/// Overlays Widgets Page - Sheets, Pickers, Menus
class OverlaysWidgetsPage extends StatefulWidget {
  const OverlaysWidgetsPage({super.key});

  @override
  State<OverlaysWidgetsPage> createState() => _OverlaysWidgetsPageState();
}

class _OverlaysWidgetsPageState extends State<OverlaysWidgetsPage> {
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      children: [
        // Section: Sheets
        _buildSectionHeader('Sheets', Icons.vertical_split),

        // TossBottomSheet
        ComponentShowcase(
          name: 'TossBottomSheet',
          filename: 'toss_bottom_sheet.dart',
          child: TossPrimaryButton(
            text: 'Show Bottom Sheet',
            onPressed: () {
              TossBottomSheet.show(
                context: context,
                title: 'Select Action',
                content: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Choose an option'),
                ),
                actions: [
                  TossActionItem(title: 'Option 1', onTap: () => Navigator.pop(context)),
                  TossActionItem(title: 'Option 2', onTap: () => Navigator.pop(context)),
                ],
              );
            },
          ),
        ),

        // TossSelectionBottomSheet
        ComponentShowcase(
          name: 'TossSelectionBottomSheet',
          filename: 'toss_selection_bottom_sheet.dart',
          child: TossSecondaryButton(
            text: 'Show Selection Sheet',
            onPressed: () {
              TossSelectionBottomSheet.show(
                context: context,
                title: 'Select Item',
                items: [
                  const TossSelectionItem(id: '1', title: 'Item 1', icon: Icons.star),
                  const TossSelectionItem(id: '2', title: 'Item 2', icon: Icons.favorite),
                  const TossSelectionItem(id: '3', title: 'Item 3', icon: Icons.bookmark),
                ],
                onItemSelected: (item) => Navigator.pop(context),
              );
            },
          ),
        ),

        // Section: Pickers
        _buildSectionHeader('Pickers', Icons.access_time),

        // TossTimePicker
        ComponentShowcase(
          name: 'TossTimePicker',
          filename: 'toss_time_picker.dart',
          child: TossTimePicker(
            time: _selectedTime,
            placeholder: 'Select time',
            onTimeChanged: (v) => setState(() => _selectedTime = v),
          ),
        ),

        // TossDatePicker
        ComponentShowcase(
          name: 'TossDatePicker',
          filename: 'toss_date_picker.dart',
          child: TossDatePicker(
            date: _selectedDate,
            placeholder: 'Select Date',
            onDateChanged: (date) => setState(() => _selectedDate = date),
          ),
        ),

        // Section: Menus
        _buildSectionHeader('Menus', Icons.more_vert),

        // SafePopupMenu
        ComponentShowcase(
          name: 'SafePopupMenuButton',
          filename: 'safe_popup_menu.dart',
          child: Align(
            alignment: Alignment.centerLeft,
            child: SafePopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: TossColors.gray700),
              onSelected: (value) {},
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 12),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: TossColors.error),
                      SizedBox(width: 12),
                      Text('Delete', style: TextStyle(color: TossColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space8),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: TossSpacing.space4, bottom: TossSpacing.space2),
      child: Row(
        children: [
          Icon(icon, size: 20, color: TossColors.primary),
          const SizedBox(width: TossSpacing.space2),
          Text(
            title,
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
