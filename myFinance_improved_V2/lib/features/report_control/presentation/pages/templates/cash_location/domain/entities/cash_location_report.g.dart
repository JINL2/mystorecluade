// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_location_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CashLocationReportImpl _$$CashLocationReportImplFromJson(
        Map<String, dynamic> json) =>
    _$CashLocationReportImpl(
      reportDate: json['report_date'] as String,
      currencySymbol: json['currency_symbol'] as String? ?? '₫',
      currencyCode: json['currency_code'] as String? ?? 'VND',
      heroStats: CashLocationHeroStats.fromJson(
          json['hero_stats'] as Map<String, dynamic>),
      locationsByStore: (json['locations_by_store'] as List<dynamic>?)
              ?.map((e) => StoreLocations.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recentEntries: (json['recent_entries'] as List<dynamic>?)
              ?.map((e) => CashEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      issues: (json['issues'] as List<dynamic>?)
              ?.map(
                  (e) => CashLocationIssue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      aiInsights: CashLocationInsights.fromJson(
          json['ai_insights'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CashLocationReportImplToJson(
        _$CashLocationReportImpl instance) =>
    <String, dynamic>{
      'report_date': instance.reportDate,
      'currency_symbol': instance.currencySymbol,
      'currency_code': instance.currencyCode,
      'hero_stats': instance.heroStats,
      'locations_by_store': instance.locationsByStore,
      'recent_entries': instance.recentEntries,
      'issues': instance.issues,
      'ai_insights': instance.aiInsights,
    };

_$CashLocationHeroStatsImpl _$$CashLocationHeroStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$CashLocationHeroStatsImpl(
      totalLocations: (json['total_locations'] as num).toInt(),
      balancedCount: (json['balanced_count'] as num).toInt(),
      issuesCount: (json['issues_count'] as num).toInt(),
      shortageCount: (json['shortage_count'] as num?)?.toInt() ?? 0,
      surplusCount: (json['surplus_count'] as num?)?.toInt() ?? 0,
      totalBookAmount: (json['total_book_amount'] as num).toDouble(),
      totalActualAmount: (json['total_actual_amount'] as num).toDouble(),
      netDifference: (json['net_difference'] as num).toDouble(),
      overallStatus: json['overall_status'] as String,
      totalBookFormatted: json['total_book_formatted'] as String,
      totalActualFormatted: json['total_actual_formatted'] as String,
      netDifferenceFormatted: json['net_difference_formatted'] as String,
    );

Map<String, dynamic> _$$CashLocationHeroStatsImplToJson(
        _$CashLocationHeroStatsImpl instance) =>
    <String, dynamic>{
      'total_locations': instance.totalLocations,
      'balanced_count': instance.balancedCount,
      'issues_count': instance.issuesCount,
      'shortage_count': instance.shortageCount,
      'surplus_count': instance.surplusCount,
      'total_book_amount': instance.totalBookAmount,
      'total_actual_amount': instance.totalActualAmount,
      'net_difference': instance.netDifference,
      'overall_status': instance.overallStatus,
      'total_book_formatted': instance.totalBookFormatted,
      'total_actual_formatted': instance.totalActualFormatted,
      'net_difference_formatted': instance.netDifferenceFormatted,
    };

_$StoreLocationsImpl _$$StoreLocationsImplFromJson(Map<String, dynamic> json) =>
    _$StoreLocationsImpl(
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      locations: (json['locations'] as List<dynamic>)
          .map((e) => CashLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      storeTotalBook: (json['store_total_book'] as num?)?.toDouble() ?? 0,
      storeTotalActual: (json['store_total_actual'] as num?)?.toDouble() ?? 0,
      storeDifference: (json['store_difference'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$StoreLocationsImplToJson(
        _$StoreLocationsImpl instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'locations': instance.locations,
      'store_total_book': instance.storeTotalBook,
      'store_total_actual': instance.storeTotalActual,
      'store_difference': instance.storeDifference,
    };

_$CashLocationImpl _$$CashLocationImplFromJson(Map<String, dynamic> json) =>
    _$CashLocationImpl(
      locationId: json['location_id'] as String,
      locationName: json['location_name'] as String,
      locationType: json['location_type'] as String,
      bookAmount: (json['book_amount'] as num).toDouble(),
      actualAmount: (json['actual_amount'] as num).toDouble(),
      difference: (json['difference'] as num).toDouble(),
      status: json['status'] as String,
      bookFormatted: json['book_formatted'] as String,
      actualFormatted: json['actual_formatted'] as String,
      differenceFormatted: json['difference_formatted'] as String,
    );

Map<String, dynamic> _$$CashLocationImplToJson(_$CashLocationImpl instance) =>
    <String, dynamic>{
      'location_id': instance.locationId,
      'location_name': instance.locationName,
      'location_type': instance.locationType,
      'book_amount': instance.bookAmount,
      'actual_amount': instance.actualAmount,
      'difference': instance.difference,
      'status': instance.status,
      'book_formatted': instance.bookFormatted,
      'actual_formatted': instance.actualFormatted,
      'difference_formatted': instance.differenceFormatted,
    };

_$CashEntryImpl _$$CashEntryImplFromJson(Map<String, dynamic> json) =>
    _$CashEntryImpl(
      entryId: json['entry_id'] as String,
      date: json['date'] as String,
      locationName: json['location_name'] as String,
      storeName: json['store_name'] as String,
      employeeName: json['employee_name'] as String,
      netCashFlow: (json['net_cash_flow'] as num).toDouble(),
      formattedAmount: json['formatted_amount'] as String,
      description: json['description'] as String?,
      entryType: json['entry_type'] as String?,
    );

Map<String, dynamic> _$$CashEntryImplToJson(_$CashEntryImpl instance) =>
    <String, dynamic>{
      'entry_id': instance.entryId,
      'date': instance.date,
      'location_name': instance.locationName,
      'store_name': instance.storeName,
      'employee_name': instance.employeeName,
      'net_cash_flow': instance.netCashFlow,
      'formatted_amount': instance.formattedAmount,
      'description': instance.description,
      'entry_type': instance.entryType,
    };

_$CashLocationIssueImpl _$$CashLocationIssueImplFromJson(
        Map<String, dynamic> json) =>
    _$CashLocationIssueImpl(
      locationId: json['location_id'] as String,
      locationName: json['location_name'] as String,
      locationType: json['location_type'] as String,
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      bookAmount: (json['book_amount'] as num).toDouble(),
      actualAmount: (json['actual_amount'] as num).toDouble(),
      difference: (json['difference'] as num).toDouble(),
      bookFormatted: json['book_formatted'] as String,
      actualFormatted: json['actual_formatted'] as String,
      differenceFormatted: json['difference_formatted'] as String,
      issueType: json['issue_type'] as String,
      severity: json['severity'] as String? ?? 'medium',
      lastEntry: json['last_entry'] == null
          ? null
          : LastEntryInfo.fromJson(json['last_entry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CashLocationIssueImplToJson(
        _$CashLocationIssueImpl instance) =>
    <String, dynamic>{
      'location_id': instance.locationId,
      'location_name': instance.locationName,
      'location_type': instance.locationType,
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'book_amount': instance.bookAmount,
      'actual_amount': instance.actualAmount,
      'difference': instance.difference,
      'book_formatted': instance.bookFormatted,
      'actual_formatted': instance.actualFormatted,
      'difference_formatted': instance.differenceFormatted,
      'issue_type': instance.issueType,
      'severity': instance.severity,
      'last_entry': instance.lastEntry,
    };

_$LastEntryInfoImpl _$$LastEntryInfoImplFromJson(Map<String, dynamic> json) =>
    _$LastEntryInfoImpl(
      entryId: json['entry_id'] as String? ?? '',
      employeeId: json['employee_id'] as String? ?? '',
      employeeName: json['employee_name'] as String? ?? 'Unknown',
      entryDate: json['entry_date'] as String? ?? '',
      entryTime: json['entry_time'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      formattedAmount: json['formatted_amount'] as String? ?? '',
      description: json['description'] as String?,
      entryType: json['entry_type'] as String?,
    );

Map<String, dynamic> _$$LastEntryInfoImplToJson(_$LastEntryInfoImpl instance) =>
    <String, dynamic>{
      'entry_id': instance.entryId,
      'employee_id': instance.employeeId,
      'employee_name': instance.employeeName,
      'entry_date': instance.entryDate,
      'entry_time': instance.entryTime,
      'amount': instance.amount,
      'formatted_amount': instance.formattedAmount,
      'description': instance.description,
      'entry_type': instance.entryType,
    };

_$CashLocationInsightsImpl _$$CashLocationInsightsImplFromJson(
        Map<String, dynamic> json) =>
    _$CashLocationInsightsImpl(
      summary: json['summary'] as String,
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CashLocationInsightsImplToJson(
        _$CashLocationInsightsImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'recommendations': instance.recommendations,
    };
