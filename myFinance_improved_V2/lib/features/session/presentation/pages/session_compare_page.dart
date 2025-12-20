import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../di/session_providers.dart';
import '../../domain/entities/session_compare_result.dart';

/// Page for comparing two sessions
/// Shows items that exist in target session but not in source session
class SessionComparePage extends ConsumerStatefulWidget {
  final String sourceSessionId;
  final String sourceSessionName;
  final String targetSessionId;
  final String targetSessionName;

  const SessionComparePage({
    super.key,
    required this.sourceSessionId,
    required this.sourceSessionName,
    required this.targetSessionId,
    required this.targetSessionName,
  });

  @override
  ConsumerState<SessionComparePage> createState() => _SessionComparePageState();
}

class _SessionComparePageState extends ConsumerState<SessionComparePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  SessionCompareResult? _compareResult;
  bool _isLoading = true;
  bool _isMerging = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCompareData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  Future<void> _loadCompareData() async {
    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

    if (userId.isEmpty) {
      setState(() {
        _isLoading = false;
        _error = 'User not found';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final compareSessions = ref.read(compareSessionsUseCaseProvider);
      final result = await compareSessions(
        sourceSessionId: widget.sourceSessionId,
        targetSessionId: widget.targetSessionId,
        userId: userId,
      );

      if (!mounted) return;

      setState(() {
        _compareResult = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.chevron_left,
          color: TossColors.gray900,
          size: 28,
        ),
      ),
      title: Text(
        'Compare Sessions',
        style: TossTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      centerTitle: true,
      bottom: _compareResult != null
          ? TabBar(
              controller: _tabController,
              labelColor: TossColors.primary,
              unselectedLabelColor: TossColors.gray500,
              indicatorColor: TossColors.primary,
              labelStyle: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TossTextStyles.caption,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              tabs: [
                Tab(
                  text: '${_truncate(widget.targetSessionName, 8)} (${_compareResult!.onlyInTarget.length})',
                ),
                Tab(
                  text: '${_truncate(widget.sourceSessionName, 8)} (${_compareResult!.onlyInSource.length})',
                ),
                Tab(
                  text: 'Both (${_compareResult!.inBoth.length})',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _buildErrorView();
    }

    if (_compareResult == null) {
      return const Center(child: Text('No data'));
    }

    return Column(
      children: [
        // Session info header
        _buildSessionInfoHeader(),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildItemList(
                _compareResult!.onlyInTarget,
                'Items in "${widget.targetSessionName}" but not in yours',
                TossColors.primary,
              ),
              _buildItemList(
                _compareResult!.onlyInSource,
                'Items in yours but not in "${widget.targetSessionName}"',
                TossColors.gray600,
              ),
              _buildItemList(
                _compareResult!.inBoth,
                'Items in both sessions',
                TossColors.success,
              ),
            ],
          ),
        ),
        // Fixed bottom merge button
        _buildMergeButton(),
      ],
    );
  }

  Widget _buildSessionInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
        color: TossColors.gray50,
        border: Border(
          bottom: BorderSide(color: TossColors.gray200),
        ),
      ),
      child: Row(
        children: [
          // Source session (Mine)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Session',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.sourceSessionName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_compareResult != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${_compareResult!.sourceSession.totalProducts} items',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Arrow
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
            child: Icon(
              Icons.compare_arrows,
              color: TossColors.gray400,
              size: 24,
            ),
          ),
          // Target session
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Target Session',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.targetSessionName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
                if (_compareResult != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${_compareResult!.targetSession.totalProducts} items',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(
    List<SessionCompareItem> items,
    String emptyMessage,
    Color accentColor,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Text(
            emptyMessage,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: TossColors.gray100,
        indent: TossSpacing.space4,
        endIndent: TossSpacing.space4,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItemCard(item, accentColor);
      },
    );
  }

  Widget _buildItemCard(SessionCompareItem item, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(8),
              image: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.imageUrl == null || item.imageUrl!.isEmpty
                ? const Icon(
                    Icons.inventory_2_outlined,
                    color: TossColors.gray400,
                    size: 24,
                  )
                : null,
          ),
          const SizedBox(width: TossSpacing.space3),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.sku != null && item.sku!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'SKU: ${item.sku}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
                if (item.scannedByName != null &&
                    item.scannedByName!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'By: ${item.scannedByName}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Quantity
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${item.quantity}',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMergeButton() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray200),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isMerging ? null : _onMerge,
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
              disabledBackgroundColor: TossColors.gray300,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isMerging
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: TossColors.white,
                    ),
                  )
                : Text(
                    'Merge',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _onMerge() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Merge Sessions'),
        content: Text(
          'Merge "${widget.targetSessionName}" into "${widget.sourceSessionName}"?\n\n'
          'All items from "${widget.targetSessionName}" will be copied to "${widget.sourceSessionName}" '
          'and "${widget.targetSessionName}" will be deactivated.',
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TossColors.gray700,
                    side: const BorderSide(color: TossColors.gray300),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    foregroundColor: TossColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Merge'),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isMerging = true);

    try {
      final appState = ref.read(appStateProvider);
      final userId = appState.userId;
      final mergeSessions = ref.read(mergeSessionsUseCaseProvider);

      await mergeSessions(
        targetSessionId: widget.sourceSessionId, // My session becomes target
        sourceSessionId: widget.targetSessionId, // Selected session is source
        userId: userId,
      );

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully merged "${widget.targetSessionName}" into "${widget.sourceSessionName}"'),
          backgroundColor: TossColors.success,
          duration: const Duration(seconds: 2),
        ),
      );

      // Go back to previous page (Count Details)
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Merge failed: ${e.toString().replaceFirst('Exception: ', '')}'),
          backgroundColor: TossColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isMerging = false);
      }
    }
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: TossColors.error,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Failed to compare sessions',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.textPrimary,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              _error ?? 'Unknown error',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space4),
            TextButton.icon(
              onPressed: _loadCompareData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
