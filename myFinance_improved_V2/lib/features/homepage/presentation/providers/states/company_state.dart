import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/company.dart';

part 'company_state.freezed.dart';

/// Company State - UI state for company operations
///
/// Handles company creation and management states
@freezed
class CompanyState with _$CompanyState {
  const factory CompanyState.initial() = _Initial;

  const factory CompanyState.loading() = _Loading;

  const factory CompanyState.created(Company company) = _Created;

  const factory CompanyState.error(
    String message,
    String errorCode,
  ) = _Error;
}
