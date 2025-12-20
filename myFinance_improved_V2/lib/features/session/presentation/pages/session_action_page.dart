import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_badge.dart';
import '../../domain/entities/inventory_session.dart';
import '../../domain/entities/session_list_item.dart';
import '../providers/session_list_provider.dart';
import 'create_session_page.dart';
import 'session_count_detail_page.dart';

/// Session action page - shows session list with app bar add button
/// Design matches stock_in_page.dart
class SessionActionPage extends ConsumerStatefulWidget {
  final String sessionType; // 'counting' or 'receiving'

  const SessionActionPage({
    super.key,
    required this.sessionType,
  });

  @override
  ConsumerState<SessionActionPage> createState() => _SessionActionPageState();
}

class _SessionActionPageState extends ConsumerState<SessionActionPage> {
  String get _pageTitle {
    return widget.sessionType == 'counting' ? 'Stock Count' : 'Receiving';
  }

  bool get _isCounting => widget.sessionType == 'counting';

  Future<void> _onCreateSessionTap() async {
    // Navigate to create session page (full page instead of dialog)
    final result = await Navigator.of(context).push<CreateSessionResponse>(
      MaterialPageRoute(
        builder: (context) => CreateSessionPage(sessionType: widget.sessionType),
      ),
    );

    if (result != null && mounted) {
      // Refresh the session list after creating a new session
      ref.read(sessionListProvider(widget.sessionType).notifier).refresh();

      // Get store ID from app state for navigation
      final appState = ref.read(appStateProvider);
      final storeId = appState.storeChoosen;

      // Build query parameters for navigation
      final queryParams = <String, String>{
        'sessionType': widget.sessionType,
        'storeId': storeId,
        'isOwner': 'true', // Creator is always the owner
      };
      if (result.sessionName != null && result.sessionName!.isNotEmpty) {
        queryParams['sessionName'] = result.sessionName!;
      }

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');

      // Navigate to session detail page with query parameters
      context.push('/session/detail/${result.sessionId}?$queryString');
    }
  }

  Future<void> _onSessionTap(SessionListItem session) async {
    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;
    final isOwner = session.createdBy == currentUserId;

    // Navigate to session count detail page (matches stock_in_detail_page design)
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => SessionCountDetailPage(
          sessionId: session.sessionId,
          sessionName: session.sessionName,
          sessionType: session.sessionType,
          storeId: session.storeId,
          storeName: session.storeName,
          isActive: session.isActive,
          createdAt: session.createdAt,
          isOwner: isOwner,
        ),
      ),
    );

    // Refresh the session list when returning from detail page
    if (mounted) {
      ref.read(sessionListProvider(widget.sessionType).notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionListProvider(widget.sessionType));
    final hasData = !state.isEmpty;

    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(hasData),
      body: _buildBody(state),
    );
  }

  PreferredSizeWidget _buildAppBar(bool hasData) {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(
          Icons.close,
          color: TossColors.gray900,
          size: 22,
        ),
      ),
      title: Text(
        _pageTitle,
        style: TossTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      titleSpacing: 0,
      actions: [
        IconButton(
          onPressed: hasData ? _onCreateSessionTap : null,
          icon: Icon(
            Icons.add,
            color: hasData ? TossColors.gray900 : TossColors.gray300,
            size: 24,
          ),
          splashRadius: 20,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildBody(SessionListState state) {
    if (state.isLoading && state.sessions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return _ErrorView(
        error: state.error ?? 'Unknown error',
        onRetry: () {
          ref.read(sessionListProvider(widget.sessionType).notifier).refresh();
        },
      );
    }

    if (state.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSessionList(state.sessions);
  }

  Widget _buildEmptyState() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icons based on session type
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left icon
                  Icon(
                    _isCounting
                        ? Icons.inventory_2_outlined
                        : Icons.local_shipping_outlined,
                    size: 48,
                    color: TossColors.gray400,
                  ),
                  const SizedBox(width: 12),
                  // Arrow icon
                  const Icon(
                    Icons.arrow_forward,
                    size: 24,
                    color: TossColors.gray400,
                  ),
                  const SizedBox(width: 12),
                  // Right icon
                  Icon(
                    _isCounting
                        ? Icons.fact_check_outlined
                        : Icons.storefront_outlined,
                    size: 48,
                    color: TossColors.gray400,
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space6),
              // Description text
              Text(
                _isCounting
                    ? 'Verify and adjust inventory quantities.\nCompare system records with actual stock.'
                    : 'Count the arrived stock and confirm it matches\nthe shipment order.',
                textAlign: TextAlign.center,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: TossSpacing.space6),
              // Start button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onCreateSessionTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    foregroundColor: TossColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _isCounting ? 'Start Stock Count' : 'Start Receiving',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionList(List<SessionListItem> sessions) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(sessionListProvider(widget.sessionType).notifier).refresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return _buildSessionItem(session);
        },
      ),
    );
  }

  Widget _buildSessionItem(SessionListItem session) {
    // Parse createdAt string to extract day and month
    String dateStr = '';
    try {
      final dateTime = DateTime.parse(session.createdAt);
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      dateStr = '$day.$month';
    } catch (_) {
      dateStr = session.createdAt.length >= 10
          ? '${session.createdAt.substring(8, 10)}.${session.createdAt.substring(5, 7)}'
          : '';
    }

    return GestureDetector(
      onTap: () => _onSessionTap(session),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date column
            SizedBox(
              width: 48,
              child: Text(
                dateStr,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Content column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session name
                  Text(
                    session.sessionName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Store name
                  Text(
                    session.storeName,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  // User row
                  Row(
                    children: [
                      // User avatar
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: TossColors.gray200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            session.createdByName.isNotEmpty
                                ? session.createdByName[0].toUpperCase()
                                : '?',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // User name
                      Text(
                        session.createdByName,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      // Member count
                      const Icon(
                        Icons.people_outline,
                        size: 12,
                        color: TossColors.gray400,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${session.memberCount}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right column: Status badge and type
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status badge
                TossStatusBadge(
                  label: session.isActive ? 'In progress' : 'Done',
                  status: session.isActive
                      ? BadgeStatus.success
                      : BadgeStatus.info,
                ),
                const SizedBox(height: 4),
                // Session type label
                Text(
                  _isCounting ? 'Stock Count' : 'Receiving',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Error view
class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: TossColors.error,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Failed to load sessions',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.textPrimary,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              error,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space4),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
