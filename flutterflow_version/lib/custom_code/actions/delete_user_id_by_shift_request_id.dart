// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

List<ManagerShiftDetailStruct>? deleteUserIdByShiftRequestId(
  String? shiftRequestId,
  List<ManagerShiftDetailStruct>? managerShiftList,
) {
  if (shiftRequestId == null || managerShiftList == null) {
    return managerShiftList ?? [];
  }

  // ✅ Step 1: 유효성 검사 - approvedEmployees 중 해당 requestId가 존재하는지 확인
  final exists = managerShiftList.any((detail) => detail.shifts.any((shift) =>
      (shift.approvedEmployees ?? [])
          .any((emp) => emp.shiftRequestId == shiftRequestId)));

  if (!exists) {
    // 없으면 원본 그대로 반환
    return managerShiftList;
  }

  final updatedList = <ManagerShiftDetailStruct>[];

  for (final shiftDetail in managerShiftList) {
    final updatedShifts = <ShiftsStruct>[];

    for (final shift in shiftDetail.shifts) {
      // 삭제 대상 유저 제거
      final approved = (shift.approvedEmployees ?? [])
          .where((emp) => emp.shiftRequestId != shiftRequestId)
          .toList();

      // approvedCount 재계산
      final approvedCount = approved.length;

      // shift 안에 유저가 남아있다면 보존
      if (approvedCount > 0 || (shift.pendingEmployees?.isNotEmpty ?? false)) {
        updatedShifts.add(
          ShiftsStruct(
            shiftId: shift.shiftId,
            shiftName: shift.shiftName,
            approvedEmployees: approved,
            pendingEmployees: shift.pendingEmployees,
            approvedCount: approvedCount,
            pendingCount: shift.pendingCount ?? 0,
            requiredEmployees: shift.requiredEmployees ?? 0,
          ),
        );
      }
    }

    // shift가 남아있는 경우만 추가
    final totalApproved = updatedShifts.fold<int>(
      0,
      (sum, s) => sum + (s.approvedCount ?? 0),
    );
    final totalPending = updatedShifts.fold<int>(
      0,
      (sum, s) => sum + (s.pendingCount ?? 0),
    );

    if (updatedShifts.isNotEmpty || totalApproved + totalPending > 0) {
      updatedList.add(
        ManagerShiftDetailStruct(
          requestDate: shiftDetail.requestDate,
          storeId: shiftDetail.storeId,
          shifts: updatedShifts,
          totalApproved: totalApproved,
          totalPending: totalPending,
        ),
      );
    }
  }

  return updatedList;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
