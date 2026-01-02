import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/value_objects/shift_params.dart';
import '../../providers/store_shift_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Show Operational Settings Dialog
void showOperationalSettingsDialog(BuildContext context, Map<String, dynamic> store) {
  TossBottomSheet.show<void>(
    context: context,
    title: 'Edit Operational Settings',
    content: _OperationalSettingsContent(store: store),
  );
}

/// Operational Settings Content Widget
class _OperationalSettingsContent extends ConsumerStatefulWidget {
  final Map<String, dynamic> store;

  const _OperationalSettingsContent({required this.store});

  @override
  ConsumerState<_OperationalSettingsContent> createState() => _OperationalSettingsContentState();
}

class _OperationalSettingsContentState extends ConsumerState<_OperationalSettingsContent> {
  late final TextEditingController _huddleTimeController;
  late final TextEditingController _paymentTimeController;
  late final TextEditingController _allowedDistanceController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _huddleTimeController = TextEditingController(
      text: (widget.store['huddle_time'] ?? 15).toString(),
    );
    _paymentTimeController = TextEditingController(
      text: (widget.store['payment_time'] ?? 30).toString(),
    );
    _allowedDistanceController = TextEditingController(
      text: (widget.store['allowed_distance'] ?? 100).toString(),
    );
  }

  @override
  void dispose() {
    _huddleTimeController.dispose();
    _paymentTimeController.dispose();
    _allowedDistanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Huddle Time
          TossTextField(
            label: 'Huddle Time',
            hintText: '15',
            controller: _huddleTimeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: TossSpacing.space3),
              child: Align(
                alignment: Alignment.centerRight,
                widthFactor: 1.0,
                child: Text(
                  'minutes',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Time allocated for team meetings',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
          const SizedBox(height: TossSpacing.space5),

          // Payment Time
          TossTextField(
            label: 'Payment Time',
            hintText: '30',
            controller: _paymentTimeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: TossSpacing.space3),
              child: Align(
                alignment: Alignment.centerRight,
                widthFactor: 1.0,
                child: Text(
                  'minutes',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Time allocated for payment processing',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
          const SizedBox(height: TossSpacing.space5),

          // Check-in Distance
          TossTextField(
            label: 'Check-in Distance',
            hintText: '100',
            controller: _allowedDistanceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: TossSpacing.space3),
              child: Align(
                alignment: Alignment.centerRight,
                widthFactor: 1.0,
                child: Text(
                  'meters',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Maximum distance from store for check-in',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
          const SizedBox(height: TossSpacing.space6),

          // Save Button
          TossButton.primary(
            text: 'Save Changes',
            onPressed: _isSubmitting ? null : _handleSave,
            fullWidth: true,
            leadingIcon: _isSubmitting
                ? TossLoadingView.inline(size: 20, color: TossColors.white)
                : null,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    setState(() => _isSubmitting = true);

    try {
      final useCase = ref.read(updateOperationalSettingsUseCaseProvider);
      await useCase(
        UpdateOperationalSettingsParams(
          storeId: widget.store['store_id'] as String,
          huddleTime: int.tryParse(_huddleTimeController.text),
          paymentTime: int.tryParse(_paymentTimeController.text),
          allowedDistance: int.tryParse(_allowedDistanceController.text),
        ),
      );

      if (mounted) {
        // Refresh store details
        ref.invalidate(storeDetailsProvider);

        Navigator.pop(context);
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Settings Updated',
            message: 'Operational settings updated successfully',
            primaryButtonText: 'OK',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Update Failed',
            message: 'Failed to update settings: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }
}
