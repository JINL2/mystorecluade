// Presentation Page: Session Count Detail
// Page for viewing and managing inventory count session details
// Design matches stock_in_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../di/session_providers.dart';
import '../../domain/entities/session_list_item.dart';
import '../providers/session_list_provider.dart';
import '../widgets/count_detail/count_detail_header_section.dart';
import '../widgets/count_detail/count_detail_info_section.dart';
import '../widgets/count_detail/merge_session_bottom_sheet.dart';
import '../widgets/count_detail/session_user_model.dart';
import '../widgets/count_detail/session_user_section.dart';
import 'session_compare_page.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Session Count Detail Page
/// Shows session info and task sheets list
class SessionCountDetailPage extends ConsumerStatefulWidget {
  final String sessionId;
  final String sessionName;
  final String sessionType;
  final String storeId;
  final String storeName;
  final bool isActive;
  final String createdAt;
  final String? memo;
  final bool isOwner;

  const SessionCountDetailPage({
    super.key,
    required this.sessionId,
    required this.sessionName,
    required this.sessionType,
    required this.storeId,
    required this.storeName,
    required this.isActive,
    required this.createdAt,
    this.memo,
    this.isOwner = false,
  });

  @override
  ConsumerState<SessionCountDetailPage> createState() =>
      _SessionCountDetailPageState();
}

class _SessionCountDetailPageState
    extends ConsumerState<SessionCountDetailPage> {
  // Session users data from RPC
  List<SessionUser> _sessionUsers = [];
  bool _isLoadingUsers = false;

  // Editable state variables
  late String _sessionName;
  late String _storeName;
  String? _memo;

  // Join session state
  bool _isJoining = false;

  // Delete session state
  bool _isDeleting = false;

  bool get _isCounting => widget.sessionType == 'counting';

  @override
  void initState() {
    super.initState();
    _sessionName = widget.sessionName;
    _storeName = widget.storeName;
    _memo = widget.memo;

    // Load session users on init
    _loadSessionUsers();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final currentUserId = appState.userId;

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with title and actions
            CountDetailHeaderSection(
              sessionName: _sessionName,
              isOwner: widget.isOwner,
              isDeleting: _isDeleting,
              onDelete: _onDelete,
            ),
            // Details section
            CountDetailInfoSection(
              isActive: widget.isActive,
              createdAt: widget.createdAt,
              storeName: _storeName,
              memo: _memo,
            ),
            // Divider
            const GrayDividerSpace(),
            // Session User section
            SessionUserSection(
              sessionUsers: _sessionUsers,
              currentUserId: currentUserId,
              isCounting: _isCounting,
              isOwner: widget.isOwner,
              isLoadingUsers: _isLoadingUsers,
              isJoining: _isJoining,
              hasCurrentUserJoined: _hasCurrentUserJoined,
              onRefresh: _loadSessionUsers,
              onMerge: _onMerge,
              onJoin: _onJoinSession,
              onUserTap: _onSessionUserTap,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: _onBack,
        icon: const Icon(
          Icons.chevron_left,
          color: TossColors.gray900,
          size: 28,
        ),
      ),
      title: Text(
        _isCounting ? 'Count Details' : 'Receiving Details',
        style: TossTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      centerTitle: true,
      actions: [
        TossButton.textButton(
          text: 'Submit',
          onPressed: _onSubmit,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  /// Check if current user has already joined the session
  bool get _hasCurrentUserJoined {
    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;
    return _sessionUsers.any((user) => user.id == currentUserId);
  }

  void _onSubmit() {
    context.push(
      '/session/review/${widget.sessionId}'
      '?sessionType=${widget.sessionType}'
      '&sessionName=${Uri.encodeComponent(_sessionName)}'
      '&storeId=${widget.storeId}',
    );
  }

  /// Load session users from RPC (inventory_get_session_items)
  Future<void> _loadSessionUsers() async {
    if (_isLoadingUsers) return;

    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;

    if (currentUserId.isEmpty) return;

    setState(() {
      _isLoadingUsers = true;
    });

    try {
      final getSessionItems = ref.read(getSessionReviewItemsUseCaseProvider);
      final response = await getSessionItems(
        sessionId: widget.sessionId,
        userId: currentUserId,
      );

      if (!mounted) return;

      final users = response.participants
          .map(
            (p) => SessionUser(
              id: p.userId,
              userName: p.userName,
              userProfileImage: p.userProfileImage,
              itemsCount: p.productCount,
              quantity: p.totalScanned,
            ),
          )
          .toList();

      // Sort users: current user first, then others
      users.sort((a, b) {
        if (a.id == currentUserId) return -1;
        if (b.id == currentUserId) return 1;
        return 0;
      });

      setState(() {
        _sessionUsers = users;
        _isLoadingUsers = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingUsers = false;
      });
    }
  }

  void _onDelete() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isCounting ? 'Close Count Session' : 'Close Receiving Session'),
        content: Text(
          _isCounting
              ? 'Are you sure you want to close this count session?'
              : 'Are you sure you want to close this receiving session?',
        ),
        actions: [
          TossButton.textButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          TossButton.textButton(
            text: 'Close',
            textColor: TossColors.loss,
            onPressed: () {
              Navigator.pop(context);
              _executeDelete();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _executeDelete() async {
    if (_isDeleting) return;

    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final userId = appState.userId;

    if (companyId.isEmpty || userId.isEmpty) return;

    setState(() => _isDeleting = true);

    try {
      final closeSession = ref.read(closeSessionUseCaseProvider);
      await closeSession(
        sessionId: widget.sessionId,
        companyId: companyId,
        userId: userId,
      );

      if (!mounted) return;

      TossToast.success(
        context,
        _isCounting ? 'Count session closed' : 'Receiving session closed',
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      setState(() => _isDeleting = false);

      showDialog<void>(
        context: context,
        builder: (ctx) => TossDialog.error(
          title: 'Failed to Delete',
          message: e.toString().replaceFirst('Exception: ', ''),
          primaryButtonText: 'OK',
          onPrimaryPressed: () => Navigator.of(ctx).pop(),
        ),
      );
    }
  }

  Future<void> _onJoinSession() async {
    if (_isJoining) return;

    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;

    if (currentUserId.isEmpty) {
      if (mounted) {
        showDialog<void>(
          context: context,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'User not found',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(context).pop(),
          ),
        );
      }
      return;
    }

    setState(() => _isJoining = true);

    try {
      final joinSession = ref.read(joinSessionUseCaseProvider);
      await joinSession(
        sessionId: widget.sessionId,
        userId: currentUserId,
      );

      if (!mounted) return;

      await _loadSessionUsers();

      if (!mounted) return;

      TossToast.success(context, 'Successfully joined the session');
    } catch (e) {
      if (!mounted) return;

      showDialog<void>(
        context: context,
        builder: (ctx) => TossDialog.error(
          title: 'Failed to Join',
          message: e.toString().replaceFirst('Exception: ', ''),
          primaryButtonText: 'OK',
          onPrimaryPressed: () => Navigator.of(ctx).pop(),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
    }
  }

  void _onBack() {
    ref.read(sessionListNotifierProvider(widget.sessionType).notifier).refresh();
    Navigator.of(context).maybePop();
  }

  void _onMerge() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => MergeSessionBottomSheet(
        currentSessionId: widget.sessionId,
        sessionType: widget.sessionType,
        onSessionSelected: (SessionListItem selectedSession) {
          Navigator.pop(context);
          _navigateToComparePage(selectedSession);
        },
      ),
    );
  }

  void _navigateToComparePage(SessionListItem targetSession) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => SessionComparePage(
          sourceSessionId: widget.sessionId,
          sourceSessionName: _sessionName,
          targetSessionId: targetSession.sessionId,
          targetSessionName: targetSession.sessionName,
        ),
      ),
    );
  }

  Future<void> _onSessionUserTap(SessionUser user) async {
    await context.push<bool>(
      '/session/detail/${widget.sessionId}'
      '?sessionType=${widget.sessionType}'
      '&storeId=${widget.storeId}'
      '&sessionName=${Uri.encodeComponent(_sessionName)}',
    );

    if (mounted) {
      _loadSessionUsers();
    }
  }
}
