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

List<ManagerShiftDetailStruct> createUserIdByShiftReuqestId(
    List<ManagerShiftDetailStruct>? managerShiftList,
    String? requestDate,
    String? shiftId,
    String? userId,
    String? userName,
    String? shiftRequestId,
    String? storeId,
    String? shiftName) {
  if (managerShiftList == null ||
      requestDate == null ||
      shiftId == null ||
      shiftName == null || // ✅ null 체크 추가
      userId == null ||
      userName == null ||
      shiftRequestId == null ||
      storeId == null) {
    return managerShiftList ?? [];
  }

  // 1️⃣ requestDate로 기존 데이터 찾기
  final shiftDetailIndex = managerShiftList.indexWhere(
    (detail) => detail.requestDate == requestDate,
  );

  if (shiftDetailIndex == -1) {
    // ❌ requestDate 없음 → 전체 새로 생성
    final newStruct = ManagerShiftDetailStruct(
      requestDate: requestDate,
      storeId: storeId,
      totalApproved: 1,
      totalPending: 0,
      shifts: [
        ShiftsStruct(
          shiftId: shiftId,
          shiftName: shiftName, // ✅ 사용
          approvedCount: 1,
          pendingCount: 0,
          approvedEmployees: [
            ApprovedEmployeesStruct(
              userId: userId,
              userName: userName,
              isApproved: true,
              shiftRequestId: shiftRequestId,
            ),
          ],
        ),
      ],
    );

    managerShiftList.add(newStruct);
    return managerShiftList;
  }

  // ✅ requestDate 있음
  final shiftDetail = managerShiftList[shiftDetailIndex];

  // 2️⃣ shiftId 확인
  final shiftIndex = shiftDetail.shifts.indexWhere(
    (s) => s.shiftId == shiftId,
  );

  if (shiftIndex == -1) {
    // ❌ shiftId 없음 → 새 shift 추가
    shiftDetail.shifts.add(
      ShiftsStruct(
        shiftId: shiftId,
        shiftName: shiftName, // ✅ 사용
        approvedCount: 1,
        pendingCount: 0,
        approvedEmployees: [
          ApprovedEmployeesStruct(
            userId: userId,
            userName: userName,
            isApproved: true,
            shiftRequestId: shiftRequestId,
          ),
        ],
      ),
    );
  } else {
    // ✅ shiftId 있음 → approved_employees에 추가
    final shift = shiftDetail.shifts[shiftIndex];
    shift.approvedEmployees ??= [];

    final isDuplicate =
        shift.approvedEmployees!.any((emp) => emp.userId == userId);
    if (isDuplicate) {
      throw Exception('해당 유저는 이미 승인된 상태입니다.');
    }

    shift.approvedEmployees!.add(
      ApprovedEmployeesStruct(
        userId: userId,
        userName: userName,
        isApproved: true,
        shiftRequestId: shiftRequestId,
      ),
    );

    shift.approvedCount = shift.approvedEmployees?.length ?? 0;
  }

  // 🔄 전체 totalApproved 업데이트
  shiftDetail.totalApproved = shiftDetail.shifts.fold<int>(
    0,
    (sum, s) => sum + (s.approvedCount ?? 0),
  );

  return managerShiftList;
}
