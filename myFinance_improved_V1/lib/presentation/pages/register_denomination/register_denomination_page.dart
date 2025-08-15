import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../widgets/toss/toss_bottom_sheet.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import 'providers/currency_providers.dart';
import 'widgets/currency_overview_card.dart';
import 'widgets/add_currency_bottom_sheet.dart';

class RegisterDenominationPage extends ConsumerWidget {
  const RegisterDenominationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyCurrenciesAsync = ref.watch(searchFilteredCurrenciesProvider);
    final searchQuery = ref.watch(currencySearchQueryProvider);
    
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        backgroundColor: TossColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Denomination',
          style: TossTextStyles.h2.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
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
                  child: Center(
                    child: CircularProgressIndicator(
                      color: TossColors.primary,
                    ),
                  ),
                )
              ],
              error: (error, stackTrace) => [
                SliverFillRemaining(
                  child: _buildErrorState(error.toString()),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCurrencySheet(context),
        backgroundColor: TossColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add, size: 24),
        label: Text(
          'Add New',
          style: TossTextStyles.labelLarge.copyWith(
            color: Colors.white,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
            const SizedBox(height: TossSpacing.space6),
            Text(
              'No currencies yet',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Add your first currency to\nstart managing denominations',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space8),
            SizedBox(
              width: 200,
              child: TossPrimaryButton(
                text: 'Add Currency',
                onPressed: () => _showAddCurrencySheet(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space6),
            Text(
              'No currencies found',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Try searching with different keywords',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TossColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: TossColors.error,
              ),
            ),
            const SizedBox(height: TossSpacing.space6),
            Text(
              'Something went wrong',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              error,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: TossSpacing.space8),
            SizedBox(
              width: 200,
              child: TossPrimaryButton(
                text: 'Retry',
                onPressed: () {
                  // Refresh the data
                  // Note: In a real implementation, you might want to use ref.refresh()
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCurrencySheet(BuildContext context) {
    TossBottomSheet.show(
      context: context,
      content: const AddCurrencyBottomSheet(),
    );
  }
}