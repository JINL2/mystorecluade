import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/inventory_providers.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../domain/entities/inventory_metadata.dart';
import '../providers/inventory_providers.dart';
import '../widgets/product_form/classification_section.dart';
import '../widgets/product_form/dialogs/brand_creation_dialog.dart';
import '../widgets/product_form/dialogs/category_creation_dialog.dart';
import '../widgets/product_form/inventory_section.dart';
import '../widgets/product_form/pricing_section.dart';
import '../widgets/product_form/product_image_picker.dart';
import '../widgets/product_form/product_info_section.dart';

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
    final images = await ProductImagePicker.pickImagesWithValidation(context);
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
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
    final userId = appState.user['user_id'] as String?;

    if (companyId == null || storeId == null || userId == null) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Validation Error',
          message: 'Company, store, or user not selected',
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
        createdBy: userId,
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
                    leading: const Icon(Icons.help_outline,
                        color: TossColors.gray400),
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
      builder: (BuildContext context) => CategoryCreationDialog(
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
      builder: (BuildContext context) => BrandCreationDialog(
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

    final items = units
        .map(
          (unit) => TossSelectionItem.fromGeneric(
            id: unit,
            title: unit,
          ),
        )
        .toList();

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
              // Image Picker Section
              ProductImagePicker(
                selectedImages: _selectedImages,
                existingImageUrls: const [],
                onPickImages: _pickImages,
                onRemoveNewImage: _removeImage,
              ),
              const SizedBox(height: 24),

              // Product Information Section
              ProductInfoSection(
                nameController: _nameController,
                productNumberController: _productNumberController,
                barcodeController: _barcodeController,
              ),
              const SizedBox(height: 16),

              // Classification Section
              if (metadataState.metadata != null)
                ClassificationSection(
                  selectedCategory: _selectedCategory,
                  selectedBrand: _selectedBrand,
                  onCategoryTap: () =>
                      _showCategorySelector(metadataState.metadata!),
                  onBrandTap: () =>
                      _showBrandSelector(metadataState.metadata!),
                ),
              const SizedBox(height: 16),

              // Pricing Section
              PricingSection(
                salePriceController: _salePriceController,
                costPriceController: _costPriceController,
                currencySymbol: '₩',
              ),
              const SizedBox(height: 16),

              // Inventory Section
              InventorySection(
                onHandController: _onHandController,
                weightController: _weightController,
                selectedUnit: _selectedUnit,
                onUnitTap: () {
                  if (metadataState.metadata != null) {
                    _showUnitSelector(metadataState.metadata!);
                  }
                },
              ),

              const SizedBox(height: 80), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
