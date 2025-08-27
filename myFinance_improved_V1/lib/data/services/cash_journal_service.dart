import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

// Cash journal service provider
final cashJournalServiceProvider = Provider<CashJournalService>((ref) {
  return CashJournalService();
});

// Cash journal data provider
final cashJournalProvider = FutureProvider.family<List<JournalEntry>, CashJournalParams>((ref, params) async {
  final service = ref.read(cashJournalServiceProvider);
  return service.getCashJournal(
    companyId: params.companyId,
    storeId: params.storeId,
    locationType: params.locationType,
    offset: params.offset,
    limit: params.limit,
  );
});

class CashJournalService {
  final _supabase = Supabase.instance.client;

  /// Get cash journal entries using RPC
  Future<List<JournalEntry>> getCashJournal({
    required String companyId,
    required String storeId,
    required String locationType,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      // Debug: print('Fetching cash journal for company: $companyId, store: $storeId, offset: $offset, limit: $limit');
      
      final response = await _supabase.rpc(
        'get_cash_journal',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );
      
      // Debug: print('Cash journal response: ${response?.length ?? 0} entries');
      
      if (response == null) return [];
      
      return (response as List)
          .map((json) => JournalEntry.fromJson(json))
          .toList();
    } catch (e) {
      // Debug: print('Error fetching cash journal: $e');
      return [];
    }
  }
  
  /// Insert journal entry for foreign currency translation
  Future<Map<String, dynamic>> insertJournalWithEverything({
    required double baseAmount,
    required String companyId,
    required String createdBy,
    required String description,
    required String entryDate,
    required List<Map<String, dynamic>> lines,
    String? counterpartyId,
    String? ifCashLocationId,
    String? storeId,
  }) async {
    try {
      final response = await _supabase.rpc(
        'insert_journal_with_everything',
        params: {
          'p_base_amount': baseAmount,
          'p_company_id': companyId,
          'p_created_by': createdBy,
          'p_description': description,
          'p_entry_date': entryDate,
          'p_lines': lines,
          'p_counterparty_id': counterpartyId,
          'p_if_cash_location_id': ifCashLocationId,
          'p_store_id': storeId,
        },
      );
      
      return {
        'success': true,
        'data': response,
      };
    } catch (e) {
      // Debug: print('Error inserting journal: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
  
  /// Create foreign currency translation journal entry
  Future<Map<String, dynamic>> createForeignCurrencyTranslation({
    required double differenceAmount,
    required String companyId,
    required String userId,
    required String locationName,
    required String cashLocationId,
    String? storeId,
  }) async {
    // Constants for account IDs
    const cashAccountId = 'd4a7a16e-45a1-47fe-992b-ff807c8673f0';
    const foreignCurrencyAccountId = '80b311db-f548-46e3-9854-67c5ff6766e8';
    
    // Get current date
    final now = DateTime.now().toLocal();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);
    final entryDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);
    
    // Calculate absolute amount
    final absAmount = differenceAmount.abs();
    final isPositiveDifference = differenceAmount > 0;
    
    // Create journal lines
    final lines = [
      {
        'account_id': cashAccountId,
        'description': 'Foreign Currency Translation',
        'debit': isPositiveDifference ? absAmount : 0,
        'credit': isPositiveDifference ? 0 : absAmount,
        'cash': {
          'cash_location_id': cashLocationId,
        },
      },
      {
        'account_id': foreignCurrencyAccountId,
        'description': 'Foreign Currency Translation',
        'debit': isPositiveDifference ? 0 : absAmount,
        'credit': isPositiveDifference ? absAmount : 0,
      },
    ];
    
    return insertJournalWithEverything(
      baseAmount: absAmount,
      companyId: companyId,
      createdBy: userId,
      description: 'Foreign Currency Translation - $locationName',
      entryDate: entryDate,
      lines: lines,
      counterpartyId: null,
      ifCashLocationId: null,
      storeId: storeId,
    );
  }
  
  /// Create error adjustment journal entry
  Future<Map<String, dynamic>> createErrorJournal({
    required double differenceAmount,
    required String companyId,
    required String userId,
    required String locationName,
    required String cashLocationId,
    String? storeId,
  }) async {
    // Constants for account IDs
    const cashAccountId = 'd4a7a16e-45a1-47fe-992b-ff807c8673f0';
    const errorAccountId = 'a45fac5d-010c-4b1b-92e9-ddcf8f3222bf';
    
    // Get current date
    final now = DateTime.now().toLocal();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);
    final entryDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);
    
    // Calculate absolute amount
    final absAmount = differenceAmount.abs();
    final isPositiveDifference = differenceAmount > 0;
    
    // Create journal lines
    final lines = [
      {
        'account_id': cashAccountId,
        'description': 'Make error',
        'debit': isPositiveDifference ? absAmount : 0,
        'credit': isPositiveDifference ? 0 : absAmount,
        'cash': {
          'cash_location_id': cashLocationId,
        },
      },
      {
        'account_id': errorAccountId,
        'description': 'Make error',
        'debit': isPositiveDifference ? 0 : absAmount,
        'credit': isPositiveDifference ? absAmount : 0,
      },
    ];
    
    return insertJournalWithEverything(
      baseAmount: absAmount,
      companyId: companyId,
      createdBy: userId,
      description: 'Make Error - $locationName',
      entryDate: entryDate,
      lines: lines,
      counterpartyId: null,
      ifCashLocationId: null,
      storeId: storeId,
    );
  }
}

// Models
class JournalEntry {
  final String journalId;
  final String journalDescription;
  final String entryDate;
  final DateTime transactionDate;
  final List<JournalLine> lines;

  JournalEntry({
    required this.journalId,
    required this.journalDescription,
    required this.entryDate,
    required this.transactionDate,
    required this.lines,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      journalId: json['journal_id'] ?? '',
      journalDescription: json['journal_description'] ?? '',
      entryDate: json['entry_date'] ?? '',
      transactionDate: DateTime.parse(json['transaction_date'] ?? DateTime.now().toIso8601String()),
      lines: (json['lines'] as List? ?? [])
          .map((line) => JournalLine.fromJson(line))
          .toList(),
    );
  }
  
  // Helper method to get a formatted transaction for display
  TransactionDisplay? getTransactionDisplay(String locationType) {
    // Filter lines by location type (cash, bank, or vault)
    final relevantLines = lines.where((line) => 
      line.locationType == locationType || 
      (line.locationType == null && line.accountName.toLowerCase().contains('expense'))
    ).toList();
    
    if (relevantLines.isEmpty) return null;
    
    // Find the cash location line (where money moves in/out)
    final cashLine = lines.firstWhere(
      (line) => line.locationType == locationType,
      orElse: () => lines.first,
    );
    
    // Find the counterpart line (expense/income account or other location)
    final counterpartLine = lines.firstWhere(
      (line) => line.lineId != cashLine.lineId,
      orElse: () => cashLine,
    );
    
    // Determine if it's income (debit to cash) or expense (credit from cash)
    final isIncome = cashLine.debit > 0;
    final amount = isIncome ? cashLine.debit : cashLine.credit;
    
    // Create a meaningful title from the counterpart
    String title = '';
    if (counterpartLine.accountName.isNotEmpty) {
      title = _formatTitle(counterpartLine.accountName);
    } else if (journalDescription.isNotEmpty) {
      title = journalDescription;
    } else {
      title = isIncome ? 'Cash In' : 'Cash Out';
    }
    
    return TransactionDisplay(
      date: entryDate,
      time: _formatTime(transactionDate),
      title: title,
      locationName: cashLine.locationName ?? 'Unknown',
      personName: '', // Could be extracted from description if available
      amount: amount,
      isIncome: isIncome,
      description: journalDescription,
      journalEntry: this, // Pass reference to original journal entry
    );
  }
  
  static String _formatTitle(String accountName) {
    // Convert account names like "office supplies expenses" to "Office Supplies"
    final words = accountName.toLowerCase()
        .replaceAll('expenses', '')
        .replaceAll('expense', '')
        .replaceAll('_', ' ')
        .trim()
        .split(' ');
    
    return words.map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : ''
    ).join(' ');
  }
  
  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class JournalLine {
  final String lineId;
  final String? cashLocationId;
  final String? locationName;
  final String? locationType;
  final String accountId;
  final String accountName;
  final double debit;
  final double credit;
  final String description;

  JournalLine({
    required this.lineId,
    this.cashLocationId,
    this.locationName,
    this.locationType,
    required this.accountId,
    required this.accountName,
    required this.debit,
    required this.credit,
    required this.description,
  });

  factory JournalLine.fromJson(Map<String, dynamic> json) {
    return JournalLine(
      lineId: json['line_id'] ?? '',
      cashLocationId: json['cash_location_id'],
      locationName: json['location_name'],
      locationType: json['location_type'],
      accountId: json['account_id'] ?? '',
      accountName: json['account_name'] ?? '',
      debit: (json['debit'] as num?)?.toDouble() ?? 0.0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
    );
  }
}

// Display model for the UI
class TransactionDisplay {
  final String date;
  final String time;
  final String title;
  final String locationName;
  final String personName;
  final double amount;
  final bool isIncome;
  final String description;
  final JournalEntry journalEntry; // Reference to original journal entry for detail view

  TransactionDisplay({
    required this.date,
    required this.time,
    required this.title,
    required this.locationName,
    required this.personName,
    required this.amount,
    required this.isIncome,
    required this.description,
    required this.journalEntry,
  });
}

// Parameters for the provider
class CashJournalParams {
  final String companyId;
  final String storeId;
  final String locationType;
  final int offset;
  final int limit;

  CashJournalParams({
    required this.companyId,
    required this.storeId,
    required this.locationType,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashJournalParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          locationType == other.locationType &&
          offset == other.offset &&
          limit == other.limit;

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      locationType.hashCode ^
      offset.hashCode ^
      limit.hashCode;
}