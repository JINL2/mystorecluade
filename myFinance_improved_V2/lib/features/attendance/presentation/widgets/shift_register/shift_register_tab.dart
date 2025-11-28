import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'controllers/shift_register_controller.dart';
import 'dialogs/store_selector_dialog.dart';
import 'utils/shift_action_handler.dart';
import 'utils/shift_register_formatters.dart';
import 'utils/shift_scroll_helper.dart';
import 'widgets/selected_date_header.dart';
import 'widgets/shift_calendar_widget.dart';
import 'widgets/shift_detail_list_widget.dart';

/// Shift register tab for managing shift registrations
class ShiftRegisterTab extends ConsumerStatefulWidget {
  const ShiftRegisterTab({super.key});

  @override
  ConsumerState<ShiftRegisterTab> createState() => _ShiftRegisterTabState();
}

class _ShiftRegisterTabState extends ConsumerState<ShiftRegisterTab> with AutomaticKeepAliveClientMixin {
  late final ShiftRegisterController _controller;
  late final ShiftActionHandler _actionHandler;
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = ShiftRegisterController(
      ref: ref,
      setState: setState,
    );
    _actionHandler = ShiftActionHandler(
      context: context,
      ref: ref,
      controller: _controller,
    );
    _controller.initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleShiftClick(String shiftId, bool isRegistered) {
    _controller.handleShiftClick(shiftId, isRegistered);
    ShiftScrollHelper.performSmoothScroll(_scrollController);
    HapticFeedback.selectionClick();
  }

  Future<void> _showStoreSelector(List<dynamic> stores) async {
    StoreSelectorDialog.show(
      context,
      stores: stores,
      selectedStoreId: _controller.selectedStoreId,
      onStoreSelected: (store) async {
        await _controller.updateSelectedStore(
          store['store_id']?.toString() ?? '',
          store['store_name']?.toString(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final stores = _getAvailableStores();

    // Auto-select first store if none selected
    if (_controller.selectedStoreId == null && stores.isNotEmpty) {
      _controller.selectedStoreId = stores.first['store_id']?.toString();
      if (_controller.shiftMetadata == null && !_controller.isLoadingMetadata) {
        _controller.fetchShiftMetadata(_controller.selectedStoreId!);
        _controller.fetchMonthlyShiftStatus();
      }
    }

    return Stack(
      children: [
        Column(
          children: [
            if (stores.isNotEmpty) _buildStoreSelector(stores),
            _buildCalendarHeader(),
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
        _buildFloatingActionButton(),
      ],
    );
  }

  List<dynamic> _getAvailableStores() {
    final appState = ref.read(appStateProvider);
    final companies = (appState.user['companies'] as List<dynamic>?) ?? [];
    Map<String, dynamic>? selectedCompany;

    if (appState.companyChoosen.isNotEmpty) {
      try {
        selectedCompany = companies.firstWhere(
          (company) => (company as Map<String, dynamic>)['company_id'] == appState.companyChoosen,
          orElse: () => null,
        ) as Map<String, dynamic>?;
      } catch (e) {
        selectedCompany = null;
      }
    }

    return selectedCompany?['stores'] as List<dynamic>? ?? [];
  }

  Widget _buildStoreSelector(List<dynamic> stores) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space3,
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          _showStoreSelector(stores);
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: TossColors.background,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            border: Border.all(
              color: TossColors.gray200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  Icons.store_outlined,
                  size: 18,
                  color: TossColors.gray600,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      (stores.firstWhere(
                        (store) => store['store_id'] == _controller.selectedStoreId,
                        orElse: () => {'store_name': 'Select Store'},
                      )['store_name'] ?? 'Select Store').toString(),
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: TossColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await _controller.changeFocusedMonth(-1);
              HapticFeedback.selectionClick();
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              child: const Icon(
                Icons.chevron_left,
                size: 24,
                color: TossColors.gray600,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space4),
          Text(
            '${ShiftRegisterFormatters.getMonthName(_controller.focusedMonth.month)} ${_controller.focusedMonth.year}',
            style: TossTextStyles.h2.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: TossSpacing.space4),
          InkWell(
            onTap: () async {
              await _controller.changeFocusedMonth(1);
              HapticFeedback.selectionClick();
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              child: const Icon(
                Icons.chevron_right,
                size: 24,
                color: TossColors.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return ListView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
          child: ShiftCalendarWidget(
            selectedDate: _controller.selectedDate,
            focusedMonth: _controller.focusedMonth,
            monthlyShiftStatus: _controller.monthlyShiftStatus,
            shiftMetadata: _controller.shiftMetadata,
            onDateSelected: (date) => _controller.selectDate(date),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        SelectedDateHeader(
          selectedDate: _controller.selectedDate,
          monthlyShiftStatus: _controller.monthlyShiftStatus,
          onPreviousDate: () => _controller.goToPreviousDate(),
          onNextDate: () => _controller.goToNextDate(),
        ),
        const SizedBox(height: TossSpacing.space3),
        ShiftDetailListWidget(
          selectedDate: _controller.selectedDate,
          shiftMetadata: _controller.shiftMetadata,
          monthlyShiftStatus: _controller.monthlyShiftStatus,
          selectedShift: _controller.selectedShift,
          selectionMode: _controller.selectionMode,
          isLoadingMetadata: _controller.isLoadingMetadata,
          isLoadingShiftStatus: _controller.isLoadingShiftStatus,
          onShiftClick: _handleShiftClick,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: TossSpacing.space5,
          right: TossSpacing.space5,
          bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
          top: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: TossColors.white,
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: InkWell(
            onTap: _controller.selectedShift != null ? () {
              HapticFeedback.mediumImpact();
              if (_controller.selectionMode == 'registered') {
                _actionHandler.handleCancelShifts();
              } else if (_controller.selectionMode == 'unregistered') {
                _actionHandler.handleRegisterShift();
              }
            } : null,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: _controller.selectedShift != null
                    ? (_controller.selectionMode == 'registered'
                        ? TossColors.gray900
                        : TossColors.primary)
                    : TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              ),
              child: Center(
                child: Text(
                  _controller.selectedShift != null
                      ? (_controller.selectionMode == 'registered'
                          ? 'Cancel Shift'
                          : 'Register Shift')
                      : 'Select a Shift',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: _controller.selectedShift != null ? TossColors.white : TossColors.gray500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
