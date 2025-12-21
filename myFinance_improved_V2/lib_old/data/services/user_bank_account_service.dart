import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import '../../domain/entities/user_bank_account.dart';

class UserBankAccountService {
  final _supabase = Supabase.instance.client;
  
  void _log(String message) {
    developer.log(message, name: 'UserBankAccountService');
  }
  
  void _logError(String message, dynamic error, [StackTrace? stackTrace]) {
    developer.log(message, name: 'UserBankAccountService', error: error, stackTrace: stackTrace);
  }
  
  /// Get user bank account by user_id and company_id
  Future<UserBankAccount?> getUserBankAccount({
    required String userId,
    required String companyId,
  }) async {
    try {
      _log('Fetching bank account for userId: $userId, companyId: $companyId');
      
      final response = await _supabase
          .from('users_bank_account')
          .select('*')
          .eq('user_id', userId)
          .eq('company_id', companyId)
          .eq('is_active', true)
          .maybeSingle();
      
      _log('Bank account query result: $response');
      
      if (response != null) {
        // Parse dates
        DateTime? createdAt;
        DateTime? updatedAt;
        
        try {
          if (response['created_at'] != null) {
            createdAt = DateTime.parse(response['created_at']);
          }
          if (response['updated_at'] != null) {
            updatedAt = DateTime.parse(response['updated_at']);
          }
        } catch (e) {
          _logError('Error parsing dates', e);
        }
        
        final bankAccount = UserBankAccount(
          id: response['id'],
          userId: response['user_id'],
          companyId: response['company_id'],
          userBankName: response['user_bank_name'],
          userAccountNumber: response['user_account_number'],
          description: response['description'],
          isActive: response['is_active'] ?? true,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
        
        _log('Successfully parsed bank account: ${bankAccount.displayBankName}');
        return bankAccount;
      }
      
      _log('No bank account found');
      return null;
    } catch (e, stackTrace) {
      _logError('Error fetching user bank account', e, stackTrace);
      return null;
    }
  }
  
  /// Create or update user bank account
  Future<bool> upsertUserBankAccount({
    required String userId,
    required String companyId,
    String? userBankName,
    String? userAccountNumber,
    String? description,
  }) async {
    try {
      _log('Upserting bank account for userId: $userId, companyId: $companyId');
      _log('Data: bankName=$userBankName, accountNumber=$userAccountNumber, description=$description');
      
      // Check if bank account already exists
      final existing = await getUserBankAccount(userId: userId, companyId: companyId);
      
      final data = {
        'user_id': userId,
        'company_id': companyId,
        'user_bank_name': userBankName,
        'user_account_number': userAccountNumber,
        'description': description,
        'is_active': true,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (existing != null) {
        // Update existing record
        _log('Updating existing bank account with id: ${existing.id}');
        
        final result = await _supabase
            .from('users_bank_account')
            .update(data)
            .eq('id', existing.id!)
            .select();
            
        _log('Update result: $result');
      } else {
        // Create new record
        _log('Creating new bank account record');
        data['created_at'] = DateTime.now().toIso8601String();
        
        final result = await _supabase
            .from('users_bank_account')
            .insert(data)
            .select();
            
        _log('Insert result: $result');
      }
      
      _log('SUCCESS: Upserted bank account');
      return true;
    } catch (e, stackTrace) {
      _logError('Error upserting user bank account', e, stackTrace);
      
      if (e is PostgrestException) {
        _logError('PostgrestException details', {
          'code': e.code,
          'message': e.message,
          'details': e.details,
          'hint': e.hint,
        });
      }
      
      return false;
    }
  }
  
  /// Delete user bank account (soft delete by setting is_active to false)
  Future<bool> deleteUserBankAccount({
    required String userId,
    required String companyId,
  }) async {
    try {
      _log('Soft deleting bank account for userId: $userId, companyId: $companyId');
      
      final result = await _supabase
          .from('users_bank_account')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('company_id', companyId)
          .select();
          
      _log('Soft delete result: $result');
      _log('SUCCESS: Soft deleted bank account');
      return true;
    } catch (e, stackTrace) {
      _logError('Error soft deleting user bank account', e, stackTrace);
      return false;
    }
  }
  
  /// Get all bank accounts for a user across all companies
  Future<List<UserBankAccount>> getAllUserBankAccounts(String userId) async {
    try {
      _log('Fetching all bank accounts for userId: $userId');
      
      final response = await _supabase
          .from('users_bank_account')
          .select('*')
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('created_at', ascending: false);
      
      _log('All bank accounts query result: $response');
      
      final accounts = <UserBankAccount>[];
      for (final item in response) {
        try {
          DateTime? createdAt;
          DateTime? updatedAt;
          
          if (item['created_at'] != null) {
            createdAt = DateTime.parse(item['created_at']);
          }
          if (item['updated_at'] != null) {
            updatedAt = DateTime.parse(item['updated_at']);
          }
          
          accounts.add(UserBankAccount(
            id: item['id'],
            userId: item['user_id'],
            companyId: item['company_id'],
            userBankName: item['user_bank_name'],
            userAccountNumber: item['user_account_number'],
            description: item['description'],
            isActive: item['is_active'] ?? true,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ));
        } catch (e) {
          _logError('Error parsing bank account item', e);
        }
      }
      
      _log('Successfully parsed ${accounts.length} bank accounts');
      return accounts;
    } catch (e, stackTrace) {
      _logError('Error fetching all user bank accounts', e, stackTrace);
      return [];
    }
  }
}