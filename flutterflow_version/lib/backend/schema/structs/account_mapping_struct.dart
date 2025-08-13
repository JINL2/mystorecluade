// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AccountMappingStruct extends BaseStruct {
  AccountMappingStruct({
    String? myCompanyId,
    String? myAccountId,
    String? counterpartyId,
    String? linkedAccountId,
    String? direction,
  })  : _myCompanyId = myCompanyId,
        _myAccountId = myAccountId,
        _counterpartyId = counterpartyId,
        _linkedAccountId = linkedAccountId,
        _direction = direction;

  // "my_company_id" field.
  String? _myCompanyId;
  String get myCompanyId => _myCompanyId ?? '';
  set myCompanyId(String? val) => _myCompanyId = val;

  bool hasMyCompanyId() => _myCompanyId != null;

  // "my_account_id" field.
  String? _myAccountId;
  String get myAccountId => _myAccountId ?? '';
  set myAccountId(String? val) => _myAccountId = val;

  bool hasMyAccountId() => _myAccountId != null;

  // "counterparty_id" field.
  String? _counterpartyId;
  String get counterpartyId => _counterpartyId ?? '';
  set counterpartyId(String? val) => _counterpartyId = val;

  bool hasCounterpartyId() => _counterpartyId != null;

  // "linked_account_id" field.
  String? _linkedAccountId;
  String get linkedAccountId => _linkedAccountId ?? '';
  set linkedAccountId(String? val) => _linkedAccountId = val;

  bool hasLinkedAccountId() => _linkedAccountId != null;

  // "direction" field.
  String? _direction;
  String get direction => _direction ?? '';
  set direction(String? val) => _direction = val;

  bool hasDirection() => _direction != null;

  static AccountMappingStruct fromMap(Map<String, dynamic> data) =>
      AccountMappingStruct(
        myCompanyId: data['my_company_id'] as String?,
        myAccountId: data['my_account_id'] as String?,
        counterpartyId: data['counterparty_id'] as String?,
        linkedAccountId: data['linked_account_id'] as String?,
        direction: data['direction'] as String?,
      );

  static AccountMappingStruct? maybeFromMap(dynamic data) => data is Map
      ? AccountMappingStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'my_company_id': _myCompanyId,
        'my_account_id': _myAccountId,
        'counterparty_id': _counterpartyId,
        'linked_account_id': _linkedAccountId,
        'direction': _direction,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'my_company_id': serializeParam(
          _myCompanyId,
          ParamType.String,
        ),
        'my_account_id': serializeParam(
          _myAccountId,
          ParamType.String,
        ),
        'counterparty_id': serializeParam(
          _counterpartyId,
          ParamType.String,
        ),
        'linked_account_id': serializeParam(
          _linkedAccountId,
          ParamType.String,
        ),
        'direction': serializeParam(
          _direction,
          ParamType.String,
        ),
      }.withoutNulls;

  static AccountMappingStruct fromSerializableMap(Map<String, dynamic> data) =>
      AccountMappingStruct(
        myCompanyId: deserializeParam(
          data['my_company_id'],
          ParamType.String,
          false,
        ),
        myAccountId: deserializeParam(
          data['my_account_id'],
          ParamType.String,
          false,
        ),
        counterpartyId: deserializeParam(
          data['counterparty_id'],
          ParamType.String,
          false,
        ),
        linkedAccountId: deserializeParam(
          data['linked_account_id'],
          ParamType.String,
          false,
        ),
        direction: deserializeParam(
          data['direction'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AccountMappingStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AccountMappingStruct &&
        myCompanyId == other.myCompanyId &&
        myAccountId == other.myAccountId &&
        counterpartyId == other.counterpartyId &&
        linkedAccountId == other.linkedAccountId &&
        direction == other.direction;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [myCompanyId, myAccountId, counterpartyId, linkedAccountId, direction]);
}

AccountMappingStruct createAccountMappingStruct({
  String? myCompanyId,
  String? myAccountId,
  String? counterpartyId,
  String? linkedAccountId,
  String? direction,
}) =>
    AccountMappingStruct(
      myCompanyId: myCompanyId,
      myAccountId: myAccountId,
      counterpartyId: counterpartyId,
      linkedAccountId: linkedAccountId,
      direction: direction,
    );
