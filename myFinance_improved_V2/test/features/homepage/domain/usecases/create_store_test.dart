import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/create_store.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';

import '../../homepage_mocks.dart';
import '../../homepage_test_fixtures.dart';

void main() {
  late CreateStore useCase;
  late MockStoreRepository mockRepository;

  setUp(() {
    mockRepository = MockStoreRepository();
    useCase = CreateStore(mockRepository);
  });

  group('CreateStore', () {
    const tParams = CreateStoreParams(
      storeName: 'Test Store',
      companyId: 'comp-test-123',
    );

    test('should return Store when repository call succeeds', () async {
      // arrange
      when(() => mockRepository.createStore(
            storeName: any(named: 'storeName'),
            companyId: any(named: 'companyId'),
            storeAddress: any(named: 'storeAddress'),
            storePhone: any(named: 'storePhone'),
            huddleTime: any(named: 'huddleTime'),
            paymentTime: any(named: 'paymentTime'),
            allowedDistance: any(named: 'allowedDistance'),
          )).thenAnswer((_) async => const Right(tStore));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Right(tStore));
      verify(() => mockRepository.createStore(
            storeName: 'Test Store',
            companyId: 'comp-test-123',
            storeAddress: null,
            storePhone: null,
            huddleTime: null,
            paymentTime: null,
            allowedDistance: null,
          )).called(1);
    });

    test('should return ValidationFailure when store name is empty', () async {
      // arrange
      const emptyNameParams = CreateStoreParams(
        storeName: '',
        companyId: 'comp-test-123',
      );

      // act
      final result = await useCase(emptyNameParams);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.code, 'INVALID_NAME');
        },
        (_) => fail('Should return failure'),
      );
      verifyNever(() => mockRepository.createStore(
            storeName: any(named: 'storeName'),
            companyId: any(named: 'companyId'),
            storeAddress: any(named: 'storeAddress'),
            storePhone: any(named: 'storePhone'),
            huddleTime: any(named: 'huddleTime'),
            paymentTime: any(named: 'paymentTime'),
            allowedDistance: any(named: 'allowedDistance'),
          ));
    });

    test('should return ValidationFailure when store name is too short',
        () async {
      // arrange
      const shortNameParams = CreateStoreParams(
        storeName: 'A',
        companyId: 'comp-test-123',
      );

      // act
      final result = await useCase(shortNameParams);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.code, 'NAME_TOO_SHORT');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should trim whitespace from store name', () async {
      // arrange
      const paramsWithWhitespace = CreateStoreParams(
        storeName: '  Test Store  ',
        companyId: 'comp-test-123',
      );

      when(() => mockRepository.createStore(
            storeName: any(named: 'storeName'),
            companyId: any(named: 'companyId'),
            storeAddress: any(named: 'storeAddress'),
            storePhone: any(named: 'storePhone'),
            huddleTime: any(named: 'huddleTime'),
            paymentTime: any(named: 'paymentTime'),
            allowedDistance: any(named: 'allowedDistance'),
          )).thenAnswer((_) async => const Right(tStore));

      // act
      await useCase(paramsWithWhitespace);

      // assert
      verify(() => mockRepository.createStore(
            storeName: 'Test Store', // whitespace trimmed
            companyId: 'comp-test-123',
            storeAddress: null,
            storePhone: null,
            huddleTime: null,
            paymentTime: null,
            allowedDistance: null,
          )).called(1);
    });

    test('should return ValidationFailure when companyId is empty', () async {
      // arrange
      const invalidParams = CreateStoreParams(
        storeName: 'Test Store',
        companyId: '',
      );

      // act
      final result = await useCase(invalidParams);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.code, 'INVALID_COMPANY_ID');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should pass optional parameters correctly', () async {
      // arrange
      const paramsWithOptionals = CreateStoreParams(
        storeName: 'Test Store',
        companyId: 'comp-test-123',
        storeAddress: '123 Test St',
        storePhone: '010-1234-5678',
        huddleTime: 15,
        paymentTime: 30,
        allowedDistance: 100,
      );

      when(() => mockRepository.createStore(
            storeName: any(named: 'storeName'),
            companyId: any(named: 'companyId'),
            storeAddress: any(named: 'storeAddress'),
            storePhone: any(named: 'storePhone'),
            huddleTime: any(named: 'huddleTime'),
            paymentTime: any(named: 'paymentTime'),
            allowedDistance: any(named: 'allowedDistance'),
          )).thenAnswer((_) async => const Right(tStore));

      // act
      await useCase(paramsWithOptionals);

      // assert
      verify(() => mockRepository.createStore(
            storeName: 'Test Store',
            companyId: 'comp-test-123',
            storeAddress: '123 Test St',
            storePhone: '010-1234-5678',
            huddleTime: 15,
            paymentTime: 30,
            allowedDistance: 100,
          )).called(1);
    });
  });
}
