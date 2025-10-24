// Value Object: Sort Option
// Encapsulates product sorting criteria

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

  String get displayLabel {
    final fieldLabel = field.displayName;
    final directionLabel = direction.displayName;
    return '$fieldLabel ($directionLabel)';
  }

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

enum SortField {
  name,
  price,
  stock,
  createdAt;

  String get displayName {
    switch (this) {
      case SortField.name:
        return '이름';
      case SortField.price:
        return '가격';
      case SortField.stock:
        return '재고';
      case SortField.createdAt:
        return '등록일';
    }
  }

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

enum SortDirection {
  asc,
  desc;

  String get displayName {
    switch (this) {
      case SortDirection.asc:
        return '오름차순';
      case SortDirection.desc:
        return '내림차순';
    }
  }

  String get dbValue {
    switch (this) {
      case SortDirection.asc:
        return 'asc';
      case SortDirection.desc:
        return 'desc';
    }
  }
}
