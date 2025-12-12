import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../auth/di/auth_providers.dart';
import '../../../auth/domain/entities/store_entity.dart';
import '../../di/session_providers.dart';
import '../../domain/entities/inventory_session.dart';
import '../../domain/entities/shipment.dart';

/// Dialog for creating a new session (Stock Count or Receiving)
class CreateSessionDialog extends ConsumerStatefulWidget {
  final String sessionType; // 'counting' or 'receiving'

  const CreateSessionDialog({
    super.key,
    required this.sessionType,
  });

  @override
  ConsumerState<CreateSessionDialog> createState() =>
      _CreateSessionDialogState();
}

class _CreateSessionDialogState extends ConsumerState<CreateSessionDialog> {
  final _sessionNameController = TextEditingController();
  Store? _selectedStore;
  List<Store> _stores = [];
  Shipment? _selectedShipment;
  List<Shipment> _shipments = [];
  bool _isLoading = true;
  bool _isLoadingShipments = false;
  bool _isCreating = false;
  String? _error;

  bool get _isCounting => widget.sessionType == 'counting';
  bool get _isReceiving => widget.sessionType == 'receiving';
  Color get _typeColor =>
      _isCounting ? TossColors.primary : TossColors.success;

  @override
  void initState() {
    super.initState();
    _sessionNameController.text = 'Session1';
    _loadData();
  }

  @override
  void dispose() {
    _sessionNameController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final appState = ref.read(appStateProvider);
      final userId = appState.userId;
      final companyId = appState.companyChoosen;

      if (userId.isEmpty) {
        setState(() {
          _error = 'User not found';
          _isLoading = false;
        });
        return;
      }

      // Load stores
      final userRepository = ref.read(userRepositoryProvider);
      final stores = await userRepository.getStores(userId);

      setState(() {
        _stores = stores;
        // Pre-select the current store if available
        if (stores.isNotEmpty) {
          final currentStoreId = appState.storeChoosen;
          _selectedStore = stores.firstWhere(
            (s) => s.id == currentStoreId,
            orElse: () => stores.first,
          );
        }
      });

      // Load shipments for receiving type
      if (_isReceiving && companyId.isNotEmpty) {
        await _loadShipments(companyId);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadShipments(String companyId) async {
    setState(() {
      _isLoadingShipments = true;
    });

    try {
      final getShipmentList = ref.read(getShipmentListUseCaseProvider);

      // Date range: 1 year ago to today (user's local time)
      final now = DateTime.now();
      final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
      final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Fetch all shipments within date range (no status filter)
      final response = await getShipmentList(
        companyId: companyId,
        startDate: oneYearAgo,
        endDate: endOfToday,
        limit: 500,
      );

      // Filter client-side: only show pending or process shipments
      final filteredShipments = response.shipments
          .where((s) => s.status == 'pending' || s.status == 'process')
          .toList();

      setState(() {
        _shipments = filteredShipments;
        _isLoadingShipments = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingShipments = false;
      });
    }
  }

  Future<void> _createSession() async {
    if (_selectedStore == null) {
      setState(() => _error = 'Please select a store');
      return;
    }

    // For receiving, shipment is required
    if (_isReceiving && _selectedShipment == null) {
      setState(() => _error = 'Please select a shipment');
      return;
    }

    setState(() {
      _isCreating = true;
      _error = null;
    });

    try {
      final appState = ref.read(appStateProvider);
      final userId = appState.userId;
      final companyId = appState.companyChoosen;

      if (userId.isEmpty || companyId.isEmpty) {
        setState(() {
          _error = 'User or company not found';
          _isCreating = false;
        });
        return;
      }

      final createSession = ref.read(createSessionUseCaseProvider);
      final response = await createSession(
        companyId: companyId,
        storeId: _selectedStore!.id,
        userId: userId,
        sessionType: widget.sessionType,
        sessionName: _sessionNameController.text.trim().isNotEmpty
            ? _sessionNameController.text.trim()
            : null,
        shipmentId: _selectedShipment?.shipmentId,
      );

      if (mounted) {
        Navigator.of(context).pop(response);
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isCreating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    _isCounting
                        ? Icons.inventory_2_outlined
                        : Icons.local_shipping_outlined,
                    color: _typeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    'Create ${_isCounting ? 'Stock Count' : 'Receiving'} Session',
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: TossColors.textTertiary),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space5),

            // Content
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(TossSpacing.space6),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_stores.isEmpty)
              _buildEmptyStores()
            else
              _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStores() {
    return Column(
      children: [
        const Icon(
          Icons.store_outlined,
          size: 48,
          color: TossColors.textTertiary,
        ),
        const SizedBox(height: TossSpacing.space3),
        Text(
          'No stores available',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Shipment Selector (for receiving only)
        if (_isReceiving) ...[
          Text(
            'Shipment',
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.textSecondary,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          _buildShipmentSelector(),
          const SizedBox(height: TossSpacing.space4),
        ],

        // Store Selector
        Text(
          'Store',
          style: TossTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        _buildStoreSelector(),
        const SizedBox(height: TossSpacing.space4),

        // Session Name Input
        Text(
          'Session Name (Optional)',
          style: TossTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TextField(
          controller: _sessionNameController,
          decoration: InputDecoration(
            hintText: _isCounting
                ? 'e.g., December Stock Count'
                : 'e.g., Weekly Receiving',
            hintStyle: TossTextStyles.body.copyWith(
              color: TossColors.textTertiary,
            ),
            filled: true,
            fillColor: TossColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
          ),
        ),

        // Error Message
        if (_error != null) ...[
          const SizedBox(height: TossSpacing.space3),
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: TossColors.error,
                  size: 20,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    _error!,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: TossSpacing.space5),

        // Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed:
                    _isCreating ? null : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                onPressed: _isCreating ? null : _createSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _typeColor,
                  foregroundColor: TossColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  elevation: 0,
                ),
                child: _isCreating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: TossColors.white,
                        ),
                      )
                    : const Text('Create'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showStoreSelector() async {
    final items = _stores.map((store) {
      return TossSelectionItem(
        id: store.id,
        title: store.name,
        isSelected: _selectedStore?.id == store.id,
      );
    }).toList();

    await TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Select Store',
      items: items,
      selectedId: _selectedStore?.id,
      showSubtitle: false,
      onItemSelected: (item) {
        final store = _stores.firstWhere((s) => s.id == item.id);
        setState(() {
          _selectedStore = store;
          _error = null;
        });
      },
    );
  }

  Future<void> _showShipmentSelector() async {
    if (_shipments.isEmpty) {
      setState(() => _error = 'No pending shipments available');
      return;
    }

    final items = _shipments.map((shipment) {
      return TossSelectionItem(
        id: shipment.shipmentId,
        title: shipment.shipmentNumber,
        subtitle: '${shipment.supplierName} • ${shipment.itemCount} items',
        isSelected: _selectedShipment?.shipmentId == shipment.shipmentId,
      );
    }).toList();

    await TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Select Shipment',
      items: items,
      selectedId: _selectedShipment?.shipmentId,
      showSubtitle: true,
      onItemSelected: (item) {
        final shipment = _shipments.firstWhere((s) => s.shipmentId == item.id);
        setState(() {
          _selectedShipment = shipment;
          _error = null;
        });
      },
    );
  }

  Widget _buildStoreSelector() {
    return InkWell(
      onTap: _showStoreSelector,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedStore?.name ?? 'Select a store',
                style: TossTextStyles.body.copyWith(
                  color: _selectedStore != null
                      ? TossColors.textPrimary
                      : TossColors.textTertiary,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: TossColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentSelector() {
    return InkWell(
      onTap: _isLoadingShipments ? null : _showShipmentSelector,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          children: [
            Expanded(
              child: _isLoadingShipments
                  ? Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          'Loading shipments...',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedShipment?.shipmentNumber ??
                              'Select a shipment',
                          style: TossTextStyles.body.copyWith(
                            color: _selectedShipment != null
                                ? TossColors.textPrimary
                                : TossColors.textTertiary,
                          ),
                        ),
                        if (_selectedShipment != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${_selectedShipment!.supplierName} • ${_selectedShipment!.itemCount} items',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: TossColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the create session dialog and returns the created session response
Future<CreateSessionResponse?> showCreateSessionDialog(
  BuildContext context, {
  required String sessionType,
}) async {
  return showDialog<CreateSessionResponse>(
    context: context,
    barrierDismissible: true,
    builder: (context) => CreateSessionDialog(sessionType: sessionType),
  );
}
