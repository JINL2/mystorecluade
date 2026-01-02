import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../auth/di/auth_providers.dart';
import '../../../auth/domain/entities/store_entity.dart';
import '../../di/session_providers.dart';
import '../../domain/entities/shipment.dart';
import '../widgets/create_session/inline_text_field_row.dart';
import '../widgets/create_session/location_picker_sheet.dart';
import '../widgets/create_session/shipment_picker_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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

      final userRepository = ref.read(userRepositoryProvider);
      final stores = await userRepository.getStores(userId);

      setState(() {
        _stores = stores;
        _isLoading = false;
      });

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
        TossToast.error(context, e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const TossLoadingView()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: TossSpacing.space4),
                        _buildInlineTextField(
                          label: 'Title',
                          controller: _titleController,
                          placeholder: 'Add title',
                        ),
                        _buildLocationRow(),
                        if (_isReceiving) _buildShipmentRow(),
                      ],
                    ),
                  ),
                ),
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
    return InlineTextFieldRow(
      label: label,
      controller: controller,
      placeholder: placeholder,
      onChanged: () => setState(() {}),
    );
  }

  Widget _buildLocationRow() {
    return GestureDetector(
      onTap: () => LocationPickerSheet.show(
        context: context,
        stores: _stores,
        selectedStore: _selectedStore,
        onSelected: (store) {
          setState(() {
            _selectedStore = store;
          });
        },
      ),
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
      onTap: _isLoadingShipments
          ? null
          : () => ShipmentPickerSheet.show(
                context: context,
                shipments: _shipments,
                selectedShipment: _selectedShipment,
                onSelected: (shipment) {
                  setState(() {
                    _selectedShipment = shipment;
                  });
                },
              ),
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
                  TossLoadingView.inline(size: 16)
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
        child: TossButton.primary(
          text: 'Create',
          onPressed: _canCreate ? _createSession : null,
          isEnabled: _canCreate,
          isLoading: _isCreating,
          fullWidth: true,
        ),
      ),
    );
  }
}
