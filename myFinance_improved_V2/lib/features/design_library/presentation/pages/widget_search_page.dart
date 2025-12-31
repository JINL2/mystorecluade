import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Widget Search Page - 위젯 검색 기능
///
/// 모든 위젯을 검색하여 빠르게 찾을 수 있는 페이지
class WidgetSearchPage extends StatefulWidget {
  const WidgetSearchPage({super.key});
  @override
  State<WidgetSearchPage> createState() => _WidgetSearchPageState();
}
class _WidgetSearchPageState extends State<WidgetSearchPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  // 모든 위젯 데이터 (이름, 카테고리, 경로)
  static const List<WidgetInfo> _allWidgets = [
    // === ATOMS ===
    // Buttons (TossButton provides primary, secondary, outlined, outlinedGray, textButton variants)
    WidgetInfo(name: 'TossButton', category: 'Atoms', subcategory: 'Buttons', path: 'atoms/buttons/toss_button.dart'),
    WidgetInfo(name: 'ToggleButtonGroup', category: 'Atoms', subcategory: 'Buttons', path: 'atoms/buttons/toggle_button.dart'),
    // Display
    WidgetInfo(name: 'TossBadge', category: 'Atoms', subcategory: 'Display', path: 'atoms/display/toss_badge.dart'),
    WidgetInfo(name: 'TossCard', category: 'Atoms', subcategory: 'Display', path: 'atoms/display/toss_card.dart'),
    WidgetInfo(name: 'TossCardSafe', category: 'Atoms', subcategory: 'Display', path: 'atoms/display/toss_card_safe.dart'),
    WidgetInfo(name: 'TossChip', category: 'Atoms', subcategory: 'Display', path: 'atoms/display/toss_chip.dart'),
    WidgetInfo(name: 'CachedProductImage', category: 'Atoms', subcategory: 'Display', path: 'atoms/display/cached_product_image.dart'),
    WidgetInfo(name: 'EmployeeProfileAvatar', category: 'Atoms', subcategory: 'Display', path: 'atoms/display/employee_profile_avatar.dart'),
    // Feedback
    WidgetInfo(name: 'TossEmptyView', category: 'Atoms', subcategory: 'Feedback', path: 'atoms/feedback/toss_empty_view.dart'),
    WidgetInfo(name: 'TossLoadingView', category: 'Atoms', subcategory: 'Feedback', path: 'atoms/feedback/toss_loading_view.dart'),
    WidgetInfo(name: 'TossErrorView', category: 'Atoms', subcategory: 'Feedback', path: 'atoms/feedback/toss_error_view.dart'),
    WidgetInfo(name: 'TossRefreshIndicator', category: 'Atoms', subcategory: 'Feedback', path: 'atoms/feedback/toss_refresh_indicator.dart'),
    // Inputs
    WidgetInfo(name: 'TossSearchField', category: 'Atoms', subcategory: 'Inputs', path: 'atoms/inputs/toss_search_field.dart'),
    WidgetInfo(name: 'TossTextField', category: 'Atoms', subcategory: 'Inputs', path: 'atoms/inputs/toss_text_field.dart'),
    // Layout
    WidgetInfo(name: 'GrayDividerSpace', category: 'Atoms', subcategory: 'Layout', path: 'atoms/layout/gray_divider_space.dart'),
    WidgetInfo(name: 'TossSectionHeader', category: 'Atoms', subcategory: 'Layout', path: 'atoms/layout/toss_section_header.dart'),
    WidgetInfo(name: 'TossAppBar', category: 'Atoms', subcategory: 'Layout', path: 'atoms/layout/toss_app_bar.dart'),
    // === MOLECULES ===
    // Dropdowns
    WidgetInfo(name: 'TossDropdown', category: 'Molecules', subcategory: 'Dropdowns', path: 'molecules/dropdowns/toss_dropdown.dart'),
    WidgetInfo(name: 'TossFilterDropdown', category: 'Molecules', subcategory: 'Dropdowns', path: 'molecules/dropdowns/toss_filter_dropdown.dart'),
    // ListTile
    WidgetInfo(name: 'TossListTile', category: 'Molecules', subcategory: 'ListTile', path: 'molecules/list_tile/toss_list_tile.dart'),
    WidgetInfo(name: 'TossSettingTile', category: 'Molecules', subcategory: 'ListTile', path: 'molecules/list_tile/toss_setting_tile.dart'),
    WidgetInfo(name: 'TossMenuTile', category: 'Molecules', subcategory: 'ListTile', path: 'molecules/list_tile/toss_menu_tile.dart'),
    // Tabs
    WidgetInfo(name: 'TossTabBar', category: 'Molecules', subcategory: 'Tabs', path: 'molecules/tabs/toss_tab_bar.dart'),
    WidgetInfo(name: 'TossSegmentedControl', category: 'Molecules', subcategory: 'Tabs', path: 'molecules/tabs/toss_segmented_control.dart'),
    WidgetInfo(name: 'TossEnhancedTextField', category: 'Molecules', subcategory: 'Inputs', path: 'molecules/inputs/toss_enhanced_text_field.dart'),
    WidgetInfo(name: 'TossKeyboardToolbar', category: 'Molecules', subcategory: 'Inputs', path: 'molecules/inputs/toss_keyboard_toolbar.dart'),
    WidgetInfo(name: 'TossFormSection', category: 'Molecules', subcategory: 'Inputs', path: 'molecules/inputs/toss_form_section.dart'),
    WidgetInfo(name: 'TossQuantityInput', category: 'Molecules', subcategory: 'Inputs', path: 'molecules/inputs/toss_quantity_input.dart'),
    WidgetInfo(name: 'TossSnackBar', category: 'Molecules', subcategory: 'Feedback', path: 'molecules/feedback/toss_snack_bar.dart'),
    WidgetInfo(name: 'TossToast', category: 'Molecules', subcategory: 'Feedback', path: 'molecules/feedback/toss_toast.dart'),
    // Navigation
    WidgetInfo(name: 'TossBottomNavBar', category: 'Molecules', subcategory: 'Navigation', path: 'molecules/navigation/toss_bottom_nav_bar.dart'),
    // FAB (TossFAB provides simple and expandable variants)
    WidgetInfo(name: 'TossFAB', category: 'Molecules', subcategory: 'Buttons', path: 'molecules/buttons/toss_fab.dart'),
    // Indicators
    WidgetInfo(name: 'TossProgressBar', category: 'Molecules', subcategory: 'Indicators', path: 'molecules/indicators/toss_progress_bar.dart'),
    WidgetInfo(name: 'TossStepIndicator', category: 'Molecules', subcategory: 'Indicators', path: 'molecules/indicators/toss_step_indicator.dart'),
    // Stepper
    WidgetInfo(name: 'TossQuantityStepper', category: 'Molecules', subcategory: 'Stepper', path: 'molecules/stepper/toss_quantity_stepper.dart'),
    // === ORGANISMS ===
    // Dialogs
    WidgetInfo(name: 'TossConfirmCancelDialog', category: 'Organisms', subcategory: 'Dialogs', path: 'organisms/dialogs/toss_confirm_cancel_dialog.dart'),
    WidgetInfo(name: 'TossInfoDialog', category: 'Organisms', subcategory: 'Dialogs', path: 'organisms/dialogs/toss_info_dialog.dart'),
    WidgetInfo(name: 'TossSuccessErrorDialog', category: 'Organisms', subcategory: 'Dialogs', path: 'organisms/dialogs/toss_success_error_dialog.dart'),
    // Sheets
    WidgetInfo(name: 'TossBottomSheet', category: 'Organisms', subcategory: 'Sheets', path: 'organisms/sheets/toss_bottom_sheet.dart'),
    WidgetInfo(name: 'TossSelectionBottomSheet', category: 'Organisms', subcategory: 'Sheets', path: 'organisms/sheets/toss_selection_bottom_sheet.dart'),
    // Pickers
    WidgetInfo(name: 'TossDatePicker', category: 'Organisms', subcategory: 'Pickers', path: 'organisms/pickers/toss_date_picker.dart'),
    WidgetInfo(name: 'TossTimePicker', category: 'Organisms', subcategory: 'Pickers', path: 'organisms/pickers/toss_time_picker.dart'),
    // Calendars
    WidgetInfo(name: 'TossMonthNavigation', category: 'Organisms', subcategory: 'Calendars', path: 'organisms/calendars/toss_month_navigation.dart'),
    WidgetInfo(name: 'TossWeekNavigation', category: 'Organisms', subcategory: 'Calendars', path: 'organisms/calendars/toss_week_navigation.dart'),
    WidgetInfo(name: 'TossMonthCalendar', category: 'Organisms', subcategory: 'Calendars', path: 'organisms/calendars/toss_month_calendar.dart'),
    // Shift
    WidgetInfo(name: 'TossTodayShiftCard', category: 'Organisms', subcategory: 'Shift', path: 'organisms/shift/toss_today_shift_card.dart'),
    WidgetInfo(name: 'TossWeekShiftCard', category: 'Organisms', subcategory: 'Shift', path: 'organisms/shift/toss_week_shift_card.dart'),
    // AI
    WidgetInfo(name: 'AiConversationCard', category: 'Organisms', subcategory: 'AI', path: 'organisms/ai/ai_conversation_card.dart'),
    WidgetInfo(name: 'AiConversationHistory', category: 'Organisms', subcategory: 'AI', path: 'organisms/ai/ai_conversation_history.dart'),
    WidgetInfo(name: 'AiSuggestionCard', category: 'Organisms', subcategory: 'AI', path: 'organisms/ai/ai_suggestion_card.dart'),
  ];
  List<WidgetInfo> get _filteredWidgets {
    return _allWidgets.where((widget) {
      // 카테고리 필터
      if (_selectedCategory != null && widget.category != _selectedCategory) {
        return false;
      }
      // 검색어 필터
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return widget.name.toLowerCase().contains(query) ||
          widget.subcategory.toLowerCase().contains(query) ||
          widget.path.toLowerCase().contains(query);
    }).toList();
  }
  void dispose() {
    _searchController.dispose();
    super.dispose();
  Widget build(BuildContext context) {
    final filtered = _filteredWidgets;
    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: AppBar(
        title: const Text('Widget Search'),
        backgroundColor: TossColors.white,
        foregroundColor: TossColors.gray900,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: TossColors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search TextField
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search widgets... (e.g., TossButton)',
                    prefixIcon: const Icon(Icons.search, color: TossColors.gray500),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: TossColors.gray500),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: TossColors.gray50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 12),
                // Category Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip(null, 'All'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Atoms', 'Atoms', TossColors.primary),
                      _buildCategoryChip('Molecules', 'Molecules', TossColors.success),
                      _buildCategoryChip('Organisms', 'Organisms', TossColors.warning),
                    ],
              ],
            ),
          ),
          // Results count
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
                Text(
                  '${filtered.length} widgets found',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
          // Results List
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _buildWidgetItem(filtered[index]),
        ],
    );
  Widget _buildCategoryChip(String? category, String label, [Color? color]) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedCategory = category),
      backgroundColor: TossColors.white,
      selectedColor: (color ?? TossColors.gray600).withValues(alpha: 0.15),
      checkmarkColor: color ?? TossColors.gray600,
      labelStyle: TossTextStyles.small.copyWith(
        color: isSelected ? (color ?? TossColors.gray900) : TossColors.gray600,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      side: BorderSide(
        color: isSelected ? (color ?? TossColors.gray400) : TossColors.gray200,
  Widget _buildWidgetItem(WidgetInfo widget) {
    final categoryColor = switch (widget.category) {
      'Atoms' => TossColors.primary,
      'Molecules' => TossColors.success,
      'Organisms' => TossColors.warning,
      _ => TossColors.gray500,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TossColors.gray100),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showWidgetDetails(widget),
          child: Padding(
                // Category indicator
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(2),
                const SizedBox(width: 12),
                // Widget info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      Row(
                        children: [
                          Text(
                            widget.name,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            child: Text(
                              widget.subcategory,
                              style: TossTextStyles.small.copyWith(
                                color: categoryColor,
                                fontSize: 10,
                              ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'lib/shared/widgets/${widget.path}',
                        style: TossTextStyles.small.copyWith(
                          color: TossColors.gray500,
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
                const Icon(Icons.chevron_right, color: TossColors.gray400),
        ),
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          Icon(
            Icons.search_off,
            size: 64,
            color: TossColors.gray300,
          const SizedBox(height: 16),
          Text(
            'No widgets found',
            style: TossTextStyles.body.copyWith(color: TossColors.gray500),
          const SizedBox(height: 8),
            'Try a different search term',
            style: TossTextStyles.caption.copyWith(color: TossColors.gray400),
  void _showWidgetDetails(WidgetInfo widget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
            padding: const EdgeInsets.all(24),
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: TossColors.gray300,
                      borderRadius: BorderRadius.circular(2),
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      child: Icon(
                        switch (widget.category) {
                          'Atoms' => Icons.circle,
                          'Molecules' => Icons.interests,
                          'Organisms' => Icons.widgets,
                          _ => Icons.extension,
                        },
                        color: categoryColor,
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          Text(widget.name, style: TossTextStyles.h3),
                            '${widget.category} / ${widget.subcategory}',
                            style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
                  ],
                const SizedBox(height: 20),
                // File Path
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(8),
                      Icon(Icons.folder_outlined, size: 16, color: TossColors.gray500),
                      Expanded(
                        child: Text(
                          'lib/shared/widgets/${widget.path}',
                          style: TossTextStyles.small.copyWith(
                            fontFamily: 'monospace',
                            color: TossColors.gray600,
                      IconButton(
                        icon: Icon(Icons.copy, size: 18, color: TossColors.gray500),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: 'lib/shared/widgets/${widget.path}'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Path copied!'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                          );
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                const SizedBox(height: 24),
                // Widget Preview Section
                  'Preview',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  padding: const EdgeInsets.all(16),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: TossColors.gray200),
                  child: _buildWidgetPreview(widget),
  Widget _buildWidgetPreview(WidgetInfo widget) {
    // Build a simple preview based on widget type
    // This is a simplified preview - not all widgets can be previewed
    try {
      return _getWidgetPreviewByName(widget.name);
    } catch (e) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.preview, size: 48, color: TossColors.gray300),
            const SizedBox(height: 8),
            Text(
              'Preview not available',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
            const SizedBox(height: 4),
              'View in Design Library for full preview',
              style: TossTextStyles.small.copyWith(color: TossColors.gray400),
          ],
      );
    }
  Widget _getWidgetPreviewByName(String name) {
    // Return simple previews for common widgets
    switch (name) {
      // Atoms - Buttons
      case 'TossButton':
        return Column(
            ElevatedButton(onPressed: () {}, child: const Text('Primary Button')),
            OutlinedButton(onPressed: () {}, child: const Text('Secondary Button')),
        );
      case 'ToggleButtonGroup':
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleItem('Day', true),
              _buildToggleItem('Week', false),
              _buildToggleItem('Month', false),
            ],
      // Atoms - Display
      case 'TossBadge':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
            _buildBadge('New', TossColors.primary),
            const SizedBox(width: 8),
            _buildBadge('Sale', TossColors.error),
            _buildBadge('Hot', TossColors.warning),
      case 'TossCard':
      case 'TossCardSafe':
          padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: TossColors.gray900.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
              Icon(Icons.credit_card, color: TossColors.primary),
              const SizedBox(width: 12),
              Text('Card Content', style: TossTextStyles.body),
      case 'TossChip':
        return Wrap(
          spacing: 8,
            Chip(label: Text('Chip 1')),
            Chip(label: Text('Chip 2'), backgroundColor: TossColors.primarySurface),
      // Atoms - Feedback
      case 'TossLoadingView':
        return const Center(
          child: CircularProgressIndicator(),
      case 'TossEmptyView':
        return Center(
          child: Column(
              Icon(Icons.inbox, size: 48, color: TossColors.gray300),
              const SizedBox(height: 8),
              Text('No items', style: TossTextStyles.body.copyWith(color: TossColors.gray500)),
      case 'TossErrorView':
              Icon(Icons.error_outline, size: 48, color: TossColors.error),
              Text('Something went wrong', style: TossTextStyles.body.copyWith(color: TossColors.gray700)),
              TextButton(onPressed: () {}, child: const Text('Retry')),
      // Atoms - Inputs
      case 'TossTextField':
      case 'TossEnhancedTextField':
        return TextField(
          decoration: InputDecoration(
            hintText: 'Enter text...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      case 'TossSearchField':
            hintText: 'Search...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
      // Molecules
      case 'TossDropdown':
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: Border.all(color: TossColors.gray300),
              Text('Select option', style: TossTextStyles.body),
              const SizedBox(width: 8),
              Icon(Icons.keyboard_arrow_down, color: TossColors.gray500),
      case 'TossTabBar':
            _buildTab('Tab 1', true),
            _buildTab('Tab 2', false),
            _buildTab('Tab 3', false),
      case 'TossListTile':
      case 'TossSettingTile':
      case 'TossMenuTile':
          padding: const EdgeInsets.all(12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(8),
                child: Icon(Icons.settings, color: TossColors.gray600),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    Text('List Item Title', style: TossTextStyles.body),
                    Text('Subtitle text', style: TossTextStyles.caption.copyWith(color: TossColors.gray500)),
              Icon(Icons.chevron_right, color: TossColors.gray400),
      case 'TossProgressBar':
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                Text('Progress', style: TossTextStyles.caption),
                Text('60%', style: TossTextStyles.caption.copyWith(color: TossColors.primary)),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.6,
                backgroundColor: TossColors.gray200,
                valueColor: AlwaysStoppedAnimation(TossColors.primary),
                minHeight: 8,
      case 'TossStepIndicator':
            _buildStep(1, true, true),
            _buildStepLine(true),
            _buildStep(2, true, false),
            _buildStepLine(false),
            _buildStep(3, false, false),
      case 'TossSegmentedControl':
              Expanded(child: _buildSegment('Option 1', true)),
              Expanded(child: _buildSegment('Option 2', false)),
      case 'TossSnackBar':
      case 'TossToast':
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: TossColors.gray900,
              Icon(Icons.check_circle, color: TossColors.white, size: 20),
              Text('Action completed!', style: TossTextStyles.body.copyWith(color: TossColors.white)),
      case 'TossQuantityStepper':
      case 'TossQuantityInput':
            border: Border.all(color: TossColors.gray200),
              IconButton(icon: Icon(Icons.remove, color: TossColors.gray600), onPressed: () {}),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('1', style: TossTextStyles.h3),
              IconButton(icon: Icon(Icons.add, color: TossColors.primary), onPressed: () {}),
      case 'TossBottomNavBar':
          padding: const EdgeInsets.symmetric(vertical: 8),
            border: Border(top: BorderSide(color: TossColors.gray200)),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              _buildNavItem(Icons.home, 'Home', true),
              _buildNavItem(Icons.search, 'Search', false),
              _buildNavItem(Icons.person, 'Profile', false),
      // Organisms
      case 'TossDatePicker':
      case 'TossTimePicker':
              Icon(name.contains('Date') ? Icons.calendar_today : Icons.access_time,
                  color: TossColors.gray500),
              Text(name.contains('Date') ? '2024-12-31' : '14:30',
                  style: TossTextStyles.body),
      case 'TossConfirmCancelDialog':
      case 'TossInfoDialog':
      case 'TossSuccessErrorDialog':
          padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(16),
                color: TossColors.gray900.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 4),
              Icon(
                name.contains('Success') ? Icons.check_circle : Icons.info,
                size: 48,
                color: name.contains('Success') ? TossColors.success : TossColors.primary,
              const SizedBox(height: 16),
              Text('Dialog Title', style: TossTextStyles.h3),
              Text(
                'Dialog message content goes here.',
                style: TossTextStyles.body.copyWith(color: TossColors.gray600),
                textAlign: TextAlign.center,
              const SizedBox(height: 20),
              Row(
                children: [
                  if (name.contains('Confirm'))
                      child: OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
                  if (name.contains('Confirm')) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: TossColors.primary),
                      child: const Text('Confirm'),
                ],
      case 'TossBottomSheet':
      case 'TossSelectionBottomSheet':
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                width: 40,
                height: 4,
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
              Text('Bottom Sheet Title', style: TossTextStyles.h3),
              const SizedBox(height: 12),
              ...List.generate(3, (i) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                  color: TossColors.gray50,
                child: Row(
                    Text('Option ${i + 1}', style: TossTextStyles.body),
                    const Spacer(),
                    if (i == 0) Icon(Icons.check, color: TossColors.primary),
              )),
      case 'TossMonthCalendar':
      case 'TossMonthNavigation':
      case 'TossWeekNavigation':
                Icon(Icons.chevron_left, color: TossColors.gray500),
                Text('December 2024', style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                Icon(Icons.chevron_right, color: TossColors.gray500),
            const SizedBox(height: 12),
            if (name.contains('Calendar'))
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 7,
                childAspectRatio: 1.2,
                children: List.generate(7, (i) => Center(
                    width: 32,
                    height: 32,
                      color: i == 3 ? TossColors.primary : Colors.transparent,
                      shape: BoxShape.circle,
                    child: Center(
                      child: Text(
                        '${i + 1}',
                          color: i == 3 ? TossColors.white : TossColors.gray700,
                )),
      case 'AiConversationCard':
      case 'AiSuggestionCard':
            gradient: LinearGradient(
              colors: [TossColors.primary.withValues(alpha: 0.1), TossColors.info.withValues(alpha: 0.1)],
                  color: TossColors.primary,
                child: Icon(Icons.auto_awesome, color: TossColors.white, size: 20),
                    Text('AI Suggestion', style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    Text('Tap to see AI insights', style: TossTextStyles.caption.copyWith(color: TossColors.gray600)),
      // FAB
      case 'TossFAB':
        return Stack(
          alignment: Alignment.bottomRight,
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(12),
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                width: 56,
                height: 56,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: TossColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                child: const Icon(Icons.add, color: TossColors.white),
      default:
        // Generic preview for unknown widgets
                padding: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(12),
                child: Icon(Icons.widgets, size: 32, color: TossColors.gray400),
                name,
                style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              const SizedBox(height: 4),
                'Open Design Library for interactive preview',
                style: TossTextStyles.small.copyWith(color: TossColors.gray500),
  Widget _buildToggleItem(String label, bool selected) {
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: selected ? TossColors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      child: Text(
        label,
        style: TossTextStyles.small.copyWith(
          color: selected ? TossColors.primary : TossColors.gray500,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
  Widget _buildBadge(String label, Color color) {
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        style: TossTextStyles.small.copyWith(color: color, fontWeight: FontWeight.w600),
  Widget _buildTab(String label, bool selected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? TossColors.primary : TossColors.transparent,
              width: 2,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TossTextStyles.body.copyWith(
            color: selected ? TossColors.primary : TossColors.gray500,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
  Widget _buildStep(int number, bool completed, bool current) {
      width: 28,
      height: 28,
        color: completed ? TossColors.primary : TossColors.gray200,
        shape: BoxShape.circle,
        border: current ? Border.all(color: TossColors.primary, width: 2) : null,
      child: Center(
        child: completed
            ? Icon(Icons.check, size: 16, color: TossColors.white)
            : Text(
                '$number',
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w600,
  Widget _buildStepLine(bool completed) {
      width: 40,
      height: 2,
      color: completed ? TossColors.primary : TossColors.gray200,
  Widget _buildSegment(String label, bool selected) {
      padding: const EdgeInsets.symmetric(vertical: 8),
        textAlign: TextAlign.center,
  Widget _buildNavItem(IconData icon, String label, bool selected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: selected ? TossColors.primary : TossColors.gray500),
        const SizedBox(height: 4),
        Text(
          style: TossTextStyles.small.copyWith(
      ],
/// Search result to pass back to Design Library
class SearchResult {
  final int tabIndex;
  final String widgetName;
  const SearchResult({required this.tabIndex, required this.widgetName});
/// Widget Info data class
class WidgetInfo {
  final String name;
  final String category;
  final String subcategory;
  final String path;
  const WidgetInfo({
    required this.name,
    required this.category,
    required this.subcategory,
    required this.path,
  });
