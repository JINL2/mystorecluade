import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/user_bank_account_service.dart';
import '../../domain/entities/user_bank_account.dart';
import 'auth_provider.dart';
import 'app_state_provider.dart';

// Provider for UserBankAccountService
final userBankAccountServiceProvider = Provider<UserBankAccountService>((ref) {
  return UserBankAccountService();
});

// StateNotifier for UserBankAccount operations
class UserBankAccountNotifier extends StateNotifier<AsyncValue<void>> {
  final UserBankAccountService _service;
  
  UserBankAccountNotifier(this._service) : super(const AsyncValue.data(null));
  
  Future<void> upsertBankAccount({
    required String userId,
    required String companyId,
    String? userBankName,
    String? userAccountNumber,
    String? description,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final success = await _service.upsertUserBankAccount(
        userId: userId,
        companyId: companyId,
        userBankName: userBankName,
        userAccountNumber: userAccountNumber,
        description: description,
      );
      
      if (success) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error('Failed to update bank account', StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> deleteBankAccount({
    required String userId,
    required String companyId,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final success = await _service.deleteUserBankAccount(
        userId: userId,
        companyId: companyId,
      );
      
      if (success) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error('Failed to delete bank account', StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Provider for UserBankAccountNotifier
final userBankAccountNotifierProvider = StateNotifierProvider<UserBankAccountNotifier, AsyncValue<void>>((ref) {
  final service = ref.read(userBankAccountServiceProvider);
  return UserBankAccountNotifier(service);
});

// Provider for current user's bank account based on selected company
final currentUserBankAccountProvider = FutureProvider<UserBankAccount?>((ref) async {
  print('🚀 [currentUserBankAccountProvider] ===== PROVIDER TRIGGERED =====');
  
  final user = ref.watch(authStateProvider);
  final appState = ref.watch(appStateProvider);
  final service = ref.read(userBankAccountServiceProvider);
  
  print('🔍 [currentUserBankAccountProvider] Auth user: ${user?.id} (${user?.email})');
  print('🔍 [currentUserBankAccountProvider] Selected company: ${appState.companyChoosen}');
  
  if (user == null) {
    print('❌ [currentUserBankAccountProvider] No authenticated user, returning null');
    return null;
  }
  
  if (appState.companyChoosen.isEmpty) {
    print('❌ [currentUserBankAccountProvider] No company selected, returning null');
    return null;
  }
  
  try {
    print('🔍 [currentUserBankAccountProvider] Fetching bank account...');
    
    final bankAccount = await service.getUserBankAccount(
      userId: user.id,
      companyId: appState.companyChoosen,
    );
    
    if (bankAccount != null) {
      print('✅ [currentUserBankAccountProvider] Bank account found:');
      print('   - userBankName: "${bankAccount.userBankName}"');
      print('   - userAccountNumber: "${bankAccount.userAccountNumber}"');
      print('   - description: "${bankAccount.description}"');
      print('   - companyId: "${bankAccount.companyId}"');
    } else {
      print('⚠️ [currentUserBankAccountProvider] No bank account found');
    }
    
    return bankAccount;
  } catch (e, stackTrace) {
    print('❌ [currentUserBankAccountProvider] Error fetching bank account: $e');
    print('❌ [currentUserBankAccountProvider] Stack trace: $stackTrace');
    return null;
  }
});

// Provider for all user bank accounts across companies
final allUserBankAccountsProvider = FutureProvider<List<UserBankAccount>>((ref) async {
  print('🚀 [allUserBankAccountsProvider] ===== PROVIDER TRIGGERED =====');
  
  final user = ref.watch(authStateProvider);
  final service = ref.read(userBankAccountServiceProvider);
  
  print('🔍 [allUserBankAccountsProvider] Auth user: ${user?.id} (${user?.email})');
  
  if (user == null) {
    print('❌ [allUserBankAccountsProvider] No authenticated user, returning empty list');
    return [];
  }
  
  try {
    print('🔍 [allUserBankAccountsProvider] Fetching all bank accounts...');
    
    final bankAccounts = await service.getAllUserBankAccounts(user.id);
    
    print('✅ [allUserBankAccountsProvider] Found ${bankAccounts.length} bank accounts');
    
    return bankAccounts;
  } catch (e, stackTrace) {
    print('❌ [allUserBankAccountsProvider] Error fetching bank accounts: $e');
    print('❌ [allUserBankAccountsProvider] Stack trace: $stackTrace');
    return [];
  }
});