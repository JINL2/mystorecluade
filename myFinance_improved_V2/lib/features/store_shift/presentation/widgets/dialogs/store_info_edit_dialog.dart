import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../providers/di_providers.dart';
import '../../providers/store_shift_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Show Store Info Edit Dialog
void showStoreInfoEditDialog(BuildContext context, Map<String, dynamic> store) {
  TossBottomSheet.show<void>(
    context: context,
    title: 'Edit Store Information',
    content: _StoreInfoEditContent(store: store),
  );
}

/// Store Info Edit Content Widget
class _StoreInfoEditContent extends ConsumerStatefulWidget {
  final Map<String, dynamic> store;

  const _StoreInfoEditContent({required this.store});

  @override
  ConsumerState<_StoreInfoEditContent> createState() =>
      _StoreInfoEditContentState();
}

class _StoreInfoEditContentState extends ConsumerState<_StoreInfoEditContent> {
  late final TextEditingController _storeNameController;
  late final TextEditingController _storeEmailController;
  late final TextEditingController _storePhoneController;
  late final TextEditingController _storeAddressController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _storeNameController = TextEditingController(
      text: widget.store['store_name']?.toString() ?? '',
    );
    _storeEmailController = TextEditingController(
      text: widget.store['store_email']?.toString() ?? '',
    );
    _storePhoneController = TextEditingController(
      text: widget.store['store_phone']?.toString() ?? '',
    );
    _storeAddressController = TextEditingController(
      text: widget.store['store_address']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeEmailController.dispose();
    _storePhoneController.dispose();
    _storeAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Store Name
          TossTextField(
            label: 'Store Name',
            hintText: 'Enter store name',
            controller: _storeNameController,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: TossSpacing.space4),

          // Store Email
          TossTextField(
            label: 'Email',
            hintText: 'store@example.com',
            controller: _storeEmailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: TossSpacing.space4),

          // Store Phone
          TossTextField(
            label: 'Phone',
            hintText: '+1 234 567 8900',
            controller: _storePhoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: TossSpacing.space4),

          // Store Address
          TossTextField(
            label: 'Address',
            hintText: 'Enter store address',
            controller: _storeAddressController,
            keyboardType: TextInputType.streetAddress,
            maxLines: 2,
          ),
          const SizedBox(height: TossSpacing.space6),

          // Save Button
          TossButton.primary(
            text: 'Save Changes',
            onPressed: _isSubmitting ? null : _handleSave,
            fullWidth: true,
            leadingIcon: _isSubmitting
                ? const TossLoadingView.inline(size: 20, color: TossColors.white)
                : null,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    final storeName = _storeNameController.text.trim();
    if (storeName.isEmpty) {
      TossToast.error(context, 'Store name is required');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(storeShiftRepositoryProvider);
      await repository.updateStoreInfo(
        storeId: widget.store['store_id'] as String,
        storeName: storeName,
        storeEmail: _storeEmailController.text.trim().isEmpty
            ? null
            : _storeEmailController.text.trim(),
        storePhone: _storePhoneController.text.trim().isEmpty
            ? null
            : _storePhoneController.text.trim(),
        storeAddress: _storeAddressController.text.trim().isEmpty
            ? null
            : _storeAddressController.text.trim(),
      );

      if (mounted) {
        // Refresh store details
        ref.invalidate(storeDetailsProvider);

        Navigator.pop(context);
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Information Updated',
            message: 'Store information updated successfully',
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
            message: 'Failed to update store information: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }
}
