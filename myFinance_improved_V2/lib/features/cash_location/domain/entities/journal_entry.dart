/// Journal Entry entity for cash_location feature
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
