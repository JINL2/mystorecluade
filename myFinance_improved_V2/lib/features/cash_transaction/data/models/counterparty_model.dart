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
  /// Supports both direct table query (snake_case) and RPC response (camelCase + additionalData)
  factory CounterpartyModel.fromJson(Map<String, dynamic> json) {
    // RPC returns additionalData with snake_case fields
    final additionalData = json['additionalData'] as Map<String, dynamic>?;

    return CounterpartyModel(
      // RPC returns 'id', table returns 'counterparty_id'
      counterpartyId: (json['id'] ?? json['counterparty_id'] ?? additionalData?['counterparty_id'] ?? '') as String,
      name: json['name'] as String? ?? '',
      type: json['type'] as String?,
      // RPC returns 'isInternal', table returns 'is_internal'
      isInternal: (json['isInternal'] ?? json['is_internal'] ?? false) as bool,
      // RPC returns in additionalData, table returns directly
      linkedCompanyId: (additionalData?['linked_company_id'] ?? json['linked_company_id']) as String?,
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
