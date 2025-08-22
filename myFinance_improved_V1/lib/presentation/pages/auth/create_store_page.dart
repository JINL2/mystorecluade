import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_animations.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_text_field.dart';
import '../../widgets/auth/storebase_auth_header.dart';
import '../../../data/services/store_service.dart';
import '../../providers/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/auth_constants.dart';

class CreateStorePage extends ConsumerStatefulWidget {
  final String companyId;
  final String companyName;
  
  const CreateStorePage({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  ConsumerState<CreateStorePage> createState() => _CreateStorePageState();
}

class _CreateStorePageState extends ConsumerState<CreateStorePage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Core fields controllers
  final _storeNameController = TextEditingController();
  final _storeAddressController = TextEditingController();
  final _storePhoneController = TextEditingController();
  
  // Operational settings controllers
  final _huddleTimeController = TextEditingController(text: '15');
  final _paymentTimeController = TextEditingController(text: '30');
  final _allowedDistanceController = TextEditingController(text: '100');
  
  // Focus nodes
  final _storeNameFocusNode = FocusNode();
  final _storeAddressFocusNode = FocusNode();
  final _storePhoneFocusNode = FocusNode();
  final _huddleTimeFocusNode = FocusNode();
  final _paymentTimeFocusNode = FocusNode();
  final _allowedDistanceFocusNode = FocusNode();
  
  // Animation controllers
  late AnimationController _animationController;
  late AnimationController _successController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _successScaleAnimation;
  late Animation<double> _successFadeAnimation;
  
  bool _isLoading = false;
  bool _showSuccess = false;
  String? _storeId;
  String? _storeCode;
  
  // Validation states
  bool _isStoreNameValid = false;
  bool _isStoreAddressValid = true;  // Optional field - empty is valid
  bool _isStorePhoneValid = true;     // Optional field - empty is valid
  
  // Advanced settings visibility
  bool _showAdvancedSettings = false;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );
    
    _successController = AnimationController(
      duration: const Duration(milliseconds: AuthConstants.successAnimationMs),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ));
    
    _successScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
    
    _successFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.easeInOut,
    ));
    
    // Add validators
    _storeNameController.addListener(_validateStoreName);
    _storeAddressController.addListener(_validateStoreAddress);
    _storePhoneController.addListener(_validateStorePhone);
    
    _animationController.forward();
  }
  
  void _validateStoreName() {
    final storeName = _storeNameController.text.trim();
    final isValid = storeName.length >= AuthConstants.nameMinLength && storeName.length <= 100;
    if (isValid != _isStoreNameValid) {
      setState(() {
        _isStoreNameValid = isValid;
      });
    }
  }
  
  void _validateStoreAddress() {
    final address = _storeAddressController.text.trim();
    final isValid = address.isEmpty || address.length >= 5;
    if (isValid != _isStoreAddressValid) {
      setState(() {
        _isStoreAddressValid = isValid;
      });
    }
  }
  
  void _validateStorePhone() {
    final phone = _storePhoneController.text.trim();
    final isValid = phone.isEmpty || 
        RegExp(r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}$').hasMatch(phone);
    if (isValid != _isStorePhoneValid) {
      setState(() {
        _isStorePhoneValid = isValid;
      });
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _successController.dispose();
    _storeNameController.dispose();
    _storeAddressController.dispose();
    _storePhoneController.dispose();
    _huddleTimeController.dispose();
    _paymentTimeController.dispose();
    _allowedDistanceController.dispose();
    _storeNameFocusNode.dispose();
    _storeAddressFocusNode.dispose();
    _storePhoneFocusNode.dispose();
    _huddleTimeFocusNode.dispose();
    _paymentTimeFocusNode.dispose();
    _allowedDistanceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.background,
      resizeToAvoidBottomInset: true, // Ensure keyboard handling
      body: SafeArea(
        child: _showSuccess ? _buildSuccessView() : _buildFormView(),
      ),
    );
  }

  Widget _buildFormView() {
    return Column(
      children: [
        const StorebaseAuthHeader(showBackButton: true),
        
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(TossSpacing.space5),
            child: Form(
              key: _formKey,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      
                      const SizedBox(height: TossSpacing.space8),
                      
                      _buildSectionTitle('Store Information', isRequired: true),
                      
                      const SizedBox(height: TossSpacing.space4),
                      
                      _buildStoreNameField(),
                      
                      const SizedBox(height: TossSpacing.space4),
                      
                      _buildStoreAddressField(),
                      
                      const SizedBox(height: TossSpacing.space4),
                      
                      _buildStorePhoneField(),
                      
                      const SizedBox(height: TossSpacing.space6),
                      
                      _buildAdvancedSettingsSection(),
                      
                      const SizedBox(height: TossSpacing.space8),
                      
                      _buildCreateStoreButton(),
                      
                      const SizedBox(height: TossSpacing.space4),
                      
                      _buildTermsText(),
                      
                      const SizedBox(height: TossSpacing.space4),
                      
                      _buildSkipOption(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: FadeTransition(
        opacity: _successFadeAnimation,
        child: ScaleTransition(
          scale: _successScaleAnimation,
          child: Padding(
            padding: EdgeInsets.all(TossSpacing.space5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        TossColors.success.withOpacity(0.1),
                        TossColors.success.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.store,
                    size: 70,
                    color: TossColors.success,
                  ),
                ),
                
                const SizedBox(height: TossSpacing.space6),
                
                Text(
                  'Store Created Successfully!',
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                
                const SizedBox(height: TossSpacing.space3),
                
                Text(
                  _storeNameController.text.trim(),
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                if (_storeCode != null) ...[
                  const SizedBox(height: TossSpacing.space2),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: TossColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code,
                          size: 18,
                          color: TossColors.primary,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          'Store Code: $_storeCode',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: TossSpacing.space3),
                
                Container(
                  padding: EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSuccessInfoRow(Icons.business, 'Company', widget.companyName),
                      if (_storeAddressController.text.trim().isNotEmpty) ...[
                        const SizedBox(height: TossSpacing.space2),
                        _buildSuccessInfoRow(Icons.location_on, 'Address', _storeAddressController.text.trim()),
                      ],
                      if (_storePhoneController.text.trim().isNotEmpty) ...[
                        const SizedBox(height: TossSpacing.space2),
                        _buildSuccessInfoRow(Icons.phone, 'Phone', _storePhoneController.text.trim()),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: TossSpacing.space8),
                
                TossPrimaryButton(
                  text: 'Go to Dashboard',
                  onPressed: () async {
                    await _navigateToDashboard();
                  },
                  fullWidth: true,
                  leadingIcon: Icon(
                    Icons.dashboard_outlined,
                    size: 20,
                    color: TossColors.white,
                  ),
                ),
                
                const SizedBox(height: TossSpacing.space3),
                
                TextButton(
                  onPressed: () {
                    // Option to create another store
                    setState(() {
                      _showSuccess = false;
                      _storeNameController.clear();
                      _storeAddressController.clear();
                      _storePhoneController.clear();
                      _isStoreNameValid = false;
                      _isStoreAddressValid = false;
                      _isStorePhoneValid = false;
                    });
                    _animationController.forward(from: 0);
                  },
                  child: Text(
                    'Create Another Store',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: TossColors.textSecondary),
        const SizedBox(width: TossSpacing.space2),
        Text(
          '$label: ',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                TossColors.primary.withOpacity(0.1),
                TossColors.primary.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: TossColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.business,
                size: 16,
                color: TossColors.primary,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                widget.companyName,
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: TossSpacing.space4),
        
        Text(
          'Create Your Store',
          style: TossTextStyles.h1.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            fontSize: 32,
          ),
        ),
        
        const SizedBox(height: TossSpacing.space2),
        
        Text(
          'Set up your first store location to start managing operations',
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          title,
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: TossSpacing.space1),
          Text(
            '*',
            style: TossTextStyles.labelLarge.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStoreNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Store Name',
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
              ),
            ),
            if (_isStoreNameValid) ...[
              const SizedBox(width: TossSpacing.space2),
              Icon(
                Icons.check_circle,
                size: 18,
                color: TossColors.success,
              ),
            ],
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _storeNameController,
          focusNode: _storeNameFocusNode,
          hintText: 'e.g., Main Store, Downtown Branch',
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _storeAddressFocusNode.requestFocus(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a store name';
            }
            if (value.trim().length < 2) {
              return 'Store name must be at least 2 characters';
            }
            if (value.trim().length > 100) {
              return 'Store name must be less than 100 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'This will be displayed to your employees',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Store Address',
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Optional',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
            if (_isStoreAddressValid && _storeAddressController.text.isNotEmpty) ...[
              const SizedBox(width: TossSpacing.space2),
              Icon(
                Icons.check_circle,
                size: 18,
                color: TossColors.success,
              ),
            ],
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _storeAddressController,
          focusNode: _storeAddressFocusNode,
          hintText: '123 Main Street, City, State, ZIP',
          maxLines: 2,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _storePhoneFocusNode.requestFocus(),
          validator: (value) {
            if (value != null && value.trim().isNotEmpty && value.trim().length < 5) {
              return 'Please enter a valid address';
            }
            return null;
          },
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Used for location-based features',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStorePhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Store Phone',
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Optional',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
            if (_isStorePhoneValid && _storePhoneController.text.isNotEmpty) ...[
              const SizedBox(width: TossSpacing.space2),
              Icon(
                Icons.check_circle,
                size: 18,
                color: TossColors.success,
              ),
            ],
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _storePhoneController,
          focusNode: _storePhoneFocusNode,
          hintText: '+1 (555) 123-4567',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              if (!RegExp(r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}$').hasMatch(value.trim())) {
                return 'Please enter a valid phone number';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Contact number for this location',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _showAdvancedSettings = !_showAdvancedSettings;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  size: 20,
                  color: TossColors.textSecondary,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Operational Settings',
                  style: TossTextStyles.labelLarge.copyWith(
                    color: TossColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: TossSpacing.space1),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.gray200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Optional',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  _showAdvancedSettings ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: TossColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        
        if (_showAdvancedSettings) ...[
          const SizedBox(height: TossSpacing.space3),
          
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TossColors.borderLight,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildOperationalField(
                  'Huddle Time',
                  _huddleTimeController,
                  _huddleTimeFocusNode,
                  'Minutes for team meetings',
                  'minutes',
                ),
                
                const SizedBox(height: TossSpacing.space3),
                
                _buildOperationalField(
                  'Payment Time',
                  _paymentTimeController,
                  _paymentTimeFocusNode,
                  'Minutes for payment processing',
                  'minutes',
                ),
                
                const SizedBox(height: TossSpacing.space3),
                
                _buildOperationalField(
                  'Allowed Distance',
                  _allowedDistanceController,
                  _allowedDistanceFocusNode,
                  'Maximum distance for check-in',
                  'meters',
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOperationalField(
    String label,
    TextEditingController controller,
    FocusNode focusNode,
    String hint,
    String unit,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TossTextStyles.label.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hint,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: TossTextField(
                  controller: controller,
                  focusNode: focusNode,
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final number = int.tryParse(value);
                      if (number == null || number <= 0) {
                        return 'Invalid';
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                unit,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateStoreButton() {
    final canCreate = _isStoreNameValid && _isStoreAddressValid && _isStorePhoneValid;
    
    return TossPrimaryButton(
      text: _isLoading ? 'Creating store...' : 'Create Store',
      onPressed: _isLoading || !canCreate ? null : _handleCreateStore,
      isLoading: _isLoading,
      fullWidth: true,
      leadingIcon: _isLoading 
          ? null 
          : Icon(
              Icons.store,
              size: 20,
              color: TossColors.white,
            ),
    );
  }

  Widget _buildTermsText() {
    return Center(
      child: Text(
        'By creating a store, you agree to our Terms of Service',
        textAlign: TextAlign.center,
        style: TossTextStyles.caption.copyWith(
          color: TossColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildSkipOption() {
    return Center(
      child: TextButton(
        onPressed: _isLoading ? null : () async {
          await _navigateToDashboard();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.skip_next,
              size: 18,
              color: TossColors.textTertiary,
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              'Skip for now',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCreateStore() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(storeServiceProvider);
      
      // Parse operational settings
      final huddleTime = _huddleTimeController.text.isNotEmpty 
          ? int.tryParse(_huddleTimeController.text) 
          : null;
      final paymentTime = _paymentTimeController.text.isNotEmpty 
          ? int.tryParse(_paymentTimeController.text) 
          : null;
      final allowedDistance = _allowedDistanceController.text.isNotEmpty 
          ? int.tryParse(_allowedDistanceController.text) 
          : null;
      
      final result = await service.createStore(
        storeName: _storeNameController.text.trim(),
        companyId: widget.companyId,
        storeAddress: _storeAddressController.text.trim().isEmpty 
            ? null 
            : _storeAddressController.text.trim(),
        storePhone: _storePhoneController.text.trim().isEmpty 
            ? null 
            : _storePhoneController.text.trim(),
        huddleTime: huddleTime,
        paymentTime: paymentTime,
        allowedDistance: allowedDistance,
      );
      
      if (result != null) {
        _storeId = result['store_id'];
        _storeCode = result['store_code'];
        
        setState(() {
          _showSuccess = true;
          _isLoading = false;
        });
        
        _successController.forward();
      } else {
        throw Exception('Failed to create store');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Failed to create store: ${e.toString()}',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(TossSpacing.space4),
          ),
        );
      }
    } finally {
      if (mounted && !_showSuccess) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToDashboard() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      
      if (userId != null) {
        // Small delay to ensure database has updated
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Fetch user data and categories in parallel
        final results = await Future.wait([
          supabase.rpc(
            'get_user_companies_and_stores',
            params: {'p_user_id': userId},
          ),
          supabase.rpc('get_categories_with_features'),
        ]);
        
        final userResponse = results[0];
        final categoriesResponse = results[1];
        
        // Store both in app state
        await ref.read(appStateProvider.notifier).setUser(userResponse);
        await ref.read(appStateProvider.notifier).setCategoryFeatures(categoriesResponse);
        
        // AUTO-SELECT first company and first store for consistent UX
        // When user creates a store, they should immediately have something selected
        final companies = userResponse['companies'] as List<dynamic>? ?? [];
        if (companies.isNotEmpty) {
          final firstCompany = companies.first;
          final companyId = firstCompany['company_id'] as String;
          
          await ref.read(appStateProvider.notifier).setCompanyChoosen(companyId);
          
          // Auto-select first store from this company
          final stores = firstCompany['stores'] as List<dynamic>? ?? [];
          if (stores.isNotEmpty) {
            final firstStore = stores.first;
            final storeId = firstStore['store_id'] as String;
            final storeName = firstStore['store_name'] as String;
            
            await ref.read(appStateProvider.notifier).setStoreChoosen(storeId);
          }
        }
        
        if (mounted) {
          context.go('/');
        }
      }
    } catch (e) {
      // Fallback to homepage on error
      if (mounted) {
        context.go('/');
      }
    }
  }
}