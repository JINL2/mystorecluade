import 'package:flutter/material.dart';

import 'toss_border_radius.dart';
import 'toss_colors.dart';
import 'toss_spacing.dart';

/// ============================================================================
/// TOSS ANIMATION SYSTEM - Design Guideline & Implementation
/// ============================================================================
///
/// ## 핵심 원칙
/// - 200-250ms가 대부분의 전환에 적합한 "sweet spot"
/// - 바운스 효과 사용 금지 (프로페셔널한 느낌 유지)
/// - 진입: ease-out, 퇴장: ease-in
/// - 일관된 타이밍으로 리듬감 부여
/// - 마이크로 인터랙션은 50-100ms
///
/// ## 언제 어떤 애니메이션을 적용해야 하는가?
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │ 상황                        │ 사용할 애니메이션          │ Duration    │
/// ├─────────────────────────────────────────────────────────────────────────┤
/// │ 버튼 누르기                  │ TossAnimations.fast       │ 150ms      │
/// │ 칩/토글 선택                 │ TossAnimations.fast       │ 150ms      │
/// │ 섹션 펼치기/접기 아이콘 회전  │ TossAnimations.fast       │ 150ms      │
/// │ 섹션 내용 펼치기/접기        │ TossAnimations.fast       │ 150ms      │
/// │ 카드 호버/프레스             │ TossAnimations.normal     │ 200ms      │
/// │ 일반 상태 변화               │ TossAnimations.normal     │ 200ms      │
/// │ 탭 전환                     │ TossAnimations.medium     │ 250ms      │
/// │ 페이지 전환                  │ TossAnimations.medium     │ 250ms      │
/// │ 바텀시트 열기/닫기           │ TossAnimations.medium     │ 250ms      │
/// │ 복잡한 전환                  │ TossAnimations.slow       │ 300ms      │
/// │ 주요 장면 변경               │ TossAnimations.slower     │ 400ms      │
/// └─────────────────────────────────────────────────────────────────────────┘
///
/// ## 위젯별 적용 가이드
///
/// ### 1. Expandable Section (펼치기/접기 섹션)
/// ```dart
/// // 아이콘 회전
/// AnimatedRotation(
///   turns: isExpanded ? 0.25 : 0,  // 90도 회전
///   duration: TossAnimations.fast,
///   child: Icon(Icons.chevron_right),
/// )
///
/// // 내용 펼치기
/// AnimatedCrossFade(
///   duration: TossAnimations.fast,
///   crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
///   firstChild: expandedContent,
///   secondChild: const SizedBox.shrink(),
/// )
/// ```
///
/// ### 2. Selection Chip (선택 칩)
/// ```dart
/// AnimatedContainer(
///   duration: TossAnimations.fast,
///   decoration: BoxDecoration(
///     color: isSelected ? TossColors.gray900 : TossColors.gray100,
///     borderRadius: BorderRadius.circular(TossBorderRadius.full),
///   ),
///   child: Text(label, style: ...),
/// )
/// ```
///
/// ### 3. Tab Bar
/// ```dart
/// TabBar(
///   indicator: BoxDecoration(
///     color: TossColors.white,
///     borderRadius: BorderRadius.circular(TossBorderRadius.md),
///   ),
///   // TabController가 자동으로 애니메이션 처리
/// )
/// ```
///
/// ### 4. Bottom Sheet
/// ```dart
/// showModalBottomSheet(
///   transitionAnimationController: AnimationController(
///     duration: TossAnimations.medium,
///     vsync: this,
///   ),
/// )
/// ```
///
/// ### 5. Loading State
/// ```dart
/// AnimatedSwitcher(
///   duration: TossAnimations.normal,
///   child: isLoading ? TossLoadingIndicator() : content,
/// )
/// ```
///
/// ## 마이그레이션 체크리스트
///
/// 기존 코드에서 다음을 찾아 교체:
/// - `Duration(milliseconds: 150)` → `TossAnimations.fast`
/// - `Duration(milliseconds: 200)` → `TossAnimations.normal`
/// - `Duration(milliseconds: 250)` → `TossAnimations.medium`
/// - `Duration(milliseconds: 300)` → `TossAnimations.slow`
/// - `Curves.easeInOut` → `TossAnimations.standard`
/// - `Curves.easeOut` → `TossAnimations.decelerate`
///
/// ============================================================================

class TossAnimations {
  TossAnimations._();

  // ==================== DURATION CONSTANTS ====================
  // Toss uses consistent, predictable timing

  /// Instant (50ms) - 즉각적인 피드백
  /// 사용: 터치 피드백, 즉시 반응이 필요한 경우
  static const Duration instant = Duration(milliseconds: 50);

  /// Quick (100ms) - 마이크로 인터랙션
  /// 사용: 아주 빠른 상태 변화, 체크박스 토글
  static const Duration quick = Duration(milliseconds: 100);

  /// Fast (150ms) - 버튼 누르기, 호버, 칩 선택, 섹션 펼치기/접기 ⭐
  /// 사용: 버튼 프레스, 선택 칩, expandable section, 아이콘 회전
  static const Duration fast = Duration(milliseconds: 150);

  /// Normal (200ms) - 기본 애니메이션 ⭐
  /// 사용: 카드 상태 변화, 일반적인 UI 전환, 로딩 상태 전환
  static const Duration normal = Duration(milliseconds: 200);

  /// Medium (250ms) - 페이지/탭 전환 ⭐
  /// 사용: 페이지 네비게이션, 탭 전환, 바텀시트
  static const Duration medium = Duration(milliseconds: 250);

  /// Slow (300ms) - 복잡한 전환
  /// 사용: 다중 요소가 함께 움직이는 전환
  static const Duration slow = Duration(milliseconds: 300);

  /// Slower (400ms) - 주요 장면 변경
  /// 사용: 온보딩 화면 전환, 대규모 레이아웃 변경
  static const Duration slower = Duration(milliseconds: 400);

  // ==================== LOADING DURATION CONSTANTS ====================

  /// 로딩 펄스 애니메이션 (스켈레톤용)
  /// 사용: 스켈레톤 shimmer 효과
  static const Duration loadingPulse = Duration(milliseconds: 1200);

  /// 로딩 스피너 한 바퀴 (원형 인디케이터)
  /// 사용: CircularProgressIndicator 회전
  static const Duration loadingRotation = Duration(milliseconds: 1500);

  /// 디바운스 딜레이 (검색 입력)
  /// 사용: 검색 입력 후 API 호출 대기
  static const Duration debounceDelay = Duration(milliseconds: 300);

  /// 스낵바/토스트 표시 시간
  /// 사용: Toast, SnackBar 자동 닫기
  static const Duration toastDuration = Duration(seconds: 3);

  /// 다이얼로그 등장 애니메이션 (600ms)
  /// 사용: TossDialog 등장 시
  static const Duration dialogEnter = Duration(milliseconds: 600);

  /// 아이콘 강조 애니메이션 (800ms)
  /// 사용: 다이얼로그 아이콘 등장
  static const Duration iconEmphasis = Duration(milliseconds: 800);

  /// 타이핑 인디케이터 애니메이션 (600ms)
  /// 사용: AI 타이핑 인디케이터 도트 애니메이션
  static const Duration typingDot = Duration(milliseconds: 600);

  // ==================== CURVE CONSTANTS ====================
  // Toss avoids bouncy effects for professional feel

  /// Standard curve - Smooth and professional ⭐
  /// 사용: 대부분의 애니메이션에 기본 적용
  static const Curve standard = Curves.easeInOutCubic;

  /// Enter curve - Smooth deceleration ⭐
  /// 사용: 요소가 화면에 진입할 때
  static const Curve enter = Curves.easeOutCubic;

  /// Exit curve - Smooth acceleration
  /// 사용: 요소가 화면에서 퇴장할 때
  static const Curve exit = Curves.easeInCubic;

  /// Emphasis curve - Slight overshoot (no bounce)
  /// 사용: 강조가 필요한 애니메이션
  static const Curve emphasis = Curves.fastOutSlowIn;

  /// Linear - Constant speed (progress bars)
  /// 사용: 프로그레스 바, 로딩 인디케이터
  static const Curve linear = Curves.linear;

  /// Accelerate - Speed up gradually
  /// 사용: 퇴장 애니메이션
  static const Curve accelerate = Curves.easeIn;

  /// Decelerate - Slow down gradually ⭐
  /// 사용: 진입 애니메이션
  static const Curve decelerate = Curves.easeOut;

  /// Sharp - Quick response
  /// 사용: 즉각적인 반응이 필요할 때
  static const Curve sharp = Curves.easeOutExpo;

  /// NO BOUNCE - Toss doesn't use elasticOut or bounceOut
  /// 바운스 효과는 프로페셔널하지 않으므로 사용 금지

  // ==================== EXPANDABLE SECTION ====================
  // 펼치기/접기 섹션에 사용 (balance_sheet 스타일)

  /// Expandable 섹션의 chevron 아이콘 회전 위젯
  ///
  /// 사용 예:
  /// ```dart
  /// TossAnimations.expandIcon(
  ///   isExpanded: _isExpanded,
  ///   child: Icon(Icons.chevron_right, size: 20, color: TossColors.gray400),
  /// )
  /// ```
  static Widget expandIcon({
    required bool isExpanded,
    required Widget child,
  }) {
    return AnimatedRotation(
      turns: isExpanded ? 0.25 : 0,
      duration: fast,
      child: child,
    );
  }

  /// Expandable 섹션의 내용 펼치기/접기 위젯
  ///
  /// 사용 예:
  /// ```dart
  /// TossAnimations.expandContent(
  ///   isExpanded: _isExpanded,
  ///   child: _buildExpandedContent(),
  /// )
  /// ```
  static Widget expandContent({
    required bool isExpanded,
    required Widget child,
  }) {
    return AnimatedCrossFade(
      duration: fast,
      crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: child,
      secondChild: const SizedBox.shrink(),
      sizeCurve: decelerate,
    );
  }

  // ==================== SELECTION CHIP ====================
  // 선택 칩/토글에 사용 (period_selector 스타일)

  /// 선택 칩 데코레이션 (AnimatedContainer와 함께 사용)
  ///
  /// 사용 예:
  /// ```dart
  /// AnimatedContainer(
  ///   duration: TossAnimations.fast,
  ///   padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2),
  ///   decoration: TossAnimations.selectionChipDecoration(isSelected: isSelected),
  ///   child: Text(label),
  /// )
  /// ```
  static BoxDecoration selectionChipDecoration({
    required bool isSelected,
    Color? selectedColor,
    Color? unselectedColor,
  }) {
    return BoxDecoration(
      color: isSelected
          ? (selectedColor ?? TossColors.gray900)
          : (unselectedColor ?? TossColors.gray100),
      borderRadius: BorderRadius.circular(TossBorderRadius.full),
    );
  }

  /// 선택 칩 전체 위젯 (간편 사용)
  ///
  /// 사용 예:
  /// ```dart
  /// TossAnimations.selectionChip(
  ///   label: 'Today',
  ///   isSelected: selectedPeriod == QuickPeriod.today,
  ///   onTap: () => onPeriodChanged(QuickPeriod.today),
  /// )
  /// ```
  static Widget selectionChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? selectedColor,
    Color? unselectedColor,
    Color? selectedTextColor,
    Color? unselectedTextColor,
    EdgeInsets? padding,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: fast,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: selectionChipDecoration(
          isSelected: isSelected,
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (selectedTextColor ?? TossColors.white)
                : (unselectedTextColor ?? TossColors.gray600),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ==================== TAB INDICATOR ====================
  // 탭바 인디케이터 스타일 (financial_statements_page 스타일)

  /// Toss 스타일 탭 인디케이터 데코레이션
  ///
  /// 사용 예:
  /// ```dart
  /// TabBar(
  ///   indicator: TossAnimations.tabIndicatorDecoration(),
  ///   indicatorSize: TabBarIndicatorSize.tab,
  ///   indicatorPadding: EdgeInsets.all(TossSpacing.space1 - 1),
  ///   ...
  /// )
  /// ```
  static BoxDecoration tabIndicatorDecoration() {
    return BoxDecoration(
      color: TossColors.white,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      boxShadow: [
        BoxShadow(
          color: TossColors.black.withValues(alpha: 0.06),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  /// 탭바 배경 컨테이너 데코레이션
  static BoxDecoration tabBarBackgroundDecoration() {
    return BoxDecoration(
      color: TossColors.gray100,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
    );
  }

  // ==================== COMMON TRANSITIONS ====================

  /// Fade transition for smooth opacity changes
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Slide transition from bottom (sheets, modals)
  static Widget slideFromBottom({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: enter,
      ),),
      child: child,
    );
  }

  /// Slide transition from right (page navigation)
  static Widget slideFromRight({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: standard,
      ),),
      child: child,
    );
  }

  /// Scale transition for emphasis
  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
    double beginScale = 0.8,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: beginScale,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: enter,
      ),),
      child: fadeTransition(child: child, animation: animation),
    );
  }

  // ==================== MICRO INTERACTIONS ====================

  /// Button press scale animation
  static AnimationController createButtonController(TickerProvider vsync) {
    return AnimationController(
      duration: fast,
      vsync: vsync,
    );
  }

  /// Card hover/press animation
  static AnimationController createCardController(TickerProvider vsync) {
    return AnimationController(
      duration: normal,
      vsync: vsync,
    );
  }

  /// List item animation controller
  static AnimationController createListItemController(TickerProvider vsync) {
    return AnimationController(
      duration: medium,
      vsync: vsync,
    );
  }

  // ==================== PAGE ROUTE TRANSITIONS ====================

  /// Toss-style page route with slide and fade
  static PageRouteBuilder<T> pageRoute<T>({
    required Widget Function(BuildContext, Animation<double>, Animation<double>) pageBuilder,
    Duration duration = medium,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: pageBuilder,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(
          tween.chain(CurveTween(curve: standard)),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// Bottom sheet route animation
  static PageRouteBuilder<T> bottomSheetRoute<T>({
    required Widget Function(BuildContext) builder,
    Duration duration = medium,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionDuration: duration,
      reverseTransitionDuration: normal,
      barrierDismissible: true,
      barrierColor: TossColors.overlay,
      opaque: false,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return slideFromBottom(
          animation: animation,
          child: child,
        );
      },
    );
  }

  // ==================== STAGGER ANIMATIONS ====================

  /// Creates staggered animation intervals for lists
  static List<Interval> createStaggerIntervals(int itemCount, {double delay = 0.05}) {
    return List.generate(itemCount, (index) {
      final start = index * delay;
      final end = start + 0.5;
      return Interval(
        start.clamp(0.0, 1.0),
        end.clamp(0.0, 1.0),
        curve: enter,
      );
    });
  }

  // ==================== ANIMATED WIDGETS ====================

  /// Animated container with Toss defaults
  static Widget animatedContainer({
    required Widget child,
    Duration duration = normal,
    Curve curve = standard,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Decoration? decoration,
    double? width,
    double? height,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      margin: margin,
      decoration: decoration,
      width: width,
      height: height,
      child: child,
    );
  }

  /// Animated opacity with Toss defaults
  static Widget animatedOpacity({
    required Widget child,
    required double opacity,
    Duration duration = normal,
    Curve curve = standard,
  }) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  /// Animated scale with Toss defaults
  static Widget animatedScale({
    required Widget child,
    required double scale,
    Duration duration = normal,
    Curve curve = standard,
  }) {
    return AnimatedScale(
      scale: scale,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  /// Animated slide with Toss defaults
  static Widget animatedSlide({
    required Widget child,
    required Offset offset,
    Duration duration = normal,
    Curve curve = standard,
  }) {
    return AnimatedSlide(
      offset: offset,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  // ==================== LOADING ANIMATIONS ====================

  /// Toss-style shimmer effect for loading states
  static LinearGradient shimmerGradient = const LinearGradient(
    colors: [
      TossColors.gray300,
      TossColors.gray100,
      TossColors.gray300,
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );

  /// Pulse animation for loading indicators
  static Animation<double> createPulseAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ),);
  }

  // ==================== GESTURE ANIMATIONS ====================

  /// Creates a tap scale animation
  static Animation<double> createTapAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ),);
  }

  /// Creates a long press scale animation
  static Animation<double> createLongPressAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ),);
  }

  /// Creates a swipe animation
  static Animation<Offset> createSwipeAnimation(
    AnimationController controller,
    Offset begin,
    Offset end,
  ) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ),);
  }

  // ==================== SCROLL ANIMATIONS ====================

  /// Fade in on scroll animation
  static Widget fadeInOnScroll({
    required Widget child,
    required ScrollController scrollController,
    double triggerOffset = 100,
  }) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final offset = scrollController.hasClients
            ? scrollController.offset
            : 0.0;
        final opacity = (offset / triggerOffset).clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
    );
  }

  /// Parallax scroll effect
  static Widget parallaxScroll({
    required Widget child,
    required ScrollController scrollController,
    double speed = 0.5,
  }) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final offset = scrollController.hasClients
            ? scrollController.offset * speed
            : 0.0;

        return Transform.translate(
          offset: Offset(0, -offset),
          child: child,
        );
      },
    );
  }
}

// ============================================================================
// REUSABLE ANIMATED WIDGETS
// ============================================================================

/// Toss-style animated widget wrapper for micro-interactions
class TossAnimatedWidget extends StatefulWidget {
  final Widget child;
  final bool enableTap;
  final bool enableHover;
  final VoidCallback? onTap;
  final Duration duration;
  final Curve curve;

  const TossAnimatedWidget({
    super.key,
    required this.child,
    this.enableTap = true,
    this.enableHover = false,
    this.onTap,
    this.duration = TossAnimations.quick,
    this.curve = TossAnimations.standard,
  });

  @override
  State<TossAnimatedWidget> createState() => _TossAnimatedWidgetState();
}

class _TossAnimatedWidgetState extends State<TossAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enableTap ? (_) => _controller.forward() : null,
      onTapUp: widget.enableTap ? (_) {
        _controller.reverse();
        widget.onTap?.call();
      } : null,
      onTapCancel: widget.enableTap ? () => _controller.reverse() : null,
      child: MouseRegion(
        onEnter: widget.enableHover ? (_) => _controller.forward() : null,
        onExit: widget.enableHover ? (_) => _controller.reverse() : null,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Toss-style Expandable Section Widget
///
/// 사용 예:
/// ```dart
/// TossExpandableSection(
///   title: 'Account Details',
///   trailing: Text('3 items'),
///   initiallyExpanded: false,
///   children: [
///     _buildAccountRow('Cash', 1000),
///     _buildAccountRow('Bank', 5000),
///   ],
/// )
/// ```
class TossExpandableSection extends StatefulWidget {
  final String title;
  final Widget? trailing;
  final List<Widget> children;
  final bool initiallyExpanded;
  final EdgeInsets? titlePadding;
  final EdgeInsets? contentPadding;
  final Color? expandedBackgroundColor;
  final VoidCallback? onExpansionChanged;

  const TossExpandableSection({
    super.key,
    required this.title,
    this.trailing,
    required this.children,
    this.initiallyExpanded = false,
    this.titlePadding,
    this.contentPadding,
    this.expandedBackgroundColor,
    this.onExpansionChanged,
  });

  @override
  State<TossExpandableSection> createState() => _TossExpandableSectionState();
}

class _TossExpandableSectionState extends State<TossExpandableSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onExpansionChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        InkWell(
          onTap: _toggleExpansion,
          child: Padding(
            padding: widget.titlePadding ?? const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            child: Row(
              children: [
                // Expand icon with rotation animation
                TossAnimations.expandIcon(
                  isExpanded: _isExpanded,
                  child: const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: TossColors.gray400,
                  ),
                ),

                const SizedBox(width: TossSpacing.space2),

                // Title
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),

                // Trailing widget
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
          ),
        ),

        // Content with expand/collapse animation
        TossAnimations.expandContent(
          isExpanded: _isExpanded,
          child: Container(
            color: widget.expandedBackgroundColor ?? TossColors.gray50,
            padding: widget.contentPadding,
            child: Column(
              children: widget.children,
            ),
          ),
        ),

        // Divider
        Container(height: 1, color: TossColors.gray100),
      ],
    );
  }
}

/// Toss-style Selection Chip Group
///
/// 사용 예:
/// ```dart
/// TossSelectionChipGroup<QuickPeriod>(
///   items: [
///     (QuickPeriod.today, 'Today'),
///     (QuickPeriod.week, 'Week'),
///     (QuickPeriod.month, 'Month'),
///   ],
///   selectedValue: selectedPeriod,
///   onChanged: (value) => setState(() => selectedPeriod = value),
/// )
/// ```
class TossSelectionChipGroup<T> extends StatelessWidget {
  final List<(T, String)> items;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final EdgeInsets? padding;
  final double spacing;

  const TossSelectionChipGroup({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.padding,
    this.spacing = TossSpacing.space2,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : spacing),
            child: TossAnimations.selectionChip(
              label: item.$2,
              isSelected: selectedValue == item.$1,
              onTap: () => onChanged(item.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}
