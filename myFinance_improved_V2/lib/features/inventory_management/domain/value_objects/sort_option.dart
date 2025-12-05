// Value Object: Sort Option
// Encapsulates product sorting criteria
// Note: Display names should be handled in Presentation layer via extensions

class SortOption {
  final SortField field;
  final SortDirection direction;

  const SortOption({
    required this.field,
    required this.direction,
  });

  // Default sort option
  static const SortOption defaultOption = SortOption(
    field: SortField.name,
    direction: SortDirection.asc,
  );

  // Common sort options
  static const SortOption nameAsc = SortOption(
    field: SortField.name,
    direction: SortDirection.asc,
  );

  static const SortOption nameDesc = SortOption(
    field: SortField.name,
    direction: SortDirection.desc,
  );

  static const SortOption priceAsc = SortOption(
    field: SortField.price,
    direction: SortDirection.asc,
  );

  static const SortOption priceDesc = SortOption(
    field: SortField.price,
    direction: SortDirection.desc,
  );

  static const SortOption stockAsc = SortOption(
    field: SortField.stock,
    direction: SortDirection.asc,
  );

  static const SortOption stockDesc = SortOption(
    field: SortField.stock,
    direction: SortDirection.desc,
  );

  static const SortOption createdDesc = SortOption(
    field: SortField.createdAt,
    direction: SortDirection.desc,
  );

  SortOption toggleDirection() {
    return SortOption(
      field: field,
      direction: direction == SortDirection.asc
          ? SortDirection.desc
          : SortDirection.asc,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SortOption &&
        other.field == field &&
        other.direction == direction;
  }

  @override
  int get hashCode => field.hashCode ^ direction.hashCode;
}

/// Sort field options for product listing
enum SortField {
  name,
  price,
  stock,
  createdAt;

  /// Database field name for RPC queries
  String get dbFieldName {
    switch (this) {
      case SortField.name:
        return 'name';
      case SortField.price:
        return 'price';
      case SortField.stock:
        return 'stock';
      case SortField.createdAt:
        return 'created_at';
    }
  }
}

/// Sort direction options
enum SortDirection {
  asc,
  desc;

  /// Database value for RPC queries
  String get dbValue {
    switch (this) {
      case SortDirection.asc:
        return 'asc';
      case SortDirection.desc:
        return 'desc';
    }
  }
}
