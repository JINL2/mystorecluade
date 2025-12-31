import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
// Buttons
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toggle_button.dart';
// Display
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_card.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_card_safe.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_chip.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/cached_product_image.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/employee_profile_avatar.dart';
// Feedback
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_empty_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_refresh_indicator.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';
// Inputs
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_search_field.dart';
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_text_field.dart';
// Layout
import 'package:myfinance_improved/shared/widgets/atoms/layout/gray_divider_space.dart';
import 'package:myfinance_improved/shared/widgets/atoms/layout/toss_section_header.dart';

/// Atoms Page - 가장 작은 단위의 UI 컴포넌트
///
/// Buttons, Display, Feedback, Inputs, Layout 카테고리로 구성
class AtomsPage extends StatefulWidget {
  const AtomsPage({super.key});
  @override
  State<AtomsPage> createState() => AtomsPageState();
}
class AtomsPageState extends State<AtomsPage> {
  // Interactive states
  bool _isLoading = false;
  bool _chipSelected = false;
  String _searchText = '';
  String _textFieldValue = '';
  String _toggleId = 'day';
  bool _isRefreshing = false;
  String? _highlightedWidget;
  // Scroll controller for programmatic scrolling
  final ScrollController _scrollController = ScrollController();
  // Widget keys for scrolling
  final Map<String, GlobalKey> _widgetKeys = {};
  GlobalKey _getKeyForWidget(String name) {
    return _widgetKeys.putIfAbsent(name, () => GlobalKey());
  }
  /// Scroll to a specific widget by name. Returns true if successful.
  bool scrollToWidget(String widgetName) {
    // First try exact match
    var key = _widgetKeys[widgetName];
    // If not found, try to find by base name (for variants like TossButton.primary)
    if (key?.currentContext == null) {
      for (final entry in _widgetKeys.entries) {
        if (entry.key.split(' ').first == widgetName) {
          key = entry.value;
          break;
        }
      }
    }
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.3, // Show widget at 30% from top
      );
      // Highlight the widget temporarily
      setState(() => _highlightedWidget = widgetName);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _highlightedWidget = null);
      });
      return true;
    return false;
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildSectionHeader('Buttons', Icons.touch_app),
        _buildButtonsSection(),
        const SizedBox(height: TossSpacing.space6),
        _buildSectionHeader('Display', Icons.visibility),
        _buildDisplaySection(),
        _buildSectionHeader('Feedback', Icons.feedback),
        _buildFeedbackSection(),
        _buildSectionHeader('Inputs', Icons.input),
        _buildInputsSection(),
        _buildSectionHeader('Layout', Icons.grid_view),
        _buildLayoutSection(),
        const SizedBox(height: TossSpacing.space8),
      ],
    );
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TossColors.primarySurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: TossColors.primary, size: 20),
          ),
          const SizedBox(width: TossSpacing.space3),
          Text(
            title,
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
        ],
      ),
  Widget _buildButtonsSection() {
    return _buildShowcaseCard(
        _buildWidgetItem(
          'TossButton.primary',
          'lib/shared/widgets/atoms/buttons/toss_button.dart',
          TossButton.primary(
            text: 'Primary Button',
            onPressed: () => _showSnackBar('Primary clicked!'),
        ),
          'TossButton.secondary',
          TossButton.secondary(
            text: 'Secondary Button',
            onPressed: () => _showSnackBar('Secondary clicked!'),
          'TossButton.primary (Full Width)',
            text: 'Full Width Button',
            fullWidth: true,
            onPressed: () => _showSnackBar('Full width clicked!'),
          'Icon Buttons (using TossButton)',
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: TossColors.primarySurface,
                  foregroundColor: TossColors.primary,
                ),
                onPressed: () => _showSnackBar('Add clicked!'),
              ),
              const SizedBox(width: 8),
                icon: const Icon(Icons.edit),
                  backgroundColor: TossColors.gray100,
                  foregroundColor: TossColors.gray700,
                onPressed: () => _showSnackBar('Edit clicked!'),
                icon: const Icon(Icons.delete),
                  backgroundColor: TossColors.errorLight,
                  foregroundColor: TossColors.error,
                onPressed: () => _showSnackBar('Delete clicked!'),
            ],
          'Loading State',
          'isLoading: true',
              TossButton.primary(
                text: _isLoading ? 'Loading...' : 'Click to Load',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : () async {
                  setState(() => _isLoading = true);
                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) setState(() => _isLoading = false);
                },
          'ToggleButtonGroup (Interactive)',
          'lib/shared/widgets/atoms/buttons/toggle_button.dart',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              ToggleButtonGroup(
                items: const [
                  ToggleButtonItem(id: 'day', label: 'Day'),
                  ToggleButtonItem(id: 'week', label: 'Week'),
                  ToggleButtonItem(id: 'month', label: 'Month'),
                ],
                selectedId: _toggleId,
                onToggle: (id) => setState(() => _toggleId = id),
              const SizedBox(height: 8),
              Text(
                'Selected: ${_toggleId.toUpperCase()}',
                style: TossTextStyles.caption.copyWith(color: TossColors.primary),
  Widget _buildDisplaySection() {
          'TossBadge',
          'lib/shared/widgets/atoms/display/toss_badge.dart',
          Wrap(
            spacing: 8,
            runSpacing: 8,
              const TossBadge(label: 'Default'),
              TossBadge(
                label: 'Success',
                backgroundColor: TossColors.successLight,
                textColor: TossColors.success,
                label: 'Warning',
                backgroundColor: TossColors.warningLight,
                textColor: TossColors.warning,
                label: 'Error',
                backgroundColor: TossColors.errorLight,
                textColor: TossColors.error,
          'TossStatusBadge',
          const Wrap(
              TossStatusBadge(label: 'Success', status: BadgeStatus.success),
              TossStatusBadge(label: 'Warning', status: BadgeStatus.warning),
              TossStatusBadge(label: 'Error', status: BadgeStatus.error),
              TossStatusBadge(label: 'Info', status: BadgeStatus.info),
          'TossChip (Interactive)',
          'lib/shared/widgets/atoms/display/toss_chip.dart',
              TossChip(
                label: 'Tap me!',
                isSelected: _chipSelected,
                onTap: () => setState(() => _chipSelected = !_chipSelected),
                label: 'With Icon',
                icon: Icons.star,
                onTap: () {},
                label: 'Count: 5',
                showCount: true,
                count: 5,
          'TossCard (Tappable)',
          'lib/shared/widgets/atoms/display/toss_card.dart',
          TossCard(
            onTap: () => _showSnackBar('Card tapped!'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.touch_app, color: TossColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tappable Card', style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                        Text('Tap to see effect', style: TossTextStyles.caption),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: TossColors.gray400),
          'TossCardSafe (List-safe)',
          'lib/shared/widgets/atoms/display/toss_card_safe.dart',
          TossCardSafe(
            onTap: () => _showSnackBar('Safe card tapped!'),
            enableAnimation: false,
                  const Icon(Icons.shield_outlined, color: TossColors.success),
                        Text('Memory-Safe Card', style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                        Text('No animation for lists', style: TossTextStyles.caption),
          'CachedProductImage',
          'lib/shared/widgets/atoms/display/cached_product_image.dart',
              const CachedProductImage(
                imageUrl: null,
                size: 56,
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  Text('Product Image', style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  Text('With caching & fallback', style: TossTextStyles.caption),
          'EmployeeProfileAvatar',
          'lib/shared/widgets/atoms/display/employee_profile_avatar.dart',
              const EmployeeProfileAvatar(
                name: 'John Doe',
                size: 48,
                showBorder: true,
              const SizedBox(width: 12),
              EmployeeProfileAvatar(
                name: 'Jane',
                onTap: () => _showSnackBar('Avatar tapped!'),
                name: 'Bob',
                imageUrl: 'https://example.com/image.jpg',
  Widget _buildFeedbackSection() {
          'TossLoadingView',
          'lib/shared/widgets/atoms/feedback/toss_loading_view.dart',
          const SizedBox(
            height: 100,
            child: TossLoadingView(message: 'Loading...'),
          'TossEmptyView',
          'lib/shared/widgets/atoms/feedback/toss_empty_view.dart',
          TossEmptyView(
            title: 'No items found',
            description: 'Try adding some items',
            icon: const Icon(
              Icons.inbox_outlined,
              size: 48,
              color: TossColors.gray400,
            action: TossButton.primary(
              text: 'Add Item',
              onPressed: () => _showSnackBar('Add item clicked!'),
          'TossErrorView',
          'lib/shared/widgets/atoms/feedback/toss_error_view.dart',
          TossErrorView(
            error: Exception('Network connection failed'),
            title: 'Connection Error',
            onRetry: () => _showSnackBar('Retry clicked!'),
          'TossRefreshIndicator',
          'lib/shared/widgets/atoms/feedback/toss_refresh_indicator.dart',
          SizedBox(
            height: 120,
            child: TossRefreshIndicator(
              onRefresh: () async {
                setState(() => _isRefreshing = true);
                await Future.delayed(const Duration(seconds: 1));
                if (mounted) setState(() => _isRefreshing = false);
              },
              child: ListView(
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        _isRefreshing ? 'Refreshing...' : 'Pull down to refresh',
                        style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
                      ),
  Widget _buildInputsSection() {
          'TossTextField (Interactive)',
          'lib/shared/widgets/atoms/inputs/toss_text_field.dart',
          TossTextField(
            label: 'Email',
            hintText: 'Enter your email',
            onChanged: (value) => setState(() => _textFieldValue = value),
        if (_textFieldValue.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'You typed: $_textFieldValue',
              style: TossTextStyles.caption.copyWith(color: TossColors.primary),
          'TossTextField (Required)',
          'isRequired: true',
          const TossTextField(
            label: 'Password',
            hintText: 'Enter password',
            isRequired: true,
            obscureText: true,
          'TossSearchField (Interactive)',
          'lib/shared/widgets/atoms/inputs/toss_search_field.dart',
          TossSearchField(
            hintText: 'Search...',
            onChanged: (value) => setState(() => _searchText = value),
            onClear: () => setState(() => _searchText = ''),
        if (_searchText.isNotEmpty)
              'Searching for: "$_searchText"',
  Widget _buildLayoutSection() {
          'GrayDividerSpace',
          'lib/shared/widgets/atoms/layout/gray_divider_space.dart',
              Text('Content above', style: TossTextStyles.caption),
              const GrayDividerSpace(),
              Text('Content below', style: TossTextStyles.caption),
          'TossSectionHeader',
          'lib/shared/widgets/atoms/layout/toss_section_header.dart',
              const TossSectionHeader(
                title: 'Section Title',
              const SizedBox(height: 12),
              TossSectionHeader(
                title: 'With Trailing',
                icon: Icons.settings,
                trailing: TextButton(
                  onPressed: () => _showSnackBar('See all clicked!'),
                  child: const Text('See All'),
  Widget _buildShowcaseCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TossColors.gray100),
      child: Column(
        children: children,
  Widget _buildWidgetItem(String name, String path, Widget widget) {
    // Use full name as key to avoid duplicates (e.g., TossButton.primary, TossButton.secondary)
    // For search matching, also check base name
    final baseName = name.split(' ').first;
    final isHighlighted = _highlightedWidget == baseName || _highlightedWidget == name;
      key: _getKeyForWidget(name),
        color: isHighlighted ? TossColors.primarySurface : null,
        border: Border(
          bottom: BorderSide(color: TossColors.gray100),
          left: isHighlighted
              ? BorderSide(color: TossColors.primary, width: 3)
              : BorderSide.none,
        crossAxisAlignment: CrossAxisAlignment.start,
          // Widget name and path
              Expanded(
                child: Text(
                  name,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isHighlighted ? TossColors.primary : TossColors.gray900,
              GestureDetector(
                onTap: () => _showPathDialog(name, path),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.code, size: 12, color: TossColors.gray500),
                      const SizedBox(width: 4),
                      Text(
                        'Code',
                        style: TossTextStyles.small.copyWith(color: TossColors.gray500),
                    ],
          const SizedBox(height: TossSpacing.space3),
          // Widget preview
          widget,
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
  void _showPathDialog(String name, String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name, style: TossTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File Path:', style: TossTextStyles.caption),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(8),
              child: Text(
                path,
                style: TossTextStyles.small.copyWith(
                  fontFamily: 'monospace',
                  color: TossColors.gray700,
          ],
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
