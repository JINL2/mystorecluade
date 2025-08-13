// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FixAssetStruct extends BaseStruct {
  FixAssetStruct({
    String? assetName,
    String? acquisitionDate,
    int? usefulLifeYears,
    int? salvageValue,
    String? fixAssetName,
  })  : _assetName = assetName,
        _acquisitionDate = acquisitionDate,
        _usefulLifeYears = usefulLifeYears,
        _salvageValue = salvageValue,
        _fixAssetName = fixAssetName;

  // "asset_name" field.
  String? _assetName;
  String get assetName => _assetName ?? '';
  set assetName(String? val) => _assetName = val;

  bool hasAssetName() => _assetName != null;

  // "acquisition_date" field.
  String? _acquisitionDate;
  String get acquisitionDate => _acquisitionDate ?? '';
  set acquisitionDate(String? val) => _acquisitionDate = val;

  bool hasAcquisitionDate() => _acquisitionDate != null;

  // "useful_life_years" field.
  int? _usefulLifeYears;
  int get usefulLifeYears => _usefulLifeYears ?? 0;
  set usefulLifeYears(int? val) => _usefulLifeYears = val;

  void incrementUsefulLifeYears(int amount) =>
      usefulLifeYears = usefulLifeYears + amount;

  bool hasUsefulLifeYears() => _usefulLifeYears != null;

  // "salvage_value" field.
  int? _salvageValue;
  int get salvageValue => _salvageValue ?? 0;
  set salvageValue(int? val) => _salvageValue = val;

  void incrementSalvageValue(int amount) =>
      salvageValue = salvageValue + amount;

  bool hasSalvageValue() => _salvageValue != null;

  // "fix_asset_name" field.
  String? _fixAssetName;
  String get fixAssetName => _fixAssetName ?? '';
  set fixAssetName(String? val) => _fixAssetName = val;

  bool hasFixAssetName() => _fixAssetName != null;

  static FixAssetStruct fromMap(Map<String, dynamic> data) => FixAssetStruct(
        assetName: data['asset_name'] as String?,
        acquisitionDate: data['acquisition_date'] as String?,
        usefulLifeYears: castToType<int>(data['useful_life_years']),
        salvageValue: castToType<int>(data['salvage_value']),
        fixAssetName: data['fix_asset_name'] as String?,
      );

  static FixAssetStruct? maybeFromMap(dynamic data) =>
      data is Map ? FixAssetStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'asset_name': _assetName,
        'acquisition_date': _acquisitionDate,
        'useful_life_years': _usefulLifeYears,
        'salvage_value': _salvageValue,
        'fix_asset_name': _fixAssetName,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'asset_name': serializeParam(
          _assetName,
          ParamType.String,
        ),
        'acquisition_date': serializeParam(
          _acquisitionDate,
          ParamType.String,
        ),
        'useful_life_years': serializeParam(
          _usefulLifeYears,
          ParamType.int,
        ),
        'salvage_value': serializeParam(
          _salvageValue,
          ParamType.int,
        ),
        'fix_asset_name': serializeParam(
          _fixAssetName,
          ParamType.String,
        ),
      }.withoutNulls;

  static FixAssetStruct fromSerializableMap(Map<String, dynamic> data) =>
      FixAssetStruct(
        assetName: deserializeParam(
          data['asset_name'],
          ParamType.String,
          false,
        ),
        acquisitionDate: deserializeParam(
          data['acquisition_date'],
          ParamType.String,
          false,
        ),
        usefulLifeYears: deserializeParam(
          data['useful_life_years'],
          ParamType.int,
          false,
        ),
        salvageValue: deserializeParam(
          data['salvage_value'],
          ParamType.int,
          false,
        ),
        fixAssetName: deserializeParam(
          data['fix_asset_name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'FixAssetStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FixAssetStruct &&
        assetName == other.assetName &&
        acquisitionDate == other.acquisitionDate &&
        usefulLifeYears == other.usefulLifeYears &&
        salvageValue == other.salvageValue &&
        fixAssetName == other.fixAssetName;
  }

  @override
  int get hashCode => const ListEquality().hash([
        assetName,
        acquisitionDate,
        usefulLifeYears,
        salvageValue,
        fixAssetName
      ]);
}

FixAssetStruct createFixAssetStruct({
  String? assetName,
  String? acquisitionDate,
  int? usefulLifeYears,
  int? salvageValue,
  String? fixAssetName,
}) =>
    FixAssetStruct(
      assetName: assetName,
      acquisitionDate: acquisitionDate,
      usefulLifeYears: usefulLifeYears,
      salvageValue: salvageValue,
      fixAssetName: fixAssetName,
    );
