import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../di/session_providers.dart';
import '../../domain/entities/session_compare_result.dart';
import '../widgets/compare/compare_error_view.dart';
import '../widgets/compare/compare_item_card.dart';
import '../widgets/compare/compare_merge_button.dart';
import '../widgets/compare/compare_session_info_header.dart';

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
              labelPadding: const EdgeInsets.symmetric(horizontal: TossSpacing.space1),
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
      return CompareErrorView(
        error: _error,
        onRetry: _loadCompareData,
      );
    }

    if (_compareResult == null) {
      return const Center(child: Text('No data'));
    }

    return Column(
      children: [
        // Session info header
        CompareSessionInfoHeader(
          sourceSessionName: widget.sourceSessionName,
          targetSessionName: widget.targetSessionName,
          compareResult: _compareResult,
        ),
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
        CompareMergeButton(
          isMerging: _isMerging,
          onMerge: _onMerge,
        ),
      ],
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
        return CompareItemCard(item: item, accentColor: accentColor);
      },
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
        actionsPadding: const EdgeInsets.fromLTRB(TossSpacing.space4, 0, TossSpacing.space4, TossSpacing.space4),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TossColors.gray700,
                    side: const BorderSide(color: TossColors.gray300),
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    foregroundColor: TossColors.white,
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
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
}
