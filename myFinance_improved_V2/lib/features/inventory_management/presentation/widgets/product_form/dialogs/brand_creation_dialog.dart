import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../di/inventory_providers.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/inventory_metadata.dart';
import '../../../providers/inventory_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
          fontWeight: TossFontWeight.bold,
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
            TossTextField(
              label: 'Brand name',
              controller: _nameController,
              hintText: 'Enter brand name',
              autofocus: true,
              isRequired: true,
            ),
            const SizedBox(height: TossSpacing.space4),
            // Brand Code Field
            TossTextField(
              label: 'Brand code (optional)',
              controller: _codeController,
              hintText: 'Enter brand code or leave empty for auto...',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: TossButton.textButton(
                text: 'Cancel',
                onPressed: _isCreating ? null : () => context.pop(),
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: TossButton.primary(
                text: 'Create',
                onPressed:
                    (_isCreating || _isNameEmpty) ? null : _createBrand,
                isLoading: _isCreating,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
