// lib/features/report_control/presentation/pages/templates/financial_summary/financial_summary_template.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../domain/entities/report_notification.dart';
import '../../../../domain/entities/report_detail.dart';
import '../../../utils/report_parser.dart';
import '../../../utils/template_registry.dart';
import '../../../providers/report_provider.dart';
import 'financial_summary_detail_page.dart';
import 'providers/financial_data_providers.dart';
import 'domain/entities/cpa_audit_data.dart';
import '../../../../../../app/providers/app_state_provider.dart';

/// Financial Summary Template
///
/// Self-registering template for Daily Financial Summary reports.
///
/// Clean Architecture:
/// - Uses Domain entities (ReportNotification, ReportDetail)
/// - Returns Presentation widgets
/// - No dependency on Data layer
class FinancialSummaryTemplate {
  /// Template code (matches database)
  static const String templateCode = 'daily_fraud_detection';

  /// Alternative codes (for compatibility)
  static const List<String> alternateCodes = [
    'daily_fraud_detection_json',
    'financial_summary',
  ];

  /// Register this template with the registry
  ///
  /// Called once at app initialization
  static void register() {
    // Register primary code
    TemplateRegistry.register(templateCode, _buildPage);

    // Register alternate codes
    for (final code in alternateCodes) {
      TemplateRegistry.register(code, _buildPage);
    }

    print('✅ [FinancialTemplate] Registered with codes: $templateCode, ${alternateCodes.join(', ')}');
  }

  /// Build the page from notification
  static Widget _buildPage(ReportNotification notification) {
    // ConsumerStatefulWidget으로 content를 동적으로 로드
    return _FinancialSummaryLoader(notification: notification);
  }

  /// Build error page
  static Widget _buildErrorPage(String message) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: TossSpacing.icon4XL, color: TossColors.error),
            SizedBox(height: TossSpacing.space4),
            Text(message),
          ],
        ),
      ),
    );
  }
}

/// Widget to load content dynamically when body is empty
class _FinancialSummaryLoader extends ConsumerStatefulWidget {
  final ReportNotification notification;

  const _FinancialSummaryLoader({required this.notification});

  @override
  ConsumerState<_FinancialSummaryLoader> createState() =>
      _FinancialSummaryLoaderState();
}

class _FinancialSummaryLoaderState
    extends ConsumerState<_FinancialSummaryLoader> {
  String? _content;
  CpaAuditData? _auditData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContentIfNeeded();
  }

  Future<void> _loadContentIfNeeded() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 1. AI 요약 content 가져오기
      if (widget.notification.body.isEmpty) {
        print('🔍 [FinancialTemplate] Body is empty, fetching content...');
        final notifier = ref.read(reportProvider.notifier);
        _content = await notifier.getSessionContent(
          sessionId: widget.notification.sessionId,
        );
        print('✅ [FinancialTemplate] Content loaded successfully');
      } else {
        _content = widget.notification.body;
      }

      // 2. 실제 거래 데이터 가져오기 (RPC)
      print('🔍 [FinancialTemplate] Fetching CPA audit data...');
      final financialRepo = ref.read(financialDataRepositoryProvider);

      // companyId 가져오기
      // 1순위: notification에서 가져오기 (RPC 응답에 포함됨)
      // 2순위: AppState에서 가져오기 (현재 선택된 회사)
      // 3순위: report_generation_sessions 테이블에서 직접 조회
      String? companyId = widget.notification.companyId;

      if (companyId == null || companyId.isEmpty) {
        // AppState에서 가져오기
        final appState = ref.read(appStateProvider);
        companyId = appState.companyChoosen;

        if ((companyId?.isEmpty ?? true) && widget.notification.sessionId.isNotEmpty) {
          // 3순위: session에서 직접 가져오기
          print('🔍 [FinancialTemplate] Fetching company_id from session...');
          final sessionData = await Supabase.instance.client
              .from('report_generation_sessions')
              .select('company_id')
              .eq('session_id', widget.notification.sessionId)
              .maybeSingle();

          companyId = sessionData?['company_id'] as String?;
          print('✅ [FinancialTemplate] Got company_id from session: $companyId');
        }

        if (companyId == null || companyId.isEmpty) {
          throw Exception('Company ID not found in notification, AppState, or session');
        }
      }

      print('✅ [FinancialTemplate] Using companyId: $companyId');

      _auditData = await financialRepo.getCpaAuditReport(
        companyId: companyId,
        storeId: widget.notification.storeId, // null이면 모든 매장
        targetDate: widget.notification.reportDate,
        reportType: 'daily',
      );
      print('✅ [FinancialTemplate] CPA audit data loaded successfully');
      print('   - Total transactions: ${_auditData!.allTransactions.length}');

      setState(() {
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('❌ [FinancialTemplate] Error loading data: $e');
      print('📚 [FinancialTemplate] Stack trace: $stackTrace');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.notification.title)),
        body: const TossLoadingView(),
      );
    }

    if (_error != null) {
      return FinancialSummaryTemplate._buildErrorPage('Error: $_error');
    }

    if (_content == null) {
      return FinancialSummaryTemplate._buildErrorPage(
          'No content available');
    }

    try {
      print('🔍 [FinancialTemplate] Building page with content...');

      // Parse JSON from content
      final reportJson = ReportParser.parse(_content!);

      if (reportJson == null) {
        print('❌ [FinancialTemplate] Failed to parse JSON');
        return FinancialSummaryTemplate._buildErrorPage(
            'Failed to parse report data');
      }

      print('🔍 [FinancialTemplate] reportJson keys: ${reportJson.keys}');

      // Merge metadata from notification into reportJson
      // AI가 생성한 content JSON에는 메타데이터가 없으므로 notification에서 가져와 병합
      final completeJson = {
        'template_id': widget.notification.templateId,
        'template_code': widget.notification.templateCode,
        'report_date': widget.notification.reportDate
            .toIso8601String()
            .split('T')[0], // YYYY-MM-DD 형식
        'session_id': widget.notification.sessionId,
        ...reportJson, // AI가 생성한 리포트 데이터 병합
      };

      print('🔍 [FinancialTemplate] completeJson keys: ${completeJson.keys}');

      // Convert to ReportDetail
      print('🔍 [FinancialTemplate] Calling ReportDetail.fromJson...');
      final reportDetail = ReportDetail.fromJson(completeJson);
      print('🔍 [FinancialTemplate] ReportDetail.fromJson completed!');

      print('✅ [FinancialTemplate] ReportDetail created successfully');

      // Return detail page with audit data
      return FinancialSummaryDetailPage(
        report: reportDetail,
        auditData: _auditData, // RPC에서 가져온 실제 거래 데이터
      );
    } catch (e, stackTrace) {
      print('❌ [FinancialTemplate] Error building page: $e');
      print(
          '📚 [FinancialTemplate] Stack trace: ${stackTrace.toString().split('\n').take(3).join('\n')}');

      return FinancialSummaryTemplate._buildErrorPage('Error: $e');
    }
  }
}
