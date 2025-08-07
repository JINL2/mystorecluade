# 🏛️ Repository Pattern Guide

A comprehensive guide to implementing the Repository Pattern in MyFinance with Supabase.

## 🎯 Why Repository Pattern?

The Repository Pattern provides an abstraction layer between your business logic and data sources.

### Benefits:
1. **Testability** - Easy to mock for unit tests
2. **Flexibility** - Switch data sources without changing business logic
3. **Separation of Concerns** - Domain layer doesn't know about data implementation
4. **Type Safety** - Convert between data models and domain entities
5. **Error Handling** - Centralized error transformation

## 🏗️ Architecture Overview

```
┌─────────────────────────┐
│   Presentation Layer    │
│   (UI & State)          │
└───────────┬─────────────┘
            │ Uses
┌───────────▼─────────────┐
│    Domain Layer         │
│  (Business Logic)       │
│                         │
│  ┌──────────────────┐   │
│  │   Use Cases      │   │
│  └────────┬─────────┘   │
│           │ Uses        │
│  ┌────────▼─────────┐   │
│  │Repository Interface│ │ ◄── Abstract (What)
│  └──────────────────┘   │
└─────────────────────────┘
            ▲ Implements
┌───────────┴─────────────┐
│     Data Layer          │
│                         │
│  ┌──────────────────┐   │
│  │Repository Impl   │   │ ◄── Concrete (How)
│  └────────┬─────────┘   │
│           │ Uses        │
│  ┌────────▼─────────┐   │
│  │  Data Sources    │   │
│  │  (Supabase)      │   │
│  └──────────────────┘   │
└─────────────────────────┘
```

## 📝 Step-by-Step Implementation

### 1. Define Domain Entity

```dart
// lib/domain/entities/company.dart
class Company {
  final String id;
  final String name;
  final String? description;
  final String category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Company({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  
  // Domain methods
  bool get isNew => createdAt.difference(DateTime.now()).inDays.abs() < 7;
  
  Company copyWith({
    String? name,
    String? description,
    String? category,
    bool? isActive,
  }) {
    return Company(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
```

### 2. Create Repository Interface

```dart
// lib/domain/repositories/company_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/company.dart';
import '../../core/errors/failures.dart';

abstract class CompanyRepository {
  // Read operations
  Future<Either<Failure, List<Company>>> getCompanies();
  Future<Either<Failure, Company>> getCompanyById(String id);
  
  // Write operations
  Future<Either<Failure, Company>> createCompany(Company company);
  Future<Either<Failure, Company>> updateCompany(Company company);
  Future<Either<Failure, void>> deleteCompany(String id);
  
  // Real-time
  Stream<Either<Failure, List<Company>>> watchCompanies();
  
  // Business-specific queries
  Future<Either<Failure, List<Company>>> getActiveCompanies();
  Future<Either<Failure, List<Company>>> getCompaniesByCategory(String category);
}
```

### 3. Create Data Model

```dart
// lib/data/models/company_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/company.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

@freezed
class CompanyModel with _$CompanyModel {
  const CompanyModel._(); // Required for custom methods
  
  const factory CompanyModel({
    required String id,
    required String name,
    String? description,
    required String category,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Relations
    @JsonKey(name: 'user_id') required String userId,
  }) = _CompanyModel;
  
  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);
  
  // Convert to domain entity
  Company toEntity() {
    return Company(
      id: id,
      name: name,
      description: description,
      category: category,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  
  // Create from domain entity
  factory CompanyModel.fromEntity(Company entity, String userId) {
    return CompanyModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      category: entity.category,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      userId: userId,
    );
  }
}
```

### 4. Implement Data Source

```dart
// lib/data/datasources/remote/supabase_company_api.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/exceptions.dart';

class SupabaseCompanyApi {
  final SupabaseClient _client;
  static const String _tableName = 'companies';
  
  SupabaseCompanyApi(this._client);
  
  Future<List<Map<String, dynamic>>> getCompanies() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw UnauthorizedException(message: 'Not authenticated');
      
      final response = await _client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  Future<Map<String, dynamic>> getCompanyById(String id) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw UnauthorizedException(message: 'Not authenticated');
      
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .eq('user_id', userId)
          .single();
      
      return response;
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw NotFoundException(message: 'Company not found');
      }
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is UnauthorizedException || e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  Future<Map<String, dynamic>> createCompany(Map<String, dynamic> data) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw UnauthorizedException(message: 'Not authenticated');
      
      final response = await _client
          .from(_tableName)
          .insert({
            ...data,
            'user_id': userId,
          })
          .select()
          .single();
      
      return response;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  Future<Map<String, dynamic>> updateCompany(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw UnauthorizedException(message: 'Not authenticated');
      
      // Remove fields that shouldn't be updated
      data.remove('id');
      data.remove('user_id');
      data.remove('created_at');
      
      final response = await _client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .eq('user_id', userId)
          .select()
          .single();
      
      return response;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  Future<void> deleteCompany(String id) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw UnauthorizedException(message: 'Not authenticated');
      
      await _client
          .from(_tableName)
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  Stream<List<Map<String, dynamic>>> watchCompanies() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return Stream.error(
        UnauthorizedException(message: 'Not authenticated'),
      );
    }
    
    return _client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }
}
```

### 5. Implement Repository

```dart
// lib/data/repositories/company_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../domain/entities/company.dart';
import '../../domain/repositories/company_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/remote/supabase_company_api.dart';
import '../models/company_model.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final SupabaseCompanyApi _api;
  
  CompanyRepositoryImpl(this._api);
  
  @override
  Future<Either<Failure, List<Company>>> getCompanies() async {
    try {
      final response = await _api.getCompanies();
      final companies = response
          .map((json) => CompanyModel.fromJson(json).toEntity())
          .toList();
      return Right(companies);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred'));
    }
  }
  
  @override
  Future<Either<Failure, Company>> getCompanyById(String id) async {
    try {
      final response = await _api.getCompanyById(id);
      final company = CompanyModel.fromJson(response).toEntity();
      return Right(company);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred'));
    }
  }
  
  @override
  Future<Either<Failure, Company>> createCompany(Company company) async {
    try {
      final userId = _api._client.auth.currentUser!.id;
      final model = CompanyModel.fromEntity(company, userId);
      
      // Remove id if it's a new company
      final data = model.toJson();
      if (company.id.isEmpty) {
        data.remove('id');
      }
      
      final response = await _api.createCompany(data);
      final created = CompanyModel.fromJson(response).toEntity();
      return Right(created);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to create company'));
    }
  }
  
  @override
  Future<Either<Failure, Company>> updateCompany(Company company) async {
    try {
      final userId = _api._client.auth.currentUser!.id;
      final model = CompanyModel.fromEntity(company, userId);
      final response = await _api.updateCompany(company.id, model.toJson());
      final updated = CompanyModel.fromJson(response).toEntity();
      return Right(updated);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update company'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteCompany(String id) async {
    try {
      await _api.deleteCompany(id);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to delete company'));
    }
  }
  
  @override
  Stream<Either<Failure, List<Company>>> watchCompanies() {
    return _api.watchCompanies().map((data) {
      try {
        final companies = data
            .map((json) => CompanyModel.fromJson(json).toEntity())
            .toList();
        return Right(companies);
      } catch (e) {
        return Left(UnknownFailure(message: 'Failed to parse companies'));
      }
    }).handleError((error) {
      if (error is UnauthorizedException) {
        return Left(UnauthorizedFailure(message: error.message));
      }
      return Left(ServerFailure(message: error.toString()));
    });
  }
  
  @override
  Future<Either<Failure, List<Company>>> getActiveCompanies() async {
    final result = await getCompanies();
    return result.map((companies) => 
      companies.where((c) => c.isActive).toList()
    );
  }
  
  @override
  Future<Either<Failure, List<Company>>> getCompaniesByCategory(
    String category,
  ) async {
    final result = await getCompanies();
    return result.map((companies) => 
      companies.where((c) => c.category == category).toList()
    );
  }
}
```

### 6. Use in Providers

```dart
// lib/presentation/providers/company_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/company.dart';
import '../../domain/repositories/company_repository.dart';
import 'repository_providers.dart';

part 'company_provider.g.dart';

// Company list provider
@riverpod
class CompanyList extends _$CompanyList {
  @override
  Future<List<Company>> build() async {
    final repository = ref.watch(companyRepositoryProvider);
    final result = await repository.getCompanies();
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (companies) => companies,
    );
  }
  
  Future<void> createCompany({
    required String name,
    String? description,
    required String category,
  }) async {
    state = const AsyncValue.loading();
    
    final repository = ref.read(companyRepositoryProvider);
    final newCompany = Company(
      id: '', // Will be generated by Supabase
      name: name,
      description: description,
      category: category,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final result = await repository.createCompany(newCompany);
    
    state = await AsyncValue.guard(() async {
      return result.fold(
        (failure) => throw Exception(failure.message),
        (company) async {
          // Refresh the list
          final listResult = await repository.getCompanies();
          return listResult.fold(
            (failure) => throw Exception(failure.message),
            (companies) => companies,
          );
        },
      );
    });
  }
  
  Future<void> updateCompany(Company company) async {
    final repository = ref.read(companyRepositoryProvider);
    final result = await repository.updateCompany(company);
    
    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => ref.invalidateSelf(),
    );
  }
  
  Future<void> deleteCompany(String id) async {
    final repository = ref.read(companyRepositoryProvider);
    final result = await repository.deleteCompany(id);
    
    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => ref.invalidateSelf(),
    );
  }
}

// Single company provider
@riverpod
Future<Company?> companyDetail(CompanyDetailRef ref, String companyId) async {
  final repository = ref.watch(companyRepositoryProvider);
  final result = await repository.getCompanyById(companyId);
  
  return result.fold(
    (failure) => null,
    (company) => company,
  );
}

// Active companies provider
@riverpod
Future<List<Company>> activeCompanies(ActiveCompaniesRef ref) async {
  final repository = ref.watch(companyRepositoryProvider);
  final result = await repository.getActiveCompanies();
  
  return result.fold(
    (failure) => [],
    (companies) => companies,
  );
}
```

## 🧪 Testing Repository

```dart
// test/data/repositories/company_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockSupabaseCompanyApi extends Mock implements SupabaseCompanyApi {}

void main() {
  late CompanyRepositoryImpl repository;
  late MockSupabaseCompanyApi mockApi;
  
  setUp(() {
    mockApi = MockSupabaseCompanyApi();
    repository = CompanyRepositoryImpl(mockApi);
  });
  
  group('getCompanies', () {
    test('should return list of companies when API call is successful', () async {
      // Arrange
      final mockData = [
        {
          'id': '1',
          'name': 'Test Company',
          'description': 'Test Description',
          'category': 'Tech',
          'is_active': true,
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
          'user_id': 'user123',
        }
      ];
      
      when(() => mockApi.getCompanies()).thenAnswer((_) async => mockData);
      
      // Act
      final result = await repository.getCompanies();
      
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (companies) {
          expect(companies.length, 1);
          expect(companies.first.name, 'Test Company');
        },
      );
    });
    
    test('should return ServerFailure when API throws ServerException', () async {
      // Arrange
      when(() => mockApi.getCompanies()).thenThrow(
        ServerException(message: 'Server error'),
      );
      
      // Act
      final result = await repository.getCompanies();
      
      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server error');
        },
        (_) => fail('Should not return success'),
      );
    });
  });
}
```

## 📚 Best Practices

### 1. Keep Repositories Focused
- One repository per aggregate root
- Don't create repositories for every entity

### 2. Use Either for Error Handling
```dart
// Good - explicit error handling
Future<Either<Failure, Company>> getCompany(String id);

// Bad - throws exceptions
Future<Company> getCompany(String id);
```

### 3. Keep Business Logic Out
```dart
// Bad - business logic in repository
Future<Either<Failure, List<Company>>> getExpiredCompanies() {
  // Don't put business rules here
}

// Good - let use case handle business logic
Future<Either<Failure, List<Company>>> getCompanies();
// Filter in use case based on business rules
```

### 4. Test Your Repositories
- Mock the data source
- Test both success and failure cases
- Test edge cases

### 5. Use Dependency Injection
```dart
// Good - inject dependencies
final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final api = ref.watch(companyApiProvider);
  return CompanyRepositoryImpl(api);
});

// Bad - create dependencies internally
class CompanyRepositoryImpl {
  final api = SupabaseCompanyApi(Supabase.instance.client); // Don't do this
}
```

## 🎯 Summary

The Repository Pattern provides:
- **Clean separation** between domain and data layers
- **Testability** through dependency injection
- **Flexibility** to change data sources
- **Consistent error handling** with Either
- **Type safety** with proper models

Remember: The domain layer should never know about Supabase!

---

**Keep your repositories clean, focused, and testable!** 🚀