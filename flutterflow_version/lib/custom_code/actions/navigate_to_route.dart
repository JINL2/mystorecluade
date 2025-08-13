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

Future navigateToRoute(BuildContext context, String route) async {
  if (route.isEmpty) return;

  final cleanedRoute = route
      .trim()
      .replaceAll('/', '') // 슬래시 제거
      .replaceAll('"', '') // 쌍따옴표 제거
      .replaceAll('\\', ''); // 백슬래시 제거 (혹시 몰라 추가)

  try {
    context.pushNamed(cleanedRoute);
  } catch (e) {
    print('Navigation Error: $e');
  }
}
