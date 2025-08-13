// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_sheet_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BalanceSheetImpl _$$BalanceSheetImplFromJson(Map<String, dynamic> json) =>
    _$BalanceSheetImpl(
      id: json['id'] as String,
      companyId: json['companyId'] as String,
      storeId: json['storeId'] as String,
      periodDate: DateTime.parse(json['periodDate'] as String),
      assets: Assets.fromJson(json['assets'] as Map<String, dynamic>),
      liabilities:
          Liabilities.fromJson(json['liabilities'] as Map<String, dynamic>),
      equity: Equity.fromJson(json['equity'] as Map<String, dynamic>),
      totalAssets: (json['totalAssets'] as num).toDouble(),
      totalLiabilities: (json['totalLiabilities'] as num).toDouble(),
      totalEquity: (json['totalEquity'] as num).toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BalanceSheetImplToJson(_$BalanceSheetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'storeId': instance.storeId,
      'periodDate': instance.periodDate.toIso8601String(),
      'assets': instance.assets,
      'liabilities': instance.liabilities,
      'equity': instance.equity,
      'totalAssets': instance.totalAssets,
      'totalLiabilities': instance.totalLiabilities,
      'totalEquity': instance.totalEquity,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$AssetsImpl _$$AssetsImplFromJson(Map<String, dynamic> json) => _$AssetsImpl(
      currentAssets:
          CurrentAssets.fromJson(json['currentAssets'] as Map<String, dynamic>),
      nonCurrentAssets: NonCurrentAssets.fromJson(
          json['nonCurrentAssets'] as Map<String, dynamic>),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$AssetsImplToJson(_$AssetsImpl instance) =>
    <String, dynamic>{
      'currentAssets': instance.currentAssets,
      'nonCurrentAssets': instance.nonCurrentAssets,
      'total': instance.total,
    };

_$CurrentAssetsImpl _$$CurrentAssetsImplFromJson(Map<String, dynamic> json) =>
    _$CurrentAssetsImpl(
      cash: (json['cash'] as num).toDouble(),
      accountsReceivable: (json['accountsReceivable'] as num).toDouble(),
      inventory: (json['inventory'] as num).toDouble(),
      prepaidExpenses: (json['prepaidExpenses'] as num).toDouble(),
      otherCurrentAssets: (json['otherCurrentAssets'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$CurrentAssetsImplToJson(_$CurrentAssetsImpl instance) =>
    <String, dynamic>{
      'cash': instance.cash,
      'accountsReceivable': instance.accountsReceivable,
      'inventory': instance.inventory,
      'prepaidExpenses': instance.prepaidExpenses,
      'otherCurrentAssets': instance.otherCurrentAssets,
      'total': instance.total,
    };

_$NonCurrentAssetsImpl _$$NonCurrentAssetsImplFromJson(
        Map<String, dynamic> json) =>
    _$NonCurrentAssetsImpl(
      propertyPlantEquipment:
          (json['propertyPlantEquipment'] as num).toDouble(),
      intangibleAssets: (json['intangibleAssets'] as num).toDouble(),
      investments: (json['investments'] as num).toDouble(),
      otherNonCurrentAssets: (json['otherNonCurrentAssets'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$NonCurrentAssetsImplToJson(
        _$NonCurrentAssetsImpl instance) =>
    <String, dynamic>{
      'propertyPlantEquipment': instance.propertyPlantEquipment,
      'intangibleAssets': instance.intangibleAssets,
      'investments': instance.investments,
      'otherNonCurrentAssets': instance.otherNonCurrentAssets,
      'total': instance.total,
    };

_$LiabilitiesImpl _$$LiabilitiesImplFromJson(Map<String, dynamic> json) =>
    _$LiabilitiesImpl(
      currentLiabilities: CurrentLiabilities.fromJson(
          json['currentLiabilities'] as Map<String, dynamic>),
      nonCurrentLiabilities: NonCurrentLiabilities.fromJson(
          json['nonCurrentLiabilities'] as Map<String, dynamic>),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$LiabilitiesImplToJson(_$LiabilitiesImpl instance) =>
    <String, dynamic>{
      'currentLiabilities': instance.currentLiabilities,
      'nonCurrentLiabilities': instance.nonCurrentLiabilities,
      'total': instance.total,
    };

_$CurrentLiabilitiesImpl _$$CurrentLiabilitiesImplFromJson(
        Map<String, dynamic> json) =>
    _$CurrentLiabilitiesImpl(
      accountsPayable: (json['accountsPayable'] as num).toDouble(),
      shortTermDebt: (json['shortTermDebt'] as num).toDouble(),
      accruedExpenses: (json['accruedExpenses'] as num).toDouble(),
      currentPortionLongTermDebt:
          (json['currentPortionLongTermDebt'] as num).toDouble(),
      otherCurrentLiabilities:
          (json['otherCurrentLiabilities'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$CurrentLiabilitiesImplToJson(
        _$CurrentLiabilitiesImpl instance) =>
    <String, dynamic>{
      'accountsPayable': instance.accountsPayable,
      'shortTermDebt': instance.shortTermDebt,
      'accruedExpenses': instance.accruedExpenses,
      'currentPortionLongTermDebt': instance.currentPortionLongTermDebt,
      'otherCurrentLiabilities': instance.otherCurrentLiabilities,
      'total': instance.total,
    };

_$NonCurrentLiabilitiesImpl _$$NonCurrentLiabilitiesImplFromJson(
        Map<String, dynamic> json) =>
    _$NonCurrentLiabilitiesImpl(
      longTermDebt: (json['longTermDebt'] as num).toDouble(),
      deferredTaxLiabilities:
          (json['deferredTaxLiabilities'] as num).toDouble(),
      otherNonCurrentLiabilities:
          (json['otherNonCurrentLiabilities'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$NonCurrentLiabilitiesImplToJson(
        _$NonCurrentLiabilitiesImpl instance) =>
    <String, dynamic>{
      'longTermDebt': instance.longTermDebt,
      'deferredTaxLiabilities': instance.deferredTaxLiabilities,
      'otherNonCurrentLiabilities': instance.otherNonCurrentLiabilities,
      'total': instance.total,
    };

_$EquityImpl _$$EquityImplFromJson(Map<String, dynamic> json) => _$EquityImpl(
      commonStock: (json['commonStock'] as num).toDouble(),
      retainedEarnings: (json['retainedEarnings'] as num).toDouble(),
      additionalPaidInCapital:
          (json['additionalPaidInCapital'] as num).toDouble(),
      otherEquity: (json['otherEquity'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$EquityImplToJson(_$EquityImpl instance) =>
    <String, dynamic>{
      'commonStock': instance.commonStock,
      'retainedEarnings': instance.retainedEarnings,
      'additionalPaidInCapital': instance.additionalPaidInCapital,
      'otherEquity': instance.otherEquity,
      'total': instance.total,
    };

_$BalanceSheetSummaryImpl _$$BalanceSheetSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$BalanceSheetSummaryImpl(
      companyName: json['companyName'] as String,
      storeName: json['storeName'] as String,
      periodDate: DateTime.parse(json['periodDate'] as String),
      totalAssets: (json['totalAssets'] as num).toDouble(),
      totalLiabilities: (json['totalLiabilities'] as num).toDouble(),
      totalEquity: (json['totalEquity'] as num).toDouble(),
      currentRatio: (json['currentRatio'] as num).toDouble(),
      debtToEquityRatio: (json['debtToEquityRatio'] as num).toDouble(),
      returnOnEquity: (json['returnOnEquity'] as num).toDouble(),
    );

Map<String, dynamic> _$$BalanceSheetSummaryImplToJson(
        _$BalanceSheetSummaryImpl instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'storeName': instance.storeName,
      'periodDate': instance.periodDate.toIso8601String(),
      'totalAssets': instance.totalAssets,
      'totalLiabilities': instance.totalLiabilities,
      'totalEquity': instance.totalEquity,
      'currentRatio': instance.currentRatio,
      'debtToEquityRatio': instance.debtToEquityRatio,
      'returnOnEquity': instance.returnOnEquity,
    };

_$FinancialRatiosImpl _$$FinancialRatiosImplFromJson(
        Map<String, dynamic> json) =>
    _$FinancialRatiosImpl(
      currentRatio: (json['currentRatio'] as num).toDouble(),
      quickRatio: (json['quickRatio'] as num).toDouble(),
      cashRatio: (json['cashRatio'] as num).toDouble(),
      debtToEquityRatio: (json['debtToEquityRatio'] as num).toDouble(),
      debtToAssetsRatio: (json['debtToAssetsRatio'] as num).toDouble(),
      equityMultiplier: (json['equityMultiplier'] as num).toDouble(),
      assetTurnover: (json['assetTurnover'] as num).toDouble(),
      inventoryTurnover: (json['inventoryTurnover'] as num).toDouble(),
      receivablesTurnover: (json['receivablesTurnover'] as num).toDouble(),
      returnOnAssets: (json['returnOnAssets'] as num).toDouble(),
      returnOnEquity: (json['returnOnEquity'] as num).toDouble(),
      grossProfitMargin: (json['grossProfitMargin'] as num).toDouble(),
      netProfitMargin: (json['netProfitMargin'] as num).toDouble(),
    );

Map<String, dynamic> _$$FinancialRatiosImplToJson(
        _$FinancialRatiosImpl instance) =>
    <String, dynamic>{
      'currentRatio': instance.currentRatio,
      'quickRatio': instance.quickRatio,
      'cashRatio': instance.cashRatio,
      'debtToEquityRatio': instance.debtToEquityRatio,
      'debtToAssetsRatio': instance.debtToAssetsRatio,
      'equityMultiplier': instance.equityMultiplier,
      'assetTurnover': instance.assetTurnover,
      'inventoryTurnover': instance.inventoryTurnover,
      'receivablesTurnover': instance.receivablesTurnover,
      'returnOnAssets': instance.returnOnAssets,
      'returnOnEquity': instance.returnOnEquity,
      'grossProfitMargin': instance.grossProfitMargin,
      'netProfitMargin': instance.netProfitMargin,
    };
