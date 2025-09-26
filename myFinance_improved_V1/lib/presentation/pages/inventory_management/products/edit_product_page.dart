import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/index.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../widgets/toss/toss_bottom_sheet.dart';
import '../../../widgets/common/toss_white_card.dart';
import '../../../widgets/common/toss_section_header.dart';
import '../../../widgets/toss/toss_text_field.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../helpers/navigation_helper.dart';
import '../models/product_model.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import '../providers/inventory_providers.dart';
import '../../../../data/models/inventory_models.dart' as inv_models;
import '../../../providers/app_state_provider.dart';
class EditProductPage extends ConsumerStatefulWidget {
  final Product product;
  final inv_models.Currency? currency;
  
  const EditProductPage({
    Key? key,
    required this.product,
    this.currency,
  }) : super(key: key);

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _skuController;
  late TextEditingController _barcodeController;
  late TextEditingController _nameController;
  late TextEditingController _costPriceController;
  late TextEditingController _salePriceController;
  late TextEditingController _onHandController;
  late TextEditingController _minStockController;
  late TextEditingController _maxStockController;
  
  // Selected values
  late ProductCategory? _selectedCategory;
  late String? _selectedCategoryName;
  late String? _selectedBrand;
  late String? _selectedUnit;
  late ProductType _selectedType;
  late String? _selectedTypeName;
  late bool _isActive;
  
  // State tracking
  bool _isLoading = false;
  bool _hasChanges = false;
  Map<String, dynamic> _originalValues = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _saveOriginalValues();
  }

  void _initializeControllers() {
    final product = widget.product;
    
    _skuController = TextEditingController(text: product.sku);
    _barcodeController = TextEditingController(text: product.barcode ?? '');
    _nameController = TextEditingController(text: product.name);
    _costPriceController = TextEditingController(
      text: product.costPrice.toStringAsFixed(0),
    );
    _salePriceController = TextEditingController(
      text: product.salePrice.toStringAsFixed(0),
    );
    _onHandController = TextEditingController(text: product.onHand.toString());
    _minStockController = TextEditingController(
      text: (product.minStock ?? 0).toString(),
    );
    _maxStockController = TextEditingController(
      text: (product.maxStock ?? 100).toString(),
    );
    
    _selectedCategory = product.category;
    // Use description field for category name from RPC
    _selectedCategoryName = product.description;
    _selectedBrand = product.brand;
    _selectedUnit = product.unit;
    _selectedType = product.productType;
    // Initialize product type name based on enum value
    if (product.productType == ProductType.simple) {
      _selectedTypeName = 'commodity';
    } else if (product.productType == ProductType.bundle) {
      _selectedTypeName = 'bundle';
    } else if (product.productType == ProductType.digital) {
      _selectedTypeName = 'service';
    } else {
      _selectedTypeName = 'commodity'; // default
    }
    _isActive = product.isActive;
    
    // Add listeners to track changes
    _addChangeListeners();
  }

  void _saveOriginalValues() {
    _originalValues = {
      'sku': _skuController.text,
      'barcode': _barcodeController.text,
      'name': _nameController.text,
      'costPrice': _costPriceController.text,
      'salePrice': _salePriceController.text,
      'onHand': _onHandController.text,
      'minStock': _minStockController.text,
      'maxStock': _maxStockController.text,
      'category': _selectedCategory,
      'categoryName': _selectedCategoryName,
      'brand': _selectedBrand,
      'unit': _selectedUnit,
      'type': _selectedType,
      'typeName': _selectedTypeName,
      'isActive': _isActive,
    };
  }

  void _addChangeListeners() {
    _skuController.addListener(_checkForChanges);
    _barcodeController.addListener(_checkForChanges);
    _nameController.addListener(_checkForChanges);
    _costPriceController.addListener(_checkForChanges);
    _salePriceController.addListener(_checkForChanges);
    _onHandController.addListener(_checkForChanges);
    _minStockController.addListener(_checkForChanges);
    _maxStockController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final hasFieldChanges = 
        _skuController.text != _originalValues['sku'] ||
        _barcodeController.text != _originalValues['barcode'] ||
        _nameController.text != _originalValues['name'] ||
        _costPriceController.text != _originalValues['costPrice'] ||
        _salePriceController.text != _originalValues['salePrice'] ||
        _onHandController.text != _originalValues['onHand'] ||
        _minStockController.text != _originalValues['minStock'] ||
        _maxStockController.text != _originalValues['maxStock'] ||
        _selectedCategory != _originalValues['category'] ||
        _selectedCategoryName != _originalValues['categoryName'] ||
        _selectedBrand != _originalValues['brand'] ||
        _selectedUnit != _originalValues['unit'] ||
        _selectedType != _originalValues['type'] ||
        _selectedTypeName != _originalValues['typeName'] ||
        _isActive != _originalValues['isActive'];
    
    setState(() => _hasChanges = hasFieldChanges);
  }


  @override
  void dispose() {
    _skuController.dispose();
    _barcodeController.dispose();
    _nameController.dispose();
    _costPriceController.dispose();
    _salePriceController.dispose();
    _onHandController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    super.dispose();
  }



  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fix validation errors'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }

    if (!_hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No changes to save'),
          backgroundColor: TossColors.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Get company and store ID from app state
      final appState = ref.read(appStateProvider);
      final service = ref.read(inventoryServiceProvider);
      
      String? companyId = appState.companyChoosen as String?;
      String? storeId = appState.storeChoosen as String?;
      
      if (companyId == null || storeId == null) {
        throw Exception('Company or store not selected');
      }
      
      // Get category and brand IDs from metadata
      String? categoryId;
      String? brandId;
      
      final metadataAsync = ref.read(inventoryMetadataProvider);
      metadataAsync.whenData((metadata) {
        if (metadata != null) {
          // Find category ID by name
          if (_selectedCategoryName != null) {
            final category = metadata.categories.firstWhere(
              (c) => c.name == _selectedCategoryName,
              orElse: () => metadata.categories.firstWhere(
                (c) => c.name.toLowerCase() == 'other',
                orElse: () => metadata.categories.first,
              ),
            );
            categoryId = category.id;
          }
          
          // Find brand ID by name
          if (_selectedBrand != null) {
            final brand = metadata.brands.firstWhere(
              (b) => b.name == _selectedBrand,
              orElse: () => metadata.brands.first,
            );
            brandId = brand.id;
          }
        }
      });
      
      // Call the edit product RPC
      final result = await service.editProduct(
        productId: widget.product.id,
        companyId: companyId,
        storeId: storeId,
        sku: _skuController.text,
        productName: _nameController.text,
        barcode: _barcodeController.text.isEmpty ? null : _barcodeController.text,
        categoryId: categoryId,
        brandId: brandId,
        unit: _selectedUnit ?? 'piece',
        productType: _selectedTypeName ?? 'commodity',
        costPrice: double.tryParse(_costPriceController.text.replaceAll(',', '')),
        salePrice: double.tryParse(_salePriceController.text.replaceAll(',', '')),
        onHand: int.tryParse(_onHandController.text),
        minStock: int.tryParse(_minStockController.text),
        maxStock: int.tryParse(_maxStockController.text),
        isActive: _isActive,
        description: null, // description is not used for editing
      );

      if (result != null) {
        // Check if the response indicates success
        if (result['success'] == true) {
          // Prepare the updated product before showing dialog
          final updatedProduct = Product(
            id: widget.product.id,
            sku: _skuController.text,
            barcode: _barcodeController.text.isEmpty ? null : _barcodeController.text,
            name: _nameController.text,
            nameEn: null, // English name not supported in RPC
            category: _selectedCategory!,
            brand: _selectedBrand,
            productType: _selectedType,
            unit: _selectedUnit ?? 'piece',
            costPrice: double.parse(_costPriceController.text.replaceAll(',', '')),
            salePrice: double.parse(_salePriceController.text.replaceAll(',', '')),
            minPrice: null, // Min price not supported in RPC
            onHand: int.parse(_onHandController.text),
            minStock: int.tryParse(_minStockController.text) ?? 0,
            maxStock: int.tryParse(_maxStockController.text) ?? 100,
            reorderPoint: null, // Not supported in RPC
            reorderQuantity: null, // Not supported in RPC
            weight: null, // Weight not supported in RPC
            location: null, // Location not supported in RPC
            description: _selectedCategoryName, // Pass category name via description
            images: widget.product.images, // Keep original images
            isActive: _isActive,
            sellInStore: widget.product.sellInStore, // Keep original value
          );
          
          // Show success popup
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.dialog),
              ),
              child: Container(
                padding: EdgeInsets.all(TossSpacing.space6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success Icon with Animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 600),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            width: TossSpacing.space20,
                            height: TossSpacing.space20,
                            decoration: BoxDecoration(
                              color: TossColors.success.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: TossColors.success,
                              size: TossSpacing.space12,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: TossSpacing.space4),
                    
                    Text(
                      'Product Updated!',
                      style: TossTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space2),
                    
                    Text(
                      _nameController.text,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    // Done Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TossColors.primary,
                          padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.button),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Done',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          
          // Refresh inventory list
          ref.invalidate(inventoryPageProvider);
          
          // Navigate back with updated product
          if (mounted) {
            Navigator.pop(context, updatedProduct);
          }
        } else {
          // Handle error response from RPC
          final error = result['error'] as Map<String, dynamic>?;
          String errorMessage = 'Error updating product';
          
          if (error != null) {
            final errorCode = error['code'] as String?;
            final errorMsg = error['message'] as String?;
            
            // Handle specific error codes with user-friendly messages
            switch (errorCode) {
              case 'PRODUCT_NAME_DUPLICATE':
                errorMessage = 'This product name already exists. Please choose a different name.';
                break;
                
              case 'SKU_DUPLICATE':
                errorMessage = 'This Product Code (SKU) is already in use. Please enter a unique Product Code.';
                break;
                
              case 'PRODUCT_NOT_FOUND':
                errorMessage = 'Product not found. It may have been deleted by another user.';
                // Navigate back since product doesn't exist
                if (mounted) {
                  Navigator.pop(context);
                }
                break;
                
              case 'INVALID_REFERENCE':
                errorMessage = 'Invalid category or brand selected. Please select valid options.';
                break;
                
              case 'VALIDATION_ERROR':
                // Check if it's specifically about product_type
                if (errorMsg != null && errorMsg.contains('product_type')) {
                  errorMessage = 'Invalid product type. Please select Commodity, Service, or Bundle.';
                } else {
                  errorMessage = 'Invalid data provided. Please check your input and try again.';
                }
                break;
                
              case 'UPDATE_ERROR':
                errorMessage = errorMsg ?? 'An error occurred while updating the product. Please try again.';
                break;
                
              case 'EXCEPTION':
              case 'NO_RESPONSE':
                errorMessage = 'Connection error. Please check your internet connection and try again.';
                break;
                
              default:
                errorMessage = errorMsg ?? 'An unexpected error occurred. Please try again.';
                break;
            }
          }
          
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: TossColors.white),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(child: Text(errorMessage)),
                ],
              ),
              backgroundColor: TossColors.error,
              duration: Duration(seconds: 4),
            ),
          );
        }
      } else {
        // This should not happen since service always returns a response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error. Please try again.'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } catch (e) {
      // Handle unexpected exceptions (this should be rare now)
      print('Unexpected error in _saveChanges: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred. Please try again.'),
          backgroundColor: TossColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unsaved Changes'),
        content: Text('You have unsaved changes. Do you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Discard', style: TossTextStyles.body.copyWith(color: TossColors.error)),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: TossColors.gray100,
        appBar: AppBar(
          title: Text(
            'Edit Product',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: TossColors.gray100,
          foregroundColor: TossColors.black,
          leading: IconButton(
            icon: Icon(TossIcons.close),
            onPressed: () async {
              if (await _onWillPop()) {
                NavigationHelper.safeGoBack(context);
              }
            },
          ),
          actions: [
            if (_hasChanges)
              TextButton(
                onPressed: () {
                  _initializeControllers();
                  _saveOriginalValues();
                },
                child: Text(
                  'Reset',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: TossSpacing.space3),
                
                // Basic Info Section
                _buildBasicInfoSection(),
                
                SizedBox(height: TossSpacing.space2),
                
                // Pricing Section
                _buildPricingSection(),
                
                SizedBox(height: TossSpacing.space2),
                
                // Inventory Section
                _buildInventorySection(),
                
                SizedBox(height: TossSpacing.space2),
                
                // Details Section
                _buildDetailsSection(),
                
                SizedBox(height: 120), // Bottom padding for fixed button
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.surface,
            border: Border(
              top: BorderSide(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: TossPrimaryButton(
              text: _isLoading ? 'Saving...' : 'Save Changes',
              onPressed: _hasChanges ? _saveChanges : null,
              isLoading: _isLoading,
              isEnabled: _hasChanges && !_isLoading,
              fullWidth: true,
              leadingIcon: _hasChanges && !_isLoading ? Icon(
                Icons.check_circle_outline,
                color: TossColors.white,
                size: TossSpacing.iconSM,
              ) : null,
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _buildBasicInfoSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          TossSectionHeader(
            title: 'Basic Information',
            icon: Icons.info_outline,
          ),
          
          SizedBox(height: TossSpacing.space2),
          
          TossWhiteCard(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Code (formerly SKU)
                TossTextField(
                  label: 'Product Code *',
                  hintText: 'Enter product code',
                  controller: _skuController,
                  isImportant: true, // Bold emphasis
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product code is required';
                    }
                    return null;
                  },
                  onChanged: (_) => _checkForChanges(),
                ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Barcode
              TossTextField(
                label: 'Barcode',
                hintText: 'Enter barcode',
                controller: _barcodeController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _checkForChanges(),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Product Name
              TossTextField(
                label: 'Product Name *',
                hintText: 'Enter product name',
                controller: _nameController,
                isImportant: true, // Bold emphasis
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product name is required';
                  }
                  return null;
                },
                onChanged: (_) => _checkForChanges(),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
                // Category Selector
                GestureDetector(
                  onTap: () => _selectCategory(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(color: TossColors.gray200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          color: TossColors.gray600,
                          size: TossSpacing.iconSM,
                        ),
                        SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Category *',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                _selectedCategoryName ?? _selectedCategory?.displayName ?? 'Select category',
                                style: TossTextStyles.body.copyWith(
                                  color: _selectedCategoryName != null || _selectedCategory != null
                                      ? TossColors.gray900
                                      : TossColors.gray400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: TossColors.gray500,
                          size: TossSpacing.iconSM,
                        ),
                      ],
                    ),
                  ),
                ),
              
              SizedBox(height: TossSpacing.space4),
              
                
                SizedBox(height: TossSpacing.space4),
                
                // Brand Selector
                GestureDetector(
                  onTap: () => _selectBrand(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(color: TossColors.gray200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.branding_watermark_outlined,
                          color: TossColors.gray600,
                          size: TossSpacing.iconSM,
                        ),
                        SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Brand',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                _selectedBrand ?? 'Select brand (optional)',
                                style: TossTextStyles.body.copyWith(
                                  color: _selectedBrand != null
                                      ? TossColors.gray900
                                      : TossColors.gray400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: TossColors.gray500,
                          size: TossSpacing.iconSM,
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: TossSpacing.space4),
                
                // Unit Selector  
                GestureDetector(
                  onTap: () => _selectUnit(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(color: TossColors.gray200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.straighten,
                          color: TossColors.gray600,
                          size: TossSpacing.iconSM,
                        ),
                        SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unit',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                _selectedUnit ?? 'piece',
                                style: TossTextStyles.body.copyWith(
                                  color: _selectedUnit != null
                                      ? TossColors.gray900
                                      : TossColors.gray400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: TossColors.gray500,
                          size: TossSpacing.iconSM,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    final margin = _calculateMargin();
    final markup = _calculateMarkup();
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          TossSectionHeader(
            title: 'Pricing',
            icon: Icons.monetization_on_outlined,
            iconColor: TossColors.success,
          ),
          
          SizedBox(height: TossSpacing.space2),
          
          TossWhiteCard(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pricing Metrics
                Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Margin',
                      '${margin.toStringAsFixed(1)}%',
                      margin > 30 ? TossColors.success : TossColors.warning,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: _buildMetricCard(
                      'Markup',
                      '${markup.toStringAsFixed(1)}%',
                      markup > 50 ? TossColors.success : TossColors.warning,
                    ),
                  ),
                ],
                ),
                
                SizedBox(height: TossSpacing.space4),
                
                // Cost Price with comma formatting
                TossTextField(
                  label: 'Cost Price *',
                  hintText: '₩ Enter cost price',
                  controller: _costPriceController,
                  isImportant: true, // Bold emphasis
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _CommaNumberInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Cost price is required';
                    }
                    return null;
                  },
                  onChanged: (_) => _checkForChanges(),
                ),
                
                SizedBox(height: TossSpacing.space4),
                
                // Sale Price with comma formatting
                TossTextField(
                  label: 'Sale Price *',
                  hintText: '₩ Enter sale price',
                  controller: _salePriceController,
                  isImportant: true, // Bold emphasis
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _CommaNumberInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Sale price is required';
                    }
                    final price = double.tryParse(value.replaceAll(',', '')) ?? 0;
                    final cost = double.tryParse(_costPriceController.text.replaceAll(',', '')) ?? 0;
                    if (price < cost) {
                      return 'Sale price must be higher than cost';
                    }
                    return null;
                  },
                  onChanged: (_) => _checkForChanges(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          TossSectionHeader(
            title: 'Inventory',
            icon: Icons.inventory_2_outlined,
            iconColor: TossColors.warning,
          ),
          
          SizedBox(height: TossSpacing.space2),
          
          TossWhiteCard(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stock Status Indicator
                _buildStockStatusCard(),
              
              SizedBox(height: TossSpacing.space4),
              
              // Current Stock
              TossTextField(
                label: 'Current Stock * (${_selectedUnit ?? 'units'})',
                hintText: 'Enter current stock quantity',
                controller: _onHandController,
                isImportant: true, // Bold emphasis
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Current stock is required';
                  }
                  return null;
                },
                onChanged: (_) => _checkForChanges(),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Min/Max Stock Row
              Row(
                children: [
                  Expanded(
                    child: TossTextField(
                      label: 'Min Stock',
                      hintText: '0',
                      controller: _minStockController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => _checkForChanges(),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: TossTextField(
                      label: 'Max Stock',
                      hintText: '100',
                      controller: _maxStockController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => _checkForChanges(),
                    ),
                  ),
                ],
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          TossSectionHeader(
            title: 'Details',
            icon: Icons.description_outlined,
          ),
          
          SizedBox(height: TossSpacing.space2),
          
          TossWhiteCard(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Type Chips
                Consumer(
                  builder: (context, ref, child) {
                    final metadataAsync = ref.watch(inventoryMetadataProvider);
                    
                    return metadataAsync.when(
                      data: (metadata) {
                        final productTypes = metadata?.productTypes ?? [];
                        
                        // Always use fixed product types from database constraints
                        // Ignore metadata product types since database has CHECK constraint
                        
                        // Use fixed product types from database constraints
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Type',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.gray900,
                              ),
                            ),
                            SizedBox(height: TossSpacing.space2),
                            Wrap(
                              spacing: TossSpacing.space2,
                              children: [
                                ChoiceChip(
                                  label: Text('Commodity'),
                                  selected: _selectedTypeName == 'commodity' || (_selectedTypeName == null && _selectedType == ProductType.simple),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedTypeName = 'commodity';
                                        _selectedType = ProductType.simple;
                                        _checkForChanges();
                                      });
                                    }
                                  },
                                  selectedColor: TossColors.primary.withValues(alpha: 0.1),
                                  backgroundColor: TossColors.gray50,
                                  side: BorderSide(
                                    color: (_selectedTypeName == 'commodity' || (_selectedTypeName == null && _selectedType == ProductType.simple)) ? TossColors.primary : TossColors.gray200,
                                  ),
                                  labelStyle: TossTextStyles.body.copyWith(
                                    color: (_selectedTypeName == 'commodity' || (_selectedTypeName == null && _selectedType == ProductType.simple))
                                        ? TossColors.primary
                                        : TossColors.gray700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ChoiceChip(
                                  label: Text('Service'),
                                  selected: _selectedTypeName == 'service',
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedTypeName = 'service';
                                        _selectedType = ProductType.digital;
                                        _checkForChanges();
                                      });
                                    }
                                  },
                                  selectedColor: TossColors.primary.withValues(alpha: 0.1),
                                  backgroundColor: TossColors.gray50,
                                  side: BorderSide(
                                    color: _selectedTypeName == 'service' ? TossColors.primary : TossColors.gray200,
                                  ),
                                  labelStyle: TossTextStyles.body.copyWith(
                                    color: _selectedTypeName == 'service'
                                        ? TossColors.primary
                                        : TossColors.gray700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ChoiceChip(
                                  label: Text('Bundle'),
                                  selected: _selectedTypeName == 'bundle' || _selectedType == ProductType.bundle,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedTypeName = 'bundle';
                                        _selectedType = ProductType.bundle;
                                        _checkForChanges();
                                      });
                                    }
                                  },
                                  selectedColor: TossColors.primary.withValues(alpha: 0.1),
                                  backgroundColor: TossColors.gray50,
                                  side: BorderSide(
                                    color: (_selectedTypeName == 'bundle' || _selectedType == ProductType.bundle) ? TossColors.primary : TossColors.gray200,
                                  ),
                                  labelStyle: TossTextStyles.body.copyWith(
                                    color: (_selectedTypeName == 'bundle' || _selectedType == ProductType.bundle)
                                        ? TossColors.primary
                                        : TossColors.gray700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      loading: () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Type',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                          ),
                          SizedBox(height: TossSpacing.space2),
                          CircularProgressIndicator(),
                        ],
                      ),
                      error: (error, stack) {
                        // Use fixed product types from database constraints
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Type',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.gray900,
                              ),
                            ),
                            SizedBox(height: TossSpacing.space2),
                            Wrap(
                              spacing: TossSpacing.space2,
                              children: [
                                ChoiceChip(
                                  label: Text('Commodity'),
                                  selected: _selectedTypeName == 'commodity' || (_selectedTypeName == null && _selectedType == ProductType.simple),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedTypeName = 'commodity';
                                        _selectedType = ProductType.simple;
                                        _checkForChanges();
                                      });
                                    }
                                  },
                                  selectedColor: TossColors.primary.withValues(alpha: 0.1),
                                  backgroundColor: TossColors.gray50,
                                  side: BorderSide(
                                    color: (_selectedTypeName == 'commodity' || (_selectedTypeName == null && _selectedType == ProductType.simple)) ? TossColors.primary : TossColors.gray200,
                                  ),
                                  labelStyle: TossTextStyles.body.copyWith(
                                    color: (_selectedTypeName == 'commodity' || (_selectedTypeName == null && _selectedType == ProductType.simple))
                                        ? TossColors.primary
                                        : TossColors.gray700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ChoiceChip(
                                  label: Text('Service'),
                                  selected: _selectedTypeName == 'service',
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedTypeName = 'service';
                                        _selectedType = ProductType.digital;
                                        _checkForChanges();
                                      });
                                    }
                                  },
                                  selectedColor: TossColors.primary.withValues(alpha: 0.1),
                                  backgroundColor: TossColors.gray50,
                                  side: BorderSide(
                                    color: _selectedTypeName == 'service' ? TossColors.primary : TossColors.gray200,
                                  ),
                                  labelStyle: TossTextStyles.body.copyWith(
                                    color: _selectedTypeName == 'service'
                                        ? TossColors.primary
                                        : TossColors.gray700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ChoiceChip(
                                  label: Text('Bundle'),
                                  selected: _selectedTypeName == 'bundle' || _selectedType == ProductType.bundle,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedTypeName = 'bundle';
                                        _selectedType = ProductType.bundle;
                                        _checkForChanges();
                                      });
                                    }
                                  },
                                  selectedColor: TossColors.primary.withValues(alpha: 0.1),
                                  backgroundColor: TossColors.gray50,
                                  side: BorderSide(
                                    color: (_selectedTypeName == 'bundle' || _selectedType == ProductType.bundle) ? TossColors.primary : TossColors.gray200,
                                  ),
                                  labelStyle: TossTextStyles.body.copyWith(
                                    color: (_selectedTypeName == 'bundle' || _selectedType == ProductType.bundle)
                                        ? TossColors.primary
                                        : TossColors.gray700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              
              SizedBox(height: TossSpacing.space4),
              
                
                SizedBox(height: TossSpacing.space4),
                
                // Settings Switches
                Container(
                  padding: EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Active Product',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.gray900,
                          ),
                        ),
                        subtitle: Text(
                          'Product is available for sale',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                            _checkForChanges();
                          });
                        },
                        activeColor: TossColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.h4.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockStatusCard() {
    final current = int.tryParse(_onHandController.text) ?? 0;
    final minStock = int.tryParse(_minStockController.text) ?? 0;
    
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    if (current == 0) {
      statusColor = TossColors.error;
      statusText = 'Out of Stock';
      statusIcon = Icons.error_outline;
    } else if (current <= minStock) {
      statusColor = TossColors.warning;
      statusText = 'Low Stock';
      statusIcon = Icons.warning_amber;
    } else {
      statusColor = TossColors.success;
      statusText = 'Stock Level OK';
      statusIcon = Icons.check_circle_outline;
    }
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: TossSpacing.space10,
            height: TossSpacing.space10,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(statusIcon, color: statusColor, size: TossSpacing.iconSM),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TossTextStyles.body.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Current: $current units',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMargin() {
    final cost = double.tryParse(_costPriceController.text.replaceAll(',', '')) ?? 0;
    final sale = double.tryParse(_salePriceController.text.replaceAll(',', '')) ?? 0;
    if (cost == 0 || sale == 0) return 0;
    return ((sale - cost) / sale) * 100;
  }

  double _calculateMarkup() {
    final cost = double.tryParse(_costPriceController.text.replaceAll(',', '')) ?? 0;
    final sale = double.tryParse(_salePriceController.text.replaceAll(',', '')) ?? 0;
    if (cost == 0) return 0;
    return ((sale - cost) / cost) * 100;
  }

  
  void _selectCategory() {
    // Get metadata from provider
    final metadataAsync = ref.read(inventoryMetadataProvider);
    
    metadataAsync.when(
      data: (metadata) {
        if (metadata == null) {
          // Fallback to enum values if no metadata
          final categoryItems = ProductCategory.values.map((category) => 
            TossSelectionItem(
              id: category.name,
              title: category.displayName,
            ),
          ).toList();
          
          TossSelectionBottomSheet.show(
            context: context,
            title: 'Select Category',
            items: categoryItems,
            selectedId: _selectedCategory?.name,
            onItemSelected: (item) {
              final category = ProductCategory.values.firstWhere(
                (c) => c.name == item.id,
              );
              setState(() {
                _selectedCategory = category;
                _selectedCategoryName = category.displayName;
                _checkForChanges();
              });
            },
          );
        } else {
          // Use categories from RPC metadata
          final categoryItems = metadata.categories.map((category) => 
            TossSelectionItem(
              id: category.id,
              title: category.name,
            ),
          ).toList();
          
          // Add "Other" option if not in list
          if (!categoryItems.any((item) => item.title.toLowerCase() == 'other')) {
            categoryItems.add(TossSelectionItem(
              id: 'other',
              title: 'Other',
            ));
          }
          
          TossSelectionBottomSheet.show(
            context: context,
            title: 'Select Category',
            items: categoryItems,
            selectedId: _selectedCategoryName,
            onItemSelected: (item) {
              setState(() {
                _selectedCategoryName = item.title;
                // Map to enum value or default to other
                _selectedCategory = ProductCategory.values.firstWhere(
                  (c) => c.displayName.toLowerCase() == item.title.toLowerCase(),
                  orElse: () => ProductCategory.other,
                );
                _checkForChanges();
              });
            },
          );
        }
      },
      loading: () {
        // Show loading while fetching metadata
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loading categories...')),
        );
      },
      error: (error, stack) {
        // Fallback to enum values on error
        final categoryItems = ProductCategory.values.map((category) => 
          TossSelectionItem(
            id: category.name,
            title: category.displayName,
          ),
        ).toList();
        
        TossSelectionBottomSheet.show(
          context: context,
          title: 'Select Category',
          items: categoryItems,
          selectedId: _selectedCategory?.name,
          onItemSelected: (item) {
            final category = ProductCategory.values.firstWhere(
              (c) => c.name == item.id,
            );
            setState(() {
              _selectedCategory = category;
              _selectedCategoryName = category.displayName;
              _checkForChanges();
            });
          },
        );
      },
    );
  }
  
  void _selectBrand() {
    // Get metadata from provider
    final metadataAsync = ref.read(inventoryMetadataProvider);
    
    metadataAsync.when(
      data: (metadata) {
        if (metadata == null || metadata.brands.isEmpty) {
          // Fallback to hardcoded brands if no metadata
          final brands = [
            'GOYARD', 'PRADA', 'LOUIS VUITTON', 'CHANEL', 'HERMES',
            'GUCCI', 'DIOR', 'FENDI', 'BALENCIAGA', 'CELINE'
          ];
          
          final brandItems = brands.map((brand) => 
            TossSelectionItem(
              id: brand,
              title: brand,
            ),
          ).toList();
          
          TossSelectionBottomSheet.show(
            context: context,
            title: 'Select Brand',
            items: brandItems,
            selectedId: _selectedBrand,
            onItemSelected: (item) {
              setState(() {
                _selectedBrand = item.title;
                _checkForChanges();
              });
            },
          );
        } else {
          // Use brands from RPC metadata
          final brandItems = metadata.brands.map((brand) => 
            TossSelectionItem(
              id: brand.id,
              title: brand.name,
            ),
          ).toList();
          
          TossSelectionBottomSheet.show(
            context: context,
            title: 'Select Brand',
            items: brandItems,
            selectedId: _selectedBrand,
            onItemSelected: (item) {
              setState(() {
                _selectedBrand = item.title;
                _checkForChanges();
              });
            },
          );
        }
      },
      loading: () {
        // Show loading while fetching metadata
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loading brands...')),
        );
      },
      error: (error, stack) {
        // Fallback to hardcoded brands on error
        final brands = [
          'GOYARD', 'PRADA', 'LOUIS VUITTON', 'CHANEL', 'HERMES',
          'GUCCI', 'DIOR', 'FENDI', 'BALENCIAGA', 'CELINE'
        ];
        
        final brandItems = brands.map((brand) => 
          TossSelectionItem(
            id: brand,
            title: brand,
          ),
        ).toList();
        
        TossSelectionBottomSheet.show(
          context: context,
          title: 'Select Brand',
          items: brandItems,
          selectedId: _selectedBrand,
          onItemSelected: (item) {
            setState(() {
              _selectedBrand = item.title;
              _checkForChanges();
            });
          },
        );
      },
    );
  }

  void _selectUnit() {
    // Get metadata from provider
    final metadataAsync = ref.read(inventoryMetadataProvider);
    
    metadataAsync.when(
      data: (metadata) {
        if (metadata == null || metadata.units.isEmpty) {
          // Fallback to default units if no metadata
          final units = ['piece', 'box', 'kg', 'g', 'l', 'ml', 'set', 'pack'];
          
          final unitItems = units.map((unit) => 
            TossSelectionItem(
              id: unit,
              title: unit,
            ),
          ).toList();
          
          TossSelectionBottomSheet.show(
            context: context,
            title: 'Select Unit',
            items: unitItems,
            selectedId: _selectedUnit,
            onItemSelected: (item) {
              setState(() {
                _selectedUnit = item.title;
                _checkForChanges();
              });
            },
          );
        } else {
          // Use units from RPC metadata
          final unitItems = metadata.units.map((unit) => 
            TossSelectionItem(
              id: unit,
              title: unit,
            ),
          ).toList();
          
          TossSelectionBottomSheet.show(
            context: context,
            title: 'Select Unit',
            items: unitItems,
            selectedId: _selectedUnit,
            onItemSelected: (item) {
              setState(() {
                _selectedUnit = item.title;
                _checkForChanges();
              });
            },
          );
        }
      },
      loading: () {
        // Show loading while fetching metadata
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loading units...')),
        );
      },
      error: (error, stack) {
        // Fallback to default units on error
        final units = ['piece', 'box', 'kg', 'g', 'l', 'ml', 'set', 'pack'];
        
        final unitItems = units.map((unit) => 
          TossSelectionItem(
            id: unit,
            title: unit,
          ),
        ).toList();
        
        TossSelectionBottomSheet.show(
          context: context,
          title: 'Select Unit',
          items: unitItems,
          selectedId: _selectedUnit,
          onItemSelected: (item) {
            setState(() {
              _selectedUnit = item.title;
              _checkForChanges();
            });
          },
        );
      },
    );
  }



}

// Custom formatter for comma-separated numbers
class _CommaNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final numericText = newValue.text.replaceAll(',', '');
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