import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/feature.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_confirm_cancel_dialog.dart';
import '../../../../shared/widgets/toss/toss_text_field.dart';

import '../../../homepage/domain/entities/top_feature.dart';

/// Session Page
///
/// Main page for session management feature.
/// Feature ID: 540acbde-e5c7-4c5b-ad67-fd6204a56479
/// Route: /session
///
/// Flow:
/// 1. First select session type: Receive or Count
/// 2. Then select action: Create Session or Join Session
class SessionPage extends ConsumerStatefulWidget {
  final dynamic feature;

  const SessionPage({super.key, this.feature});

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

/// Session type enum
enum SessionType { receive, count }

class _SessionPageState extends ConsumerState<SessionPage>
    with SingleTickerProviderStateMixin {
  // Feature info extracted once
  String? _featureName;
  bool _featureInfoExtracted = false;
  bool _isNavigating = false;

  // Current selected session type (null = show type selection)
  SessionType? _selectedType;

  // Animation controller for page transitions
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isGoingForward = true;

  @override
  void initState() {
    super.initState();
    _extractFeatureInfo();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _updateSlideAnimation();
    _animationController.value = 1.0; // Start fully visible
  }

  void _updateSlideAnimation() {
    _slideAnimation = Tween<Offset>(
      begin: _isGoingForward ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        leading: _selectedType != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBack,
              )
            : null,
      ),
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: SlideTransition(
            position: _slideAnimation,
            child: _selectedType == null
                ? _buildTypeSelection()
                : _buildActionSelection(),
          ),
        ),
      ),
    );
  }

  /// Build session type selection (Receive / Count)
  Widget _buildTypeSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Receive Card
        _buildActionCard(
          context: context,
          title: 'Receive',
          subtitle: 'Receive and verify incoming items',
          icon: Icons.inventory_2_outlined,
          color: TossColors.primary,
          onTap: () => _onSelectType(SessionType.receive),
        ),

        const SizedBox(height: 20),

        // Count Card
        _buildActionCard(
          context: context,
          title: 'Count',
          subtitle: 'Count and verify inventory items',
          icon: Icons.calculate_outlined,
          color: TossColors.success,
          onTap: () => _onSelectType(SessionType.count),
        ),
      ],
    );
  }

  /// Build action selection (Create Session / Join Session)
  Widget _buildActionSelection() {
    return Column(
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
    );
  }

  // ==========================================
  // Action Handlers
  // ==========================================

  void _onSelectType(SessionType type) {
    if (_isNavigating || !mounted) return;

    _isGoingForward = true;
    _updateSlideAnimation();
    _animationController.forward(from: 0.0);

    setState(() {
      _selectedType = type;
    });
  }

  void _goBack() {
    if (_isNavigating || !mounted) return;

    _isGoingForward = false;
    _updateSlideAnimation();
    _animationController.forward(from: 0.0);

    setState(() {
      _selectedType = null;
    });
  }

  void _onCreateSession() {
    if (_isNavigating || !mounted) return;

    _showCreateSessionDialog();
  }

  void _showCreateSessionDialog() {
    final textController = TextEditingController(text: 'Session 1');
    bool isValid = textController.text.trim().isNotEmpty;

    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return TossConfirmCancelDialog(
            title: 'Create Session',
            confirmButtonText: 'Create',
            cancelButtonText: 'Cancel',
            confirmButtonColor: isValid ? null : TossColors.gray300,
            customContent: TossTextField(
              label: 'Session Name',
              hintText: 'Enter session name',
              controller: textController,
              onChanged: (value) {
                setDialogState(() {
                  isValid = value.trim().isNotEmpty;
                });
              },
            ),
            onConfirm: isValid
                ? () {
                    final sessionName = textController.text.trim();
                    Navigator.of(dialogContext).pop(true);
                    _createSession(sessionName);
                  }
                : null,
            onCancel: () {
              Navigator.of(dialogContext).pop(false);
            },
          );
        },
      ),
    );
  }

  void _createSession(String sessionName) {
    if (sessionName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a session name'),
          backgroundColor: TossColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    // TODO: Implement session creation logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating session: $sessionName'),
        backgroundColor: TossColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
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
