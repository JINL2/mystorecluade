import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_dimensions.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../di/inventory_providers.dart';
import '../../domain/entities/inventory_metadata.dart';
import '../adapters/xfile_image_adapter.dart';
import '../providers/inventory_providers.dart';
import '../utils/store_utils.dart';
import '../widgets/product_form/product_form_widgets.dart';
import 'attribute_value_selector_page.dart';
import 'attributes_edit_page.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Add Product Page - Redesigned with cleaner Toss-style layout
class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  // Form state
  final List<XFile> _selectedImages = [];
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final FocusNode _productNameFocusNode = FocusNode();
  final FocusNode _salePriceFocusNode = FocusNode();
  final FocusNode _costPriceFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  bool _isProductNameFocused = false;
  bool _isSalePriceFocused = false;
  bool _isCostPriceFocused = false;
  String? _sku;
  bool _isAutoGenerateSku = false; // true면 SKU 자동 생성
  Category? _selectedCategory;
  Brand? _selectedBrand;
  String? _selectedLocation; // Store ID
  String? _selectedLocationName; // Store name for display
  String _unit = 'piece';
  bool _isSaving = false;

  // Custom attributes: Map of attributeId -> selected optionId
  final Map<String, String?> _selectedAttributeValues = {};

  /// Check if required fields are filled for save button
  bool get _canSave {
    final hasProductName = _productNameController.text.trim().isNotEmpty;
    final hasLocation = _selectedLocation != null && _selectedLocation!.isNotEmpty;
    return hasProductName && hasLocation && !_isSaving;
  }

  @override
  void initState() {
    super.initState();
    _productNameFocusNode.addListener(_onProductNameFocusChange);
    _salePriceFocusNode.addListener(_onSalePriceFocusChange);
    _costPriceFocusNode.addListener(_onCostPriceFocusChange);
    _productNameController.addListener(_onRequiredFieldChanged);

    // Set default store location from AppState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      final defaultStoreId = appState.storeChoosen;
      final defaultStoreName = appState.storeName;

      if (defaultStoreId.isNotEmpty) {
        setState(() {
          _selectedLocation = defaultStoreId;
          _selectedLocationName = defaultStoreName.isNotEmpty ? defaultStoreName : null;
        });
      }
    });
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
    // Validate required fields
    final productName = _productNameController.text.trim();
    if (productName.isEmpty) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Validation Error',
          message: 'Product name is required',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    // Get app state
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen as String?;
    // Use selected location if available, otherwise fall back to app state
    final storeId = _selectedLocation ?? appState.storeChoosen as String?;
    final userId = appState.user['user_id'] as String?;

    // Validate required fields
    if (companyId == null || userId == null) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Validation Error',
          message: 'Company or user not selected',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    // Validate store location is selected
    if (storeId == null) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Validation Error',
          message: 'Please select a store location',
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

      // Step 1: Validate with inventory_check_create RPC
      final userSku = _sku?.trim().isEmpty ?? true ? null : _sku!.trim();
      final productName = _productNameController.text.trim();

      final validationResult = await repository.checkCreateProduct(
        companyId: companyId,
        productName: productName,
        storeId: storeId,
        sku: userSku,
        barcode: null,
        categoryId: _selectedCategory?.id,
        brandId: _selectedBrand?.id,
      );

      if (!validationResult.success) {
        // Show error dialog based on errorCode
        String errorMessage = validationResult.errorMessage ?? 'Validation failed';
        if (validationResult.errorCode == 'DUPLICATE_SKU') {
          errorMessage = 'SKU already exists. Please use a different SKU.';
        } else if (validationResult.errorCode == 'DUPLICATE_BARCODE') {
          errorMessage = 'Barcode already exists. Please use a different barcode.';
        } else if (validationResult.errorCode == 'STORE_ID_REQUIRED') {
          errorMessage = 'Store ID is required.';
        }

        if (mounted) {
          await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => TossDialog.error(
              title: 'Validation Error',
              message: errorMessage,
              primaryButtonText: 'OK',
            ),
          );
        }
        return;
      }

      // Step 2: Upload images to bucket if any
      List<String> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        final imageFiles = XFileImageAdapter.fromXFiles(_selectedImages);
        imageUrls = await repository.uploadProductImages(
          companyId: companyId,
          images: imageFiles,
        );
      }

      // Step 3: Create product with validated data and image URLs
      final product = await repository.createProduct(
        companyId: companyId,
        storeId: storeId,
        createdBy: userId,
        name: productName,
        sku: validationResult.sku,
        barcode: validationResult.barcode,
        categoryId: _selectedCategory?.id,
        brandId: _selectedBrand?.id,
        unit: _unit,
        costPrice: double.tryParse(_costPriceController.text.replaceAll(',', '')) ?? 0.0,
        sellingPrice: double.tryParse(_salePriceController.text.replaceAll(',', '')) ?? 0.0,
        initialQuantity: int.tryParse(_quantityController.text) ?? 0,
        imageUrls: imageUrls,
      );

      if (product != null && mounted) {
        ref.read(inventoryPageNotifierProvider.notifier).refresh();

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

  void _showSkuInput() {
    SkuInputSheet.show(
      context: context,
      currentSku: _sku,
      showAutoGenerate: true,
      onSkuChanged: (value) {
        setState(() {
          _sku = value;
          _isAutoGenerateSku = false;
        });
      },
      onAutoGenerate: () {
        setState(() {
          _sku = null; // null이면 RPC에서 SKU 자동 생성
          _isAutoGenerateSku = true;
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
        .map((store) => SelectionItem(
              id: store.id,
              title: store.name,
              icon: TossIcons.store,
            ))
        .toList();

    SelectionBottomSheetCommon.show<void>(
      context: context,
      title: 'Store',
      showDividers: true,
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final item = items[index];
        final isSelected = item.id == _selectedLocation;
        return SelectionListItem(
          item: item,
          isSelected: isSelected,
          variant: SelectionItemVariant.standard,
          enableHaptic: true,
          onTap: () {
            setState(() {
              _selectedLocation = item.id;
              _selectedLocationName = item.title;
            });
            Navigator.pop(ctx);
          },
        );
      },
    );
  }

  Future<void> _showUnitSelector() async {
    // Always use default units list - piece is first (default)
    const units = ['piece', 'box', 'kg', 'g', 'l', 'ml', 'pack', 'set', 'dozen'];

    final items = units
        .map((unit) => SelectionItem(id: unit, title: unit))
        .toList();

    await SelectionBottomSheetCommon.show<void>(
      context: context,
      title: 'Unit',
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final item = items[index];
        final isSelected = item.id == _unit;
        return SelectionListItem(
          item: item,
          isSelected: isSelected,
          variant: SelectionItemVariant.minimal,
          onTap: () {
            setState(() {
              _unit = item.id;
            });
            Navigator.pop(ctx);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final metadataState = ref.watch(inventoryMetadataNotifierProvider);

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
                  // Basic info section
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
                  SizedBox(height: TossSpacing.space24 + TossSpacing.space1),
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
      title: 'Add product',
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
      selectedImages: _selectedImages,
    );
  }

  Widget _buildBasicInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          FormListRow(
            label: 'SKU',
            value: _isAutoGenerateSku ? 'Auto-generate' : _sku,
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
          // Custom attributes from metadata
          if (metadata != null)
            ...metadata.attributes.map((attribute) {
              final selectedOptionId = _selectedAttributeValues[attribute.id];
              final selectedOption = attribute.options.cast<AttributeOption?>().firstWhere(
                (o) => o?.id == selectedOptionId,
                orElse: () => null,
              );
              return FormListRow(
                label: attribute.name,
                value: selectedOption?.value,
                placeholder: 'Select ${attribute.name.toLowerCase()}',
                showChevron: true,
                onTap: () => _showAttributeOptionSelector(attribute),
              );
            }),
        ],
      ),
    );
  }

  void _showAttributeOptionSelector(Attribute attribute) {
    final items = attribute.options
        .map((option) => SelectionItem(
              id: option.id,
              title: option.value,
            ))
        .toList();

    SelectionBottomSheetCommon.show<void>(
      context: context,
      title: attribute.name,
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final item = items[index];
        final isSelected = item.id == _selectedAttributeValues[attribute.id];
        return SelectionListItem(
          item: item,
          isSelected: isSelected,
          variant: SelectionItemVariant.standard,
          onTap: () {
            setState(() {
              _selectedAttributeValues[attribute.id] = item.id;
            });
            Navigator.pop(ctx);
          },
        );
      },
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
            isRequired: true,
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
          height: TossDimensions.headerHeight,
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
