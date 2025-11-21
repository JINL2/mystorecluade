import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../domain/providers/usecase_providers.dart';
import '../../domain/usecases/create_company.dart';
import '../../domain/usecases/create_store.dart';
import '../../domain/usecases/join_by_code.dart';
import '../providers/homepage_providers.dart';
import '../widgets/helpers/snackbar_helpers.dart';

/// Service class for company and store operations
class CompanyStoreService {
  /// Create a new company
  static Future<void> createCompany(
    BuildContext context,
    WidgetRef ref,
    String name,
    String companyTypeId,
    String baseCurrencyId,
  ) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    SnackbarHelpers.showLoading(scaffoldMessenger, 'Creating company "$name"...');

    try {
      final createCompany = ref.read(createCompanyUseCaseProvider);
      final result = await createCompany(CreateCompanyParams(
        companyName: name,
        companyTypeId: companyTypeId,
        baseCurrencyId: baseCurrencyId,
      ));

      SnackbarHelpers.dismiss(scaffoldMessenger);

      result.fold(
        (failure) {
          debugPrint('🔴 [CreateCompany] Failed: ${failure.message}');
          SnackbarHelpers.showError(
            scaffoldMessenger,
            failure.message,
          );
        },
        (company) async {
          debugPrint('🟢 [CreateCompany] Company created successfully: ${company.name}');

          final appStateNotifier = ref.read(appStateProvider.notifier);
          debugPrint('🟢 [CreateCompany] Setting new company as selected: ${company.id}');
          appStateNotifier.selectCompany(company.id, companyName: company.name);

          if (navigator.canPop()) navigator.pop();
          if (navigator.canPop()) navigator.pop();

          debugPrint('🟢 [CreateCompany] Navigating to dashboard with fresh data fetch...');
          await SnackbarHelpers.navigateToDashboard(context, ref);

          SnackbarHelpers.showSuccess(
            scaffoldMessenger,
            'Company "${company.name}" created successfully!',
            actionLabel: 'Share Code',
            onAction: () {
              SnackbarHelpers.copyToClipboard(context, company.code, 'Company code');
            },
          );
        },
      );
    } catch (e) {
      SnackbarHelpers.dismiss(scaffoldMessenger);
      SnackbarHelpers.showError(
        scaffoldMessenger,
        'Error: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }

  /// Join a company by code
  static Future<void> joinCompany(BuildContext context, WidgetRef ref, String code) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    SnackbarHelpers.showLoading(scaffoldMessenger, 'Joining company...');

    try {
      final joinByCode = ref.read(joinByCodeUseCaseProvider);
      final user = ref.read(currentUserProvider);

      if (user == null) {
        SnackbarHelpers.dismiss(scaffoldMessenger);
        SnackbarHelpers.showError(scaffoldMessenger, 'Please log in first');
        return;
      }

      final result = await joinByCode(JoinByCodeParams(
        userId: user.id,
        code: code,
      ));

      result.fold(
        (failure) async {
          debugPrint('🔴 [JoinCompany] Failed: ${failure.message}');
          SnackbarHelpers.dismiss(scaffoldMessenger);

          await TossErrorDialogs.showBusinessJoinFailed(
            context: context,
            error: failure.message,
            onRetry: () {
              Navigator.of(context).pop();
              joinCompany(context, ref, code);
            },
          );
        },
        (joinResult) async {
          debugPrint('🟢 [JoinCompany] Join successful: ${joinResult.entityName}');

          if (navigator.canPop()) navigator.pop();
          if (navigator.canPop()) navigator.pop();

          SnackbarHelpers.dismiss(scaffoldMessenger);

          if (joinResult.companyId != null) {
            final appStateNotifier = ref.read(appStateProvider.notifier);
            appStateNotifier.selectCompany(joinResult.companyId!);

            if (joinResult.storeId != null) {
              appStateNotifier.selectStore(joinResult.storeId!);
            }
          }

          if (context.mounted) {
            await TossSuccessDialogs.showBusinessJoined(
              context: context,
              companyName: joinResult.entityName,
              roleName: joinResult.roleAssigned ?? 'Member',
              onContinue: () {
                Navigator.of(context).pop();
                context.go('/');
              },
            );
          }
        },
      );
    } catch (e) {
      debugPrint('🔴 [JoinCompany] Exception: ${e.toString()}');
      SnackbarHelpers.dismiss(scaffoldMessenger);

      await TossErrorDialogs.showBusinessJoinFailed(
        context: context,
        error: e.toString().replaceAll('Exception: ', ''),
        onRetry: () {
          Navigator.of(context).pop();
          joinCompany(context, ref, code);
        },
      );
    }
  }

  /// Create a new store
  static Future<void> createStore(
    BuildContext context,
    WidgetRef ref,
    String name,
    String companyId,
    String? address,
    String? phone,
  ) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    SnackbarHelpers.showLoading(scaffoldMessenger, 'Creating store "$name"...');

    try {
      final createStore = ref.read(createStoreUseCaseProvider);
      final result = await createStore(CreateStoreParams(
        storeName: name,
        companyId: companyId,
        storeAddress: address,
        storePhone: phone,
      ));

      SnackbarHelpers.dismiss(scaffoldMessenger);

      result.fold(
        (failure) {
          debugPrint('🔴 [CreateStore] Failed: ${failure.message}');
          SnackbarHelpers.showError(
            scaffoldMessenger,
            failure.message,
          );
        },
        (store) async {
          debugPrint('🟢 [CreateStore] Store created successfully: ${store.name}');

          final appStateNotifier = ref.read(appStateProvider.notifier);
          debugPrint('🟢 [CreateStore] Setting company and store as selected: ${store.companyId}, ${store.id}');
          appStateNotifier.selectCompany(store.companyId);
          appStateNotifier.selectStore(store.id, storeName: store.name);

          if (navigator.canPop()) navigator.pop();
          if (navigator.canPop()) navigator.pop();

          await SnackbarHelpers.navigateToDashboard(context, ref);

          SnackbarHelpers.showSuccess(
            scaffoldMessenger,
            'Store "${store.name}" created successfully!',
            actionLabel: 'Share Code',
            onAction: () {
              SnackbarHelpers.copyToClipboard(context, store.code, 'Store code');
            },
          );
        },
      );
    } catch (e) {
      SnackbarHelpers.dismiss(scaffoldMessenger);
      SnackbarHelpers.showError(
        scaffoldMessenger,
        'Error: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }

  /// Join a store by code
  static Future<void> joinStore(BuildContext context, WidgetRef ref, String code) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    SnackbarHelpers.showLoading(scaffoldMessenger, 'Joining store...');

    try {
      final joinByCode = ref.read(joinByCodeUseCaseProvider);
      final user = ref.read(currentUserProvider);

      if (user == null) {
        SnackbarHelpers.dismiss(scaffoldMessenger);
        SnackbarHelpers.showError(scaffoldMessenger, 'Please log in first');
        return;
      }

      final result = await joinByCode(JoinByCodeParams(
        userId: user.id,
        code: code,
      ));

      result.fold(
        (failure) async {
          debugPrint('🔴 [JoinStore] Failed: ${failure.message}');
          SnackbarHelpers.dismiss(scaffoldMessenger);

          await TossErrorDialogs.showBusinessJoinFailed(
            context: context,
            error: failure.message,
            onRetry: () {
              Navigator.of(context).pop();
              joinStore(context, ref, code);
            },
          );
        },
        (joinResult) async {
          debugPrint('🟢 [JoinStore] Join successful: ${joinResult.entityName}');

          if (navigator.canPop()) navigator.pop();
          if (navigator.canPop()) navigator.pop();

          SnackbarHelpers.dismiss(scaffoldMessenger);

          await Future<void>.delayed(const Duration(milliseconds: 300));

          // Force comprehensive data refresh
          ref.invalidate(userCompaniesProvider);
          ref.invalidate(categoriesWithFeaturesProvider);

          if (joinResult.companyId != null) {
            final appStateNotifier = ref.read(appStateProvider.notifier);
            appStateNotifier.selectCompany(joinResult.companyId!);

            if (joinResult.storeId != null) {
              appStateNotifier.selectStore(joinResult.storeId!);
            }
          }

          if (context.mounted) {
            await TossSuccessDialogs.showBusinessJoined(
              context: context,
              companyName: joinResult.entityName,
              roleName: joinResult.roleAssigned ?? 'Member',
              onContinue: () {
                Navigator.of(context).pop(true);
                context.go('/');
              },
            );
          }
        },
      );
    } catch (e) {
      debugPrint('🔴 [JoinStore] Exception: ${e.toString()}');
      SnackbarHelpers.dismiss(scaffoldMessenger);

      await TossErrorDialogs.showBusinessJoinFailed(
        context: context,
        error: e.toString().replaceAll('Exception: ', ''),
        onRetry: () {
          Navigator.of(context).pop();
          joinStore(context, ref, code);
        },
      );
    }
  }
}
