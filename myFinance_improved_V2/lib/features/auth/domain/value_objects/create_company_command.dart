// lib/features/auth/domain/value_objects/create_company_command.dart

/// Command for creating a company
class CreateCompanyCommand {
  final String name;
  final String? businessNumber;
  final String? email;
  final String? phone;
  final String? address;
  final String companyTypeId;
  final String currencyId;
  final String ownerId;

  const CreateCompanyCommand({
    required this.name,
    this.businessNumber,
    this.email,
    this.phone,
    this.address,
    required this.companyTypeId,
    required this.currencyId,
    required this.ownerId,
  });

  @override
  String toString() {
    return 'CreateCompanyCommand(name: $name, ownerId: $ownerId)';
  }
}

