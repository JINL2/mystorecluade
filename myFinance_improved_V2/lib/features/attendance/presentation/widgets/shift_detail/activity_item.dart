import 'package:flutter/material.dart';

/// Activity item data class for shift detail activity log
class ActivityItem {
  final IconData icon;
  final Color color;
  final String label;
  final String time;

  const ActivityItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.time,
  });
}
