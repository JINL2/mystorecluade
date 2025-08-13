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

Future<List<ShiftMetaDataStruct>> mergeAndRemoveDuplicatesShiftMeta(
  List<ShiftMetaDataStruct>? myList,
  List<ShiftMetaDataStruct>? addList,
) async {
  // 둘 다 비어 있으면 빈 리스트 반환 (null 방지)
  if ((myList?.isEmpty ?? true) && (addList?.isEmpty ?? true)) {
    return [];
  }

  final Map<String, ShiftMetaDataStruct> map = {};

  for (final item in [...?myList, ...?addList]) {
    if (item != null) {
      final id = item.shiftId;
      if (id != null && id.isNotEmpty) {
        map[id] = item;
      }
    }
  }

  return map.values.toList();
}
