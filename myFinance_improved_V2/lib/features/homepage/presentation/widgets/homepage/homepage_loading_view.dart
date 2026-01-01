import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Loading view for homepage states
class HomepageLoadingView extends StatelessWidget {
  final String message;

  const HomepageLoadingView({
    super.key,
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.surface,
      body: TossLoadingView(
        message: message,
      ),
    );
  }
}

/// Logout loading view
class LogoutLoadingView extends StatelessWidget {
  const LogoutLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: TossColors.surface,
      body: TossLoadingView(
        message: 'Logging out...',
      ),
    );
  }
}

/// Refresh loading view
class RefreshLoadingView extends StatelessWidget {
  const RefreshLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: TossColors.surface,
      body: TossLoadingView(
        message: 'Refreshing...',
      ),
    );
  }
}
