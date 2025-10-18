import 'package:equatable/equatable.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';

/// State for Store creation operations
abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class StoreInitial extends StoreState {
  const StoreInitial();
}

/// Loading state - creating store
class StoreLoading extends StoreState {
  const StoreLoading();
}

/// Success state - store created
class StoreCreated extends StoreState {
  const StoreCreated(this.store);

  final Store store;

  @override
  List<Object?> get props => [store];
}

/// Error state - failed to create store
class StoreError extends StoreState {
  const StoreError(this.message, this.errorCode);

  final String message;
  final String errorCode;

  @override
  List<Object?> get props => [message, errorCode];
}
