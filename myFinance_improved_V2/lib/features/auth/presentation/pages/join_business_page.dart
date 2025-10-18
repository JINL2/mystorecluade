import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core - Theme System
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';

// Presentation - Providers
import '../providers/repository_providers.dart';
import '../../../../app/providers/app_state_provider.dart';

// Domain Layer
import '../../domain/usecases/join_company_usecase.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/exceptions/validation_exception.dart';

// Homepage Data Source (for filtering helper)
import '../../../homepage/data/datasources/homepage_data_source.dart';

// Navigation

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
                padding: EdgeInsets.all(TossSpacing.space5),
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
            icon: Icon(Icons.arrow_back, color: TossColors.gray900),
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

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TossColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
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
            if (_isCodeValid) ...[
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: BorderSide(color: TossColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: BorderSide(color: TossColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: BorderSide(color: TossColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: BorderSide(color: TossColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: BorderSide(color: TossColors.error, width: 2),
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
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
        ),
        child: _isLoading
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
                  Icon(Icons.group_add, size: 18),
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
            Expanded(child: Divider(color: TossColors.border)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
              child: Text(
                'or',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ),
            Expanded(child: Divider(color: TossColors.border)),
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
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                size: 20,
                color: TossColors.primary,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Need help?',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Not authenticated');
      }

      // Get repository
      final companyRepository = ref.read(companyRepositoryProvider);

      // Create UseCase
      final joinCompanyUseCase = JoinCompanyUseCase(
        companyRepository: companyRepository,
      );

      // Execute UseCase
      final company = await joinCompanyUseCase.execute(
        companyCode: _codeController.text.trim(),
        userId: userId,
      );

      // Reload user data with new company
      final supabase = Supabase.instance.client;
      final userResponse = await supabase.rpc(
        'get_user_companies_and_stores',
        params: {'p_user_id': userId},
      );

      if (userResponse is Map<String, dynamic>) {
        // ✅ Filter out deleted companies and stores
        final filteredResponse = HomepageDataSource.filterDeletedCompaniesAndStores(userResponse);

        ref.read(appStateProvider.notifier).updateUser(
          user: filteredResponse,
          isAuthenticated: true,
        );

        // ✅ Auto-select the newly joined company
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

      if (mounted) {
        // Show success dialog
        final shouldNavigate = await _showSuccessDialog(company.name);

        if (shouldNavigate == true && mounted) {
          context.go('/');
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
        title: Row(
          children: [
            Icon(Icons.check_circle, color: TossColors.success, size: 28),
            const SizedBox(width: TossSpacing.space2),
            const Text('Success!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
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
                padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
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
}
