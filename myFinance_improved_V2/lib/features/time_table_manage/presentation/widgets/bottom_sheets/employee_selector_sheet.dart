import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_spacing.dart';

/// Employee Selector Sheet
///
/// Sheet for selecting employees for shift assignment (placeholder)
class EmployeeSelectorSheet extends StatelessWidget {
  const EmployeeSelectorSheet({super.key});

  static Future<List<String>?> show(BuildContext context) {
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EmployeeSelectorSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space6),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: const Center(
        child: Text('Employee Selector - To be implemented'),
      ),
    );
  }
}
