// Data Layer - Cash Location Detail Model
// DTO for detailed cash location information

import 'dart:convert';
import '../../domain/entities/cash_location_detail.dart';

class CashLocationDetailModel {
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

  CashLocationDetailModel({
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

  /// From JSON (Database) → Model
  factory CashLocationDetailModel.fromJson(Map<String, dynamic> json) {
    // Extract description from location_info if it exists
    String? description;
    if (json['location_info'] != null && json['location_info'] is String) {
      try {
        final locationInfo = jsonDecode(json['location_info'] as String) as Map<String, dynamic>;
        description = locationInfo['description'] as String?;
      } catch (e) {
        description = null;
      }
    }

    return CashLocationDetailModel(
      locationId: json['cash_location_id'] as String? ?? json['id'] as String? ?? '',
      locationName: json['location_name'] as String? ?? json['name'] as String? ?? '',
      locationType: json['location_type'] as String? ?? '',
      note: json['note'] as String?,
      description: description,
      bankName: json['bank_name'] as String?,
      accountNumber: json['bank_account'] as String? ?? json['account_number'] as String?,
      isMainLocation: json['main_cash_location'] as bool? ?? false,
      companyId: json['company_id'] as String? ?? '',
      storeId: json['store_id'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );
  }

  /// Model → Domain Entity
  CashLocationDetail toEntity() {
    return CashLocationDetail(
      locationId: locationId,
      locationName: locationName,
      locationType: locationType,
      note: note,
      description: description,
      bankName: bankName,
      accountNumber: accountNumber,
      isMainLocation: isMainLocation,
      companyId: companyId,
      storeId: storeId,
      isDeleted: isDeleted,
    );
  }
}
