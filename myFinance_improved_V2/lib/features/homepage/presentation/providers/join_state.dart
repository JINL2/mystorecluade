import 'package:equatable/equatable.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/join_result.dart';

/// Base state for Join operations
abstract class JoinState extends Equatable {
  const JoinState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any join operation
class JoinInitial extends JoinState {
  const JoinInitial();
}

/// State while joining is in progress
class JoinLoading extends JoinState {
  const JoinLoading();
}

/// State when join was successful
class JoinSuccess extends JoinState {
  const JoinSuccess(this.result);

  final JoinResult result;

  @override
  List<Object?> get props => [result];
}

/// State when join failed
class JoinError extends JoinState {
  const JoinError(this.message, this.errorCode);

  final String message;
  final String errorCode;

  @override
  List<Object?> get props => [message, errorCode];
}
