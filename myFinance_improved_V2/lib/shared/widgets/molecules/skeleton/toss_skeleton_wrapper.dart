import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../themes/toss_skeleton_theme.dart';

/// TossSkeletonWrapper - Skeletonizer를 Toss 디자인 시스템으로 래핑한 편의 위젯
///
/// 기존 UI를 자동으로 스켈레톤 로딩 상태로 변환합니다.
/// Mock 데이터를 사용하여 레이아웃을 유지하면서 로딩 효과를 적용합니다.
///
/// ## 기본 사용법
/// ```dart
/// TossSkeletonWrapper(
///   enabled: isLoading,
///   child: ProductTile(product: data ?? Product.mock()),
/// )
/// ```
///
/// ## Riverpod AsyncValue와 함께 사용
/// ```dart
/// asyncValue.when(
///   data: (data) => ProductTile(product: data),
///   loading: () => TossSkeletonWrapper(
///     enabled: true,
///     child: ProductTile(product: Product.mock()),
///   ),
///   error: (e, _) => ErrorView(error: e),
/// )
/// ```
///
/// ## 또는 skeleton 확장 메서드 사용
/// ```dart
/// asyncValue.skeleton(
///   builder: (data) => ProductTile(product: data),
///   mockData: Product.mock(),
/// )
/// ```
class TossSkeletonWrapper extends StatelessWidget {
  /// 스켈레톤 로딩 활성화 여부
  final bool enabled;

  /// 스켈레톤화할 자식 위젯
  final Widget child;

  /// 커스텀 페인팅 효과 (기본: shimmer)
  final PaintingEffect? effect;

  /// 컨테이너 배경색 무시 여부
  final bool ignoreContainers;

  /// 상태 전환 애니메이션 활성화
  final bool enableSwitchAnimation;

  /// 접근성: 움직임 감소 모드
  final bool reduceMotion;

  const TossSkeletonWrapper({
    super.key,
    required this.enabled,
    required this.child,
    this.effect,
    this.ignoreContainers = false,
    this.enableSwitchAnimation = true,
    this.reduceMotion = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      effect: effect ?? TossSkeletonTheme.getEffect(reduceMotion: reduceMotion),
      ignoreContainers: ignoreContainers,
      enableSwitchAnimation: enableSwitchAnimation,
      child: child,
    );
  }
}

/// Sliver용 스켈레톤 래퍼
///
/// CustomScrollView 내에서 사용할 수 있는 스켈레톤 래퍼입니다.
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     TossSliverSkeletonWrapper(
///       enabled: isLoading,
///       child: SliverList(...),
///     ),
///   ],
/// )
/// ```
class TossSliverSkeletonWrapper extends StatelessWidget {
  final bool enabled;
  final Widget child;
  final PaintingEffect? effect;
  final bool ignoreContainers;
  final bool enableSwitchAnimation;
  final bool reduceMotion;

  const TossSliverSkeletonWrapper({
    super.key,
    required this.enabled,
    required this.child,
    this.effect,
    this.ignoreContainers = false,
    this.enableSwitchAnimation = true,
    this.reduceMotion = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      enabled: enabled,
      effect: effect ?? TossSkeletonTheme.getEffect(reduceMotion: reduceMotion),
      ignoreContainers: ignoreContainers,
      child: child,
    );
  }
}

/// AsyncValue를 위한 스켈레톤 확장 메서드
///
/// Riverpod의 AsyncValue와 함께 사용하여 로딩 상태를 쉽게 처리합니다.
///
/// ```dart
/// final asyncProducts = ref.watch(productsProvider);
///
/// asyncProducts.skeleton(
///   builder: (products) => ProductList(products: products),
///   mockData: List.generate(5, (_) => Product.mock()),
/// )
/// ```
extension AsyncValueSkeletonExtension<T> on AsyncValue<T> {
  /// AsyncValue를 스켈레톤 래퍼로 변환
  ///
  /// [builder] - 데이터가 있을 때 렌더링할 위젯
  /// [mockData] - 로딩 중 레이아웃용 가짜 데이터
  /// [effect] - 커스텀 페인팅 효과
  /// [errorBuilder] - 에러 시 표시할 위젯 (기본: mockData로 스켈레톤)
  Widget skeleton({
    required Widget Function(T data) builder,
    required T mockData,
    PaintingEffect? effect,
    Widget Function(Object error, StackTrace? stack)? errorBuilder,
  }) {
    return when(
      data: (data) => TossSkeletonWrapper(
        enabled: false,
        child: builder(data),
      ),
      loading: () => TossSkeletonWrapper(
        enabled: true,
        effect: effect,
        child: builder(mockData),
      ),
      error: (error, stack) {
        if (errorBuilder != null) {
          return errorBuilder(error, stack);
        }
        // 에러 시에도 스켈레톤으로 표시 (선택적)
        return TossSkeletonWrapper(
          enabled: true,
          effect: effect,
          child: builder(mockData),
        );
      },
    );
  }

  /// 로딩/리프레시 중인지 확인하여 스켈레톤 상태 결정
  ///
  /// 기존 데이터가 있으면 유지하면서 로딩 표시
  Widget skeletonWithPreviousData({
    required Widget Function(T data) builder,
    required T mockData,
    PaintingEffect? effect,
    Widget Function(Object error, StackTrace? stack)? errorBuilder,
  }) {
    final isLoadingOrRefreshing = isLoading || isRefreshing;
    final currentData = valueOrNull ?? mockData;

    if (hasError && errorBuilder != null) {
      return errorBuilder(error!, stackTrace);
    }

    return TossSkeletonWrapper(
      enabled: isLoadingOrRefreshing && !hasValue,
      effect: effect,
      child: builder(currentData),
    );
  }
}
