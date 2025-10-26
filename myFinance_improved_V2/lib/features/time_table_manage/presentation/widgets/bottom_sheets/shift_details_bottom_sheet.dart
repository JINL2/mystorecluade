// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation, argument_type_not_assignable, invalid_assignment, non_bool_condition, non_bool_negation_expression, non_bool_operand, use_of_void_result
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../core/utils/input_formatters.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../../shared/widgets/toss/toss_time_picker.dart';
import '../../providers/time_table_providers.dart';

class ShiftDetailsBottomSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> card;
  final VoidCallback? onUpdate;

  const ShiftDetailsBottomSheet({
    super.key,
    required this.card,
    this.onUpdate,
  });

  @override
  ConsumerState<ShiftDetailsBottomSheet> createState() => _ShiftDetailsBottomSheetState();
}

class _ShiftDetailsBottomSheetState extends ConsumerState<ShiftDetailsBottomSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? editedStartTime;
  String? editedEndTime;
  String? selectedTagType;
  String? tagContent;
  late bool isProblemSolved;
  String bonusInputText = '';
  late TextEditingController bonusController;
  
  // Original values to track changes
  String? originalStartTime;
  String? originalEndTime;
  late bool originalProblemSolved;
  
  final List<String> tagTypes = [
    'Schedule Change',
    'Exceptional Case', 
    'Manager Note',
    'Policy Violation',
    'Others',
    'Reset'
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize with confirmed times
    editedStartTime = widget.card['confirm_start_time'];
    editedEndTime = widget.card['confirm_end_time'];
    // Store original values
    originalStartTime = editedStartTime;
    originalEndTime = editedEndTime;
    
    // Tag values start as null
    selectedTagType = null;
    tagContent = null;
    
    // Initialize bonus controller - always start with empty text
    bonusController = TextEditingController(text: '');
    bonusInputText = bonusController.text;
    bonusController.addListener(() {
      setState(() {
        bonusInputText = bonusController.text;
      });
    });
    
    // Initialize problem solved state
    final isProblem = widget.card['is_problem'] == true;
    final wasSolved = widget.card['is_problem_solved'] == true;
    
    if (!isProblem) {
      // If not a problem, default to solved (clicked)
      isProblemSolved = true;
    } else if (isProblem && wasSolved) {
      // If problem and already solved, default to solved (clicked)
      isProblemSolved = true;
    } else {
      // If problem and not solved, default to unsolved (unclicked)
      isProblemSolved = false;
    }
    originalProblemSolved = isProblemSolved;
  }
  
  // Check if any changes have been made
  bool hasChanges() {
    // Check if times have changed
    final timeChanged = editedStartTime != originalStartTime || 
                       editedEndTime != originalEndTime;
    
    // Check if problem status changed
    final problemChanged = isProblemSolved != originalProblemSolved;
    
    // Check if tag is being added
    final tagAdded = (selectedTagType != null && tagContent != null && tagContent!.isNotEmpty);
    
    return timeChanged || problemChanged || tagAdded;
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    bonusController.dispose();
    super.dispose();
  }
  
  Future<void> _showBonusConfirmationDialog() async {
    // Get current bonus from card
    final dynamic rawBonusAmount = widget.card['bonus_amount'];
    final num currentBonus = rawBonusAmount is String 
        ? num.tryParse(rawBonusAmount) ?? 0 
        : rawBonusAmount ?? 0;
    
    // Get base pay
    final dynamic rawBasePay = widget.card['base_pay'] ?? '0';
    final num basePay = rawBasePay is String 
        ? num.tryParse(rawBasePay.replaceAll(',', '')) ?? 0 
        : rawBasePay ?? 0;
    
    // Get typed bonus (remove commas for parsing)
    String cleanInput = bonusInputText.replaceAll(',', '');
    final num typedBonus = num.tryParse(cleanInput) ?? 0;
    
    // Calculate total pays
    final num currentTotal = basePay + currentBonus;
    final num newTotal = basePay + typedBonus;
    
    // Format numbers for display
    final formatter = NumberFormat('#,###');
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          ),
          title: Text(
            'Confirm Bonus',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.info.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  border: Border.all(
                    color: TossColors.info.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Payment Summary',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    
                    // Base Pay
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Base Pay',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          basePay != 0 ? formatter.format(basePay) : '0',
                          style: TossTextStyles.body.copyWith(
                            color: basePay < 0 ? TossColors.error : TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    
                    // Current Bonus with arrow to New Bonus
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bonus',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              currentBonus > 0 ? '+ ${formatter.format(currentBonus)}' : '+ 0',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray500,
                                fontWeight: FontWeight.w600,
                                decoration: currentTotal != newTotal ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            if (currentTotal != newTotal) ...[
                              const SizedBox(width: TossSpacing.space2),
                              const Icon(
                                Icons.arrow_forward,
                                size: 14,
                                color: TossColors.info,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                typedBonus > 0 ? '+ ${formatter.format(typedBonus)}' : '+ 0',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.info,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    
                    // Divider
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                      height: 1,
                      color: TossColors.info.withValues(alpha: 0.2),
                    ),
                    
                    // Total Pay
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pay',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          formatter.format(newTotal),
                          style: TossTextStyles.h3.copyWith(
                            color: newTotal < 0 ? TossColors.error : TossColors.info,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.gray200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space4,
                          vertical: TossSpacing.space3,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space4,
                          vertical: TossSpacing.space3,
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [],
        );
      },
    );
    
    if (result == true) {
      await _updateBonusAmount(typedBonus);
    }
  }
  
  Future<void> _updateBonusAmount(num newBonus) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: TossColors.primary,
          ),
        ),
      );
      
      // Get shift request ID from the card
      final shiftRequestId = widget.card['shift_request_id'];
      
      if (shiftRequestId == null) {
        throw Exception('Shift request ID not found');
      }

      // Use repository instead of direct Supabase call
      await ref.read(timeTableRepositoryProvider).updateBonusAmount(
        shiftRequestId: shiftRequestId,
        bonusAmount: newBonus.toDouble(),
      );

      // Close loading dialog
      Navigator.of(context).pop();
      
      // Update the card in parent's state by returning the new bonus amount
      Navigator.of(context).pop({'updated': true, 'bonus_amount': newBonus, 'shift_request_id': shiftRequestId});
      
    } catch (e) {
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update bonus: $e',
            style: TossTextStyles.body.copyWith(color: TossColors.white),
          ),
          backgroundColor: TossColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
      );
    }
  }
  
  Future<void> _showDeleteTagDialog(BuildContext context, String tagId, String content) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          ),
          title: Text(
            'Delete Tag',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Do you want to delete this tag?',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              Container(
                padding: const EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Text(
                  content,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: TossColors.error,
              ),
              child: Text(
                'Delete',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
    
    if (result == true && mounted) {
      await _deleteTag(tagId);
    }
  }
  
  Future<void> _showNotApproveDialog(BuildContext context, Map<String, dynamic> card) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          ),
          title: Text(
            'Confirm',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: Text(
            'Are you sure you want to not approve this shift?',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: TossColors.warning,
              ),
              child: Text(
                'Yes',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
    
    if (result == true && mounted) {
      await _toggleApprovalStatus(card['shift_request_id']);
    }
  }
  
  Future<void> _toggleApprovalStatus(String shiftRequestId) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: true, // Allow dismissing loading dialogs
        builder: (BuildContext context) {
          return const Center(
            child: const TossLoadingView(
            ),
          );
        },
      );
      
      // Get user ID from app state
      final appState = ref.read(appStateProvider);
      final userId = appState.user['user_id'] ?? '';
      
      if (userId.isEmpty || shiftRequestId.isEmpty) {
        throw Exception('Missing user ID or shift request ID');
      }
      
      // Use repository instead of direct Supabase call
      // Toggle: if currently approved, make it pending (false), and vice versa
      final isCurrentlyApproved = widget.card['is_approved'] == true;
      final newState = !isCurrentlyApproved;

      await ref.read(timeTableRepositoryProvider).processBulkApproval(
        shiftRequestIds: [shiftRequestId],
        approvalStates: [newState],
      );

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Shift request changed to pending successfully',
              style: TossTextStyles.body.copyWith(
                color: TossColors.white,
              ),
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            margin: const EdgeInsets.all(TossSpacing.space4),
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Close the bottom sheet and return true to trigger refresh in parent
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: TossTextStyles.body.copyWith(
                color: TossColors.white,
              ),
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            margin: const EdgeInsets.all(TossSpacing.space4),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
  
  Future<void> _deleteTag(String tagId) async {
    // Validate tag ID
    if (tagId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid tag ID',
            style: TossTextStyles.body.copyWith(color: TossColors.white),
          ),
          backgroundColor: TossColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
      );
      return;
    }
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: TossLoadingView(),
          );
        },
      );
      
      // Get user ID from app state
      final appState = ref.read(appStateProvider);
      final userId = appState.user['user_id'] ?? '';
      
      if (userId.isEmpty) {
        throw Exception('User ID not found');
      }
      
      // Debug log

      // Use repository instead of direct Supabase call
      final response = await ref.read(timeTableRepositoryProvider).deleteShiftTag(
        tagId: tagId,
        userId: userId,
      );

      // Debug log response
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Check response
      if (response != null && response is Map) {
        final success = response['success'] ?? false;
        
        if (!success) {
          // Handle error response
          final errorMessage = response['message'] ?? 'Failed to delete tag';
          final errorCode = response['error'] ?? 'UNKNOWN_ERROR';
          
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  errorMessage,
                  style: TossTextStyles.body.copyWith(color: TossColors.white),
                ),
                backgroundColor: TossColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                margin: const EdgeInsets.all(TossSpacing.space4),
                duration: const Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tag deleted successfully',
              style: TossTextStyles.body.copyWith(color: TossColors.white),
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            margin: const EdgeInsets.all(TossSpacing.space4),
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Don't modify widget.card directly, just close with success flag
        // The parent will refresh the data
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete tag: ${e.toString()}',
              style: TossTextStyles.body.copyWith(color: TossColors.white),
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            margin: const EdgeInsets.all(TossSpacing.space4),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final hasUnsolvedProblem = card['is_problem'] == true && card['is_problem_solved'] != true;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8 - MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),
          // Header with user info
          Container(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space4,
              TossSpacing.space5,
              TossSpacing.space3,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        TossColors.primary.withValues(alpha: 0.8),
                        TossColors.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                  ),
                  child: Center(
                    child: Text(
                      (card['user_name'] ?? '?')[0].toUpperCase(),
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card['user_name'] ?? 'Unknown',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${card['shift_name'] ?? ''} • ${card['request_date'] ?? ''}',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: TossColors.gray600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tab Bar - Same style as main page
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space5,
              vertical: TossSpacing.space3,
            ),
            height: 44,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            ),
            padding: const EdgeInsets.all(2),
            child: AnimatedBuilder(
              animation: _tabController,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Animated selection indicator
                    AnimatedAlign(
                      alignment: _tabController.index == 0 
                        ? Alignment.centerLeft 
                        : _tabController.index == 1
                          ? Alignment.center
                          : Alignment.centerRight,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: FractionallySizedBox(
                        widthFactor: 1/3,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: TossColors.white,
                            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                            boxShadow: [
                              BoxShadow(
                                color: TossColors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Tab buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_tabController.index != 0) {
                                _tabController.animateTo(0);
                                HapticFeedback.lightImpact();
                              }
                            },
                            child: Container(
                              color: TossColors.transparent,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: 200),
                                  style: TossTextStyles.bodySmall.copyWith(
                                    color: _tabController.index == 0 
                                      ? TossColors.gray900 
                                      : TossColors.gray600,
                                    fontWeight: _tabController.index == 0 
                                      ? FontWeight.w700 
                                      : FontWeight.w500,
                                  ),
                                  child: Text('Info'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_tabController.index != 1) {
                                _tabController.animateTo(1);
                                HapticFeedback.lightImpact();
                              }
                            },
                            child: Container(
                              color: TossColors.transparent,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: 200),
                                  style: TossTextStyles.bodySmall.copyWith(
                                    color: _tabController.index == 1 
                                      ? TossColors.gray900 
                                      : TossColors.gray600,
                                    fontWeight: _tabController.index == 1 
                                      ? FontWeight.w700 
                                      : FontWeight.w500,
                                  ),
                                  child: Text('Manage'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_tabController.index != 2) {
                                _tabController.animateTo(2);
                                HapticFeedback.lightImpact();
                              }
                            },
                            child: Container(
                              color: TossColors.transparent,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: 200),
                                  style: TossTextStyles.bodySmall.copyWith(
                                    color: _tabController.index == 2 
                                      ? TossColors.gray900 
                                      : TossColors.gray600,
                                    fontWeight: _tabController.index == 2 
                                      ? FontWeight.w700 
                                      : FontWeight.w500,
                                  ),
                                  child: Text('Bonus'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Info Tab
                _buildInfoTab(card, hasUnsolvedProblem),
                // Manage Tab
                _buildManageTab(card),
                // Bonus Tab
                _buildBonusTab(card),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoTab(Map<String, dynamic> card, bool hasUnsolvedProblem) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Problem Alert if there's an unsolved problem
          if (hasUnsolvedProblem) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(
                TossSpacing.space5,
                TossSpacing.space2,
                TossSpacing.space5,
                TossSpacing.space3,
              ),
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                border: Border.all(
                  color: TossColors.error.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: TossColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Text(
                        'Problem Detected',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (card['problem_type'] != null) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      'Type: ${card['problem_type']}',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.error.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                  if (card['problem_description'] != null) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      card['problem_description'],
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ],
                  // Display report reason if the problem has been reported
                  if (card['is_reported'] == true && card['report_reason'] != null) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      card['report_reason'],
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          
          // Primary Time Info - Most Important (Confirmed Times)
          Container(
                      margin: const EdgeInsets.fromLTRB(
                        TossSpacing.space5,
                        TossSpacing.space2,
                        TossSpacing.space5,
                        TossSpacing.space3,
                      ),
                      padding: const EdgeInsets.all(TossSpacing.space5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            TossColors.primary.withValues(alpha: 0.05),
                            TossColors.primary.withValues(alpha: 0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                        border: Border.all(
                          color: TossColors.primary.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with icon
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: TossColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                ),
                                child: const Icon(
                                  Icons.access_time_filled,
                                  size: 18,
                                  color: TossColors.primary,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space3),
                              Text(
                                'Confirmed Working Hours',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space5),
                          // Time display in big format
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'START',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray500,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: TossSpacing.space2),
                                    Text(
                                      card['confirm_start_time'] ?? '--:--',
                                      style: TossTextStyles.display.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: card['confirm_start_time'] != null 
                                          ? TossColors.gray900 
                                          : TossColors.gray400,
                                        fontFamily: 'JetBrains Mono',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 50,
                                color: TossColors.gray200,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'END',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray500,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: TossSpacing.space2),
                                    Text(
                                      card['confirm_end_time'] ?? '--:--',
                                      style: TossTextStyles.display.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: card['confirm_end_time'] != null 
                                          ? TossColors.gray900 
                                          : TossColors.gray400,
                                        fontFamily: 'JetBrains Mono',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Total hours if available
                          if (card['paid_hour'] != null && card['paid_hour'] > 0) ...[
                            const SizedBox(height: TossSpacing.space4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space3,
                                vertical: TossSpacing.space2,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.background,
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    size: 16,
                                    color: TossColors.gray600,
                                  ),
                                  const SizedBox(width: TossSpacing.space2),
                                  Text(
                                    'Total: ${card['paid_hour']} hours',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Quick Status Pills
                    Container(
                      height: 36,
                      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                        children: [
                          // Approval status
                          _buildStatusPill(
                            icon: card['is_approved'] == true 
                              ? Icons.check_circle 
                              : Icons.pending,
                            label: card['is_approved'] == true ? 'Approved' : 'Pending',
                            color: card['is_approved'] == true 
                              ? TossColors.success 
                              : TossColors.warning,
                          ),
                          // Problem status
                          if (card['is_problem'] == true)
                            _buildStatusPill(
                              icon: card['is_problem_solved'] == true 
                                ? Icons.check_circle_outline 
                                : Icons.warning_amber_rounded,
                              label: card['is_problem_solved'] == true 
                                ? 'Problem Solved' 
                                : 'Has Problem',
                              color: card['is_problem_solved'] == true 
                                ? TossColors.success 
                                : TossColors.error,
                            ),
                          // Late status
                          if (card['is_late'] == true)
                            _buildStatusPill(
                              icon: Icons.schedule,
                              label: 'Late ${card['late_minute']}min',
                              color: TossColors.error,
                            ),
                          // Overtime
                          if (card['is_over_time'] == true)
                            _buildStatusPill(
                              icon: Icons.trending_up,
                              label: 'OT ${card['over_time_minute']}min',
                              color: TossColors.info,
                            ),
                        ],
                      ),
                    ),
                    
                    // Shift Information Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shift Details',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space3),
                          _buildDetailRow('Store', card['store_name'] ?? 'N/A'),
                          _buildDetailRow('Shift Type', card['shift_name'] ?? 'N/A'),
                          _buildDetailRow('Scheduled Time', card['shift_time'] ?? 'N/A'),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    
                    // Actual Check-in/out Times
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Check-in/out Records',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space3),
                          _buildDetailRow('Actual Check-in', card['actual_start'] ?? 'Not checked in'),
                          _buildDetailRow('Actual Check-out', card['actual_end'] ?? 'Not checked out'),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    
                    // Location section (if available)
                    if (card['is_valid_checkin_location'] != null || card['is_valid_checkout_location'] != null) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space3),
                            if (card['is_valid_checkin_location'] != null)
                              _buildDetailRow('Check-in Location', 
                                card['is_valid_checkin_location'] == true ? 'Valid' : 'Invalid',
                                valueColor: card['is_valid_checkin_location'] == true ? TossColors.success : TossColors.error),
                            if (card['checkin_distance_from_store'] != null && card['checkin_distance_from_store'] > 0)
                              _buildDetailRow('Check-in Distance', '${card['checkin_distance_from_store']}m from store'),
                            if (card['is_valid_checkout_location'] != null)
                              _buildDetailRow('Check-out Location', 
                                card['is_valid_checkout_location'] == true ? 'Valid' : 'Invalid',
                                valueColor: card['is_valid_checkout_location'] == true ? TossColors.success : TossColors.error),
                            if (card['checkout_distance_from_store'] != null && card['checkout_distance_from_store'] > 0)
                              _buildDetailRow('Check-out Distance', '${card['checkout_distance_from_store']}m from store'),
                          ],
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                    ],
                    
                    // Additional info
                    if (card['notice_tag'] != null && (card['notice_tag'] as List).isNotEmpty) ...[
                      _buildSectionTitle('Notice Tags'),
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Wrap(
                          spacing: TossSpacing.space2,
                          runSpacing: TossSpacing.space2,
                          children: (card['notice_tag'] as List).map((tag) {
                            // Parse tag as a Map and extract only content
                            final tagData = tag is Map ? tag : {};
                            final content = tagData['content'] ?? 'No content';
                            
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space3,
                                vertical: TossSpacing.space1,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: Text(
                                content,
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.primary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                    ],
                    
                    const SizedBox(height: TossSpacing.space5),
                  ],
                ),
              );
  }
  
  Widget _buildManageTab(Map<String, dynamic> card) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Edit Confirmed Times Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: TossColors.gray700,
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            'Edit Confirmed Times',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      // Start Time Editor
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Start Time',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: TossTimePicker(
                              time: _parseTimeString(editedStartTime),
                              placeholder: '--:--',
                              use24HourFormat: false,
                              onTimeChanged: (TimeOfDay time) {
                                setState(() {
                                  editedStartTime = _formatTimeOfDay(time);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      // End Time Editor
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'End Time',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: TossTimePicker(
                              time: _parseTimeString(editedEndTime),
                              placeholder: '--:--',
                              use24HourFormat: false,
                              onTimeChanged: (TimeOfDay time) {
                                setState(() {
                                  editedEndTime = _formatTimeOfDay(time);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),
                
                // Problem Status Section
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with problem status
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 20,
                              color: isProblemSolved ? TossColors.success : TossColors.warning,
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            Text(
                              'Problem Status',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TossSpacing.space3),
                        // Animated toggle button - Same style as journal input
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          padding: EdgeInsets.all(TossSpacing.space1),
                          child: Stack(
                            children: [
                              // Animated selection indicator
                              AnimatedAlign(
                                alignment: isProblemSolved 
                                  ? Alignment.centerRight 
                                  : Alignment.centerLeft,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                child: FractionallySizedBox(
                                  widthFactor: 0.5,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    decoration: BoxDecoration(
                                      color: isProblemSolved 
                                        ? TossColors.success 
                                        : TossColors.warning,
                                      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isProblemSolved 
                                            ? TossColors.success 
                                            : TossColors.warning).withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildProblemToggleButton('Not solve', false),
                                  ),
                                  Expanded(
                                    child: _buildProblemToggleButton('Solved', true),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space2),
                        // Status description
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: Row(
                            children: [
                              Icon(
                                isProblemSolved ? Icons.check_circle_outline : Icons.info_outline,
                                size: 16,
                                color: isProblemSolved ? TossColors.success : TossColors.gray600,
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Expanded(
                                child: Text(
                                  isProblemSolved 
                                    ? 'The shift problem has been resolved'
                                    : 'Toggle on when the problem is resolved',
                                  style: TossTextStyles.caption.copyWith(
                                    color: isProblemSolved ? TossColors.success : TossColors.gray600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
                const SizedBox(height: TossSpacing.space4),
                
                // Add Tag Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.label_outline,
                            size: 20,
                            color: TossColors.gray700,
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            'Add Tag',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      
                      // Tag Type Selector
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space1,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.background,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          border: Border.all(
                            color: TossColors.gray200,
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedTagType,
                            hint: Text(
                              'Select Tag Type',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray400,
                              ),
                            ),
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: TossColors.gray500,
                            ),
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTagType = newValue;
                              });
                            },
                            items: tagTypes.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      
                      // Tag Content Text Field
                      Container(
                        decoration: BoxDecoration(
                          color: TossColors.background,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          border: Border.all(
                            color: TossColors.gray200,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              tagContent = value.isEmpty ? null : value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter tag content...',
                            hintStyle: TossTextStyles.body.copyWith(
                              color: TossColors.gray400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(TossSpacing.space3),
                          ),
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                          ),
                          maxLines: 3,
                          minLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Existing Tags Display - Always show the section for consistent layout
                const SizedBox(height: TossSpacing.space4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Existing Tags',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      if (card['notice_tag'] != null && (card['notice_tag'] as List).isNotEmpty)
                        Wrap(
                          spacing: TossSpacing.space2,
                          runSpacing: TossSpacing.space2,
                          children: (card['notice_tag'] as List).map((tag) {
                            // Parse tag as a Map if it's not already
                            final tagData = tag is Map ? tag : {};
                            final content = tagData['content'] ?? 'No content';
                            final tagId = tagData['id']?.toString() ?? '';
                            
                            // Only show delete option if tag has a valid ID
                            if (tagId.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space3,
                                  vertical: TossSpacing.space2,
                                ),
                                decoration: BoxDecoration(
                                  color: TossColors.gray100,
                                  borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                                ),
                                child: Text(
                                  content,
                                  style: TossTextStyles.bodySmall.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                              );
                            }
                            
                            return GestureDetector(
                              onTap: () => _showDeleteTagDialog(context, tagId.toString(), content),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space3,
                                  vertical: TossSpacing.space2,
                                ),
                                decoration: BoxDecoration(
                                  color: TossColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                                  border: Border.all(
                                    color: TossColors.primary.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      content,
                                      style: TossTextStyles.bodySmall.copyWith(
                                        color: TossColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: TossSpacing.space1),
                                    Icon(
                                      Icons.close,
                                      size: 14,
                                      color: TossColors.primary.withValues(alpha: 0.6),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      else
                        Text(
                          'No tags added yet',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),
              ],
            ),
          ),
        ),
        
        // Bottom Action Buttons
        Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                // First Row: Not Approve button (full width)
                _buildBottomButton(
                  'Not Approve',
                  TossColors.warning,
                  Icons.remove_circle_outline,
                  card['is_approved'] == false ? null : () => _showNotApproveDialog(context, card),
                  outlined: true,
                  disabled: card['is_approved'] == false,
                ),
                const SizedBox(height: TossSpacing.space3),
                // Second Row: Save button (full width)
                _buildBottomButton(
                  'Save',
                  TossColors.primary,
                  Icons.save_outlined,
                  hasChanges() ? () async {
                    // Validate tag inputs - both must be provided or both must be empty
                    final hasTagType = selectedTagType != null && selectedTagType!.trim().isNotEmpty;
                    final hasTagContent = tagContent != null && tagContent!.trim().isNotEmpty;
                    
                    if (hasTagType != hasTagContent) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please fill both tag type and content or leave both empty',
                            style: TossTextStyles.body.copyWith(color: TossColors.white),
                          ),
                          backgroundColor: TossColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                        ),
                      );
                      return;
                    }
                    
                    // Additional validation for tag content length
                    if (hasTagContent && tagContent!.trim().length > 500) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Tag content cannot exceed 500 characters',
                            style: TossTextStyles.body.copyWith(color: TossColors.white),
                          ),
                          backgroundColor: TossColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                        ),
                      );
                      return;
                    }
                    
                    // Show confirmation dialog
                    final bool? shouldSave = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          backgroundColor: TossColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                          ),
                          title: Text(
                            'Confirm Save',
                            style: TossTextStyles.body.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: TossColors.gray900,
                            ),
                          ),
                          content: Text(
                            'Do you want to save the changes?',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext, false),
                              child: Text(
                                'Cancel',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext, true),
                              style: TextButton.styleFrom(
                                backgroundColor: TossColors.primary.withValues(alpha: 0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                                child: Text(
                                  'OK',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    
                    // If user cancelled, return
                    if (shouldSave != true) {
                      return;
                    }
                    
                    // Get values from app state and card
                    final appState = ref.read(appStateProvider);
                    final userId = appState.user['user_id'];
                    final shiftRequestId = widget.card['shift_request_id'];
                    final isLate = widget.card['is_late'] ?? false;
                    
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: true, // Allow dismissing loading dialogs
                      builder: (BuildContext context) {
                        return const Center(
                          child: const TossLoadingView(
                          ),
                        );
                      },
                    );
                    
                    try {
                      // Format times to ensure HH:mm format (24-hour)
                      String? formatTimeToHHmm(String? timeStr) {
                        if (timeStr == null || timeStr == '--:--' || timeStr.isEmpty) return null;
                        
                        // If already in HH:mm format, validate and return
                        if (RegExp(r'^\d{2}:\d{2}$').hasMatch(timeStr)) {
                          final parts = timeStr.split(':');
                          final hour = int.parse(parts[0]);
                          final minute = int.parse(parts[1]);
                          // Validate time values
                          if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
                            return timeStr;
                          }
                        }
                        
                        // Try to extract time from datetime string
                        try {
                          if (timeStr.contains('T') || timeStr.contains(' ')) {
                            final parts = timeStr.split(RegExp(r'[T ]'));
                            if (parts.length > 1) {
                              final timePart = parts[1];
                              final timeComponents = timePart.split(':');
                              if (timeComponents.length >= 2) {
                                final hour = int.tryParse(timeComponents[0]) ?? 0;
                                final minute = int.tryParse(timeComponents[1]) ?? 0;
                                if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
                                  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
                                }
                              }
                            }
                          }
                          return null; // Return null if can't parse properly
                        } catch (e) {
                          return null;
                        }
                      }
                      
                      // Format times - these should already be in HH:mm format from _formatTimeOfDay
                      final startTimeHHmm = formatTimeToHHmm(editedStartTime ?? widget.card['confirm_start_time']);
                      final endTimeHHmm = formatTimeToHHmm(editedEndTime ?? widget.card['confirm_end_time']);

                      // Validate times are not null
                      if (startTimeHHmm == null || endTimeHHmm == null) {
                        throw Exception('Start time and end time are required');
                      }

                      // Get request date for full DateTime conversion
                      final requestDate = widget.card['request_date'] as String?;
                      if (requestDate == null || requestDate.isEmpty) {
                        throw Exception('Request date is required for time conversion');
                      }

                      // Convert HH:mm to full DateTime and then to UTC for DB storage
                      final startDateTime = DateTime.parse('$requestDate $startTimeHHmm:00');
                      final endDateTime = DateTime.parse('$requestDate $endTimeHHmm:00');

                      // Convert to UTC ISO8601 string for RPC
                      final startTimeUtc = DateTimeUtils.toUtc(startDateTime);
                      final endTimeUtc = DateTimeUtils.toUtc(endDateTime);

                      // Prepare tag parameters - ensure null instead of empty strings
                      final processedTagContent = (tagContent != null && tagContent!.trim().isNotEmpty)
                          ? tagContent!.trim()
                          : null;
                      final processedTagType = (selectedTagType != null && selectedTagType!.trim().isNotEmpty)
                          ? selectedTagType!.trim()
                          : null;

                      // Ensure shiftRequestId is valid
                      if (shiftRequestId == null || shiftRequestId.isEmpty) {
                        throw Exception('Invalid shift request ID');
                      }

                      // Use repository instead of direct Supabase call
                      final response = await ref.read(timeTableRepositoryProvider).inputCard(
                        managerId: userId,
                        shiftRequestId: shiftRequestId,
                        confirmStartTime: startTimeUtc,
                        confirmEndTime: endTimeUtc,
                        newTagContent: processedTagContent,
                        newTagType: processedTagType,
                        isLate: isLate,
                        isProblemSolved: isProblemSolved,
                      );

                      // Check if RPC returned an error structure
                      if (response['success'] == false) {
                        final errorMessage = response['message'] ?? 'Unknown error occurred';
                        final errorCode = response['error'] ?? 'UNKNOWN_ERROR';
                        throw Exception('$errorCode: $errorMessage');
                      }
                      
                      // Close loading dialog
                      Navigator.pop(context);
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Successfully saved',
                            style: TossTextStyles.body.copyWith(color: TossColors.white),
                          ),
                          backgroundColor: TossColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                        ),
                      );
                      
                      // Close bottom sheet and trigger refresh
                      Navigator.pop(context, true); // Return true to indicate data changed
                      
                    } catch (e) {
                      // Close loading dialog
                      Navigator.pop(context);
                      
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to save: ${e.toString()}',
                            style: TossTextStyles.body.copyWith(color: TossColors.white),
                          ),
                          backgroundColor: TossColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                        ),
                      );
                    }
                  } : null,
                  outlined: false,
                  fullWidth: true,
                  disabled: !hasChanges(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildBottomButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback? onTap, {
    bool outlined = false,
    bool fullWidth = false,
    bool disabled = false,
  }) {
    final effectiveColor = disabled ? TossColors.gray300 : color;
    
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: outlined ? TossColors.transparent : (disabled ? TossColors.gray100 : effectiveColor),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: outlined ? (disabled ? TossColors.gray200 : effectiveColor.withValues(alpha: 0.3)) : (disabled ? TossColors.gray200 : effectiveColor),
              width: outlined ? 1.5 : 0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: disabled 
                    ? TossColors.gray400 
                    : (outlined ? effectiveColor : TossColors.white),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  color: disabled 
                      ? TossColors.gray400 
                      : (outlined ? effectiveColor : TossColors.white),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper widget for detail rows
  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.bodySmall.copyWith(
              color: valueColor ?? TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper widget for status pills in bottom sheet
  Widget _buildStatusPill({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: TossSpacing.space2),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: TossSpacing.space1),
          Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper widget for section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: TossSpacing.space2,
        bottom: TossSpacing.space3,
      ),
      child: Text(
        title,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray900,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
  
  // Build Bonus tab content
  Widget _buildBonusTab(Map<String, dynamic> card) {
    // Extract salary information from card data
    final String salaryType = card['salary_type'] ?? 'hourly';
    final String salaryAmountStr = card['salary_amount'] ?? '0';
    final dynamic rawBasePay = card['base_pay'] ?? '0';
    final dynamic rawBonusAmount = card['bonus_amount'];

    // Parse numeric values
    final num salaryAmount = num.tryParse(salaryAmountStr.replaceAll(',', '')) ?? 0;
    final num basePay = rawBasePay is String
        ? num.tryParse(rawBasePay.replaceAll(',', '')) ?? 0
        : rawBasePay ?? 0;
    final num bonusAmount = rawBonusAmount is String
        ? num.tryParse(rawBonusAmount) ?? 0
        : rawBonusAmount ?? 0;
    
    // Helper function to format salary type display
    String getSalaryTypeDisplay() {
      if (salaryType == 'hourly') {
        return 'Hourly Rate';
      } else if (salaryType == 'monthly') {
        return 'Monthly Salary';
      }
      return salaryType;
    }
    
    // Create scroll controller for auto-scroll when keyboard appears
    final ScrollController scrollController = ScrollController();
    
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: TossSpacing.space5,
                right: TossSpacing.space5,
                top: TossSpacing.space5,
                bottom: MediaQuery.of(context).viewInsets.bottom + TossSpacing.space5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Title
                Text(
                  'Salary & Bonus Information',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'View salary details and set bonus amount',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),
                
                // Salary Type and Amount
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    border: Border.all(
                      color: TossColors.gray200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getSalaryTypeDisplay(),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space1),
                          Text(
                            salaryAmount > 0 
                                ? NumberFormat('#,###').format(salaryAmount.toInt())
                                : '0',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: salaryType == 'hourly' 
                              ? TossColors.primary.withValues(alpha: 0.1)
                              : TossColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Text(
                          salaryType == 'hourly' ? 'Per Hour' : 'Per Month',
                          style: TossTextStyles.caption.copyWith(
                            color: salaryType == 'hourly' 
                                ? TossColors.primary
                                : TossColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                
                // Combined Payment Information Box with Blue Design
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.info.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    border: Border.all(
                      color: TossColors.info.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Payment Details',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      
                      // Base Pay Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Base Pay',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            basePay != 0 
                                ? NumberFormat('#,###').format(basePay.toInt())
                                : '0',
                            style: TossTextStyles.body.copyWith(
                              color: basePay < 0 ? TossColors.error : TossColors.gray700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      
                      // Current Bonus Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Bonus',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            bonusAmount > 0 
                                ? '+ ${NumberFormat('#,###').format(bonusAmount.toInt())}'
                                : '+ 0',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      
                      // Divider
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                        height: 1,
                        color: TossColors.info.withValues(alpha: 0.2),
                      ),
                      
                      // Total Pay Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Pay',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            NumberFormat('#,###').format((basePay + bonusAmount).toInt()),
                            style: TossTextStyles.h3.copyWith(
                              color: (basePay + bonusAmount) < 0
                                  ? TossColors.error
                                  : TossColors.info,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),
                
                // Divider
                Container(
                  height: 1,
                  color: TossColors.gray200,
                ),
                const SizedBox(height: TossSpacing.space5),
                
                // New Bonus Section Title
                Text(
                  'Set New Bonus',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Enter a new bonus amount for this shift',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                
                // Bonus input field
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    border: Border.all(
                      color: TossColors.gray300,
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: bonusController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ThousandSeparatorInputFormatter(),
                    ],
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TossTextStyles.h3.copyWith(
                        color: TossColors.gray400,
                        fontWeight: FontWeight.w700,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onTap: () {
                      // Auto-scroll to make the input field visible when keyboard appears
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (scrollController.hasClients) {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      });
                    },
                  ),
                ),
                // Add extra padding at the bottom for keyboard
                const SizedBox(height: TossSpacing.space10),
              ],
            ),
          ),
        ),
        // Bottom button section
        Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(TossBorderRadius.xxl),
              topRight: Radius.circular(TossBorderRadius.xxl),
            ),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: _buildBottomButton(
              'Confirm Bonus',
              TossColors.primary,
              Icons.check_circle_outline,
              () {
                HapticFeedback.lightImpact();
                _showBonusConfirmationDialog();
              },
              disabled: bonusInputText.isEmpty,
            ),
          ),
        ),
      ],
      ),
    );
  }

  TimeOfDay? _parseTimeString(String? timeStr) {
    if (timeStr == null || timeStr == '--:--') return null;
    final parts = timeStr.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
  
  Widget _buildProblemToggleButton(String label, bool isSolved) {
    final isSelected = isProblemSolved == isSolved;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          setState(() {
            isProblemSolved = isSolved;
          });
          // Add haptic feedback for better user experience
          HapticFeedback.lightImpact();
        }
      },
      child: Container(
        color: TossColors.transparent,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 200),
            style: TossTextStyles.bodySmall.copyWith(
              color: isSelected ? TossColors.white : TossColors.gray700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  // Build stat card widget
}
