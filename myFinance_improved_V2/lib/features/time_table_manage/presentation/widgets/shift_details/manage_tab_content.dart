import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/usecases/delete_shift_tag.dart';
import '../../../domain/usecases/input_card.dart';
import '../../../domain/usecases/process_bulk_approval.dart';
import '../../../domain/value_objects/shift_time_formatter.dart';
import '../../../domain/value_objects/tag_input.dart';
import '../../providers/usecase/time_table_usecase_providers.dart';
import 'confirmed_times_editor.dart';
import 'problem_status_section.dart';
import 'sections/tag_section.dart';
import 'sections/action_button.dart';
import 'dialogs/shift_details_dialogs.dart';

/// Manage tab content for ShiftDetailsBottomSheet
class ManageTabContent extends ConsumerStatefulWidget {
  final ShiftCard card;

  const ManageTabContent({
    super.key,
    required this.card,
  });

  @override
  ConsumerState<ManageTabContent> createState() => _ManageTabContentState();
}

class _ManageTabContentState extends ConsumerState<ManageTabContent> {
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
    'Reset',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with confirmed times
    final requestDate = widget.card.shiftDate;
    editedStartTime = ShiftTimeFormatter.formatTime(
        widget.card.confirmedStartTime?.toIso8601String(), requestDate);
    editedEndTime = ShiftTimeFormatter.formatTime(
        widget.card.confirmedEndTime?.toIso8601String(), requestDate);

    originalStartTime = editedStartTime;
    originalEndTime = editedEndTime;

    selectedTagType = null;
    tagContent = null;

    // Initialize problem solved state
    final isProblem = widget.card.hasProblem;
    final wasSolved = widget.card.isProblemSolved;

    if (!isProblem) {
      isProblemSolved = true;
    } else if (isProblem && wasSolved) {
      isProblemSolved = true;
    } else {
      isProblemSolved = false;
    }
    originalProblemSolved = isProblemSolved;
  }

  bool hasChanges() {
    final timeChanged =
        editedStartTime != originalStartTime || editedEndTime != originalEndTime;
    final problemChanged = isProblemSolved != originalProblemSolved;
    final tagAdded =
        (selectedTagType != null && tagContent != null && tagContent!.isNotEmpty);
    return timeChanged || problemChanged || tagAdded;
  }

  Future<void> _handleDeleteTag(String tagId, String content) async {
    final result = await showDeleteTagDialog(context, content: content);
    if (result == true && mounted) {
      await _deleteTag(tagId);
    }
  }

  Future<void> _handleNotApprove() async {
    final result = await showNotApproveDialog(context);
    if (result == true && mounted) {
      await _toggleApprovalStatus(widget.card.shiftRequestId);
    }
  }

  Future<void> _toggleApprovalStatus(String shiftRequestId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const Center(child: TossLoadingView());
        },
      );

      final appState = ref.read(appStateProvider);
      final userId = appState.user['user_id'] as String? ?? '';

      if (userId.isEmpty || shiftRequestId.isEmpty) {
        throw Exception('Missing user ID or shift request ID');
      }

      final isCurrentlyApproved = widget.card.isApproved;
      final newState = !isCurrentlyApproved;

      await ref.read(processBulkApprovalUseCaseProvider).call(
            ProcessBulkApprovalParams(
              shiftRequestIds: [shiftRequestId],
              approvalStates: [newState],
            ),
          );

      if (mounted) {
        context.pop();
      }

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
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        context.pop();
      }
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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: TossLoadingView());
        },
      );

      final appState = ref.read(appStateProvider);
      final userId = appState.user['user_id'] as String? ?? '';

      if (userId.isEmpty) {
        throw Exception('User ID not found');
      }

      final response = await ref.read(deleteShiftTagUseCaseProvider).call(
            DeleteShiftTagParams(
              tagId: tagId,
              userId: userId,
            ),
          );

      if (mounted) {
        context.pop();
      }

      if (response.isSuccess) {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
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
      if (mounted) {
        context.pop();
      }
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

  Future<void> _handleSave() async {
    final tagInput = TagInput(
      tagType: selectedTagType,
      content: tagContent,
    );

    if (!tagInput.isValid) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Error',
          message: tagInput.validationError ?? 'Invalid tag input',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    final shouldSave = await showConfirmSaveDialog(context);
    if (shouldSave != true) {
      return;
    }

    final appState = ref.read(appStateProvider);
    final userId = appState.user['user_id'] as String? ?? '';
    final timezone = DateTimeUtils.getLocalTimezone();
    final shiftRequestId = widget.card.shiftRequestId;
    final isLate = widget.card.isLate;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const Center(child: TossLoadingView());
      },
    );

    try {
      String? startTimeHHmm =
          ShiftTimeFormatter.validateAndFormatTime(editedStartTime);
      String? endTimeHHmm =
          ShiftTimeFormatter.validateAndFormatTime(editedEndTime);

      final startTimeForDb =
          (startTimeHHmm != null && startTimeHHmm.isNotEmpty)
              ? startTimeHHmm
              : null;
      final endTimeForDb =
          (endTimeHHmm != null && endTimeHHmm.isNotEmpty) ? endTimeHHmm : null;

      final processedTagContent = tagInput.trimmedContent;
      final processedTagType = tagInput.trimmedType;

      if (shiftRequestId.isEmpty) {
        throw Exception('Invalid shift request ID');
      }

      await ref.read(inputCardUseCaseProvider).call(
            InputCardParams(
              managerId: userId,
              shiftRequestId: shiftRequestId,
              confirmStartTime: startTimeForDb,
              confirmEndTime: endTimeForDb,
              newTagContent: processedTagContent,
              newTagType: processedTagType,
              isLate: isLate,
              isProblemSolved: isProblemSolved,
              timezone: timezone,
            ),
          );

      Navigator.pop(context);

      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.success(
          title: 'Success',
          message: 'Successfully saved',
          primaryButtonText: 'OK',
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      Navigator.pop(context);

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
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;

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
                AddTagSection(
                  selectedTagType: selectedTagType,
                  tagTypes: tagTypes,
                  onTagTypeChanged: (value) {
                    setState(() {
                      selectedTagType = value;
                    });
                  },
                  onTagContentChanged: (value) {
                    setState(() {
                      tagContent = value.isEmpty ? null : value;
                    });
                  },
                ),

                const SizedBox(height: TossSpacing.space4),

                // Existing Tags Section
                ExistingTagsSection(
                  tags: card.tags,
                  onDeleteTag: _handleDeleteTag,
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
                // Not Approve button
                ShiftDetailsActionButton(
                  label: 'Not Approve',
                  color: TossColors.warning,
                  icon: Icons.remove_circle_outline,
                  onTap: card.isApproved ? _handleNotApprove : null,
                  outlined: true,
                  disabled: !card.isApproved,
                ),
                const SizedBox(height: TossSpacing.space3),
                // Save button
                ShiftDetailsActionButton(
                  label: 'Save',
                  color: TossColors.primary,
                  icon: Icons.save_outlined,
                  onTap: hasChanges() ? _handleSave : null,
                  disabled: !hasChanges(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
