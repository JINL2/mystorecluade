import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company_type.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/get_company_types.dart';

import '../../homepage_mocks.dart';
import '../../homepage_test_fixtures.dart';

void main() {
  late GetCompanyTypes useCase;
  late MockCompanyRepository mockRepository;

  setUp(() {
    mockRepository = MockCompanyRepository();
    useCase = GetCompanyTypes(mockRepository);
  });

  group('GetCompanyTypes', () {
    test('should return list of CompanyType when repository call succeeds',
        () async {
      // arrange
      when(() => mockRepository.getCompanyTypes())
          .thenAnswer((_) async => const Right(tCompanyTypeList));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(tCompanyTypeList));
      verify(() => mockRepository.getCompanyTypes()).called(1);
    });

    test('should return empty list when no company types exist', () async {
      // arrange
      const emptyList = <CompanyType>[];
      when(() => mockRepository.getCompanyTypes())
          .thenAnswer((_) async => const Right(emptyList));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(emptyList));
      verify(() => mockRepository.getCompanyTypes()).called(1);
    });

    test('should return ServerFailure when repository call fails', () async {
      // arrange
      const serverFailure = ServerFailure(
        message: 'Failed to fetch company types',
        code: 'SERVER_ERROR',
      );
      when(() => mockRepository.getCompanyTypes())
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
      verify(() => mockRepository.getCompanyTypes()).called(1);
    });
  });
}
