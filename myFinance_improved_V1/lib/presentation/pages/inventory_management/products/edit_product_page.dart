import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
import '../widgets/barcode_scanner_sheet.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class EditProductPage extends ConsumerStatefulWidget {
  final Product product;
  
  const EditProductPage({
    Key? key,
    required this.product,
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
  late TextEditingController _nameEnController;
  late TextEditingController _costPriceController;
  late TextEditingController _salePriceController;
  late TextEditingController _minPriceController;
  late TextEditingController _onHandController;
  late TextEditingController _minStockController;
  late TextEditingController _maxStockController;
  late TextEditingController _reorderPointController;
  late TextEditingController _reorderQuantityController;
  late TextEditingController _weightController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  
  // Selected values
  late ProductCategory? _selectedCategory;
  late String? _selectedBrand;
  late String? _selectedUnit;
  late ProductType _selectedType;
  late List<String> _existingImages;
  late List<File> _newImages;
  late List<String> _imagesToDelete;
  late bool _isActive;
  late bool _sellInStore;
  
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
    _nameEnController = TextEditingController(text: product.nameEn ?? '');
    _costPriceController = TextEditingController(
      text: product.costPrice.toStringAsFixed(0),
    );
    _salePriceController = TextEditingController(
      text: product.salePrice.toStringAsFixed(0),
    );
    _minPriceController = TextEditingController(
      text: product.minPrice?.toStringAsFixed(0) ?? '',
    );
    _onHandController = TextEditingController(text: product.onHand.toString());
    _minStockController = TextEditingController(
      text: (product.minStock ?? 0).toString(),
    );
    _maxStockController = TextEditingController(
      text: (product.maxStock ?? 100).toString(),
    );
    _reorderPointController = TextEditingController(
      text: (product.reorderPoint ?? 10).toString(),
    );
    _reorderQuantityController = TextEditingController(
      text: (product.reorderQuantity ?? 20).toString(),
    );
    _weightController = TextEditingController(
      text: product.weight?.toString() ?? '',
    );
    _locationController = TextEditingController(text: product.location ?? '');
    _descriptionController = TextEditingController(
      text: product.description ?? '',
    );
    
    _selectedCategory = product.category;
    _selectedBrand = product.brand;
    _selectedUnit = product.unit;
    _selectedType = product.productType;
    _existingImages = List.from(product.images);
    _newImages = [];
    _imagesToDelete = [];
    _isActive = product.isActive;
    _sellInStore = product.sellInStore;
    
    // Add listeners to track changes
    _addChangeListeners();
  }

  void _saveOriginalValues() {
    _originalValues = {
      'sku': _skuController.text,
      'barcode': _barcodeController.text,
      'name': _nameController.text,
      'nameEn': _nameEnController.text,
      'costPrice': _costPriceController.text,
      'salePrice': _salePriceController.text,
      'minPrice': _minPriceController.text,
      'onHand': _onHandController.text,
      'minStock': _minStockController.text,
      'maxStock': _maxStockController.text,
      'reorderPoint': _reorderPointController.text,
      'reorderQuantity': _reorderQuantityController.text,
      'weight': _weightController.text,
      'location': _locationController.text,
      'description': _descriptionController.text,
      'category': _selectedCategory,
      'brand': _selectedBrand,
      'unit': _selectedUnit,
      'type': _selectedType,
      'isActive': _isActive,
      'sellInStore': _sellInStore,
    };
  }

  void _addChangeListeners() {
    _skuController.addListener(_checkForChanges);
    _barcodeController.addListener(_checkForChanges);
    _nameController.addListener(_checkForChanges);
    _nameEnController.addListener(_checkForChanges);
    _costPriceController.addListener(_checkForChanges);
    _salePriceController.addListener(_checkForChanges);
    _minPriceController.addListener(_checkForChanges);
    _onHandController.addListener(_checkForChanges);
    _minStockController.addListener(_checkForChanges);
    _maxStockController.addListener(_checkForChanges);
    _reorderPointController.addListener(_checkForChanges);
    _reorderQuantityController.addListener(_checkForChanges);
    _weightController.addListener(_checkForChanges);
    _locationController.addListener(_checkForChanges);
    _descriptionController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final hasFieldChanges = 
        _skuController.text != _originalValues['sku'] ||
        _barcodeController.text != _originalValues['barcode'] ||
        _nameController.text != _originalValues['name'] ||
        _nameEnController.text != _originalValues['nameEn'] ||
        _costPriceController.text != _originalValues['costPrice'] ||
        _salePriceController.text != _originalValues['salePrice'] ||
        _minPriceController.text != _originalValues['minPrice'] ||
        _onHandController.text != _originalValues['onHand'] ||
        _minStockController.text != _originalValues['minStock'] ||
        _maxStockController.text != _originalValues['maxStock'] ||
        _reorderPointController.text != _originalValues['reorderPoint'] ||
        _reorderQuantityController.text != _originalValues['reorderQuantity'] ||
        _weightController.text != _originalValues['weight'] ||
        _locationController.text != _originalValues['location'] ||
        _descriptionController.text != _originalValues['description'] ||
        _selectedCategory != _originalValues['category'] ||
        _selectedBrand != _originalValues['brand'] ||
        _selectedUnit != _originalValues['unit'] ||
        _selectedType != _originalValues['type'] ||
        _isActive != _originalValues['isActive'] ||
        _sellInStore != _originalValues['sellInStore'] ||
        _newImages.isNotEmpty ||
        _imagesToDelete.isNotEmpty;
    
    setState(() => _hasChanges = hasFieldChanges);
  }


  @override
  void dispose() {
    _skuController.dispose();
    _barcodeController.dispose();
    _nameController.dispose();
    _nameEnController.dispose();
    _costPriceController.dispose();
    _salePriceController.dispose();
    _minPriceController.dispose();
    _onHandController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    _reorderPointController.dispose();
    _reorderQuantityController.dispose();
    _weightController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    final result = await TossBottomSheet.show<String>(
      context: context,
      content: const BarcodeScannerSheet(),
    );
    
    if (result != null) {
      setState(() {
        _barcodeController.text = result;
        _checkForChanges();
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
    
    if (pickedFile != null) {
      setState(() {
        _newImages.add(File(pickedFile.path));
        _checkForChanges();
      });
    }
  }

  void _removeExistingImage(String imageUrl) {
    setState(() {
      _existingImages.remove(imageUrl);
      _imagesToDelete.add(imageUrl);
      _checkForChanges();
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
      _checkForChanges();
    });
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
      // Create updated product object  
      Product(
        id: widget.product.id,
        sku: _skuController.text,
        barcode: _barcodeController.text.isEmpty ? null : _barcodeController.text,
        name: _nameController.text,
        nameEn: _nameEnController.text.isEmpty ? null : _nameEnController.text,
        category: _selectedCategory!,
        brand: _selectedBrand,
        productType: _selectedType,
        unit: _selectedUnit ?? 'piece',
        costPrice: double.parse(_costPriceController.text.replaceAll(',', '')),
        salePrice: double.parse(_salePriceController.text.replaceAll(',', '')),
        minPrice: _minPriceController.text.isEmpty 
            ? null 
            : double.parse(_minPriceController.text.replaceAll(',', '')),
        onHand: int.parse(_onHandController.text),
        minStock: int.tryParse(_minStockController.text) ?? 0,
        maxStock: int.tryParse(_maxStockController.text) ?? 100,
        reorderPoint: int.tryParse(_reorderPointController.text),
        reorderQuantity: int.tryParse(_reorderQuantityController.text),
        weight: _weightController.text.isEmpty 
            ? null 
            : double.parse(_weightController.text),
        location: _locationController.text.isEmpty 
            ? null 
            : _locationController.text,
        description: _descriptionController.text.isEmpty 
            ? null 
            : _descriptionController.text,
        images: _existingImages,
        isActive: _isActive,
        sellInStore: _sellInStore,
      );

      // TODO: Update in database via provider
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: TossColors.white),
                SizedBox(width: TossSpacing.space2),
                Text('Product updated successfully'),
              ],
            ),
            backgroundColor: TossColors.success,
          ),
        );
        
        NavigationHelper.safeGoBack(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating product: $e'),
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
                
                // Product Images Section
                _buildImageSection(),
                
                SizedBox(height: TossSpacing.space2),
                
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
              onPressed: _isLoading || !_hasChanges ? null : _saveChanges,
              isLoading: _isLoading,
              fullWidth: true,
              leadingIcon: _hasChanges ? Icon(
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

  Widget _buildImageSection() {
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          TossSectionHeader(
            title: 'Product Images',
            icon: Icons.photo_library_outlined,
          ),
          
          SizedBox(height: TossSpacing.space2),
          
          TossWhiteCard(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Existing images
                      ..._existingImages.map((imageUrl) {
                        return _buildImageCard(imageUrl, isExisting: true);
                      }).toList(),
                      
                      // New images
                      ..._newImages.map((image) {
                        final index = _newImages.indexOf(image);
                        return _buildNewImageCard(image, index);
                      }).toList(),
                      
                      // Add photo button
                      _buildAddPhotoButton(),
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
                // SKU (Read-only)
                TossTextField(
                  label: 'SKU',
                  hintText: 'Auto-generated product SKU',
                  controller: _skuController,
                  enabled: false,
                ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Barcode
              TossTextField(
                label: 'Barcode',
                hintText: 'Scan or enter barcode',
                controller: _barcodeController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffixIcon: IconButton(
                  icon: Icon(Icons.qr_code_scanner, color: TossColors.primary, size: TossSpacing.iconSM),
                  onPressed: _scanBarcode,
                ),
                onChanged: (_) => _checkForChanges(),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Product Name
              TossTextField(
                label: 'Product Name *',
                hintText: 'Enter product name',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product name is required';
                  }
                  return null;
                },
                onChanged: (_) => _checkForChanges(),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Product Name (English)
              TossTextField(
                label: 'Product Name (English)',
                hintText: 'Enter English name (optional)',
                controller: _nameEnController,
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
                                _selectedCategory?.displayName ?? 'Select category',
                                style: TossTextStyles.body.copyWith(
                                  color: _selectedCategory != null
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
                
                SizedBox(height: TossSpacing.space4),
              
                // Minimum Price
                TossTextField(
                  label: 'Minimum Price',
                  hintText: '₩ Minimum selling price (optional)',
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _CommaNumberInputFormatter(),
                  ],
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
              
              SizedBox(height: TossSpacing.space4),
              
              // Reorder Point/Quantity Row
              Row(
                children: [
                  Expanded(
                    child: TossTextField(
                      label: 'Reorder Point',
                      hintText: 'Alert threshold',
                      controller: _reorderPointController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => _checkForChanges(),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: TossTextField(
                      label: 'Reorder Qty',
                      hintText: 'Order amount',
                      controller: _reorderQuantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => _checkForChanges(),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: TossSpacing.space4),
              
                // Location
                TossTextField(
                  label: 'Warehouse Location',
                  hintText: 'e.g., A-1-3',
                  controller: _locationController,
                  onChanged: (_) => _checkForChanges(),
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
                // Weight
                TossTextField(
                  label: 'Weight',
                  hintText: 'Product weight in grams (optional)',
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => _checkForChanges(),
                ),
                
                SizedBox(height: TossSpacing.space4),
                
                // Description
                TossTextField(
                  label: 'Description',
                  hintText: 'Product description (optional)',
                  controller: _descriptionController,
                  maxLines: 4,
                  onChanged: (_) => _checkForChanges(),
                ),
                
                SizedBox(height: TossSpacing.space4),
              
                // Product Type Chips
                Column(
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
                      children: ProductType.values.map((type) {
                        return ChoiceChip(
                          label: Text(type.displayName),
                          selected: _selectedType == type,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedType = type;
                                _checkForChanges();
                              });
                            }
                          },
                          selectedColor: TossColors.primary.withValues(alpha: 0.1),
                          backgroundColor: TossColors.gray50,
                          side: BorderSide(
                            color: _selectedType == type ? TossColors.primary : TossColors.gray200,
                          ),
                          labelStyle: TossTextStyles.body.copyWith(
                            color: _selectedType == type
                                ? TossColors.primary
                                : TossColors.gray700,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
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
                      Divider(height: 1, color: TossColors.gray200),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Sell In-Store',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.gray900,
                          ),
                        ),
                        subtitle: Text(
                          'Available for POS transactions',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        value: _sellInStore,
                        onChanged: (value) {
                          setState(() {
                            _sellInStore = value;
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
    final reorderPoint = int.tryParse(_reorderPointController.text) ?? 10;
    
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    if (current == 0) {
      statusColor = TossColors.error;
      statusText = 'Out of Stock';
      statusIcon = Icons.error_outline;
    } else if (current <= reorderPoint) {
      statusColor = TossColors.warning;
      statusText = 'Low Stock - Reorder Needed';
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

  Widget _buildImageCard(String imageUrl, {required bool isExisting}) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(right: TossSpacing.space2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: TossSpacing.space2 + 4,
          child: GestureDetector(
            onTap: () => _removeExistingImage(imageUrl),
            child: Container(
              padding: EdgeInsets.all(TossSpacing.space1),
              decoration: BoxDecoration(
                color: TossColors.black.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                TossIcons.close,
                size: TossSpacing.iconXS,
                color: TossColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildNewImageCard(File image, int index) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(right: TossSpacing.space2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: TossColors.success,
              width: 2,
            ),
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space1),
            decoration: BoxDecoration(
              color: TossColors.success,
              shape: BoxShape.circle,
            ),
            child: Icon(
              TossIcons.add,
              size: TossSpacing.iconXS,
              color: TossColors.white,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: TossSpacing.space2 + 4,
          child: GestureDetector(
            onTap: () => _removeNewImage(index),
            child: Container(
              padding: EdgeInsets.all(TossSpacing.space1),
              decoration: BoxDecoration(
                color: TossColors.black.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                TossIcons.close,
                size: TossSpacing.iconXS,
                color: TossColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: () => _showImagePicker(),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: TossColors.gray300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              color: TossColors.gray400,
              size: TossSpacing.iconSM,
            ),
            SizedBox(height: TossSpacing.space1),
            Text(
              'Add Photo',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _selectCategory() {
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
          _checkForChanges();
        });
      },
    );
  }
  
  void _selectBrand() {
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
          _selectedBrand = item.id;
          _checkForChanges();
        });
      },
    );
  }

  void _showImagePicker() {
    TossBottomSheet.show(
      context: context,
      content: Container(
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 48,
                height: 4,
                margin: EdgeInsets.only(top: TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Title
              Text(
                'Add Product Image',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Options
              ListTile(
                leading: Icon(Icons.camera_alt, color: TossColors.primary),
                title: Text('Take Photo', style: TossTextStyles.body),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: TossColors.primary),
                title: Text('Choose from Gallery', style: TossTextStyles.body),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: TossColors.gray500),
                title: Text('Cancel', style: TossTextStyles.body),
                onTap: () => Navigator.pop(context),
              ),
              
              SizedBox(height: TossSpacing.space2),
            ],
          ),
        ),
      ),
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