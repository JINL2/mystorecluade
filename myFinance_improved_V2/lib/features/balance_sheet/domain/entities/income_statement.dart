import 'package:freezed_annotation/freezed_annotation.dart';
import 'financial_account.dart';
import '../value_objects/date_range.dart';

part 'income_statement.freezed.dart';

/// Income statement subcategory
@freezed
class IncomeStatementSubcategory with _$IncomeStatementSubcategory {
  const factory IncomeStatementSubcategory({
    required String subcategoryName,
    required double subcategoryTotal,
    required List<IncomeStatementAccount> accounts,
  }) = _IncomeStatementSubcategory;
}

/// Income statement section
@freezed
class IncomeStatementSection with _$IncomeStatementSection {
  const factory IncomeStatementSection({
    required String sectionName,
    required dynamic sectionTotal, // Can be double or String (for margins)
    required List<IncomeStatementSubcategory> subcategories,
  }) = _IncomeStatementSection;
}

/// Income statement entity
@freezed
class IncomeStatement with _$IncomeStatement {
  const factory IncomeStatement({
    required List<IncomeStatementSection> sections,
    required DateRange dateRange,
    required String companyId,
    String? storeId,
  }) = _IncomeStatement;

  const IncomeStatement._();

  /// Find section total by name
  String findSectionTotal(String sectionName) {
    try {
      final section = sections.firstWhere(
        (s) => s.sectionName == sectionName,
        orElse: () => const IncomeStatementSection(
          sectionName: '',
          sectionTotal: '0',
          subcategories: [],
        ),
      );
      return section.sectionTotal?.toString() ?? '0';
    } catch (e) {
      return '0';
    }
  }
}
