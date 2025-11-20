import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/auth_providers.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../providers/notifier_providers.dart';
import '../providers/states/join_state.dart';

/// Join by Code Bottom Sheet Widget
///
/// Universal widget for joining either a company or store by code
/// The server determines which type based on the code format
class JoinByCodeSheet extends ConsumerStatefulWidget {
  const JoinByCodeSheet({
    super.key,
    required this.title,
    required this.subtitle,
  });

  /// Title (e.g., "Join Company" or "Join Store")
  final String title;

  /// Subtitle (e.g., "Enter company invite code")
  final String subtitle;

  @override
  ConsumerState<JoinByCodeSheet> createState() => _JoinByCodeSheetState();
}

class _JoinByCodeSheetState extends ConsumerState<JoinByCodeSheet> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Reset state when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(joinNotifierProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to state changes for snackbars and navigation
    ref.listen<JoinState>(joinNotifierProvider, (previous, next) {
      next.when(
        initial: () {
          // Do nothing
        },
        loading: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Text('Joining...'),
                ],
              ),
              backgroundColor: TossColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              duration: const Duration(seconds: 30), // Will be dismissed on success/error
            ),
          );
        },
        error: (message, errorCode) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: TossColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              action: SnackBarAction(
                label: 'Retry',
                textColor: TossColors.white,
                onPressed: () => _handleJoin(),
              ),
            ),
          );
        },
        success: (result) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // Close the sheet and return result
          Navigator.of(context).pop(result);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Successfully joined ${result.entityName}! Role: ${result.roleAssigned ?? "Member"}',
              ),
              backgroundColor: TossColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
            ),
          );
        },
      );
    });

    final state = ref.watch(joinNotifierProvider);
    final isLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.bottomSheet),
          topRight: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(
              top: TossSpacing.space2,
              bottom: TossSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: TossColors.textTertiary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TossTextStyles.h3.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close, color: TossColors.textSecondary),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space6),

          // Form
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: TossSpacing.space6,
                right: TossSpacing.space6,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  // Code input field
                  TextFormField(
                    controller: _codeController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Code',
                      hintText: 'Enter invite code',
                      filled: true,
                      fillColor: TossColors.gray100,
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
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a code';
                      }
                      if (value.trim().length < 5) {
                        return 'Code must be at least 5 characters';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _handleJoin(),
                  ),

                  const SizedBox(height: TossSpacing.space4),

                  // Info text
                  Text(
                    'Enter the invite code shared with you',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space6),

                  // Join button
                  SizedBox(
                    width: double.infinity,
                    child: TossPrimaryButton(
                      text: widget.title,
                      onPressed: isLoading ? null : _handleJoin,
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleJoin() {
    if (_formKey.currentState?.validate() ?? false) {
      final authState = ref.read(authStateProvider);
      final user = authState.when(
        data: (user) => user,
        loading: () => null,
        error: (_, __) => null,
      );

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in first'),
            backgroundColor: TossColors.error,
          ),
        );
        return;
      }

      ref.read(joinNotifierProvider.notifier).joinByCode(
            userId: user.id,
            code: _codeController.text.trim(),
          );
    }
  }
}
