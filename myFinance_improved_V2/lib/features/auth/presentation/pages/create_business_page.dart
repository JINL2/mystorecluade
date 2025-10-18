import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

// Shared - Themes
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';

// Core - Constants & Navigation
import '../../../../core/constants/auth_constants.dart';

// App - Providers
import '../../../../app/providers/app_state_provider.dart';

// Presentation - Providers
import '../providers/company_service.dart';

// Domain - Value Objects
import '../../domain/value_objects/company_type.dart';
import '../../domain/value_objects/currency.dart';

// Domain - Exceptions
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/exceptions/validation_exception.dart';

// Homepage Data Source (for filtering helper)
import '../../../homepage/data/datasources/homepage_data_source.dart';

// Core - Infrastructure
import '../../../../core/cache/auth_data_cache.dart';

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

  // Focus Nodes
  final _businessNameFocusNode = FocusNode();
  final _businessEmailFocusNode = FocusNode();
  final _businessPhoneFocusNode = FocusNode();
  final _businessAddressFocusNode = FocusNode();

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State
  bool _isLoading = false;
  String? _selectedTypeId;
  String? _selectedCurrencyId;
  List<CompanyType> _companyTypes = [];
  List<Currency> _currencies = [];

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
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ));

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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildAuthHeader(),

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

  // ==========================================
  // Header
  // ==========================================

  Widget _buildAuthHeader() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(
            color: TossColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: TossColors.textPrimary),
            onPressed: () {
              // Safe navigation back - go to choose-role instead of pop
              context.go('/onboarding/choose-role');
            },
          ),
          const SizedBox(width: TossSpacing.space2),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: TossColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.store,
              color: TossColors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'Storebase',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
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
        _buildTextField(
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
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: 4),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
            border: Border.all(color: TossColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTypeId,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: TossColors.textSecondary),
              style: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: TossColors.white,
              items: _companyTypes
                  .map((type) => DropdownMenuItem(
                        value: type.companyTypeId,
                        child: Text(type.typeName),
                      ))
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
        _buildTextField(
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
        _buildTextField(
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
        _buildTextField(
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
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: 4),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
            border: Border.all(color: TossColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCurrencyId,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: TossColors.textSecondary),
              style: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: TossColors.white,
              items: _currencies
                  .map((currency) => DropdownMenuItem(
                        value: currency.currencyId,
                        child: Text('${currency.currencyCode} - ${currency.currencyName}'),
                      ))
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

    return _buildPrimaryButton(
      text: _isLoading ? 'Creating business...' : 'Create Business',
      onPressed: _isLoading || !canCreate ? null : _handleCreateBusiness,
      isLoading: _isLoading,
      icon: _isLoading
          ? null
          : Icon(
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
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      final company = await companyService.createCompany(
        name: _businessNameController.text.trim(),
        ownerId: userId,
        companyTypeId: _selectedTypeId!,
        currencyId: _selectedCurrencyId!,
        email: _businessEmailController.text.trim().isEmpty
            ? null
            : _businessEmailController.text.trim(),
        phone: _businessPhoneController.text.trim().isEmpty
            ? null
            : _businessPhoneController.text.trim(),
        address: _businessAddressController.text.trim().isEmpty
            ? null
            : _businessAddressController.text.trim(),
      );

      // Invalidate app state to force refresh
      ref.invalidate(appStateProvider);

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: TossColors.white, size: 20),
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
                });
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
    } on NetworkException catch (e) {
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
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId != null) {
        // Small delay for backend to update
        await Future.delayed(const Duration(milliseconds: 500));

        final cache = AuthDataCache.instance;

        // Fetch user data and categories using cache
        final results = await Future.wait([
          cache.deduplicate(
            'user_data_$userId',
            () => supabase.rpc(
              'get_user_companies_and_stores',
              params: {'p_user_id': userId},
            ),
          ),
          cache.deduplicate(
            'categories_features',
            () => supabase.rpc('get_categories_with_features'),
          ),
        ]);

        final userResponse = results[0];
        final categoriesResponse = results[1];

        // Update app state
        if (userResponse is Map<String, dynamic>) {
          // ✅ Filter out deleted companies and stores
          final filteredResponse = HomepageDataSource.filterDeletedCompaniesAndStores(userResponse);

          ref.read(appStateProvider.notifier).updateUser(
            user: filteredResponse,
            isAuthenticated: true,
          );

          // ✅ Auto-select first company and store for better UX
          final companies = filteredResponse['companies'] as List?;
          if (companies != null && companies.isNotEmpty) {
            final firstCompany = companies.first as Map<String, dynamic>;
            final companyId = firstCompany['company_id'] as String;
            final companyName = firstCompany['company_name'] as String;

            ref.read(appStateProvider.notifier).selectCompany(
              companyId,
              companyName: companyName,
            );

            // Auto-select first store if available
            final stores = firstCompany['stores'] as List?;
            if (stores != null && stores.isNotEmpty) {
              final firstStore = stores.first as Map<String, dynamic>;
              final storeId = firstStore['store_id'] as String;
              final storeName = firstStore['store_name'] as String;

              ref.read(appStateProvider.notifier).selectStore(
                storeId,
                storeName: storeName,
              );
            }
          }
        }

        if (categoriesResponse is List) {
          ref.read(appStateProvider.notifier).updateCategoryFeatures(categoriesResponse);
        }

        if (mounted) {
          context.go('/');
        }
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
        title: Row(
          children: [
            Icon(Icons.check_circle, color: TossColors.success, size: 28),
            const SizedBox(width: TossSpacing.space2),
            const Text('Business Created!'),
          ],
        ),
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
              padding: EdgeInsets.all(TossSpacing.space3),
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
                  Text(
                    companyCode,
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
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
                padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
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
            Icon(Icons.error_outline, color: TossColors.white, size: 20),
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

  // ==========================================
  // Temporary Widget Implementations
  // ==========================================

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      style: TossTextStyles.body.copyWith(
        color: TossColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TossTextStyles.body.copyWith(
          color: TossColors.textTertiary,
        ),
        filled: true,
        fillColor: TossColors.gray50,
        contentPadding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          borderSide: BorderSide(color: TossColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          borderSide: BorderSide(color: TossColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          borderSide: BorderSide(color: TossColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          borderSide: BorderSide(color: TossColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          borderSide: BorderSide(color: TossColors.error, width: 2),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null ? TossColors.gray300 : TossColors.primary,
          foregroundColor: TossColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConstants.borderRadiusStandard),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space5,
            vertical: TossSpacing.space3,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon,
                    const SizedBox(width: TossSpacing.space2),
                  ],
                  Text(
                    text,
                    style: TossTextStyles.button.copyWith(
                      color: TossColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
