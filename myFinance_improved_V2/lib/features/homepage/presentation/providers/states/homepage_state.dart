import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/category_with_features.dart';
import '../../../domain/entities/revenue.dart';
import '../../../domain/entities/top_feature.dart';

part 'homepage_state.freezed.dart';

/// Homepage State - UI state for homepage
///
/// Manages overall homepage data loading and display state
@freezed
class HomepageState with _$HomepageState {
  const factory HomepageState({
    @Default([]) List<CategoryWithFeatures> categories,
    @Default([]) List<TopFeature> topFeatures,
    Revenue? revenue,
    @Default(false) bool isLoadingCategories,
    @Default(false) bool isLoadingRevenue,
    @Default(false) bool isLoadingTopFeatures,
    String? errorMessage,
  }) = _HomepageState;
}

/// Revenue Tab State - UI state for revenue tab selection
@freezed
class RevenueTabState with _$RevenueTabState {
  const factory RevenueTabState({
    @Default(RevenueViewTab.company) RevenueViewTab selectedTab,
  }) = _RevenueTabState;
}

/// Revenue view tab options
enum RevenueViewTab {
  company,
  store,
}
