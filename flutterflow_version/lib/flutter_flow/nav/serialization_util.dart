import 'dart:convert';

import 'package:flutter/material.dart';

import '/backend/schema/structs/index.dart';

import '/backend/supabase/supabase.dart';

import '../../flutter_flow/place.dart';
import '../../flutter_flow/uploaded_file.dart';

/// SERIALIZATION HELPERS

String dateTimeRangeToString(DateTimeRange dateTimeRange) {
  final startStr = dateTimeRange.start.millisecondsSinceEpoch.toString();
  final endStr = dateTimeRange.end.millisecondsSinceEpoch.toString();
  return '$startStr|$endStr';
}

String placeToString(FFPlace place) => jsonEncode({
      'latLng': place.latLng.serialize(),
      'name': place.name,
      'address': place.address,
      'city': place.city,
      'state': place.state,
      'country': place.country,
      'zipCode': place.zipCode,
    });

String uploadedFileToString(FFUploadedFile uploadedFile) =>
    uploadedFile.serialize();

String? serializeParam(
  dynamic param,
  ParamType paramType, {
  bool isList = false,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final serializedValues = (param as Iterable)
          .map((p) => serializeParam(p, paramType, isList: false))
          .where((p) => p != null)
          .map((p) => p!)
          .toList();
      return json.encode(serializedValues);
    }
    String? data;
    switch (paramType) {
      case ParamType.int:
        data = param.toString();
      case ParamType.double:
        data = param.toString();
      case ParamType.String:
        data = param;
      case ParamType.bool:
        data = param ? 'true' : 'false';
      case ParamType.DateTime:
        data = (param as DateTime).millisecondsSinceEpoch.toString();
      case ParamType.DateTimeRange:
        data = dateTimeRangeToString(param as DateTimeRange);
      case ParamType.LatLng:
        data = (param as LatLng).serialize();
      case ParamType.Color:
        data = (param as Color).toCssString();
      case ParamType.FFPlace:
        data = placeToString(param as FFPlace);
      case ParamType.FFUploadedFile:
        data = uploadedFileToString(param as FFUploadedFile);
      case ParamType.JSON:
        data = json.encode(param);

      case ParamType.DataStruct:
        data = param is BaseStruct ? param.serialize() : null;

      case ParamType.SupabaseRow:
        return json.encode((param as SupabaseDataRow).data);

      default:
        data = null;
    }
    return data;
  } catch (e) {
    print('Error serializing parameter: $e');
    return null;
  }
}

/// END SERIALIZATION HELPERS

/// DESERIALIZATION HELPERS

DateTimeRange? dateTimeRangeFromString(String dateTimeRangeStr) {
  final pieces = dateTimeRangeStr.split('|');
  if (pieces.length != 2) {
    return null;
  }
  return DateTimeRange(
    start: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.first)),
    end: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.last)),
  );
}

LatLng? latLngFromString(String? latLngStr) {
  final pieces = latLngStr?.split(',');
  if (pieces == null || pieces.length != 2) {
    return null;
  }
  return LatLng(
    double.parse(pieces.first.trim()),
    double.parse(pieces.last.trim()),
  );
}

FFPlace placeFromString(String placeStr) {
  final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
  final data = {
    'latLng': serializedData.containsKey('latLng')
        ? latLngFromString(serializedData['latLng'] as String)
        : const LatLng(0.0, 0.0),
    'name': serializedData['name'] ?? '',
    'address': serializedData['address'] ?? '',
    'city': serializedData['city'] ?? '',
    'state': serializedData['state'] ?? '',
    'country': serializedData['country'] ?? '',
    'zipCode': serializedData['zipCode'] ?? '',
  };
  return FFPlace(
    latLng: data['latLng'] as LatLng,
    name: data['name'] as String,
    address: data['address'] as String,
    city: data['city'] as String,
    state: data['state'] as String,
    country: data['country'] as String,
    zipCode: data['zipCode'] as String,
  );
}

FFUploadedFile uploadedFileFromString(String uploadedFileStr) =>
    FFUploadedFile.deserialize(uploadedFileStr);

enum ParamType {
  int,
  double,
  String,
  bool,
  DateTime,
  DateTimeRange,
  LatLng,
  Color,
  FFPlace,
  FFUploadedFile,
  JSON,

  DataStruct,
  SupabaseRow,
}

dynamic deserializeParam<T>(
  String? param,
  ParamType paramType,
  bool isList, {
  StructBuilder<T>? structBuilder,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final paramValues = json.decode(param);
      if (paramValues is! Iterable || paramValues.isEmpty) {
        return null;
      }
      return paramValues
          .where((p) => p is String)
          .map((p) => p as String)
          .map((p) => deserializeParam<T>(
                p,
                paramType,
                false,
                structBuilder: structBuilder,
              ))
          .where((p) => p != null)
          .map((p) => p! as T)
          .toList();
    }
    switch (paramType) {
      case ParamType.int:
        return int.tryParse(param);
      case ParamType.double:
        return double.tryParse(param);
      case ParamType.String:
        return param;
      case ParamType.bool:
        return param == 'true';
      case ParamType.DateTime:
        final milliseconds = int.tryParse(param);
        return milliseconds != null
            ? DateTime.fromMillisecondsSinceEpoch(milliseconds)
            : null;
      case ParamType.DateTimeRange:
        return dateTimeRangeFromString(param);
      case ParamType.LatLng:
        return latLngFromString(param);
      case ParamType.Color:
        return fromCssColor(param);
      case ParamType.FFPlace:
        return placeFromString(param);
      case ParamType.FFUploadedFile:
        return uploadedFileFromString(param);
      case ParamType.JSON:
        return json.decode(param);

      case ParamType.SupabaseRow:
        final data = json.decode(param) as Map<String, dynamic>;
        switch (T) {
          case CurrencyDenominationsRow:
            return CurrencyDenominationsRow(data);
          case FiscalYearsRow:
            return FiscalYearsRow(data);
          case SpatialRefSysRow:
            return SpatialRefSysRow(data);
          case VShiftRequestWithUserRow:
            return VShiftRequestWithUserRow(data);
          case RecurringJournalsRow:
            return RecurringJournalsRow(data);
          case CashLocationsRow:
            return CashLocationsRow(data);
          case JournalAttachmentsRow:
            return JournalAttachmentsRow(data);
          case UserStoresRow:
            return UserStoresRow(data);
          case CompanyTypesRow:
            return CompanyTypesRow(data);
          case BookExchangeRatesRow:
            return BookExchangeRatesRow(data);
          case CurrencyTypesRow:
            return CurrencyTypesRow(data);
          case CompanyCurrencyRow:
            return CompanyCurrencyRow(data);
          case RolePermissionsRow:
            return RolePermissionsRow(data);
          case VSalaryIndividualRow:
            return VSalaryIndividualRow(data);
          case UserCompaniesRow:
            return UserCompaniesRow(data);
          case ShiftRequestsRow:
            return ShiftRequestsRow(data);
          case GeometryColumnsRow:
            return GeometryColumnsRow(data);
          case RecurringJournalLinesRow:
            return RecurringJournalLinesRow(data);
          case FeaturesRow:
            return FeaturesRow(data);
          case CompaniesRow:
            return CompaniesRow(data);
          case FixedAssetsRow:
            return FixedAssetsRow(data);
          case DepreciationProcessLogRow:
            return DepreciationProcessLogRow(data);
          case VUserSalaryRow:
            return VUserSalaryRow(data);
          case ViewCashierRealLatestTotalRow:
            return ViewCashierRealLatestTotalRow(data);
          case VCashLocationRow:
            return VCashLocationRow(data);
          case TransactionTemplatesRow:
            return TransactionTemplatesRow(data);
          case VaultAmountLineRow:
            return VaultAmountLineRow(data);
          case BankAmountRow:
            return BankAmountRow(data);
          case VJournalLinesCompleteRow:
            return VJournalLinesCompleteRow(data);
          case VUserSalaryWorkingRow:
            return VUserSalaryWorkingRow(data);
          case VDepreciationProcessStatusRow:
            return VDepreciationProcessStatusRow(data);
          case VUserRoleInfoRow:
            return VUserRoleInfoRow(data);
          case VMonthlyDepreciationSummaryRow:
            return VMonthlyDepreciationSummaryRow(data);
          case ProductsRow:
            return ProductsRow(data);
          case AccountsRow:
            return AccountsRow(data);
          case ViewRolesWithPermissionsRow:
            return ViewRolesWithPermissionsRow(data);
          case VIncomeStatementByStoreRow:
            return VIncomeStatementByStoreRow(data);
          case StoreShiftsRow:
            return StoreShiftsRow(data);
          case GeographyColumnsRow:
            return GeographyColumnsRow(data);
          case VDepreciationSummaryRow:
            return VDepreciationSummaryRow(data);
          case VStoreIncomeSummaryRow:
            return VStoreIncomeSummaryRow(data);
          case VCronJobStatusRow:
            return VCronJobStatusRow(data);
          case InventoryTransactionsRow:
            return InventoryTransactionsRow(data);
          case CashLocationsWithTotalAmountRow:
            return CashLocationsWithTotalAmountRow(data);
          case VShiftRequestWithRealtimeProblemRow:
            return VShiftRequestWithRealtimeProblemRow(data);
          case VBalanceSheetByStoreRow:
            return VBalanceSheetByStoreRow(data);
          case UserRolesRow:
            return UserRolesRow(data);
          case VStoreBalanceSummaryRow:
            return VStoreBalanceSummaryRow(data);
          case JournalLinesRow:
            return JournalLinesRow(data);
          case CounterpartiesRow:
            return CounterpartiesRow(data);
          case VUserStoresRow:
            return VUserStoresRow(data);
          case DebtsReceivableRow:
            return DebtsReceivableRow(data);
          case AssetImpairmentsRow:
            return AssetImpairmentsRow(data);
          case UserSalariesRow:
            return UserSalariesRow(data);
          case AccountMappingsRow:
            return AccountMappingsRow(data);
          case VStoreShiftsRow:
            return VStoreShiftsRow(data);
          case ShiftEditLogsRow:
            return ShiftEditLogsRow(data);
          case CashierAmountLinesRow:
            return CashierAmountLinesRow(data);
          case CashControlRow:
            return CashControlRow(data);
          case FiscalPeriodsRow:
            return FiscalPeriodsRow(data);
          case UsersRow:
            return UsersRow(data);
          case DebtPaymentsRow:
            return DebtPaymentsRow(data);
          case ViewCompanyCurrencyRow:
            return ViewCompanyCurrencyRow(data);
          case RolesRow:
            return RolesRow(data);
          case VShiftRequestRow:
            return VShiftRequestRow(data);
          case DepreciationMethodsRow:
            return DepreciationMethodsRow(data);
          case StoresRow:
            return StoresRow(data);
          case VBankAmountRow:
            return VBankAmountRow(data);
          case JournalEntriesRow:
            return JournalEntriesRow(data);
          case CategoriesRow:
            return CategoriesRow(data);
          case VAccountMappingsWithLinkedCompanyRow:
            return VAccountMappingsWithLinkedCompanyRow(data);
          default:
            return null;
        }

      case ParamType.DataStruct:
        final data = json.decode(param) as Map<String, dynamic>? ?? {};
        return structBuilder != null ? structBuilder(data) : null;

      default:
        return null;
    }
  } catch (e) {
    print('Error deserializing parameter: $e');
    return null;
  }
}
