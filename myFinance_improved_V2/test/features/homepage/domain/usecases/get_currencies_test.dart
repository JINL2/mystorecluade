import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/currency.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/get_currencies.dart';

import '../../homepage_mocks.dart';
import '../../homepage_test_fixtures.dart';

void main() {
  late GetCurrencies useCase;
  late MockCompanyRepository mockRepository;

  setUp(() {
    mockRepository = MockCompanyRepository();
    useCase = GetCurrencies(mockRepository);
  });

  group('GetCurrencies', () {
    test('should return list of Currency when repository call succeeds',
        () async {
      // arrange
      when(() => mockRepository.getCurrencies())
          .thenAnswer((_) async => const Right(tCurrencyList));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(tCurrencyList));
      verify(() => mockRepository.getCurrencies()).called(1);
    });

    test('should return empty list when no currencies exist', () async {
      // arrange
      const emptyList = <Currency>[];
      when(() => mockRepository.getCurrencies())
          .thenAnswer((_) async => const Right(emptyList));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(emptyList));
      verify(() => mockRepository.getCurrencies()).called(1);
    });

    test('should return ServerFailure when repository call fails', () async {
      // arrange
      const serverFailure = ServerFailure(
        message: 'Failed to fetch currencies',
        code: 'SERVER_ERROR',
      );
      when(() => mockRepository.getCurrencies())
          .thenAnswer((_) async => const Left(serverFailure));

      // act
      final result = await useCase();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.code, 'SERVER_ERROR');
        },
        (_) => fail('Should return failure'),
      );
      verify(() => mockRepository.getCurrencies()).called(1);
    });
  });
}
