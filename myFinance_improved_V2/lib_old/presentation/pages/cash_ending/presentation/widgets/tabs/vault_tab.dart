import 'package:flutter/material.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../widgets/toss/toss_card.dart';
import 'animated_tab_mixin.dart';

/// Vault tab component for Cash Ending page with automatic UI transitions
/// Enhanced with smooth animations when vault location is selected
class VaultTab extends StatefulWidget {
  final String? selectedStoreId;
  final String? selectedVaultLocationId;
  final Widget Function() buildStoreSelector;
  final Widget Function(String) buildLocationSelector;
  final Widget Function({required String tabType}) buildDenominationSection;
  final Widget Function() buildDebitCreditToggle;
  final Widget Function({required String tabType}) buildTotalSection;
  final Widget Function() buildSubmitButton;
  final Widget Function({required bool showSection}) buildRealJournalSection;

  const VaultTab({
    super.key,
    required this.selectedStoreId,
    required this.selectedVaultLocationId,
    required this.buildStoreSelector,
    required this.buildLocationSelector,
    required this.buildDenominationSection,
    required this.buildDebitCreditToggle,
    required this.buildTotalSection,
    required this.buildSubmitButton,
    required this.buildRealJournalSection,
  });

  @override
  State<VaultTab> createState() => _VaultTabState();
}

class _VaultTabState extends State<VaultTab>
    with TickerProviderStateMixin, AnimatedTabMixin {
  
  @override
  void initState() {
    super.initState();
    // Initialize animations from mixin
    initializeAnimations();
  }
  
  @override
  void didUpdateWidget(VaultTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check for vault location selection changes
    checkLocationChange(oldWidget.selectedVaultLocationId, widget.selectedVaultLocationId);
  }
  
  @override
  void dispose() {
    // Dispose animations from mixin
    disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController, // Use animated scroll controller from mixin
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build the location selection card
          _buildLocationSelectionCard(),
          
          // Build the animated vault counting card (conditional)
          if (widget.selectedVaultLocationId != null) ...[
            const SizedBox(height: TossSpacing.space6),
            wrapWithFullAnimation(_buildVaultCountingCard()),
          ],
          
          // Build the animated transaction history section (conditional)
          if (widget.selectedVaultLocationId != null && widget.selectedVaultLocationId!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space5),
            buildDelayedAnimation(
              child: _buildTransactionHistorySection(),
              delay: const Duration(milliseconds: 300),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds the first card containing store and vault location selection
  Widget _buildLocationSelectionCard() {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store selector
          widget.buildStoreSelector(),
          
          // Vault location selector (conditional on store selection)
          if (widget.selectedStoreId != null) ...[
            const SizedBox(height: TossSpacing.space6),
            widget.buildLocationSelector('vault'),
          ],
        ],
      ),
    );
  }

  /// Builds the second card containing vault counting inputs and controls
  Widget _buildVaultCountingCard() {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Currency selection and denomination inputs
          widget.buildDenominationSection(tabType: 'vault'),
          
          const SizedBox(height: TossSpacing.space8),
          
          // Debit/Credit toggle (In/Out)
          widget.buildDebitCreditToggle(),
          
          const SizedBox(height: TossSpacing.space8),
          
          // Total display section
          widget.buildTotalSection(tabType: 'vault'),
          
          const SizedBox(height: TossSpacing.space10),
          
          // Submit button
          widget.buildSubmitButton(),
        ],
      ),
    );
  }

  /// Builds the transaction history section for vault
  Widget _buildTransactionHistorySection() {
    return widget.buildRealJournalSection(
      showSection: true,
    );
  }

}