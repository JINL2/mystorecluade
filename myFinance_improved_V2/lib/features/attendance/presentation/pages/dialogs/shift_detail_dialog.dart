import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/shift_card.dart';
import '../shift_detail_page.dart';

/// Static dialog utilities for showing shift details
class ShiftDetailDialog {
  /// Navigate to shift detail page with dynamic mock ShiftCard
  /// TODO: Replace with real ShiftCard from getUserShiftCards provider
  static void show(
    BuildContext context, {
    required String shiftDate,
    required String shiftType,
    required String shiftTime,
    required String shiftStatus,
  }) {
    // Parse date to generate different data per shift
    final date = DateTime.parse(shiftDate);
    final dayOfMonth = date.day;

    // Generate dynamic times based on shift type and day
    final isMorning = shiftType.toLowerCase().contains('morning');

    // Vary check-in time by day (simulate real-world variations)
    final checkInMinutes = (dayOfMonth * 3) % 10; // 0-9 minutes variation
    final actualCheckIn = isMorning
        ? '09:${checkInMinutes.toString().padLeft(2, '0')}:00'
        : '14:${checkInMinutes.toString().padLeft(2, '0')}:00';

    // Check-out also varies slightly
    final checkOutMinutes = (dayOfMonth * 5) % 15; // 0-14 minutes variation
    final actualCheckOut = isMorning
        ? '17:${checkOutMinutes.toString().padLeft(2, '0')}:00'
        : '22:${checkOutMinutes.toString().padLeft(2, '0')}:00';

    // Calculate hours worked (with decimal variation)
    final scheduledHours = 8.0;
    final actualHours =
        scheduledHours + (checkInMinutes / 60.0) + (checkOutMinutes / 60.0);

    // Calculate pay based on hours and day
    final hourlyRate = 10.0 + (dayOfMonth % 5); // $10-$14/hr
    final basePay = actualHours * hourlyRate;
    final bonusAmount =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday
            ? 20.0 // Weekend bonus
            : (dayOfMonth % 2 == 0 ? 15.0 : 10.0); // Varied bonus
    final totalPay = basePay + bonusAmount;

    // Determine if late based on check-in time
    final isLate = checkInMinutes > 5;
    final lateMinutes = isLate ? checkInMinutes : 0;

    // Create dynamic ShiftCard
    final dynamicShift = ShiftCard(
      requestDate: shiftDate,
      shiftRequestId: 'shift-${date.millisecondsSinceEpoch}',
      shiftTime: shiftType,
      storeName: 'Downtown Store',
      scheduledHours: scheduledHours,
      isApproved: true,
      actualStartTime: actualCheckIn,
      actualEndTime: actualCheckOut,
      confirmStartTime: actualCheckIn,
      confirmEndTime: actualCheckOut,
      paidHours: actualHours,
      isLate: isLate,
      lateMinutes: lateMinutes,
      lateDeducutAmount: isLate ? 5.0 : 0.0,
      isExtratime: actualHours > scheduledHours,
      overtimeMinutes: actualHours > scheduledHours
          ? ((actualHours - scheduledHours) * 60).round()
          : 0,
      basePay: basePay.toStringAsFixed(2),
      bonusAmount: bonusAmount,
      totalPayWithBonus: totalPay.toStringAsFixed(2),
      salaryType: 'hourly',
      salaryAmount: hourlyRate.toStringAsFixed(2),
      isReported: false,
      isProblem: false,
      isProblemSolved: false,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShiftDetailPage(shift: dynamicShift),
      ),
    );
  }
}
