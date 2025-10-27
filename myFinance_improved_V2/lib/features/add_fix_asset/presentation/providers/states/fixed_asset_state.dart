import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/fixed_asset.dart';

part 'fixed_asset_state.freezed.dart';

/// Fixed Asset Page State - UI state for fixed asset page
///
/// Manages the state of the fixed asset list page including
/// loading, error handling, and store/currency selection.
@freezed
class FixedAssetState with _$FixedAssetState {
  const factory FixedAssetState({
    @Default([]) List<FixedAsset> assets,
    @Default(false) bool isLoading,
    @Default(false) bool isCreating,
    String? errorMessage,
    String? selectedStoreId,
    String? baseCurrencyId,
    @Default('\$') String currencySymbol,
  }) = _FixedAssetState;
}

/// Fixed Asset Form State - UI state for asset creation/editing form
///
/// Tracks form submission state and field-level validation errors.
@freezed
class FixedAssetFormState with _$FixedAssetFormState {
  const factory FixedAssetFormState({
    @Default(false) bool isSubmitting,
    String? errorMessage,
    @Default({}) Map<String, String> fieldErrors,
  }) = _FixedAssetFormState;
}
