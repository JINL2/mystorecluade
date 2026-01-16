/// Transfer Selection Cards - DEPRECATED
///
/// This file previously re-exported TossSelectionCard widgets.
/// These have been replaced with:
/// - SelectionListItem (for selection lists)
/// - InfoCard.summary (for summary displays)
/// - InfoCard.alertWarning (for warning notices)
///
/// Import these directly from shared/widgets/index.dart instead.
library;

// Re-export InfoCard for backward compatibility
export 'package:myfinance_improved/shared/widgets/molecules/cards/info_card.dart';
export 'package:myfinance_improved/shared/widgets/molecules/sheets/selection_list_item.dart';
