# 📡 Supabase API Integration Guide

How to properly integrate Supabase with Clean Architecture using the Repository Pattern.

## 🏗️ Architecture Overview

```
┌─────────────────┐
│   UI Layer      │ (Pages, Widgets)
└────────┬────────┘
         │ Uses Providers
┌────────▼────────┐
│ Providers       │ (Riverpod State)
└────────┬────────┘
         │ Uses Use Cases
┌────────▼────────┐
│ Use Cases       │ (Business Logic)
└────────┬────────┘
         │ Uses Repository Interface
┌────────▼────────┐
│ Repository      │ (Abstract Interface)
│ Interface       │
└────────┬────────┘
         │ Implemented by
┌────────▼────────┐
│ Repository      │ (Concrete Implementation)
│ Implementation  │
└────────┬────────┘
         │ Uses
┌────────▼────────┐
│ Supabase API    │ (Data Source)
└─────────────────┘
```

## 🔑 Key Principles

1. **UI doesn't know about Supabase** - Only repositories use Supabase
2. **Use repository pattern** - Abstract data source from business logic
3. **Handle errors properly** - Convert Supabase errors to domain errors
4. **Type safety** - Use Freezed models with proper conversion

## 📝 Step-by-Step Implementation

### 1. Domain Layer - Repository Interface

```dart
// lib/domain/repositories/transaction_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/transaction.dart';
import '../../core/errors/failures.dart';

abstract class TransactionRepository {
  // Get all transactions
  Future<Either<Failure, List<Transaction>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? companyId,
  });
  
  // Get single transaction
  Future<Either<Failure, Transaction>> getTransactionById(String id);
  
  // Create transaction
  Future<Either<Failure, Transaction>> createTransaction(Transaction transaction);
  
  // Update transaction
  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction);
  
  // Delete transaction
  Future<Either<Failure, void>> deleteTransaction(String id);
  
  // Real-time subscription
  Stream<Either<Failure, List<Transaction>>> watchTransactions();
}
```

### 2. Data Layer - Supabase API Service

```dart
// lib/data/datasources/remote/supabase_transaction_api.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/exceptions.dart';

class SupabaseTransactionApi {
  final SupabaseClient _client;
  
  SupabaseTransactionApi(this._client);
  
  // Table name constant
  static const String _tableName = 'transactions';
  
  Future<List<Map<String, dynamic>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? companyId,
  }) async {
    try {
      var query = _client
          .from(_tableName)
          .select('*, company:companies(*)')
          .eq('user_id', _client.auth.currentUser!.id);
      
      // Apply filters
      if (startDate != null) {
        query = query.gte('date', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('date', endDate.toIso8601String());
      }
      if (companyId != null) {
        query = query.eq('company_id', companyId);
      }
      
      final response = await query.order('date', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  Future<Map<String, dynamic>> getTransactionById(String id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select('*, company:companies(*)')
          .eq('id', id)
          .single();
      
      return response;
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw NotFoundException(message: 'Transaction not found');
      }
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  Future<Map<String, dynamic>> createTransaction(Map<String, dynamic> data) async {
    try {
      final response = await _client
          .from(_tableName)
          .insert({
            ...data,
            'user_id': _client.auth.currentUser!.id,
          })
          .select('*, company:companies(*)')
          .single();
      
      return response;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  Future<Map<String, dynamic>> updateTransaction(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .eq('user_id', _client.auth.currentUser!.id)
          .select('*, company:companies(*)')
          .single();
      
      return response;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  Future<void> deleteTransaction(String id) async {
    try {
      await _client
          .from(_tableName)
          .delete()
          .eq('id', id)
          .eq('user_id', _client.auth.currentUser!.id);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  Stream<List<Map<String, dynamic>>> watchTransactions() {
    return _client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', _client.auth.currentUser!.id)
        .order('date', ascending: false);
  }
}
```

### 3. Data Layer - Repository Implementation

```dart
// lib/data/repositories/transaction_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/remote/supabase_transaction_api.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final SupabaseTransactionApi _api;
  
  TransactionRepositoryImpl(this._api);
  
  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? companyId,
  }) async {
    try {
      final response = await _api.getTransactions(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
      );
      
      final transactions = response
          .map((json) => TransactionModel.fromJson(json).toEntity())
          .toList();
      
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      final response = await _api.getTransactionById(id);
      final transaction = TransactionModel.fromJson(response).toEntity();
      return Right(transaction);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Transaction>> createTransaction(
    Transaction transaction,
  ) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final response = await _api.createTransaction(model.toJson());
      final created = TransactionModel.fromJson(response).toEntity();
      return Right(created);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  ) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final response = await _api.updateTransaction(
        transaction.id!,
        model.toJson(),
      );
      final updated = TransactionModel.fromJson(response).toEntity();
      return Right(updated);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await _api.deleteTransaction(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Stream<Either<Failure, List<Transaction>>> watchTransactions() {
    return _api.watchTransactions().map((data) {
      try {
        final transactions = data
            .map((json) => TransactionModel.fromJson(json).toEntity())
            .toList();
        return Right(transactions);
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    });
  }
}
```

### 4. Provider Setup

```dart
// lib/presentation/providers/repository_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/remote/supabase_transaction_api.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/repositories/transaction_repository.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Transaction API provider
final transactionApiProvider = Provider<SupabaseTransactionApi>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseTransactionApi(client);
});

// Transaction repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final api = ref.watch(transactionApiProvider);
  return TransactionRepositoryImpl(api);
});
```

## 🔄 Real-time Updates

### Setup Real-time Subscription

```dart
// lib/presentation/providers/transaction_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/transaction.dart';
import 'repository_providers.dart';

part 'transaction_provider.g.dart';

// Real-time transaction stream
@riverpod
Stream<List<Transaction>> transactionStream(TransactionStreamRef ref) async* {
  final repository = ref.watch(transactionRepositoryProvider);
  
  await for (final either in repository.watchTransactions()) {
    yield* either.fold(
      (failure) => Stream.error(failure),
      (transactions) => Stream.value(transactions),
    );
  }
}

// Transaction list with real-time updates
@riverpod
class TransactionList extends _$TransactionList {
  @override
  Future<List<Transaction>> build() async {
    // Watch real-time stream
    ref.listen(transactionStreamProvider, (previous, next) {
      next.whenData((transactions) {
        state = AsyncValue.data(transactions);
      });
    });
    
    // Initial load
    final repository = ref.watch(transactionRepositoryProvider);
    final result = await repository.getTransactions();
    
    return result.fold(
      (failure) => throw failure,
      (transactions) => transactions,
    );
  }
}
```

## 🛡️ Error Handling

### Custom Exceptions

```dart
// lib/core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException({required this.message});
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException({required this.message});
}
```

### Custom Failures

```dart
// lib/core/errors/failures.dart
abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
```

## 📊 Advanced Queries

### Aggregations

```dart
Future<Map<String, dynamic>> getTransactionStats({
  required DateTime startDate,
  required DateTime endDate,
}) async {
  try {
    // Get total income
    final incomeResponse = await _client
        .from(_tableName)
        .select('amount.sum()')
        .eq('user_id', _client.auth.currentUser!.id)
        .eq('type', 'income')
        .gte('date', startDate.toIso8601String())
        .lte('date', endDate.toIso8601String())
        .single();
    
    // Get total expense
    final expenseResponse = await _client
        .from(_tableName)
        .select('amount.sum()')
        .eq('user_id', _client.auth.currentUser!.id)
        .eq('type', 'expense')
        .gte('date', startDate.toIso8601String())
        .lte('date', endDate.toIso8601String())
        .single();
    
    return {
      'totalIncome': incomeResponse['sum'] ?? 0,
      'totalExpense': expenseResponse['sum'] ?? 0,
      'balance': (incomeResponse['sum'] ?? 0) - (expenseResponse['sum'] ?? 0),
    };
  } catch (e) {
    throw ServerException(message: e.toString());
  }
}
```

### Pagination

```dart
Future<PaginatedResponse<Transaction>> getTransactionsPaginated({
  int page = 1,
  int limit = 20,
}) async {
  try {
    final from = (page - 1) * limit;
    final to = from + limit - 1;
    
    // Get total count
    final countResponse = await _client
        .from(_tableName)
        .select('*', const FetchOptions(count: CountOption.exact, head: true))
        .eq('user_id', _client.auth.currentUser!.id);
    
    final total = countResponse.count ?? 0;
    
    // Get paginated data
    final response = await _client
        .from(_tableName)
        .select('*, company:companies(*)')
        .eq('user_id', _client.auth.currentUser!.id)
        .order('date', ascending: false)
        .range(from, to);
    
    final transactions = response
        .map((json) => TransactionModel.fromJson(json).toEntity())
        .toList();
    
    return PaginatedResponse(
      data: transactions,
      total: total,
      page: page,
      totalPages: (total / limit).ceil(),
    );
  } catch (e) {
    throw ServerException(message: e.toString());
  }
}
```

## 🧪 Testing

### Mock Supabase for Tests

```dart
// test/mocks/mock_supabase_client.dart
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockPostgrestQueryBuilder extends Mock implements PostgrestQueryBuilder {}
class MockGoTrueClient extends Mock implements GoTrueClient {}

// Usage in tests
void main() {
  late MockSupabaseClient mockClient;
  late SupabaseTransactionApi api;
  
  setUp(() {
    mockClient = MockSupabaseClient();
    api = SupabaseTransactionApi(mockClient);
  });
  
  test('should get transactions', () async {
    // Arrange
    when(() => mockClient.from(any())).thenReturn(mockQueryBuilder);
    when(() => mockQueryBuilder.select(any())).thenReturn(mockQueryBuilder);
    // ... more setup
    
    // Act
    final result = await api.getTransactions();
    
    // Assert
    expect(result, isA<List<Map<String, dynamic>>>());
  });
}
```

## 📚 Best Practices

1. **Always use repository pattern** - Never use Supabase directly in UI
2. **Handle all errors** - Convert exceptions to failures
3. **Use type-safe models** - Freezed with proper JSON conversion
4. **Enable RLS** - Row Level Security on all tables
5. **Use real-time wisely** - Not everything needs real-time updates
6. **Cache when possible** - Reduce API calls
7. **Paginate large lists** - Better performance
8. **Test your repositories** - Mock Supabase client

---

**Remember: Clean Architecture = Supabase stays in data layer only!** 🎯