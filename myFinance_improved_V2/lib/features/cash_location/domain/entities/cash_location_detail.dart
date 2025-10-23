// Domain Entity - Cash Location Detail
// Represents detailed cash location information for editing/viewing

class CashLocationDetail {
  final String locationId;
  final String locationName;
  final String locationType;
  final String? note;
  final String? description;
  final String? bankName;
  final String? accountNumber;
  final bool isMainLocation;
  final String companyId;
  final String? storeId;
  final bool isDeleted;

  const CashLocationDetail({
    required this.locationId,
    required this.locationName,
    required this.locationType,
    this.note,
    this.description,
    this.bankName,
    this.accountNumber,
    required this.isMainLocation,
    required this.companyId,
    this.storeId,
    this.isDeleted = false,
  });

  CashLocationDetail copyWith({
    String? locationId,
    String? locationName,
    String? locationType,
    String? note,
    String? description,
    String? bankName,
    String? accountNumber,
    bool? isMainLocation,
    String? companyId,
    String? storeId,
    bool? isDeleted,
  }) {
    return CashLocationDetail(
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      locationType: locationType ?? this.locationType,
      note: note ?? this.note,
      description: description ?? this.description,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      isMainLocation: isMainLocation ?? this.isMainLocation,
      companyId: companyId ?? this.companyId,
      storeId: storeId ?? this.storeId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
