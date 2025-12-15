import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../auth/di/auth_providers.dart';
import '../../../auth/domain/entities/store_entity.dart';
import '../../di/session_providers.dart';
import '../../domain/entities/shipment.dart';

/// Full-page session creation
/// Design matches new_stock_in_record_page.dart
class CreateSessionPage extends ConsumerStatefulWidget {
  final String sessionType; // 'counting' or 'receiving'

  const CreateSessionPage({
    super.key,
    required this.sessionType,
  });

  @override
  ConsumerState<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends ConsumerState<CreateSessionPage> {
  final TextEditingController _titleController = TextEditingController();
  Store? _selectedStore;
  List<Store> _stores = [];
  Shipment? _selectedShipment;
  List<Shipment> _shipments = [];
  bool _isLoading = true;
  bool _isLoadingShipments = false;
  bool _isCreating = false;

  bool get _isCounting => widget.sessionType == 'counting';
  bool get _isReceiving => widget.sessionType == 'receiving';

  String get _pageTitle {
    return _isCounting ? 'New Inventory Count' : 'New Receiving';
  }

  // Validation: Location is required
  bool get _canCreate => _selectedStore != null && !_isCreating;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final appState = ref.read(appStateProvider);
      final userId = appState.userId;
      final companyId = appState.companyChoosen;

      if (userId.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Load stores
      final userRepository = ref.read(userRepositoryProvider);
      final stores = await userRepository.getStores(userId);

      setState(() {
        _stores = stores;
        _isLoading = false;
      });

      // Load shipments for receiving type
      if (_isReceiving && companyId.isNotEmpty) {
        await _loadShipments(companyId);
      }
    } catch (e) {
      setState(() {
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

      final now = DateTime.now();
      final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
      final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final response = await getShipmentList(
        companyId: companyId,
        startDate: oneYearAgo,
        endDate: endOfToday,
        limit: 500,
      );

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
    if (_selectedStore == null || _isCreating) return;

    setState(() {
      _isCreating = true;
    });

    try {
      final appState = ref.read(appStateProvider);
      final userId = appState.userId;
      final companyId = appState.companyChoosen;

      if (userId.isEmpty || companyId.isEmpty) {
        setState(() {
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
        sessionName: _titleController.text.trim().isNotEmpty
            ? _titleController.text.trim()
            : null,
        shipmentId: _selectedShipment?.shipmentId,
      );

      if (mounted) {
        Navigator.of(context).pop(response);
      }
    } catch (e) {
      setState(() {
        _isCreating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: TossSpacing.space4),
                        // Title field - inline text field
                        _buildInlineTextField(
                          label: 'Title',
                          controller: _titleController,
                          placeholder: 'Add title',
                        ),
                        // Location field - uses bottom sheet picker
                        _buildLocationRow(),
                        // Shipment field (for receiving only)
                        if (_isReceiving) _buildShipmentRow(),
                      ],
                    ),
                  ),
                ),
                // Create button
                _buildCreateButton(),
              ],
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
          Icons.close,
          color: TossColors.gray900,
          size: 22,
        ),
      ),
      title: Text(
        _pageTitle,
        style: TossTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      titleSpacing: 0,
    );
  }

  Widget _buildInlineTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
  }) {
    return _InlineTextFieldRow(
      label: label,
      controller: controller,
      placeholder: placeholder,
      onChanged: () => setState(() {}),
    );
  }

  Widget _buildLocationRow() {
    return GestureDetector(
      onTap: _showLocationPicker,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Location',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedStore?.name ?? 'Select store location',
                  style: TossTextStyles.body.copyWith(
                    color: _selectedStore != null
                        ? TossColors.gray900
                        : TossColors.gray400,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: TossColors.gray400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentRow() {
    return GestureDetector(
      onTap: _isLoadingShipments ? null : _showShipmentPicker,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipment',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoadingShipments)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Text(
                    _selectedShipment?.shipmentNumber ?? 'Select shipment',
                    style: TossTextStyles.body.copyWith(
                      color: _selectedShipment != null
                          ? TossColors.gray900
                          : TossColors.gray400,
                    ),
                  ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: TossColors.gray400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canCreate ? _createSession : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _canCreate ? TossColors.primary : TossColors.gray300,
              foregroundColor: TossColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
                : Text(
                    'Create',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _showLocationPicker() {
    if (_stores.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: TossSpacing.space2),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Select Store Location',
                style: TossTextStyles.titleLarge.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _stores.length,
                  itemBuilder: (context, index) {
                    final store = _stores[index];
                    final isSelected = store.id == _selectedStore?.id;
                    return ListTile(
                      leading: Icon(
                        Icons.store_outlined,
                        color:
                            isSelected ? TossColors.primary : TossColors.gray600,
                      ),
                      title: Text(
                        store.name,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? TossColors.primary
                              : TossColors.gray900,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check,
                              color: TossColors.primary,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedStore = store;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }

  void _showShipmentPicker() {
    if (_shipments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No pending shipments available'),
          backgroundColor: TossColors.gray600,
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: TossSpacing.space2),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Select Shipment',
                style: TossTextStyles.titleLarge.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _shipments.length,
                  itemBuilder: (context, index) {
                    final shipment = _shipments[index];
                    final isSelected =
                        shipment.shipmentId == _selectedShipment?.shipmentId;
                    return ListTile(
                      leading: Icon(
                        Icons.local_shipping_outlined,
                        color:
                            isSelected ? TossColors.primary : TossColors.gray600,
                      ),
                      title: Text(
                        shipment.shipmentNumber,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? TossColors.primary
                              : TossColors.gray900,
                        ),
                      ),
                      subtitle: Text(
                        '${shipment.supplierName} • ${shipment.itemCount} items',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check,
                              color: TossColors.primary,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedShipment = shipment;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }
}

/// Inline text field row that hides hint when focused
class _InlineTextFieldRow extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String placeholder;
  final VoidCallback onChanged;

  const _InlineTextFieldRow({
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.onChanged,
  });

  @override
  State<_InlineTextFieldRow> createState() => _InlineTextFieldRowState();
}

class _InlineTextFieldRowState extends State<_InlineTextFieldRow> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showPlaceholder = !_isFocused && widget.controller.text.isEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  textAlign: TextAlign.right,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                  ),
                  decoration: InputDecoration(
                    hintText: showPlaceholder ? widget.placeholder : null,
                    hintStyle: TossTextStyles.body.copyWith(
                      color: TossColors.gray400,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onChanged: (_) => widget.onChanged(),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: TossColors.gray400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
