import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../providers/homepage_providers.dart';
import '../providers/notifier_providers.dart';
import '../providers/states/store_state.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Create Store Bottom Sheet Widget
/// Uses Riverpod StateNotifier for state management
/// Matches legacy UI from modern_bottom_drawer.dart lines 1087-1279
class CreateStoreSheet extends ConsumerStatefulWidget {
  const CreateStoreSheet({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  final String companyId;
  final String companyName;

  @override
  ConsumerState<CreateStoreSheet> createState() => _CreateStoreSheetState();
}

class _CreateStoreSheetState extends ConsumerState<CreateStoreSheet> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Reset state when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storeNotifierProvider.notifier).reset();
    });
  }

  bool get _isFormValid => _nameController.text.trim().isNotEmpty;

  void _createStore() {
    if (!_isFormValid) {
      return;
    }

    ref.read(storeNotifierProvider.notifier).createStore(
          storeName: _nameController.text.trim(),
          companyId: widget.companyId,
          storeAddress: _addressController.text.trim().isNotEmpty
              ? _addressController.text.trim()
              : null,
          storePhone: _phoneController.text.trim().isNotEmpty
              ? _phoneController.text.trim()
              : null,
        );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    TossToast.success(context, 'Code "$text" copied to clipboard!');
  }

  @override
  Widget build(BuildContext context) {
    // Listen to store state changes
    ref.listen<StoreState>(storeNotifierProvider, (previous, next) {
      next.when(
        initial: () {
          // Do nothing
        },
        loading: () {
          // Show loading snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  TossLoadingView.inline(size: 20, color: TossColors.white),
                  SizedBox(width: 12),
                  Text('Creating store...'),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              duration: const Duration(seconds: 30),
            ),
          );
        },
        error: (message, errorCode) {
          // Hide loading, show error
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: TossColors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text(message)),
                ],
              ),
              backgroundColor: TossColors.error,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Retry',
                textColor: TossColors.white,
                onPressed: _createStore,
              ),
            ),
          );
        },
        created: (store) {
          // Hide loading
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // 1. AppState 즉시 업데이트 (UI 반영)
          final appStateNotifier = ref.read(appStateProvider.notifier);
          appStateNotifier.addNewStoreToCompany(
            companyId: widget.companyId,
            storeId: store.id,
            storeName: store.name,
            storeCode: store.code,
          );

          // 2. 새로 생성한 스토어를 선택
          appStateNotifier.selectStore(
            store.id,
            storeName: store.name,
          );

          // 3. Provider invalidate (백그라운드에서 서버 최신 데이터 재조회)
          ref.invalidate(userCompaniesProvider);

          // 4. Close bottom sheet and return store
          Navigator.of(context).pop(store);

          // 5. Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: TossColors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Store "${store.name}" created successfully!'),
                  ),
                ],
              ),
              backgroundColor: TossColors.success,
              duration: const Duration(seconds: 3),
              action: store.code.isNotEmpty
                  ? SnackBarAction(
                      label: 'Share Code',
                      textColor: TossColors.white,
                      onPressed: () => _copyToClipboard(store.code),
                    )
                  : null,
            ),
          );
        },
      );
    });

    final state = ref.watch(storeNotifierProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
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
                bottom: TossSpacing.paddingXL,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Store',
                        style: TossTextStyles.h3.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'For ${widget.companyName}',
                        style: TossTextStyles.caption.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TossSpacing.space8),

            // Form
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    // Store Name Input
                    TossTextField.filled(
                      label: 'Store Name',
                      controller: _nameController,
                      hintText: 'Enter store name',
                      autofocus: true,
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: TossSpacing.space6),

                    // Store Address Input (Optional)
                    TossTextField.filled(
                      label: 'Store Address (Optional)',
                      controller: _addressController,
                      hintText: 'Enter store address',
                      maxLines: 2,
                    ),

                    const SizedBox(height: TossSpacing.space6),

                    // Store Phone Input (Optional)
                    TossTextField.filled(
                      label: 'Store Phone (Optional)',
                      controller: _phoneController,
                      hintText: 'Enter store phone number',
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: TossSpacing.space8),

                    // Create Button
                    Builder(
                      builder: (context) {
                        final isValid = _isFormValid;
                        final isLoading = state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );

                        return SizedBox(
                          width: double.infinity,
                          child: TossButton.primary(
                            text: 'Create Store',
                            onPressed: isValid && !isLoading ? _createStore : null,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: TossSpacing.space4),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
