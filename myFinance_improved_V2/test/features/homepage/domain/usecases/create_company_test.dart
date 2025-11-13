import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/create_company.dart';

import '../../homepage_mocks.dart';
import '../../homepage_test_fixtures.dart';

void main() {
  late CreateCompany useCase;
  late MockCompanyRepository mockRepository;

  setUp(() {
    mockRepository = MockCompanyRepository();
    useCase = CreateCompany(mockRepository);
  });

  group('CreateCompany', () {
    const tParams = CreateCompanyParams(
      companyName: 'Test Company',
      companyTypeId: 'type-123',
      baseCurrencyId: 'usd',
    );

    test('should return Company when repository call succeeds', () async {
      // arrange
      when(() => mockRepository.createCompany(
            companyName: any(named: 'companyName'),
            companyTypeId: any(named: 'companyTypeId'),
            baseCurrencyId: any(named: 'baseCurrencyId'),
          ),).thenAnswer((_) async => const Right(tCompany));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Right(tCompany));
      verify(() => mockRepository.createCompany(
            companyName: 'Test Company',
            companyTypeId: 'type-123',
            baseCurrencyId: 'usd',
          ),).called(1);
    });

    test('should return ValidationFailure when company name is empty',
        () async {
      // arrange
      const emptyNameParams = CreateCompanyParams(
        companyName: '',
        companyTypeId: 'type-123',
        baseCurrencyId: 'usd',
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
      verifyNever(() => mockRepository.createCompany(
            companyName: any(named: 'companyName'),
            companyTypeId: any(named: 'companyTypeId'),
            baseCurrencyId: any(named: 'baseCurrencyId'),
          ),);
    });

    test('should return ValidationFailure when company name is too short',
        () async {
      // arrange
      const shortNameParams = CreateCompanyParams(
        companyName: 'A',
        companyTypeId: 'type-123',
        baseCurrencyId: 'usd',
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
      verifyNever(() => mockRepository.createCompany(
            companyName: any(named: 'companyName'),
            companyTypeId: any(named: 'companyTypeId'),
            baseCurrencyId: any(named: 'baseCurrencyId'),
          ),);
    });

    test('should trim whitespace from company name', () async {
      // arrange
      const paramsWithWhitespace = CreateCompanyParams(
        companyName: '  Test Company  ',
        companyTypeId: 'type-123',
        baseCurrencyId: 'usd',
      );

      when(() => mockRepository.createCompany(
            companyName: any(named: 'companyName'),
            companyTypeId: any(named: 'companyTypeId'),
            baseCurrencyId: any(named: 'baseCurrencyId'),
          ),).thenAnswer((_) async => const Right(tCompany));

      // act
      await useCase(paramsWithWhitespace);

      // assert
      verify(() => mockRepository.createCompany(
            companyName: 'Test Company', // whitespace trimmed
            companyTypeId: 'type-123',
            baseCurrencyId: 'usd',
          ),).called(1);
    });

    test('should return ValidationFailure when companyTypeId is empty',
        () async {
      // arrange
      const invalidParams = CreateCompanyParams(
        companyName: 'Test Company',
        companyTypeId: '',
        baseCurrencyId: 'usd',
      );

      // act
      final result = await useCase(invalidParams);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.code, 'INVALID_COMPANY_TYPE');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return ValidationFailure when baseCurrencyId is empty',
        () async {
      // arrange
      const invalidParams = CreateCompanyParams(
        companyName: 'Test Company',
        companyTypeId: 'type-123',
        baseCurrencyId: '',
      );

      // act
      final result = await useCase(invalidParams);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.code, 'INVALID_CURRENCY');
        },
        (_) => fail('Should return failure'),
      );
    });
  });
}
