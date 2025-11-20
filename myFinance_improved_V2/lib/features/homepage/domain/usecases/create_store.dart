import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/store_repository.dart';

/// Use case for creating a new store
///
/// Encapsulates the business logic for store creation
/// Follows Clean Architecture's dependency inversion principle
class CreateStore {
  const CreateStore(this.repository);

  final StoreRepository repository;

  /// Execute the use case
  ///
  /// Validates inputs and delegates to repository
  /// Returns [Right<Store>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Store>> call(CreateStoreParams params) async {
    // Validate store name
    if (params.storeName.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Please enter a valid store name',
        code: 'INVALID_NAME',
      ),);
    }

    if (params.storeName.trim().length < 2) {
      return const Left(ValidationFailure(
        message: 'Store name must be at least 2 characters',
        code: 'NAME_TOO_SHORT',
      ),);
    }

    if (params.storeName.trim().length > 100) {
      return const Left(ValidationFailure(
        message: 'Store name must be less than 100 characters',
        code: 'NAME_TOO_LONG',
      ),);
    }

    // Validate company ID
    if (params.companyId.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Invalid company selected',
        code: 'INVALID_COMPANY_ID',
      ),);
    }

    // Validate optional store address
    if (params.storeAddress != null && params.storeAddress!.trim().isNotEmpty) {
      if (params.storeAddress!.trim().length < 5) {
        return const Left(ValidationFailure(
          message: 'Store address must be at least 5 characters',
          code: 'ADDRESS_TOO_SHORT',
        ),);
      }

      if (params.storeAddress!.trim().length > 500) {
        return const Left(ValidationFailure(
          message: 'Store address must be less than 500 characters',
          code: 'ADDRESS_TOO_LONG',
        ),);
      }
    }

    // Validate optional store phone
    if (params.storePhone != null && params.storePhone!.trim().isNotEmpty) {
      final phoneRegex = RegExp(
          r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}$',);
      if (!phoneRegex.hasMatch(params.storePhone!.trim())) {
        return const Left(ValidationFailure(
          message: 'Please enter a valid phone number',
          code: 'INVALID_PHONE',
        ),);
      }
    }

    // Validate operational settings
    if (params.huddleTime != null &&
        (params.huddleTime! <= 0 || params.huddleTime! > 1440)) {
      return const Left(ValidationFailure(
        message: 'Huddle time must be between 1 and 1440 minutes',
        code: 'INVALID_HUDDLE_TIME',
      ),);
    }

    if (params.paymentTime != null &&
        (params.paymentTime! <= 0 || params.paymentTime! > 1440)) {
      return const Left(ValidationFailure(
        message: 'Payment time must be between 1 and 1440 minutes',
        code: 'INVALID_PAYMENT_TIME',
      ),);
    }

    if (params.allowedDistance != null &&
        (params.allowedDistance! <= 0 || params.allowedDistance! > 10000)) {
      return const Left(ValidationFailure(
        message: 'Allowed distance must be between 1 and 10000 meters',
        code: 'INVALID_ALLOWED_DISTANCE',
      ),);
    }

    // Delegate to repository
    return await repository.createStore(
      storeName: params.storeName.trim(),
      companyId: params.companyId.trim(),
      storeAddress: params.storeAddress?.trim(),
      storePhone: params.storePhone?.trim(),
      huddleTime: params.huddleTime,
      paymentTime: params.paymentTime,
      allowedDistance: params.allowedDistance,
    );
  }
}

/// Parameters for creating a store
class CreateStoreParams extends Equatable {
  const CreateStoreParams({
    required this.storeName,
    required this.companyId,
    this.storeAddress,
    this.storePhone,
    this.huddleTime,
    this.paymentTime,
    this.allowedDistance,
  });

  final String storeName;
  final String companyId;
  final String? storeAddress;
  final String? storePhone;
  final int? huddleTime;
  final int? paymentTime;
  final int? allowedDistance;

  @override
  List<Object?> get props => [
        storeName,
        companyId,
        storeAddress,
        storePhone,
        huddleTime,
        paymentTime,
        allowedDistance,
      ];
}
