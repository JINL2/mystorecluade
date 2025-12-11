import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../domain/entities/session_list_item.dart';
import '../providers/session_list_provider.dart';

/// Session list page - shows active sessions
class SessionListPage extends ConsumerWidget {
  final String sessionType;

  const SessionListPage({
    super.key,
    required this.sessionType,
  });

  String get _pageTitle {
    switch (sessionType) {
      case 'counting':
        return 'Stock Count Sessions';
      case 'receiving':
        return 'Receiving Sessions';
      case 'join':
        return 'Join Session';
      default:
        return 'Sessions';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionListProvider(sessionType));

    return Scaffold(
      appBar: TossAppBar1(
        title: _pageTitle,
        secondaryActionIcon: Icons.refresh,
        onSecondaryAction: () {
          ref.read(sessionListProvider(sessionType).notifier).refresh();
        },
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, SessionListState state) {
    if (state.isLoading && state.sessions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return _ErrorView(
        error: state.error ?? 'Unknown error',
        onRetry: () {
          ref.read(sessionListProvider(sessionType).notifier).refresh();
        },
      );
    }

    if (state.isEmpty) {
      return _EmptyView(sessionType: sessionType);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(sessionListProvider(sessionType).notifier).refresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(TossSpacing.space4),
        itemCount: state.sessions.length,
        itemBuilder: (context, index) {
          final session = state.sessions[index];
          return _SessionCard(
            session: session,
            onTap: () => _onSessionTap(context, ref, session),
          );
        },
      ),
    );
  }

  void _onSessionTap(BuildContext context, WidgetRef ref, SessionListItem session) {
    final appState = ref.read(appStateProvider);
    final currentUserId = appState.user['user_id']?.toString() ?? '';
    final isOwner = session.createdBy == currentUserId;

    context.push(
      '/session/detail/${session.sessionId}'
      '?sessionType=${session.sessionType}'
      '&storeId=${session.storeId}'
      '&sessionName=${Uri.encodeComponent(session.sessionName)}'
      '&isOwner=$isOwner',
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
    final isJoin = sessionType == 'join';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isJoin ? Icons.group_off_outlined : Icons.inbox_outlined,
              size: 64,
              color: TossColors.textTertiary,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              isJoin ? 'No active sessions' : 'No sessions yet',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.textPrimary,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              isJoin
                  ? 'There are no active sessions to join'
                  : 'Create a new session to get started',
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
