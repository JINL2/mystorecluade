// lib/features/auth/domain/value_objects/create_store_command.dart

/// Command for creating a store
class CreateStoreCommand {
  final String name;
  final String companyId;
  final String? storeCode;
  final String? phone;
  final String? address;
  final String? timezone;
  final String? description;

  // Operational settings
  final int? huddleTimeMinutes;
  final int? paymentTimeDays;
  final double? allowedDistanceMeters;

  const CreateStoreCommand({
    required this.name,
    required this.companyId,
    this.storeCode,
    this.phone,
    this.address,
    this.timezone,
    this.description,
    this.huddleTimeMinutes,
    this.paymentTimeDays,
    this.allowedDistanceMeters,
  });

  @override
  String toString() {
    return 'CreateStoreCommand(name: $name, companyId: $companyId)';
  }
}

