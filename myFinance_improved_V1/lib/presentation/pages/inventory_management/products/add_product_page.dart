import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_icons_fa.dart';
import '../../../../core/themes/index.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../widgets/common/toss_app_bar.dart';
import '../../../widgets/toss/toss_text_field.dart';
import '../../../widgets/toss/toss_enhanced_text_field.dart';
import '../../../widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../widgets/toss/toss_button.dart';
import '../../../helpers/navigation_helper.dart';
import '../models/product_model.dart';
import '../../../../data/models/inventory_models.dart';
import '../../../../data/services/inventory_service.dart';
import '../../../providers/app_state_provider.dart';

class AddProductPage extends ConsumerStatefulWidget {
  final InventoryMetadata? metadata;
  
  const AddProductPage({Key? key, this.metadata}) : super(key: key);

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _inventoryService = InventoryService();
  
  // Controllers
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _skuController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _onHandController = TextEditingController();
  final _weightController = TextEditingController();
  
  // Selected values
  ProductCategory? _selectedCategory;
  String? _selectedCategoryId;
  String? _selectedBrand;
  String? _selectedBrandId;
  String? _selectedUnit;
  File? _productImage;
  bool _isLoading = false;

  // Local metadata copy that can be updated
  InventoryMetadata? _metadata;

  // Getter for metadata
  InventoryMetadata? get metadata => _metadata ?? widget.metadata;

  @override
  void initState() {
    super.initState();
    // Initialize local metadata copy
    _metadata = widget.metadata;
    
    // Product number is optional - user can add if needed
    
    // Note: storeId and companyId are now retrieved from app state when saving
    
    // Set default unit if metadata is available
    if (metadata?.units.isNotEmpty == true) {
      _selectedUnit = metadata?.units.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _skuController.dispose();
    _costPriceController.dispose();
    _salePriceController.dispose();
    _onHandController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  
  String? _validateSku(String? value) {
    if (value == null || value.isEmpty) {
      return null; // SKU is optional
    }
    
    // Allow any string format as long as it's not empty
    // Duplicate checking will be handled by the RPC on the server side
    return null;
  }
  
  String? _validateBarcode(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Barcode is optional
    }
    
    final validationRules = metadata?.validationRules;
    if (validationRules?.barcodePattern != null) {
      final pattern = RegExp(validationRules!.barcodePattern!);
      if (!pattern.hasMatch(value)) {
        return 'Barcode format is invalid';
      }
    }
    
    return null;
  }
  
  String? _validatePrice(String? value, {bool isRequired = false}) {
    if (value == null || value.isEmpty) {
      if (isRequired) {
        return 'Price is required';
      }
      return null;
    }
    
    final numericValue = double.tryParse(value.replaceAll(',', ''));
    if (numericValue == null) {
      return 'Please enter a valid price';
    }
    
    final validationRules = metadata?.validationRules;
    if (validationRules?.minPriceRequired == true && numericValue <= 0) {
      return 'Price must be greater than 0';
    }
    
    return null;
  }


  Future<void> _pickImage() async {
    final items = [
      TossSelectionItem.fromGeneric(
        id: 'camera',
        title: 'Take Photo',
        icon: Icons.camera_alt_outlined,
      ),
      TossSelectionItem.fromGeneric(
        id: 'gallery',
        title: 'Choose from Gallery',
        icon: Icons.photo_library_outlined,
      ),
    ];

    await TossSelectionBottomSheet.show<String>(
      context: context,
      title: 'Add Photo',
      items: items,
      showSubtitle: false,
      onItemSelected: (item) async {
        final picker = ImagePicker();
        final source = item.id == 'camera' ? ImageSource.camera : ImageSource.gallery;
        
        final pickedFile = await picker.pickImage(
          source: source,
          maxWidth: 1080,
          maxHeight: 1080,
          imageQuality: 85,
        );
        
        if (pickedFile != null) {
          setState(() {
            _productImage = File(pickedFile.path);
          });
        }
      },
    );
  }

  Future<void> _showResultDialog({
    required bool isSuccess,
    required String title,
    required String message,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          icon: Icon(
            isSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded,
            color: isSuccess ? TossColors.success : TossColors.error,
            size: 48,
          ),
          title: Text(
            title,
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuccess ? TossColors.success : TossColors.primary,
                  foregroundColor: TossColors.white,
                  minimumSize: const Size(120, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                ),
                child: Text(
                  'OK',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCategoryCreationDialog() async {
    print('🔧 DEBUG: _showCategoryCreationDialog called');

    print('🔧 DEBUG: About to call showDialog');
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _CategoryCreationDialog(
          metadata: metadata,
          onCategoryCreated: (result) async {
            Navigator.of(context).pop();
            await _refreshMetadataAndSelectCategory(result);
          },
          ref: ref,
          inventoryService: _inventoryService,
        );
      },
    );
  }

  Future<void> _refreshMetadataAndSelectCategory(Map<String, dynamic> newCategory) async {
    try {
      // Get app state values
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isNotEmpty && storeId.isNotEmpty) {
        // Refresh metadata
        final newMetadata = await _inventoryService.getInventoryMetadata(
          companyId: companyId,
          storeId: storeId,
        );

        if (newMetadata != null) {
          // Update the local metadata and select the new category
          setState(() {
            _metadata = newMetadata;
            
            // Select the newly created category - handle various response formats
            if (newCategory.containsKey('data') && newCategory['data'] is Map) {
              final data = newCategory['data'] as Map<String, dynamic>;
              _selectedCategoryId = data['category_id']?.toString() ?? data['id']?.toString();
            } else {
              _selectedCategoryId = newCategory['category_id']?.toString() ?? newCategory['id']?.toString();
            }
            _selectedCategory = null; // Clear enum category
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Category created successfully'),
              backgroundColor: TossColors.success,
            ),
          );
        }
      }
    } catch (e) {
      print('Error refreshing metadata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category created but failed to refresh list'),
          backgroundColor: TossColors.warning,
        ),
      );
    }
  }

  Future<void> _refreshMetadata() async {
    try {
      // Get app state values
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isNotEmpty && storeId.isNotEmpty) {
        // Refresh metadata
        final newMetadata = await _inventoryService.getInventoryMetadata(
          companyId: companyId,
          storeId: storeId,
        );

        if (newMetadata != null) {
          // Update the local metadata
          setState(() {
            _metadata = newMetadata;
          });
        }
      }
    } catch (e) {
      print('Error refreshing metadata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh data'),
          backgroundColor: TossColors.warning,
        ),
      );
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Get app state values
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      // Validate required app state values
      if (companyId.isEmpty || storeId.isEmpty) {
        if (mounted) {
          await _showResultDialog(
            isSuccess: false,
            title: 'Setup Required',
            message: 'Please select company and store first',
          );
        }
        return;
      }

      // Parse numeric values from text fields
      double? costPrice;
      if (_costPriceController.text.isNotEmpty) {
        costPrice = double.tryParse(_costPriceController.text.replaceAll(',', ''));
      }

      double? sellingPrice;
      if (_salePriceController.text.isNotEmpty) {
        sellingPrice = double.tryParse(_salePriceController.text.replaceAll(',', ''));
      }

      int? initialQuantity;
      if (_onHandController.text.isNotEmpty) {
        initialQuantity = int.tryParse(_onHandController.text.replaceAll(',', ''));
      }

      // Determine category ID
      String? categoryId;
      if (_selectedCategoryId != null) {
        categoryId = _selectedCategoryId;
      }

      // Determine brand ID
      String? brandId;
      if (_selectedBrandId != null) {
        brandId = _selectedBrandId;
      }

      // Handle image upload (for now, we'll pass null as we don't have image upload implementation)
      String? imageUrl;
      String? thumbnailUrl;
      
      // Call the RPC function
      final result = await _inventoryService.createProduct(
        companyId: companyId,
        productName: _nameController.text.trim(),
        storeId: storeId,
        sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
        barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
        categoryId: categoryId,
        brandId: brandId,
        unit: _selectedUnit,
        costPrice: costPrice,
        sellingPrice: sellingPrice,
        initialQuantity: initialQuantity,
        imageUrl: imageUrl,
        thumbnailUrl: thumbnailUrl,
        imageUrls: null,
      );

      if (mounted) {
        if (result != null) {
          // Success - show success dialog and navigate back
          await _showResultDialog(
            isSuccess: true,
            title: 'Product Created',
            message: 'Product "${_nameController.text.trim()}" has been created successfully',
          );
          
          // Navigate back with result to trigger refresh
          if (context.mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop(true);
          } else {
            NavigationHelper.safeGoBack(context);
          }
        } else {
          // Error - show error dialog
          await _showResultDialog(
            isSuccess: false,
            title: 'Creation Failed',
            message: 'Failed to create product. Please check your inputs and try again.',
          );
        }
      }
    } catch (e) {
      print('Error saving product: $e');
      if (mounted) {
        await _showResultDialog(
          isSuccess: false,
          title: 'Error',
          message: 'An unexpected error occurred: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildImageUploadSection() {
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      child: TossPageStyles.card(
        padding: EdgeInsets.all(TossSpacing.space3),
        child: InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            width: double.infinity,
            height: TossSpacing.space12, // 48px height
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            child: _productImage != null
                ? Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        child: Image.file(
                          _productImage!,
                          width: TossSpacing.space10,
                          height: TossSpacing.space10,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          'Product image selected',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray700,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.edit,
                        size: TossSpacing.iconSM,
                        color: TossColors.gray400,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: TossSpacing.iconSM,
                        color: TossColors.gray400,
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        'Add Photo',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfoSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossPageStyles.card(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            // Section Header
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TossColors.gray100,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  FaIcon(
                    AppIcons.info,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Product Information',
                    style: TossPageStyles.sectionTitleStyle,
                  ),
                  Spacer(),
                  // Debug: Show metadata status
                  if (metadata != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Text(
                        'Metadata ✓',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Product Name (Required)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TossTextStyles.label.copyWith(
                      color: TossColors.gray700,
                    ),
                    children: [
                      TextSpan(
                        text: 'Product name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: TossColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                TossTextField(
                  label: null,
                  hintText: 'Enter product name',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product name is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Product Number (Optional - for inventory tracking)
            TossTextField(
              label: 'Product number (Optional)',
              hintText: 'Enter product number for inventory tracking',
              controller: _skuController,
              validator: _validateSku,
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Barcode
            TossTextField(
              label: 'Barcode (Optional)',
              hintText: 'Enter barcode',
              controller: _barcodeController,
              validator: _validateBarcode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassificationSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossPageStyles.card(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Section Header
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TossColors.gray100,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  FaIcon(
                    AppIcons.folder,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Classification',
                    style: TossPageStyles.sectionTitleStyle,
                  ),
                ],
              ),
            ),
            
            // Category Selection
            _buildSelectionRow(
              label: 'Category',
              value: _selectedCategoryId != null
                  ? metadata?.categories.firstWhere(
                      (cat) => cat.id == _selectedCategoryId,
                      orElse: () => Category(id: '', name: 'Unknown'),
                    ).name
                  : null,
              placeholder: 'Select product category',
              onTap: () async {
                print('🔧 DEBUG: Category selection tapped');
                final categories = metadata?.categories ?? [];
                print('🔧 DEBUG: Categories found: ${categories.length}');
                if (categories.isEmpty) {
                  print('🔧 DEBUG: No metadata categories, using enum fallback');
                  // Fallback to enum if no metadata
                  final items = ProductCategory.values.map((category) => 
                    TossSelectionItem.fromGeneric(
                      id: category.name,
                      title: category.displayName,
                    )
                  ).toList();
                  
                  // Add "Add category" button
                  items.add(TossSelectionItem.fromGeneric(
                    id: '__add_category__',
                    title: 'Add category',
                    icon: Icons.add,
                  ));
                  
                  await TossSelectionBottomSheet.show<String>(
                    context: context,
                    title: 'Product category',
                    items: items,
                    selectedId: _selectedCategory?.name,
                    showSubtitle: false,
                    onItemSelected: (item) {
                      print('🔧 DEBUG: Item selected - ID: ${item.id}, Title: ${item.title}');
                      if (item.id == '__add_category__') {
                        print('🔧 DEBUG: Add category button clicked');
                        // Use Future.delayed to ensure the bottom sheet closes first
                        Future.delayed(Duration(milliseconds: 300), () {
                          if (mounted) {
                            print('🔧 DEBUG: Showing category creation dialog');
                            _showCategoryCreationDialog();
                          } else {
                            print('🔧 DEBUG: Widget not mounted, skipping dialog');
                          }
                        });
                      } else {
                        setState(() {
                          _selectedCategory = ProductCategory.values.firstWhere(
                            (cat) => cat.name == item.id
                          );
                          _selectedCategoryId = null; // Clear metadata category
                        });
                      }
                    },
                  );
                } else {
                  print('🔧 DEBUG: Using metadata categories with Add category button');
                  // Use metadata categories with "Add category" button
                  final items = categories.map((category) => 
                    TossSelectionItem.fromGeneric(
                      id: category.id,
                      title: category.name,
                      subtitle: category.productCount != null 
                          ? '${category.productCount} products'
                          : null,
                    )
                  ).toList();
                  
                  // Add "Add category" button at the top
                  items.insert(0, TossSelectionItem.fromGeneric(
                    id: '__add_category__',
                    title: 'Add category',
                    icon: Icons.add,
                    subtitle: 'Create a new category',
                  ));
                  
                  await TossSelectionBottomSheet.show<String>(
                    context: context,
                    title: 'Product category',
                    items: items,
                    selectedId: _selectedCategoryId,
                    showSubtitle: true,
                    onItemSelected: (item) {
                      print('🔧 DEBUG: Metadata item selected - ID: ${item.id}, Title: ${item.title}');
                      if (item.id == '__add_category__') {
                        print('🔧 DEBUG: Add category button clicked (metadata path)');
                        // Use Future.delayed to ensure the bottom sheet closes first
                        Future.delayed(Duration(milliseconds: 300), () {
                          if (mounted) {
                            print('🔧 DEBUG: Showing category creation dialog (metadata path)');
                            _showCategoryCreationDialog();
                          } else {
                            print('🔧 DEBUG: Widget not mounted, skipping dialog (metadata path)');
                          }
                        });
                      } else {
                        setState(() {
                          _selectedCategoryId = item.id;
                          _selectedCategory = null; // Clear enum category
                        });
                      }
                    },
                  );
                }
              },
            ),
            
            // Brand Selection
            _buildSelectionRow(
              label: 'Brand',
              value: _selectedBrandId != null
                  ? metadata?.brands.firstWhere(
                      (brand) => brand.id == _selectedBrandId,
                      orElse: () => Brand(id: '', name: 'Unknown'),
                    ).name
                  : _selectedBrand,
              placeholder: 'Choose brand',
              onTap: () async {
                final brands = metadata?.brands ?? [];
                if (brands.isEmpty) {
                  // Fallback to hardcoded brands if no metadata
                  final hardcodedBrands = [
                    'GOYARD', 'PRADA', 'LOUIS VUITTON', 'CHANEL', 'HERMES',
                    'GUCCI', 'DIOR', 'FENDI', 'BALENCIAGA', 'CELINE', 
                    'APPLE', 'SAMSUNG', 'Other'
                  ];
                  
                  final items = hardcodedBrands.map((brand) => 
                    TossSelectionItem.fromGeneric(
                      id: brand,
                      title: brand,
                    )
                  ).toList();
                  
                  await TossSelectionBottomSheet.show<String>(
                    context: context,
                    title: 'Brand',
                    items: items,
                    selectedId: _selectedBrand,
                    showSubtitle: false,
                    showSearch: true,
                    onItemSelected: (item) {
                      setState(() {
                        _selectedBrand = item.id;
                        _selectedBrandId = null; // Clear metadata brand
                      });
                    },
                  );
                } else {
                  // Use metadata brands with "Add brand" button - same design as categories
                  final items = brands.map((brand) => 
                    TossSelectionItem.fromGeneric(
                      id: brand.id,
                      title: brand.name,
                      subtitle: brand.productCount != null 
                          ? '${brand.productCount} products'
                          : null,
                    )
                  ).toList();
                  
                  // Add "Add brand" button at the top - exactly like categories
                  items.insert(0, TossSelectionItem.fromGeneric(
                    id: '__add_brand__',
                    title: 'Add brand',
                    icon: Icons.add,
                    subtitle: 'Create a new brand',
                  ));
                  
                  await TossSelectionBottomSheet.show<String>(
                    context: context,
                    title: 'Brand',
                    items: items,
                    selectedId: _selectedBrandId,
                    showSubtitle: true,
                    onItemSelected: (item) {
                      print('🔧 DEBUG: Brand item selected - ID: ${item.id}, Title: ${item.title}');
                      if (item.id == '__add_brand__') {
                        print('🔧 DEBUG: Add brand button clicked');
                        // Use Future.delayed to ensure the bottom sheet closes first
                        Future.delayed(Duration(milliseconds: 300), () {
                          if (mounted) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => _BrandCreationDialog(
                                metadata: metadata,
                                onBrandCreated: (Map<String, dynamic> result) {
                                  print('✅ Brand created: $result');
                                  // Refresh metadata after brand creation
                                  _refreshMetadata();
                                },
                                ref: ref,
                                inventoryService: _inventoryService,
                              ),
                            );
                          }
                        });
                      } else {
                        // Regular brand selection
                        setState(() {
                          _selectedBrandId = item.id;
                          _selectedBrand = null; // Clear hardcoded brand
                        });
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossPageStyles.card(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            // Section Header
            Row(
              children: [
                FaIcon(
                  AppIcons.money,
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Pricing',
                  style: TossPageStyles.sectionTitleStyle,
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Sale Price
            TossTextField(
              label: 'Sale price${metadata?.currency?.symbol != null ? ' (${metadata?.currency?.symbol})' : ''}',
              hintText: '0',
              controller: _salePriceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CommaNumberInputFormatter(),
              ],
              validator: (value) => _validatePrice(value, isRequired: metadata?.validationRules?.minPriceRequired ?? false),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Cost Price
            TossTextField(
              label: 'Cost of goods${metadata?.currency?.symbol != null ? ' (${metadata?.currency?.symbol})' : ''}',
              hintText: '0',
              controller: _costPriceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CommaNumberInputFormatter(),
              ],
              validator: _validatePrice,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventorySection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossPageStyles.card(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            // Section Header
            Row(
              children: [
                FaIcon(
                  AppIcons.inventory,
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Inventory',
                  style: TossPageStyles.sectionTitleStyle,
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // On-hand Quantity
            TossTextField(
              label: 'On-hand quantity',
              hintText: '0',
              controller: _onHandController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CommaNumberInputFormatter(),
              ],
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: TossColors.gray400,
                  size: TossSpacing.iconSM,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Current stock quantity available'),
                      backgroundColor: TossColors.gray700,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Weight
            TossTextField(
              label: 'Weight (g)',
              hintText: '0',
              controller: _weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CommaNumberInputFormatter(),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Unit Selection
            _buildSelectionRow(
              label: 'Unit',
              value: _selectedUnit,
              placeholder: 'Select unit',
              onTap: () async {
                final units = metadata?.units ?? ['piece', 'kg', 'g', 'liter', 'ml', 'box', 'pack'];
                
                final items = units.map((unit) => 
                  TossSelectionItem.fromGeneric(
                    id: unit,
                    title: unit,
                  )
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
              },
            ),
            
          ],
        ),
      ),
    );
  }


  Widget _buildSelectionRow({
    required String label,
    required String? value,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: TossColors.gray100,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TossPageStyles.labelStyle.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              value ?? placeholder,
              style: TossPageStyles.valueStyle.copyWith(
                color: value != null ? TossColors.gray900 : TossColors.gray400,
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: TossSpacing.iconXS,
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Add product',
        backgroundColor: TossColors.gray100,
        primaryActionText: _isLoading ? 'Saving...' : 'Save',
        onPrimaryAction: _isLoading ? null : _saveProduct,
        leading: IconButton(
          icon: const Icon(Icons.close, size: TossSpacing.iconMD),
          onPressed: _isLoading ? null : () => NavigationHelper.safeGoBack(context),
        ),
      ),
      body: TossFormWrapper(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Image Upload Section
                _buildImageUploadSection(),
                
                SizedBox(height: TossSpacing.space2),
                
                // Product Information Section
                _buildProductInfoSection(),
                
                SizedBox(height: TossSpacing.space2),
                
                // Classification Section
                _buildClassificationSection(),
                
                SizedBox(height: TossSpacing.space2),
                
                // Pricing Section
                _buildPricingSection(),
                
                SizedBox(height: TossSpacing.space2),
                
                // Inventory Section
                _buildInventorySection(),
                
                SizedBox(height: TossSpacing.space2),
                
                
                SizedBox(height: TossSpacing.space24 * 4), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Separate StatefulWidget for the dialog to properly manage state and listeners
class _CategoryCreationDialog extends StatefulWidget {
  final InventoryMetadata? metadata;
  final void Function(Map<String, dynamic>) onCategoryCreated;
  final WidgetRef ref;
  final InventoryService inventoryService;

  const _CategoryCreationDialog({
    Key? key,
    required this.metadata,
    required this.onCategoryCreated,
    required this.ref,
    required this.inventoryService,
  }) : super(key: key);

  @override
  State<_CategoryCreationDialog> createState() => _CategoryCreationDialogState();
}

class _CategoryCreationDialogState extends State<_CategoryCreationDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedParentCategoryId;
  bool _isCreating = false;
  bool _isNameEmpty = true;

  @override
  void initState() {
    super.initState();
    // Add listener only once in initState
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    // Properly dispose of controller and remove listener
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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
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
            SizedBox(height: TossSpacing.space2),
            TossTextField(
              label: null,
              hintText: 'Enter category name',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Category name is required';
                }
                return null;
              },
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Parent Category Selection
            Text(
              'Parent Category (Optional)',
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            InkWell(
              onTap: _isCreating ? null : () async {
                final categories = widget.metadata?.categories ?? [];
                if (categories.isNotEmpty) {
                  final items = categories.map((category) => 
                    TossSelectionItem.fromGeneric(
                      id: category.id,
                      title: category.name,
                      subtitle: category.productCount != null 
                          ? '${category.productCount} products'
                          : null,
                    )
                  ).toList();
                  
                  await TossSelectionBottomSheet.show<String>(
                    context: context,
                    title: 'Parent Category',
                    items: items,
                    selectedId: _selectedParentCategoryId,
                    showSubtitle: true,
                    onItemSelected: (item) {
                      setState(() {
                        _selectedParentCategoryId = item.id;
                      });
                    },
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space3,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: TossColors.gray300),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedParentCategoryId != null
                            ? widget.metadata?.categories.firstWhere(
                                (cat) => cat.id == _selectedParentCategoryId,
                                orElse: () => Category(id: '', name: 'Unknown'),
                              ).name ?? 'Unknown'
                            : 'Select parent category (optional)',
                        style: TossTextStyles.body.copyWith(
                          color: _selectedParentCategoryId != null 
                              ? TossColors.gray900 
                              : TossColors.gray400,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: TossColors.gray400,
                      size: TossSpacing.iconXS,
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
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: ElevatedButton(
                onPressed: (_isCreating || _isNameEmpty) ? null : () async {
                  if (_nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Category name is required'),
                        backgroundColor: TossColors.error,
                      ),
                    );
                    return;
                  }

                  setState(() {
                    _isCreating = true;
                  });

                  try {
                    final appState = widget.ref.read(appStateProvider);
                    final companyId = appState.companyChoosen;

                    if (companyId.isEmpty) {
                      throw Exception('Company not selected');
                    }

                    final result = await widget.inventoryService.createCategory(
                      companyId: companyId,
                      categoryName: _nameController.text.trim(),
                      parentCategoryId: _selectedParentCategoryId,
                    );

                    if (result != null) {
                      // Check if result contains the success wrapper
                      if (result.containsKey('success') && result['success'] == true) {
                        // Success - call the callback with the data
                        final data = result['data'];
                        if (data is Map<String, dynamic>) {
                          widget.onCategoryCreated(data);
                        } else {
                          widget.onCategoryCreated(result);
                        }
                      } else if (result.containsKey('category_id')) {
                        // Direct data response
                        widget.onCategoryCreated(result);
                      } else {
                        throw Exception('Failed to create category');
                      }
                    } else {
                      throw Exception('Failed to create category');
                    }
                  } catch (e) {
                    setState(() {
                      _isCreating = false;
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create category: ${e.toString()}'),
                        backgroundColor: TossColors.error,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  foregroundColor: TossColors.white,
                ),
                child: _isCreating
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: TossColors.white,
                        ),
                      )
                    : Text(
                        'Create',
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Custom input formatter for adding commas to numbers
class _CommaNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all commas from the text
    final numericText = newValue.text.replaceAll(',', '');
    
    // Parse the number and format with commas
    final number = int.tryParse(numericText);
    if (number == null) {
      return oldValue;
    }
    
    final formattedText = NumberFormatter.formatWithCommas(number);
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

// Separate StatefulWidget for the brand creation dialog to properly manage state and listeners
class _BrandCreationDialog extends StatefulWidget {
  final InventoryMetadata? metadata;
  final void Function(Map<String, dynamic>) onBrandCreated;
  final WidgetRef ref;
  final InventoryService inventoryService;

  const _BrandCreationDialog({
    Key? key,
    required this.metadata,
    required this.onBrandCreated,
    required this.ref,
    required this.inventoryService,
  }) : super(key: key);

  @override
  State<_BrandCreationDialog> createState() => _BrandCreationDialogState();
}

class _BrandCreationDialogState extends State<_BrandCreationDialog> {
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _brandCodeController = TextEditingController();
  bool _isCreateButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _brandNameController.addListener(_onBrandNameChanged);
  }

  @override
  void dispose() {
    _brandNameController.removeListener(_onBrandNameChanged);
    _brandNameController.dispose();
    _brandCodeController.dispose();
    super.dispose();
  }

  void _onBrandNameChanged() {
    setState(() {
      _isCreateButtonEnabled = _brandNameController.text.trim().isNotEmpty;
    });
  }

  Future<void> _createBrand() async {
    if (!_isCreateButtonEnabled || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final appState = widget.ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId == null) {
        _showError('Company not selected');
        return;
      }

      final brandName = _brandNameController.text.trim();
      final brandCode = _brandCodeController.text.trim().isEmpty 
          ? null 
          : _brandCodeController.text.trim();

      print('🔄 Creating brand: $brandName, code: $brandCode');

      final result = await widget.inventoryService.createBrand(
        companyId: companyId,
        brandName: brandName,
        brandCode: brandCode,
      );

      if (result != null) {
        // Check if the result indicates success or failure
        if (result['success'] == false) {
          // Handle specific error from server
          final error = result['error'] as Map<String, dynamic>?;
          String errorMessage = 'Failed to create brand';
          
          if (error != null) {
            final code = error['code'] as String?;
            final message = error['message'] as String?;
            final details = error['details'] as Map<String, dynamic>?;
            
            if (code == 'DUPLICATE_BRAND' && details != null) {
              final existingName = details['existing_brand_name'] as String?;
              errorMessage = 'Brand name "${existingName ?? brandName}" already exists. Please choose a different name.';
            } else if (message != null) {
              errorMessage = message;
            }
          }
          
          _showError(errorMessage);
          return;
        }
        
        // Success case
        print('✅ Brand created successfully: $result');
        widget.onBrandCreated(result);
        
        if (mounted) {
          Navigator.of(context).pop();
          _showSuccess('Brand created successfully');
        }
      } else {
        _showError('Failed to create brand');
      }
    } catch (e) {
      print('❌ Error creating brand: $e');
      _showError('Error creating brand: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Brand',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: TossColors.gray600),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Brand Name Input
            TossTextField(
              label: 'Brand name *',
              hintText: 'Enter brand name',
              controller: _brandNameController,
              enabled: !_isLoading,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Brand name is required';
                }
                return null;
              },
            ),
            
            SizedBox(height: TossSpacing.space3),
            
            // Brand Code Input
            TossTextField(
              label: 'Brand code (optional)',
              hintText: 'Enter brand code or leave empty for auto-generation',
              controller: _brandCodeController,
              enabled: !_isLoading,
              validator: (value) {
                // Optional field, no validation needed
                return null;
              },
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TossButton.secondary(
                    text: 'Cancel',
                    onPressed: _isLoading 
                        ? null 
                        : () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: TossButton.primary(
                    text: _isLoading ? 'Creating...' : 'Create',
                    onPressed: _isCreateButtonEnabled && !_isLoading 
                        ? _createBrand 
                        : null,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}