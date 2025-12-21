// Presentation Page: Stock In Detail
// Page for viewing and managing stock in record details

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/gray_divider_space.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_badge.dart';
import 'stock_in_task_sheet_page.dart';

/// Stock In Detail Page
class StockInDetailPage extends ConsumerStatefulWidget {
  final String stockInId;
  final String shipmentCode;
  final String location;
  final DateTime startedAt;
  final String status;
  final int arrivalPercentage;
  final String? memo;

  const StockInDetailPage({
    super.key,
    required this.stockInId,
    required this.shipmentCode,
    required this.location,
    required this.startedAt,
    required this.status,
    required this.arrivalPercentage,
    this.memo,
  });

  @override
  ConsumerState<StockInDetailPage> createState() => _StockInDetailPageState();
}

class _StockInDetailPageState extends ConsumerState<StockInDetailPage> {
  // Mock task sheets data
  final List<_TaskSheet> _taskSheets = [];

  // Editable state variables
  late String _shipmentCode;
  late String _location;
  String? _locationId;
  String? _memo;
  late int _arrivalPercentage;

  @override
  void initState() {
    super.initState();
    _shipmentCode = widget.shipmentCode;
    _location = widget.location;
    _memo = widget.memo;
    _arrivalPercentage = widget.arrivalPercentage;
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
            // Task Sheets section
            _buildTaskSheetsSection(),
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
        'Stock In Details',
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
          // Title (Shipment Code)
          Expanded(
            child: Text(
              _shipmentCode,
              style: TossTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: TossColors.gray900,
              ),
            ),
          ),
          // Edit button
          GestureDetector(
            onTap: _onEdit,
            child: const Icon(
              Icons.edit_outlined,
              color: TossColors.gray600,
              size: 22,
            ),
          ),
          const SizedBox(width: TossSpacing.space4),
          // Delete button
          GestureDetector(
            onTap: _onDelete,
            child: const Icon(
              Icons.delete_outline,
              color: TossColors.gray600,
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
          // Arrival row
          _buildDetailRow(
            label: 'Arrival',
            value: '$_arrivalPercentage%',
          ),
          const SizedBox(height: TossSpacing.space3),
          // Location row
          _buildDetailRow(
            label: 'Location',
            value: _location,
          ),
          const SizedBox(height: TossSpacing.space3),
          // Started row
          _buildDetailRow(
            label: 'Started',
            value: _formatDateTime(widget.startedAt),
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
    final isInProgress = widget.status == 'inProgress';

    return TossStatusBadge(
      label: isInProgress ? 'In Progress' : 'Done',
      status: isInProgress ? BadgeStatus.success : BadgeStatus.info,
    );
  }

  Widget _buildTaskSheetsSection() {
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
                'Task Sheets',
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              GestureDetector(
                onTap: _onAddTaskSheet,
                child: Text(
                  '+ Add',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Task sheets list or empty state
        if (_taskSheets.isEmpty)
          _buildTaskSheetsEmptyState()
        else
          _buildTaskSheetsList(),
      ],
    );
  }

  Widget _buildTaskSheetsEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space6,
      ),
      child: Center(
        child: Text(
          'Add a task sheet to start your stock in counting session.',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskSheetsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _taskSheets.length,
      itemBuilder: (context, index) {
        final taskSheet = _taskSheets[index];
        return _buildTaskSheetItem(taskSheet);
      },
    );
  }

  Widget _buildTaskSheetItem(_TaskSheet taskSheet) {
    return GestureDetector(
      onTap: () => _onTaskSheetTap(taskSheet),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TossColors.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: Name and Status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    taskSheet.name,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                _buildTaskSheetStatusBadge(taskSheet.status),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
            // Details rows
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column: Items, Quantity, Started/Completed
                Expanded(
                  child: Column(
                    children: [
                      _buildTaskSheetDetailRow('Items', '${taskSheet.itemsCount}'),
                      const SizedBox(height: TossSpacing.space2),
                      _buildTaskSheetDetailRow('Quantity', '${taskSheet.quantity}'),
                      const SizedBox(height: TossSpacing.space2),
                      _buildTaskSheetDetailRow(
                        taskSheet.status == TaskSheetStatus.completed
                            ? 'Completed'
                            : 'Started',
                        _formatShortDateTime(
                          taskSheet.status == TaskSheetStatus.completed
                              ? taskSheet.completedAt ?? taskSheet.startedAt
                              : taskSheet.startedAt,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right column: Assignee
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: TossColors.gray500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          taskSheet.assignee,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSheetDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 70,
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

  Widget _buildTaskSheetStatusBadge(TaskSheetStatus status) {
    String label;
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case TaskSheetStatus.notStarted:
        label = 'Not started';
        backgroundColor = TossColors.gray100;
        textColor = TossColors.gray600;
        break;
      case TaskSheetStatus.inProgress:
        label = 'In Progress';
        backgroundColor = TossColors.profit;
        textColor = TossColors.white;
        break;
      case TaskSheetStatus.completed:
        label = 'Completed';
        backgroundColor = TossColors.primary;
        textColor = TossColors.white;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TossTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatShortDateTime(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return 'Dec $day, $year · $hour:$minute';
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$month $day, $year $hour12:$minute $period';
  }

  void _onSubmit() {
    // Save progress and go back to the previous page
    Navigator.of(context).pop();
  }

  void _onEdit() {
    // TODO: Navigate to edit stock in page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit stock in record'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onDelete() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Stock In Record'),
        content: const Text('Are you sure you want to delete this stock in record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Stock in record deleted'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: TossColors.loss),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddTaskSheet() {
    final nameController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Task Sheet',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Name',
                    style: TossTextStyles.label.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Enter task sheet name',
                      hintStyle: TossTextStyles.body.copyWith(
                        color: TossColors.gray400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: TossColors.gray300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: TossColors.gray300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: TossColors.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        if (name.isNotEmpty) {
                          Navigator.pop(dialogContext);
                          _createTaskSheet(name);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        foregroundColor: TossColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createTaskSheet(String name) {
    setState(() {
      _taskSheets.add(_TaskSheet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        itemsCount: 0,
        quantity: 0,
        status: TaskSheetStatus.notStarted,
        assignee: 'BoxHero', // TODO: Get current user name
        startedAt: DateTime.now(),
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task sheet "$name" created'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onTaskSheetTap(_TaskSheet taskSheet) async {
    final result = await Navigator.push<StockInTaskSheetResult>(
      context,
      MaterialPageRoute(
        builder: (context) => StockInTaskSheetPage(
          taskSheetId: taskSheet.id,
          taskSheetName: taskSheet.name,
          initialCountedQuantities: taskSheet.countedQuantities,
          initialRejectedQuantities: taskSheet.rejectedQuantities,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        final index = _taskSheets.indexWhere((t) => t.id == taskSheet.id);
        if (index != -1) {
          TaskSheetStatus newStatus;
          DateTime? completedAt;

          if (result.isCompleted) {
            newStatus = TaskSheetStatus.completed;
            completedAt = DateTime.now();
          } else if (result.isDraft) {
            newStatus = TaskSheetStatus.inProgress;
            completedAt = null;
          } else {
            newStatus = taskSheet.status;
            completedAt = taskSheet.completedAt;
          }

          _taskSheets[index] = _TaskSheet(
            id: taskSheet.id,
            name: taskSheet.name,
            itemsCount: result.itemsCount,
            quantity: result.totalQuantity,
            rejected: result.totalRejected,
            status: newStatus,
            assignee: taskSheet.assignee,
            startedAt: taskSheet.startedAt,
            completedAt: completedAt,
            countedQuantities: Map<String, int>.from(result.countedQuantities),
            rejectedQuantities: Map<String, int>.from(result.rejectedQuantities),
          );
        }
      });
    }
  }
}

/// Task sheet status
enum TaskSheetStatus {
  notStarted,
  inProgress,
  completed,
}

/// Task sheet data model
class _TaskSheet {
  final String id;
  final String name;
  final int itemsCount;
  final int quantity;
  final int rejected;
  final TaskSheetStatus status;
  final String assignee;
  final DateTime startedAt;
  final DateTime? completedAt;
  final Map<String, int>? _countedQuantities;
  final Map<String, int>? _rejectedQuantities;

  // Getter that provides a fallback for null values (handles hot reload issues)
  Map<String, int> get countedQuantities => _countedQuantities ?? const {};
  Map<String, int> get rejectedQuantities => _rejectedQuantities ?? const {};

  _TaskSheet({
    required this.id,
    required this.name,
    required this.itemsCount,
    required this.quantity,
    this.rejected = 0,
    required this.status,
    required this.assignee,
    required this.startedAt,
    this.completedAt,
    Map<String, int>? countedQuantities,
    Map<String, int>? rejectedQuantities,
  })  : _countedQuantities = countedQuantities ?? const {},
        _rejectedQuantities = rejectedQuantities ?? const {};
}
