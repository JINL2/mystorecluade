// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeSummaryImpl _$$EmployeeSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$EmployeeSummaryImpl(
      employeeName: json['employeeName'] as String,
      transactionCount: (json['transactionCount'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => TransactionEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$EmployeeSummaryImplToJson(
        _$EmployeeSummaryImpl instance) =>
    <String, dynamic>{
      'employeeName': instance.employeeName,
      'transactionCount': instance.transactionCount,
      'totalAmount': instance.totalAmount,
      'transactions': instance.transactions,
    };

_$StoreEmployeeSummaryImpl _$$StoreEmployeeSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$StoreEmployeeSummaryImpl(
      storeId: json['storeId'] as String,
      storeName: json['storeName'] as String,
      storeTotal: (json['storeTotal'] as num).toDouble(),
      employees: (json['employees'] as List<dynamic>)
          .map((e) => EmployeeSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$StoreEmployeeSummaryImplToJson(
        _$StoreEmployeeSummaryImpl instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'storeName': instance.storeName,
      'storeTotal': instance.storeTotal,
      'employees': instance.employees,
    };
