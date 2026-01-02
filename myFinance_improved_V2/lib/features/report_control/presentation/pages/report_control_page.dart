// lib/features/report_control/presentation/pages/report_control_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/domain/entities/feature.dart';
import '../../../../shared/themes/index.dart';
import '../../../../shared/widgets/ai_chat/ai_chat.dart';
import '../../../homepage/domain/entities/top_feature.dart';
import '../constants/report_strings.dart';
import '../providers/report_provider.dart';
import '../utils/template_initializer.dart';
import '../widgets/common/received_reports_tab.dart';
import '../widgets/common/subscribe_reports_tab.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Report Control Page
///
/// Main page for viewing received reports and subscribing to report templates
///
/// Two tabs:
/// 1. Received Reports - View reports user has received with filtering
/// 2. Subscribe to Reports - Manage report subscriptions
class ReportControlPage extends ConsumerStatefulWidget {
  final dynamic feature;

  const ReportControlPage({super.key, this.feature});

  @override
  ConsumerState<ReportControlPage> createState() => _ReportControlPageState();
}

class _ReportControlPageState extends ConsumerState<ReportControlPage>
    with SingleTickerProviderStateMixin {
  // Feature info extracted once
  String? _featureName;
  String? _featureId;
  bool _featureInfoExtracted = false;

  // Tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    // Initialize report templates (once)
    TemplateInitializer.initialize();

    // Initialize tab controller
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final appState = ref.read(appStateProvider);
      final userId = appState.user['user_id']?.toString() ?? '';
      final companyId = appState.companyChoosen;

      if (userId.isNotEmpty && companyId.isNotEmpty) {
        ref.read(reportProvider.notifier).loadAllData(
              userId: userId,
              companyId: companyId,
            );
      }

      // Extract feature info for AI Chat
      _extractFeatureInfo();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  /// Handle tab change
  void _handleTabChange() {
    if (!mounted) return; // ✅ mounted 체크 추가
    if (_tabController.indexIsChanging) {
      ref.read(reportProvider.notifier).setSelectedTab(_tabController.index);
    }
  }

  /// Extract feature name and ID from widget.feature (once)
  void _extractFeatureInfo() {
    if (_featureInfoExtracted) return;
    _featureInfoExtracted = true;

    if (widget.feature == null) {
      _featureName = 'Report Control';
      return;
    }

    try {
      if (widget.feature is TopFeature) {
        final topFeature = widget.feature as TopFeature;
        _featureName = topFeature.featureName;
        _featureId = topFeature.featureId;
      } else if (widget.feature is Feature) {
        final feature = widget.feature as Feature;
        _featureName = feature.featureName;
        _featureId = feature.featureId;
      } else if (widget.feature is Map<String, dynamic>) {
        final featureMap = widget.feature as Map<String, dynamic>;
        _featureName = featureMap['feature_name'] as String? ??
            featureMap['featureName'] as String?;
        _featureId = featureMap['feature_id'] as String? ??
            featureMap['featureId'] as String?;
      }
    } catch (e) {
      _featureName = 'Report Control';
    }

    _featureName ??= 'Report Control';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportProvider);
    final appState = ref.watch(appStateProvider);
    final userId = appState.user['user_id']?.toString() ?? '';
    final companyId = appState.companyChoosen;

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: TossAppBar(
        title: 'Report Control',
        backgroundColor: TossColors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: TossColors.primary,
          unselectedLabelColor: TossColors.gray500,
          indicatorColor: TossColors.primary,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(ReportStrings.tabReceivedReports),
                  if (state.unreadCount > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${state.unreadCount}',
                        style: TossTextStyles.labelSmall.copyWith(
                          color: TossColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(text: ReportStrings.tabSubscribeReports),
          ],
        ),
      ),
      body: Column(
        children: [
          // Error message banner
          if (state.errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TossSpacing.space3),
              color: TossColors.error.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: TossColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: TossColors.error),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      // Reload data
                      if (userId.isNotEmpty && companyId.isNotEmpty) {
                        ref.read(reportProvider.notifier).loadAllData(
                              userId: userId,
                              companyId: companyId,
                            );
                      }
                    },
                    color: TossColors.error,
                  ),
                ],
              ),
            ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ReceivedReportsTab(
                  userId: userId,
                  companyId: companyId,
                ),
                SubscribeReportsTab(
                  userId: userId,
                  companyId: companyId,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AiChatFab(
        featureName: _featureName ?? 'Report Control',
        pageContext: _buildPageContext(),
        featureId: _featureId,
      ),
    );
  }

  /// Build page context for AI Chat
  Map<String, dynamic> _buildPageContext() {
    final appState = ref.read(appStateProvider);
    final state = ref.read(reportProvider);
    final context = <String, dynamic>{};

    if (appState.storeChoosen.isNotEmpty) {
      context['store_id'] = appState.storeChoosen;
    }

    if (appState.companyChoosen.isNotEmpty) {
      context['company_id'] = appState.companyChoosen;
    }

    // Add current tab context
    context['current_tab'] =
        state.selectedTabIndex == 0 ? 'received_reports' : 'subscribe_reports';
    context['unread_count'] = state.unreadCount;
    context['subscribed_templates_count'] = state.subscribedTemplates.length;
    context['available_templates_count'] = state.availableTemplates.length;

    return context;
  }
}
