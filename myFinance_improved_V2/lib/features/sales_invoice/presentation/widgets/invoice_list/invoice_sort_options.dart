/// Sort field options for invoice list
enum InvoiceSortField { date, amount }

/// Sort direction options
enum InvoiceSortDirection { asc, desc }

/// Sort option combining field and direction
class InvoiceSortOption {
  final InvoiceSortField field;
  final InvoiceSortDirection direction;

  const InvoiceSortOption(this.field, this.direction);

  static const dateAsc =
      InvoiceSortOption(InvoiceSortField.date, InvoiceSortDirection.asc);
  static const dateDesc =
      InvoiceSortOption(InvoiceSortField.date, InvoiceSortDirection.desc);
  static const amountAsc =
      InvoiceSortOption(InvoiceSortField.amount, InvoiceSortDirection.asc);
  static const amountDesc =
      InvoiceSortOption(InvoiceSortField.amount, InvoiceSortDirection.desc);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceSortOption &&
          field == other.field &&
          direction == other.direction;

  @override
  int get hashCode => field.hashCode ^ direction.hashCode;
}
