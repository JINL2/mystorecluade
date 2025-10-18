import 'package:equatable/equatable.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company.dart';

/// State for Company creation operations
abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CompanyInitial extends CompanyState {
  const CompanyInitial();
}

/// Loading state - creating company
class CompanyLoading extends CompanyState {
  const CompanyLoading();
}

/// Success state - company created
class CompanyCreated extends CompanyState {
  const CompanyCreated(this.company);

  final Company company;

  @override
  List<Object?> get props => [company];
}

/// Error state - failed to create company
class CompanyError extends CompanyState {
  const CompanyError(this.message, this.errorCode);

  final String message;
  final String errorCode;

  @override
  List<Object?> get props => [message, errorCode];
}
