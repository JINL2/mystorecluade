import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../core/homepage_logger.dart';
import '../providers/notifier_providers.dart';

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
    homepageLogger.d('Button pressed - isFormValid: $_isFormValid, Name: "${_nameController.text.trim()}"');

    if (!_isFormValid) {
      homepageLogger.w('Form is invalid, showing alert');

      // Show alert dialog for missing store name
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(width: TossSpacing.space3),
              const Text('Required Fields'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Please fill in the following required fields:'),
              SizedBox(height: TossSpacing.space3),
              Padding(
                padding: const EdgeInsets.only(bottom: TossSpacing.space1),
                child: Text(
                  '• Store Name',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TossButton.primary(
              text: 'OK',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    homepageLogger.i('Calling createStore...');
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
      homepageLogger.d('State changed: ${next.runtimeType}');

      next.when(
        initial: () {
          // Do nothing
        },
        loading: () {
          homepageLogger.d('Showing loading SnackBar');
          SnackBarHelper.showLoading(context, 'Creating store...');
        },
        error: (message, errorCode) {
          homepageLogger.e('Showing error SnackBar: $message');
          SnackBarHelper.hideAndShowError(
            context,
            message,
            onRetry: _createStore,
          );
        },
        created: (store) {
          homepageLogger.i('Store created successfully: ${store.name}');

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

          // 3. Close bottom sheet and return store
          Navigator.of(context).pop(store);

          // 4. Show success message
          SnackBarHelper.hideAndShowSuccess(
            context,
            'Store "${store.name}" created successfully!',
            action: store.code.isNotEmpty
                ? SnackBarAction(
                    label: 'Share Code',
                    textColor: TossColors.white,
                    onPressed: () => _copyToClipboard(store.code),
                  )
                : null,
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
            topLeft: Radius.circular(TossBorderRadius.bottomSheet),
            topRight: Radius.circular(TossBorderRadius.bottomSheet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: TossSpacing.iconXL,
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
