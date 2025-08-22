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
import '../../../data/services/company_service.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/simple_onboarding_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/auth_constants.dart';

class CreateBusinessPage extends ConsumerStatefulWidget {
  const CreateBusinessPage({super.key});

  @override
  ConsumerState<CreateBusinessPage> createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends ConsumerState<CreateBusinessPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  final _businessNameController = TextEditingController();
  final _businessEmailController = TextEditingController();
  final _businessPhoneController = TextEditingController();
  final _businessAddressController = TextEditingController();
  
  final _businessNameFocusNode = FocusNode();
  final _businessEmailFocusNode = FocusNode();
  final _businessPhoneFocusNode = FocusNode();
  final _businessAddressFocusNode = FocusNode();
  
  late AnimationController _animationController;
  late AnimationController _successController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _successScaleAnimation;
  
  bool _isLoading = false;
  bool _showSuccess = false;
  String? _businessType;
  String? _selectedCurrencyId;
  String? _companyCode;
  List<CompanyType> _companyTypes = [];
  List<Currency> _currencies = [];
  
  bool _isBusinessNameValid = false;
  bool _isBusinessEmailValid = false;
  
  @override
  void initState() {
    super.initState();
    _loadCompanyTypes();
    _loadCurrencies();
    
    _animationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );
    
    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
    
    _businessNameController.addListener(_validateBusinessName);
    _businessEmailController.addListener(_validateBusinessEmail);
    
    _animationController.forward();
  }
  
  void _loadCompanyTypes() async {
    final service = ref.read(companyServiceProvider);
    final types = await service.getCompanyTypes();
    if (mounted) {
      setState(() {
        _companyTypes = types;
        if (types.isNotEmpty) {
          _businessType = types.first.companyTypeId;
        }
      });
    }
  }
  
  void _loadCurrencies() async {
    final service = ref.read(companyServiceProvider);
    final currencies = await service.getCurrencies();
    if (mounted) {
      setState(() {
        _currencies = currencies;
            final usd = currencies.firstWhere(
          (c) => c.currencyCode == 'USD',
          orElse: () => currencies.first,
        );
        _selectedCurrencyId = usd.currencyId;
      });
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
    _successController.dispose();
    _businessNameController.dispose();
    _businessEmailController.dispose();
    _businessPhoneController.dispose();
    _businessAddressController.dispose();
    _businessNameFocusNode.dispose();
    _businessEmailFocusNode.dispose();
    _businessPhoneFocusNode.dispose();
    _businessAddressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.background,
      resizeToAvoidBottomInset: true, // Ensure keyboard handling
      body: SafeArea(
        child: Column(
          children: [
            const StorebaseAuthHeader(showBackButton: true),
            
            Expanded(
              child: _showSuccess 
                  ? _buildSuccessView()
                  : _buildFormView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
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
                _buildTitleSection(),
                
                const SizedBox(height: TossSpacing.space8),
                
                _buildSectionTitle('Business Information'),
                
                const SizedBox(height: TossSpacing.space4),
                
                _buildBusinessNameField(),
                
                const SizedBox(height: TossSpacing.space4),
                
                _buildBusinessTypeDropdown(),
                
                const SizedBox(height: TossSpacing.space4),
                
                _buildBusinessEmailField(),
                
                const SizedBox(height: TossSpacing.space4),
                
                _buildBusinessPhoneField(),
                
                const SizedBox(height: TossSpacing.space6),
                
                _buildSectionTitle('Business Location'),
                
                const SizedBox(height: TossSpacing.space4),
                
                _buildAddressField(),
                
                const SizedBox(height: TossSpacing.space4),
                
                _buildCurrencyDropdown(),
                
                const SizedBox(height: TossSpacing.space8),
                
                _buildCreateButton(),
                
                const SizedBox(height: TossSpacing.space4),
                
                _buildTermsText(),
                
                const SizedBox(height: TossSpacing.space4),
                
                _buildJoinBusinessOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: ScaleTransition(
        scale: _successScaleAnimation,
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: TossColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 60,
                  color: TossColors.success,
                ),
              ),
              
              const SizedBox(height: TossSpacing.space6),
              
              Text(
                AuthConstants.successBusinessCreated,
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              
              const SizedBox(height: TossSpacing.space3),
              
              Text(
                _businessNameController.text,
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              if (_companyCode != null) ...[
                const SizedBox(height: TossSpacing.space2),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Company Code: $_companyCode',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'Share this code with employees to join',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
              
              const SizedBox(height: TossSpacing.space2),
              
              Text(
                'Your business is ready to go!',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: TossSpacing.space8),
              
              TossPrimaryButton(
                text: 'Go to Dashboard',
                onPressed: () async {
                  try {
                    // Call API to get updated user companies, stores, and categories
                    final supabase = Supabase.instance.client;
                    final userId = supabase.auth.currentUser?.id;
                    
                    if (userId != null) {
                      // Small delay to ensure database has updated
                      await Future.delayed(const Duration(milliseconds: AuthConstants.apiDelayMs));
                      
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
                      
                      final companyCount = userResponse['company_count'] ?? 0;
                      
                      // Note: Do NOT auto-select company here
                      // User will go to create store page, then auto-select when they go to dashboard
                      
                      // Navigate to homepage
                      if (mounted) {
                        context.go('/');
                      }
                    }
                  } catch (e) {
                    // Still navigate to homepage on error
                    if (mounted) {
                      context.go('/');
                    }
                  }
                },
                fullWidth: true,
                leadingIcon: Icon(
                  Icons.dashboard,
                  size: 18,
                  color: TossColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      style: TossTextStyles.labelLarge.copyWith(
        color: TossColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

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
            if (_isBusinessNameValid) ...[
              const SizedBox(width: TossSpacing.space2),
              Icon(
                Icons.check_circle,
                size: 16,
                color: TossColors.success,
              ),
            ],
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
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: TossColors.borderLight,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _businessType,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: TossColors.textSecondary),
              style: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
              ),
              items: _companyTypes.map((type) => 
                DropdownMenuItem(
                  value: type.companyTypeId,
                  child: Text(type.typeName),
                ),
              ).toList(),
              onChanged: (value) {
                setState(() {
                  _businessType = value;
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
        Text(
          'Business Email (Optional)',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _businessEmailController,
          focusNode: _businessEmailFocusNode,
          hintText: AuthConstants.placeholderBusinessEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _businessPhoneFocusNode.requestFocus(),
        ),
      ],
    );
  }

  Widget _buildBusinessPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Phone (Optional)',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _businessPhoneController,
          focusNode: _businessPhoneFocusNode,
          hintText: '+1 234 567 8900',
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
        Text(
          'Business Address (Optional)',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _businessAddressController,
          focusNode: _businessAddressFocusNode,
          hintText: 'Enter your business address',
          textInputAction: TextInputAction.done,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: TossColors.borderLight,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCurrencyId,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: TossColors.textSecondary),
              style: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
              ),
              items: _currencies.map((currency) => 
                DropdownMenuItem(
                  value: currency.currencyId,
                  child: Text('${currency.symbol} ${currency.currencyCode} - ${currency.currencyName}'),
                ),
              ).toList(),
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

  Widget _buildCreateButton() {
    final canCreate = _isBusinessNameValid;
    
    return TossPrimaryButton(
      text: _isLoading ? AuthConstants.loadingCreatingBusiness : AuthConstants.buttonCreateBusiness,
      onPressed: _isLoading || !canCreate ? null : _handleCreateBusiness,
      isLoading: _isLoading,
      fullWidth: true,
      leadingIcon: _isLoading 
          ? null 
          : Icon(
              Icons.business,
              size: 18,
              color: TossColors.white,
            ),
    );
  }

  Widget _buildTermsText() {
    return Center(
      child: Text(
        'By creating a business, you agree to our Terms of Service',
        textAlign: TextAlign.center,
        style: TossTextStyles.caption.copyWith(
          color: TossColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildJoinBusinessOption() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'or',
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          TextButton(
            onPressed: () {
              context.pushReplacement('/onboarding/join-business');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.group_add,
                  size: 18,
                  color: TossColors.primary,
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  'Join existing business',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCreateBusiness() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_businessType == null || _selectedCurrencyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select business type and currency'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(companyServiceProvider);
      
      final companyDetails = await service.createCompany(
        companyName: _businessNameController.text.trim(),
        companyTypeId: _businessType!,
        baseCurrencyId: _selectedCurrencyId!,
      );
      
      if (companyDetails != null) {
        _companyCode = companyDetails['company_code'] ?? 'N/A';
        final companyId = companyDetails['company_id'];
        final companyName = _businessNameController.text.trim();
        
        ref.invalidate(appStateProvider);
        
        // Navigate to Create Store page
        if (mounted) {
          context.go('/onboarding/create-store', extra: {
            'companyId': companyId,
            'companyName': companyName,
          });
        }
      } else {
        throw Exception('Failed to create company');
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
                    'Failed to create business: ${e.toString()}',
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
}