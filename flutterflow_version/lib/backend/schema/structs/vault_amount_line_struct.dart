// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VaultAmountLineStruct extends BaseStruct {
  VaultAmountLineStruct({
    String? denominationId,
    int? quantity,
  })  : _denominationId = denominationId,
        _quantity = quantity;

  // "denomination_id" field.
  String? _denominationId;
  String get denominationId => _denominationId ?? '';
  set denominationId(String? val) => _denominationId = val;

  bool hasDenominationId() => _denominationId != null;

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  set quantity(int? val) => _quantity = val;

  void incrementQuantity(int amount) => quantity = quantity + amount;

  bool hasQuantity() => _quantity != null;

  static VaultAmountLineStruct fromMap(Map<String, dynamic> data) =>
      VaultAmountLineStruct(
        denominationId: data['denomination_id'] as String?,
        quantity: castToType<int>(data['quantity']),
      );

  static VaultAmountLineStruct? maybeFromMap(dynamic data) => data is Map
      ? VaultAmountLineStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'denomination_id': _denominationId,
        'quantity': _quantity,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'denomination_id': serializeParam(
          _denominationId,
          ParamType.String,
        ),
        'quantity': serializeParam(
          _quantity,
          ParamType.int,
        ),
      }.withoutNulls;

  static VaultAmountLineStruct fromSerializableMap(Map<String, dynamic> data) =>
      VaultAmountLineStruct(
        denominationId: deserializeParam(
          data['denomination_id'],
          ParamType.String,
          false,
        ),
        quantity: deserializeParam(
          data['quantity'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'VaultAmountLineStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VaultAmountLineStruct &&
        denominationId == other.denominationId &&
        quantity == other.quantity;
  }

  @override
  int get hashCode => const ListEquality().hash([denominationId, quantity]);
}

VaultAmountLineStruct createVaultAmountLineStruct({
  String? denominationId,
  int? quantity,
}) =>
    VaultAmountLineStruct(
      denominationId: denominationId,
      quantity: quantity,
    );
