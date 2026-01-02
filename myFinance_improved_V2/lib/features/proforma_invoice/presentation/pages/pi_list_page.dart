import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../domain/entities/proforma_invoice.dart';
import '../providers/pi_providers.dart';
import '../widgets/pi_list_item.dart';
import '../widgets/pi_filter_chips.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class PIListPage extends ConsumerStatefulWidget {
  const PIListPage({super.key});

  @override
  ConsumerState<PIListPage> createState() => _PIListPageState();
}

class _PIListPageState extends ConsumerState<PIListPage> {
  final _scrollController = ScrollController();
  List<PIStatus>? _selectedStatuses;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(piListProvider.notifier).loadList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(piListProvider.notifier).loadMore();
    }
  }

  void _onFilterChanged(List<PIStatus>? statuses) {
    setState(() => _selectedStatuses = statuses);
    ref.read(piListProvider.notifier).loadList(
          statuses: statuses,
          searchQuery: _searchQuery,
        );
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query.isEmpty ? null : query);
    ref.read(piListProvider.notifier).loadList(
          statuses: _selectedStatuses,
          searchQuery: _searchQuery,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(piListProvider);

    // 초기 로딩 중일 때 전체 화면 로딩 뷰 표시
    if (state.isLoading && state.items.isEmpty) {
      return TossScaffold(
        appBar: TossAppBar(
          title: 'Proforma Invoice',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
        ),
        body: const TossLoadingView(message: 'Loading...'),
      );
    }

    return TossScaffold(
      appBar: TossAppBar(
        title: 'Proforma Invoice',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        primaryActionIcon: Icons.add,
        primaryActionText: 'New',
        onPrimaryAction: () => context.push('/proforma-invoice/new'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: TossTextField.filled(
              hintText: 'Search by PI number or buyer...',
              prefixIcon: const Icon(Icons.search, size: 20),
              onChanged: _onSearch,
            ),
          ),

          // Filter chips
          PIFilterChips(
            selectedStatuses: _selectedStatuses,
            onChanged: _onFilterChanged,
          ),

          const SizedBox(height: TossSpacing.space2),

          // List
          Expanded(
            child: _buildContent(state),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(PIListState state) {
    // 초기 로딩은 build()에서 처리하므로 여기서는 에러만 처리
    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Failed to load',
              style: TossTextStyles.bodyLarge.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: TossSpacing.space2),
            TossButton.textButton(
              text: 'Retry',
              onPressed: () => ref.read(piListProvider.notifier).refresh(),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, size: 64, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No Proforma Invoices',
              style: TossTextStyles.h3.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Create your first PI to get started',
              style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray500),
            ),
            const SizedBox(height: TossSpacing.space4),
            TossButton.primary(
              text: 'Create PI',
              leadingIcon: const Icon(Icons.add, size: 20, color: TossColors.white),
              onPressed: () => context.push('/proforma-invoice/new'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(piListProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: TossLoadingView(),
            );
          }

          final item = state.items[index];
          return PIListItemWidget(
            item: item,
            onTap: () async {
              final result = await context.push<bool>('/proforma-invoice/${item.id}');
              if (result == true) {
                ref.read(piListProvider.notifier).refresh();
              }
            },
          );
        },
      ),
    );
  }
}
