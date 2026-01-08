import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/constants/auth_constants.dart';
import '../../../homepage/presentation/providers/homepage_providers.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/exceptions/validation_exception.dart';
import '../../domain/value_objects/company_type.dart';
import '../../domain/value_objects/currency.dart';
import '../providers/company_service.dart';
import '../widgets/create_business/create_business_widgets.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Create Business Page - Clean Architecture Version
///
/// Multi-step wizard for creating a new business/company.
/// Step 1: Business Name → Step 2: Business Type → Step 3: Currency
class CreateBusinessPage extends ConsumerStatefulWidget {
  const CreateBusinessPage({super.key});

  @override
  ConsumerState<CreateBusinessPage> createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends ConsumerState<CreateBusinessPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _businessNameController = TextEditingController();
  final _customTypeController = TextEditingController();

  // Focus Nodes
  final _businessNameFocusNode = FocusNode();
  final _customTypeFocusNode = FocusNode();

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State
  bool _isLoading = false;
  int _currentStep = 1;
  String? _selectedTypeId;
  String? _selectedCurrencyId;
  List<CompanyType> _companyTypes = [];
  List<Currency> _currencies = [];
  bool _isCustomTypeSelected = false;
  bool _isBusinessNameValid = false;

  @override
  void initState() {
    super.initState();
    _loadCompanyTypes();
    _loadCurrencies();
    _initAnimations();
    _businessNameController.addListener(_validateBusinessName);
    _animationController.forward();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: TossAnimations.standard),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: TossAnimations.standard),
    );
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
    } catch (_) {}
  }

  void _loadCurrencies() async {
    try {
      final companyService = ref.read(companyServiceProvider);
      final currencies = await companyService.getCurrencies();
      if (mounted) {
        setState(() {
          _currencies = currencies;
          final usd = currencies.where((c) => c.currencyCode == 'USD').firstOrNull;
          _selectedCurrencyId = usd?.currencyId ?? currencies.firstOrNull?.currencyId;
        });
      }
    } catch (_) {}
  }

  void _validateBusinessName() {
    final name = _businessNameController.text.trim();
    final isValid = name.length >= AuthConstants.nameMinLength;
    if (isValid != _isBusinessNameValid) {
      setState(() => _isBusinessNameValid = isValid);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _businessNameController.dispose();
    _customTypeController.dispose();
    _businessNameFocusNode.dispose();
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
            _buildHeader(),
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
                          ProgressIndicatorWidget(currentStep: _currentStep),
                          const SizedBox(height: TossSpacing.space8),
                          _buildCurrentStep(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: TossColors.textPrimary),
            onPressed: () {
              if (_currentStep > 1) {
                setState(() => _currentStep--);
              } else {
                context.go('/onboarding/choose-role');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return Step1BusinessName(
          controller: _businessNameController,
          focusNode: _businessNameFocusNode,
        );
      case 2:
        return Step2BusinessType(
          companyTypes: _companyTypes,
          selectedTypeId: _selectedTypeId,
          isCustomTypeSelected: _isCustomTypeSelected,
          customTypeController: _customTypeController,
          customTypeFocusNode: _customTypeFocusNode,
          onTypeSelected: (typeId) => setState(() => _selectedTypeId = typeId),
          onCustomTypeToggled: (isCustom) => setState(() => _isCustomTypeSelected = isCustom),
        );
      case 3:
        return Step3Currency(
          currencies: _currencies,
          selectedCurrencyId: _selectedCurrencyId,
          onCurrencySelected: (currencyId) => setState(() => _selectedCurrencyId = currencyId),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: _buildBottomButton(),
    );
  }

  Widget _buildBottomButton() {
    switch (_currentStep) {
      case 1:
        return SizedBox(
          width: double.infinity,
          child: TossButton.primary(
            text: 'Continue',
            onPressed: _isBusinessNameValid ? () => setState(() => _currentStep = 2) : null,
            fullWidth: true,
          ),
        );
      case 2:
        final hasValidType = _selectedTypeId != null ||
            (_isCustomTypeSelected && _customTypeController.text.trim().isNotEmpty);
        return SizedBox(
          width: double.infinity,
          child: TossButton.primary(
            text: 'Continue',
            onPressed: hasValidType ? () => setState(() => _currentStep = 3) : null,
            fullWidth: true,
          ),
        );
      case 3:
        return SizedBox(
          width: double.infinity,
          child: TossButton.primary(
            text: _isLoading ? 'Creating Company...' : 'Create Company',
            onPressed: _selectedCurrencyId != null && !_isLoading ? _handleCreateBusiness : null,
            isLoading: _isLoading,
            fullWidth: true,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _handleCreateBusiness() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTypeId == null || _selectedCurrencyId == null) {
      _showErrorSnackbar('Please select business type and currency');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final companyService = ref.read(companyServiceProvider);
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

      // Update AppState with new company
      ref.read(appStateProvider.notifier).addNewCompanyToUser(
        companyId: company.id,
        companyName: company.name,
        companyCode: company.companyCode,
        role: <String, dynamic>{'role_name': 'Owner', 'permissions': <dynamic>[]},
      );

      ref.read(appStateProvider.notifier).selectCompany(company.id, companyName: company.name);
      ref.invalidate(userCompaniesProvider);

      if (mounted) {
        _showSuccessSnackbar('Business created! Company Code: ${company.companyCode}');

        await Future.delayed(TossAnimations.slow);

        if (mounted) {
          final shouldCreateStore = await CreateBusinessSuccessDialog.show(
            context,
            companyName: company.name,
            companyCode: company.companyCode ?? 'N/A',
          );

          if (mounted) {
            _animationController.stop();
            if (shouldCreateStore == true) {
              context.push('/onboarding/create-store', extra: {
                'companyId': company.id,
                'companyName': company.name,
              });
            } else {
              context.go('/');
            }
          }
        }
      }
    } on ValidationException catch (e) {
      if (mounted) _showErrorSnackbar(e.message);
    } on CompanyNameExistsException catch (e) {
      if (mounted) _showErrorSnackbar(e.message);
    } on NetworkException {
      if (mounted) _showErrorSnackbar('Connection issue. Please check your internet and try again.');
    } on AuthException catch (e) {
      if (mounted) _showErrorSnackbar(e.message);
    } catch (_) {
      if (mounted) _showErrorSnackbar('Unable to create business. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackbar(String message) {
    TossToast.success(context, message);
  }

  void _showErrorSnackbar(String message) {
    TossToast.error(context, message);
  }
}
