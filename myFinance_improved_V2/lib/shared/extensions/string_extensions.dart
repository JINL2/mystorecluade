/// String extensions for the entire project
extension StringExtensions on String {
  /// Capitalize first letter of string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Format category tag for display
  ///
  /// Converts category tags to human-readable format:
  /// - 'fixedasset' → 'Fixed Asset'
  /// - 'payable' → 'Payable'
  /// - etc.
  String formatCategoryTag() {
    switch (toLowerCase()) {
      case 'fixedasset':
        return 'Fixed Asset';
      case 'payable':
        return 'Payable';
      case 'receivable':
        return 'Receivable';
      case 'cash':
        return 'Cash';
      case 'bank':
        return 'Bank';
      case 'equity':
        return 'Equity';
      case 'revenue':
        return 'Revenue';
      case 'expense':
        return 'Expense';
      default:
        // Capitalize first letter
        if (isEmpty) return this;
        return this[0].toUpperCase() + substring(1);
    }
  }

  /// Convert to title case
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty ? word : word.capitalize())
        .join(' ');
  }
}
