import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../providers/session_type_provider.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Main session page - entry point for counting/receiving features
class SessionPage extends ConsumerWidget {
  final dynamic feature;

  const SessionPage({super.key, this.feature});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: TossAppBar(
        title: 'Inventory',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Select Task Type',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Start inventory counting or receiving',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TossSpacing.space6),

              // Counting Card
              _SessionTypeCard(
                icon: Icons.inventory_2_outlined,
                title: 'Stock Count',
                subtitle: 'Verify and adjust current inventory quantities',
                color: TossColors.primary,
                onTap: () {
                  ref.read(selectedSessionTypeProvider.notifier).state =
                      'counting';
                  context.push('/session/action/counting');
                },
              ),
              const SizedBox(height: TossSpacing.space4),

              // Receiving Card
              _SessionTypeCard(
                icon: Icons.local_shipping_outlined,
                title: 'Receiving',
                subtitle: 'Process new product arrivals',
                color: TossColors.success,
                onTap: () {
                  ref.read(selectedSessionTypeProvider.notifier).state =
                      'receiving';
                  context.push('/session/action/receiving');
                },
              ),
              const SizedBox(height: TossSpacing.space4),

              // History Card
              _SessionTypeCard(
                icon: Icons.history,
                title: 'History',
                subtitle: 'View past counting and receiving sessions',
                color: TossColors.gray600,
                onTap: () {
                  context.push('/session/history');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Session type selection card
class _SessionTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SessionTypeCard({
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
