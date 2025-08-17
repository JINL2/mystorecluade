import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../widgets/toss/toss_bottom_sheet.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_animations.dart';
import 'providers/currency_providers.dart';
import 'widgets/currency_overview_card.dart';
import 'widgets/add_currency_bottom_sheet.dart';

class RegisterDenominationPage extends ConsumerWidget {
  const RegisterDenominationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyCurrenciesAsync = ref.watch(searchFilteredCurrenciesProvider);
    final searchQuery = ref.watch(currencySearchQueryProvider);
    
    return TossScaffold(
      backgroundColor: TossColors.background,
      appBar: const TossAppBar(
        title: 'Denomination',
        centerTitle: true,
        backgroundColor: TossColors.background,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(ref),
          color: TossColors.primary,
          backgroundColor: TossColors.white,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: TossSearchField(
                  onChanged: (query) => ref.read(currencySearchQueryProvider.notifier).state = query,
                  hintText: 'Search currencies...',
                  prefixIcon: Icons.search,
                  onClear: () => ref.read(currencySearchQueryProvider.notifier).state = '',
                ),
              ),
            ),
            
            // Currency list content
            ...companyCurrenciesAsync.when(
              data: (currencies) {
                if (currencies.isEmpty && searchQuery.isNotEmpty) {
                  return [
                    SliverFillRemaining(
                      child: _buildEmptySearchState(),
                    )
                  ];
                } else if (currencies.isEmpty) {
                  return [
                    SliverFillRemaining(
                      child: _buildEmptyState(context),
                    )
                  ];
                } else {
                  return [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                      sliver: SliverList.builder(
                        itemCount: currencies.length,
                        itemBuilder: (context, index) {
                          final currency = currencies[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: TossSpacing.space3),
                            child: CurrencyOverviewCard(
                              currency: currency,
                            ),
                          );
                        },
                      ),
                    ),
                  ];
                }
              },
              loading: () => [
                const SliverFillRemaining(
                  child: TossLoadingView(
                    message: 'Loading currencies...',
                  ),
                )
              ],
              error: (error, stackTrace) => [
                SliverFillRemaining(
                  child: TossErrorView(
                    error: error,
                    onRetry: () => ref.invalidate(searchFilteredCurrenciesProvider),
                  ),
                )
              ],
            ),
              
            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: TossSpacing.space8),
            ),
          ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCurrencySheet(context),
        backgroundColor: TossColors.primary,
        foregroundColor: TossColors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: Text(
          'Add New',
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return TossEmptyView(
      icon: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
        ),
        child: const Icon(
          Icons.currency_exchange,
          size: 40,
          color: TossColors.gray400,
        ),
      ),
      title: 'No currencies yet',
      description: 'Add your first currency to start managing denominations\n\nPull down to refresh if currencies don\'t appear',
      action: SizedBox(
        width: 200,
        child: TossPrimaryButton(
          text: 'Add Currency',
          onPressed: () => _showAddCurrencySheet(context),
        ),
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return const TossEmptyView(
      icon: Icon(
        Icons.search_off,
        size: 64,
        color: TossColors.gray400,
      ),
      title: 'No currencies found',
      description: 'Try searching with different keywords',
    );
  }

  // This method is no longer needed as we're using TossErrorView directly

  Future<void> _onRefresh(WidgetRef ref) async {
    // Haptic feedback for better UX
    HapticFeedback.lightImpact();
    
    // Clear search query to show all currencies during refresh
    ref.read(currencySearchQueryProvider.notifier).state = '';
    
    // Invalidate all currency-related providers to force fresh data
    ref.invalidate(companyCurrenciesProvider);
    ref.invalidate(companyCurrenciesStreamProvider);
    ref.invalidate(searchFilteredCurrenciesProvider);
    ref.invalidate(availableCurrenciesToAddProvider);
    
    try {
      // Force refresh of the main provider
      ref.refresh(searchFilteredCurrenciesProvider);
      
      // Wait a bit for the refresh to propagate
      await Future.delayed(TossAnimations.medium);
      
      // Additional haptic feedback on successful refresh
      HapticFeedback.selectionClick();
    } catch (e) {
      // Handle refresh errors gracefully
      debugPrint('Refresh failed: $e');
    }
    
    // Small delay for smooth UX
    await Future.delayed(TossAnimations.normal);
  }

  void _showAddCurrencySheet(BuildContext context) {
    TossBottomSheet.show(
      context: context,
      content: const AddCurrencyBottomSheet(),
    );
  }
}