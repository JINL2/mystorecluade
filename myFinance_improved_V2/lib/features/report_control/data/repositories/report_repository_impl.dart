// lib/features/report_control/data/repositories/report_repository_impl.dart

import '../../domain/entities/report_category.dart';
import '../../domain/entities/report_notification.dart';
import '../../domain/entities/template_with_subscription.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';
import 'base_repository.dart';

/// Implementation of ReportRepository using BaseRepository for error handling
///
/// Converts between DTOs and domain entities
/// Uses BaseRepository.executeWithErrorHandling for consistent error handling
class ReportRepositoryImpl extends BaseRepository implements ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  ReportRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ReportNotification>> getUserReceivedReports({
    required String userId,
    String? companyId,
    int limit = 50,
    int offset = 0,
  }) async {
    return executeWithErrorHandling(
      () async {
        final dtos = await _remoteDataSource.getUserReceivedReports(
          userId: userId,
          companyId: companyId,
          limit: limit,
          offset: offset,
        );
        return dtos.map((dto) => dto.toDomain()).toList();
      },
      operationName: 'getUserReceivedReports',
    );
  }

  @override
  Future<List<TemplateWithSubscription>> getAvailableTemplatesWithStatus({
    required String userId,
    required String companyId,
  }) async {
    return executeWithErrorHandling(
      () async {
        final dtos = await _remoteDataSource.getAvailableTemplatesWithStatus(
          userId: userId,
          companyId: companyId,
        );
        return dtos.map((dto) => dto.toDomain()).toList();
      },
      operationName: 'getAvailableTemplatesWithStatus',
    );
  }

  @override
  Future<List<ReportCategory>> getCategoriesWithStats({
    required String userId,
    required String companyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return executeWithErrorHandling(
      () async {
        final dtos = await _remoteDataSource.getCategoriesWithStats(
          userId: userId,
          companyId: companyId,
          startDate: startDate,
          endDate: endDate,
        );
        return dtos.map((dto) => dto.toDomain()).toList();
      },
      operationName: 'getCategoriesWithStats',
    );
  }

  @override
  Future<bool> markReportAsRead({
    required String notificationId,
    required String userId,
  }) async {
    return executeWithErrorHandling(
      () async {
        return await _remoteDataSource.markReportAsRead(
          notificationId: notificationId,
          userId: userId,
        );
      },
      operationName: 'markReportAsRead',
    );
  }

  @override
  Future<String> subscribeToTemplate({
    required String userId,
    required String companyId,
    String? storeId,
    required String templateId,
    String? subscriptionName,
    String? scheduleTime,
    List<int>? scheduleDays,
    int? monthlySendDay,
    String timezone = 'UTC',
    List<String> notificationChannels = const ['push'],
  }) async {
    return executeWithErrorHandling(
      () async {
        final dto = await _remoteDataSource.subscribeToTemplate(
          userId: userId,
          companyId: companyId,
          storeId: storeId,
          templateId: templateId,
          subscriptionName: subscriptionName,
          scheduleTime: scheduleTime,
          scheduleDays: scheduleDays,
          monthlySendDay: monthlySendDay,
          timezone: timezone,
          notificationChannels: notificationChannels,
        );

        if (dto == null) {
          throw Exception('Failed to subscribe to template');
        }

        return dto.subscriptionId;
      },
      operationName: 'subscribeToTemplate',
    );
  }

  @override
  Future<bool> updateSubscription({
    required String subscriptionId,
    required String userId,
    bool? enabled,
    String? scheduleTime,
    List<int>? scheduleDays,
    int? monthlySendDay,
    String? timezone,
  }) async {
    return executeWithErrorHandling(
      () async {
        return await _remoteDataSource.updateSubscription(
          subscriptionId: subscriptionId,
          userId: userId,
          enabled: enabled,
          scheduleTime: scheduleTime,
          scheduleDays: scheduleDays,
          monthlySendDay: monthlySendDay,
          timezone: timezone,
        );
      },
      operationName: 'updateSubscription',
    );
  }

  @override
  Future<bool> unsubscribeFromTemplate({
    required String subscriptionId,
    required String userId,
  }) async {
    return executeWithErrorHandling(
      () async {
        return await _remoteDataSource.unsubscribeFromTemplate(
          subscriptionId: subscriptionId,
          userId: userId,
        );
      },
      operationName: 'unsubscribeFromTemplate',
    );
  }

  @override
  Future<String> getSessionContent({
    required String sessionId,
    required String userId,
  }) async {
    return executeWithErrorHandling(
      () async {
        return await _remoteDataSource.getSessionContent(
          sessionId: sessionId,
          userId: userId,
        );
      },
      operationName: 'getSessionContent',
    );
  }
}
