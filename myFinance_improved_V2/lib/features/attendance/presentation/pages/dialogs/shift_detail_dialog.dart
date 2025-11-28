import 'package:flutter/material.dart';

import '../../../domain/entities/shift_card.dart';
import '../shift_detail_page.dart';

/// Static dialog utilities for showing shift details
class ShiftDetailDialog {
  /// Navigate to shift detail page with real ShiftCard data
  static void show(
    BuildContext context, {
    required ShiftCard shiftCard,
  }) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ShiftDetailPage(shift: shiftCard),
      ),
    );
  }
}
