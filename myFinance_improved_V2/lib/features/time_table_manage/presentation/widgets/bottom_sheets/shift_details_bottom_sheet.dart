// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation, argument_type_not_assignable, invalid_assignment, non_bool_condition, non_bool_negation_expression, non_bool_operand, use_of_void_result
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../domain/value_objects/shift_time_formatter.dart';
import '../../providers/time_table_providers.dart';
import '../shift_details/bonus_management_tab.dart';
import '../shift_details/confirmed_times_editor.dart';
import '../shift_details/problem_status_section.dart';
import '../shift_details/shift_details_tab_bar.dart';
import '../shift_details/shift_info_tab.dart';

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
  String editedStartTime = '--:--';
  String editedEndTime = '--:--';
  String? selectedTagType;
  String? tagContent;
  late bool isProblemSolved;
  
  // Original values to track changes
  String originalStartTime = '--:--';
  String originalEndTime = '--:--';
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
    // Initialize with confirmed times - convert UTC to local time for display
    final requestDate = widget.card['request_date'] as String?;
    editedStartTime = ShiftTimeFormatter.formatTime(widget.card['confirm_start_time'], requestDate);
    editedEndTime = ShiftTimeFormatter.formatTime(widget.card['confirm_end_time'], requestDate);
    // Store original values
    originalStartTime = editedStartTime;
    originalEndTime = editedEndTime;
    
    // Tag values start as null
    selectedTagType = null;
    tagContent = null;

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
    super.dispose();
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
        context.pop();
      }
      
      // Show success message
      if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.success(
            title: 'Success',
            message: 'Shift request changed to pending successfully',
            primaryButtonText: 'OK',
          ),
        );

        // Close the bottom sheet and return true to trigger refresh in parent
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        context.pop();
      }
      
      // Show error message
      if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: e.toString(),
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }
  
  Future<void> _deleteTag(String tagId) async {
    // Validate tag ID
    if (tagId.isEmpty) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Error',
          message: 'Invalid tag ID',
          primaryButtonText: 'OK',
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
        context.pop();
      }
      
      // Check response
      if (response.isSuccess) {
        // Success - tag deleted
        if (mounted) {
          // Trigger parent refresh by returning true
          Navigator.of(context).pop(true);
        }
      } else {
        // Handle error response
        final errorMessage = response.message ?? 'Failed to delete tag';

        if (mounted) {
          await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => TossDialog.error(
              title: 'Error',
              message: errorMessage,
              primaryButtonText: 'OK',
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        context.pop();
      }
      
      // Show error message
      if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'Failed to delete tag: ${e.toString()}',
            primaryButtonText: 'OK',
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
          // Tab Bar
          ShiftDetailsTabBar(controller: _tabController),
          const SizedBox(height: TossSpacing.space3),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Info Tab
                ShiftInfoTab(card: card, hasUnsolvedProblem: hasUnsolvedProblem),
                // Manage Tab
                _buildManageTab(card),
                // Bonus Tab
                BonusManagementTab(card: card),
              ],
            ),
          ),
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
                ConfirmedTimesEditor(
                  editedStartTime: editedStartTime,
                  editedEndTime: editedEndTime,
                  onStartTimeChanged: (timeStr) {
                    setState(() {
                      editedStartTime = timeStr;
                    });
                  },
                  onEndTimeChanged: (timeStr) {
                    setState(() {
                      editedEndTime = timeStr;
                    });
                  },
                ),
                const SizedBox(height: TossSpacing.space4),
                
                // Problem Status Section
                ProblemStatusSection(
                  isProblemSolved: isProblemSolved,
                  onStatusChanged: (isSolved) {
                    setState(() {
                      isProblemSolved = isSolved;
                    });
                  },
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
                      await showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => TossDialog.error(
                          title: 'Error',
                          message: 'Please fill both tag type and content or leave both empty',
                          primaryButtonText: 'OK',
                        ),
                      );
                      return;
                    }
                    
                    // Additional validation for tag content length
                    if (hasTagContent && tagContent!.trim().length > 500) {
                      await showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => TossDialog.error(
                          title: 'Error',
                          message: 'Tag content cannot exceed 500 characters',
                          primaryButtonText: 'OK',
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
                      
                      // Format times - use edited times if available, otherwise use existing confirm times
                      String? startTimeHHmm = formatTimeToHHmm(editedStartTime);
                      String? endTimeHHmm = formatTimeToHHmm(editedEndTime);

                      // If times weren't edited, try to use existing confirm times from card
                      if (startTimeHHmm == null || startTimeHHmm.isEmpty) {
                        final existingStart = widget.card['confirm_start_time'] as String?;
                        startTimeHHmm = formatTimeToHHmm(existingStart);
                      }
                      if (endTimeHHmm == null || endTimeHHmm.isEmpty) {
                        final existingEnd = widget.card['confirm_end_time'] as String?;
                        endTimeHHmm = formatTimeToHHmm(existingEnd);
                      }

                      // Convert times to UTC - both times are required for inputCard
                      String startTimeForDb;
                      String endTimeForDb;

                      if (startTimeHHmm == null || startTimeHHmm.isEmpty ||
                          endTimeHHmm == null || endTimeHHmm.isEmpty) {
                        throw Exception('Both start and end times are required');
                      }

                      // Get request date for full DateTime conversion
                      final requestDate = widget.card['request_date'] as String?;
                      if (requestDate == null || requestDate.isEmpty) {
                        throw Exception('Request date is required for time conversion');
                      }

                      // Convert local time to UTC time
                      // Manager inputs local time (e.g., 13:00), we need to convert to UTC (e.g., 06:00)
                      final startDateTime = DateTime.parse('$requestDate $startTimeHHmm:00');
                      final endDateTime = DateTime.parse('$requestDate $endTimeHHmm:00');

                      // Convert to UTC and extract time only (HH:mm:ss)
                      final startUtc = startDateTime.toUtc();
                      final endUtc = endDateTime.toUtc();

                      startTimeForDb = '${startUtc.hour.toString().padLeft(2, '0')}:${startUtc.minute.toString().padLeft(2, '0')}:${startUtc.second.toString().padLeft(2, '0')}';
                      endTimeForDb = '${endUtc.hour.toString().padLeft(2, '0')}:${endUtc.minute.toString().padLeft(2, '0')}:${endUtc.second.toString().padLeft(2, '0')}';

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
                      final cardInputResult = await ref.read(timeTableRepositoryProvider).inputCard(
                        managerId: userId,
                        shiftRequestId: shiftRequestId,
                        confirmStartTime: startTimeForDb,
                        confirmEndTime: endTimeForDb,
                        newTagContent: processedTagContent,
                        newTagType: processedTagType,
                        isLate: isLate,
                        isProblemSolved: isProblemSolved,
                      );

                      // Close loading dialog
                      Navigator.pop(context);

                      // Show success message
                      await showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => TossDialog.success(
                          title: 'Success',
                          message: 'Successfully saved',
                          primaryButtonText: 'OK',
                        ),
                      );

                      // Close bottom sheet and trigger refresh
                      Navigator.pop(context, true); // Return true to indicate data changed
                      
                    } catch (e) {
                      // Close loading dialog
                      Navigator.pop(context);

                      // Show error message
                      await showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => TossDialog.error(
                          title: 'Error',
                          message: 'Failed to save: ${e.toString()}',
                          primaryButtonText: 'OK',
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
  // Build Bonus tab content
}
