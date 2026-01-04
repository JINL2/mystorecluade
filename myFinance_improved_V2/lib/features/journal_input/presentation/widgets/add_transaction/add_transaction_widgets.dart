/// Add Transaction Dialog Widgets
///
/// Barrel export for all reusable widgets used in AddTransactionDialog.
/// These widgets follow the Single Responsibility Principle and can be
/// composed to build the complete transaction dialog.
library;

// Header and Footer
export 'dialog_header.dart';
export 'dialog_footer.dart';

// Form Sections
export 'section_title.dart';
export 'debit_credit_toggle.dart';
export 'amount_input_section.dart';
export 'description_input_section.dart';
export 'debt_information_section.dart';

// Selection Sections
export 'cash_location_section.dart';
export 'counterparty_section.dart';
export 'counterparty_store_picker.dart';
export 'store_selection_sheet.dart';

// Status and Feedback
export 'account_mapping_status.dart';
export 'mapping_required_dialog.dart';

// Form Inputs
export 'form_date_picker.dart';
