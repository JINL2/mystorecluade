import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// App - Providers
import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
// Core - Constants & Navigation
import '../../../../core/constants/auth_constants.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
// Shared - Widgets
import '../../../../shared/widgets/toss/toss_text_field.dart';
// Domain - Exceptions
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/exceptions/validation_exception.dart';
// Presentation - Providers
import '../providers/store_service.dart';
import '../providers/usecase_providers.dart';

/// Create Store Page - Clean Architecture Version
///
/// Page for creating a new store within a company after business creation.
///
/// Features:
/// - Store name input with validation
/// - Optional fields: address, phone
/// - Operational settings: huddle time, payment time, distance
/// - Success screen with store code display
/// - Navigation to dashboard after completion
///
/// Architecture:
/// - Uses storeServiceProvider (Clean Architecture)
/// - Receives companyId and companyName from navigation extras
/// - Uses AuthDataCache for data fetching
class CreateStorePage extends ConsumerStatefulWidget {
  const CreateStorePage({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  final String companyId;
  final String companyName;

  @override
  ConsumerState<CreateStorePage> createState() => _CreateStorePageState();
}

class _CreateStorePageState extends ConsumerState<CreateStorePage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _storeNameController = TextEditingController();
  final _storeAddressController = TextEditingController();
  final _storePhoneController = TextEditingController();
  final _huddleTimeController = TextEditingController();
  final _paymentTimeController = TextEditingController();
  final _allowedDistanceController = TextEditingController();

  // Focus Nodes
  final _storeNameFocusNode = FocusNode();
  final _storeAddressFocusNode = FocusNode();
  final _storePhoneFocusNode = FocusNode();

  // Animations
  late AnimationController _animationController;
  late AnimationController _successController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _successFadeAnimation;
  late Animation<double> _successScaleAnimation;

  // State
  bool _isLoading = false;
  bool _showSuccess = false;
  String? _storeCode;

  // Validation State
  bool _isStoreNameValid = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
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
    ),);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ),);

    _successFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.easeIn,
    ),);

    _successScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.easeOutBack,
    ),);

    // Add validation listeners
    _storeNameController.addListener(_validateStoreName);

    _animationController.forward();
  }

  void _validateStoreName() {
    final name = _storeNameController.text.trim();
    final isValid = name.length >= AuthConstants.nameMinLength;
    if (isValid != _isStoreNameValid) {
      setState(() {
        _isStoreNameValid = isValid;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return _buildSuccessScreen();
    }

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
                          _buildTitleSection(),

                          const SizedBox(height: TossSpacing.space8),

                          _buildSectionTitle('Store Information'),

                          const SizedBox(height: TossSpacing.space4),

                          _buildStoreNameField(),

                          const SizedBox(height: TossSpacing.space4),

                          _buildStoreAddressField(),

                          const SizedBox(height: TossSpacing.space4),

                          _buildStorePhoneField(),

                          const SizedBox(height: TossSpacing.space6),

                          _buildSectionTitle('Operational Settings (Optional)'),

                          const SizedBox(height: TossSpacing.space4),

                          _buildOperationalFields(),

                          const SizedBox(height: TossSpacing.space8),

                          _buildCreateButton(),
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
      padding: const EdgeInsets.all(TossSpacing.space4),
      color: TossColors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: TossColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: TossSpacing.space2),
          ClipRRect(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            child: Image.asset(
              'assets/images/app icon.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              widget.companyName,
              style: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: _isLoading ? null : _navigateToDashboard,
            child: Text(
              'Skip',
              style: TossTextStyles.body.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
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
          'Create Your First Store',
          style: TossTextStyles.h1.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Set up a store location for your business. You can add more stores later.',
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
          controller: _storeNameController,
          focusNode: _storeNameFocusNode,
          hintText: AuthConstants.placeholderStoreName,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _storeAddressFocusNode.requestFocus(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter store name';
            }
            return null;
          },
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
          controller: _storeAddressController,
          focusNode: _storeAddressFocusNode,
          hintText: AuthConstants.placeholderStoreAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _storePhoneFocusNode.requestFocus(),
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
          controller: _storePhoneController,
          focusNode: _storePhoneFocusNode,
          hintText: AuthConstants.placeholderStorePhone,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildOperationalFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configure operational settings for this store',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: _buildSmallField(
                controller: _huddleTimeController,
                label: 'Huddle Time',
                hint: 'Minutes',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: _buildSmallField(
                controller: _paymentTimeController,
                label: 'Payment Time',
                hint: 'Days',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        _buildSmallField(
          controller: _allowedDistanceController,
          label: 'Allowed Distance',
          hint: 'Meters',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildSmallField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TossTextStyles.body.copyWith(
              color: TossColors.textTertiary,
            ),
            filled: true,
            fillColor: TossColors.gray50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Action Buttons
  // ==========================================

  Widget _buildCreateButton() {
    final canCreate = _isStoreNameValid;

    return TossPrimaryButton(
      text: _isLoading ? 'Creating store...' : 'Create Store',
      onPressed: _isLoading || !canCreate ? null : _handleCreateStore,
      isLoading: _isLoading,
      fullWidth: true,
    );
  }

  // ==========================================
  // Business Logic - Clean Architecture
  // ==========================================

  Future<void> _handleCreateStore() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ✅ Clean Architecture: Use storeServiceProvider
      final storeService = ref.read(storeServiceProvider);

      // Parse optional numeric fields
      final huddleTime = _huddleTimeController.text.isNotEmpty
          ? int.tryParse(_huddleTimeController.text)
          : null;
      final paymentTime = _paymentTimeController.text.isNotEmpty
          ? int.tryParse(_paymentTimeController.text)
          : null;
      final allowedDistance = _allowedDistanceController.text.isNotEmpty
          ? double.tryParse(_allowedDistanceController.text)
          : null;

      final store = await storeService.createStore(
        name: _storeNameController.text.trim(),
        companyId: widget.companyId,
        address: _storeAddressController.text.trim().isEmpty
            ? null
            : _storeAddressController.text.trim(),
        phone: _storePhoneController.text.trim().isEmpty
            ? null
            : _storePhoneController.text.trim(),
        huddleTimeMinutes: huddleTime,
        paymentTimeDays: paymentTime,
        allowedDistanceMeters: allowedDistance,
      );

      if (mounted) {
        setState(() {
          _showSuccess = true;
          _storeCode = store.storeCode;
          _isLoading = false;
        });

        _successController.forward();
      }
    } on ValidationException catch (e) {
      if (mounted) {
        _showErrorSnackbar(e.message);
        setState(() {
          _isLoading = false;
        });
      }
    } on StoreCodeExistsException catch (e) {
      if (mounted) {
        _showErrorSnackbar(e.message);
        setState(() {
          _isLoading = false;
        });
      }
    } on NetworkException {
      if (mounted) {
        _showErrorSnackbar('Connection issue. Please check your internet and try again.');
        setState(() {
          _isLoading = false;
        });
      }
    } on AuthException catch (e) {
      if (mounted) {
        _showErrorSnackbar(e.message);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Unable to create store. Please try again or contact support.');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToDashboard() async {
    try {
      final userId = ref.read(currentUserIdProvider);

      if (userId == null) {
        throw const AuthException('User not authenticated');
      }

      // Create default store with company name when skipping
      final storeService = ref.read(storeServiceProvider);
      await storeService.createStore(
        name: widget.companyName,
        companyId: widget.companyId,
      );

      // Small delay for backend to update
      await Future.delayed(const Duration(milliseconds: 500));

      // ✅ Use GetUserDataUseCase instead of direct RPC call
      final getUserDataUseCase = ref.read(getUserDataUseCaseProvider);
      final filteredResponse = await getUserDataUseCase.execute(userId);

      // Update app state
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

  // ==========================================
  // Success Screen
  // ==========================================

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _successFadeAnimation,
          child: ScaleTransition(
            scale: _successScaleAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(TossSpacing.space6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: TossColors.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 48,
                        color: TossColors.success,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space6),
                    Text(
                      'Store Created Successfully!',
                      style: TossTextStyles.h1.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: TossSpacing.space4),
                    Text(
                      'Your store has been set up and is ready to use.',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_storeCode != null) ...[
                      const SizedBox(height: TossSpacing.space8),
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.white,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                          border: Border.all(color: TossColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: TossColors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Store Code',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space2),
                            Text(
                              _storeCode!,
                              style: TossTextStyles.h2.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space2),
                            Text(
                              'Share this code with your employees',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: TossSpacing.space8),
                    TossPrimaryButton(
                      text: 'Go to Dashboard',
                      onPressed: _navigateToDashboard,
                      leadingIcon: const Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: TossColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Helper Methods
  // ==========================================

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
