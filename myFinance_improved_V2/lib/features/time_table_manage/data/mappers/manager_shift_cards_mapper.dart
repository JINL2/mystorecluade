import 'package:flutter/foundation.dart';

import '../../domain/entities/manager_shift_cards.dart';

/// Mapper for converting RPC response to ManagerShiftCards entity
///
/// Separates complex data transformation logic from Repository
class ManagerShiftCardsMapper {
  /// Converts RPC response to ManagerShiftCards entity
  ///
  /// RPC returns: {stores: [{store_id, cards: [...]}]}
  /// Entity expects: {store_id, start_date, end_date, cards: [...]}
  static ManagerShiftCards fromRpcResponse(
    Map<String, dynamic> rpcData, {
    required String storeId,
    required String startDate,
    required String endDate,
  }) {
    if (kDebugMode) {
      debugPrint('🔍 [CardsMapper] RPC data keys: ${rpcData.keys.toList()}');
    }

    // Extract stores array
    final stores = rpcData['stores'] as List<dynamic>? ?? [];
    if (stores.isEmpty) {
      if (kDebugMode) debugPrint('⚠️ [CardsMapper] stores is EMPTY → returning empty cards');
      return _emptyCards(storeId, startDate, endDate);
    }

    if (kDebugMode) {
      debugPrint('✅ [CardsMapper] stores.length = ${stores.length}');
    }

    // Extract cards from first store
    final storeData = stores.first as Map<String, dynamic>;
    final cards = storeData['cards'] as List<dynamic>? ?? [];

    if (kDebugMode) {
      debugPrint('✅ [CardsMapper] cards.length = ${cards.length}');
      if (cards.isNotEmpty) {
        debugPrint('🔍 [CardsMapper] First card keys: ${(cards.first as Map).keys.toList()}');
      }
    }

    // Transform cards: RPC flat structure → ShiftCard nested structure
    // RPC card has: shift_name, shift_time (flat)
    // ShiftCard expects: shift {}, employee {} (nested)
    final transformedCards = cards.map((card) {
      final cardMap = card as Map<String, dynamic>;

      // Parse shift_time "10:00-14:00" to extract start/end
      final shiftTime = cardMap['shift_time'] as String? ?? '';
      final timeParts = shiftTime.split('-');
      final startTime = timeParts.isNotEmpty ? timeParts[0] : '00:00';
      final endTime = timeParts.length > 1 ? timeParts[1] : '00:00';

      // Helper function to convert time string to full ISO8601 datetime
      String? _timeToDateTime(String? timeStr, String? dateStr) {
        if (timeStr == null || timeStr.isEmpty || timeStr == 'null') return null;
        if (dateStr == null || dateStr.isEmpty) return null;

        // Remove seconds if present (18:00:00 -> 18:00)
        final timeParts = timeStr.split(':');
        final timeOnly = timeParts.length >= 2
            ? '${timeParts[0]}:${timeParts[1]}'
            : timeStr;

        return '${dateStr}T$timeOnly:00';
      }

      final requestDate = cardMap['request_date'] as String?;

      return {
        ...cardMap,
        // Convert time-only strings to full datetime strings
        'actual_start': _timeToDateTime(cardMap['actual_start'] as String?, requestDate),
        'actual_end': _timeToDateTime(cardMap['actual_end'] as String?, requestDate),
        'confirm_start_time': _timeToDateTime(cardMap['confirm_start_time'] as String?, requestDate),
        'confirm_end_time': _timeToDateTime(cardMap['confirm_end_time'] as String?, requestDate),
        // Build nested shift object
        'shift': {
          'shift_id': cardMap['shift_id'] ?? '',
          'store_id': storeData['store_id'] ?? storeId,
          'shift_date': requestDate ?? '',
          'shift_name': cardMap['shift_name'],
          'plan_start_time': '${requestDate}T$startTime:00',
          'plan_end_time': '${requestDate}T$endTime:00',
          'target_count': 0,
          'current_count': 0,
          'tags': [],
        },
        // Build nested employee object
        'employee': {
          'user_id': cardMap['user_id'] ?? '',
          'user_name': cardMap['user_name'] ?? '',
          'profile_image': cardMap['profile_image'],
        },
      };
    }).toList();

    // Transform to entity format
    final mappedData = {
      'store_id': storeData['store_id'] ?? storeId,
      'start_date': startDate,
      'end_date': endDate,
      'cards': transformedCards,
    };

    if (kDebugMode) {
      debugPrint('✅ [CardsMapper] Transformed ${cards.length} cards with nested structure');
    }

    return ManagerShiftCards.fromJson(mappedData);
  }

  /// Returns empty ManagerShiftCards when no data available
  static ManagerShiftCards _emptyCards(
    String storeId,
    String startDate,
    String endDate,
  ) {
    return ManagerShiftCards(
      storeId: storeId,
      startDate: startDate,
      endDate: endDate,
      cards: const [],
    );
  }
}
