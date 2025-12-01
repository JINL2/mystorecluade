import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../domain/entities/store_shift.dart';
import '../../providers/store_shift_providers.dart';

/// Show Delete Confirmation Dialog
void showDeleteShiftDialog(
  BuildContext context,
  WidgetRef ref,
  StoreShift shift,
) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Shift'),
      content: Text('Are you sure you want to delete "${shift.shiftName}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await ref.read(deleteShiftProvider)(shift.shiftId);
              if (context.mounted) {
                Navigator.pop(context);
                await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => TossDialog.success(
                    title: 'Shift Deleted',
                    message: 'Shift deleted successfully',
                    primaryButtonText: 'OK',
                  ),
                );
              }
              ref.invalidate(storeShiftsProvider);
            } catch (e) {
              if (context.mounted) {
                Navigator.pop(context);
                await showDialog<bool>(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => TossDialog.error(
                    title: 'Delete Failed',
                    message: 'Failed to delete: $e',
                    primaryButtonText: 'OK',
                  ),
                );
              }
            }
          },
          style: TextButton.styleFrom(foregroundColor: TossColors.error),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
