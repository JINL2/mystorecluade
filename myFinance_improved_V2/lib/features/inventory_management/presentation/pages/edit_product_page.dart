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
import '../../domain/entities/product.dart';
import '../adapters/xfile_image_adapter.dart';
import '../providers/inventory_providers.dart';
import '../widgets/product_form/classification_section.dart';
import '../widgets/product_form/dialogs/brand_creation_dialog.dart';
import '../widgets/product_form/dialogs/category_creation_dialog.dart';
import '../widgets/product_form/inventory_section.dart';
import '../widgets/product_form/pricing_section.dart';
import '../widgets/product_form/product_image_picker.dart';
import '../widgets/product_form/product_info_section.dart';
import '../widgets/product_form/product_status_section.dart';

/// Edit Product Page - Edit existing product
class EditProductPage extends ConsumerStatefulWidget {
  final String productId;

  const EditProductPage({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _productNumberController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _onHandController = TextEditingController();
  final _weightController = TextEditingController();

  // Form state
  final List<XFile> _selectedImages = [];
  List<String> _existingImageUrls = [];
  Category? _selectedCategory;
  Brand? _selectedBrand;
  String? _selectedUnit;
  bool _isSaving = false;
  bool _isActive = true;

  Product? _product;

  // Original values for change detection
  String _originalName = '';
  String _originalSku = '';
  String _originalBarcode = '';
  String _originalSalePrice = '';
  String _originalCostPrice = '';
  String _originalDescription = '';
  String _originalOnHand = '';
  String _originalWeight = '';
  String? _originalUnit;
  bool _originalIsActive = true;
  String? _originalCategoryId;
  String? _originalBrandId;
  List<String> _originalImageUrls = [];

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() {
    final productsState = ref.read(inventoryPageProvider);
    _product = productsState.products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => throw Exception('Product not found'),
    );

    // Pre-populate form fields
    _nameController.text = _product!.name;
    _productNumberController.text = _product!.sku;
    _barcodeController.text = _product!.barcode ?? '';
    _salePriceController.text = _product!.salePrice.toStringAsFixed(0);
    _costPriceController.text = _product!.costPrice.toStringAsFixed(0);
    _descriptionController.text = _product!.description ?? '';
    _onHandController.text = _product!.onHand.toString();
    _weightController.text = (_product!.weight ?? 0).toString();
    _selectedUnit = _product!.unit;
    _isActive = _product!.isActive;
    _existingImageUrls = List.from(_product!.images);

    // Store original values for change detection
    _originalName = _product!.name;
    _originalSku = _product!.sku;
    _originalBarcode = _product!.barcode ?? '';
    _originalSalePrice = _product!.salePrice.toStringAsFixed(0);
    _originalCostPrice = _product!.costPrice.toStringAsFixed(0);
    _originalDescription = _product!.description ?? '';
    _originalOnHand = _product!.onHand.toString();
    _originalWeight = (_product!.weight ?? 0).toString();
    _originalUnit = _product!.unit;
    _originalIsActive = _product!.isActive;
    _originalCategoryId = _product!.categoryId;
    _originalBrandId = _product!.brandId;
    _originalImageUrls = List.from(_product!.images);

    // Load metadata to find category and brand
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final metadataState = ref.read(inventoryMetadataProvider);
      if (metadataState.metadata != null) {
        setState(() {
          _selectedCategory = metadataState.metadata!.categories.firstWhere(
            (c) => c.id == _product!.categoryId,
            orElse: () => metadataState.metadata!.categories.first,
          );
          _selectedBrand = metadataState.metadata!.brands.firstWhere(
            (b) => b.id == _product!.brandId,
            orElse: () => metadataState.metadata!.brands.first,
          );
        });
      }
    });
  }

  /// Check if any field has been modified from original values
  bool get _hasChanges {
    // Text field changes
    if (_nameController.text != _originalName) return true;
    if (_productNumberController.text != _originalSku) return true;
    if (_barcodeController.text != _originalBarcode) return true;
    if (_salePriceController.text != _originalSalePrice) return true;
    if (_costPriceController.text != _originalCostPrice) return true;
    if (_descriptionController.text != _originalDescription) return true;
    if (_onHandController.text != _originalOnHand) return true;
    if (_weightController.text != _originalWeight) return true;

    // Selection changes
    if (_selectedUnit != _originalUnit) return true;
    if (_isActive != _originalIsActive) return true;
    if (_selectedCategory?.id != _originalCategoryId) return true;
    if (_selectedBrand?.id != _originalBrandId) return true;

    // Image changes
    if (_selectedImages.isNotEmpty) return true;
    if (!_listEquals(_existingImageUrls, _originalImageUrls)) return true;

    return false;
  }

  /// Helper to compare two string lists
  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _productNumberController.dispose();
    _barcodeController.dispose();
    _salePriceController.dispose();
    _costPriceController.dispose();
    _descriptionController.dispose();
    _onHandController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _removeNewImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
      final repository = ref.read(inventoryRepositoryProvider);
      final salePrice = double.tryParse(_salePriceController.text) ?? 0.0;
      final costPrice = double.tryParse(_costPriceController.text) ?? 0.0;
      final productName = _nameController.text.trim();
      final sku = _productNumberController.text.trim();

      // Step 1: Validate with inventory_check_edit RPC
      final checkResult = await repository.checkEditProduct(
        productId: widget.productId,
        companyId: companyId,
        sku: sku.isNotEmpty ? sku : null,
        productName: productName.isNotEmpty ? productName : null,
      );

      if (!checkResult.success) {
        if (mounted) {
          String errorTitle = 'Validation Error';
          String errorMessage = checkResult.errorMessage ?? 'Validation failed';

          // Handle specific error codes
          switch (checkResult.errorCode) {
            case 'PRODUCT_NOT_FOUND':
              errorTitle = 'Product Not Found';
              errorMessage =
                  'This product no longer exists or you do not have access.';
              break;
            case 'PRODUCT_NAME_DUPLICATE':
              errorTitle = 'Duplicate Name';
              errorMessage = 'A product with this name already exists.';
              break;
            case 'SKU_DUPLICATE':
              errorTitle = 'Duplicate SKU';
              errorMessage = 'A product with this SKU already exists.';
              break;
          }

          await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => TossDialog.error(
              title: errorTitle,
              message: errorMessage,
              primaryButtonText: 'OK',
            ),
          );
        }
        return;
      }

      // Step 2: Upload new images to Supabase Storage (if any)
      List<String> newImageUrls = [];
      if (_selectedImages.isNotEmpty) {
        // Convert XFile to ImageFile using adapter for Clean Architecture compliance
        final imageFiles = XFileImageAdapter.fromXFiles(_selectedImages);
        newImageUrls = await repository.uploadProductImages(
          companyId: companyId,
          images: imageFiles,
        );
      }

      // Step 3: Combine existing URLs with newly uploaded URLs
      final allImageUrls = [..._existingImageUrls, ...newImageUrls];

      // Parse quantity - only send if changed from original
      final parsedOnHand = int.tryParse(_onHandController.text);
      final originalOnHand = _product?.onHand;
      // Only send onHand if quantity has changed
      final onHand = (parsedOnHand != null && parsedOnHand != originalOnHand)
          ? parsedOnHand
          : null;

      // Step 4: Proceed with actual update (inventory_edit_product_v4)
      final product = await repository.updateProduct(
        productId: widget.productId,
        companyId: companyId,
        storeId: storeId,
        createdBy: userId,
        name: productName,
        sku: sku,
        categoryId: _selectedCategory?.id,
        brandId: _selectedBrand?.id,
        unit: _selectedUnit,
        costPrice: costPrice,
        salePrice: salePrice,
        onHand: onHand,
        imageUrls: allImageUrls.isNotEmpty ? allImageUrls : null,
      );

      if (product != null && mounted) {
        // Refresh the inventory list and wait for completion
        await ref.read(inventoryPageProvider.notifier).refresh();

        if (!mounted) return;
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => TossDialog.success(
            title: 'Product Updated',
            message: 'Product updated successfully',
            primaryButtonText: 'OK',
          ),
        );

        // Navigate directly to inventory page (skip product detail)
        if (mounted) {
          context.go('/inventoryManagement');
        }
      } else if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Update Failed',
            message: 'Failed to update product',
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

  void _showCategorySelector(InventoryMetadata metadata) {
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
              'Product category',
              style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            // Add category button
            ListTile(
              leading: const Icon(Icons.add, color: TossColors.primary),
              title: Text(
                'Add category',
                style: TossTextStyles.bodyLarge.copyWith(
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
        onCategoryCreated: (Category category) {
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
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product brand',
              style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            // Add brand button
            ListTile(
              leading: const Icon(Icons.add, color: TossColors.primary),
              title: Text(
                'Add brand',
                style: TossTextStyles.bodyLarge.copyWith(
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
                    leading: const Icon(Icons.business_outlined,
                        color: TossColors.gray400),
                    title: Text(brand.name),
                    subtitle: Text('${brand.productCount ?? 0} products'),
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
    final productsState = ref.watch(inventoryPageProvider);
    final currencySymbol = productsState.currency?.symbol ?? '';

    if (_product == null) {
      return const TossScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit product',
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
              onPressed: _hasChanges ? _saveProduct : null,
              child: Text(
                'Save',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: _hasChanges ? TossColors.primary : TossColors.gray400,
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
              // Product Status Toggle
              ProductStatusSection(
                isActive: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Image Picker Section
              ProductImagePicker(
                selectedImages: _selectedImages,
                existingImageUrls: _existingImageUrls,
                onImageSourceSelected: (source) async {
                  List<XFile> images;
                  if (source == ImageSourceOption.gallery) {
                    images = await ProductImagePicker.pickFromGalleryWithValidation(context);
                  } else {
                    images = await ProductImagePicker.takePhotoWithValidation(context);
                  }
                  if (images.isNotEmpty && mounted) {
                    setState(() {
                      _selectedImages.addAll(images);
                    });
                  }
                },
                onRemoveNewImage: _removeNewImage,
                onRemoveExistingImage: _removeExistingImage,
              ),
              const SizedBox(height: 24),

              // Product Information Section
              ProductInfoSection(
                nameController: _nameController,
                productNumberController: _productNumberController,
                barcodeController: _barcodeController,
                descriptionController: _descriptionController,
                showDescription: true,
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
                currencySymbol: currencySymbol,
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
