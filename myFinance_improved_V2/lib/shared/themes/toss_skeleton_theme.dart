import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'toss_animations.dart';
import 'toss_border_radius.dart';
import 'toss_colors.dart';

/// Toss Design System - Skeleton Theme Configuration
///
/// Skeletonizer 패키지와 Toss 디자인 시스템을 통합하는 테마 설정입니다.
///
/// ## 사용법
///
/// ### 1. 앱 테마에 추가 (app_theme.dart)
/// ```dart
/// ThemeData(
///   extensions: [
///     TossSkeletonTheme.light,
///   ],
/// )
/// ```
///
/// ### 2. 위젯에서 사용
/// ```dart
/// Skeletonizer(
///   enabled: isLoading,
///   child: YourWidget(data: mockData),
/// )
/// ```
///
/// ### 3. TossSkeletonWrapper 사용 (권장)
/// ```dart
/// TossSkeletonWrapper(
///   enabled: isLoading,
///   child: ProductTile(product: data ?? Product.mock()),
/// )
/// ```
class TossSkeletonTheme {
  TossSkeletonTheme._();

  // ==================== COLORS ====================

  /// 스켈레톤 베이스 색상 (회색 배경)
  static const Color baseColor = TossColors.gray100;

  /// 스켈레톤 하이라이트 색상 (shimmer 효과)
  static const Color highlightColor = TossColors.gray200;

  /// 다크 모드 베이스 색상
  static const Color darkBaseColor = Color(0xFF2D2D2D);

  /// 다크 모드 하이라이트 색상
  static const Color darkHighlightColor = Color(0xFF3D3D3D);

  // ==================== LIGHT THEME ====================

  /// 라이트 테마 스켈레톤 설정
  ///
  /// - Base color: TossColors.gray100
  /// - Highlight color: TossColors.gray200
  /// - Duration: 1200ms (TossAnimations.loadingPulse)
  /// - Text border radius: TossBorderRadius.xs
  static SkeletonizerConfigData get light => SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: baseColor,
          highlightColor: highlightColor,
          duration: TossAnimations.loadingPulse,
        ),
        justifyMultiLineText: true,
        textBorderRadius: TextBoneBorderRadius(
          BorderRadius.circular(TossBorderRadius.xs),
        ),
        ignoreContainers: false,
        containersColor: baseColor,
        enableSwitchAnimation: true,
      );

  // ==================== DARK THEME ====================

  /// 다크 테마 스켈레톤 설정
  static SkeletonizerConfigData get dark => SkeletonizerConfigData.dark(
        effect: ShimmerEffect(
          baseColor: darkBaseColor,
          highlightColor: darkHighlightColor,
          duration: TossAnimations.loadingPulse,
        ),
        justifyMultiLineText: true,
        textBorderRadius: TextBoneBorderRadius(
          BorderRadius.circular(TossBorderRadius.xs),
        ),
      );

  // ==================== ALTERNATIVE EFFECTS ====================

  /// Pulse 효과 (shimmer 대신 깜빡임)
  ///
  /// 움직임이 적은 로딩 효과가 필요할 때 사용
  static PulseEffect get pulseEffect => PulseEffect(
        from: baseColor,
        to: highlightColor,
        duration: TossAnimations.loadingPulse,
      );

  /// Solid 효과 (애니메이션 없음)
  ///
  /// 접근성 - 움직임 감소 설정 시 사용
  static SoldColorEffect get solidEffect => SoldColorEffect(
        color: baseColor,
      );

  // ==================== HELPER METHODS ====================

  /// 사용자의 접근성 설정에 따라 적절한 효과 반환
  ///
  /// [reduceMotion]이 true면 움직임 없는 solid 효과 사용
  static PaintingEffect getEffect({bool reduceMotion = false}) {
    if (reduceMotion) {
      return solidEffect;
    }
    return ShimmerEffect(
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: TossAnimations.loadingPulse,
    );
  }

  /// 커스텀 shimmer 효과 생성
  ///
  /// 특정 색상이나 duration이 필요한 경우 사용
  static ShimmerEffect customShimmer({
    Color? base,
    Color? highlight,
    Duration? duration,
  }) {
    return ShimmerEffect(
      baseColor: base ?? baseColor,
      highlightColor: highlight ?? highlightColor,
      duration: duration ?? TossAnimations.loadingPulse,
    );
  }
}
