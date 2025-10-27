import 'package:freezed_annotation/freezed_annotation.dart';

/// Counter Party Type Enum
enum CounterPartyType {
  @JsonValue('My Company')
  myCompany('My Company', 'Internal company within the group'),

  @JsonValue('Team Member')
  teamMember('Team Member', 'Internal team member'),

  @JsonValue('Suppliers')
  supplier('Suppliers', 'External supplier or vendor'),

  @JsonValue('Employees')
  employee('Employees', 'Company employee'),

  @JsonValue('Customers')
  customer('Customers', 'External customer or client'),

  @JsonValue('Others')
  other('Others', 'Other type of counterparty');

  final String displayName;
  final String description;

  const CounterPartyType(this.displayName, this.description);
}

/// Helper function to convert type from JSON
CounterPartyType counterPartyTypeFromJson(dynamic value) {
  if (value == null) return CounterPartyType.other;

  // Handle both uppercase and lowercase variations
  final normalizedValue = value.toString();

  switch (normalizedValue) {
    case 'My Company':
    case 'my company':
    case 'myCompany':
      return CounterPartyType.myCompany;
    case 'Team Member':
    case 'team member':
    case 'teamMember':
      return CounterPartyType.teamMember;
    case 'Suppliers':
    case 'suppliers':
    case 'supplier':
      return CounterPartyType.supplier;
    case 'Employees':
    case 'employees':
    case 'employee':
      return CounterPartyType.employee;
    case 'Customers':
    case 'customers':
    case 'customer':
      return CounterPartyType.customer;
    case 'Others':
    case 'others':
    case 'other':
    default:
      return CounterPartyType.other;
  }
}

/// Helper function to convert type to JSON (for database)
String counterPartyTypeToJson(CounterPartyType type) {
  return type.displayName;
}
