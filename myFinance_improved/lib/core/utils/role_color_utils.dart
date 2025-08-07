// lib/core/utils/role_color_utils.dart

import 'package:flutter/material.dart';

class RoleColorUtils {
  static Color getRoleColor(String? roleName) {
    if (roleName == null) return Colors.grey;
    
    switch (roleName.toLowerCase()) {
      case 'owner':
        return const Color(0xFF8B5CF6); // Purple
      case 'admin':
        return const Color(0xFFEF4444); // Red
      case 'manager':
        return const Color(0xFFF59E0B); // Orange
      case 'employee':
        return const Color(0xFF10B981); // Green
      case 'cashier':
        return const Color(0xFF3B82F6); // Blue
      case 'staff':
        return const Color(0xFF06B6D4); // Cyan
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }
}