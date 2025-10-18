class TemplateCreationData {
  final String name;
  final String? description;
  final String? selectedDebitAccountId;
  final String? selectedCreditAccountId;
  final String? selectedDebitCounterpartyId;
  final Map<String, dynamic>? selectedDebitCounterpartyData;
  final String? selectedCreditCounterpartyId;
  final Map<String, dynamic>? selectedCreditCounterpartyData;
  final String? selectedDebitStoreId;
  final String? selectedDebitCashLocationId;
  final String? selectedCreditStoreId;
  final String? selectedCreditCashLocationId;
  final String? selectedDebitMyCashLocationId;
  final String? selectedCreditMyCashLocationId;
  final String visibilityLevel;
  final String permission;
  
  const TemplateCreationData({
    required this.name,
    this.description,
    this.selectedDebitAccountId,
    this.selectedCreditAccountId,
    this.selectedDebitCounterpartyId,
    this.selectedDebitCounterpartyData,
    this.selectedCreditCounterpartyId,
    this.selectedCreditCounterpartyData,
    this.selectedDebitStoreId,
    this.selectedDebitCashLocationId,
    this.selectedCreditStoreId,
    this.selectedCreditCashLocationId,
    this.selectedDebitMyCashLocationId,
    this.selectedCreditMyCashLocationId,
    required this.visibilityLevel,
    required this.permission,
  });
}