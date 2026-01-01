/// Transfer Selection Cards - Re-export from shared widgets
///
/// This file now re-exports the unified selection card widgets
/// from the shared widgets library for backward compatibility.
///
/// The original duplicate widgets have been consolidated into:
/// - TossSelectionCard (replaces SelectionCard)
/// - TossSelectionCard.store (replaces StoreSelectionCard)
/// - TossSelectionCard.company (replaces CompanySelectionCard)
/// - TossSummaryCard (replaces SummaryCard)
/// - TossNoticeCard.warning (replaces DebtTransactionNotice)
/// - TossTransferArrow (replaces TransferArrow)
library;

export 'package:myfinance_improved/shared/widgets/molecules/cards/toss_selection_card.dart';
