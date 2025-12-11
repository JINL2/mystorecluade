import 'package:flutter/material.dart';
import '../data/services/stock_flow_service.dart';
import '../presentation/widgets/displays/real_item_widget.dart';

/// Widget factory for creating dynamic widgets in Cash Ending Page
/// Provides factory methods for creating widgets with proper callbacks
class WidgetFactory {
  
  /// Create a Real item widget with all necessary callbacks
  static Widget createRealItemWidget({
    required ActualFlow flow,
    required bool showDate,
    required LocationSummary? locationSummary,
    required Map<String, dynamic> Function() getBaseCurrency,
    required String Function(double amount, String symbol) formatBalance,
    required TabController tabController,
    required Function(ActualFlow flow, {String locationType}) showRealDetailBottomSheet,
  }) {
    return RealItemWidget(
      flow: flow,
      showDate: showDate,
      locationSummary: locationSummary,
      getBaseCurrency: getBaseCurrency,
      formatBalance: formatBalance,
      tabController: tabController,
      showRealDetailBottomSheet: showRealDetailBottomSheet,
    );
  }


  /// Create callback function for building Real items
  static Widget Function(ActualFlow flow, bool showDate) createRealItemBuilder({
    required LocationSummary? locationSummary,
    required Map<String, dynamic> Function() getBaseCurrency,
    required String Function(double amount, String symbol) formatBalance,
    required TabController tabController,
    required Function(ActualFlow flow, {String locationType}) showRealDetailBottomSheet,
  }) {
    return (ActualFlow flow, bool showDate) {
      return createRealItemWidget(
        flow: flow,
        showDate: showDate,
        locationSummary: locationSummary,
        getBaseCurrency: getBaseCurrency,
        formatBalance: formatBalance,
        tabController: tabController,
        showRealDetailBottomSheet: showRealDetailBottomSheet,
      );
    };
  }


  /// Create error message display widget
  static Widget createErrorMessage({
    required String message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  /// Create loading indicator widget
  static Widget createLoadingIndicator({
    String? message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Create empty state widget
  static Widget createEmptyState({
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onAction,
    String? actionText,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          if (onAction != null && actionText != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText),
            ),
          ],
        ],
      ),
    );
  }

  /// Create validation result message widget
  static Widget? createValidationMessage({
    required Map<String, dynamic> validation,
  }) {
    if (validation['isValid'] == true) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: Colors.red[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              validation['errorMessage'] ?? 'Validation error',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Create success message widget
  static Widget createSuccessMessage({
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Create info message widget
  static Widget createInfoMessage({
    required String message,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? Icons.info,
            color: Colors.blue[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Create tab progress indicator
  static Widget createTabProgressIndicator({
    required int currentStep,
    required int totalSteps,
    required List<String> stepLabels,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          for (int i = 0; i < totalSteps; i++) ...[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: i <= currentStep ? Colors.blue : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: i <= currentStep ? Colors.white : Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (i < totalSteps - 1)
              Expanded(
                child: Container(
                  height: 2,
                  color: i < currentStep ? Colors.blue : Colors.grey[300],
                ),
              ),
          ],
        ],
      ),
    );
  }
}