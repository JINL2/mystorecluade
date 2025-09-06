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
import '../../../helpers/navigation_helper.dart';
import '../models/product_model.dart';
import '../widgets/barcode_scanner_sheet.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  
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
  String? _selectedBrand;
  String? _selectedLocation;
  File? _productImage;
  bool _sellInStore = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Product number is optional - user can add if needed
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

  void _generateProductNumber() {
    // Generate simple sequential number for internal tracking
    final now = DateTime.now();
    final shortDate = '${now.year.toString().substring(2)}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final timeCode = '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    _skuController.text = 'P$shortDate$timeCode';
  }

  Future<void> _scanBarcode() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => const BarcodeScannerSheet(),
    );
    
    if (result != null) {
      setState(() {
        _barcodeController.text = result;
      });
    }
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

    await TossSelectionBottomSheet.show(
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

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implement actual save logic
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        NavigationHelper.safeGoBack(context);
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
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Product Number (Optional - for inventory tracking)
            TossTextField(
              label: 'Product number (Optional)',
              hintText: 'For inventory tracking - tap refresh to generate',
              controller: _skuController,
              suffixIcon: IconButton(
                onPressed: _generateProductNumber,
                icon: Icon(
                  Icons.refresh,
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
                tooltip: 'Generate product number',
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Barcode
            TossTextField(
              label: 'Barcode',
              hintText: 'Enter or scan barcode',
              controller: _barcodeController,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.qr_code_scanner,
                  color: TossColors.gray700,
                  size: TossSpacing.iconSM,
                ),
                onPressed: _scanBarcode,
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Product Name
            TossTextField(
              label: 'Product name',
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
              value: _selectedCategory?.displayName,
              placeholder: 'Select product category',
              onTap: () async {
                final items = ProductCategory.values.map((category) => 
                  TossSelectionItem.fromGeneric(
                    id: category.name,
                    title: category.displayName,
                  )
                ).toList();
                
                await TossSelectionBottomSheet.show(
                  context: context,
                  title: 'Product category',
                  items: items,
                  selectedId: _selectedCategory?.name,
                  showSubtitle: false,
                  onItemSelected: (item) {
                    setState(() {
                      _selectedCategory = ProductCategory.values.firstWhere(
                        (cat) => cat.name == item.id
                      );
                    });
                  },
                );
              },
            ),
            
            // Brand Selection
            _buildSelectionRow(
              label: 'Brand',
              value: _selectedBrand,
              placeholder: 'Choose brand',
              onTap: () async {
                final brands = [
                  'GOYARD', 'PRADA', 'LOUIS VUITTON', 'CHANEL', 'HERMES',
                  'GUCCI', 'DIOR', 'FENDI', 'BALENCIAGA', 'CELINE', 
                  'APPLE', 'SAMSUNG', 'Other'
                ];
                
                final items = brands.map((brand) => 
                  TossSelectionItem.fromGeneric(
                    id: brand,
                    title: brand,
                  )
                ).toList();
                
                await TossSelectionBottomSheet.show(
                  context: context,
                  title: 'Brand',
                  items: items,
                  selectedId: _selectedBrand,
                  showSubtitle: false,
                  showSearch: true,
                  onItemSelected: (item) {
                    setState(() {
                      _selectedBrand = item.id;
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
              label: 'Sale price',
              hintText: '0',
              controller: _salePriceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CommaNumberInputFormatter(),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Cost Price
            TossTextField(
              label: 'Cost of goods',
              hintText: '0',
              controller: _costPriceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CommaNumberInputFormatter(),
              ],
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
            
            // Position Selection
            _buildSelectionRow(
              label: 'Position',
              value: _selectedLocation,
              placeholder: 'Select location',
              onTap: () async {
                final locations = [
                  'A-1-1', 'A-1-2', 'A-1-3', 'A-2-1', 'A-2-2',
                  'B-1-1', 'B-1-2', 'B-1-3', 'B-2-1', 'B-2-2',
                  'C-1-1', 'C-1-2', 'C-1-3', 'C-2-1', 'C-2-2',
                ];
                
                final items = locations.map((location) => 
                  TossSelectionItem.fromGeneric(
                    id: location,
                    title: location,
                  )
                ).toList();
                
                await TossSelectionBottomSheet.show(
                  context: context,
                  title: 'Position',
                  items: items,
                  selectedId: _selectedLocation,
                  showSubtitle: false,
                  onItemSelected: (item) {
                    setState(() {
                      _selectedLocation = item.id;
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

  Widget _buildOptionsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossPageStyles.card(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Sell In-Store Toggle
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sell in-store',
                          style: TossPageStyles.titleStyle,
                        ),
                        Text(
                          'Allow this product to be sold in-store',
                          style: TossPageStyles.subtitleStyle,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _sellInStore,
                    onChanged: (value) {
                      setState(() {
                        _sellInStore = value;
                      });
                    },
                    activeColor: TossColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
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

  Widget _buildAddAttributeButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Add attribute feature coming soon'),
              backgroundColor: TossColors.gray700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space4,
          ),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: TossColors.gray200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: TossSpacing.iconMD,
                height: TossSpacing.iconMD,
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: TossColors.white,
                  size: TossSpacing.iconXS,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Text(
                'Add attribute',
                style: TossPageStyles.valueStyle.copyWith(
                  color: TossColors.primary,
                ),
              ),
            ],
          ),
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
        primaryActionText: _isLoading ? null : 'Save',
        onPrimaryAction: _isLoading ? null : _saveProduct,
        leading: IconButton(
          icon: const Icon(Icons.close, size: TossSpacing.iconMD),
          onPressed: () => NavigationHelper.safeGoBack(context),
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
                
                // Options Section
                _buildOptionsSection(),
                
                SizedBox(height: TossSpacing.space2),
                
                // Add Attribute Button
                _buildAddAttributeButton(),
                
                SizedBox(height: TossSpacing.space24 * 4), // Bottom padding
              ],
            ),
          ),
        ),
      ),
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