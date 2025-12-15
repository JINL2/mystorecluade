// Presentation Page: Session Count Detail
// Page for viewing and managing inventory count session details
// Design matches stock_in_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/gray_divider_space.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_badge.dart';
import '../../di/session_providers.dart';

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
  List<_SessionUser> _sessionUsers = [];
  bool _isLoadingUsers = false;
  String? _loadError;

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
    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with title and actions
            _buildHeaderSection(),
            // Details section
            _buildDetailsSection(),
            // Divider
            const GrayDividerSpace(),
            // Session User section
            _buildSessionUserSection(),
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
        onPressed: () => Navigator.of(context).maybePop(),
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
        TextButton(
          onPressed: _onSubmit,
          child: Text(
            'Submit',
            style: TossTextStyles.body.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title (Session Name)
          Expanded(
            child: Text(
              _sessionName,
              style: TossTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: TossColors.gray900,
              ),
            ),
          ),
          // Delete button (only visible to session owner)
          if (widget.isOwner)
            GestureDetector(
              onTap: _isDeleting ? null : _onDelete,
              child: _isDeleting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: TossColors.loss,
                      ),
                    )
                  : const Icon(
                      Icons.delete_outline,
                      color: TossColors.loss,
                      size: 22,
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          // Status row
          _buildDetailRow(
            label: 'Status',
            child: _buildStatusBadge(),
          ),
          const SizedBox(height: TossSpacing.space3),
          // Started row
          _buildDetailRow(
            label: 'Started',
            value: _formatDateTime(widget.createdAt),
          ),
          const SizedBox(height: TossSpacing.space3),
          // Location row
          _buildDetailRow(
            label: 'Location',
            value: _storeName,
          ),
          const SizedBox(height: TossSpacing.space3),
          // Items row
          _buildDetailRow(
            label: 'Items',
            value: 'All items',
          ),
          const SizedBox(height: TossSpacing.space3),
          // Memo row
          _buildMemoRow(context),
          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    String? value,
    Widget? child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ),
        if (child != null)
          child
        else
          Expanded(
            child: Text(
              value ?? '',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMemoRow(BuildContext context) {
    final hasMemo = _memo != null && _memo!.isNotEmpty;

    return GestureDetector(
      onTap: hasMemo ? () => _showFullMemo(context) : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              'Memo',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              hasMemo ? _memo! : '-',
              style: TossTextStyles.body.copyWith(
                color: hasMemo ? TossColors.gray900 : TossColors.gray400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasMemo) ...[
            const SizedBox(width: TossSpacing.space2),
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }

  void _showFullMemo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              // Title
              Text(
                'Memo',
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              // Full memo content
              Text(
                _memo!,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return TossStatusBadge(
      label: widget.isActive ? 'In Progress' : 'Done',
      status: widget.isActive ? BadgeStatus.success : BadgeStatus.info,
    );
  }

  /// Check if current user has already joined the session
  bool get _hasCurrentUserJoined {
    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;
    return _sessionUsers.any((user) => user.id == currentUserId);
  }

  Widget _buildSessionUserSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Session User',
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              Row(
                children: [
                  // Refresh button
                  GestureDetector(
                    onTap: _isLoadingUsers ? null : _loadSessionUsers,
                    child: _isLoadingUsers
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: TossColors.gray400,
                            ),
                          )
                        : const Icon(
                            Icons.refresh,
                            color: TossColors.gray500,
                            size: 22,
                          ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  // Join button - disabled if current user already joined
                  GestureDetector(
                    onTap: (_isJoining || _hasCurrentUserJoined) ? null : _onJoinSession,
                    child: _isJoining
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: TossColors.primary,
                            ),
                          )
                        : Text(
                            '+ Join',
                            style: TossTextStyles.body.copyWith(
                              color: _hasCurrentUserJoined
                                  ? TossColors.gray400
                                  : TossColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Session users list or empty state
        if (_sessionUsers.isEmpty)
          _buildSessionUserEmptyState()
        else
          _buildSessionUserList(),
      ],
    );
  }

  Widget _buildSessionUserEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space6,
      ),
      child: Center(
        child: Text(
          _isCounting
              ? 'Join the session to start your inventory count.'
              : 'Join the session to start your receiving.',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ),
    );
  }

  Widget _buildSessionUserList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sessionUsers.length,
      itemBuilder: (context, index) {
        final user = _sessionUsers[index];
        return _buildSessionUserCard(user);
      },
    );
  }

  Widget _buildSessionUserCard(_SessionUser user) {
    // Check if this is the current user's card
    final appState = ref.read(appStateProvider);
    final isCurrentUser = user.id == appState.userId;

    return GestureDetector(
      // Only current user can tap their card
      onTap: isCurrentUser ? () => _onSessionUserTap(user) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrentUser ? TossColors.primary : TossColors.gray200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: Profile image + User name (no status badge)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User profile image (small, matching text size)
                _buildUserProfileImage(user.userProfileImage),
                const SizedBox(width: TossSpacing.space2),
                // User name
                Expanded(
                  child: Text(
                    user.userName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
            // Details section: Items, Quantity, Started (no right column)
            Column(
              children: [
                _buildSessionUserDetailRow('Items', '${user.itemsCount}'),
                const SizedBox(height: TossSpacing.space2),
                _buildSessionUserDetailRow('Quantity', '${user.quantity}'),
                const SizedBox(height: TossSpacing.space2),
                _buildSessionUserDetailRow(
                  'Started',
                  _formatShortDateTime(DateTime.now()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileImage(String? profileImageUrl) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: TossColors.gray100,
        image: profileImageUrl != null && profileImageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(profileImageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: profileImageUrl == null || profileImageUrl.isEmpty
          ? const Icon(
              Icons.person,
              color: TossColors.gray400,
              size: 12,
            )
          : null,
    );
  }

  String _formatShortDateTime(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final month = months[dateTime.month - 1];
    final day = dateTime.day.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$month $day, $year · $hour:$minute';
  }

  Widget _buildSessionUserDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ),
        Text(
          value,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final formatter = DateFormat('MMMM dd, yyyy h:mm a');
      return formatter.format(dateTime);
    } catch (_) {
      return createdAt;
    }
  }

  void _onSubmit() {
    // Navigate to review page with storeId for stock lookup
    context.push(
      '/session/review/${widget.sessionId}'
      '?sessionType=${widget.sessionType}'
      '&sessionName=${Uri.encodeComponent(_sessionName)}'
      '&storeId=${widget.storeId}',
    );
  }

  /// Load session users from RPC (inventory_get_session_items)
  /// Uses participants array which includes all session members
  Future<void> _loadSessionUsers() async {
    if (_isLoadingUsers) return;

    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;

    if (currentUserId.isEmpty) return;

    setState(() {
      _isLoadingUsers = true;
      _loadError = null;
    });

    try {
      final getSessionItems = ref.read(getSessionReviewItemsUseCaseProvider);
      final response = await getSessionItems(
        sessionId: widget.sessionId,
        userId: currentUserId,
      );

      if (!mounted) return;

      // Use participants array directly from RPC response
      // This includes all session members, even those who haven't scanned anything
      final users = response.participants
          .map(
            (p) => _SessionUser(
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
        _loadError = e.toString().replaceFirst('Exception: ', '');
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _executeDelete();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: TossColors.loss),
            ),
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

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isCounting
                ? 'Count session closed'
                : 'Receiving session closed',
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate back to session list
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      setState(() => _isDeleting = false);

      // Show error dialog
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
      // Call inventory_join_session RPC
      final joinSession = ref.read(joinSessionUseCaseProvider);
      await joinSession(
        sessionId: widget.sessionId,
        userId: currentUserId,
      );

      if (!mounted) return;

      // Reload session users from RPC after successful join
      await _loadSessionUsers();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully joined the session'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      // Show error dialog
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

  Future<void> _onSessionUserTap(_SessionUser user) async {
    // Navigate to session detail page (counting/receiving page)
    await context.push<bool>(
      '/session/detail/${widget.sessionId}'
      '?sessionType=${widget.sessionType}'
      '&storeId=${widget.storeId}'
      '&sessionName=${Uri.encodeComponent(_sessionName)}',
    );

    // Always refresh data when returning from detail page
    if (mounted) {
      _loadSessionUsers();
    }
  }
}

/// Session user data model (from inventory_get_session_items RPC participants)
class _SessionUser {
  final String id;
  final String userName;
  final String? userProfileImage;
  final int itemsCount;
  final int quantity;

  _SessionUser({
    required this.id,
    required this.userName,
    this.userProfileImage,
    required this.itemsCount,
    required this.quantity,
  });
}
