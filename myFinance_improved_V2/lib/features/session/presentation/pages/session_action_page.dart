import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';

/// Session action selection page - Create or Join
class SessionActionPage extends ConsumerWidget {
  final String sessionType; // 'counting' or 'receiving'

  const SessionActionPage({
    super.key,
    required this.sessionType,
  });

  String get _pageTitle {
    return sessionType == 'counting' ? 'Stock Count' : 'Receiving';
  }

  String get _subtitle {
    return sessionType == 'counting'
        ? 'Create a new count session or join an existing one'
        : 'Create a new receiving session or join an existing one';
  }

  Color get _typeColor {
    return sessionType == 'counting' ? TossColors.primary : TossColors.success;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: TossAppBar1(title: _pageTitle),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Select Action',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                _subtitle,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TossSpacing.space6),

              // Create Session Card
              _ActionCard(
                icon: Icons.add_circle_outline,
                title: 'Create Session',
                subtitle: 'Start a new ${sessionType == 'counting' ? 'stock count' : 'receiving'} session',
                color: _typeColor,
                onTap: () => context.push('/session/create/$sessionType'),
              ),
              const SizedBox(height: TossSpacing.space4),

              // Join Session Card
              _ActionCard(
                icon: Icons.group_add_outlined,
                title: 'Join Session',
                subtitle: 'Join an existing ${sessionType == 'counting' ? 'stock count' : 'receiving'} session',
                color: TossColors.warning,
                onTap: () => context.push('/session/list/$sessionType'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Action selection card
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: TossColors.gray50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(width: TossSpacing.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TossColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      subtitle,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
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
}
