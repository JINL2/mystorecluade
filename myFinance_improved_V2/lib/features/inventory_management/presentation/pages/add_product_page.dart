import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/gray_divider_space.dart';
import '../../../../shared/widgets/common/toss_info_dialog.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_button.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../di/inventory_providers.dart';
import '../../domain/entities/inventory_metadata.dart';
import '../providers/inventory_providers.dart';
import '../widgets/product_form/dialogs/brand_creation_dialog.dart';
import '../widgets/product_form/dialogs/category_creation_dialog.dart';
import '../widgets/product_form/product_image_picker.dart';
import 'attribute_value_selector_page.dart';
import 'attributes_edit_page.dart';
import 'barcode_scanner_page.dart';

/// Currency input formatter that adds comma separators
class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Format with commas
    final formatted = _formatWithCommas(digitsOnly);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatWithCommas(String value) {
    return value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

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
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _productNameFocusNode = FocusNode();
  final FocusNode _salePriceFocusNode = FocusNode();
  final FocusNode _costPriceFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  final FocusNode _weightFocusNode = FocusNode();
  bool _isProductNameFocused = false;
  bool _isSalePriceFocused = false;
  bool _isCostPriceFocused = false;
  String? _sku;
  Category? _selectedCategory;
  Brand? _selectedBrand;
  String? _selectedLocation; // Store ID
  String? _selectedLocationName; // Store name for display
  String _unit = 'piece';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _productNameFocusNode.addListener(_onProductNameFocusChange);
    _salePriceFocusNode.addListener(_onSalePriceFocusChange);
    _costPriceFocusNode.addListener(_onCostPriceFocusChange);
  }

  @override
  void dispose() {
    _productNameFocusNode.removeListener(_onProductNameFocusChange);
    _salePriceFocusNode.removeListener(_onSalePriceFocusChange);
    _costPriceFocusNode.removeListener(_onCostPriceFocusChange);
    _productNameFocusNode.dispose();
    _salePriceFocusNode.dispose();
    _costPriceFocusNode.dispose();
    _quantityFocusNode.dispose();
    _weightFocusNode.dispose();
    _productNameController.dispose();
    _salePriceController.dispose();
    _costPriceController.dispose();
    _quantityController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _onProductNameFocusChange() {
    setState(() {
      _isProductNameFocused = _productNameFocusNode.hasFocus;
    });
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
    _showUploadImageSheet();
  }

  void _showUploadImageSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildUploadImageSheet(),
    );
  }

  Widget _buildUploadImageSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Upload Image',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Options
          _buildImageOptionItem(
            icon: Icons.photo_library_outlined,
            title: 'Choose from Library',
            onTap: () async {
              Navigator.pop(context);
              final images = await ProductImagePicker.pickFromGalleryWithValidation(context);
              if (images.isNotEmpty && mounted) {
                setState(() {
                  _selectedImages.addAll(images);
                });
              }
            },
          ),
          _buildImageOptionItem(
            icon: Icons.camera_alt_outlined,
            title: 'Take Photo',
            onTap: () async {
              Navigator.pop(context);
              final images = await ProductImagePicker.takePhotoWithValidation(context);
              if (images.isNotEmpty && mounted) {
                setState(() {
                  _selectedImages.addAll(images);
                });
              }
            },
            isLast: true,
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _buildImageOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: TossColors.gray100,
                    width: 0.5,
                  ),
                ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 18,
                color: TossColors.gray600,
              ),
            ),

            const SizedBox(width: 12),

            // Title
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Chevron
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
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

      // Create product
      final product = await repository.createProduct(
        companyId: companyId,
        storeId: storeId,
        createdBy: userId,
        name: productName,
        sku: _sku?.trim().isEmpty ?? true ? _generateSKU() : _sku!.trim(),
        barcode: null,
        categoryId: _selectedCategory?.id,
        brandId: _selectedBrand?.id,
        unit: _unit,
        costPrice: double.tryParse(_costPriceController.text.replaceAll(',', '')) ?? 0.0,
        sellingPrice: double.tryParse(_salePriceController.text.replaceAll(',', '')) ?? 0.0,
        initialQuantity: int.tryParse(_quantityController.text) ?? 0,
        imageUrls: [],
      );

      if (product != null && mounted) {
        ref.read(inventoryPageProvider.notifier).refresh();

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

  String _generateSKU() {
    final name = _productNameController.text.trim();
    if (name.isEmpty) return 'PROD${DateTime.now().millisecondsSinceEpoch}';

    final prefix = name
        .split(' ')
        .take(3)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join('');
    return '$prefix${DateTime.now().millisecondsSinceEpoch % 10000}';
  }

  void _showSkuInput() {
    const skuOptions = [
      TossSelectionItem(
        id: 'scan',
        title: 'Scan Barcode',
        icon: Icons.view_week_outlined,
      ),
      TossSelectionItem(
        id: 'manual',
        title: 'Enter Manually',
        icon: Icons.keyboard_outlined,
      ),
      TossSelectionItem(
        id: 'auto',
        title: 'Auto-generate',
        icon: Icons.auto_awesome_outlined,
      ),
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Header with title and close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24), // Spacer for centering
                  Text(
                    'Choose an SKU Option',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.gray900,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Options list
            ...skuOptions.map((option) => InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _handleSkuOptionSelected(option.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          option.icon,
                          size: 24,
                          color: TossColors.gray600,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option.title,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w500,
                              color: TossColors.gray900,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: TossColors.gray400,
                        ),
                      ],
                    ),
                  ),
                ),),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSkuOptionSelected(String optionId) async {
    switch (optionId) {
      case 'scan':
        // Navigate to barcode scanner page
        final result = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => const BarcodeScannerPage(),
          ),
        );

        if (result != null && mounted) {
          if (result == 'MANUAL_ENTRY') {
            // User chose to enter manually from scanner page
            _showBarcodeInputDialog();
          } else {
            // Barcode was scanned
            setState(() {
              _sku = result;
            });
          }
        }
        break;
      case 'manual':
        _showBarcodeInputDialog();
        break;
      case 'auto':
        setState(() {
          _sku = _generateSKU();
        });
        break;
    }
  }

  void _showBarcodeInputDialog() {
    final controller = TextEditingController(text: _sku);
    showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: TossColors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Enter Barcode Number',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: 24),
              // Text field with underline
              TextField(
                controller: controller,
                autofocus: true,
                textAlign: TextAlign.center,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                ),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: TossColors.gray300),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: TossColors.gray300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: TossColors.primary, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
              const SizedBox(height: 24),
              // Buttons row
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: TossColors.gray700,
                        side: const BorderSide(color: TossColors.gray300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: TossColors.gray700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Done button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, controller.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        foregroundColor: TossColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Done',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: TossColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      if (value != null && value.isNotEmpty && mounted) {
        setState(() {
          _sku = value;
        });
      }
    });
  }

  void _showTextInputDialog({
    required String title,
    String? initialValue,
    required String placeholder,
    required void Function(String?) onSave,
  }) {
    final controller = TextEditingController(text: initialValue);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: const BorderSide(color: TossColors.gray200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: const BorderSide(color: TossColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TossButton.primary(
                text: 'Done',
                fullWidth: true,
                onPressed: () {
                  onSave(controller.text.isEmpty ? null : controller.text);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
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
              ref.read(inventoryMetadataProvider.notifier).refresh();
            }
            return category;
          },
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
              ref.read(inventoryMetadataProvider.notifier).refresh();
            }
            return brand;
          },
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

  void _showLocationSelector() {
    // Mock store data with IDs (in real app, this would come from provider/API)
    final stores = [
      {'id': 'bb1f91be14', 'name': 'trial'},
      {'id': '261c9b1dd4', 'name': 'test store22'},
      {'id': '8df73d5aa2', 'name': 'test3'},
      {'id': 'd161278ee5', 'name': 'test2'},
      {'id': '570b4f196c', 'name': 'test1'},
      {'id': '8b6e72c413', 'name': 'Hongdae Branch'},
      {'id': 'a51e13772b', 'name': 'Headquarters'},
      {'id': 'cd7be02d1f', 'name': 'Gangnam Branch'},
      {'id': 'd1bb65328a', 'name': 'create test'},
    ];

    final items = stores
        .map((store) => TossSelectionItem(
              id: store['id']!,
              title: store['name']!,
              subtitle: store['id'],
              icon: TossIcons.store,
            ),)
        .toList();

    TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Store',
      items: items,
      selectedId: _selectedLocation,
      showSubtitle: true,
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

  Future<void> _showUnitSelector(InventoryMetadata metadata) async {
    final units = metadata.units.isNotEmpty
        ? metadata.units
        : ['piece', 'kg', 'g', 'liter', 'ml', 'box', 'pack'];

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
    final metadataState = ref.watch(inventoryMetadataProvider);

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
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Add product',
        style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: TossColors.white,
      foregroundColor: TossColors.gray900,
    );
  }

  Widget _buildImageUpload() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Center(
        child: GestureDetector(
          onTap: _pickImages,
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              border: Border.all(
                color: TossColors.gray200,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _selectedImages.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                        size: 26,
                        color: TossColors.gray500,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Add Photo',
                        style: TossTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w500,
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.asset(
                      _selectedImages.first.path,
                      fit: BoxFit.cover,
                      width: 88,
                      height: 88,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image,
                        size: 40,
                        color: TossColors.gray400,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildListRow(
            label: 'SKU',
            value: _sku,
            placeholder: 'Scan or enter manually',
            showChevron: true,
            showHelpBadge: true,
            onTap: _showSkuInput,
            onHelpTap: _showSkuInfoDialog,
          ),
          _buildProductNameRow(),
        ],
      ),
    );
  }

  Widget _buildProductNameRow() {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label
          Text(
            'Product name',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray600,
            ),
          ),
          // TextField and chevron
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _productNameController,
                    focusNode: _productNameFocusNode,
                    textAlign: TextAlign.right,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w400,
                      color: TossColors.gray900,
                    ),
                    decoration: InputDecoration(
                      hintText: _isProductNameFocused || _productNameController.text.isNotEmpty ? null : 'Enter product name',
                      hintStyle: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w400,
                        color: TossColors.gray500,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: TossColors.gray500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributesSection(InventoryMetadata? metadata) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSectionHeader(
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
          _buildListRow(
            label: 'Category',
            value: _selectedCategory?.name,
            placeholder: 'Enter a value',
            showChevron: true,
            onTap: metadata != null ? () => _showCategorySelector(metadata) : null,
          ),
          _buildListRow(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSectionHeader(title: 'Pricing'),
          _buildPriceRow(
            label: 'Sale price (₩)',
            controller: _salePriceController,
            focusNode: _salePriceFocusNode,
            isFocused: _isSalePriceFocused,
            placeholder: 'Enter selling price',
          ),
          _buildPriceRow(
            label: 'Cost of goods (₩)',
            controller: _costPriceController,
            focusNode: _costPriceFocusNode,
            isFocused: _isCostPriceFocused,
            placeholder: 'Enter item cost',
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isFocused,
    required String placeholder,
  }) {
    final bool hasValue = controller.text.isNotEmpty;

    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray600,
            ),
          ),
          // TextField, currency suffix and chevron
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CurrencyInputFormatter(),
                    ],
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w400,
                      color: TossColors.gray900,
                    ),
                    decoration: InputDecoration(
                      hintText: isFocused || hasValue ? null : placeholder,
                      hintStyle: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w400,
                        color: TossColors.gray500,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                // Currency suffix
                if (hasValue) ...[
                  Text(
                    '₩',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w400,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: TossColors.gray500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySection(InventoryMetadata? metadata) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSectionHeader(title: 'Inventory'),
          _buildListRow(
            label: 'Location',
            value: _selectedLocationName,
            placeholder: 'Select store location',
            showChevron: true,
            onTap: _showLocationSelector,
          ),
          _buildNumberInputRow(
            label: 'On-hand quantity',
            controller: _quantityController,
            focusNode: _quantityFocusNode,
            placeholder: 'e.g. 50',
          ),
          _buildNumberInputRow(
            label: 'Weight (g)',
            controller: _weightController,
            focusNode: _weightFocusNode,
            placeholder: '0',
            allowDecimal: true,
          ),
          _buildListRow(
            label: 'Unit',
            value: _unit,
            placeholder: 'piece',
            showChevron: true,
            isValueActive: true,
            onTap: metadata != null ? () => _showUnitSelector(metadata) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberInputRow({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String placeholder,
    bool allowDecimal = false,
  }) {
    return ListenableBuilder(
      listenable: Listenable.merge([focusNode, controller]),
      builder: (context, _) {
        final bool isFocused = focusNode.hasFocus;
        final bool hasValue = controller.text.isNotEmpty;

        return Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Label
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.gray600,
                ),
              ),
              // TextField and chevron
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
                        inputFormatters: allowDecimal
                            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                            : [FilteringTextInputFormatter.digitsOnly],
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w400,
                          color: TossColors.gray900,
                        ),
                        decoration: InputDecoration(
                          hintText: isFocused || hasValue ? null : placeholder,
                          hintStyle: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w400,
                            color: TossColors.gray500,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: TossColors.gray500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({
    required String title,
    bool showHelpBadge = false,
    String? actionText,
    VoidCallback? onActionTap,
    VoidCallback? onHelpTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              if (showHelpBadge) ...[
                const SizedBox(width: 8),
                _buildHelpBadge(onTap: onHelpTap),
              ],
            ],
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListRow({
    required String label,
    String? value,
    required String placeholder,
    bool showChevron = false,
    bool showHelpBadge = false,
    bool isValueActive = false,
    VoidCallback? onTap,
    VoidCallback? onHelpTap,
  }) {
    final bool hasValue = value != null && value.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Label
            Row(
              children: [
                Text(
                  label,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray600,
                  ),
                ),
                if (showHelpBadge) ...[
                  const SizedBox(width: 8),
                  _buildHelpBadge(onTap: onHelpTap),
                ],
              ],
            ),
            // Value and chevron
            Row(
              children: [
                Text(
                  hasValue ? value : placeholder,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: hasValue && isValueActive
                        ? FontWeight.w500
                        : FontWeight.w400,
                    color: hasValue && isValueActive
                        ? TossColors.gray900
                        : TossColors.gray500,
                  ),
                ),
                if (showChevron) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: TossColors.gray500,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpBadge({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 18,
        height: 18,
        decoration: const BoxDecoration(
          color: TossColors.gray100,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '?',
          style: TossTextStyles.caption.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray500,
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
            onPressed: _saveProduct,
          ),
        ),
      ),
    );
  }
}
