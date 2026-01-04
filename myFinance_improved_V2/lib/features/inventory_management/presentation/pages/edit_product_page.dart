import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../di/inventory_providers.dart';
import '../../domain/entities/inventory_metadata.dart';
import '../../domain/entities/product.dart';
import '../../domain/value_objects/pagination_params.dart';
import '../../domain/value_objects/product_filter.dart';
import '../adapters/xfile_image_adapter.dart';
import '../providers/inventory_providers.dart';
import '../utils/store_utils.dart';
import '../widgets/product_form/product_form_widgets.dart';
import 'attribute_value_selector_page.dart';
import 'attributes_edit_page.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Edit Product Page - Redesigned to match Add Product Page layout
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
  // Form state
  final List<XFile> _selectedImages = [];
  List<String> _existingImageUrls = [];
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _productNameFocusNode = FocusNode();
  final FocusNode _salePriceFocusNode = FocusNode();
  final FocusNode _costPriceFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  bool _isProductNameFocused = false;
  bool _isSalePriceFocused = false;
  bool _isCostPriceFocused = false;
  String? _sku;
  String? _barcode;
  Category? _selectedCategory;
  Brand? _selectedBrand;
  String? _selectedLocation; // Store ID
  String? _selectedLocationName; // Store name for display
  String _unit = 'piece';
  bool _isSaving = false;
  bool _isActive = true;

  Product? _product;
  bool _isLoadingProduct = false;

  // Original values for change detection
  String _originalName = '';
  String _originalSku = '';
  String _originalBarcode = '';
  String _originalSalePrice = '';
  String _originalCostPrice = '';
  String _originalDescription = '';
  String _originalOnHand = '';
  String? _originalUnit;
  bool _originalIsActive = true;
  String? _originalCategoryId;
  String? _originalBrandId;
  List<String> _originalImageUrls = [];

  /// Check if any field has been modified from original values
  bool get _hasChanges {
    // Text field changes
    if (_productNameController.text != _originalName) return true;
    if (_sku != _originalSku) return true;
    if (_barcode != _originalBarcode) return true;
    if (_salePriceController.text.replaceAll(',', '') != _originalSalePrice) return true;
    if (_costPriceController.text.replaceAll(',', '') != _originalCostPrice) return true;
    if (_descriptionController.text != _originalDescription) return true;
    if (_quantityController.text != _originalOnHand) return true;

    // Selection changes
    if (_unit != _originalUnit) return true;
    if (_isActive != _originalIsActive) return true;
    if (_selectedCategory?.id != _originalCategoryId) return true;
    if (_selectedBrand?.id != _originalBrandId) return true;

    // Image changes
    if (_selectedImages.isNotEmpty) return true;
    if (!_listEquals(_existingImageUrls, _originalImageUrls)) return true;

    return false;
  }

  /// Check if required fields are filled for save button
  bool get _canSave {
    final hasProductName = _productNameController.text.trim().isNotEmpty;
    return hasProductName && _hasChanges && !_isSaving;
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
  void initState() {
    super.initState();
    _productNameFocusNode.addListener(_onProductNameFocusChange);
    _salePriceFocusNode.addListener(_onSalePriceFocusChange);
    _costPriceFocusNode.addListener(_onCostPriceFocusChange);
    _productNameController.addListener(_onRequiredFieldChanged);
    _loadProduct();
  }

  void _loadProduct() {
    final productsState = ref.read(inventoryPageNotifierProvider);
    try {
      _product = productsState.products.firstWhere(
        (p) => p.id == widget.productId,
      );
    } catch (e) {
      // Product not found in cache, load from API
      _loadProductFromApi();
      return;
    }

    if (_product == null) {
      _loadProductFromApi();
      return;
    }

    // Pre-populate form fields
    _productNameController.text = _product!.name;
    _sku = _product!.sku;
    _barcode = _product!.barcode;
    _salePriceController.text = _formatNumberWithCommas(_product!.salePrice.toStringAsFixed(0));
    _costPriceController.text = _formatNumberWithCommas(_product!.costPrice.toStringAsFixed(0));
    _descriptionController.text = _product!.description ?? '';
    _quantityController.text = _product!.onHand.toString();
    _unit = _product!.unit;
    _isActive = _product!.isActive;
    _existingImageUrls = List.from(_product!.images);

    // Set location from app state
    final appState = ref.read(appStateProvider);
    _selectedLocation = appState.storeChoosen;
    _selectedLocationName = appState.storeName;

    // Store original values for change detection
    _originalName = _product!.name;
    _originalSku = _product!.sku;
    _originalBarcode = _product!.barcode ?? '';
    _originalSalePrice = _product!.salePrice.toStringAsFixed(0);
    _originalCostPrice = _product!.costPrice.toStringAsFixed(0);
    _originalDescription = _product!.description ?? '';
    _originalOnHand = _product!.onHand.toString();
    _originalUnit = _product!.unit;
    _originalIsActive = _product!.isActive;
    _originalCategoryId = _product!.categoryId;
    _originalBrandId = _product!.brandId;
    _originalImageUrls = List.from(_product!.images);

    // Load metadata to find category and brand
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final metadataState = ref.read(inventoryMetadataNotifierProvider);
      if (metadataState.metadata != null) {
        setState(() {
          // Find category
          for (final c in metadataState.metadata!.categories) {
            if (c.id == _product!.categoryId) {
              _selectedCategory = c;
              break;
            }
          }
          // Find brand
          for (final b in metadataState.metadata!.brands) {
            if (b.id == _product!.brandId) {
              _selectedBrand = b;
              break;
            }
          }
        });
      }
    });
  }

  /// Load product from API if not found in provider cache
  Future<void> _loadProductFromApi() async {
    if (_isLoadingProduct) return;

    setState(() => _isLoadingProduct = true);

    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    if (companyId.isEmpty || storeId.isEmpty) {
      setState(() => _isLoadingProduct = false);
      return;
    }

    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final result = await repository.getProducts(
        companyId: companyId,
        storeId: storeId,
        pagination: const PaginationParams(limit: 50),
        filter: ProductFilter(searchQuery: widget.productId),
      );

      if (mounted && result != null && result.products.isNotEmpty) {
        final matchedProduct = result.products.cast<Product?>().firstWhere(
          (p) => p?.id == widget.productId,
          orElse: () => null,
        );

        if (matchedProduct != null) {
          _product = matchedProduct;
          // Add to provider for future use
          ref.read(inventoryPageNotifierProvider.notifier).addProductIfNotExists(_product!);
          // Initialize form fields with the loaded product
          _initializeFormFields();
          setState(() => _isLoadingProduct = false);
        } else {
          setState(() => _isLoadingProduct = false);
        }
      } else {
        setState(() => _isLoadingProduct = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingProduct = false);
      }
    }
  }

  /// Initialize form fields with product data
  void _initializeFormFields() {
    if (_product == null) return;

    // Pre-populate form fields
    _productNameController.text = _product!.name;
    _sku = _product!.sku;
    _barcode = _product!.barcode;
    _salePriceController.text = _formatNumberWithCommas(_product!.salePrice.toStringAsFixed(0));
    _costPriceController.text = _formatNumberWithCommas(_product!.costPrice.toStringAsFixed(0));
    _descriptionController.text = _product!.description ?? '';
    _quantityController.text = _product!.onHand.toString();
    _unit = _product!.unit;
    _isActive = _product!.isActive;
    _existingImageUrls = List.from(_product!.images);

    // Set location from app state
    final appState = ref.read(appStateProvider);
    _selectedLocation = appState.storeChoosen;
    _selectedLocationName = appState.storeName;

    // Store original values for change detection
    _originalName = _product!.name;
    _originalSku = _product!.sku;
    _originalBarcode = _product!.barcode ?? '';
    _originalSalePrice = _product!.salePrice.toStringAsFixed(0);
    _originalCostPrice = _product!.costPrice.toStringAsFixed(0);
    _originalDescription = _product!.description ?? '';
    _originalOnHand = _product!.onHand.toString();
    _originalUnit = _product!.unit;
    _originalIsActive = _product!.isActive;
    _originalCategoryId = _product!.categoryId;
    _originalBrandId = _product!.brandId;
    _originalImageUrls = List.from(_product!.images);

    // Load metadata to find category and brand
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final metadataState = ref.read(inventoryMetadataNotifierProvider);
      if (metadataState.metadata != null) {
        setState(() {
          for (final c in metadataState.metadata!.categories) {
            if (c.id == _product!.categoryId) {
              _selectedCategory = c;
              break;
            }
          }
          for (final b in metadataState.metadata!.brands) {
            if (b.id == _product!.brandId) {
              _selectedBrand = b;
              break;
            }
          }
        });
      }
    });
  }

  String _formatNumberWithCommas(String value) {
    return value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  void dispose() {
    _productNameFocusNode.removeListener(_onProductNameFocusChange);
    _salePriceFocusNode.removeListener(_onSalePriceFocusChange);
    _costPriceFocusNode.removeListener(_onCostPriceFocusChange);
    _productNameController.removeListener(_onRequiredFieldChanged);
    _productNameFocusNode.dispose();
    _salePriceFocusNode.dispose();
    _costPriceFocusNode.dispose();
    _quantityFocusNode.dispose();
    _productNameController.dispose();
    _salePriceController.dispose();
    _costPriceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onProductNameFocusChange() {
    setState(() {
      _isProductNameFocused = _productNameFocusNode.hasFocus;
    });
  }

  void _onRequiredFieldChanged() {
    // Trigger rebuild to update Save button state
    setState(() {});
  }

  void _onSalePriceFocusChange() {
    setState(() {
      _isSalePriceFocused = _salePriceFocusNode.hasFocus;
    });
  }

  void _onCostPriceFocusChange() {
    setState(() {
      _isCostPriceFocused = _costPriceFocusNode.hasFocus;
    });
  }

  void _pickImages() {
    ImageUploadSheet.show(
      context: context,
      onImagesSelected: (images) {
        if (mounted) {
          setState(() {
            _selectedImages.addAll(images);
          });
        }
      },
    );
  }

  Future<void> _saveProduct() async {
    if (!_canSave) return;

    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen as String?;
    final storeId = _selectedLocation ?? appState.storeChoosen as String?;
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
      final salePrice = double.tryParse(_salePriceController.text.replaceAll(',', '')) ?? 0.0;
      final costPrice = double.tryParse(_costPriceController.text.replaceAll(',', '')) ?? 0.0;
      final productName = _productNameController.text.trim();
      final sku = _sku?.trim() ?? '';

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
      final parsedOnHand = int.tryParse(_quantityController.text);
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
        unit: _unit,
        costPrice: costPrice,
        salePrice: salePrice,
        onHand: onHand,
        imageUrls: allImageUrls.isNotEmpty ? allImageUrls : null,
      );

      if (product != null && mounted) {
        // Refresh the inventory list and wait for completion
        await ref.read(inventoryPageNotifierProvider.notifier).refresh();

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

        // Navigate back to inventory page
        // Pop twice: edit page -> product detail -> inventory page
        if (mounted) {
          // First pop: close edit page
          context.pop();
          // Second pop: close product detail page (if came from there)
          if (context.canPop()) {
            context.pop();
          }
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

  void _showSkuInput() {
    SkuInputSheet.show(
      context: context,
      currentSku: _sku,
      onSkuChanged: (value) {
        setState(() {
          _sku = value;
        });
      },
    );
  }

  void _showCategorySelector(InventoryMetadata metadata) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => AttributeValueSelectorPage<Category>(
          title: 'category',
          searchHint: 'Search or enter a category',
          values: metadata.categories,
          selectedValue: _selectedCategory,
          getName: (category) => category.name,
          getId: (category) => category.id,
          onSelect: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
          onQuickAdd: (name) async {
            final appState = ref.read(appStateProvider);
            final companyId = appState.companyChoosen as String?;
            if (companyId == null) return null;

            final repository = ref.read(inventoryRepositoryProvider);
            final category = await repository.createCategory(
              companyId: companyId,
              categoryName: name,
            );

            if (category != null) {
              ref.read(inventoryMetadataNotifierProvider.notifier).refresh();
            }
            return category;
          },
        ),
      ),
    );
  }

  void _showBrandSelector(InventoryMetadata metadata) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => AttributeValueSelectorPage<Brand>(
          title: 'brand',
          searchHint: 'Search or enter a brand',
          values: metadata.brands,
          selectedValue: _selectedBrand,
          getName: (brand) => brand.name,
          getId: (brand) => brand.id,
          onSelect: (brand) {
            setState(() {
              _selectedBrand = brand;
            });
          },
          onQuickAdd: (name) async {
            final appState = ref.read(appStateProvider);
            final companyId = appState.companyChoosen as String?;
            if (companyId == null) return null;

            final repository = ref.read(inventoryRepositoryProvider);
            final brand = await repository.createBrand(
              companyId: companyId,
              brandName: name,
            );

            if (brand != null) {
              ref.read(inventoryMetadataNotifierProvider.notifier).refresh();
            }
            return brand;
          },
        ),
      ),
    );
  }

  void _showLocationSelector() {
    final appState = ref.read(appStateProvider);
    final stores = StoreUtils.getCompanyStores(appState);

    final items = stores
        .map((store) => TossSelectionItem(
              id: store.id,
              title: store.name,
              icon: TossIcons.store,
            ))
        .toList();

    TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Store',
      items: items,
      selectedId: _selectedLocation,
      showSubtitle: false,
      selectedFontWeight: FontWeight.w700,
      unselectedFontWeight: FontWeight.w500,
      unselectedIconColor: TossColors.gray500,
      borderBottomWidth: 0.5,
      checkIcon: TossIcons.check,
      enableHapticFeedback: true,
      onItemSelected: (item) {
        setState(() {
          _selectedLocation = item.id;
          _selectedLocationName = item.title;
        });
      },
    );
  }

  Future<void> _showUnitSelector() async {
    // Always use default units list - piece is first (default)
    const units = ['piece', 'box', 'kg', 'g', 'l', 'ml', 'pack', 'set', 'dozen'];

    final items = units
        .map((unit) => TossSelectionItem.fromGeneric(id: unit, title: unit))
        .toList();

    await TossSelectionBottomSheet.show<String>(
      context: context,
      title: 'Unit',
      items: items,
      selectedId: _unit,
      showSubtitle: false,
      onItemSelected: (item) {
        setState(() {
          _unit = item.id;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final metadataState = ref.watch(inventoryMetadataNotifierProvider);

    if (_product == null) {
      return const TossScaffold(
        backgroundColor: TossColors.white,
        body: TossLoadingView(),
      );
    }

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Image upload
                  _buildImageUpload(),
                  // Basic info section (includes Product Status)
                  _buildBasicInfoSection(),
                  // Section divider - full width
                  const GrayDividerSpace(),
                  // Attributes section
                  _buildAttributesSection(metadataState.metadata),
                  // Section divider - full width
                  const GrayDividerSpace(),
                  // Pricing section
                  _buildPricingSection(),
                  // Section divider - full width
                  const GrayDividerSpace(),
                  // Inventory section
                  _buildInventorySection(metadataState.metadata),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return TossAppBar(
      title: 'Edit product',
      backgroundColor: TossColors.white,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.close, color: TossColors.gray900),
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildImageUpload() {
    return ProductImageThumbnail(
      onTap: _pickImages,
      existingImageUrls: _existingImageUrls,
      selectedImages: _selectedImages,
    );
  }

  Widget _buildBasicInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          // Product Status row
          ProductStatusRow(
            isActive: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
              });
            },
          ),
          FormListRow(
            label: 'SKU',
            value: _sku,
            placeholder: 'Scan or enter manually',
            showChevron: true,
            showHelpBadge: true,
            onTap: _showSkuInput,
            onHelpTap: _showSkuInfoDialog,
          ),
          ProductNameRow(
            controller: _productNameController,
            focusNode: _productNameFocusNode,
            isFocused: _isProductNameFocused,
          ),
        ],
      ),
    );
  }

  Widget _buildAttributesSection(InventoryMetadata? metadata) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          FormSectionHeader(
            title: 'Attributes',
            showHelpBadge: true,
            actionText: 'Edit',
            onActionTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const AttributesEditPage(),
                ),
              );
            },
            onHelpTap: _showAttributesInfoDialog,
          ),
          FormListRow(
            label: 'Category',
            value: _selectedCategory?.name,
            placeholder: 'Enter a value',
            showChevron: true,
            onTap: metadata != null ? () => _showCategorySelector(metadata) : null,
          ),
          FormListRow(
            label: 'Brand',
            value: _selectedBrand?.name,
            placeholder: 'Enter a value',
            showChevron: true,
            onTap: metadata != null ? () => _showBrandSelector(metadata) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    // Get base currency symbol from inventory page state
    final inventoryState = ref.watch(inventoryPageNotifierProvider);
    final currencySymbol = inventoryState.baseCurrency?.displaySymbol ?? '₩';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          const FormSectionHeader(title: 'Pricing'),
          FormPriceRow(
            label: 'Sale price ($currencySymbol)',
            controller: _salePriceController,
            focusNode: _salePriceFocusNode,
            isFocused: _isSalePriceFocused,
            placeholder: 'Enter selling price',
            currencySymbol: currencySymbol,
          ),
          FormPriceRow(
            label: 'Cost of goods ($currencySymbol)',
            controller: _costPriceController,
            focusNode: _costPriceFocusNode,
            isFocused: _isCostPriceFocused,
            placeholder: 'Enter item cost',
            currencySymbol: currencySymbol,
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySection(InventoryMetadata? metadata) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          const FormSectionHeader(title: 'Inventory'),
          FormListRow(
            label: 'Location',
            value: _selectedLocationName,
            placeholder: 'Select store location',
            showChevron: true,
            onTap: _showLocationSelector,
          ),
          FormNumberInputRow(
            label: 'On-hand quantity',
            controller: _quantityController,
            focusNode: _quantityFocusNode,
            placeholder: 'e.g. 50',
          ),
          FormListRow(
            label: 'Unit',
            value: _unit,
            placeholder: 'piece',
            showChevron: true,
            isValueActive: true,
            onTap: _showUnitSelector,
          ),
        ],
      ),
    );
  }

  void _showSkuInfoDialog() {
    TossInfoDialog.show(
      context: context,
      title: 'What is an SKU?',
      bulletPoints: [
        'An SKU (Stock Keeping Unit) is a unique code used to identify an item.',
        'You can enter your own or have Storebase generate one for you.',
        'SKUs help you find items quickly and perform bulk actions in your inventory.',
      ],
    );
  }

  void _showAttributesInfoDialog() {
    TossInfoDialog.show(
      context: context,
      title: 'What are attributes?',
      bulletPoints: [
        'Attributes are custom fields you can add to each item.',
        'You can choose from: text, number, date, or barcode.',
        'Attributes help you organize, search, and filter your inventory more easily.',
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(TossSpacing.space4, TossSpacing.space2, TossSpacing.space4, TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white.withValues(alpha: 0.94),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: TossButton.primary(
            text: 'Save',
            fullWidth: true,
            isLoading: _isSaving,
            isEnabled: _canSave,
            onPressed: _saveProduct,
          ),
        ),
      ),
    );
  }
}
