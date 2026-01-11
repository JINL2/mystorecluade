import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../themes/toss_border_radius.dart';
import '../../../themes/toss_colors.dart';
import '../../../themes/toss_spacing.dart';
import '../../../themes/toss_text_styles.dart';

/// TossHomepageSkeleton - Homepage 전용 스켈레톤 템플릿
///
/// Homepage의 로딩 상태를 표시하는 스켈레톤입니다.
/// Header + Revenue Card + Quick Access + Feature Grid 구조를 반영합니다.
///
/// ## 사용법
/// ```dart
/// if (isLoading)
///   const TossHomepageSkeleton()
/// else
///   Homepage()
/// ```
class TossHomepageSkeleton extends StatelessWidget {
  /// shimmer 효과 활성화
  final bool enableShimmer;

  /// 메시지 표시 (optional)
  final String? message;

  const TossHomepageSkeleton({
    super.key,
    this.enableShimmer = true,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.surface,
      body: SafeArea(
        child: Skeletonizer(
          enabled: enableShimmer,
          child: CustomScrollView(
            slivers: [
              // Header Skeleton
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              // Revenue Card Skeleton
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                  ),
                  child: _buildRevenueCard(),
                ),
              ),

              // Quick Access Section Skeleton
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                  ),
                  child: _buildQuickAccessSection(),
                ),
              ),

              // Chart Card Skeleton
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: TossSpacing.space4,
                    right: TossSpacing.space4,
                    top: TossSpacing.space4,
                  ),
                  child: _buildChartCard(),
                ),
              ),

              // Divider
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: TossSpacing.space5 + 1,
                  ),
                  child: Container(
                    height: 18,
                    color: TossColors.borderLight,
                  ),
                ),
              ),

              // Feature Grid Skeleton
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                  ),
                  child: _buildFeatureGrid(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header skeleton (company name + profile icon)
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Company name + dropdown
          Expanded(
            child: Row(
              children: [
                // Company icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                // Company name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Profile icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  /// Revenue card skeleton
  Widget _buildRevenueCard() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.gray200.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 14,
                width: 80,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 24,
                width: 100,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          // Main value
          Container(
            height: 32,
            width: 180,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          // Growth indicator
          Container(
            height: 16,
            width: 100,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  /// Quick access section skeleton
  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space4),
        // Section title
        Container(
          height: 18,
          width: 100,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        // Quick access buttons (4 items in a row)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (index) => _buildQuickAccessItem()),
        ),
      ],
    );
  }

  Widget _buildQuickAccessItem() {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          height: 12,
          width: 48,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  /// Chart card skeleton
  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 18,
                width: 120,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 24,
                width: 80,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          // Chart placeholder
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Center(
              child: Icon(
                Icons.bar_chart,
                size: 48,
                color: TossColors.gray200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Feature grid skeleton
  Widget _buildFeatureGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Container(
          height: 18,
          width: 80,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        // Feature grid (2 columns, 3 rows = 6 items)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: TossSpacing.space3,
            mainAxisSpacing: TossSpacing.space3,
            childAspectRatio: 1.5,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => _buildFeatureItem(),
        ),
        const SizedBox(height: TossSpacing.space6),
      ],
    );
  }

  Widget _buildFeatureItem() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Container(
            height: 14,
            width: 80,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Homepage 로딩 스켈레톤 (Logout/Refresh용)
class HomepageActionSkeleton extends StatelessWidget {
  final String message;

  const HomepageActionSkeleton({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: TossColors.primary,
              strokeWidth: 2,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              message,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
