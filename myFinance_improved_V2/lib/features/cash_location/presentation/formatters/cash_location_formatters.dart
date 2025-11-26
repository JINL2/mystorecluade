// Presentation Layer - Formatters
// UI-specific formatting logic for cash location entities
// This keeps Domain entities clean from presentation concerns

import 'package:intl/intl.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/bank_real_entry.dart';
import '../../domain/entities/cash_real_entry.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/stock_flow.dart';
import '../../domain/entities/vault_real_entry.dart';

/// Formatter for displaying cash location data in UI
class CashLocationFormatters {
  CashLocationFormatters._(); // Private constructor - utility class

  // ============================================================================
  // Date and Time Formatting
  // ============================================================================

  /// Format date as "dd/MM"
  static String formatShortDate(String dateTimeString) {
    try {
      final localDateTime = DateTime.parse(dateTimeString);
      return '${localDateTime.day}/${localDateTime.month}';
    } catch (e) {
      return dateTimeString;
    }
  }

  /// Format time only (HH:mm)
  static String formatTimeOnly(String dateTimeString) {
    try {
      final localDateTime = DateTime.parse(dateTimeString);
      return DateTimeUtils.formatTimeOnly(localDateTime);
    } catch (e) {
      // Fallback: try parsing with toLocal if Z format fails
      try {
        final utcDateTime = DateTime.parse(dateTimeString);
        final localDateTime = utcDateTime.toLocal();
        return DateTimeUtils.formatTimeOnly(localDateTime);
      } catch (e2) {
        return dateTimeString;
      }
    }
  }

  /// Format full date and time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  // ============================================================================
  // Journal Entry Formatting
  // ============================================================================

  /// Format journal entry title for display
  static String formatJournalTitle(String accountName) {
    // Simple title formatting - can be enhanced based on business rules
    if (accountName.isEmpty) return 'Unknown';

    // Capitalize first letter
    return accountName.substring(0, 1).toUpperCase() +
           accountName.substring(1);
  }

  /// Format journal entry time for display
  static String formatJournalTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Get formatted transaction display from journal entry
  /// This method handles the business logic of extracting transaction data
  /// and formatting it for display purposes
  static TransactionDisplay? getTransactionDisplay(
    JournalEntry entry,
    String locationType,
  ) {
    // Use domain method to get transaction data
    final transactionData = entry.getTransactionData(locationType);
    if (transactionData == null) return null;

    // Format the title
    String title = '';
    if (transactionData.counterpartLine.accountName.isNotEmpty) {
      title = formatJournalTitle(transactionData.counterpartLine.accountName);
    } else if (entry.journalDescription.isNotEmpty) {
      title = entry.journalDescription;
    } else {
      title = transactionData.isIncome ? 'Cash In' : 'Cash Out';
    }

    return TransactionDisplay(
      title: title,
      amount: transactionData.amount,
      isIncome: transactionData.isIncome,
      date: entry.entryDate,
      time: formatJournalTime(entry.transactionDate),
      journalType: entry.journalDescription,
      description: entry.journalDescription,
      locationName: transactionData.cashLine.locationName ?? 'Unknown',
      personName: '',
      journalEntry: entry,
    );
  }

  // ============================================================================
  // Stock Flow Formatting
  // ============================================================================

  /// Format JournalFlow date
  static String formatJournalFlowDate(JournalFlow flow) {
    return formatShortDate(flow.createdAt);
  }

  /// Format JournalFlow time
  static String formatJournalFlowTime(JournalFlow flow) {
    return formatTimeOnly(flow.createdAt);
  }

  /// Format ActualFlow date
  static String formatActualFlowDate(ActualFlow flow) {
    return formatShortDate(flow.createdAt);
  }

  /// Format ActualFlow time
  static String formatActualFlowTime(ActualFlow flow) {
    return formatTimeOnly(flow.createdAt);
  }

  // ============================================================================
  // Real Entry Formatting
  // ============================================================================

  /// Format CashRealEntry time
  static String formatCashRealTime(CashRealEntry entry) {
    return formatTimeOnly(entry.createdAt);
  }

  /// Format BankRealEntry time
  static String formatBankRealTime(BankRealEntry entry) {
    return formatTimeOnly(entry.createdAt);
  }

  /// Format VaultRealEntry time
  static String formatVaultRealTime(VaultRealEntry entry) {
    return formatTimeOnly(entry.createdAt);
  }

  // ============================================================================
  // Currency Formatting
  // ============================================================================

  /// Format amount with currency symbol
  static String formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.round())}';
  }

  /// Format amount without currency symbol
  static String formatAmount(double amount) {
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(amount.round());
  }
}

/// Display model for Journal Transaction (Presentation concern)
class JournalTransactionDisplay {
  final String title;
  final double amount;
  final bool isIncome;
  final String date;
  final String time;
  final String journalType;
  final String description;
  final String locationName;
  final String personName;
  final JournalEntry? journalEntry; // Optional for details

  JournalTransactionDisplay({
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.time,
    required this.journalType,
    required this.description,
    this.locationName = '',
    this.personName = '',
    this.journalEntry,
  });
}

/// Alias for backward compatibility with existing code
typedef TransactionDisplay = JournalTransactionDisplay;
