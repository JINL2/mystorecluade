import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../providers/homepage_providers.dart';
import '../providers/notifier_providers.dart';
import '../providers/states/join_state.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
  String? _errorMessage;

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
    // Listen to state changes for navigation and error handling
    ref.listen<JoinState>(joinNotifierProvider, (previous, next) {
      next.when(
        initial: () {
          setState(() => _errorMessage = null);
        },
        loading: () {
          setState(() => _errorMessage = null);
        },
        error: (message, errorCode) {
          // Show error inline in the sheet
          setState(() => _errorMessage = message);
        },
        success: (result) {
          // 1. AppState 즉시 업데이트 (UI 반영)
          final appStateNotifier = ref.read(appStateProvider.notifier);

          if (result.isCompanyJoin && result.companyId != null) {
            // 회사 join - 회사를 user.companies에 추가
            appStateNotifier.addNewCompanyToUser(
              companyId: result.companyId!,
              companyName: result.companyName ?? 'Company',
              role: {'role_name': result.roleAssigned ?? 'Employee', 'permissions': []},
            );
          } else if (result.isStoreJoin && result.storeId != null) {
            // 스토어 join - 스토어를 해당 회사의 stores에 추가
            if (result.companyId != null) {
              appStateNotifier.addNewStoreToCompany(
                companyId: result.companyId!,
                storeId: result.storeId!,
                storeName: result.storeName ?? 'Store',
              );
            }
          }

          // 2. 새로 join한 회사/스토어를 선택
          if (result.companyId != null) {
            appStateNotifier.selectCompany(
              result.companyId!,
              companyName: result.companyName,
            );

            if (result.storeId != null) {
              appStateNotifier.selectStore(
                result.storeId!,
                storeName: result.storeName,
              );
            }
          }

          // 3. Provider invalidate (백그라운드에서 서버 최신 데이터 재조회)
          ref.invalidate(userCompaniesProvider);

          // 4. Sheet 닫기
          Navigator.of(context).pop(result);

          // 5. 성공 메시지 표시
          TossToast.success(context, 'Successfully joined ${result.entityName}!');
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
            width: TossSpacing.space10,
            height: TossSpacing.space1,
            margin: const EdgeInsets.only(
              top: TossSpacing.space2,
              bottom: TossSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: TossColors.textTertiary.withValues(alpha: 0.3),
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
                      SizedBox(height: TossSpacing.space1 / 2),
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
                  TossTextField.filled(
                    controller: _codeController,
                    label: 'Code',
                    hintText: 'Enter invite code',
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
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

                  // Error message (if any)
                  if (_errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(TossSpacing.space3),
                      decoration: BoxDecoration(
                        color: TossColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        border: Border.all(color: TossColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: TossColors.error, size: TossSpacing.iconMD),
                          const SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space4),
                  ],

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
                    child: TossButton.primary(
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
        TossToast.error(context, 'Please log in first');
        return;
      }

      ref.read(joinNotifierProvider.notifier).joinByCode(
            userId: user.id,
            code: _codeController.text.trim(),
          );
    }
  }
}
