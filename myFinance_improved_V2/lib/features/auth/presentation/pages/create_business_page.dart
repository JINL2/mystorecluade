import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// App - Providers
import '../../../../app/providers/app_state_provider.dart';
// Core - Constants & Navigation
import '../../../../core/constants/auth_constants.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
// Shared - Widgets
import '../../../../shared/widgets/toss/toss_text_field.dart';
// Homepage - Providers (for userCompaniesProvider)
import '../../../homepage/presentation/providers/homepage_providers.dart';
// Domain - Exceptions
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/exceptions/validation_exception.dart';
// Domain - Value Objects
import '../../domain/value_objects/company_type.dart';
import '../../domain/value_objects/currency.dart';
// Presentation - Providers
import '../providers/company_service.dart';
import '../providers/current_user_provider.dart';

/// Create Business Page - Clean Architecture Version
///
/// Page for creating a new business/company after signup.
///
/// Features:
/// - Business name input with validation
/// - Business type dropdown (Retail, Restaurant, Service, etc.)
/// - Currency selection (USD, EUR, KRW, etc.)
/// - Optional fields: email, phone, address
/// - Fade + slide animations
/// - Success/error handling with dialogs
///
/// Architecture:
/// - Uses companyServiceProvider (Clean Architecture)
/// - Leverages existing infrastructure (AuthDataCache)
/// - Navigation to Create Store or Dashboard after success
class CreateBusinessPage extends ConsumerStatefulWidget {
  const CreateBusinessPage({super.key});

  @override
  ConsumerState<CreateBusinessPage> createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends ConsumerState<CreateBusinessPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _businessNameController = TextEditingController();
  final _businessEmailController = TextEditingController();
  final _businessPhoneController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _customTypeController = TextEditingController();

  // Focus Nodes
  final _businessNameFocusNode = FocusNode();
  final _businessEmailFocusNode = FocusNode();
  final _businessPhoneFocusNode = FocusNode();
  final _businessAddressFocusNode = FocusNode();
  final _customTypeFocusNode = FocusNode();

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State
  bool _isLoading = false;
  int _currentStep = 1; // Step 1: Name, Step 2: Type, Step 3: Currency
  String? _selectedTypeId;
  String? _selectedCurrencyId;
  List<CompanyType> _companyTypes = [];
  List<Currency> _currencies = [];
  bool _isCustomTypeSelected = false;

  // Validation State
  bool _isBusinessNameValid = false;
  bool _isBusinessEmailValid = false;

  @override
  void initState() {
    super.initState();
    _loadCompanyTypes();
    _loadCurrencies();

    // Initialize animations
    _animationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ),);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ),);

    // Add validation listeners
    _businessNameController.addListener(_validateBusinessName);
    _businessEmailController.addListener(_validateBusinessEmail);

    _animationController.forward();
  }

  void _loadCompanyTypes() async {
    try {
      final companyService = ref.read(companyServiceProvider);
      final types = await companyService.getCompanyTypes();
      if (mounted) {
        setState(() {
          _companyTypes = types;
          if (types.isNotEmpty) {
            _selectedTypeId = types.first.companyTypeId;
          }
        });
      }
    } catch (e) {
      // Silently fail - will show error when user tries to create
    }
  }

  void _loadCurrencies() async {
    try {
      final companyService = ref.read(companyServiceProvider);
      final currencies = await companyService.getCurrencies();
      if (mounted) {
        setState(() {
          _currencies = currencies;
          // Default to USD if available
          final usd = currencies.where((c) => c.currencyCode == 'USD').firstOrNull;
          _selectedCurrencyId = usd?.currencyId ?? currencies.firstOrNull?.currencyId;
        });
      }
    } catch (e) {
      // Silently fail - will show error when user tries to create
    }
  }

  void _validateBusinessName() {
    final name = _businessNameController.text.trim();
    final isValid = name.length >= AuthConstants.nameMinLength;
    if (isValid != _isBusinessNameValid) {
      setState(() {
        _isBusinessNameValid = isValid;
      });
    }
  }

  void _validateBusinessEmail() {
    final email = _businessEmailController.text.trim();
    final isValid = email.isEmpty ||
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    if (isValid != _isBusinessEmailValid) {
      setState(() {
        _isBusinessEmailValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _businessNameController.dispose();
    _businessEmailController.dispose();
    _businessPhoneController.dispose();
    _businessAddressController.dispose();
    _customTypeController.dispose();
    _businessNameFocusNode.dispose();
    _businessEmailFocusNode.dispose();
    _businessPhoneFocusNode.dispose();
    _businessAddressFocusNode.dispose();
    _customTypeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildAuthHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TossSpacing.space5),
                child: Form(
                  key: _formKey,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProgressIndicator(),

                          const SizedBox(height: TossSpacing.space8),

                          if (_currentStep == 1) ...[
                            _buildStep1ContentWithoutButton(),
                          ] else if (_currentStep == 2) ...[
                            _buildStep2ContentWithoutButton(),
                          ] else if (_currentStep == 3) ...[
                            _buildStep3ContentWithoutButton(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom button - always visible at screen bottom
            Container(
              padding: const EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.white,
                boxShadow: [
                  BoxShadow(
                    color: TossColors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: _buildBottomButton(),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Header
  // ==========================================

  Widget _buildAuthHeader() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: TossColors.textPrimary),
            onPressed: () {
              if (_currentStep > 1) {
                // Go to previous step
                setState(() {
                  _currentStep--;
                });
              } else {
                // On step 1, go back to choose-role
                context.go('/onboarding/choose-role');
              }
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Title & Sections
  // ==========================================

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Your Business',
          style: TossTextStyles.h1.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Set up your business profile to start managing your operations',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TossTextStyles.h3.copyWith(
        color: TossColors.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    );
  }

  // ==========================================
  // Form Fields
  // ==========================================

  Widget _buildBusinessNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Business Name',
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _businessNameController,
          focusNode: _businessNameFocusNode,
          hintText: 'Enter your business name',
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _businessEmailFocusNode.requestFocus(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your business name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBusinessTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Type',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: 4),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
            border: Border.all(color: TossColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTypeId,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: TossColors.textSecondary),
              style: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: TossColors.white,
              items: _companyTypes
                  .map((type) => DropdownMenuItem(
                        value: type.companyTypeId,
                        child: Text(type.typeName),
                      ),)
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTypeId = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Business Email',
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              '(Optional)',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _businessEmailController,
          focusNode: _businessEmailFocusNode,
          hintText: 'business@example.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _businessPhoneFocusNode.requestFocus(),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBusinessPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Business Phone',
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              '(Optional)',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _businessPhoneController,
          focusNode: _businessPhoneFocusNode,
          hintText: '+1 (555) 123-4567',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _businessAddressFocusNode.requestFocus(),
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Business Address',
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              '(Optional)',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _businessAddressController,
          focusNode: _businessAddressFocusNode,
          hintText: '123 Main Street, City, State, ZIP',
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Base Currency',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: 4),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
            border: Border.all(color: TossColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCurrencyId,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: TossColors.textSecondary),
              style: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: TossColors.white,
              items: _currencies
                  .map((currency) => DropdownMenuItem(
                        value: currency.currencyId,
                        child: Text('${currency.currencyCode} - ${currency.currencyName}'),
                      ),)
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurrencyId = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Action Button & Links
  // ==========================================

  Widget _buildCreateButton() {
    final canCreate = _isBusinessNameValid &&
        _selectedTypeId != null &&
        _selectedCurrencyId != null;

    return TossPrimaryButton(
      text: _isLoading ? 'Creating business...' : 'Create Business',
      onPressed: _isLoading || !canCreate ? null : _handleCreateBusiness,
      isLoading: _isLoading,
      leadingIcon: _isLoading
          ? null
          : const Icon(
              Icons.business,
              size: 18,
              color: TossColors.white,
            ),
    );
  }

  Widget _buildTermsText() {
    return Text(
      'By creating a business, you agree to our Terms of Service and Privacy Policy',
      style: TossTextStyles.caption.copyWith(
        color: TossColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildJoinBusinessOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Have a business code? ',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            if (!mounted) return;
            _animationController.stop();
            context.push('/onboarding/join-business');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Join Business',
            style: TossTextStyles.body.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Multi-Step UI Components
  // ==========================================

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber == _currentStep;
        final isCompleted = stepNumber < _currentStep;

        return Row(
          children: [
            Container(
              width: isActive ? 32 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive || isCompleted
                    ? TossColors.primary
                    : TossColors.gray300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            if (index < 2) const SizedBox(width: 8),
          ],
        );
      }),
    );
  }

  Widget _buildStep1ContentWithoutButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your business name?',
          style: TossTextStyles.h1.copyWith(
            fontWeight: FontWeight.w800,
            color: TossColors.textPrimary,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'This will be the name of your company in Storebase',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space8),
        _buildBusinessNameField(),
      ],
    );
  }

  Widget _buildStep2ContentWithoutButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What type of company?',
          style: TossTextStyles.h1.copyWith(
            fontWeight: FontWeight.w800,
            color: TossColors.textPrimary,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Choose the category that best describes your company',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space6),
        ..._companyTypes.map((type) {
          // Check if this is the "Others" type from database
          final isOthersType = type.typeName.toLowerCase() == 'others' ||
                               type.typeName.toLowerCase() == 'other';
          final isSelected = _isCustomTypeSelected
              ? (_selectedTypeId == type.companyTypeId)
              : (_selectedTypeId == type.companyTypeId);

          return Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space3),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedTypeId = type.companyTypeId;
                    if (isOthersType) {
                      _isCustomTypeSelected = true;
                      // Auto-focus the text field
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _customTypeFocusNode.requestFocus();
                      });
                    } else {
                      _isCustomTypeSelected = false;
                      _customTypeController.clear();
                    }
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? TossColors.primary : TossColors.gray300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: TossColors.white,
                  ),
                  child: Row(
                    children: [
                      if (!isOthersType || !_isCustomTypeSelected)
                        Expanded(
                          child: Text(
                            type.typeName,
                            style: TossTextStyles.h3.copyWith(
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: isSelected ? TossColors.primary : TossColors.textPrimary,
                              fontSize: TossTextStyles.h3.fontSize! * 0.7,
                            ),
                          ),
                        ),
                      if (isOthersType && _isCustomTypeSelected) ...[
                        Text(
                          type.typeName,
                          style: TossTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.primary,
                            fontSize: TossTextStyles.h3.fontSize! * 0.7,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space6),
                        Expanded(
                          child: TextField(
                            controller: _customTypeController,
                            focusNode: _customTypeFocusNode,
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type your company type',
                              hintStyle: TossTextStyles.body.copyWith(
                                color: TossColors.textSecondary.withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep3ContentWithoutButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your currency',
          style: TossTextStyles.h1.copyWith(
            fontWeight: FontWeight.w800,
            color: TossColors.textPrimary,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'This will be used for all financial transactions',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space6),
        ..._currencies.map((currency) {
          final isSelected = _selectedCurrencyId == currency.currencyId;
          return Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space3),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCurrencyId = currency.currencyId;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? TossColors.primary : TossColors.gray300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: TossColors.white,
                  ),
                  child: Row(
                    children: [
                      Text(
                        currency.symbol,
                        style: TossTextStyles.h2.copyWith(
                          color: isSelected ? TossColors.primary : TossColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currency.currencyName,
                              style: TossTextStyles.h3.copyWith(
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                color: isSelected ? TossColors.primary : TossColors.textPrimary,
                                fontSize: TossTextStyles.h3.fontSize! * 0.7,
                              ),
                            ),
                            Text(
                              currency.currencyCode,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textSecondary,
                                fontSize: TossTextStyles.caption.fontSize! * 0.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomButton() {
    if (_currentStep == 1) {
      return SizedBox(
        width: double.infinity,
        child: TossPrimaryButton(
          text: 'Continue',
          onPressed: _isBusinessNameValid ? () {
            setState(() {
              _currentStep = 2;
            });
          } : null,
          fullWidth: true,
        ),
      );
    } else if (_currentStep == 2) {
      // Enable button if: (1) predefined type selected OR (2) custom type entered
      final hasValidType = _selectedTypeId != null ||
          (_isCustomTypeSelected && _customTypeController.text.trim().isNotEmpty);

      return SizedBox(
        width: double.infinity,
        child: TossPrimaryButton(
          text: 'Continue',
          onPressed: hasValidType ? () {
            setState(() {
              _currentStep = 3;
            });
          } : null,
          fullWidth: true,
        ),
      );
    } else {
      // Step 3
      return SizedBox(
        width: double.infinity,
        child: TossPrimaryButton(
          text: _isLoading ? 'Creating Company...' : 'Create Company',
          onPressed: _selectedCurrencyId != null && !_isLoading
              ? _handleCreateBusiness
              : null,
          isLoading: _isLoading,
          fullWidth: true,
        ),
      );
    }
  }

  // ==========================================
  // Business Logic - Clean Architecture
  // ==========================================

  Future<void> _handleCreateBusiness() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTypeId == null || _selectedCurrencyId == null) {
      _showErrorSnackbar('Please select business type and currency');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ✅ Clean Architecture: Use companyServiceProvider
      final companyService = ref.read(companyServiceProvider);

      // Get current user ID
      final userId = ref.read(currentUserIdProvider);

      if (userId == null) {
        throw const AuthException('User not authenticated');
      }

      final company = await companyService.createCompany(
        name: _businessNameController.text.trim(),
        ownerId: userId,
        companyTypeId: _selectedTypeId!,
        currencyId: _selectedCurrencyId!,
        otherTypeDetail: _isCustomTypeSelected && _customTypeController.text.trim().isNotEmpty
            ? _customTypeController.text.trim()
            : null,
      );

      // ✅ WORKFLOW: Update AppState immediately with new company
      // This follows the same pattern as company_store_selector.dart:653-673

      // 1. Add company to user's companies list in AppState (instant UI update)
      ref.read(appStateProvider.notifier).addNewCompanyToUser(
        companyId: company.id,
        companyName: company.name,
        companyCode: company.companyCode,
        role: <String, dynamic>{'role_name': 'Owner', 'permissions': <dynamic>[]},
      );

      // 2. Set the new company as selected
      ref.read(appStateProvider.notifier).selectCompany(
        company.id,
        companyName: company.name,
      );

      // 3. Invalidate providers to refresh data from server (background)
      ref.invalidate(userCompaniesProvider);

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Business created! Company Code: ${company.companyCode}',
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        if (mounted) {
          await Future.delayed(const Duration(milliseconds: 300));

          // Show dialog asking if user wants to create store or go to dashboard
          if (mounted) {
            final shouldCreateStore = await _showSuccessDialog(
              company.name,
              company.companyCode ?? 'N/A',
            );

            if (mounted) {
              _animationController.stop();

              if (shouldCreateStore == true) {
                // Navigate to Create Store page
                context.push('/onboarding/create-store', extra: {
                  'companyId': company.id,
                  'companyName': company.name,
                },);
              } else {
                // Go to dashboard
                await _navigateToDashboard();
              }
            }
          }
        }
      }
    } on ValidationException catch (e) {
      if (mounted) {
        _showErrorSnackbar(e.message);
      }
    } on CompanyNameExistsException catch (e) {
      if (mounted) {
        _showErrorSnackbar(e.message);
      }
    } on NetworkException {
      if (mounted) {
        _showErrorSnackbar('Connection issue. Please check your internet and try again.');
      }
    } on AuthException catch (e) {
      if (mounted) {
        _showErrorSnackbar(e.message);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Unable to create business. Please try again or contact support.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToDashboard() async {
    try {
      // ✅ WORKFLOW: AppState is already updated in _handleCreateCompany()
      // No need to fetch from server again - just navigate to dashboard
      // The userCompaniesProvider will use the cached data from AppState

      // Small delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Failed to load dashboard. Please sign in again.');
        context.go('/auth/login');
      }
    }
  }

  Future<bool?> _showSuccessDialog(String companyName, String companyCode) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Business Created!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your business "$companyName" has been created successfully.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(color: TossColors.border),
              ),
              child: Column(
                children: [
                  Text(
                    'Company Code:',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        companyCode,
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      IconButton(
                        icon: const Icon(
                          Icons.copy,
                          color: TossColors.primary,
                          size: 20,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: companyCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Company code copied!'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Copy code',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Share this code with your team members to invite them.',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                foregroundColor: TossColors.white,
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
              ),
              child: const Text('Create Store'),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: TossColors.white, size: 20),
            const SizedBox(width: TossSpacing.space2),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: TossColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
      ),
    );
  }

}
