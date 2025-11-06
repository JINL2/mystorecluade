import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../shared/themes/toss_colors.dart';

/// 데이터베이스의 icon_key 문자열을 Font Awesome 아이콘으로 매핑하는 클래스
/// 
/// 사용법:
/// ```dart
/// // DB에서 가져온 icon_key
/// String iconKey = feature['icon_key']; // 예: "wallet"
/// 
/// // 아이콘 가져오기
/// IconData icon = IconMapper.getIcon(iconKey);
/// 
/// // 위젯에서 사용
/// FaIcon(icon)
/// ```
class IconMapper {
  IconMapper._();

  /// DB의 icon_key 문자열을 IconData로 변환 (순수 데이터 기반)
  static IconData getIcon(String? iconKey, {String? featureName}) {
    // Only use iconKey from database - no hardcoded fallbacks
    if (iconKey == null || iconKey.isEmpty) {
      return FontAwesomeIcons.circleQuestion; // Default when no data
    }

    return _getIconFromKey(iconKey);
  }


  /// Helper method to get icon from key
  static IconData _getIconFromKey(String iconKey) {
    // DB의 icon_key와 Font Awesome 아이콘 매핑 (Toss-style regular icons)
    final iconMap = {
      // 대시보드 & 분석 - Regular versions for cleaner look
      'dashboard': FontAwesomeIcons.chartLine,
      'chartLine': FontAwesomeIcons.chartLine,
      'chartLineRegular': FontAwesomeIcons.chartLine,
      'chartPie': FontAwesomeIcons.chartPie,
      'chartPieRegular': FontAwesomeIcons.chartPie,
      'chartBar': FontAwesomeIcons.chartColumn,
      
      // 계정 & 매핑
      'sitemap': FontAwesomeIcons.sitemap,
      'sitemapRegular': FontAwesomeIcons.sitemap,
      'networkWired': FontAwesomeIcons.networkWired,
      
      // 재무 & 돈 - Keep solid for financial icons (more recognizable)
      'wallet': FontAwesomeIcons.wallet,
      'walletRegular': FontAwesomeIcons.wallet,
      'moneyCheckDollar': FontAwesomeIcons.moneyCheckDollar,
      'cashRegister': FontAwesomeIcons.cashRegister,
      'cashRegisterRegular': FontAwesomeIcons.cashRegister,
      'vault': FontAwesomeIcons.vault,
      'coins': FontAwesomeIcons.coins,
      'handHoldingDollar': FontAwesomeIcons.handHoldingDollar,
      'sackDollar': FontAwesomeIcons.sackDollar,
      'fileInvoiceDollar': FontAwesomeIcons.fileInvoiceDollar,
      
      // 자산 & 건물 - Regular versions where available
      'buildingColumns': FontAwesomeIcons.buildingColumns,
      'building': FontAwesomeIcons.building,
      'buildingRegular': FontAwesomeIcons.building,
      'warehouse': FontAwesomeIcons.warehouse,
      
      // 사용자 & 직원 - Regular versions for cleaner look
      'userCircle': FontAwesomeIcons.circleUser,
      'userGear': FontAwesomeIcons.userGear,
      'userGearRegular': FontAwesomeIcons.userGear, // Use solid since regular doesn't exist
      'userClock': FontAwesomeIcons.userClock,
      'userShield': FontAwesomeIcons.userShield,
      'userShieldRegular': FontAwesomeIcons.userShield, // Use solid since regular doesn't exist
      'userTag': FontAwesomeIcons.userTag,
      'userTagRegular': FontAwesomeIcons.userTag, // Use solid since regular doesn't exist
      'users': FontAwesomeIcons.users,
      'userTie': FontAwesomeIcons.userTie,
      'userRegular': FontAwesomeIcons.userLarge, // Regular user icon
      
      // 시간 & 일정 - Regular versions for cleaner look
      'calendarDays': FontAwesomeIcons.calendar, // Regular calendar
      'calendarRegular': FontAwesomeIcons.calendar,
      'calendarCheck': FontAwesomeIcons.calendarCheck,
      'calendarCheckRegular': FontAwesomeIcons.calendarCheck,
      'clock': FontAwesomeIcons.clock, // Regular clock
      'clockRegular': FontAwesomeIcons.clock,
      'clockRotateLeft': FontAwesomeIcons.clockRotateLeft,
      'clockRotateRegular': FontAwesomeIcons.clockRotateLeft,
      'businessTime': FontAwesomeIcons.businessTime,
      
      // 문서 & 파일 - Regular versions where available
      'fileContract': FontAwesomeIcons.fileContract,
      'fileSignature': FontAwesomeIcons.fileSignature,
      'fileInvoice': FontAwesomeIcons.fileInvoice,
      'fileInvoiceRegular': FontAwesomeIcons.fileInvoice,
      'filePen': FontAwesomeIcons.filePen,
      'fileLines': FontAwesomeIcons.fileLines,
      
      // 편집 & 입력 - Regular versions for subtlety
      'penToSquare': FontAwesomeIcons.penToSquare,
      'pen': FontAwesomeIcons.pen,
      'pencil': FontAwesomeIcons.pencil,
      'editRegular': FontAwesomeIcons.penToSquare, // Clean edit icon

      // 삭제 & 액션
      'trash': FontAwesomeIcons.trash,
      'trashCan': FontAwesomeIcons.trashCan,
      'trashAlt': FontAwesomeIcons.trashCan,
      
      // 위치 & 지도 - Regular versions
      'mapPin': FontAwesomeIcons.locationDot,
      'locationDot': FontAwesomeIcons.locationDot,
      'mapLocation': FontAwesomeIcons.mapLocationDot,
      'mapLocationRegular': FontAwesomeIcons.mapLocationDot,
      
      // 기타 - Regular versions where available
      'handshake': FontAwesomeIcons.handshake,
      'handshakeRegular': FontAwesomeIcons.handshake,
      'wand': FontAwesomeIcons.wandMagicSparkles,
      'flask': FontAwesomeIcons.flask,
      'flaskRegular': FontAwesomeIcons.flask,
      'gear': FontAwesomeIcons.gear,
      'gears': FontAwesomeIcons.gears,
      'circleQuestion': FontAwesomeIcons.circleQuestion,
      'question': FontAwesomeIcons.question,
      'info': FontAwesomeIcons.info,
      'infoCircle': FontAwesomeIcons.circleInfo,
      'infoCircleRegular': FontAwesomeIcons.circleInfo,
      
      // 거래 & 히스토리  
      'history': FontAwesomeIcons.clockRotateLeft,
      'transactionHistory': FontAwesomeIcons.clockRotateLeft,
    };

    // 매핑된 아이콘 반환, 없으면 기본 아이콘
    final result = iconMap[iconKey] ?? FontAwesomeIcons.circleQuestion;
    return result;
  }

  /// 아이콘과 함께 색상도 반환 (카테고리별 색상)
  static Color getIconColor(String? iconKey) {
    if (iconKey == null || iconKey.isEmpty) {
      return TossColors.gray500;
    }

    // 카테고리별 색상 매핑
    final colorMap = {
      // 재무 관련 - 초록색
      'wallet': TossColors.success,
      'moneyCheckDollar': TossColors.success,
      'cashRegister': TossColors.success,
      'vault': TossColors.success,
      'coins': TossColors.success,
      'handHoldingDollar': TossColors.success,
      'sackDollar': TossColors.success,
      'fileInvoiceDollar': TossColors.success,
      
      // 차트 & 분석 - 파란색
      'dashboard': TossColors.primary,
      'chartLine': TossColors.primary,
      'chartPie': TossColors.primary,
      'chartBar': TossColors.primary,
      
      // 사용자 관련 - 주황색
      'userCircle': TossColors.warning,
      'userGear': TossColors.warning,
      'userClock': TossColors.warning,
      'userShield': TossColors.warning,
      'userTag': TossColors.warning,
      
      // 시간 관련 - 보라색
      'calendarDays': TossColors.primary,
      'calendarCheck': TossColors.primary,
      'clock': TossColors.primary,
      'clockRotateLeft': TossColors.primary,
      'businessTime': TossColors.primary,
      
      // 문서 관련 - 청록색
      'fileContract': TossColors.success,
      'fileSignature': TossColors.success,
      'fileInvoice': TossColors.success,
      'filePen': TossColors.success,
      
      // 기본 색상
      'default': TossColors.gray500,
    };

    return colorMap[iconKey] ?? TossColors.gray500;
  }

  /// 디버깅용: 사용 가능한 모든 아이콘 키 목록
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

/// 간편한 아이콘 위젯 - Toss-style with perfect centering
class DynamicIcon extends StatelessWidget {
  final String? iconKey;
  final String? featureName;
  final double? size;
  final Color? color;
  final bool useDefaultColor;

  const DynamicIcon({
    Key? key,
    required this.iconKey,
    this.featureName,
    this.size = 24,
    this.color,
    this.useDefaultColor = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconData = IconMapper.getIcon(iconKey, featureName: featureName);
    // Ensure color is properly applied
    final iconColor = color ?? 
                      (useDefaultColor ? IconMapper.getIconColor(iconKey) : Theme.of(context).iconTheme.color);

    return Center(
      child: FaIcon(
        iconData,
        size: size,
        color: iconColor,
      ),
    );
  }
}
