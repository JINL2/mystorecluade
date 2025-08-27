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
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/auth_constants.dart';
import '../../widgets/common/toss_scaffold.dart';

class JoinBusinessPage extends ConsumerStatefulWidget {
  const JoinBusinessPage({super.key});

  @override
  ConsumerState<JoinBusinessPage> createState() => _JoinBusinessPageState();
}

class _JoinBusinessPageState extends ConsumerState<JoinBusinessPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _codeFocusNode = FocusNode();
  
  late AnimationController _animationController;
  late AnimationController _successController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _successScaleAnimation;
  
  bool _isLoading = false;
  bool _showSuccess = false;
  String? _companyName;
  
  @override
  void initState() {
    super.initState();
    
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
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _successController.dispose();
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.background,
      resizeToAvoidBottomInset: true, // Ensure keyboard handling
      body: SafeArea(
        child: Column(
          children: [
            const StorebaseAuthHeader(showBackButton: true),
            
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(TossSpacing.space5),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Form(
                      key: _formKey,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _showSuccess 
                              ? _buildSuccessView()
                              : _buildCodeEntryView(),
                        ),
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

  Widget _buildCodeEntryView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: TossColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.vpn_key,
            size: 40,
            color: TossColors.primary,
          ),
        ),
        
        const SizedBox(height: TossSpacing.space6),
        
        Text(
          'Enter Business Code',
          style: TossTextStyles.h2.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        
        const SizedBox(height: TossSpacing.space3),
        
        Text(
          'Ask your employer or manager for the business code to join your company',
          textAlign: TextAlign.center,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
            height: 1.5,
          ),
        ),
        
        const SizedBox(height: TossSpacing.space8),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Code',
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            TossTextField(
              controller: _codeController,
              focusNode: _codeFocusNode,
              hintText: AuthConstants.placeholderBusinessCode,
              onChanged: (value) {
                setState(() {
                  final normalizedValue = value.toUpperCase();
                  _codeController.text = normalizedValue;
                  _codeController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _codeController.text.length),
                  );
                });
                
                // Auto-join when maximum length is reached
                if (value.length == AuthConstants.businessCodeMaxLength) {
                  _handleJoinBusiness();
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AuthConstants.errorBusinessCodeRequired;
                }
                if (value.length < AuthConstants.businessCodeMinLength || 
                    value.length > AuthConstants.businessCodeMaxLength) {
                  return AuthConstants.errorBusinessCodeLength;
                }
                return null;
              },
            ),
          ],
        ),
        
        const SizedBox(height: TossSpacing.space6),
        
        TossPrimaryButton(
          text: _isLoading ? AuthConstants.loadingVerifyingCode : AuthConstants.buttonJoinBusiness,
          onPressed: _isLoading || _codeController.text.trim().isEmpty
              ? null 
              : _handleJoinBusiness,
          isLoading: _isLoading,
          fullWidth: true,
          leadingIcon: _isLoading 
              ? null 
              : Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: TossColors.white,
                ),
        ),
        
        const SizedBox(height: TossSpacing.space4),
        
        _buildAlternativeOptions(),
        
        const SizedBox(height: TossSpacing.space6),
        
        _buildHelpSection(),
      ],
    );
  }

  Widget _buildSuccessView() {
    return ScaleTransition(
      scale: _successScaleAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            AuthConstants.successBusinessJoined,
            style: TossTextStyles.h2.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          
          const SizedBox(height: TossSpacing.space3),
          
          if (_companyName != null) ...[
            Text(
              'Welcome to',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              _companyName!,
              style: TossTextStyles.h3.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          
          const SizedBox(height: TossSpacing.space8),
          
          TossPrimaryButton(
            text: 'Go to Dashboard',
            onPressed: () async {
              try {
                // Stop animations for smoother transition
                _animationController.stop();
                _successController.stop();
                
                // Call API to get updated user companies and stores
                final supabase = Supabase.instance.client;
                final userId = supabase.auth.currentUser?.id;
                
                if (userId != null) {
                  // Small delay to ensure database has updated
                  await Future.delayed(const Duration(milliseconds: 500));
                  
                  final response = await supabase.rpc(
                    'get_user_companies_and_stores',
                    params: {'p_user_id': userId},
                  );
                  
                  // Store in app state
                  await ref.read(appStateProvider.notifier).setUser(response);
                  
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
    );
  }

  Widget _buildAlternativeOptions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: TossColors.borderLight,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
              child: Text(
                'or',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: TossColors.borderLight,
                thickness: 1,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: TossSpacing.space4),
        
        TextButton(
          onPressed: () {
            // Stop animations for smoother transition
            _animationController.stop();
            _successController.stop();
            
            context.pushReplacement('/onboarding/create-business');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.business,
                size: 20,
                color: TossColors.primary,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Create a new business instead',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TossColors.info.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: TossColors.info,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Where to find your code?',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            '• Ask your manager or business owner\n'
            '• Check your invitation email\n'
            '• Look for it in your onboarding materials',
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
      final service = ref.read(companyServiceProvider);
      
      final result = await service.joinCompany(
        companyCode: _codeController.text.trim(),
      );
      
      if (result != null) {
        ref.invalidate(appStateProvider);
        
        setState(() {
          _showSuccess = true;
          _companyName = result['company_name'] ?? 'Unknown Company';
        });
        
        _successController.forward();
      } else {
        throw Exception('Failed to join company');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Invalid code. Please check and try again.';
        
        if (e.toString().contains('Invalid company code')) {
          errorMessage = 'Invalid company code. Please check and try again.';
        } else if (e.toString().contains('already a member')) {
          errorMessage = 'You are already a member of this company.';
        } else if (e.toString().contains('No user logged in')) {
          errorMessage = 'Please log in first.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: TossColors.white, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    errorMessage,
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