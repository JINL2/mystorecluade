import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../shared/themes/toss_colors.dart';

/// Maps database icon_key strings to Lucide icons
///
/// Usage:
/// ```dart
/// // Get icon_key from database
/// String iconKey = feature['icon_key']; // e.g., "wallet"
///
/// // Get IconData
/// IconData icon = IconMapper.getIcon(iconKey);
///
/// // Use in widget
/// Icon(icon)
/// ```
class IconMapper {
  IconMapper._();

  /// Convert database icon_key string to IconData
  static IconData getIcon(String? iconKey, {String? featureName}) {
    // Only use iconKey from database - no hardcoded fallbacks
    if (iconKey == null || iconKey.isEmpty) {
      return LucideIcons.helpCircle; // Default when no data
    }

    return _getIconFromKey(iconKey);
  }

  /// Helper method to get icon from key
  static IconData _getIconFromKey(String iconKey) {
    // Map database icon_key to Lucide icons
    final iconMap = {
      // Dashboard & Analytics
      'dashboard': LucideIcons.lineChart,
      'chartLine': LucideIcons.lineChart,
      'chartLineRegular': LucideIcons.lineChart,
      'chartPie': LucideIcons.pieChart,
      'chartPieRegular': LucideIcons.pieChart,
      'chartBar': LucideIcons.barChart,

      // Store & Inventory Management
      'store': LucideIcons.store,
      'storeAlt': LucideIcons.store,
      'inventory': LucideIcons.boxes,
      'inventoryManagement': LucideIcons.boxes,
      'box': LucideIcons.box,
      'boxes': LucideIcons.boxes,
      'boxesStacked': LucideIcons.boxes,
      'warehouse': LucideIcons.warehouse,
      'qrCode': LucideIcons.qrCode,
      'qr': LucideIcons.qrCode,
      'barcode': LucideIcons.scanLine,
      'scan': LucideIcons.scanLine,

      // Sales & Shopping
      'sale': LucideIcons.tag,
      'saleProduct': LucideIcons.tags,
      'sales': LucideIcons.receipt,
      'salesInvoice': LucideIcons.fileText,
      'invoice': LucideIcons.fileText,
      'receipt': LucideIcons.receipt,
      'shopping': LucideIcons.shoppingBag,
      'shoppingBag': LucideIcons.shoppingBag,
      'shoppingCart': LucideIcons.shoppingCart,
      'cart': LucideIcons.shoppingCart,
      'tag': LucideIcons.tag,
      'tags': LucideIcons.tags,

      // Settings & Configuration
      'storeSetting': LucideIcons.settings,
      'setting': LucideIcons.settings,
      'settings': LucideIcons.settings,

      // User & Profile
      'user': LucideIcons.user,
      'userLarge': LucideIcons.user,
      'myPage': LucideIcons.user,
      'profile': LucideIcons.user,

      // Edit & Modify
      'edit': LucideIcons.edit,
      'editAlt': LucideIcons.pencil,

      // Payment & Cards
      'creditCard': LucideIcons.creditCard,
      'card': LucideIcons.creditCard,
      'payment': LucideIcons.creditCard,

      // Shopping Bag
      'bag': LucideIcons.shoppingBag,

      // Account & Mapping
      'sitemap': LucideIcons.network,
      'sitemapRegular': LucideIcons.network,
      'networkWired': LucideIcons.network,

      // Finance & Money
      'wallet': LucideIcons.wallet,
      'walletRegular': LucideIcons.wallet,
      'moneyCheckDollar': LucideIcons.banknote,
      'cashRegister': LucideIcons.calculator,
      'cashRegisterRegular': LucideIcons.calculator,
      'vault': LucideIcons.archive,
      'coins': LucideIcons.coins,
      'handHoldingDollar': LucideIcons.hand,
      'sackDollar': LucideIcons.banknote,
      'fileInvoiceDollar': LucideIcons.fileText,

      // Assets & Buildings
      'buildingColumns': LucideIcons.building,
      'building': LucideIcons.building,
      'buildingRegular': LucideIcons.building,

      // Users & Employees
      'userCircle': LucideIcons.userCircle,
      'userGear': LucideIcons.userCog,
      'userGearRegular': LucideIcons.userCog,
      'userClock': LucideIcons.userCheck,
      'userShield': LucideIcons.shieldCheck,
      'userShieldRegular': LucideIcons.shieldCheck,
      'userTag': LucideIcons.users,
      'userTagRegular': LucideIcons.users,
      'users': LucideIcons.users,
      'userTie': LucideIcons.user,
      'userRegular': LucideIcons.user,

      // Time & Schedule
      'calendarDays': LucideIcons.calendar,
      'calendarRegular': LucideIcons.calendar,
      'calendarCheck': LucideIcons.calendarCheck,
      'calendarCheckRegular': LucideIcons.calendarCheck,
      'clock': LucideIcons.clock,
      'clockRegular': LucideIcons.clock,
      'clockRotateLeft': LucideIcons.history,
      'clockRotateRegular': LucideIcons.history,
      'businessTime': LucideIcons.briefcase,
      'stopwatch': LucideIcons.timer,
      'timer': LucideIcons.timer,

      // Documents & Files
      'fileContract': LucideIcons.fileText,
      'fileSignature': LucideIcons.fileSignature,
      'fileInvoice': LucideIcons.fileText,
      'fileInvoiceRegular': LucideIcons.fileText,
      'filePen': LucideIcons.fileEdit,
      'fileLines': LucideIcons.fileText,

      // Edit & Input
      'penToSquare': LucideIcons.edit,
      'pen': LucideIcons.pencil,
      'pencil': LucideIcons.pencil,
      'editRegular': LucideIcons.edit,

      // Delete & Actions
      'trash': LucideIcons.trash2,
      'trashCan': LucideIcons.trash,
      'trashAlt': LucideIcons.trash,

      // Location & Maps
      'mapPin': LucideIcons.mapPin,
      'locationDot': LucideIcons.mapPin,
      'mapLocation': LucideIcons.map,
      'mapLocationRegular': LucideIcons.map,

      // Settings & Management
      'gear': LucideIcons.settings,
      'gears': LucideIcons.settings,
      'sliders': LucideIcons.sliders,
      'slidersH': LucideIcons.sliders,
      'wrench': LucideIcons.wrench,
      'screwdriver': LucideIcons.wrench,
      'screwdriverWrench': LucideIcons.wrench,
      'toolbox': LucideIcons.wrench,

      // Permissions & Roles
      'userShieldAlt': LucideIcons.shieldCheck,
      'shieldHalved': LucideIcons.shield,
      'shieldHeart': LucideIcons.shieldCheck,
      'shield': LucideIcons.shield,
      'lock': LucideIcons.lock,
      'lockOpen': LucideIcons.lock,
      'unlock': LucideIcons.unlock,
      'key': LucideIcons.key,
      'fingerprint': LucideIcons.fingerprint,

      // Team & Organization
      'usersGear': LucideIcons.users,
      'peopleGroup': LucideIcons.users,
      'peopleLine': LucideIcons.users,
      'peopleArrows': LucideIcons.users,
      'userGroup': LucideIcons.users,
      'usersLine': LucideIcons.users,

      // Additional Documents
      'fileCircleCheck': LucideIcons.fileCheck,
      'fileCirclePlus': LucideIcons.filePlus,
      'fileShield': LucideIcons.fileText,
      'folder': LucideIcons.folder,
      'folderOpen': LucideIcons.folderOpen,
      'folderTree': LucideIcons.folderTree,

      // Notifications & Communication
      'bell': LucideIcons.bell,
      'BellRing': LucideIcons.bellRing,
      'bellRing': LucideIcons.bellRing,
      'bellSlash': LucideIcons.bellOff,
      'envelope': LucideIcons.mail,
      'envelopeOpen': LucideIcons.mailOpen,
      'message': LucideIcons.messageSquare,
      'comment': LucideIcons.messageCircle,
      'comments': LucideIcons.messageSquare,
      'inbox': LucideIcons.inbox,

      // Status & Actions
      'check': LucideIcons.check,
      'checkCircle': LucideIcons.checkCircle,
      'checkDouble': LucideIcons.checkCheck,
      'xmark': LucideIcons.x,
      'ban': LucideIcons.ban,
      'exclamation': LucideIcons.alertCircle,
      'exclamationCircle': LucideIcons.alertCircle,
      'exclamationTriangle': LucideIcons.alertTriangle,
      'circle': LucideIcons.circle,
      'circleDot': LucideIcons.circleDot,

      // Other
      'handshake': LucideIcons.heartHandshake,
      'handshakeRegular': LucideIcons.heartHandshake,
      'wand': LucideIcons.wand2,
      'flask': LucideIcons.flaskConical,
      'flaskRegular': LucideIcons.flaskConical,
      'circleQuestion': LucideIcons.helpCircle,
      'question': LucideIcons.helpCircle,
      'info': LucideIcons.info,
      'infoCircle': LucideIcons.info,
      'infoCircleRegular': LucideIcons.info,

      // Chevron & Navigation
      'chevronDown': LucideIcons.chevronDown,
      'chevronUp': LucideIcons.chevronUp,
      'chevronLeft': LucideIcons.chevronLeft,
      'chevronRight': LucideIcons.chevronRight,
      'angleDown': LucideIcons.chevronDown,
      'angleUp': LucideIcons.chevronUp,
      'angleLeft': LucideIcons.chevronLeft,
      'angleRight': LucideIcons.chevronRight,
      'caretDown': LucideIcons.chevronDown,
      'caretUp': LucideIcons.chevronUp,

      // History & Transactions
      'history': LucideIcons.history,
      'transactionHistory': LucideIcons.history,

      // ✅ Lucide native names (snake_case from database)
      'user_round_cog': LucideIcons.userCog,
      'clock_8': LucideIcons.clock,
      'calendar_check': LucideIcons.calendarCheck,
      'hand_coins': LucideIcons.coins, // Changed from hand to coins for Cash Ending
      'pen_line': LucideIcons.pencil,
      'credit_card': LucideIcons.creditCard,
      'file_text': LucideIcons.fileText,
      'scale': LucideIcons.scale,
      'map_pin': LucideIcons.mapPin,
      'shopping_bag': LucideIcons.shoppingBag,
      'package': LucideIcons.package,
      'line_chart': LucideIcons.lineChart,
      'circle_help': LucideIcons.helpCircle,
      'bar_chart_3': LucideIcons.barChart3,
    };

    // Return mapped icon or default
    final result = iconMap[iconKey];

    if (result == null) {
      print('⚠️ WARNING: No mapping found for iconKey="$iconKey"');
      print('→ Add this to icon_mapper.dart:');
      print('   \'$iconKey\': LucideIcons.yourIcon,');
      return LucideIcons.helpCircle;
    }

    return result;
  }

  /// Get color for icon based on category
  static Color getIconColor(String? iconKey) {
    if (iconKey == null || iconKey.isEmpty) {
      return TossColors.gray500;
    }

    // Category-based color mapping
    final colorMap = {
      // Finance - Green
      'wallet': TossColors.success,
      'moneyCheckDollar': TossColors.success,
      'cashRegister': TossColors.success,
      'vault': TossColors.success,
      'coins': TossColors.success,
      'handHoldingDollar': TossColors.success,
      'sackDollar': TossColors.success,
      'fileInvoiceDollar': TossColors.success,

      // Charts & Analytics - Blue
      'dashboard': TossColors.primary,
      'chartLine': TossColors.primary,
      'chartPie': TossColors.primary,
      'chartBar': TossColors.primary,

      // Users - Orange
      'userCircle': TossColors.warning,
      'userGear': TossColors.warning,
      'userClock': TossColors.warning,
      'userShield': TossColors.warning,
      'userTag': TossColors.warning,

      // Time - Purple
      'calendarDays': TossColors.primary,
      'calendarCheck': TossColors.primary,
      'clock': TossColors.primary,
      'clockRotateLeft': TossColors.primary,
      'businessTime': TossColors.primary,

      // Documents - Teal
      'fileContract': TossColors.success,
      'fileSignature': TossColors.success,
      'fileInvoice': TossColors.success,
      'filePen': TossColors.success,

      // Default
      'default': TossColors.gray500,
    };

    return colorMap[iconKey] ?? TossColors.gray500;
  }

  /// Get all available icon keys (for debugging)
  static List<String> getAllIconKeys() {
    return [
      'dashboard', 'chartLine', 'chartPie', 'chartBar',
      'sitemap', 'networkWired',
      'wallet', 'moneyCheckDollar', 'cashRegister', 'vault', 'coins',
      'handHoldingDollar', 'sackDollar', 'fileInvoiceDollar',
      'buildingColumns', 'building', 'warehouse',
      'userCircle', 'userGear', 'userClock', 'userShield', 'userTag',
      'calendarDays', 'calendarCheck', 'clock', 'clockRotateLeft', 'businessTime',
      'fileContract', 'fileSignature', 'fileInvoice', 'filePen',
      'penToSquare', 'pen', 'pencil',
      'mapPin', 'locationDot', 'mapLocation',
      'handshake', 'wand', 'flask', 'gear', 'gears',
      'circleQuestion', 'question', 'info', 'infoCircle',
    ];
  }
}

/// Convenient icon widget - Toss-style with perfect centering
class DynamicIcon extends StatelessWidget {
  final String? iconKey;
  final String? featureName;
  final double? size;
  final Color? color;
  final bool useDefaultColor;

  const DynamicIcon({
    super.key,
    required this.iconKey,
    this.featureName,
    this.size = 24,
    this.color,
    this.useDefaultColor = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = IconMapper.getIcon(iconKey, featureName: featureName);
    // Ensure color is properly applied
    final iconColor = color ??
                      (useDefaultColor ? IconMapper.getIconColor(iconKey) : Theme.of(context).iconTheme.color);

    return Center(
      child: Icon(
        iconData,
        size: size,
        color: iconColor,
      ),
    );
  }
}
