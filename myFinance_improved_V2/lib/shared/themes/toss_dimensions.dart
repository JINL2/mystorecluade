import 'package:flutter/material.dart';

import 'toss_spacing.dart';

/// Toss Dimensions System - Component-Specific Size Tokens
///
/// Provides standardized dimensions for common UI components
/// that don't fit into the spacing system.
///
/// Design Philosophy:
/// - Consistent component sizes across the app
/// - Semantic naming for clarity
/// - Single source of truth for component dimensions
class TossDimensions {
  TossDimensions._();

  // ==================== DRAG HANDLE ====================
  // Standard bottom sheet drag handle dimensions

  static const double dragHandleWidth = 40.0;
  static const double dragHandleHeight = 4.0;

  /// Standard drag handle margin (top: 12, bottom: 8)
  static const EdgeInsets dragHandleMargin = EdgeInsets.only(
    top: TossSpacing.space3,
    bottom: TossSpacing.space2,
  );

  // ==================== DIVIDERS ====================

  static const double dividerThickness = 1.0;
  static const double dividerThicknessThin = 0.5;
  static const double dividerThicknessMedium = 1.5;  // Medium border (status indicators)
  static const double dividerThicknessBold = 2.0;    // Bold border (focused inputs)
  static const double dividerHeight = 20.0;    // Default divider height
  static const double dividerHeightSM = 24.0;
  static const double dividerHeightMD = 32.0;
  static const double dividerHeightLG = 40.0;
  static const double dividerHeightXL = 50.0;

  // ==================== TIMELINE ====================
  // Timeline component specific dimensions

  static const double timelineDateCircle = 32.0;
  static const double timelineIndicatorCircle = 24.0;
  static const double timelineLineWidth = 2.0;
  static const double timelineDot = 8.0;
  static const double timelineDotSmall = 6.0;
  static const double timelineConnectorWidth = 1.0;
  static const double timelineConnectorHeight = 16.0;

  // ==================== AVATAR SIZES ====================
  // Profile picture and avatar dimensions

  static const double avatarXXS = 20.0;
  static const double avatarXS = 24.0;
  static const double avatarSM = 28.0;
  static const double avatarMD = 32.0;
  static const double avatarMD2 = 36.0;
  static const double avatarLG = 40.0;
  static const double avatarXL = 48.0;
  static const double avatarXL2 = 52.0;
  static const double avatarXXL = 56.0;
  static const double avatar3XL = 64.0;
  static const double avatar4XL = 80.0;
  static const double avatar5XL = 90.0;   // Profile page avatar
  static const double avatarHero = 120.0; // Hero section avatar

  // Avatar radius (half of avatar size for CircleAvatar)
  static const double avatarRadius5XL = 42.0;  // For avatar5XL (90 / 2 - border)

  // ==================== RANK INDICATOR ====================

  static const double rankIndicatorWidth = 3.0;
  static const double rankNumberWidth = 28.0;
  static const double rankBadgeSize = 24.0;

  // ==================== COMPONENT HEIGHTS ====================
  // Fixed height components

  static const double statsGaugeCardHeight = 116.0;
  static const double headerHeight = 52.0;
  static const double headerHeightLarge = 56.0;
  static const double timePickerHeight = 144.0;
  static const double timePickerColumnWidth = 72.0;
  static const double timePickerItemExtent = 28.0;
  static const double timePickerSelectionHeight = 32.0;

  // ==================== BUTTON DIMENSIONS ====================
  // Specific button sizes beyond TossSpacing

  static const double buttonMinWidth = 64.0;
  static const double fabSize = 56.0;
  static const double fabSizeMini = 40.0;
  static const double closeButtonOffset = 36.0;  // Offset for close button balance

  // ==================== CARD DIMENSIONS ====================

  static const double cardMinHeight = 80.0;
  static const double cardImageHeight = 120.0;
  static const double cardImageHeightLarge = 160.0;
  static const double pricingCardHeight = 260.0;  // Subscription pricing card height

  // ==================== INPUT DIMENSIONS ====================

  static const double inputLabelWidth = 100.0;
  static const double inputLabelWidthLarge = 120.0;

  // ==================== INDICATOR DIMENSIONS ====================

  static const double progressIndicatorSize = 24.0;
  static const double progressIndicatorSizeSmall = 16.0;
  static const double progressIndicatorSizeLarge = 48.0;

  // ==================== BADGE DIMENSIONS ====================

  static const double badgeMinWidth = 18.0;
  static const double badgeHeight = 18.0;
  static const double badgeHeightSmall = 14.0;
  static const double badgeCircle = 16.0;
  static const double editBadgeSize = 28.0;       // Edit badge on avatars
  static const double editBadgeIconSize = 14.0;   // Icon inside edit badge

  // ==================== STATUS INDICATOR ====================
  // Active status dots and indicators

  static const double statusDotXS = 8.0;
  static const double statusDotSM = 10.0;
  static const double statusDotMD = 12.0;

  // ==================== EMPLOYEE CARD ====================

  static const double employeeAvatarSize = 52.0;
  static const double infoLabelWidth = 140.0;

  // ==================== NAVIGATION ====================

  static const double navBarHeight = 64.0;
  static const double tabBarHeight = 48.0;
  static const double appBarHeight = 56.0;
  static const double topBarHeight = 56.0;     // Top bar height (same as appBar)
  static const double bottomSheetMinHeight = 200.0;

  // ==================== FLOW ITEM DIMENSIONS ====================
  // Used in journal_flow_item and actual_flow_item

  static const double dateColumnWidth = 50.0;
  static const double timeColumnWidth = 50.0;

  // ==================== TRANSACTION HISTORY DIMENSIONS ====================

  static const double transactionIconSize = 26.0;
  static const double chipMaxWidthSM = 120.0;
  static const double chipMaxWidthMD = 140.0;
  static const double metadataLabelWidth = 100.0;
  static const double thumbnailSize = 64.0;
  static const double errorIconSize = 64.0;

  // ==================== PAGE INDICATOR DIMENSIONS ====================

  static const double pageIndicatorDotSize = 8.0;
  static const double pageIndicatorActiveDotWidth = 20.0;
  static const double pageIndicatorDotSpacing = 3.0;

  // ==================== IMAGE DIMENSIONS ====================

  static const double imagePreviewHeight = 200.0;
  static const double profileImageWidth = 60.0;
  static const double productImageLarge = 80.0;  // Large product image size

  // ==================== DECORATIVE ICON DIMENSIONS ====================

  static const double decorativeIconMD = 100.0;   // Medium decorative icon
  static const double decorativeIconLG = 150.0;   // Large decorative icon

  // ==================== TOUCH TARGETS ====================
  // Minimum touch target size for accessibility (WCAG 2.1)

  static const double minTouchTarget = 44.0;
  static const double minTouchTargetSmall = 36.0;

  // ==================== ROW DIMENSIONS ====================

  static const double minRowHeight = 48.0;     // Minimum row height for list items

  // ==================== LIST DIMENSIONS ====================

  static const double listBottomPadding = 100.0;  // Bottom padding for lists with FAB

  // ==================== SEMANTIC GETTERS ====================

  /// Standard gauge semicircle size
  static const Size gaugeSize = Size(160, 90);

  /// Standard drag handle size
  static const Size dragHandleSize = Size(dragHandleWidth, dragHandleHeight);
}
