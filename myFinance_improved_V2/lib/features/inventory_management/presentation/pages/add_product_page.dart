import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/inventory_metadata.dart';
import '../providers/inventory_providers.dart';

/// Add Product Page - Full implementation with save functionality
class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _productNumberController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _onHandController = TextEditingController();
  final _weightController = TextEditingController();

  // Form state
  final List<XFile> _selectedImages = [];
  Category? _selectedCategory;
  Brand? _selectedBrand;
  String? _selectedUnit;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _productNumberController.dispose();
    _barcodeController.dispose();
    _salePriceController.dispose();
    _costPriceController.dispose();
    _onHandController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Image Selection Failed',
            message: 'Failed to pick images: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get app state
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen as String?;
    final storeId = appState.storeChoosen as String?;

    if (companyId == null || storeId == null) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Validation Error',
          message: 'Company or store not selected',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Get repository
      final repository = ref.read(inventoryRepositoryProvider);

      // Parse prices
      final salePrice = double.tryParse(_salePriceController.text) ?? 0.0;
      final costPrice = double.tryParse(_costPriceController.text) ?? 0.0;

      // TODO: Upload images to storage and get URLs
      // For now, we'll pass empty list as imageUrls
      List<String> imageUrls = [];

      // Create product
      final product = await repository.createProduct(
        companyId: companyId,
        storeId: storeId,
        name: _nameController.text.trim(),
        sku: _productNumberController.text.trim().isEmpty
            ? _generateSKU()
            : _productNumberController.text.trim(),
        barcode: _barcodeController.text.trim().isEmpty
            ? null
            : _barcodeController.text.trim(),
        categoryId: _selectedCategory?.id,
        brandId: _selectedBrand?.id,
        unit: _selectedUnit,
        costPrice: costPrice,
        sellingPrice: salePrice,
        initialQuantity: 0,
        imageUrls: imageUrls,
      );

      if (product != null && mounted) {
        // Refresh the inventory list
        ref.read(inventoryPageProvider.notifier).refresh();

        // Show success message
        if (!context.mounted) return;
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Product Added',
            message: 'Product added successfully',
            primaryButtonText: 'OK',
          ),
        );

        // Navigate back
        if (mounted) {
          context.pop();
        }
      } else if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Creation Failed',
            message: 'Failed to create product',
            primaryButtonText: 'OK',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'Error: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _generateSKU() {
    // Generate SKU from product name
    final name = _nameController.text.trim();
    if (name.isEmpty) return 'PROD${DateTime.now().millisecondsSinceEpoch}';

    final prefix = name
        .split(' ')
        .take(3)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join('');
    return '$prefix${DateTime.now().millisecondsSinceEpoch % 10000}';
  }

  void _showCategorySelector(InventoryMetadata metadata) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product category',
              style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // Add category button
            ListTile(
              leading: const Icon(Icons.add, color: TossColors.primary),
              title: Text(
                'Add category',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text('Create a new category'),
              onTap: () async {
                Navigator.pop(context);
                await _showAddCategoryDialog();
              },
            ),
            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: metadata.categories.length,
                itemBuilder: (context, index) {
                  final category = metadata.categories[index];
                  return ListTile(
                    leading: const Icon(Icons.help_outline, color: TossColors.gray400),
                    title: Text(category.name),
                    subtitle: Text('${category.productCount ?? 0} products'),
                    trailing: _selectedCategory?.id == category.id
                        ? const Icon(Icons.check, color: TossColors.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
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

  Future<void> _showAddCategoryDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => _CategoryCreationDialog(
        onCategoryCreated: (category) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  void _showBrandSelector(InventoryMetadata metadata) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Brand',
              style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // Add brand button
            ListTile(
              leading: const Icon(Icons.add, color: TossColors.primary),
              title: Text(
                'Add brand',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text('Create a new brand'),
              onTap: () async {
                Navigator.pop(context);
                await _showAddBrandDialog();
              },
            ),
            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: metadata.brands.length,
                itemBuilder: (context, index) {
                  final brand = metadata.brands[index];
                  return ListTile(
                    title: Text(brand.name),
                    trailing: _selectedBrand?.id == brand.id
                        ? const Icon(Icons.check, color: TossColors.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedBrand = brand;
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

  Future<void> _showAddBrandDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => _BrandCreationDialog(
        onBrandCreated: (Brand brand) {
          setState(() {
            _selectedBrand = brand;
          });
        },
      ),
    );
  }

  Future<void> _showUnitSelector(InventoryMetadata metadata) async {
    final units = metadata.units.isNotEmpty
        ? metadata.units
        : ['piece', 'kg', 'g', 'liter', 'ml', 'box', 'pack'];

    final items = units.map((unit) =>
      TossSelectionItem.fromGeneric(
        id: unit,
        title: unit,
      ),
    ).toList();

    await TossSelectionBottomSheet.show<String>(
      context: context,
      title: 'Unit',
      items: items,
      selectedId: _selectedUnit,
      showSubtitle: false,
      onItemSelected: (item) {
        setState(() {
          _selectedUnit = item.id;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final metadataState = ref.watch(inventoryMetadataProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add product',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _saveProduct,
              child: Text(
                'Save',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Photo Section
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: double.infinity,
                  height: _selectedImages.isEmpty ? 120 : 180,
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: TossColors.gray300),
                  ),
                  child: _selectedImages.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: TossColors.gray400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Photo',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray500,
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(8),
                          itemCount: _selectedImages.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _selectedImages.length) {
                              return GestureDetector(
                                onTap: _pickImages,
                                child: Container(
                                  width: 140,
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: TossColors.gray200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: TossColors.gray500,
                                    size: 40,
                                  ),
                                ),
                              );
                            }

                            return Stack(
                              children: [
                                Container(
                                  width: 140,
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(File(_selectedImages[index].path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 12,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Product Information Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TossColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: TossColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Product Information',
                          style: TossTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Product name
                    Text(
                      'Product name *',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Product name is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter product name',
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: TossColors.gray300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: TossColors.gray300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: TossColors.primary, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: TossColors.error, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Product number
                    Text(
                      'Product number (Optional)',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _productNumberController,
                      decoration: InputDecoration(
                        hintText: 'Enter product number for inventory tracking',
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: TossColors.gray300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Barcode
                    Text(
                      'Barcode (Optional)',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _barcodeController,
                      decoration: InputDecoration(
                        hintText: 'Enter barcode',
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: TossColors.gray300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Classification Section
              metadataState.metadata != null
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: TossColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.folder_outlined, color: TossColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Classification',
                                style: TossTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Category', style: TossTextStyles.body),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedCategory?.name ?? 'Select product category',
                                  style: TossTextStyles.body.copyWith(
                                    color: _selectedCategory != null
                                        ? TossColors.gray900
                                        : TossColors.gray400,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.chevron_right, color: TossColors.gray400),
                              ],
                            ),
                            onTap: () => _showCategorySelector(metadataState.metadata!),
                          ),
                          const Divider(height: 1, color: TossColors.gray200),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Brand', style: TossTextStyles.body),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedBrand?.name ?? 'Choose brand',
                                  style: TossTextStyles.body.copyWith(
                                    color: _selectedBrand != null
                                        ? TossColors.gray900
                                        : TossColors.gray400,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.chevron_right, color: TossColors.gray400),
                              ],
                            ),
                            onTap: () => _showBrandSelector(metadataState.metadata!),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 16),

              // Pricing Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TossColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: TossColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Pricing',
                          style: TossTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Sale price (₩)',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _salePriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: TossColors.gray300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Cost of goods (₩)',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _costPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: TossColors.gray300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Inventory Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TossColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, color: TossColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Inventory',
                          style: TossTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'On-hand quantity',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _onHandController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: TossColors.gray300),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.info_outline, size: 20, color: TossColors.gray400),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Current stock quantity available'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Weight (g)',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: TossColors.gray300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Unit Selection
                    const Divider(height: 1, color: TossColors.gray200),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Unit',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedUnit ?? 'piece',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.chevron_right,
                            color: TossColors.gray400,
                            size: 20,
                          ),
                        ],
                      ),
                      onTap: () => _showUnitSelector(metadataState.metadata!),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}

// Category Creation Dialog Widget
class _CategoryCreationDialog extends ConsumerStatefulWidget {
  final void Function(Category) onCategoryCreated;

  const _CategoryCreationDialog({
    required this.onCategoryCreated,
  });

  @override
  ConsumerState<_CategoryCreationDialog> createState() => _CategoryCreationDialogState();
}

class _CategoryCreationDialogState extends ConsumerState<_CategoryCreationDialog> {
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

  @override
  Widget build(BuildContext context) {
    final metadataState = ref.watch(inventoryMetadataProvider);
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
              onTap: _isCreating ? null : () async {
                if (metadata == null || metadata.categories.isEmpty) return;

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
                                leading: const Icon(Icons.help_outline, color: TossColors.gray400),
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
              },
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
                        _selectedParentCategory?.name ?? 'Select parent category (optional)',
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
                onPressed: _isCreating ? null : () {
                  context.pop();
                },
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
                onPressed: (_isCreating || _isNameEmpty) ? null : () async {
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
                    final companyId = appState.companyChoosen as String?;

                    if (companyId == null) {
                      throw Exception('Company not selected');
                    }

                    final repository = ref.read(inventoryRepositoryProvider);
                    final category = await repository.createCategory(
                      companyId: companyId,
                      categoryName: _nameController.text.trim(),
                      parentCategoryId: _selectedParentCategory?.id,
                    );

                    if (category != null) {
                      if (!context.mounted) return;

                      // Refresh metadata
                      ref.read(inventoryMetadataProvider.notifier).refresh();

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
                    if (!context.mounted) return;
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
                },
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

// Brand Creation Dialog Widget
class _BrandCreationDialog extends ConsumerStatefulWidget {
  final void Function(Brand) onBrandCreated;

  const _BrandCreationDialog({
    required this.onBrandCreated,
  });

  @override
  ConsumerState<_BrandCreationDialog> createState() =>
      _BrandCreationDialogState();
}

class _BrandCreationDialogState extends ConsumerState<_BrandCreationDialog> {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(8),
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
                onPressed: _isCreating
                    ? null
                    : () {
                        context.pop();
                      },
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
                onPressed: (_isCreating || _isNameEmpty)
                    ? null
                    : () async {
                        final name = _nameController.text.trim();
                        final code = _codeController.text.trim();

                        setState(() {
                          _isCreating = true;
                        });

                        try {
                          final appState = ref.read(appStateProvider);
                          final companyId = appState.companyChoosen as String?;

                          if (companyId == null) {
                            if (!context.mounted) return;
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

                          final repository =
                              ref.read(inventoryRepositoryProvider);
                          final brand = await repository.createBrand(
                            companyId: companyId,
                            brandName: name,
                            brandCode: code.isEmpty ? null : code,
                          );

                          if (brand != null) {
                            if (!context.mounted) return;

                            // Refresh metadata
                            ref.read(inventoryMetadataProvider.notifier).refresh();

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
                            if (!context.mounted) return;
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
                          if (!context.mounted) return;
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
                      },
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
