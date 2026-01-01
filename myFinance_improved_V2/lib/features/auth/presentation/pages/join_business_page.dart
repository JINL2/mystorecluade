import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../shared/themes/toss_border_radius.dart';
// Core - Theme System
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
// Domain Layer
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/exceptions/validation_exception.dart';
// Homepage - Providers (for userCompaniesProvider)
import '../../../homepage/presentation/providers/homepage_providers.dart';
// Presentation - Providers
import '../providers/usecase_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Join Business Page - Clean Architecture Version
///
/// Features:
/// - Enter company code
/// - Validate code format
/// - Join company using UseCase
/// - Success feedback with company name
/// - Navigate to dashboard
class JoinBusinessPage extends ConsumerStatefulWidget {
  const JoinBusinessPage({super.key});

  @override
  ConsumerState<JoinBusinessPage> createState() => _JoinBusinessPageState();
}

class _JoinBusinessPageState extends ConsumerState<JoinBusinessPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _codeFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isCodeValid = false;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_validateCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  void _validateCode() {
    final code = _codeController.text.trim();
    final isValid = code.length >= 6;
    if (isValid != _isCodeValid) {
      setState(() {
        _isCodeValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: TossSpacing.space4),
                      _buildWelcomeSection(),
                      const SizedBox(height: TossSpacing.space6),
                      _buildCodeField(),
                      const SizedBox(height: TossSpacing.space6),
                      _buildJoinButton(),
                      const SizedBox(height: TossSpacing.space4),
                      _buildAlternativeOptions(),
                      const SizedBox(height: TossSpacing.space6),
                      _buildHelpSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
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
            icon: const Icon(Icons.arrow_back, color: TossColors.gray900),
            onPressed: () {
              // Safe navigation back - go to choose-role instead of pop
              context.go('/onboarding/choose-role');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: const Icon(
                Icons.group_add,
                size: 32,
                color: TossColors.success,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join Business',
                    style: TossTextStyles.h2.copyWith(
                      color: TossColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        Text(
          'Enter the code shared by your business owner to join their company.',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Business Code',
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TextFormField(
          controller: _codeController,
          focusNode: _codeFocusNode,
          textCapitalization: TextCapitalization.characters,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleJoinBusiness(),
          style: TossTextStyles.body.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
          decoration: InputDecoration(
            hintText: 'Enter 6+ character code',
            hintStyle: TossTextStyles.body.copyWith(
              color: TossColors.textTertiary,
            ),
            filled: true,
            fillColor: TossColors.gray50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.error, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Business code is required';
            }
            if (value.trim().length < 6) {
              return 'Code must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildJoinButton() {
    final canJoin = _isCodeValid && !_isLoading;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canJoin ? _handleJoinBusiness : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canJoin ? TossColors.success : TossColors.gray300,
          foregroundColor: TossColors.white,
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
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
                  const Icon(Icons.group_add, size: 18),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    'Join Business',
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

  Widget _buildAlternativeOptions() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: TossColors.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
              child: Text(
                'or',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ),
            const Expanded(child: Divider(color: TossColors.border)),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        TextButton(
          onPressed: () => context.go('/onboarding/create-business'),
          child: Text(
            'Create your own business instead',
            style: TossTextStyles.body.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Need help?',
            style: TossTextStyles.body.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            '• Ask your business owner for the company code\n'
            '• The code is usually 6-10 characters\n'
            '• Code is case-insensitive',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleJoinBusiness() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) {
        throw const AuthException('Not authenticated');
      }

      // ✅ Use JoinCompanyUseCase provider
      final joinCompanyUseCase = ref.read(joinCompanyUseCaseProvider);
      final company = await joinCompanyUseCase.execute(
        companyCode: _codeController.text.trim(),
        userId: userId,
      );

      // ✅ Use GetUserDataUseCase instead of direct RPC call
      final getUserDataUseCase = ref.read(getUserDataUseCaseProvider);
      final filteredResponse = await getUserDataUseCase.execute(userId);

      // Update app state
      ref.read(appStateProvider.notifier).updateUser(
        user: filteredResponse,
        isAuthenticated: true,
      );

      // ✅ Auto-select the newly joined company
      final companies = filteredResponse['companies'] as List?;
      if (companies != null && companies.isNotEmpty) {
        // Find the joined company (the one matching company.id)
        final joinedCompany = companies.firstWhere(
          (c) => (c as Map<String, dynamic>)['company_id'] == company.id,
          orElse: () => companies.first,
        ) as Map<String, dynamic>;

        final companyId = joinedCompany['company_id'] as String;
        final companyName = joinedCompany['company_name'] as String;

        ref.read(appStateProvider.notifier).selectCompany(
          companyId,
          companyName: companyName,
        );

        // Auto-select first store if available
        final stores = joinedCompany['stores'] as List?;
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

      // ✅ Invalidate userCompaniesProvider to refresh data from server (background)
      ref.invalidate(userCompaniesProvider);

      if (mounted) {
        // Show success dialog
        final shouldNavigate = await _showSuccessDialog(company.name);

        if (shouldNavigate == true && mounted) {
          // Small delay for smooth transition (same as create_business_page)
          await Future.delayed(const Duration(milliseconds: 300));

          if (mounted) {
            context.go('/');
          }
        }
      }
    } on ValidationException catch (e) {
      if (mounted) {
        _showErrorSnackbar(e.message);
      }
    } on InvalidCompanyCodeException catch (_) {
      if (mounted) {
        _showErrorSnackbar('Invalid company code. Please check and try again.');
      }
    } on AlreadyMemberException catch (_) {
      if (mounted) {
        _showErrorSnackbar('You are already a member of this company.');
      }
    } on NetworkException catch (_) {
      if (mounted) {
        _showErrorSnackbar('Network error. Please check your connection.');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Failed to join business. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool?> _showSuccessDialog(String companyName) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: TossColors.success, size: 28),
            SizedBox(width: TossSpacing.space2),
            Text('Success!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'You have successfully joined',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              companyName,
              style: TossTextStyles.h3.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w700,
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
              child: const Text('Go to Dashboard'),
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
