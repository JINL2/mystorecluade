import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../widgets/toss/toss_button.dart';
import '../../../widgets/toss/toss_text_field.dart';
import '../../../providers/app_state_provider.dart';
import '../models/cash_location_model.dart';
import '../providers/cash_location_provider.dart';

class AddLocationSheet extends ConsumerStatefulWidget {
  final CashLocationModel? locationToEdit;
  final Function(CashLocationModel)? onLocationAdded;
  
  const AddLocationSheet({
    super.key,
    this.locationToEdit,
    this.onLocationAdded,
  });
  
  @override
  ConsumerState<AddLocationSheet> createState() => _AddLocationSheetState();
}

class _AddLocationSheetState extends ConsumerState<AddLocationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountController = TextEditingController();
  
  String _selectedType = 'cash';
  String _selectedCurrency = 'USD';
  String? _selectedStoreId;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.locationToEdit != null) {
      final location = widget.locationToEdit!;
      _nameController.text = location.locationName;
      _selectedType = location.locationType;
      _selectedCurrency = location.currencyCode;
      _selectedStoreId = location.storeId;
      _bankNameController.text = location.bankName ?? '';
      _accountController.text = location.bankAccount ?? '';
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _bankNameController.dispose();
    _accountController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final stores = selectedCompany != null 
        ? (selectedCompany['stores'] as List<dynamic>? ?? [])
        : [];
    
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.locationToEdit != null 
                      ? 'Edit Cash Location' 
                      : 'Add Cash Location',
                    style: TossTextStyles.h1,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: TossColors.gray600),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Type Selection
                      Text(
                        'Location Type',
                        style: TossTextStyles.label.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildTypeChip(
                            emoji: '💵',
                            label: 'Cash',
                            value: 'cash',
                          ),
                          const SizedBox(width: 8),
                          _buildTypeChip(
                            emoji: '🏦',
                            label: 'Bank',
                            value: 'bank',
                          ),
                          const SizedBox(width: 8),
                          _buildTypeChip(
                            emoji: '🔐',
                            label: 'Vault',
                            value: 'vault',
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Location Name
                      TossTextField(
                        controller: _nameController,
                        label: 'Location Name',
                        hintText: _getNameHint(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter location name';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Store Selection
                      Text(
                        'Store',
                        style: TossTextStyles.label.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedStoreId ?? (ref.read(appStateProvider).storeChoosen.isEmpty ? null : ref.read(appStateProvider).storeChoosen),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: TossColors.gray50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            borderSide: BorderSide(
                              color: TossColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        items: stores.map((store) {
                          final storeMap = store as Map<String, dynamic>;
                          return DropdownMenuItem(
                            value: storeMap['store_id'] as String,
                            child: Text(storeMap['store_name'] as String),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStoreId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a store';
                          }
                          return null;
                        },
                      ),
                      
                      if (_selectedType == 'bank') ...[
                        const SizedBox(height: 20),
                        
                        // Bank Name
                        TossTextField(
                          controller: _bankNameController,
                          label: 'Bank Name',
                          hintText: 'e.g., Bank of America',
                          validator: (value) {
                            if (_selectedType == 'bank' && 
                                (value == null || value.isEmpty)) {
                              return 'Please enter bank name';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Account Number
                        TossTextField(
                          controller: _accountController,
                          label: 'Account Number',
                          hintText: 'e.g., ****1234',
                          keyboardType: TextInputType.text,
                        ),
                      ],
                      
                      const SizedBox(height: 20),
                      
                      // Currency Selection
                      Text(
                        'Currency',
                        style: TossTextStyles.label.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCurrency,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: TossColors.gray50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: _currencies.map((currency) {
                          return DropdownMenuItem(
                            value: currency['code'],
                            child: Text('${currency['symbol']} ${currency['code']} - ${currency['name']}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCurrency = value ?? 'USD';
                          });
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Info Box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          border: Border.all(
                            color: TossColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: TossColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Cash locations help you track money across different physical and digital storage points in your business.',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 80), // Space for button
                    ],
                  ),
                ),
              ),
            ),
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TossButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.white,
                      textColor: TossColors.gray700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TossButton(
                      text: widget.locationToEdit != null ? 'Update' : 'Add',
                      isLoading: _isLoading,
                      onPressed: _submitForm,
                      backgroundColor: TossColors.primary,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTypeChip({
    required String emoji,
    required String label,
    required String value,
  }) {
    final isSelected = _selectedType == value;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected 
              ? TossColors.primary.withOpacity(0.1) 
              : TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: isSelected ? TossColors.primary : TossColors.gray200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TossTextStyles.label.copyWith(
                  color: isSelected ? TossColors.primary : TossColors.gray700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getNameHint() {
    switch (_selectedType) {
      case 'cash':
        return 'e.g., Register 1, Front Desk';
      case 'bank':
        return 'e.g., Business Checking, Savings';
      case 'vault':
        return 'e.g., Main Safe, Backup Vault';
      default:
        return '';
    }
  }
  
  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
    {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
    {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
    {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
    {'code': 'KRW', 'symbol': '₩', 'name': 'Korean Won'},
    {'code': 'CNY', 'symbol': '¥', 'name': 'Chinese Yuan'},
    {'code': 'CAD', 'symbol': 'C\$', 'name': 'Canadian Dollar'},
    {'code': 'AUD', 'symbol': 'A\$', 'name': 'Australian Dollar'},
  ];
  
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final location = CashLocationModel(
        id: widget.locationToEdit?.id ?? '',
        companyId: ref.read(appStateProvider).companyChoosen,
        storeId: _selectedStoreId ?? ref.read(appStateProvider).storeChoosen,
        locationName: _nameController.text.trim(),
        locationType: _selectedType,
        currencyCode: _selectedCurrency,
        bankName: _selectedType == 'bank' ? _bankNameController.text.trim() : null,
        bankAccount: _selectedType == 'bank' && _accountController.text.isNotEmpty 
          ? _accountController.text.trim() 
          : null,
        createdAt: widget.locationToEdit?.createdAt ?? DateTime.now(),
      );
      
      if (widget.locationToEdit != null) {
        await ref.read(updateCashLocationProvider)(location);
      } else {
        await ref.read(createCashLocationProvider)(location);
      }
      
      widget.onLocationAdded?.call(location);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.locationToEdit != null 
                ? 'Location updated successfully' 
                : 'Location added successfully',
            ),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}