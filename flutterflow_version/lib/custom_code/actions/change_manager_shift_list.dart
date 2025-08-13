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

List<ManagerShiftDetailStruct>? changeManagerShiftList(
  List<String>? shiftRequestId,
  List<ManagerShiftDetailStruct>? managerShiftList,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE
  if (shiftRequestId == null || managerShiftList == null)
    return managerShiftList;

  for (final shiftDetail in managerShiftList) {
    int shiftLevelApprovedDelta = 0;
    int shiftLevelPendingDelta = 0;

    for (final shift in shiftDetail.shifts) {
      final pending = shift.pendingEmployees ?? [];
      final approved = shift.approvedEmployees ?? [];

      final moveList = <ApprovedEmployeesStruct>[];

      for (final emp in pending) {
        if (shiftRequestId.contains(emp.shiftRequestId)) {
          final approvedEmp = ApprovedEmployeesStruct(
            userId: emp.userId,
            userName: emp.userName,
            isApproved: true,
            shiftRequestId: emp.shiftRequestId,
          );
          moveList.add(approvedEmp);
        }
      }

      // 개수 계산
      final movedCount = moveList.length;
      if (movedCount > 0) {
        shiftLevelApprovedDelta += movedCount;
        shiftLevelPendingDelta += movedCount;
      }

      // pending에서 제거
      shift.pendingEmployees = pending
          .where((e) => !shiftRequestId.contains(e.shiftRequestId))
          .toList();

      // approved에 추가
      shift.approvedEmployees = [...approved, ...moveList];

      // shift 단위 카운트 변경
      shift.approvedCount = (shift.approvedCount ?? 0) + movedCount;
      shift.pendingCount = (shift.pendingCount ?? 0) - movedCount;
    }

    // 날짜 전체 카운트 변경
    shiftDetail.totalApproved =
        (shiftDetail.totalApproved ?? 0) + shiftLevelApprovedDelta;
    shiftDetail.totalPending =
        (shiftDetail.totalPending ?? 0) - shiftLevelPendingDelta;
  }

  return managerShiftList;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
