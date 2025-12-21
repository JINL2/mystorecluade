// Presentation Page: New Stock In Record
// Page for creating a new stock in record session

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';

/// New Stock In Record Page
class NewStockInRecordPage extends ConsumerStatefulWidget {
  const NewStockInRecordPage({super.key});

  @override
  ConsumerState<NewStockInRecordPage> createState() =>
      _NewStockInRecordPageState();
}

class _NewStockInRecordPageState extends ConsumerState<NewStockInRecordPage> {
  final TextEditingController _shipmentCodeController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  String? _selectedLocationId;
  String? _selectedLocationName;

  @override
  void dispose() {
    _shipmentCodeController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create button is enabled when location is selected (shipment code is optional)
    final canCreate = _selectedLocationId != null;

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: TossSpacing.space4),
                  // Shipment Code field - inline text field
                  _buildInlineTextField(
                    label: 'Shipment Code',
                    controller: _shipmentCodeController,
                    placeholder: 'Add shipment code',
                  ),
                  // Location field - uses bottom sheet picker
                  _buildLocationRow(),
                  // Memo field - inline text field
                  _buildInlineTextField(
                    label: 'Memo',
                    controller: _memoController,
                    placeholder: 'Optional note',
                  ),
                ],
              ),
            ),
          ),
          // Create button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canCreate ? _onCreate : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        canCreate ? TossColors.primary : TossColors.gray300,
                    foregroundColor: TossColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Create',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
        'New Stock In Record',
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
                  _selectedLocationName ?? 'Select store location',
                  style: TossTextStyles.body.copyWith(
                    color: _selectedLocationName != null
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

  void _showLocationPicker() {
    final appState = ref.read(appStateProvider);
    final stores = _getCompanyStores(appState);

    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(TossBorderRadius.bottomSheet)),
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
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    final isSelected = store.id == _selectedLocationId;
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
                          _selectedLocationId = store.id;
                          _selectedLocationName = store.name;
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

  List<_StoreOption> _getCompanyStores(AppState appState) {
    final currentCompanyId = appState.companyChoosen;
    final companies = appState.user['companies'] as List<dynamic>? ?? [];

    Map<String, dynamic>? company;
    for (final c in companies) {
      if (c is Map<String, dynamic> && c['company_id'] == currentCompanyId) {
        company = c;
        break;
      }
    }

    if (company == null) {
      return [
        _StoreOption(
          id: appState.storeChoosen,
          name: appState.storeName.isNotEmpty ? appState.storeName : 'Main Store',
        ),
      ];
    }

    final storesList = company['stores'] as List<dynamic>? ?? [];

    return storesList.map((store) {
      final storeMap = store as Map<String, dynamic>;
      return _StoreOption(
        id: storeMap['store_id'] as String? ?? '',
        name: storeMap['store_name'] as String? ?? 'Unknown Store',
      );
    }).toList();
  }

  void _onCreate() {
    // TODO: Implement create stock in record API call and navigate to detail page
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _shipmentCodeController.text.isNotEmpty
              ? 'Stock in record "${_shipmentCodeController.text}" created'
              : 'Stock in record created',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _StoreOption {
  final String id;
  final String name;

  _StoreOption({
    required this.id,
    required this.name,
  });
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
    final showPlaceholder =
        !_isFocused && widget.controller.text.isEmpty;

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
