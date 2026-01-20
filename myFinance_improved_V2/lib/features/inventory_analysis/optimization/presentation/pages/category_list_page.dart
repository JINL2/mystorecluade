import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/index.dart';
import '../providers/inventory_optimization_providers.dart';
import '../widgets/category_list_tile.dart';
import 'product_list_page.dart';

/// 카테고리 목록 페이지
class CategoryListPage extends ConsumerWidget {
  final String companyId;

  const CategoryListPage({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categorySummariesProvider(companyId));

    return TossScaffold(
      appBar: TossAppBar(
        title: 'Categories',
        primaryActionIcon: Icons.refresh,
        onPrimaryAction: () {
          ref.invalidate(categorySummariesProvider(companyId));
        },
      ),
      body: categoriesAsync.when(
        loading: () => const TossLoadingView(),
        error: (error, stack) => TossErrorView(
          error: error,
          onRetry: () {
            ref.invalidate(categorySummariesProvider(companyId));
          },
        ),
        data: (categories) {
          if (categories.isEmpty) {
            return const TossEmptyView(
              icon: Icon(Icons.category_outlined, size: 48),
              title: 'No Categories',
              description: 'No product categories found',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(categorySummariesProvider(companyId));
            },
            color: TossColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.all(TossSpacing.paddingXL),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: TossSpacing.gapMD),
                  child: CategoryListTile(
                    category: category,
                    onTap: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => ProductListPage(
                            companyId: companyId,
                            categoryId: category.categoryId,
                            title: category.categoryName,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
