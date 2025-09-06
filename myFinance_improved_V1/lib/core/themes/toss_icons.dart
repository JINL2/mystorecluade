import 'package:flutter/material.dart';

/// Toss Icon System - Consistent iconography across the app
/// 
/// Design Principles:
/// - Material Icons as primary icon set
/// - Consistent sizing with 4px grid system
/// - Clear hierarchy through size variations
/// - Semantic naming for common use cases
class TossIcons {
  TossIcons._();

  // ==================== NAVIGATION ICONS ====================
  static const IconData back = Icons.arrow_back_ios;
  static const IconData forward = Icons.chevron_right;
  static const IconData close = Icons.close;
  static const IconData menu = Icons.menu;
  static const IconData more = Icons.more_horiz;
  static const IconData moreVert = Icons.more_vert;
  
  // ==================== USER & ACCOUNT ICONS ====================
  static const IconData person = Icons.person_outline;
  static const IconData personFilled = Icons.person;
  static const IconData account = Icons.account_circle_outlined;
  static const IconData accountFilled = Icons.account_circle;
  static const IconData lock = Icons.lock_outline;
  static const IconData lockFilled = Icons.lock;
  
  // ==================== FINANCE & BUSINESS ICONS ====================
  static const IconData wallet = Icons.account_balance_wallet;
  static const IconData bank = Icons.account_balance;
  static const IconData receipt = Icons.receipt_long;
  static const IconData currency = Icons.currency_exchange;
  static const IconData business = Icons.business;
  static const IconData store = Icons.store_outlined;
  static const IconData storeFilled = Icons.store;
  
  // ==================== STATUS & FEEDBACK ICONS ====================
  static const IconData check = Icons.check;
  static const IconData checkCircle = Icons.check_circle;
  static const IconData error = Icons.error;
  static const IconData errorOutline = Icons.error_outline;
  static const IconData info = Icons.info_outline;
  static const IconData infoFilled = Icons.info;
  static const IconData warning = Icons.warning_amber_outlined;
  static const IconData warningFilled = Icons.warning;
  static const IconData star = Icons.star;
  static const IconData starOutline = Icons.star_outline;
  
  // ==================== DATE & TIME ICONS ====================
  static const IconData calendar = Icons.calendar_today;
  static const IconData calendarFilled = Icons.calendar_month;
  static const IconData time = Icons.access_time;
  static const IconData timeFilled = Icons.access_time_filled;
  
  // ==================== LOCATION ICONS ====================
  static const IconData location = Icons.location_on_outlined;
  static const IconData locationFilled = Icons.location_on;
  static const IconData locationOff = Icons.location_off;
  
  // ==================== COMMON ACTION ICONS ====================
  static const IconData add = Icons.add;
  static const IconData remove = Icons.remove;
  static const IconData edit = Icons.edit_outlined;
  static const IconData editFilled = Icons.edit;
  static const IconData delete = Icons.delete_outline;
  static const IconData deleteFilled = Icons.delete;
  static const IconData share = Icons.share_outlined;
  static const IconData shareFilled = Icons.share;
  static const IconData download = Icons.download_outlined;
  static const IconData downloadFilled = Icons.download;
  static const IconData upload = Icons.upload_outlined;
  static const IconData uploadFilled = Icons.upload;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityFilled = Icons.visibility;
  
  // ==================== SEARCH & FILTER ICONS ====================
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_list;
  static const IconData sort = Icons.sort;
  
  // ==================== DASHBOARD & ANALYTICS ICONS ====================
  static const IconData dashboard = Icons.dashboard_outlined;
  static const IconData dashboardFilled = Icons.dashboard;
  static const IconData analytics = Icons.analytics_outlined;
  static const IconData analyticsFilled = Icons.analytics;
  static const IconData refresh = Icons.refresh;
  
  // ==================== SETTINGS & PREFERENCES ICONS ====================
  static const IconData settings = Icons.settings_outlined;
  static const IconData settingsFilled = Icons.settings;
  static const IconData notifications = Icons.notifications_outlined;
  static const IconData notificationsFilled = Icons.notifications;
  
  // ==================== HELPER METHODS ====================
  
  /// Returns the appropriate icon based on selection state
  static IconData getIcon(IconData outlined, IconData filled, bool isSelected) {
    return isSelected ? filled : outlined;
  }
  
  /// Returns the appropriate store icon based on type
  static IconData getStoreIcon(String? storeType) {
    if (storeType == 'headquarter') return business;
    return store;
  }
  
  /// Returns the appropriate status icon
  static IconData getStatusIcon(bool isSuccess) {
    return isSuccess ? checkCircle : error;
  }
}