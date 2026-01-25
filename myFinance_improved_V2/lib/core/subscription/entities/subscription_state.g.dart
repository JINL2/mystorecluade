// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionStateImpl _$$SubscriptionStateImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionStateImpl(
      userId: json['user_id'] as String,
      planId: json['plan_id'] as String? ?? '',
      planName: json['plan_name'] as String? ?? 'free',
      displayName: json['display_name'] as String? ?? 'Free',
      planType: json['plan_type'] as String? ?? 'free',
      status: json['status'] as String? ?? 'active',
      maxCompanies: (json['max_companies'] as num?)?.toInt(),
      maxStores: (json['max_stores'] as num?)?.toInt(),
      maxEmployees: (json['max_employees'] as num?)?.toInt(),
      aiDailyLimit: (json['ai_daily_limit'] as num?)?.toInt(),
      priceMonthly: (json['price_monthly'] as num?)?.toDouble() ?? 0.0,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastSyncedAt: json['last_synced_at'] == null
          ? null
          : DateTime.parse(json['last_synced_at'] as String),
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['sync_status']) ??
              SyncStatus.unknown,
      revenueCatCustomerId: json['revenue_cat_customer_id'] as String?,
      trialEndsAt: json['trial_ends_at'] == null
          ? null
          : DateTime.parse(json['trial_ends_at'] as String),
      currentPeriodEndsAt: json['current_period_ends_at'] == null
          ? null
          : DateTime.parse(json['current_period_ends_at'] as String),
      errorMessage: json['error_message'] as String?,
    );

Map<String, dynamic> _$$SubscriptionStateImplToJson(
        _$SubscriptionStateImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'plan_id': instance.planId,
      'plan_name': instance.planName,
      'display_name': instance.displayName,
      'plan_type': instance.planType,
      'status': instance.status,
      'max_companies': instance.maxCompanies,
      'max_stores': instance.maxStores,
      'max_employees': instance.maxEmployees,
      'ai_daily_limit': instance.aiDailyLimit,
      'price_monthly': instance.priceMonthly,
      'features': instance.features,
      'last_synced_at': instance.lastSyncedAt?.toIso8601String(),
      'sync_status': _$SyncStatusEnumMap[instance.syncStatus]!,
      'revenue_cat_customer_id': instance.revenueCatCustomerId,
      'trial_ends_at': instance.trialEndsAt?.toIso8601String(),
      'current_period_ends_at': instance.currentPeriodEndsAt?.toIso8601String(),
      'error_message': instance.errorMessage,
    };

const _$SyncStatusEnumMap = {
  SyncStatus.unknown: 'unknown',
  SyncStatus.syncing: 'syncing',
  SyncStatus.synced: 'synced',
  SyncStatus.stale: 'stale',
  SyncStatus.error: 'error',
  SyncStatus.offline: 'offline',
};
