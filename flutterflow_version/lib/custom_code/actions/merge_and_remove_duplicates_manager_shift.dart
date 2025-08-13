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

Future<List<ManagerShiftDetailStruct>> mergeAndRemoveDuplicatesManagerShift(
  List<ManagerShiftDetailStruct>? myList,
  List<ManagerShiftDetailStruct>? addList,
) async {
  // myList와 addList가 모두 null이거나 비어 있으면 빈 리스트 반환 (null 방지)
  if ((myList == null || myList.isEmpty) &&
      (addList == null || addList.isEmpty)) {
    return [];
  }

  final Map<String, ManagerShiftDetailStruct> map = {};

  // myList와 addList가 null이 아니면 합쳐서 처리
  for (final item in [...?myList, ...?addList]) {
    if (item != null) {
      final requestDate = item.requestDate; // 이미 String 타입
      final storeId = item.storeId;

      // request_date와 store_id로 필터링 (AND 조건)
      if (requestDate != null && storeId != null) {
        final key = "$requestDate-$storeId"; // 고유 키 생성

        // 중복이 없는 경우에만 map에 추가
        map[key] = item;
      }
    }
  }

  // 중복을 제거한 리스트 반환
  return map.values.toList();
}
