/// Template Form Analyzer Service
/// Extracted from template_usage_bottom_sheet.dart for proper separation of concerns

// Form complexity levels
enum FormComplexity {
  simple,        // Only amount input needed
  withCash,      // Need cash location selection
  withCounterparty, // Need counterparty's cash location
  complex        // Multiple selections needed
}