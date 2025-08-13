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

Future<List<ShiftStatusStruct>> mergeAndRemoveDuplicatesShiftStatus(
  List<ShiftStatusStruct>? myList,
  List<ShiftStatusStruct>? addList,
) async {
  if ((myList?.isEmpty ?? true) && (addList?.isEmpty ?? true)) {
    return [];
  }

  final Map<String, ShiftStatusStruct> map = {};

  for (final item in [...?myList, ...?addList]) {
    if (item != null) {
      final id = item.shiftRequestId;
      if (id != null && id.isNotEmpty) {
        map[id] = item; // 여기서 더 이상 item! 하지 않음
      }
    }
  }

  return map.values.toList();
}
