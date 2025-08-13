import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start accountMapping Group Code

class AccountMappingGroup {
  static String getBaseUrl({
    String? pMyCompanyId = '',
    String? pMyAccountId = '',
    String? pCounterpartyCompanyId = '',
    String? pLinkedAccountId = '',
    String? pDirection = '',
    String? pCreatedBy = '',
  }) =>
      'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Content-Type': 'application/json',
  };
  static InsertAccountMappingCall insertAccountMappingCall =
      InsertAccountMappingCall();
  static CheckAccountMapCall checkAccountMapCall = CheckAccountMapCall();
}

class InsertAccountMappingCall {
  Future<ApiCallResponse> call({
    String? pMyCompanyId = '',
    String? pMyAccountId = '',
    String? pCounterpartyCompanyId = '',
    String? pLinkedAccountId = '',
    String? pDirection = '',
    String? pCreatedBy = '',
  }) async {
    final baseUrl = AccountMappingGroup.getBaseUrl(
      pMyCompanyId: pMyCompanyId,
      pMyAccountId: pMyAccountId,
      pCounterpartyCompanyId: pCounterpartyCompanyId,
      pLinkedAccountId: pLinkedAccountId,
      pDirection: pDirection,
      pCreatedBy: pCreatedBy,
    );

    final ffApiRequestBody = '''
{
  "p_my_company_id": "${escapeStringForJson(pMyCompanyId)}",
  "p_my_account_id": "${escapeStringForJson(pMyAccountId)}",
  "p_counterparty_company_id": "${escapeStringForJson(pCounterpartyCompanyId)}",
  "p_linked_account_id": "${escapeStringForJson(pLinkedAccountId)}",
  "p_direction": "${escapeStringForJson(pDirection)}",
  "p_created_by": "${escapeStringForJson(pCreatedBy)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertAccountMapping',
      apiUrl: '${baseUrl}insert_account_mapping_with_company',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CheckAccountMapCall {
  Future<ApiCallResponse> call({
    String? pMyCompanyId = '',
    String? pMyAccountId = '',
    String? pCounterpartyCompanyId = '',
    String? pLinkedAccountId = '',
    String? pDirection = '',
    String? pCreatedBy = '',
  }) async {
    final baseUrl = AccountMappingGroup.getBaseUrl(
      pMyCompanyId: pMyCompanyId,
      pMyAccountId: pMyAccountId,
      pCounterpartyCompanyId: pCounterpartyCompanyId,
      pLinkedAccountId: pLinkedAccountId,
      pDirection: pDirection,
      pCreatedBy: pCreatedBy,
    );

    final ffApiRequestBody = '''
{
  "p_my_account_id": "${escapeStringForJson(pMyAccountId)}",
  "p_counterparty_id": "${escapeStringForJson(pCounterpartyCompanyId)}",
  "p_my_company_id": "${escapeStringForJson(pMyCompanyId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'checkAccountMap',
      apiUrl: '${baseUrl}check_account_mapping_exists',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic ismapped(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

/// End accountMapping Group Code

/// Start JournalEntry Group Code

class JournalEntryGroup {
  static String getBaseUrl({
    String? pCompanyId = '',
    String? pStoreId = '',
    String? pCreatedBy = '',
    String? pEntryDate = '',
    String? pDescription = '',
    double? pBaseAmount,
    dynamic pLinesJson,
    String? pJournalType = '',
    String? pApprovedBy = '',
  }) =>
      'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Content-Type': 'application/json',
  };
  static InsertDebtJounralCall insertDebtJounralCall = InsertDebtJounralCall();
  static InsertjournalwitheverythingCall insertjournalwitheverythingCall =
      InsertjournalwitheverythingCall();
  static InsertJournalCall insertJournalCall = InsertJournalCall();
}

class InsertDebtJounralCall {
  Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pStoreId = '',
    String? pCreatedBy = '',
    String? pEntryDate = '',
    String? pDescription = '',
    double? pBaseAmount,
    dynamic pLinesJson,
    String? pJournalType = '',
    String? pApprovedBy = '',
  }) async {
    final baseUrl = JournalEntryGroup.getBaseUrl(
      pCompanyId: pCompanyId,
      pStoreId: pStoreId,
      pCreatedBy: pCreatedBy,
      pEntryDate: pEntryDate,
      pDescription: pDescription,
      pBaseAmount: pBaseAmount,
      pLinesJson: pLinesJson,
      pJournalType: pJournalType,
      pApprovedBy: pApprovedBy,
    );

    final pLines = _serializeJson(pLinesJson, true);
    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",

  "p_store_id" : "${escapeStringForJson(pStoreId)}",

  "p_created_by" : "${escapeStringForJson(pCreatedBy)}",

  "p_entry_date" : "${escapeStringForJson(pEntryDate)}" ,

  "p_description" :  "${escapeStringForJson(pDescription)}",

 "p_base_amount" : ${pBaseAmount},

 "p_lines" : ${pLines}


}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertDebtJounral',
      apiUrl: '${baseUrl}insert_debt_with_journal',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InsertjournalwitheverythingCall {
  Future<ApiCallResponse> call({
    String? pIfCashLocationId = '',
    String? pCounterpartyId = '',
    String? pCompanyId = '',
    String? pStoreId = '',
    String? pCreatedBy = '',
    String? pEntryDate = '',
    String? pDescription = '',
    double? pBaseAmount,
    dynamic pLinesJson,
    String? pJournalType = '',
    String? pApprovedBy = '',
  }) async {
    final baseUrl = JournalEntryGroup.getBaseUrl(
      pCompanyId: pCompanyId,
      pStoreId: pStoreId,
      pCreatedBy: pCreatedBy,
      pEntryDate: pEntryDate,
      pDescription: pDescription,
      pBaseAmount: pBaseAmount,
      pLinesJson: pLinesJson,
      pJournalType: pJournalType,
      pApprovedBy: pApprovedBy,
    );

    final pLines = _serializeJson(pLinesJson, true);
    final ffApiRequestBody = '''
{
  "p_base_amount": ${pBaseAmount},
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_created_by": "${escapeStringForJson(pCreatedBy)}",
  "p_description": "${escapeStringForJson(pDescription)}",
  "p_entry_date": "${escapeStringForJson(pEntryDate)}",
  "p_lines": ${pLines},
  "p_counterparty_id" : "${escapeStringForJson(pCounterpartyId)}",
  "p_if_cash_location_id": "${escapeStringForJson(pIfCashLocationId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertjournalwitheverything',
      apiUrl: '${baseUrl}/insert_journal_with_everything',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InsertJournalCall {
  Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pStoreId = '',
    String? pCreatedBy = '',
    String? pEntryDate = '',
    String? pDescription = '',
    double? pBaseAmount,
    dynamic pLinesJson,
    String? pJournalType = '',
    String? pApprovedBy = '',
  }) async {
    final baseUrl = JournalEntryGroup.getBaseUrl(
      pCompanyId: pCompanyId,
      pStoreId: pStoreId,
      pCreatedBy: pCreatedBy,
      pEntryDate: pEntryDate,
      pDescription: pDescription,
      pBaseAmount: pBaseAmount,
      pLinesJson: pLinesJson,
      pJournalType: pJournalType,
      pApprovedBy: pApprovedBy,
    );

    final pLines = _serializeJson(pLinesJson, true);
    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",

  "p_store_id" : "${escapeStringForJson(pStoreId)}",

  "p_created_by" : "${escapeStringForJson(pCreatedBy)}",

  "p_entry_date" : "${escapeStringForJson(pEntryDate)}" ,

  "p_description" :  "${escapeStringForJson(pDescription)}",

 "p_base_amount" : ${pBaseAmount},

 "p_lines" : ${pLines}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertJournal',
      apiUrl: '${baseUrl}insert_journal_with_lines',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End JournalEntry Group Code

/// Start Roles Group Code

class RolesGroup {
  static String getBaseUrl() =>
      'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
  };
  static UpdateRoleCall updateRoleCall = UpdateRoleCall();
  static DeleteRoleCall deleteRoleCall = DeleteRoleCall();
  static CreateRoleCall createRoleCall = CreateRoleCall();
}

class UpdateRoleCall {
  Future<ApiCallResponse> call({
    String? pRoleId = '',
    String? pRoleName = '',
    String? pRoleType = '',
    dynamic pPermissionsJson,
    String? pCompanyId = '',
  }) async {
    final baseUrl = RolesGroup.getBaseUrl();

    final pPermissions = _serializeJson(pPermissionsJson);
    final ffApiRequestBody = '''
{
  "p_company_id" : "${escapeStringForJson(pCompanyId)}",
  "p_permissions" : ${pPermissions},
  "p_role_id": "${escapeStringForJson(pRoleId)}",
  "p_role_name": "${escapeStringForJson(pRoleName)}",
  "p_role_type" : "${escapeStringForJson(pRoleType)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Update Role',
      apiUrl: '${baseUrl}/update_role',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeleteRoleCall {
  Future<ApiCallResponse> call({
    String? pRoleId = '',
  }) async {
    final baseUrl = RolesGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_role_id": "${escapeStringForJson(pRoleId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Delete Role',
      apiUrl: '${baseUrl}/delete_role',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateRoleCall {
  Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pRoleName = '',
    String? pRoleType = '',
    dynamic pPermissionsJson,
  }) async {
    final baseUrl = RolesGroup.getBaseUrl();

    final pPermissions = _serializeJson(pPermissionsJson);
    final ffApiRequestBody = '''
{"p_company_id" : "${escapeStringForJson(pCompanyId)}",
 "p_permissions" :  ${pPermissions},
 "p_role_name" : "${escapeStringForJson(pRoleName)}",
 "p_role_type" : "${escapeStringForJson(pRoleType)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Create Role',
      apiUrl: '${baseUrl}/create_role',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Roles Group Code

/// Start deleteData Group Code

class DeleteDataGroup {
  static String getBaseUrl() =>
      'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
  };
  static DeleteowneruserCall deleteowneruserCall = DeleteowneruserCall();
  static DeletestoreCall deletestoreCall = DeletestoreCall();
  static DeletecompanyCall deletecompanyCall = DeletecompanyCall();
  static FireemployeeCall fireemployeeCall = FireemployeeCall();
  static LeavecompanyCall leavecompanyCall = LeavecompanyCall();
  static DeleteemployeeuserCall deleteemployeeuserCall =
      DeleteemployeeuserCall();
}

class DeleteowneruserCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
  }) async {
    final baseUrl = DeleteDataGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'deleteowneruser',
      apiUrl: '${baseUrl}/delete_owner_user',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeletestoreCall {
  Future<ApiCallResponse> call({
    String? pStoreId = '',
  }) async {
    final baseUrl = DeleteDataGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_store_id": "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'deletestore',
      apiUrl: '${baseUrl}/delete_store',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeletecompanyCall {
  Future<ApiCallResponse> call({
    String? pCompanyId = '',
  }) async {
    final baseUrl = DeleteDataGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_company_id" :  "${escapeStringForJson(pCompanyId)}"

}''';
    return ApiManager.instance.makeApiCall(
      callName: 'deletecompany',
      apiUrl: '${baseUrl}/delete_company',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class FireemployeeCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = DeleteDataGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_company_id" :  "${escapeStringForJson(pCompanyId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'fireemployee',
      apiUrl: '${baseUrl}/fire_employee',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class LeavecompanyCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = DeleteDataGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",


  "p_company_id" : "${escapeStringForJson(pCompanyId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'leavecompany',
      apiUrl: '${baseUrl}/leave_company',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeleteemployeeuserCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
  }) async {
    final baseUrl = DeleteDataGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'deleteemployeeuser',
      apiUrl: '${baseUrl}/delete_employee_user',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End deleteData Group Code

/// Start debtControl Group Code

class DebtControlGroup {
  static String getBaseUrl() =>
      'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Content-Type': 'application/json',
  };
  static GetcounterpartymatrixCall getcounterpartymatrixCall =
      GetcounterpartymatrixCall();
  static DebtOverviewCall debtOverviewCall = DebtOverviewCall();
  static GetcounterpartiesfortransactionCall
      getcounterpartiesfortransactionCall =
      GetcounterpartiesfortransactionCall();
  static GetsinglecounterpartyCall getsinglecounterpartyCall =
      GetsinglecounterpartyCall();
  static GetdebttransactionsCall getdebttransactionsCall =
      GetdebttransactionsCall();
}

class GetcounterpartymatrixCall {
  Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pStoreId = '',
    int? pPageSize,
  }) async {
    final baseUrl = DebtControlGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_page_size": ${pPageSize}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getcounterpartymatrix',
      apiUrl: '${baseUrl}get_counterparty_matrix_edit',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DebtOverviewCall {
  Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pStoreId = '',
  }) async {
    final baseUrl = DebtControlGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",


  "p_store_id" : "${escapeStringForJson(pStoreId)}"

}''';
    return ApiManager.instance.makeApiCall(
      callName: 'debtOverview',
      apiUrl: '${baseUrl}get_debt_summary_all_modes',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetcounterpartiesfortransactionCall {
  Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pSearchTerm = '',
  }) async {
    final baseUrl = DebtControlGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",

  "p_search_term" :  "${escapeStringForJson(pSearchTerm)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getcounterpartiesfortransaction',
      apiUrl: '${baseUrl}get_counterparties_for_transaction',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetsinglecounterpartyCall {
  Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pCounterpartyId = '',
    String? pStoreId = '',
  }) async {
    final baseUrl = DebtControlGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",

  "p_counterparty_id" : "${escapeStringForJson(pCounterpartyId)}",

  "p_store_id" : "${escapeStringForJson(pStoreId)}"
}

''';
    return ApiManager.instance.makeApiCall(
      callName: 'getsinglecounterparty',
      apiUrl: '${baseUrl}get_single_counterparty',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetdebttransactionsCall {
  Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pCounterpartyId = '',
    String? pStartDate = '',
    String? pEndDate = '',
    String? pTransactionType = '',
    String? pStoreId = '',
    int? pLimit,
    int? pOffset,
  }) async {
    final baseUrl = DebtControlGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_counterparty_id": "${escapeStringForJson(pCounterpartyId)}",
  "p_start_date": "${escapeStringForJson(pStartDate)}",
  "p_end_date": "${escapeStringForJson(pEndDate)}",
  "p_transaction_type": "${escapeStringForJson(pTransactionType)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_limit": ${pLimit},
  "p_offset": ${pOffset}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getdebttransactions',
      apiUrl: '${baseUrl}get_debt_transactions_v3',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End debtControl Group Code

/// Start cashLocation Group Code

class CashLocationGroup {
  static String getBaseUrl({
    String? pCompanyId = '',
    String? pLocationName = '',
    String? pLocationType = '',
    String? pStoreId = '',
    String? pLocationInfo = '',
    String? pCurrencyCode = '',
    String? pBankAccount = '',
    String? pBankName = '',
  }) =>
      'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Content-Type': 'application/json',
  };
  static CashlocationcreateCall cashlocationcreateCall =
      CashlocationcreateCall();
  static CashlocationeditCall cashlocationeditCall = CashlocationeditCall();
  static GetcashlocationsnestedCall getcashlocationsnestedCall =
      GetcashlocationsnestedCall();
}

class CashlocationcreateCall {
  Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pLocationName = '',
    String? pLocationType = '',
    String? pStoreId = '',
    String? pLocationInfo = '',
    String? pCurrencyCode = '',
    String? pBankAccount = '',
    String? pBankName = '',
  }) async {
    final baseUrl = CashLocationGroup.getBaseUrl(
      pCompanyId: pCompanyId,
      pLocationName: pLocationName,
      pLocationType: pLocationType,
      pStoreId: pStoreId,
      pLocationInfo: pLocationInfo,
      pCurrencyCode: pCurrencyCode,
      pBankAccount: pBankAccount,
      pBankName: pBankName,
    );

    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_location_name": "${escapeStringForJson(pLocationName)}",
  "p_location_type": "${escapeStringForJson(pLocationType)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_location_info": "${escapeStringForJson(pLocationInfo)}",
  "p_currency_code": "${escapeStringForJson(pCurrencyCode)}",
  "p_bank_account": "${escapeStringForJson(pBankAccount)}",
  "p_bank_name": "${escapeStringForJson(pBankName)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'cashlocationcreate',
      apiUrl: '${baseUrl}cash_location_create',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CashlocationeditCall {
  Future<ApiCallResponse> call({
    String? pCashLocationId = '',
    String? pCompanyId = '',
    String? pLocationName = '',
    String? pLocationType = '',
    String? pStoreId = '',
    String? pLocationInfo = '',
    String? pCurrencyCode = '',
    String? pBankAccount = '',
    String? pBankName = '',
  }) async {
    final baseUrl = CashLocationGroup.getBaseUrl(
      pCompanyId: pCompanyId,
      pLocationName: pLocationName,
      pLocationType: pLocationType,
      pStoreId: pStoreId,
      pLocationInfo: pLocationInfo,
      pCurrencyCode: pCurrencyCode,
      pBankAccount: pBankAccount,
      pBankName: pBankName,
    );

    final ffApiRequestBody = '''
{
  "p_cash_location_id" : "${escapeStringForJson(pCashLocationId)}",
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_location_name": "${escapeStringForJson(pLocationName)}",
  "p_location_type": "${escapeStringForJson(pLocationType)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_location_info": "${escapeStringForJson(pLocationInfo)}",
  "p_currency_code": "${escapeStringForJson(pCurrencyCode)}",
  "p_bank_account": "${escapeStringForJson(pBankAccount)}",
  "p_bank_name": "${escapeStringForJson(pBankName)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'cashlocationedit',
      apiUrl: '${baseUrl}cash_location_edit',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetcashlocationsnestedCall {
  Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pLocationName = '',
    String? pLocationType = '',
    String? pStoreId = '',
    String? pLocationInfo = '',
    String? pCurrencyCode = '',
    String? pBankAccount = '',
    String? pBankName = '',
  }) async {
    final baseUrl = CashLocationGroup.getBaseUrl(
      pCompanyId: pCompanyId,
      pLocationName: pLocationName,
      pLocationType: pLocationType,
      pStoreId: pStoreId,
      pLocationInfo: pLocationInfo,
      pCurrencyCode: pCurrencyCode,
      pBankAccount: pBankAccount,
      pBankName: pBankName,
    );

    final ffApiRequestBody = '''
{
"p_company_id" :"${escapeStringForJson(pCompanyId)}",
"p_store_id" : "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getcashlocationsnested',
      apiUrl: '${baseUrl}get_cash_locations_nested',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End cashLocation Group Code

/// Start managerShift Group Code

class ManagerShiftGroup {
  static String getBaseUrl({
    String? pStartDate = '',
    String? pEndDate = '',
    String? pStoreId = '',
    String? pDate = '',
    String? pShiftRequestId = '',
    String? pCompanyId = '',
  }) =>
      'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Content-Type': 'application/json',
  };
  static ManagershiftgetoverviewCall managershiftgetoverviewCall =
      ManagershiftgetoverviewCall();
  static ManagershiftgetcardsCall managershiftgetcardsCall =
      ManagershiftgetcardsCall();
  static ManagershiftgetdetailCall managershiftgetdetailCall =
      ManagershiftgetdetailCall();
  static ManagershiftinputcardCall managershiftinputcardCall =
      ManagershiftinputcardCall();
  static ManagershiftdeletetagCall managershiftdeletetagCall =
      ManagershiftdeletetagCall();
  static ManagershiftgetscheduleCall managershiftgetscheduleCall =
      ManagershiftgetscheduleCall();
  static ManagershiftinsertscheduleCall managershiftinsertscheduleCall =
      ManagershiftinsertscheduleCall();
  static ManagershiftnotapproveCall managershiftnotapproveCall =
      ManagershiftnotapproveCall();
  static InsertshiftrequestvCall insertshiftrequestvCall =
      InsertshiftrequestvCall();
}

class ManagershiftgetoverviewCall {
  Future<ApiCallResponse> call({
    String? pStartDate = '',
    String? pEndDate = '',
    String? pStoreId = '',
    String? pDate = '',
    String? pShiftRequestId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = ManagerShiftGroup.getBaseUrl(
      pStartDate: pStartDate,
      pEndDate: pEndDate,
      pStoreId: pStoreId,
      pDate: pDate,
      pShiftRequestId: pShiftRequestId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_company_id" : "${escapeStringForJson(pCompanyId)}",
  "p_start_date": "${escapeStringForJson(pStartDate)}",
  "p_end_date": "${escapeStringForJson(pEndDate)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'managershiftgetoverview',
      apiUrl: '${baseUrl}manager_shift_get_overview',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ManagershiftgetcardsCall {
  Future<ApiCallResponse> call({
    String? pStartDate = '',
    String? pEndDate = '',
    String? pStoreId = '',
    String? pDate = '',
    String? pShiftRequestId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = ManagerShiftGroup.getBaseUrl(
      pStartDate: pStartDate,
      pEndDate: pEndDate,
      pStoreId: pStoreId,
      pDate: pDate,
      pShiftRequestId: pShiftRequestId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_start_date": "${escapeStringForJson(pStartDate)}",
  "p_end_date": "${escapeStringForJson(pEndDate)}",
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'managershiftgetcards',
      apiUrl: '${baseUrl}manager_shift_get_cards',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ManagershiftgetdetailCall {
  Future<ApiCallResponse> call({
    String? pStartDate = '',
    String? pEndDate = '',
    String? pStoreId = '',
    String? pDate = '',
    String? pShiftRequestId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = ManagerShiftGroup.getBaseUrl(
      pStartDate: pStartDate,
      pEndDate: pEndDate,
      pStoreId: pStoreId,
      pDate: pDate,
      pShiftRequestId: pShiftRequestId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_shift_request_id": "${escapeStringForJson(pShiftRequestId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'managershiftgetdetail',
      apiUrl: '${baseUrl}manager_shift_get_detail',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ManagershiftinputcardCall {
  Future<ApiCallResponse> call({
    String? pManagerId = '',
    String? pConfirmStartTime = '',
    String? pConfirmEndTime = '',
    String? pNewTagContent = '',
    String? pNewTagType = '',
    bool? pIsLate,
    bool? pIsProblemSolved,
    String? pStartDate = '',
    String? pEndDate = '',
    String? pStoreId = '',
    String? pDate = '',
    String? pShiftRequestId = '',
    String? pCompanyId = '',
  }) async {
    pIsLate ??= null;
    pIsProblemSolved ??= null;
    final baseUrl = ManagerShiftGroup.getBaseUrl(
      pStartDate: pStartDate,
      pEndDate: pEndDate,
      pStoreId: pStoreId,
      pDate: pDate,
      pShiftRequestId: pShiftRequestId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_shift_request_id": "${escapeStringForJson(pShiftRequestId)}",
  "p_manager_id": "${escapeStringForJson(pManagerId)}",
  "p_confirm_start_time": "${escapeStringForJson(pConfirmStartTime)}",
  "p_confirm_end_time": "${escapeStringForJson(pConfirmEndTime)}",
  "p_new_tag_content": "${escapeStringForJson(pNewTagContent)}",
  "p_new_tag_type": "${escapeStringForJson(pNewTagType)}",
  "p_is_late": ${pIsLate},
  "p_is_problem_solved": ${pIsProblemSolved}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'managershiftinputcard',
      apiUrl: '${baseUrl}manager_shift_input_card',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ManagershiftdeletetagCall {
  Future<ApiCallResponse> call({
    String? pTagId = '',
    String? pUserId = '',
    String? pStartDate = '',
    String? pEndDate = '',
    String? pStoreId = '',
    String? pDate = '',
    String? pShiftRequestId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = ManagerShiftGroup.getBaseUrl(
      pStartDate: pStartDate,
      pEndDate: pEndDate,
      pStoreId: pStoreId,
      pDate: pDate,
      pShiftRequestId: pShiftRequestId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_tag_id": "${escapeStringForJson(pTagId)}",
  "p_user_id": "${escapeStringForJson(pUserId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'managershiftdeletetag',
      apiUrl: '${baseUrl}manager_shift_delete_tag',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ManagershiftgetscheduleCall {
  Future<ApiCallResponse> call({
    String? pStartDate = '',
    String? pEndDate = '',
    String? pStoreId = '',
    String? pDate = '',
    String? pShiftRequestId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = ManagerShiftGroup.getBaseUrl(
      pStartDate: pStartDate,
      pEndDate: pEndDate,
      pStoreId: pStoreId,
      pDate: pDate,
      pShiftRequestId: pShiftRequestId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_store_id": "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'managershiftgetschedule',
      apiUrl: '${baseUrl}manager_shift_get_schedule',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ManagershiftinsertscheduleCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pShiftId = '',
    String? pRequestDate = '',
    String? pApprovedBy = '',
    String? pStartDate = '',
    String? pEndDate = '',
    String? pStoreId = '',
    String? pDate = '',
    String? pShiftRequestId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = ManagerShiftGroup.getBaseUrl(
      pStartDate: pStartDate,
      pEndDate: pEndDate,
      pStoreId: pStoreId,
      pDate: pDate,
      pShiftRequestId: pShiftRequestId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_shift_id": "${escapeStringForJson(pShiftId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_request_date": "${escapeStringForJson(pRequestDate)}",
  "p_approved_by": "${escapeStringForJson(pApprovedBy)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'managershiftinsertschedule',
      apiUrl: '${baseUrl}manager_shift_insert_schedule',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ManagershiftnotapproveCall {
  Future<ApiCallResponse> call({
    String? pRemovedBy = '',
    String? pRemovalReason = '',
    String? pStartDate = '',
    String? pEndDate = '',
    String? pStoreId = '',
    String? pDate = '',
    String? pShiftRequestId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = ManagerShiftGroup.getBaseUrl(
      pStartDate: pStartDate,
      pEndDate: pEndDate,
      pStoreId: pStoreId,
      pDate: pDate,
      pShiftRequestId: pShiftRequestId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_shift_request_id": "${escapeStringForJson(pShiftRequestId)}",
  "p_removed_by": "${escapeStringForJson(pRemovedBy)}",
  "p_removal_reason": "${escapeStringForJson(pRemovalReason)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'managershiftnotapprove',
      apiUrl: '${baseUrl}manager_shift_notapprove',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InsertshiftrequestvCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pShiftId = '',
    String? pRequestDate = '',
    String? pStartDate = '',
    String? pEndDate = '',
    String? pStoreId = '',
    String? pDate = '',
    String? pShiftRequestId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = ManagerShiftGroup.getBaseUrl(
      pStartDate: pStartDate,
      pEndDate: pEndDate,
      pStoreId: pStoreId,
      pDate: pDate,
      pShiftRequestId: pShiftRequestId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_shift_id": "${escapeStringForJson(pShiftId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_request_date": "${escapeStringForJson(pRequestDate)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertshiftrequestv',
      apiUrl: '${baseUrl}insert_shift_request_v2',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End managerShift Group Code

/// Start userShift Group Code

class UserShiftGroup {
  static String getBaseUrl({
    String? pUserId = '',
    String? pRequestDate = '',
    String? pStoreId = '',
    String? pCompanyId = '',
  }) =>
      'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
    'Content-Type': 'application/json',
  };
  static UsershiftmonthlysummaryCall usershiftmonthlysummaryCall =
      UsershiftmonthlysummaryCall();
  static UsershiftoverviewCall usershiftoverviewCall = UsershiftoverviewCall();
  static UsershiftcardsCall usershiftcardsCall = UsershiftcardsCall();
  static UpdateshiftrequestsvCall updateshiftrequestsvCall =
      UpdateshiftrequestsvCall();
}

class UsershiftmonthlysummaryCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pRequestDate = '',
    String? pStoreId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = UserShiftGroup.getBaseUrl(
      pUserId: pUserId,
      pRequestDate: pRequestDate,
      pStoreId: pStoreId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_request_date": "${escapeStringForJson(pRequestDate)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'usershiftmonthlysummary',
      apiUrl: '${baseUrl}user_shift_monthly_summary',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UsershiftoverviewCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pRequestDate = '',
    String? pStoreId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = UserShiftGroup.getBaseUrl(
      pUserId: pUserId,
      pRequestDate: pRequestDate,
      pStoreId: pStoreId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_request_date": "${escapeStringForJson(pRequestDate)}",
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'usershiftoverview',
      apiUrl: '${baseUrl}user_shift_overview',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UsershiftcardsCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pRequestDate = '',
    String? pStoreId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = UserShiftGroup.getBaseUrl(
      pUserId: pUserId,
      pRequestDate: pRequestDate,
      pStoreId: pStoreId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_request_date": "${escapeStringForJson(pRequestDate)}",
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'usershiftcards',
      apiUrl: '${baseUrl}user_shift_cards',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateshiftrequestsvCall {
  Future<ApiCallResponse> call({
    String? pTime = '',
    double? pLat,
    double? pLng,
    String? pUserId = '',
    String? pRequestDate = '',
    String? pStoreId = '',
    String? pCompanyId = '',
  }) async {
    final baseUrl = UserShiftGroup.getBaseUrl(
      pUserId: pUserId,
      pRequestDate: pRequestDate,
      pStoreId: pStoreId,
      pCompanyId: pCompanyId,
    );

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_request_date": "${escapeStringForJson(pRequestDate)}",
  "p_time": "${escapeStringForJson(pTime)}",
  "p_lat": ${pLat},
  "p_lng": ${pLng}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateshiftrequestsv',
      apiUrl: '${baseUrl}update_shift_requests_v3',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End userShift Group Code

/// Start contentsCreation Group Code

class ContentsCreationGroup {
  static String getBaseUrl() =>
      'https://yenfccoefczqxckbizqa.supabase.co/rest/v1/rpc/';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllbmZjY29lZmN6cXhja2JpenFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU5NDkyNzksImV4cCI6MjA2MTUyNTI3OX0.U1iQUOaNPSrEHf1w_ePqgYzJiRO6Bi48E2Np2hY0nCQ',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllbmZjY29lZmN6cXhja2JpenFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU5NDkyNzksImV4cCI6MjA2MTUyNTI3OX0.U1iQUOaNPSrEHf1w_ePqgYzJiRO6Bi48E2Np2hY0nCQ',
    'Content-Type': 'application/json',
  };
  static GetuserdashboarddataCall getuserdashboarddataCall =
      GetuserdashboarddataCall();
}

class GetuserdashboarddataCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pCompanyId = '',
    String? pStoreId = '',
  }) async {
    final baseUrl = ContentsCreationGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getuserdashboarddata',
      apiUrl: '${baseUrl}get_user_dashboard_data',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllbmZjY29lZmN6cXhja2JpenFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU5NDkyNzksImV4cCI6MjA2MTUyNTI3OX0.U1iQUOaNPSrEHf1w_ePqgYzJiRO6Bi48E2Np2hY0nCQ',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllbmZjY29lZmN6cXhja2JpenFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU5NDkyNzksImV4cCI6MjA2MTUyNTI3OX0.U1iQUOaNPSrEHf1w_ePqgYzJiRO6Bi48E2Np2hY0nCQ',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End contentsCreation Group Code

class GetjournalLineCall {
  static Future<ApiCallResponse> call({
    String? storeId = '',
    String? companyId = '',
    String? rangeHeader = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getjournalLine',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/journal_entries?select=*&store_id=eq.${storeId}&company_id=eq.${companyId}&order=created_at.desc',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Range': '${rangeHeader}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? journalId(dynamic response) => (getJsonField(
        response,
        r'''$[:].journal_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? amount(dynamic response) => (getJsonField(
        response,
        r'''$[:].base_amount''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? createdAt(dynamic response) => (getJsonField(
        response,
        r'''$[:].created_at''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class UpdateStoreLocationCall {
  static Future<ApiCallResponse> call({
    String? pStoreId = '',
    double? pStoreLat,
    double? pStoreLng,
  }) async {
    final ffApiRequestBody = '''
{
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_store_lat": ${pStoreLat},
  "p_store_lng": ${pStoreLng}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateStoreLocation',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/update_store_location',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetBalanceDfiferencesCall {
  static Future<ApiCallResponse> call({
    String? storeId = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getBalanceDfiferences',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/v_store_balance_summary?select=*&store_id=eq.${storeId}',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Range': '0-9',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? debit(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$[:].total_debit''',
      ));
  static int? credit(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$[:].total_credit''',
      ));
  static int? diff(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$[:].balance_difference''',
      ));
}

class UpdateShiftRequestsEndCall {
  static Future<ApiCallResponse> call({
    String? pShiftRequestId = '',
    String? pActualEndTime = '',
    double? pEndLat,
    double? pEndLng,
  }) async {
    final ffApiRequestBody = '''
{
  "p_shift_request_id": "${escapeStringForJson(pShiftRequestId)}",
  "p_actual_end_time": "${escapeStringForJson(pActualEndTime)}",
  "p_end_lat": ${pEndLat},
  "p_end_lng": ${pEndLng}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateShiftRequestsEnd',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/update_shift_request_end',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetManagerShiftCall {
  static Future<ApiCallResponse> call({
    String? pStoreId = '',
    String? pRequestDate = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_request_date": "${escapeStringForJson(pRequestDate)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetManagerShift',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_monthly_shift_status_manager',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeleteCashAmountLineCall {
  static Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pRecordDate = '',
    String? pLocationId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_record_date": "${escapeStringForJson(pRecordDate)}",
  "p_location_id": "${escapeStringForJson(pLocationId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'deleteCashAmountLine',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/delete_null_store_cashier_lines',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InsertCashLineCall {
  static Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pStoreId = '',
    String? pLocationId = '',
    String? pRecordDate = '',
    dynamic pCurrenciesJson,
    String? pCreatedBy = '',
    String? pCreatedAt = '',
  }) async {
    final pCurrencies = _serializeJson(pCurrenciesJson);
    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_location_id": "${escapeStringForJson(pLocationId)}",
  "p_record_date": "${escapeStringForJson(pRecordDate)}",
  "p_created_by": "${escapeStringForJson(pCreatedBy)}",
  "p_currencies": ${pCurrencies},
  "p_created_at": "${escapeStringForJson(pCreatedAt)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertCashLine',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/insert_cashier_amount_lines',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateUserSalaryCall {
  static Future<ApiCallResponse> call({
    String? pSalaryId = '',
    double? pSalaryAmount,
    String? pSalaryType = '',
    String? pCurrencyId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_salary_id": "${escapeStringForJson(pSalaryId)}",
  "p_salary_amount": ${pSalaryAmount},
  "p_salary_type": "${escapeStringForJson(pSalaryType)}",
  "p_currency_id": "${escapeStringForJson(pCurrencyId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateUserSalary',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/update_user_salary',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserCompaniesCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getUserCompanies',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_user_companies_and_stores',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? userid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.user_id''',
      ));
  static String? username(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.user_name''',
      ));
  static int? compnycount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.company_count''',
      ));
  static List? companiesJson(dynamic response) => getJsonField(
        response,
        r'''$.companies''',
        true,
      ) as List?;
  static String? companiesId(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.companies[:].company_id''',
      ));
  static int? companyStoreCount(dynamic response) =>
      castToType<int>(getJsonField(
        response,
        r'''$.companies[:].store_count''',
      ));
  static String? companyName(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.companies[:].company_name''',
      ));
  static List<String>? storeId(dynamic response) => (getJsonField(
        response,
        r'''$.companies[:].stores[:].store_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetusernamesbystoreidCall {
  static Future<ApiCallResponse> call({
    String? pStoreId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_store_id": "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getusernamesbystoreid',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_user_names_by_store_id',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? userId(dynamic response) => (getJsonField(
        response,
        r'''$[:].user_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? fullName(dynamic response) => (getJsonField(
        response,
        r'''$[:].full_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetCategoriesWithFeaturesCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'getCategoriesWithFeatures',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_categories_with_features',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? categoryId(dynamic response) => (getJsonField(
        response,
        r'''$[:].category_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? categoryName(dynamic response) => (getJsonField(
        response,
        r'''$[:].category_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? categoryFeatures(dynamic response) => getJsonField(
        response,
        r'''$[:].features''',
        true,
      ) as List?;
  static List<String>? featuresId(dynamic response) => (getJsonField(
        response,
        r'''$[:].features[:].feature_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? featuresName(dynamic response) => (getJsonField(
        response,
        r'''$[:].features[:].feature_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? featuresIcon(dynamic response) => (getJsonField(
        response,
        r'''$[:].features[:].icon''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? featureRoute(dynamic response) => (getJsonField(
        response,
        r'''$[:].features[:].route''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ShiftrequestfilternumberCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pRequestDate = '',
    String? pStoreId,
  }) async {
    pStoreId ??= null;

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_request_date": "${escapeStringForJson(pRequestDate)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'shiftrequestfilternumber',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/shift_request_filter_number',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class VaultAmountInsertCall {
  static Future<ApiCallResponse> call({
    String? pLocationId = '',
    String? pCompanyId = '',
    String? pCreatedAt = '',
    String? pCreatedBy = '',
    bool? pCredit,
    String? pCurrencyId = '',
    bool? pDebit,
    String? pRecordDate = '',
    String? pStoreId = '',
    dynamic pVaultAmountLineJsonJson,
  }) async {
    final pVaultAmountLineJson = _serializeJson(pVaultAmountLineJsonJson, true);
    final ffApiRequestBody = '''
{
  "p_location_id": "${escapeStringForJson(pLocationId)}",
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_created_at": "${escapeStringForJson(pCreatedAt)}",
  "p_created_by": "${escapeStringForJson(pCreatedBy)}",
  "p_credit": ${pCredit},
  "p_currency_id": "${escapeStringForJson(pCurrencyId)}",
  "p_debit": ${pDebit},
  "p_record_date": "${escapeStringForJson(pRecordDate)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_vault_amount_line_json": ${pVaultAmountLineJson}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'vaultAmountInsert',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/vault_amount_insert',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ToggleshiftapprovalCall {
  static Future<ApiCallResponse> call({
    List<String>? pShiftRequestIdsList,
    String? pUserId = '',
  }) async {
    final pShiftRequestIds = _serializeList(pShiftRequestIdsList);

    final ffApiRequestBody = '''
{
  "p_shift_request_ids": ${pShiftRequestIds},
  "p_user_id": "${escapeStringForJson(pUserId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'toggleshiftapproval',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/toggle_shift_approval',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BringFinanceAccountInfoCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'bringFinanceAccountInfo',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/accounts?select=account_id,account_name,account_type,expense_nature,category_tag',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? accountid(dynamic response) => (getJsonField(
        response,
        r'''$[:].account_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? accountName(dynamic response) => (getJsonField(
        response,
        r'''$[:].account_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? accountType(dynamic response) => (getJsonField(
        response,
        r'''$[:].account_type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class UpdateShiftRequestsCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pStoreId = '',
    String? pRequestDate = '',
    String? pTime = '',
    double? pLat,
    double? pLng,
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_request_date": "${escapeStringForJson(pRequestDate)}",
  "p_time": "${escapeStringForJson(pTime)}",
  "p_lat": ${pLat},
  "p_lng": ${pLng}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateShiftRequests',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/update_shift_requests',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserShiftStatusCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pStoreId = '',
    String? pRequestDate = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",

  "p_store_id" : "${escapeStringForJson(pStoreId)}",

  "p_request_date" : "${escapeStringForJson(pRequestDate)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getUserShiftStatus',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_monthly_shift_status',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? shiftId(dynamic response) => (getJsonField(
        response,
        r'''$[:].shift_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? requestDate(dynamic response) => (getJsonField(
        response,
        r'''$[:].request_date''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? totalRegistered(dynamic response) => (getJsonField(
        response,
        r'''$[:].total_registered''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<bool>? isRegisteredbyMe(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_registered_by_me''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static List<String>? shiftRequestId(dynamic response) => (getJsonField(
        response,
        r'''$[:].shift_request_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<bool>? isApproved(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_approved''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static int? totalOtherStaffs(dynamic response) =>
      castToType<int>(getJsonField(
        response,
        r'''$[:].total_other_staffs''',
      ));
}

class GetshiftmetadataCall {
  static Future<ApiCallResponse> call({
    String? pStoreId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_store_id": "${escapeStringForJson(pStoreId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getshiftmetadata',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_shift_metadata',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BankAmountInsertCall {
  static Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pStoreId,
    String? pRecordDate = '',
    String? pLocationId = '',
    String? pCurrencyId = '',
    int? pTotalAmount,
    String? pCreatedBy = '',
    String? pCreatedAt = '',
  }) async {
    pStoreId ??= null;

    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_record_date": "${escapeStringForJson(pRecordDate)}",
  "p_location_id": "${escapeStringForJson(pLocationId)}",
  "p_currency_id": "${escapeStringForJson(pCurrencyId)}",
  "p_total_amount": ${pTotalAmount},
  "p_created_by": "${escapeStringForJson(pCreatedBy)}",
  "p_created_at": "${escapeStringForJson(pCreatedAt)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'bankAmountInsert',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/bank_amount_insert_v2',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateTamplateCall {
  static Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pStoreId = '',
    String? pName = '',
    dynamic pDataJson,
  }) async {
    final pData = _serializeJson(pDataJson);
    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",


  "p_store_id" : "${escapeStringForJson(pStoreId)}",

  "p_name" :  "${escapeStringForJson(pName)}",

  "p_data" : ${pData}
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'createTamplate',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/insert_transaction_template',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class JoinUserByCodeCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pCode = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_code": "${escapeStringForJson(pCode)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'JoinUserByCode',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/join_user_by_code',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetNotMyCounterPartyCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pCompanyId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",


  "p_company_id" : "${escapeStringForJson(pCompanyId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetNotMyCounterParty',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_unlinked_companies',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? companyId(dynamic response) => (getJsonField(
        response,
        r'''$[:].company_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? companyName(dynamic response) => (getJsonField(
        response,
        r'''$[:].company_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetlatestcashieramountlinesCall {
  static Future<ApiCallResponse> call({
    String? pCompanyId = '',
    String? pStoreId = '',
    String? pRequestDate = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_company_id": "${escapeStringForJson(pCompanyId)}",


  "p_store_id" :  "${escapeStringForJson(pStoreId)}",


"p_request_date" : "${escapeStringForJson(pRequestDate)}"
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'getlatestcashieramountlines',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_latest_cashier_amount_lines',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserShiftQuantityCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pStoreId = '',
    String? pRequestDate = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_request_date": "${escapeStringForJson(pRequestDate)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getUserShiftQuantity',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_user_shift_quantity',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic shiftquantity(dynamic response) => getJsonField(
        response,
        r'''$[*]''',
      );
}

class GetshiftrequestmonthlyCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pStoreId = '',
    String? pRequestDate = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_request_date": "${escapeStringForJson(pRequestDate)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getshiftrequestmonthly',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_shift_request_monthly',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? shiftRequestMonth(dynamic response) => getJsonField(
        response,
        r'''$[*]''',
        true,
      ) as List?;
}

class GetusersalaryindividualCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pStoreId = '',
    String? pRequestDate = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_store_id": "${escapeStringForJson(pStoreId)}",
  "p_request_date": "${escapeStringForJson(pRequestDate)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getusersalaryindividual',
      apiUrl:
          'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_user_salary_individual',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0a2VrendndWtkdnVjcW50cnlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTQwMjIsImV4cCI6MjA1ODQ3MDAyMn0.G4WqAmLvQSqYEfMWIpFOAZOYtnT0kxCxj8dVGhuUYO8',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
