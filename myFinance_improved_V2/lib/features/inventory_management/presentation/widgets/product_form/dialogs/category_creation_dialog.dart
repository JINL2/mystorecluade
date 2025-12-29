import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../di/inventory_providers.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../domain/entities/inventory_metadata.dart';
import '../../../providers/inventory_providers.dart';

/// Dialog for creating a new category
class CategoryCreationDialog extends ConsumerStatefulWidget {
  final void Function(Category) onCategoryCreated;

  const CategoryCreationDialog({
    super.key,
    required this.onCategoryCreated,
  });

  @override
  ConsumerState<CategoryCreationDialog> createState() =>
      _CategoryCreationDialogState();
}

class _CategoryCreationDialogState
    extends ConsumerState<CategoryCreationDialog> {
  final TextEditingController _nameController = TextEditingController();
  Category? _selectedParentCategory;
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

  Future<void> _createCategory() async {
    if (_nameController.text.trim().isEmpty) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Validation Error',
          message: 'Category name is required',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) {
        throw Exception('Company not selected');
      }

      final repository = ref.read(inventoryRepositoryProvider);
      final category = await repository.createCategory(
        companyId: companyId,
        categoryName: _nameController.text.trim(),
        parentCategoryId: _selectedParentCategory?.id,
      );

      if (category != null) {
        if (!mounted) return;

        // Refresh metadata
        ref.read(inventoryMetadataNotifierProvider.notifier).refresh();

        // Call the callback
        widget.onCategoryCreated(category);

        context.pop();
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Category Created',
            message: 'Category "${_nameController.text.trim()}" created',
            primaryButtonText: 'OK',
          ),
        );
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
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  void _showParentCategorySelector(InventoryMetadata metadata) {
    if (metadata.categories.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parent Category',
              style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: metadata.categories.length,
                itemBuilder: (context, index) {
                  final category = metadata.categories[index];
                  return ListTile(
                    leading: const Icon(Icons.help_outline,
                        color: TossColors.gray400),
                    title: Text(category.name),
                    subtitle: Text('${category.productCount ?? 0} products'),
                    trailing: _selectedParentCategory?.id == category.id
                        ? const Icon(Icons.check, color: TossColors.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedParentCategory = category;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metadataState = ref.watch(inventoryMetadataNotifierProvider);
    final metadata = metadataState.metadata;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        'Add Category',
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
            // Category Name Field
            Text(
              'Category Name *',
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter category name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              autofocus: true,
            ),

            const SizedBox(height: 16),

            // Parent Category Selection
            Text(
              'Parent Category (Optional)',
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _isCreating || metadata == null
                  ? null
                  : () => _showParentCategorySelector(metadata),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: TossColors.gray300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedParentCategory?.name ??
                            'Select parent category (optional)',
                        style: TossTextStyles.body.copyWith(
                          color: _selectedParentCategory != null
                              ? TossColors.gray900
                              : TossColors.gray400,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: TossColors.gray400,
                      size: 20,
                    ),
                  ],
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
                    (_isCreating || _isNameEmpty) ? null : _createCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_isCreating || _isNameEmpty)
                      ? TossColors.gray200
                      : TossColors.primary,
                  foregroundColor: (_isCreating || _isNameEmpty)
                      ? TossColors.gray900
                      : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
