import 'package:flutter/material.dart';

/// Denomination controllers state management
/// FROM PRODUCTION LINE 104 and disposal logic from lines 196-201
class DenominationControllerState {
  // Denomination controllers for cash counting - dynamically created (Line 104)
  final Map<String, Map<String, TextEditingController>> denominationControllers;

  DenominationControllerState({
    Map<String, Map<String, TextEditingController>>? denominationControllers,
  }) : denominationControllers = denominationControllers ?? {};

  /// Initialize controllers for a currency's denominations
  /// This preserves the exact logic from production lines 301-318
  void initializeControllersForCurrency(String currencyId, List<Map<String, dynamic>> denominations) {
    if (!denominationControllers.containsKey(currencyId)) {
      denominationControllers[currencyId] = {};
    }
    
    for (var denom in denominations) {
      final denomValue = (denom['value'] ?? 0).toString();
      if (!denominationControllers[currencyId]!.containsKey(denomValue)) {
        denominationControllers[currencyId]![denomValue] = TextEditingController();
      }
    }
  }

  /// Get controller for specific denomination
  TextEditingController? getController(String currencyId, String denomValue) {
    return denominationControllers[currencyId]?[denomValue];
  }

  /// Dispose all controllers - CRITICAL for memory management
  /// FROM PRODUCTION LINES 196-201
  void dispose() {
    denominationControllers.forEach((currencyId, controllers) {
      controllers.forEach((denomValue, controller) {
        controller.dispose();
      });
    });
  }

  DenominationControllerState copyWith({
    Map<String, Map<String, TextEditingController>>? denominationControllers,
  }) {
    return DenominationControllerState(
      denominationControllers: denominationControllers ?? this.denominationControllers,
    );
  }
}