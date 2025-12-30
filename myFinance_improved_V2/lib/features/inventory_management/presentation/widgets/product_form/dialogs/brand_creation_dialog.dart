import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../di/inventory_providers.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../domain/entities/inventory_metadata.dart';
import '../../../providers/inventory_providers.dart';

/// Dialog for creating a new brand
class BrandCreationDialog extends ConsumerStatefulWidget {
  final void Function(Brand) onBrandCreated;

  const BrandCreationDialog({
    super.key,
    required this.onBrandCreated,
  });

  @override
  ConsumerState<BrandCreationDialog> createState() =>
      _BrandCreationDialogState();
}

class _BrandCreationDialogState extends ConsumerState<BrandCreationDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _isCreating = false;
  bool _isNameEmpty = true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    final isEmpty = _nameController.text.trim().isEmpty;
    if (isEmpty != _isNameEmpty) {
      setState(() {
        _isNameEmpty = isEmpty;
      });
    }
  }

  Future<void> _createBrand() async {
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();

    setState(() {
      _isCreating = true;
    });

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) {
        if (!mounted) return;
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Validation Error',
            message: 'Company not selected',
            primaryButtonText: 'OK',
          ),
        );
        setState(() {
          _isCreating = false;
        });
        return;
      }

      final repository = ref.read(inventoryRepositoryProvider);
      final brand = await repository.createBrand(
        companyId: companyId,
        brandName: name,
        brandCode: code.isEmpty ? null : code,
      );

      if (brand != null) {
        if (!mounted) return;

        // Refresh metadata
        ref.read(inventoryMetadataNotifierProvider.notifier).refresh();

        // Notify parent
        widget.onBrandCreated(brand);

        // Close dialog
        context.pop();

        // Show success message
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Brand Created',
            message: 'Brand "$name" created',
            primaryButtonText: 'OK',
          ),
        );
      } else {
        if (!mounted) return;
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Creation Failed',
            message: 'Failed to create brand',
            primaryButtonText: 'OK',
          ),
        );
        setState(() {
          _isCreating = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Error',
          message: 'Error: $e',
          primaryButtonText: 'OK',
        ),
      );
      setState(() {
        _isCreating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      title: Text(
        'Add Brand',
        style: TossTextStyles.h3.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Name Field
            Text(
              'Brand name *',
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter brand name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            // Brand Code Field
            Text(
              'Brand code (optional)',
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: 'Enter brand code or leave empty for auto...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _isCreating ? null : () => context.pop(),
                child: Text(
                  'Cancel',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed:
                    (_isCreating || _isNameEmpty) ? null : _createBrand,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_isCreating || _isNameEmpty)
                      ? TossColors.gray200
                      : TossColors.primary,
                  foregroundColor: (_isCreating || _isNameEmpty)
                      ? TossColors.gray900
                      : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                ),
                child: _isCreating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            TossColors.gray600,
                          ),
                        ),
                      )
                    : const Text('Create'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
