import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/join_by_code.dart';

import '../../homepage_mocks.dart';
import '../../homepage_test_fixtures.dart';

void main() {
  late JoinByCode useCase;
  late MockJoinRepository mockRepository;

  setUp(() {
    mockRepository = MockJoinRepository();
    useCase = JoinByCode(mockRepository);
  });

  group('JoinByCode', () {
    const tUserId = 'user-test-123';
    const tCode = 'COMP12345';

    const tParams = JoinByCodeParams(
      userId: tUserId,
      code: tCode,
    );

    test('should return JoinResult when repository call succeeds with company code',
        () async {
      // arrange
      when(() => mockRepository.joinByCode(
            userId: any(named: 'userId'),
            code: any(named: 'code'),
          )).thenAnswer((_) async => const Right(tJoinResultCompany));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Right(tJoinResultCompany));
      verify(() => mockRepository.joinByCode(
            userId: tUserId,
            code: tCode,
          )).called(1);
    });

    test('should return JoinResult when repository call succeeds with store code',
        () async {
      // arrange
      when(() => mockRepository.joinByCode(
            userId: any(named: 'userId'),
            code: any(named: 'code'),
          )).thenAnswer((_) async => const Right(tJoinResultStore));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Right(tJoinResultStore));
      verify(() => mockRepository.joinByCode(
            userId: tUserId,
            code: tCode,
          )).called(1);
    });

    test('should return ValidationFailure when code is empty', () async {
      // arrange
      const emptyCodeParams = JoinByCodeParams(
        userId: tUserId,
        code: '',
      );

      // act
      final result = await useCase(emptyCodeParams);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.code, 'EMPTY_CODE');
        },
        (_) => fail('Should return failure'),
      );
      verifyNever(() => mockRepository.joinByCode(
            userId: any(named: 'userId'),
            code: any(named: 'code'),
          ));
    });

    test('should return ValidationFailure when code is too short', () async {
      // arrange
      const shortCodeParams = JoinByCodeParams(
        userId: tUserId,
        code: 'AB12', // 4 characters (minimum is 5)
      );

      // act
      final result = await useCase(shortCodeParams);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.code, 'INVALID_CODE_FORMAT');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return ValidationFailure when code is too long', () async {
      // arrange
      const longCodeParams = JoinByCodeParams(
        userId: tUserId,
        code: 'ABCDEFGHIJ1234567890X', // 21 characters (maximum is 20)
      );

      // act
      final result = await useCase(longCodeParams);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.code, 'INVALID_CODE_FORMAT');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return ValidationFailure when code contains invalid characters',
        () async {
      // arrange
      const invalidCodeParams = JoinByCodeParams(
        userId: tUserId,
        code: 'COMP-12345', // Contains hyphen (not alphanumeric)
      );

      // act
      final result = await useCase(invalidCodeParams);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.code, 'INVALID_CODE_FORMAT');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should convert code to uppercase before calling repository',
        () async {
      // arrange
      const lowercaseParams = JoinByCodeParams(
        userId: tUserId,
        code: 'comp12345', // lowercase
      );

      when(() => mockRepository.joinByCode(
            userId: any(named: 'userId'),
            code: any(named: 'code'),
          )).thenAnswer((_) async => const Right(tJoinResultCompany));

      // act
      await useCase(lowercaseParams);

      // assert
      verify(() => mockRepository.joinByCode(
            userId: tUserId,
            code: 'COMP12345', // converted to uppercase
          )).called(1);
    });

    test('should trim whitespace from code before calling repository',
        () async {
      // arrange
      const whitespaceParams = JoinByCodeParams(
        userId: tUserId,
        code: '  COMP12345  ', // with whitespace
      );

      when(() => mockRepository.joinByCode(
            userId: any(named: 'userId'),
            code: any(named: 'code'),
          )).thenAnswer((_) async => const Right(tJoinResultCompany));

      // act
      await useCase(whitespaceParams);

      // assert
      verify(() => mockRepository.joinByCode(
            userId: tUserId,
            code: 'COMP12345', // whitespace trimmed
          )).called(1);
    });

    test('should handle both trim and uppercase transformations together',
        () async {
      // arrange
      const mixedParams = JoinByCodeParams(
        userId: tUserId,
        code: '  comp12345  ', // lowercase with whitespace
      );

      when(() => mockRepository.joinByCode(
            userId: any(named: 'userId'),
            code: any(named: 'code'),
          )).thenAnswer((_) async => const Right(tJoinResultCompany));

      // act
      await useCase(mixedParams);

      // assert
      verify(() => mockRepository.joinByCode(
            userId: tUserId,
            code: 'COMP12345', // trimmed and uppercase
          )).called(1);
    });
  });
}
