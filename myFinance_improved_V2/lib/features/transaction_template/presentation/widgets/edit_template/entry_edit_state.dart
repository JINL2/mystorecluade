/// Entry Edit State - State management for template entry editing
///
/// Purpose: Manages editable state for individual template entries
/// - Holds form controllers and field values
/// - Tracks changes for validation
///
/// Clean Architecture: PRESENTATION LAYER - State Model
library;

import 'package:flutter/material.dart';

/// Entry edit state helper class
/// Manages mutable state for editing a single template entry
class EntryEditState {
  final TextEditingController descriptionController;
  String? cashLocationId;
  String? counterpartyId;
  String? counterpartyName;
  bool isCounterpartyInternal;
  String? linkedCompanyId; // For internal counterparty's company
  String? counterpartyStoreId; // Counterparty's selected store
  String? counterpartyStoreName;
  String? counterpartyCashLocationId;
  String? counterpartyCashLocationName;
  String? categoryTag; // To check if payable/receivable
  String? accountId; // For account mapping check
  String? accountCode; // Account code for expense detection (5000-9999)
  Map<String, dynamic>? accountMapping; // Account mapping result
  String? mappingError; // Account mapping error

  EntryEditState({
    required this.descriptionController,
    this.cashLocationId,
    this.counterpartyId,
    this.counterpartyName,
    this.isCounterpartyInternal = false,
    this.linkedCompanyId,
    this.counterpartyStoreId,
    this.counterpartyStoreName,
    this.counterpartyCashLocationId,
    this.counterpartyCashLocationName,
    this.categoryTag,
    this.accountId,
    this.accountCode,
    this.accountMapping,
    this.mappingError,
  });

  factory EntryEditState.fromEntry(Map<String, dynamic> entry) {
    // Check if counterparty is internal by looking for linked_company_id
    final linkedCompanyIdRaw = entry['linked_company_id'];
    final linkedCompanyId = linkedCompanyIdRaw?.toString();
    final hasLinkedCompany = linkedCompanyId != null &&
        linkedCompanyId.isNotEmpty &&
        linkedCompanyId != 'null';

    // Get counterparty store info
    final counterpartyStoreIdRaw = entry['counterparty_store_id'];
    final counterpartyStoreId = counterpartyStoreIdRaw?.toString();
    final hasCounterpartyStore = counterpartyStoreId != null &&
        counterpartyStoreId.isNotEmpty &&
        counterpartyStoreId != 'null';

    return EntryEditState(
      descriptionController: TextEditingController(
        text: entry['description']?.toString() ?? '',
      ),
      cashLocationId: entry['cash_location_id']?.toString(),
      counterpartyId: entry['counterparty_id']?.toString(),
      counterpartyName: entry['counterparty_name']?.toString(),
      isCounterpartyInternal: hasLinkedCompany,
      linkedCompanyId: hasLinkedCompany ? linkedCompanyId : null,
      counterpartyStoreId: hasCounterpartyStore ? counterpartyStoreId : null,
      counterpartyStoreName: entry['counterparty_store_name']?.toString(),
      counterpartyCashLocationId:
          entry['counterparty_cash_location_id']?.toString(),
      counterpartyCashLocationName:
          entry['counterparty_cash_location_name']?.toString(),
      categoryTag: entry['category_tag']?.toString(),
      accountId: entry['account_id']?.toString(),
      accountCode: entry['account_code']?.toString(), // For expense detection
    );
  }

  void dispose() {
    descriptionController.dispose();
  }
}

/// Original entry state for change detection (immutable snapshot)
/// Used to compare against current state to detect changes
class EntryOriginalState {
  final String description;
  final String? cashLocationId;
  final String? counterpartyStoreId;
  final String? counterpartyCashLocationId;

  const EntryOriginalState({
    required this.description,
    this.cashLocationId,
    this.counterpartyStoreId,
    this.counterpartyCashLocationId,
  });

  factory EntryOriginalState.fromEntry(Map<String, dynamic> entry) {
    return EntryOriginalState(
      description: entry['description']?.toString() ?? '',
      cashLocationId: entry['cash_location_id']?.toString(),
      counterpartyStoreId: entry['counterparty_store_id']?.toString(),
      counterpartyCashLocationId:
          entry['counterparty_cash_location_id']?.toString(),
    );
  }
}
