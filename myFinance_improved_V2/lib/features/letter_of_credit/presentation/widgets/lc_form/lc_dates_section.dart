import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Important Dates section for LC form
class LCDatesSection extends StatelessWidget {
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final DateTime? latestShipmentDate;
  final TextEditingController expiryPlaceController;
  final TextEditingController presentationDaysController;
  final String? expiryError;
  final ValueChanged<DateTime?> onIssueDateChanged;
  final ValueChanged<DateTime?> onExpiryDateChanged;
  final ValueChanged<DateTime?> onLatestShipmentDateChanged;

  const LCDatesSection({
    super.key,
    required this.issueDate,
    required this.expiryDate,
    required this.latestShipmentDate,
    required this.expiryPlaceController,
    required this.presentationDaysController,
    this.expiryError,
    required this.onIssueDateChanged,
    required this.onExpiryDateChanged,
    required this.onLatestShipmentDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDatePicker(
          context,
          'Issue Date',
          issueDate,
          onIssueDateChanged,
        ),
        const SizedBox(height: TossSpacing.space3),
        _buildDatePicker(
          context,
          'Expiry Date *',
          expiryDate,
          onExpiryDateChanged,
          isRequired: true,
          error: expiryError,
        ),
        const SizedBox(height: TossSpacing.space3),
        TossTextField.filled(
          inlineLabel: 'Expiry Place',
          controller: expiryPlaceController,
          hintText: '',
        ),
        const SizedBox(height: TossSpacing.space3),
        _buildDatePicker(
          context,
          'Latest Shipment Date',
          latestShipmentDate,
          onLatestShipmentDateChanged,
        ),
        const SizedBox(height: TossSpacing.space3),
        TossTextField.filled(
          inlineLabel: 'Presentation Period (Days)',
          controller: presentationDaysController,
          hintText: '',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? value,
    ValueChanged<DateTime?> onChanged, {
    bool isRequired = false,
    String? error,
  }) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: error,
          filled: true,
          fillColor: TossColors.gray50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: BorderSide(color: TossColors.gray300),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value != null ? dateFormat.format(value) : 'Select date',
              style: TextStyle(
                color: value != null ? TossColors.gray800 : TossColors.gray500,
              ),
            ),
            Icon(Icons.calendar_today, size: TossSpacing.iconMD, color: TossColors.gray400),
          ],
        ),
      ),
    );
  }
}
