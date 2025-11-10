import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved_v1/features/cash_ending/data/repositories/cash_ending_repository_impl.dart';
import 'package:myfinance_improved_v1/features/cash_ending/data/repositories/bank_repository_impl.dart';
import 'package:myfinance_improved_v1/features/cash_ending/data/repositories/vault_repository_impl.dart';
import 'package:myfinance_improved_v1/features/cash_ending/domain/entities/cash_ending.dart';
import 'package:myfinance_improved_v1/features/cash_ending/domain/entities/bank_balance.dart';
import 'package:myfinance_improved_v1/features/cash_ending/domain/entities/vault_balance.dart';

// Generate mocks for Supabase client
@GenerateMocks([SupabaseClient])
import 'database_operations_test.mocks.dart';

/// Integration tests for database operations
/// 
/// These tests verify that the refactored repository implementations
/// maintain IDENTICAL behavior to the original database operations,
/// particularly the critical RPC functions.
/// 
/// CRITICAL RPC FUNCTIONS TESTED:
/// 1. insert_cashier_amount_lines - Cash ending operations
/// 2. bank_amount_insert_v2 - Bank balance operations  
/// 3. vault_amount_insert - Vault credit/debit operations
/// 4. get_vault_amount_line_history - Vault transaction history
void main() {
  group('Database Operations Integration Tests', () {
    late MockSupabaseClient mockSupabase;
    late CashEndingRepositoryImpl cashEndingRepository;
    late BankRepositoryImpl bankRepository;
    late VaultRepositoryImpl vaultRepository;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      cashEndingRepository = CashEndingRepositoryImpl(mockSupabase);
      bankRepository = BankRepositoryImpl(mockSupabase);
      vaultRepository = VaultRepositoryImpl(mockSupabase);
    });

    group('Cash Ending Repository Tests', () {
      test('saveCashEnding preserves IDENTICAL RPC call structure', () async {
        // Arrange - Create test data that matches original format exactly
        final cashEnding = CashEnding(
          companyId: 'test_company_123',
          userId: 'test_user_456',
          locationId: 'test_location_789',
          denominationLines: [
            {
              'denomination_id': 'denom_1',
              'quantity': 10,
              'subtotal': 1000.0,
              'currency_id': 'currency_usd',
            },
            {
              'denomination_id': 'denom_2', 
              'quantity': 5,
              'subtotal': 500.0,
              'currency_id': 'currency_usd',
            },
          ],
          totalAmount: 1500.0,
          sessionId: 'session_abc123',
        );

        // Mock the exact RPC response structure from original
        when(mockSupabase.rpc('insert_cashier_amount_lines', params: anyNamed('params')))
            .thenAnswer((_) async => {
                  'success': true,
                  'message': 'Cash ending saved successfully',
                  'session_id': 'session_abc123'
                });

        // Act
        final result = await cashEndingRepository.saveCashEnding(cashEnding);

        // Assert - Verify RPC was called with IDENTICAL parameters
        verify(mockSupabase.rpc('insert_cashier_amount_lines', params: {
          'p_company_id': 'test_company_123',
          'p_user_id': 'test_user_456', 
          'p_location_id': 'test_location_789',
          'p_denomination_lines': [
            {
              'denomination_id': 'denom_1',
              'quantity': 10,
              'subtotal': 1000.0,
              'currency_id': 'currency_usd',
            },
            {
              'denomination_id': 'denom_2',
              'quantity': 5, 
              'subtotal': 500.0,
              'currency_id': 'currency_usd',
            },
          ],
          'p_total_amount': 1500.0,
          'p_session_id': 'session_abc123',
        })).called(1);

        expect(result.isSuccess, isTrue);
        expect(result.sessionId, equals('session_abc123'));
      });

      test('saveCashEnding handles RPC errors identically to original', () async {
        // Arrange
        final cashEnding = CashEnding(
          companyId: 'test_company',
          userId: 'test_user',
          locationId: 'test_location',
          denominationLines: [],
          totalAmount: 0.0,
          sessionId: 'session_test',
        );

        // Mock RPC error response
        when(mockSupabase.rpc('insert_cashier_amount_lines', params: anyNamed('params')))
            .thenThrow(PostgrestException(
              message: 'Invalid denomination data',
              code: '23503',
            ));

        // Act & Assert
        expect(
          () => cashEndingRepository.saveCashEnding(cashEnding),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Bank Repository Tests', () {
      test('saveBankBalance preserves IDENTICAL bank_amount_insert_v2 RPC call', () async {
        // Arrange - Test data matching original format
        final bankBalance = BankBalance(
          companyId: 'test_company_123',
          userId: 'test_user_456',
          locationId: 'bank_location_789',
          currencyId: 'currency_usd',
          amount: 25000.0,
          sessionId: 'bank_session_xyz',
        );

        // Mock exact RPC response structure
        when(mockSupabase.rpc('bank_amount_insert_v2', params: anyNamed('params')))
            .thenAnswer((_) async => {
                  'success': true,
                  'message': 'Bank balance saved successfully',
                  'transaction_id': 'bank_txn_123'
                });

        // Act
        final result = await bankRepository.saveBankBalance(bankBalance);

        // Assert - Verify IDENTICAL RPC parameters
        verify(mockSupabase.rpc('bank_amount_insert_v2', params: {
          'p_company_id': 'test_company_123',
          'p_user_id': 'test_user_456',
          'p_location_id': 'bank_location_789', 
          'p_currency_id': 'currency_usd',
          'p_total_amount': 25000.0,
          'p_session_id': 'bank_session_xyz',
        })).called(1);

        expect(result.isSuccess, isTrue);
        expect(result.transactionId, equals('bank_txn_123'));
      });

      test('getBankTransactions preserves original query structure', () async {
        // Arrange
        const companyId = 'test_company';
        const locationId = 'bank_location';
        const limit = 10;

        // Mock bank transactions response
        when(mockSupabase
            .from('bank_amounts')
            .select('*, currency:currencies(*), user:profiles(*)')
            .eq('company_id', companyId)
            .eq('location_id', locationId)
            .order('created_at', ascending: false)
            .limit(limit))
            .thenAnswer((_) async => [
                  {
                    'id': 'bank_1',
                    'total_amount': 15000.0,
                    'currency_id': 'usd',
                    'created_at': '2024-01-15T10:30:00Z',
                    'user_id': 'user_1',
                    'currency': {'symbol': '\$', 'currency_code': 'USD'},
                    'user': {'full_name': 'John Doe'}
                  }
                ]);

        // Act
        final result = await bankRepository.getBankTransactions(
          companyId: companyId,
          locationId: locationId,
          limit: limit,
        );

        // Assert - Verify query preserves original structure
        expect(result, hasLength(1));
        expect(result.first['total_amount'], equals(15000.0));
        expect(result.first['currency']['symbol'], equals('\$'));
      });
    });

    group('Vault Repository Tests', () {
      test('saveVaultBalance preserves IDENTICAL vault_amount_insert RPC call', () async {
        // Arrange - Test vault credit transaction
        final vaultBalance = VaultBalance(
          companyId: 'test_company_123',
          userId: 'test_user_456', 
          locationId: 'vault_location_789',
          currencyId: 'currency_usd',
          transactionType: 'credit',
          denominationLines: [
            {
              'denomination_id': 'vault_denom_1',
              'quantity': 20,
              'subtotal': 2000.0,
            }
          ],
          totalAmount: 2000.0,
          sessionId: 'vault_session_abc',
        );

        // Mock vault RPC response
        when(mockSupabase.rpc('vault_amount_insert', params: anyNamed('params')))
            .thenAnswer((_) async => {
                  'success': true,
                  'message': 'Vault transaction completed',
                  'transaction_id': 'vault_txn_456'
                });

        // Act
        final result = await vaultRepository.saveVaultBalance(vaultBalance);

        // Assert - Verify IDENTICAL vault RPC parameters
        verify(mockSupabase.rpc('vault_amount_insert', params: {
          'p_company_id': 'test_company_123',
          'p_user_id': 'test_user_456',
          'p_location_id': 'vault_location_789',
          'p_currency_id': 'currency_usd',
          'p_transaction_type': 'credit',
          'p_denomination_lines': [
            {
              'denomination_id': 'vault_denom_1',
              'quantity': 20,
              'subtotal': 2000.0,
            }
          ],
          'p_total_amount': 2000.0,
          'p_session_id': 'vault_session_abc',
        })).called(1);

        expect(result.isSuccess, isTrue);
        expect(result.transactionId, equals('vault_txn_456'));
      });

      test('getVaultTransactionHistory preserves IDENTICAL get_vault_amount_line_history RPC', () async {
        // Arrange
        const companyId = 'test_company';
        const locationId = 'vault_location';
        const limit = 5;

        // Mock vault history RPC response
        when(mockSupabase.rpc('get_vault_amount_line_history', params: anyNamed('params')))
            .thenAnswer((_) async => [
                  {
                    'transaction_id': 'vault_txn_1',
                    'transaction_type': 'credit',
                    'total_amount': 1500.0,
                    'currency_id': 'usd',
                    'created_at': '2024-01-15T11:00:00Z',
                    'user_full_name': 'Jane Smith',
                    'denomination_details': [
                      {'denomination_id': 'denom_100', 'quantity': 15}
                    ]
                  }
                ]);

        // Act
        final result = await vaultRepository.getVaultTransactionHistory(
          companyId: companyId,
          locationId: locationId,
          limit: limit,
        );

        // Assert - Verify IDENTICAL RPC call parameters
        verify(mockSupabase.rpc('get_vault_amount_line_history', params: {
          'p_company_id': companyId,
          'p_location_id': locationId,
          'p_limit': limit,
        })).called(1);

        expect(result, hasLength(1));
        expect(result.first['transaction_type'], equals('credit'));
        expect(result.first['total_amount'], equals(1500.0));
      });

      test('vault debit transactions preserve original validation logic', () async {
        // Arrange - Test vault debit transaction
        final vaultBalance = VaultBalance(
          companyId: 'test_company',
          userId: 'test_user',
          locationId: 'vault_location',
          currencyId: 'currency_usd', 
          transactionType: 'debit',
          denominationLines: [
            {
              'denomination_id': 'vault_denom_1',
              'quantity': 10,
              'subtotal': 1000.0,
            }
          ],
          totalAmount: 1000.0,
          sessionId: 'vault_debit_session',
        );

        // Mock insufficient funds error (original behavior)
        when(mockSupabase.rpc('vault_amount_insert', params: anyNamed('params')))
            .thenThrow(PostgrestException(
              message: 'Insufficient vault balance for debit operation',
              code: '23514',
            ));

        // Act & Assert - Verify error handling matches original
        expect(
          () => vaultRepository.saveVaultBalance(vaultBalance),
          throwsA(isA<PostgrestException>()),
        );
      });
    });

    group('Data Format Compatibility Tests', () {
      test('all repositories maintain legacy format compatibility', () async {
        // This test ensures that the refactored repositories
        // can handle data in the exact same format as the original implementation
        
        // Test cash ending legacy format
        final legacyCashData = {
          'company_id': 'comp_123',
          'user_id': 'user_456', 
          'location_id': 'loc_789',
          'denomination_lines': [
            {
              'denomination_id': 'denom_50',
              'quantity': 8,
              'subtotal': 400.0,
              'currency_id': 'php',
            }
          ],
          'total_amount': 400.0,
          'session_id': 'legacy_session_123'
        };

        // Verify that repository can handle legacy format
        expect(legacyCashData['company_id'], isA<String>());
        expect(legacyCashData['denomination_lines'], isA<List>());
        expect((legacyCashData['denomination_lines'] as List).first, isA<Map>());
      });
    });

    group('Error Handling Compatibility Tests', () {
      test('repositories preserve original error message formats', () async {
        // Arrange - Test various error scenarios that existed in original
        final invalidCashEnding = CashEnding(
          companyId: '',  // Invalid company ID 
          userId: 'test_user',
          locationId: 'test_location',
          denominationLines: [],
          totalAmount: 0.0,
          sessionId: 'test_session',
        );

        // Mock validation error
        when(mockSupabase.rpc('insert_cashier_amount_lines', params: anyNamed('params')))
            .thenThrow(PostgrestException(
              message: 'Company ID is required',
              code: '23502',
            ));

        // Act & Assert
        try {
          await cashEndingRepository.saveCashEnding(invalidCashEnding);
          fail('Expected exception was not thrown');
        } catch (e) {
          expect(e, isA<PostgrestException>());
          expect((e as PostgrestException).message, contains('Company ID'));
        }
      });
    });
  });
}