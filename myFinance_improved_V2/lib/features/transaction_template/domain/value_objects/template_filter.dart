import 'package:equatable/equatable.dart';

/// Value object for template filtering criteria
/// 
/// Encapsulates all filtering parameters for transaction templates.
/// This is an immutable value object following Clean Architecture principles.
class TemplateFilter extends Equatable {
  /// Filter by specific account IDs
  final List<String>? accountIds;
  
  /// Filter by counterparty ID
  final String? counterpartyId;
  
  /// Filter by cash location ID
  final String? cashLocationId;
  
  /// Filter by search query (name, description)
  final String? searchQuery;
  
  /// Filter by visibility level
  final String? visibilityLevel;
  
  /// Filter by permission level
  final String? permission;

  const TemplateFilter({
    this.accountIds,
    this.counterpartyId,
    this.cashLocationId,
    this.searchQuery,
    this.visibilityLevel,
    this.permission,
  });

  /// Factory constructor for creating empty filter
  factory TemplateFilter.empty() {
    return const TemplateFilter();
  }

  /// Factory constructor for search-only filter
  factory TemplateFilter.search(String query) {
    return TemplateFilter(searchQuery: query);
  }

  /// Checks if filter is empty (no criteria set)
  bool get isEmpty => 
    (accountIds?.isEmpty ?? true) &&
    counterpartyId == null &&
    cashLocationId == null &&
    (searchQuery?.isEmpty ?? true) &&
    visibilityLevel == null &&
    permission == null;

  /// Checks if filter has any criteria
  bool get isNotEmpty => !isEmpty;

  /// Checks if filter has account criteria
  bool get hasAccountFilter => accountIds?.isNotEmpty ?? false;

  /// Checks if filter has counterparty criteria
  bool get hasCounterpartyFilter => counterpartyId != null;

  /// Checks if filter has cash location criteria
  bool get hasCashLocationFilter => cashLocationId != null;

  /// Checks if filter has search criteria
  bool get hasSearchFilter => searchQuery?.isNotEmpty ?? false;

  /// Creates a copy with updated values
  TemplateFilter copyWith({
    List<String>? accountIds,
    String? counterpartyId,
    String? cashLocationId,
    String? searchQuery,
    String? visibilityLevel,
    String? permission,
  }) {
    return TemplateFilter(
      accountIds: accountIds ?? this.accountIds,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      cashLocationId: cashLocationId ?? this.cashLocationId,
      searchQuery: searchQuery ?? this.searchQuery,
      visibilityLevel: visibilityLevel ?? this.visibilityLevel,
      permission: permission ?? this.permission,
    );
  }

  /// Clears all filter criteria
  TemplateFilter clear() {
    return TemplateFilter.empty();
  }

  /// Converts to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      if (accountIds != null) 'accountIds': accountIds,
      if (counterpartyId != null) 'counterpartyId': counterpartyId,
      if (cashLocationId != null) 'cashLocationId': cashLocationId,
      if (searchQuery != null) 'searchQuery': searchQuery,
      if (visibilityLevel != null) 'visibilityLevel': visibilityLevel,
      if (permission != null) 'permission': permission,
    };
  }

  /// Creates template filter from map
  factory TemplateFilter.fromMap(Map<String, dynamic> map) {
    return TemplateFilter(
      accountIds: map['accountIds'] != null 
        ? List<String>.from(map['accountIds'] as List)
        : null,
      counterpartyId: map['counterpartyId'] as String?,
      cashLocationId: map['cashLocationId'] as String?,
      searchQuery: map['searchQuery'] as String?,
      visibilityLevel: map['visibilityLevel'] as String?,
      permission: map['permission'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        accountIds,
        counterpartyId,
        cashLocationId,
        searchQuery,
        visibilityLevel,
        permission,
      ];

  @override
  String toString() => 'TemplateFilter(${toMap()})';
}