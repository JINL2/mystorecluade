import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to store the currently selected session type
/// 'counting' for Stock Count, 'receiving' for Receiving
final selectedSessionTypeProvider = StateProvider<String?>((ref) => null);
