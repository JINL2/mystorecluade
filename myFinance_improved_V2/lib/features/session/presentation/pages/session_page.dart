import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/feature.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../homepage/domain/entities/top_feature.dart';

/// Session Page
///
/// Main page for session management feature.
/// Feature ID: 540acbde-e5c7-4c5b-ad67-fd6204a56479
/// Route: /session
///
/// Options:
/// - Create Session: Start a new session
/// - Join Session: Join an existing session with a code
class SessionPage extends ConsumerStatefulWidget {
  final dynamic feature;

  const SessionPage({super.key, this.feature});

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage> {
  // Feature info extracted once
  String? _featureName;
  bool _featureInfoExtracted = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _extractFeatureInfo();
  }

  void _extractFeatureInfo() {
    if (_featureInfoExtracted) return;

    final feature = widget.feature;
    if (feature != null) {
      if (feature is Feature) {
        _featureName = feature.featureName;
      } else if (feature is TopFeature) {
        _featureName = feature.featureName;
      }
    }

    _featureInfoExtracted = true;
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: TossAppBar1(
        title: _featureName ?? 'Session',
        backgroundColor: TossColors.background,
      ),
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Create Session Card
              _buildActionCard(
                context: context,
                title: 'Create Session',
                subtitle: 'Start a new work session',
                icon: Icons.add_circle_outline,
                color: TossColors.primary,
                onTap: () => _onCreateSession(),
              ),

              const SizedBox(height: 20),

              // Join Session Card
              _buildActionCard(
                context: context,
                title: 'Join Session',
                subtitle: 'Join an existing session with a code',
                icon: Icons.login_outlined,
                color: TossColors.success,
                onTap: () => _onJoinSession(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Action Handlers
  // ==========================================

  void _onCreateSession() {
    if (_isNavigating || !mounted) return;

    setState(() {
      _isNavigating = true;
    });

    // TODO: Navigate to create session page
    // context.push('/session/create');

    // For now, show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Create Session - Coming Soon'),
        backgroundColor: TossColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Reset navigation state
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    });
  }

  void _onJoinSession() {
    if (_isNavigating || !mounted) return;

    setState(() {
      _isNavigating = true;
    });

    // TODO: Navigate to join session page or show join dialog
    // context.push('/session/join');

    // For now, show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Join Session - Coming Soon'),
        backgroundColor: TossColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Reset navigation state
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    });
  }

  // ==========================================
  // UI Components
  // ==========================================

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: TossColors.gray200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TossColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              const Icon(
                Icons.arrow_forward_ios,
                color: TossColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
