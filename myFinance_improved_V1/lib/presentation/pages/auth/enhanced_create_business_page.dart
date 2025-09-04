import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_animations.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_text_field.dart';
import '../../widgets/auth/storebase_auth_header.dart';
import '../../providers/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/auth_constants.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../../core/navigation/safe_navigation.dart';
import '../../../data/services/enhanced_company_service.dart';
import '../../../data/services/company_service.dart';
import '../../widgets/common/toss_success_dialog.dart';
import '../../widgets/common/toss_error_dialog.dart';

class EnhancedCreateBusinessPage extends ConsumerStatefulWidget {
  const EnhancedCreateBusinessPage({super.key});

  @override
  ConsumerState<EnhancedCreateBusinessPage> createState() => _EnhancedCreateBusinessPageState();
}

class _EnhancedCreateBusinessPageState extends ConsumerState<EnhancedCreateBusinessPage>
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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = false;
  String? _businessType;
  String? _selectedCurrencyId;
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
    
    _businessNameController.addListener(_validateBusinessName);
    _businessEmailController.addListener(_validateBusinessEmail);
    
    _animationController.forward();
  }
  
  void _loadCompanyTypes() async {
    final service = ref.read(enhancedCompanyServiceProvider);
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
    final service = ref.read(enhancedCompanyServiceProvider);
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
    return TossScaffold(
      backgroundColor: TossColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
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
              ),
            ),
          ],
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
              _animationController.stop();
              context.safePushReplacement('/onboarding/join-business');
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

  /// Enhanced business creation handler with comprehensive error handling
  Future<void> _handleCreateBusiness() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_businessType == null || _selectedCurrencyId == null) {
      await TossErrorDialogs.showValidationError(
        context: context,
        message: 'Please select business type and currency',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(enhancedCompanyServiceProvider);
      
      final result = await service.createCompanyEnhanced(
        companyName: _businessNameController.text.trim(),
        companyTypeId: _businessType!,
        baseCurrencyId: _selectedCurrencyId!,
      );
      
      if (result.isSuccess) {
        ref.invalidate(appStateProvider);
        
        // Show success dialog with option to continue to store creation
        final shouldContinue = await TossSuccessDialogs.showCompanyCreated(
          context: context,
          companyName: result.companyName!,
          companyCode: result.companyCode,
          onContinue: () => Navigator.of(context).pop(true),
        );

        if (mounted) {
          _animationController.stop();
          
          if (shouldContinue == true) {
            // Navigate to Create Store page
            context.safeGo('/onboarding/create-store', extra: {
              'companyId': result.companyId!,
              'companyName': result.companyName!,
            });
          } else {
            // Go directly to dashboard
            await _navigateToDashboard();
          }
        }
      } else {
        // Show error dialog with retry option
        final shouldRetry = await TossErrorDialogs.showBusinessCreationFailed(
          context: context,
          error: result.error!,
          onRetry: () => Navigator.of(context).pop(true),
        );

        if (shouldRetry == true && mounted) {
          // Retry the creation
          _handleCreateBusiness();
        }
      }
    } catch (e) {
      if (mounted) {
        await TossErrorDialogs.showBusinessCreationFailed(
          context: context,
          error: e.toString(),
          onRetry: () {
            Navigator.of(context).pop(true);
            _handleCreateBusiness();
          },
        );
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
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      
      if (userId != null) {
        await Future.delayed(const Duration(milliseconds: AuthConstants.apiDelayMs));
        
        final results = await Future.wait([
          supabase.rpc(
            'get_user_companies_and_stores',
            params: {'p_user_id': userId},
          ),
          supabase.rpc('get_categories_with_features'),
        ]);
        
        final userResponse = results[0];
        final categoriesResponse = results[1];
        
        await ref.read(appStateProvider.notifier).setUser(userResponse);
        await ref.read(appStateProvider.notifier).setCategoryFeatures(categoriesResponse);
        
        if (mounted) {
          context.safeGo('/');
        }
      }
    } catch (e) {
      if (mounted) {
        context.safeGo('/');
      }
    }
  }
}