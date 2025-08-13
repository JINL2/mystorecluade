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

List<ManagerShiftDetailStruct>? updateUserIdByShiftRequestId(
  String? shiftRequestId,
  String? newUserId,
  String? newUserName,
  List<ManagerShiftDetailStruct>? managerShiftList,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE
  /// MODIFY CODE ONLY BELOW THIS LINE
  if (shiftRequestId == null ||
      newUserId == null ||
      newUserName == null ||
      managerShiftList == null) return managerShiftList;

  for (final shiftDetail in managerShiftList) {
    for (final shift in shiftDetail.shifts) {
      final pending = shift.pendingEmployees ?? [];
      final approved = shift.approvedEmployees ?? [];

      // pendingEmployees 수정
      for (final emp in pending) {
        if (emp.shiftRequestId == shiftRequestId) {
          emp.userId = newUserId;
          emp.userName = newUserName;
        }
      }

      // approvedEmployees 수정
      for (final emp in approved) {
        if (emp.shiftRequestId == shiftRequestId) {
          emp.userId = newUserId;
          emp.userName = newUserName;
        }
      }
    }
  }

  return managerShiftList;

  /// MODIFY CODE ONLY ABOVE THIS LINE
  /// MODIFY CODE ONLY ABOVE THIS LINE
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
