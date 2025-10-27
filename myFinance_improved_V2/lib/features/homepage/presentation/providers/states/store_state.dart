import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/store.dart';

part 'store_state.freezed.dart';

/// Store State - UI state for store operations
///
/// Handles store creation and management states
@freezed
class StoreState with _$StoreState {
  const factory StoreState.initial() = _Initial;

  const factory StoreState.loading() = _Loading;

  const factory StoreState.created(Store store) = _Created;

  const factory StoreState.error(
    String message,
    String errorCode,
  ) = _Error;
}
