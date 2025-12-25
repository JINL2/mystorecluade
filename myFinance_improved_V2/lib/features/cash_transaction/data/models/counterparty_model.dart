import '../../domain/entities/counterparty.dart';

/// Data model for Counterparty
///
/// Handles JSON serialization and mapping to domain entity
class CounterpartyModel {
  final String counterpartyId;
  final String name;
  final String? type;
  final bool isInternal;
  final String? linkedCompanyId;

  CounterpartyModel({
    required this.counterpartyId,
    required this.name,
    this.type,
    this.isInternal = false,
    this.linkedCompanyId,
  });

  /// From JSON (API/Database) → Model
  factory CounterpartyModel.fromJson(Map<String, dynamic> json) {
    return CounterpartyModel(
      counterpartyId: json['counterparty_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String?,
      isInternal: json['is_internal'] as bool? ?? false,
      linkedCompanyId: json['linked_company_id'] as String?,
    );
  }

  /// Model → Domain Entity
  Counterparty toEntity() {
    return Counterparty(
      counterpartyId: counterpartyId,
      name: name,
      type: type,
      isInternal: isInternal,
      linkedCompanyId: linkedCompanyId,
    );
  }

  /// Model → JSON (for API calls)
  Map<String, dynamic> toJson() {
    return {
      'counterparty_id': counterpartyId,
      'name': name,
      'type': type,
      'is_internal': isInternal,
      'linked_company_id': linkedCompanyId,
    };
  }
}
