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
import 'create_session/dialog_action_buttons.dart';
import 'create_session/dialog_empty_stores.dart';
import 'create_session/dialog_error_banner.dart';
import 'create_session/dialog_header.dart';
import 'create_session/dialog_selector_field.dart';

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
      showSearch: true,
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
      showSearch: true,
      onItemSelected: (item) {
        final shipment = _shipments.firstWhere((s) => s.shipmentId == item.id);
        setState(() {
          _selectedShipment = shipment;
          _error = null;
        });
      },
    );
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
            DialogHeader(
              icon: _isCounting
                  ? Icons.inventory_2_outlined
                  : Icons.local_shipping_outlined,
              title: 'Create ${_isCounting ? 'Stock Count' : 'Receiving'} Session',
              color: _typeColor,
              onClose: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: TossSpacing.space5),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(TossSpacing.space6),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_stores.isEmpty)
              DialogEmptyStores(
                onClose: () => Navigator.of(context).pop(),
              )
            else
              _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Shipment Selector (for receiving only)
        if (_isReceiving) ...[
          _buildFieldLabel('Shipment'),
          const SizedBox(height: TossSpacing.space2),
          DialogSelectorField(
            value: _selectedShipment?.shipmentNumber,
            subtitle: _selectedShipment != null
                ? '${_selectedShipment!.supplierName} • ${_selectedShipment!.itemCount} items'
                : null,
            placeholder: 'Select a shipment',
            isLoading: _isLoadingShipments,
            loadingText: 'Loading shipments...',
            onTap: _showShipmentSelector,
          ),
          const SizedBox(height: TossSpacing.space4),
        ],

        // Store Selector
        _buildFieldLabel('Store'),
        const SizedBox(height: TossSpacing.space2),
        DialogSelectorField(
          value: _selectedStore?.name,
          placeholder: 'Select a store',
          onTap: _showStoreSelector,
        ),
        const SizedBox(height: TossSpacing.space4),

        // Session Name Input
        _buildFieldLabel('Session Name (Optional)'),
        const SizedBox(height: TossSpacing.space2),
        _buildSessionNameInput(),

        // Error Message
        if (_error != null) ...[
          const SizedBox(height: TossSpacing.space3),
          DialogErrorBanner(message: _error!),
        ],

        const SizedBox(height: TossSpacing.space5),

        // Buttons
        DialogActionButtons(
          cancelText: 'Cancel',
          confirmText: 'Create',
          confirmColor: _typeColor,
          isLoading: _isCreating,
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: _createSession,
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TossTextStyles.bodySmall.copyWith(
        fontWeight: FontWeight.w500,
        color: TossColors.textSecondary,
      ),
    );
  }

  Widget _buildSessionNameInput() {
    return TextField(
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
