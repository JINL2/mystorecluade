import 'package:equatable/equatable.dart';

/// Company Type entity (e.g., Retail, Restaurant, Service)
/// Represents a business category from the company_types table
class CompanyType extends Equatable {
  const CompanyType({
    required this.id,
    required this.typeName,
  });

  /// Unique identifier (company_type_id from database)
  final String id;

  /// Display name of the company type (e.g., "Retail", "Restaurant")
  final String typeName;

  @override
  List<Object?> get props => [id, typeName];

  @override
  String toString() => 'CompanyType(id: $id, typeName: $typeName)';

  // ============================================
  // Mock Factory (for skeleton loading)
  // ============================================

  static CompanyType mock() => const CompanyType(
        id: 'mock-type-id',
        typeName: 'Retail',
      );

  static List<CompanyType> mockList([int count = 3]) => [
        const CompanyType(id: 'retail', typeName: 'Retail'),
        const CompanyType(id: 'restaurant', typeName: 'Restaurant'),
        const CompanyType(id: 'service', typeName: 'Service'),
      ].take(count).toList();
}
