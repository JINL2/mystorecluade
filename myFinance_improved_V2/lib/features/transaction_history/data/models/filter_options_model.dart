import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction_filter.dart';

part 'filter_options_model.freezed.dart';

/// Data model for filter options
@freezed
class FilterOptionsModel with _$FilterOptionsModel {
  const factory FilterOptionsModel({
    @Default([]) List<FilterOptionModel> stores,
    @Default([]) List<FilterOptionModel> accounts,
    @JsonKey(name: 'cash_locations') @Default([]) List<FilterOptionModel> cashLocations,
    @Default([]) List<FilterOptionModel> counterparties,
    @JsonKey(name: 'journal_types') @Default([]) List<FilterOptionModel> journalTypes,
    @Default([]) List<FilterOptionModel> users,
  }) = _FilterOptionsModel;

  factory FilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionsModel(
      stores: (json['stores'] as List<dynamic>? ?? [])
          .map((item) => FilterOptionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      accounts: (json['accounts'] as List<dynamic>? ?? [])
          .map((item) => FilterOptionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      cashLocations: (json['cash_locations'] as List<dynamic>? ?? [])
          .map((item) => FilterOptionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      counterparties: (json['counterparties'] as List<dynamic>? ?? [])
          .map((item) => FilterOptionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      journalTypes: (json['journal_types'] as List<dynamic>? ?? [])
          .map((item) => FilterOptionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      users: (json['users'] as List<dynamic>? ?? [])
          .map((item) => FilterOptionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Extension to convert model to entity
extension FilterOptionsModelMapper on FilterOptionsModel {
  FilterOptions toEntity() {
    return FilterOptions(
      stores: stores.map((s) => s.toEntity()).toList(),
      accounts: accounts.map((a) => a.toEntity()).toList(),
      cashLocations: cashLocations.map((c) => c.toEntity()).toList(),
      counterparties: counterparties.map((c) => c.toEntity()).toList(),
      journalTypes: journalTypes.map((j) => j.toEntity()).toList(),
      users: users.map((u) => u.toEntity()).toList(),
    );
  }
}

/// Individual filter option model
@freezed
class FilterOptionModel with _$FilterOptionModel {
  const factory FilterOptionModel({
    required String id,
    required String name,
    @JsonKey(name: 'transaction_count') @Default(0) int transactionCount,
  }) = _FilterOptionModel;

  factory FilterOptionModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      transactionCount: (json['transaction_count'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Extension to convert option model to entity
extension FilterOptionModelMapper on FilterOptionModel {
  FilterOption toEntity() {
    return FilterOption(
      id: id,
      name: name,
      transactionCount: transactionCount,
    );
  }
}
