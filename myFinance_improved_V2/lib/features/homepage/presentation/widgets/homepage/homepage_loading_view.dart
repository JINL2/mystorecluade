import 'package:flutter/material.dart';

import '../../../../../shared/widgets/organisms/skeleton/toss_homepage_skeleton.dart';

/// Loading view for homepage states - Uses skeleton instead of spinner
class HomepageLoadingView extends StatelessWidget {
  final String message;

  const HomepageLoadingView({
    super.key,
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return TossHomepageSkeleton(
      message: message,
    );
  }
}

/// Logout loading view - Shows spinner with message (quick action)
class LogoutLoadingView extends StatelessWidget {
  const LogoutLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomepageActionSkeleton(
      message: 'Logging out...',
    );
  }
}

/// Refresh loading view - Shows skeleton (data refresh)
class RefreshLoadingView extends StatelessWidget {
  const RefreshLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TossHomepageSkeleton();
  }
}
