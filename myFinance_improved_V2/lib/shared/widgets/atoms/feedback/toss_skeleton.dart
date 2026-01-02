import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// 스켈레톤 로딩 효과 위젯
///
/// 콘텐츠가 로딩 중일 때 표시하는 플레이스홀더입니다.
/// Shimmer 애니메이션을 포함하여 로딩 상태를 시각적으로 표현합니다.
///
/// ## 사용 예시
/// ```dart
/// // 기본 박스 스켈레톤
/// TossSkeleton(width: 100, height: 20)
///
/// // 카드 스켈레톤
/// TossSkeleton.card(height: 120)
///
/// // 원형 스켈레톤 (아바타용)
/// TossSkeleton.circle(size: 48)
///
/// // 텍스트 라인 스켈레톤
/// TossSkeleton.text(width: 150)
/// ```
class TossSkeleton extends StatefulWidget {
  /// 스켈레톤 너비
  final double? width;

  /// 스켈레톤 높이
  final double height;

  /// 모서리 둥글기
  final double borderRadius;

  /// 원형 여부
  final bool isCircle;

  /// Shimmer 애니메이션 사용 여부
  final bool enableShimmer;

  /// 배경 색상
  final Color? baseColor;

  /// Shimmer 하이라이트 색상
  final Color? highlightColor;

  const TossSkeleton({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = TossBorderRadius.md,
    this.isCircle = false,
    this.enableShimmer = true,
    this.baseColor,
    this.highlightColor,
  });

  /// 카드 형태 스켈레톤 (넓은 영역)
  factory TossSkeleton.card({
    Key? key,
    double? width,
    required double height,
    bool enableShimmer = true,
  }) {
    return TossSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: TossBorderRadius.lg,
      enableShimmer: enableShimmer,
    );
  }

  /// 원형 스켈레톤 (아바타용)
  factory TossSkeleton.circle({
    Key? key,
    required double size,
    bool enableShimmer = true,
  }) {
    return TossSkeleton(
      key: key,
      width: size,
      height: size,
      isCircle: true,
      enableShimmer: enableShimmer,
    );
  }

  /// 텍스트 라인 스켈레톤
  factory TossSkeleton.text({
    Key? key,
    double width = 100,
    double height = 16,
    bool enableShimmer = true,
  }) {
    return TossSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: TossBorderRadius.xs,
      enableShimmer: enableShimmer,
    );
  }

  /// 리스트 아이템 스켈레톤 (아바타 + 텍스트 조합)
  static Widget listItem({
    Key? key,
    double avatarSize = 48,
    bool enableShimmer = true,
  }) {
    return Row(
      key: key,
      children: [
        TossSkeleton.circle(size: avatarSize, enableShimmer: enableShimmer),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TossSkeleton.text(width: 120, enableShimmer: enableShimmer),
              const SizedBox(height: TossSpacing.space2),
              TossSkeleton.text(width: 80, height: 12, enableShimmer: enableShimmer),
            ],
          ),
        ),
      ],
    );
  }

  @override
  State<TossSkeleton> createState() => _TossSkeletonState();
}

class _TossSkeletonState extends State<TossSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    if (widget.enableShimmer) {
      _controller = AnimationController(
        duration: TossAnimations.loadingPulse,
        vsync: this,
      )..repeat();
      _animation = Tween<double>(begin: -2, end: 2).animate(
        CurvedAnimation(parent: _controller!, curve: TossAnimations.standard),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? TossColors.gray100;
    final highlightColor = widget.highlightColor ?? TossColors.gray200;

    final decoration = BoxDecoration(
      color: baseColor,
      borderRadius: widget.isCircle
          ? null
          : BorderRadius.circular(widget.borderRadius),
      shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
    );

    if (!widget.enableShimmer || _animation == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: decoration,
      );
    }

    return AnimatedBuilder(
      animation: _animation!,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.isCircle
                ? null
                : BorderRadius.circular(widget.borderRadius),
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment(_animation!.value - 1, 0),
              end: Alignment(_animation!.value + 1, 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
            ),
          ),
        );
      },
    );
  }
}
