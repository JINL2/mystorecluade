import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../di/session_providers.dart';
import '../../domain/entities/session_list_item.dart';
import '../providers/session_list_provider.dart';
import '../widgets/create_session_dialog.dart';

/// Session action page - shows session list with FAB for creating new sessions
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
  bool _isJoining = false;

  String get _pageTitle {
    return widget.sessionType == 'counting' ? 'Stock Count' : 'Receiving';
  }

  Color get _typeColor {
    return widget.sessionType == 'counting' ? TossColors.primary : TossColors.success;
  }

  Future<void> _onCreateSessionTap() async {
    final result = await showCreateSessionDialog(
      context,
      sessionType: widget.sessionType,
    );

    if (result != null && mounted) {
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
    if (_isJoining) return;

    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;
    final isOwner = session.createdBy == currentUserId;

    setState(() => _isJoining = true);

    try {
      // Call inventory_join_session RPC
      final joinSession = ref.read(joinSessionUseCaseProvider);
      await joinSession(
        sessionId: session.sessionId,
        userId: currentUserId,
      );

      if (!mounted) return;

      // Navigate to session detail page on success
      context.push(
        '/session/detail/${session.sessionId}'
        '?sessionType=${session.sessionType}'
        '&storeId=${session.storeId}'
        '&sessionName=${Uri.encodeComponent(session.sessionName)}'
        '&isOwner=$isOwner',
      );
    } catch (e) {
      if (!mounted) return;

      // Show error dialog
      showDialog<void>(
        context: context,
        builder: (ctx) => TossDialog.error(
          title: 'Failed to Join',
          message: e.toString().replaceFirst('Exception: ', ''),
          primaryButtonText: 'OK',
          onPrimaryPressed: () => Navigator.of(ctx).pop(),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionListProvider(widget.sessionType));

    return Stack(
      children: [
        Scaffold(
          appBar: TossAppBar1(
            title: _pageTitle,
            secondaryActionIcon: Icons.refresh,
            onSecondaryAction: () {
              ref.read(sessionListProvider(widget.sessionType).notifier).refresh();
            },
          ),
          body: _buildBody(state),
          floatingActionButton: FloatingActionButton(
            onPressed: _onCreateSessionTap,
            backgroundColor: _typeColor,
            child: const Icon(Icons.add, color: TossColors.white),
          ),
        ),
        // Loading overlay when joining session
        if (_isJoining)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
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
      return _EmptyView(sessionType: widget.sessionType);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(sessionListProvider(widget.sessionType).notifier).refresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(TossSpacing.space4),
        itemCount: state.sessions.length,
        itemBuilder: (context, index) {
          final session = state.sessions[index];
          return _SessionCard(
            session: session,
            onTap: () => _onSessionTap(session),
          );
        },
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

/// Empty view
class _EmptyView extends StatelessWidget {
  final String sessionType;

  const _EmptyView({required this.sessionType});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 64,
              color: TossColors.textTertiary,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No sessions yet',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.textPrimary,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Tap + to create a new ${sessionType == 'counting' ? 'stock count' : 'receiving'} session',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Session card
class _SessionCard extends StatelessWidget {
  final SessionListItem session;
  final VoidCallback onTap;

  const _SessionCard({
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      elevation: 0,
      color: TossColors.gray50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTypeColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  _getTypeIcon(),
                  color: _getTypeColor(),
                  size: 24,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.sessionName,
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Row(
                      children: [
                        const Icon(
                          Icons.store_outlined,
                          size: 14,
                          color: TossColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            session.storeName,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getTypeLabel(),
                            style: TossTextStyles.small.copyWith(
                              color: _getTypeColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.people_outline,
                          label: '${session.memberCount}',
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        _InfoChip(
                          icon: Icons.person_outline,
                          label: session.createdByName,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              const Icon(
                Icons.chevron_right,
                color: TossColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    return session.isCounting
        ? Icons.inventory_2_outlined
        : Icons.local_shipping_outlined;
  }

  Color _getTypeColor() {
    return session.isCounting ? TossColors.primary : TossColors.success;
  }

  String _getTypeLabel() {
    return session.isCounting ? 'Stock Count' : 'Receiving';
  }
}

/// Info chip
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: TossColors.textTertiary,
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: TossTextStyles.small.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
