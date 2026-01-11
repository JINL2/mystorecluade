import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../themes/toss_border_radius.dart';
import '../../../themes/toss_colors.dart';
import '../../../themes/toss_spacing.dart';
import '../../../themes/toss_text_styles.dart';

/// 스켈레톤 프리셋 - 공통 UI 패턴을 위한 Bone 위젯 조합
///
/// Skeletonizer의 Bone 위젯을 활용하여 자주 사용되는 UI 패턴의
/// 스켈레톤 레이아웃을 제공합니다.
///
/// ## 사용 시나리오
///
/// ### 1. 자동 스켈레톤화가 어려운 경우
/// 동적 레이아웃이나 조건부 렌더링이 많아 mock 데이터로 레이아웃을 잡기 어려울 때
///
/// ### 2. 수동 스켈레톤이 필요한 경우
/// 특정 형태의 스켈레톤을 명시적으로 표시하고 싶을 때
///
/// ## 사용법
/// ```dart
/// Skeletonizer(
///   enabled: true,
///   child: ListView.builder(
///     itemCount: 5,
///     itemBuilder: (_, __) => SkeletonPresets.listItem(),
///   ),
/// )
/// ```
class SkeletonPresets {
  SkeletonPresets._();

  // ==================== LIST ITEMS ====================

  /// 기본 리스트 아이템 스켈레톤
  ///
  /// [○ 아바타] [제목 ████████]
  ///           [부제목 ████]
  static Widget listItem({
    double avatarSize = 48,
    int titleWords = 4,
    int subtitleWords = 6,
    EdgeInsets? padding,
  }) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: TossSpacing.paddingMD,
            vertical: TossSpacing.space3,
          ),
      child: Row(
        children: [
          Bone.circle(size: avatarSize),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: titleWords),
                const SizedBox(height: TossSpacing.space1),
                Bone.text(words: subtitleWords),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 컴팩트 리스트 아이템 (작은 아바타)
  static Widget listItemCompact({
    EdgeInsets? padding,
  }) {
    return listItem(
      avatarSize: 32,
      titleWords: 3,
      subtitleWords: 4,
      padding: padding,
    );
  }

  // ==================== PRODUCT CARDS ====================

  /// 제품 카드 스켈레톤
  ///
  /// [□ 이미지] [제품명 ████]
  ///           [SKU ████████]
  ///           [가격 ████]    [+]
  static Widget productCard({
    double imageSize = 56,
    bool showButton = true,
    EdgeInsets? padding,
  }) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: TossSpacing.paddingMD,
            vertical: TossSpacing.space3,
          ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray100, width: 1),
        ),
      ),
      child: Row(
        children: [
          Bone.square(
            size: imageSize,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 3),
                const SizedBox(height: TossSpacing.space1),
                Bone.text(words: 2),
                const SizedBox(height: TossSpacing.space1),
                Bone.text(words: 2),
              ],
            ),
          ),
          if (showButton) ...[
            const SizedBox(width: TossSpacing.space3),
            Bone.square(size: 36, borderRadius: BorderRadius.circular(TossBorderRadius.md)),
          ],
        ],
      ),
    );
  }

  /// 제품 그리드 아이템 스켈레톤
  static Widget productGridItem({
    double imageHeight = 120,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.square(
            size: imageHeight,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 2),
                const SizedBox(height: TossSpacing.space1),
                Bone.text(words: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== TRANSACTION ITEMS ====================

  /// 거래 내역 아이템 스켈레톤
  ///
  /// [○] [거래처명 ████]      [금액 ████]
  ///     [날짜 ████]         [상태 ██]
  static Widget transactionItem({
    EdgeInsets? padding,
  }) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: TossSpacing.paddingMD,
            vertical: TossSpacing.space3,
          ),
      child: Row(
        children: [
          Bone.circle(size: 40),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 3),
                const SizedBox(height: TossSpacing.space1),
                Bone.text(words: 2),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Bone.text(words: 2),
              const SizedBox(height: TossSpacing.space1),
              Bone.text(words: 1),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== SUMMARY CARDS ====================

  /// 요약 카드 스켈레톤 (대시보드용)
  ///
  /// ┌────────────────┐
  /// │ 라벨 ██        │
  /// │ 값 ████████    │
  /// │ 부가정보 ████   │
  /// └────────────────┘
  static Widget summaryCard({
    double? width,
    double? height,
  }) {
    return Container(
      width: width ?? 140,
      height: height,
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Bone.text(words: 1),
          const SizedBox(height: TossSpacing.space2),
          Bone.text(
            words: 2,
            style: TossTextStyles.h4,
          ),
          const SizedBox(height: TossSpacing.space1),
          Bone.text(words: 2),
        ],
      ),
    );
  }

  /// 통계 카드 스켈레톤 (큰 숫자 + 라벨)
  static Widget statsCard({
    double? width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(TossSpacing.paddingLG),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.text(words: 2),
          const SizedBox(height: TossSpacing.space3),
          Bone.text(
            words: 1,
            style: TossTextStyles.h2,
          ),
        ],
      ),
    );
  }

  // ==================== CHARTS ====================

  /// 차트 플레이스홀더 스켈레톤
  static Widget chartPlaceholder({
    double height = 200,
    double? width,
  }) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: const Center(
        child: Bone.icon(size: 48),
      ),
    );
  }

  // ==================== HEADERS ====================

  /// 섹션 헤더 스켈레톤
  static Widget sectionHeader({
    bool showAction = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.paddingMD,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Bone.text(words: 2),
          if (showAction) Bone.text(words: 1),
        ],
      ),
    );
  }

  /// 페이지 타이틀 스켈레톤
  static Widget pageTitle() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.text(
            words: 3,
            style: TossTextStyles.h2,
          ),
          const SizedBox(height: TossSpacing.space2),
          Bone.text(words: 6),
        ],
      ),
    );
  }

  // ==================== FORM FIELDS ====================

  /// 입력 필드 스켈레톤
  static Widget inputField({
    bool showLabel = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel) ...[
            Bone.text(words: 2),
            const SizedBox(height: TossSpacing.space2),
          ],
          Container(
            height: TossSpacing.inputHeightMD,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.input),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== BUTTONS ====================

  /// 버튼 스켈레톤
  static Widget button({
    double? width,
    double height = 48,
  }) {
    return Bone.square(
      size: height,
      borderRadius: BorderRadius.circular(TossBorderRadius.button),
    );
  }

  /// 칩 그룹 스켈레톤
  static Widget chipGroup({
    int count = 4,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD),
      child: Row(
        children: List.generate(
          count,
          (index) => Padding(
            padding: const EdgeInsets.only(right: TossSpacing.space2),
            child: Bone.square(
              size: 32,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),
        ),
      ),
    );
  }
}
