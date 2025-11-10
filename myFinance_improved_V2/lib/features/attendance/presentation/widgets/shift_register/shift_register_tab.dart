import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../app/providers/auth_providers.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../domain/entities/monthly_shift_status.dart';
import '../../../domain/entities/shift_data.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../providers/attendance_providers.dart';
import '../../utils/date_format_utils.dart';
import 'date_header_card.dart';
import 'shift_calendar.dart';

class ShiftRegisterTab extends ConsumerStatefulWidget {
  const ShiftRegisterTab({super.key});

  @override
  ConsumerState<ShiftRegisterTab> createState() => _ShiftRegisterTabState();
}

class _ShiftRegisterTabState extends ConsumerState<ShiftRegisterTab>
    with AutomaticKeepAliveClientMixin {
  DateTime selectedDate = DateTime.now();
  DateTime focusedMonth = DateTime.now();
  String? selectedStoreId;
  List<ShiftMetadata>? shiftMetadata; // Store shift metadata (strongly typed)
  bool isLoadingMetadata = false;
  List<MonthlyShiftStatus>? monthlyShiftStatus; // Store monthly shift status (strongly typed)
  bool isLoadingShiftStatus = false;

  // ScrollController for auto-scroll functionality
  final ScrollController _scrollController = ScrollController();
  bool _isAutoScrolling = false; // Prevent conflicting scroll animations

  // Selection state for shift cards
  String? selectedShift; // Store single selected shift ID
  String? selectionMode; // 'registered' or 'unregistered' - determined by selection

  // Keep state alive when switching tabs
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  // Fetch shift metadata from Supabase RPC
  Future<void> fetchShiftMetadata(String storeId) async {
    print('🔍 [ShiftRegister] fetchShiftMetadata 시작 - storeId: $storeId');

    if (storeId.isEmpty) {
      print('❌ [ShiftRegister] storeId가 비어있음');
      return;
    }

    if (mounted) {
      setState(() {
        isLoadingMetadata = true;
      });
    }

    try {
      // Use get shift metadata use case
      final getShiftMetadata = ref.read(getShiftMetadataProvider);
      print('📡 [ShiftRegister] getShiftMetadata 호출 중...');

      final response = await getShiftMetadata(
        storeId: storeId,
      );

      print('✅ [ShiftRegister] shiftMetadata 응답 받음 - 개수: ${response.length}');
      if (response.isNotEmpty) {
        print('📋 [ShiftRegister] 첫 번째 shift: ${response.first}');
      } else {
        print('⚠️ [ShiftRegister] shiftMetadata가 비어있음 (store에 shift가 설정되지 않았을 수 있음)');
      }

      if (mounted) {
        setState(() {
          // Store the raw response directly - it should be a List of shift objects
          shiftMetadata = response;
          isLoadingMetadata = false;
        });
      }

    } catch (e, stackTrace) {
      print('❌ [ShiftRegister] fetchShiftMetadata 에러: $e');
      print('📚 [ShiftRegister] 스택 트레이스: $stackTrace');

      if (mounted) {
        setState(() {
          isLoadingMetadata = false;
          shiftMetadata = [];
        });
      }
    }
  }
  
  // Fetch monthly shift status from Supabase RPC (Shows all employees' registrations)
  Future<void> fetchMonthlyShiftStatus() async {
    print('🔍 [ShiftRegister] fetchMonthlyShiftStatus 시작');
    print('   - selectedStoreId: $selectedStoreId');
    print('   - focusedMonth: ${focusedMonth.year}-${focusedMonth.month}');

    if (selectedStoreId == null || selectedStoreId!.isEmpty) {
      print('❌ [ShiftRegister] selectedStoreId가 없음');
      return;
    }

    setState(() {
      isLoadingShiftStatus = true;
    });

    try {
      // Format date as YYYY-MM-DD for the first day of the focused month
      final requestDate = '${focusedMonth.year}-${focusedMonth.month.toString().padLeft(2, '0')}-01';

      // Use get monthly shift status use case
      final getMonthlyShiftStatus = ref.read(getMonthlyShiftStatusProvider);
      final appState = ref.read(appStateProvider);
      final authStateAsync = ref.read(authStateProvider);
      final user = authStateAsync.value;
      final userId = user?.id;

      if (userId == null) {
        print('❌ [ShiftRegister] userId가 없습니다');
        setState(() {
          isLoadingShiftStatus = false;
        });
        return;
      }

      print('📡 [ShiftRegister] getMonthlyShiftStatus 호출 중...');
      print('   - storeId: $selectedStoreId');
      print('   - userId: $userId');
      print('   - requestDate: $requestDate');

      final response = await getMonthlyShiftStatus(
        storeId: selectedStoreId!,
        userId: userId,
        requestDate: requestDate,
      );

      print('✅ [ShiftRegister] monthlyShiftStatus 응답 받음 - 개수: ${response.length}');
      if (response.isNotEmpty) {
        print('📋 [ShiftRegister] 첫 번째 status: ${response.first}');
        print('👥 [ShiftRegister] otherStaffs 개수: ${response.first.otherStaffs.length}');
        if (response.first.otherStaffs.isNotEmpty) {
          print('👤 [ShiftRegister] 첫 번째 otherStaff: ${response.first.otherStaffs.first}');
        }
      } else {
        print('⚠️ [ShiftRegister] monthlyShiftStatus가 비어있음 (아직 신청된 shift가 없을 수 있음)');
      }

      setState(() {
        monthlyShiftStatus = response;
        isLoadingShiftStatus = false;
      });

    } catch (e, stackTrace) {
      print('❌ [ShiftRegister] fetchMonthlyShiftStatus 에러: $e');
      print('📚 [ShiftRegister] 스택 트레이스: $stackTrace');

      setState(() {
        isLoadingShiftStatus = false;
        monthlyShiftStatus = [];
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    print('🚀 [ShiftRegister] initState 시작');

    // Initialize selectedStoreId from app state
    final appState = ref.read(appStateProvider);
    selectedStoreId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;

    print('🏪 [ShiftRegister] App State 확인:');
    print('   - storeChoosen: ${appState.storeChoosen}');
    print('   - companyChoosen: ${appState.companyChoosen}');
    print('   - selectedStoreId: $selectedStoreId');

    // Fetch shift metadata and monthly status for the default store
    if (selectedStoreId != null) {
      print('✅ [ShiftRegister] selectedStoreId 있음 - 데이터 fetch 시작');
      fetchShiftMetadata(selectedStoreId!);
      fetchMonthlyShiftStatus();
    } else {
      print('❌ [ShiftRegister] selectedStoreId가 null - store가 선택되지 않음');
    }
  }
  
  // Handle shift card click
  void _handleShiftClick(String shiftId, bool isRegistered) {
    setState(() {
      // If clicking the same shift, deselect it
      if (selectedShift == shiftId) {
        selectedShift = null;
        selectionMode = null;
      } else {
        // Select the new shift and set the mode
        selectedShift = shiftId;
        selectionMode = isRegistered ? 'registered' : 'unregistered';
        
        // Auto-scroll to bottom with enhanced smoothness
        _performSmoothScroll();
      }
    });
    
    // Haptic feedback
    HapticFeedback.selectionClick();
  }
  
  // Enhanced smooth scroll function with dynamic duration and progressive scrolling
  void _performSmoothScroll() {
    // Prevent multiple simultaneous scroll animations
    if (_isAutoScrolling) return;
    
    // Small delay to ensure button is rendered and for better UX flow
    Future.delayed(const Duration(milliseconds: 200), () async {
      if (!_scrollController.hasClients || !mounted) return;
      
      final currentPosition = _scrollController.position.pixels;
      // Calculate the proper target position without overscroll
      // maxScrollExtent already represents the maximum scrollable position
      // We'll clamp it to ensure we don't go beyond content bounds
      final maxScroll = _scrollController.position.maxScrollExtent;
      // Ensure target position doesn't exceed actual content bounds
      final targetPosition = maxScroll.clamp(0.0, maxScroll);
      final scrollDistance = (targetPosition - currentPosition).abs();
      
      // Skip if already at bottom or very close
      if (scrollDistance < 50) return;
      
      _isAutoScrolling = true;
      
      try {
        // Calculate dynamic duration based on distance
        // Base duration: 700ms for smoothness, scales up to 1400ms for long distances
        final baseDuration = 700;
        final maxDuration = 1400;
        final viewportHeight = _scrollController.position.viewportDimension;
        final scrollRatio = (scrollDistance / viewportHeight).clamp(0.0, 3.0);
        
        // Use a smoother duration curve (logarithmic scaling for better feel)
        final duration = (baseDuration + (maxDuration - baseDuration) * (scrollRatio / 3) * 0.8).round();
        
        // For very long distances (>2.5x viewport), use progressive multi-stage scrolling
        if (scrollDistance > viewportHeight * 2.5) {
          // Stage 1: Accelerate to 60% of distance
          final stage1Position = (currentPosition + (scrollDistance * 0.6)).clamp(0.0, maxScroll);
          await _scrollController.animateTo(
            stage1Position,
            duration: Duration(milliseconds: (duration * 0.45).round()),
            curve: Curves.easeInQuad, // Start slow, accelerate
          );
          
          // Stage 2: Continue to 90% with steady speed
          final stage2Position = (currentPosition + (scrollDistance * 0.9)).clamp(0.0, maxScroll);
          await _scrollController.animateTo(
            stage2Position,
            duration: Duration(milliseconds: (duration * 0.35).round()),
            curve: Curves.linear, // Constant speed
          );
          
          // Stage 3: Decelerate smoothly to final position
          await _scrollController.animateTo(
            targetPosition,
            duration: Duration(milliseconds: (duration * 0.3).round()),
            curve: Curves.easeOutQuad, // Smooth deceleration
          );
        } else if (scrollDistance > viewportHeight) {
          // For medium distances, use two-stage scrolling
          final intermediatePosition = (currentPosition + (scrollDistance * 0.75)).clamp(0.0, maxScroll);
          
          // First stage: smooth acceleration
          await _scrollController.animateTo(
            intermediatePosition,
            duration: Duration(milliseconds: (duration * 0.6).round()),
            curve: Curves.easeIn,
          );
          
          // Second stage: smooth deceleration
          await _scrollController.animateTo(
            targetPosition,
            duration: Duration(milliseconds: (duration * 0.4).round()),
            curve: Curves.easeOut,
          );
        } else {
          // For short distances, use single ultra-smooth animation
          await _scrollController.animateTo(
            targetPosition,
            duration: Duration(milliseconds: duration),
            curve: Curves.decelerate, // Ultra-smooth deceleration curve for natural feel
          );
        }
        
        // Add subtle haptic feedback when scroll completes (only for longer scrolls)
        if (scrollDistance > viewportHeight * 1.5) {
          HapticFeedback.lightImpact();
        }
      } finally {
        _isAutoScrolling = false;
      }
    });
  }
  
  // Reset selections when date changes
  void _resetSelections() {
    setState(() {
      selectedShift = null;
      selectionMode = null;
    });
  }

  // Show store selector with Toss-style bottom sheet
  void _showStoreSelector(List<dynamic> stores) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Row(
                children: [
                  Text(
                    'Select Store',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // Store list
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  final isSelected = store['store_id'] == selectedStoreId;
                  
                  return InkWell(
                    onTap: () async {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                      
                      setState(() {
                        selectedStoreId = store['store_id']?.toString();
                        _resetSelections();
                      });
                      
                      // Update app state with the new store selection
                      ref.read(appStateProvider.notifier).selectStore(
                        store['store_id']?.toString() ?? '',
                        storeName: store['store_name']?.toString(),
                      );
                      // Fetch shift metadata and monthly status for the new store
                      await fetchShiftMetadata(store['store_id']?.toString() ?? '');
                      await fetchMonthlyShiftStatus();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space5,
                        vertical: TossSpacing.space4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? TossColors.gray50 : TossColors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: TossColors.gray100,
                            width: index == stores.length - 1 ? 0 : 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected ? TossColors.primary.withOpacity(0.1) : TossColors.gray100,
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            child: Icon(
                              Icons.store_outlined,
                              size: 20,
                              color: isSelected ? TossColors.primary : TossColors.gray600,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Text(
                              store['store_name']?.toString() ?? 'Unknown Store',
                              style: TossTextStyles.body.copyWith(
                                color: isSelected ? TossColors.primary : TossColors.gray900,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              size: 20,
                              color: TossColors.primary,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }
  
  // Handle cancel shifts
  // TODO: Refactor - MonthlyShiftStatus entity doesn't match nested structure expected
  Future<void> _handleCancelShifts() async {
    // FIXME: This method assumes monthlyShiftStatus contains nested Map structures
    // but monthlyShiftStatus is List<MonthlyShiftStatus> which is a flat entity
    // Need to redesign the data model or use different entity
    return; // Temporarily disabled

    /* if (selectedShift == null) {
      return;
    }

    // Get the selected shift details
    final allStoreShifts = _getAllStoreShifts();
    Map<String, dynamic>? selectedShiftDetail;

    // Get user's shift data for the selected date
    final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    // monthlyShiftStatus contains days with nested shifts and employee arrays
    // We need to find the day data first, then look for the user in the shift's employee arrays
    final dayData = monthlyShiftStatus?.firstWhere(
      (day) => day['request_date'] == dateStr,
      orElse: () => <String, dynamic>{},
    );

    if (dayData != null && dayData.isNotEmpty) {
    } else {
    }

    // Extract user's shift information from the nested structure
    final authStateAsync = ref.read(authStateProvider);
    final user = authStateAsync.value;
    Map<String, dynamic>? userShiftData;

    if (dayData != null && dayData.isNotEmpty && user != null) {
      final shifts = dayData['shifts'] as List? ?? [];
      
      // Look ONLY for the SELECTED shift, not all shifts
      for (final shift in shifts) {
        final shiftId = shift['shift_id']?.toString() ?? '';
        
        // IMPORTANT: Only check the shift that matches the selected shift
        if (shiftId != selectedShift) {
          continue;
        }
        
        
        // Check pending employees for THIS specific shift
        final pendingEmployees = shift['pending_employees'] as List? ?? [];
        for (final emp in pendingEmployees) {
          if (emp['user_id'] == user.id) {
            userShiftData = {
              'shift_id': shiftId,
              'shift_request_id': emp['shift_request_id'],
              'is_approved': false,
              'shift_type': shift['shift_name'] ?? shift['shift_type'],
            };
            break;
          }
        }
        
        // Check approved employees if not found in pending
        if (userShiftData == null) {
          final approvedEmployees = shift['approved_employees'] as List? ?? [];
          for (final emp in approvedEmployees) {
            if (emp['user_id'] == user.id) {
              userShiftData = {
                'shift_id': shiftId,
                'shift_request_id': emp['shift_request_id'],
                'is_approved': true,
                'shift_type': shift['shift_name'] ?? shift['shift_type'],
              };
              break;
            }
          }
        }
        
        // We found (or didn't find) the user in the selected shift, so we're done
        break;
      }
    }
    
    
    // Find the selected shift details from store shifts
    for (final shift in allStoreShifts) {
      final shiftId = shift['shift_id'] ?? shift['id'] ?? shift['store_shift_id'];
      
      if (shiftId?.toString() == selectedShift) {
        
        // If we found user data for this shift, use it
        if (userShiftData != null) {
          selectedShiftDetail = {
            ...shift,
            'shift_request_id': userShiftData['shift_request_id'],
            'is_approved': userShiftData['is_approved'] ?? false,
          };
        } else {
        }
        break;
      }
    }
    
    if (selectedShiftDetail == null) {
      
      // Show alert if user hasn't registered for this shift
      if (userShiftData == null) {
        _showNotRegisteredAlert();
      }
      return;
    }
    
    
    // Check if the shift is approved
    if (selectedShiftDetail['is_approved'] == true) {
      _showApprovedShiftAlert();
    } else {
      _showCancelConfirmationDialog([selectedShiftDetail]);
    } */
  }
  
  // Handle register shift
  Future<void> _handleRegisterShift() async {
    if (selectedShift == null) return;

    // Store parent context before showing dialog
    final scaffoldContext = context;

    // Get the selected shift details
    final allStoreShifts = _getAllStoreShifts();
    Map<String, dynamic>? selectedShiftDetail;

    // Find the selected shift details
    for (final shift in allStoreShifts) {
      final shiftId = shift['shift_id'] ?? shift['id'] ?? shift['store_shift_id'];
      if (shiftId?.toString() == selectedShift) {
        selectedShiftDetail = shift;
        break;
      }
    }

    if (selectedShiftDetail == null) return;

    // Extract shift information
    final shiftName = selectedShiftDetail['shift_name'] ??
                     selectedShiftDetail['name'] ??
                     selectedShiftDetail['shift_type'] ??
                     'Shift';
    final startTime = selectedShiftDetail['start_time'] ??
                     selectedShiftDetail['shift_start_time'] ??
                     selectedShiftDetail['default_start_time'] ??
                     '--:--';
    final endTime = selectedShiftDetail['end_time'] ??
                   selectedShiftDetail['shift_end_time'] ??
                   selectedShiftDetail['default_end_time'] ??
                   '--:--';

    // Format the date
    final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final displayDate = '${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}';

    // Show confirmation dialog
    showDialog(
      context: scaffoldContext,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and Title Section
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.event_available,
                          color: TossColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Register Shift',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'Do you want to register:',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space3),
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        child: Column(
                          children: [
                            Text(
                              displayDate,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            Text(
                              shiftName?.toString() ?? '',
                              style: TossTextStyles.h4.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            Text(
                              '$startTime - $endTime',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Button Section
                Container(
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                          ),
                          child: Text(
                            'Cancel',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 48,
                        color: TossColors.gray200,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();

                            // Get user ID
                            final authStateAsync = ref.read(authStateProvider);
                            final user = authStateAsync.value;
                            if (user == null) return;
                            
                            
                            try {
                              // Use register shift request use case
                              final registerShiftRequest = ref.read(registerShiftRequestProvider);
                              await registerShiftRequest(
                                userId: user.id,
                                shiftId: selectedShift!,
                                storeId: selectedStoreId!,
                                requestDate: dateStr,
                              );
                              
                              
                              // Optimistic UI update: immediately update local state
                              // This prevents the race condition where fetch happens before DB commit
                              
                              // Get user data from app state for more accurate information
                              final appState = ref.read(appStateProvider);

                              _resetSelections();

                              // Show success message
                              if (mounted) {
                                showDialog(
                                  context: scaffoldContext,
                                  barrierDismissible: true,
                                  builder: (BuildContext successContext) {
                                    return Dialog(
                                      backgroundColor: TossColors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: TossColors.white,
                                          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                                          boxShadow: [
                                            BoxShadow(
                                              color: TossColors.black.withOpacity(0.1),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(TossSpacing.space5),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 56,
                                                    height: 56,
                                                    decoration: BoxDecoration(
                                                      color: TossColors.success.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.check_circle,
                                                      color: TossColors.success,
                                                      size: 28,
                                                    ),
                                                  ),
                                                  const SizedBox(height: TossSpacing.space4),
                                                  Text(
                                                    'Success',
                                                    style: TossTextStyles.h3.copyWith(
                                                      color: TossColors.gray900,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  const SizedBox(height: TossSpacing.space3),
                                                  Text(
                                                    'Shift registered successfully',
                                                    style: TossTextStyles.body.copyWith(
                                                      color: TossColors.gray600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: TossColors.gray50,
                                                borderRadius: const BorderRadius.only(
                                                  bottomLeft: Radius.circular(20),
                                                  bottomRight: Radius.circular(20),
                                                ),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(successContext).pop();
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                                                  minimumSize: const Size(double.infinity, 0),
                                                ),
                                                child: Text(
                                                  'OK',
                                                  style: TossTextStyles.body.copyWith(
                                                    color: TossColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                await showDialog<bool>(
                                  context: scaffoldContext,
                                  barrierDismissible: true,
                                  builder: (errorContext) => TossDialog.error(
                                    title: 'Registration Failed',
                                    message: 'Failed to register shift: ${e.toString()}',
                                    primaryButtonText: 'OK',
                                  ),
                                );
                              }
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                          ),
                          child: Text(
                            'OK',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Show alert for mixed shifts (approved and pending)
  void _showMixedShiftAlert(List<Map<String, dynamic>> approvedShifts, List<Map<String, dynamic>> pendingShifts) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and Title Section
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TossColors.warning.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: TossColors.warning,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Mixed Shift Status',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: '${approvedShifts.length} shift${approvedShifts.length > 1 ? 's' : ''}',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.success,
                              ),
                            ),
                            const TextSpan(text: ' are approved and cannot be cancelled.\n'),
                            const TextSpan(text: 'Only '),
                            TextSpan(
                              text: '${pendingShifts.length} pending shift${pendingShifts.length > 1 ? 's' : ''}',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.warning,
                              ),
                            ),
                            const TextSpan(text: ' can be cancelled.\n\nDo you want to cancel the pending shifts?'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Divider
                Container(
                  height: 1,
                  color: TossColors.gray100,
                ),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.pop();
                        },
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space4,
                          ),
                          child: Center(
                            child: Text(
                              'No',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: TossColors.gray100,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.pop();
                          _showCancelConfirmationDialog(pendingShifts);
                        },
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space4,
                          ),
                          child: Center(
                            child: Text(
                              'Cancel Pending',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Show alert for shifts not registered by user
  void _showNotRegisteredAlert() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and Title Section
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TossColors.warning.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: TossColors.warning,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Not Registered',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'You have not registered for this shift.\nYou can only cancel shifts you have registered for.',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // OK Button
                InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.pop();
                  },
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: TossSpacing.space4,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: TossColors.gray200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'OK',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Show alert for approved shifts
  void _showApprovedShiftAlert() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and Title Section
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TossColors.warning.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: TossColors.warning,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Cannot Cancel Approved Shift',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'This shift has already been approved.\nPlease ask your manager to cancel it.',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Divider
                Container(
                  height: 1,
                  color: TossColors.gray100,
                ),
                
                // Button
                InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.pop();
                  },
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: TossSpacing.space4,
                    ),
                    child: Center(
                      child: Text(
                        'OK',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Show confirmation dialog for canceling shifts
  void _showCancelConfirmationDialog(List<Map<String, dynamic>> shiftsToCancel) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: TossColors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and Title Section
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TossColors.error.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          color: TossColors.error,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Cancel Shift',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'Are you sure you want to cancel ${shiftsToCancel.length} shift${shiftsToCancel.length > 1 ? 's' : ''}?',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Divider
                Container(
                  height: 1,
                  color: TossColors.gray100,
                ),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.pop();
                        },
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space4,
                          ),
                          child: Center(
                            child: Text(
                              'No',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: TossColors.gray100,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          context.pop();
                          await _cancelShifts(shiftsToCancel);
                        },
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space4,
                          ),
                          child: Center(
                            child: Text(
                              'Yes, Cancel',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Cancel shifts in Supabase
  Future<void> _cancelShifts(List<Map<String, dynamic>> shiftsToCancel) async {
    try {
      // Get current user
      final authStateAsync = ref.read(authStateProvider);
      final user = authStateAsync.value;
      if (user == null) {
        return;
      }
      
      
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: true, // Allow dismissing loading dialogs
        builder: (BuildContext context) {
          return const TossLoadingView();
        },
      );
      
      // Cancel each shift
      for (final shift in shiftsToCancel) {
        // Get shift_id and prepare request_date
        final shiftId = shift['shift_id']?.toString() ?? 
                       shift['id']?.toString() ?? 
                       shift['store_shift_id']?.toString() ?? '';
        final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
        
        
        if (shiftId.isNotEmpty) {

          // Delete using the three-column filter approach via use case
          // This uniquely identifies the row without needing shift_request_id
          final deleteShiftRequest = ref.read(deleteShiftRequestProvider);
          await deleteShiftRequest(
            userId: user.id,
            shiftId: shiftId,
            requestDate: dateStr,
          );
        }
      }

      // Close loading indicator
      if (mounted) context.pop();

      // Reset selections first
      _resetSelections();

      // Show success message
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: TossColors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: TossColors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                  boxShadow: [
                    BoxShadow(
                      color: TossColors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon and Title Section
                    Container(
                      padding: const EdgeInsets.all(TossSpacing.space5),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: TossColors.success.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle_outline,
                              color: TossColors.success,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space4),
                          Text(
                            'Success',
                            style: TossTextStyles.h3.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: TossSpacing.space3),
                          Text(
                            'Successfully cancelled ${shiftsToCancel.length} shift${shiftsToCancel.length > 1 ? 's' : ''}.',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    // Divider
                    Container(
                      height: 1,
                      color: TossColors.gray100,
                    ),
                    
                    // Button
                    InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        context.pop();
                      },
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: TossSpacing.space4,
                        ),
                        child: Center(
                          child: Text(
                            'OK',
                            style: TossTextStyles.bodyLarge.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      // Close loading indicator if still showing
      if (mounted) context.pop();
      
      // Show error message
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to cancel shift: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    'OK',
                    style: TossTextStyles.body.copyWith(color: TossColors.primary),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final appState = ref.watch(appStateProvider);

    print('🎨 [ShiftRegister] build() 호출');
    print('   - isLoadingMetadata: $isLoadingMetadata');
    print('   - shiftMetadata: ${shiftMetadata?.length ?? 0}개');
    print('   - isLoadingShiftStatus: $isLoadingShiftStatus');
    print('   - monthlyShiftStatus: ${monthlyShiftStatus?.length ?? 0}개');

    // Get selected company from user's companies based on companyChoosen
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

    final stores = selectedCompany?['stores'] as List<dynamic>? ?? [];
    print('   - stores 개수: ${stores.length}');
    print('   - selectedStoreId: $selectedStoreId');

    // If selectedStoreId is null and stores are available, use the first store
    if (selectedStoreId == null && stores.isNotEmpty) {
      print('⚠️ [ShiftRegister] selectedStoreId가 null - 첫 번째 store 자동 선택');
      selectedStoreId = stores.first['store_id']?.toString();
      print('   - 자동 선택된 storeId: $selectedStoreId');

      // Fetch metadata and monthly status for the auto-selected store
      if (shiftMetadata == null && !isLoadingMetadata) {
        print('✅ [ShiftRegister] shiftMetadata가 없음 - fetch 시작');
        fetchShiftMetadata(selectedStoreId!);
        fetchMonthlyShiftStatus();
      }
    }
    
    return Stack(
      children: [
        Column(
          children: [
            // Store Selector - Toss Style
            if (stores.isNotEmpty)
              Container(
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
                              (store) => store['store_id'] == selectedStoreId,
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
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: TossColors.gray400,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
        // Calendar Header - Toss Style
        Container(
          margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  setState(() {
                    focusedMonth = DateTime(
                      focusedMonth.year,
                      focusedMonth.month - 1,
                    );
                    _resetSelections();
                  });
                  await fetchMonthlyShiftStatus();
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
                '${_getMonthName(focusedMonth.month)} ${focusedMonth.year}',
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: TossSpacing.space4),
              InkWell(
                onTap: () async {
                  setState(() {
                    focusedMonth = DateTime(
                      focusedMonth.year,
                      focusedMonth.month + 1,
                    );
                    _resetSelections();
                  });
                  await fetchMonthlyShiftStatus();
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
        ),
        
            // Main content with scroll
            Expanded(
              child: ListView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.only(bottom: 100), // Padding for floating button
                children: [
                  // Calendar - Toss Style
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    child: ShiftCalendar(
                      focusedMonth: focusedMonth,
                      selectedDate: selectedDate,
                      currentUserId: (ref.read(appStateProvider).user['user_id'] ?? '') as String,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                          _resetSelections();
                        });
                      },
                      hasShiftOnDate: _hasShiftOnDate,
                      getShiftForDate: _getShiftForDate,
                    ),
                  ),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
                  // Selected Date Shift Details
                  _buildSelectedDateShiftDetails(),
                  
                  // Add bottom padding for comfortable scrolling
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
        
        // Floating Register/Cancel Button - Always visible at bottom
        Positioned(
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
                onTap: selectedShift != null ? () {
                  HapticFeedback.mediumImpact();
                  // Check what action to take based on selection
                  if (selectionMode == 'registered' && selectedShift != null) {
                    _handleCancelShifts();
                  } else if (selectionMode == 'unregistered' && selectedShift != null) {
                    _handleRegisterShift();
                  } else {
                  }
                } : null,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: selectedShift != null
                      ? (selectionMode == 'registered'
                        ? TossColors.gray900
                        : TossColors.primary)
                      : TossColors.gray300,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  ),
                  child: Center(
                    child: Text(
                      selectedShift != null
                        ? (selectionMode == 'registered'
                          ? 'Cancel Shift'
                          : 'Register Shift')
                        : 'Select a Shift',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: selectedShift != null
                          ? TossColors.white
                          : TossColors.gray500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildShiftInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: TossColors.gray500),
        const SizedBox(width: TossSpacing.space1),
        Text(
          '$label:',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  /// Check if user has any registered shift on a specific date
  bool _hasShiftOnDate(DateTime date) {
    if (monthlyShiftStatus == null || monthlyShiftStatus!.isEmpty) return false;

    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return monthlyShiftStatus!.any((shiftStatus) {
      return shiftStatus.requestDate == dateStr && shiftStatus.isRegisteredByMe;
    });
  }

  /// Get shift data for calendar display (not used in user view)
  /// Returns null as user view uses different data structure
  Map<String, dynamic>? _getShiftForDate(DateTime date) {
    // User view doesn't need detailed shift data for calendar
    // Calendar only shows if user has registered shift (via hasShiftOnDate)
    return null;
  }
  
  Widget _buildSelectedDateShiftDetails() {
    // Get ALL shifts from store metadata (not filtered by day)
    final allStoreShifts = _getAllStoreShifts();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header - Toss Style
          DateHeaderCard(
            selectedDate: selectedDate,
            selectedShift: selectedShift,
            getWeekdayFull: _getWeekdayFull,
            getMonthName: _getMonthName,
          ),
          
          const SizedBox(height: TossSpacing.space3),
          
          // Shifts section
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Show all store shifts or loading state
                if (isLoadingMetadata || isLoadingShiftStatus) ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                      child: TossLoadingView(),
                    ),
                  ),
                ] else if (allStoreShifts.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Shifts in This Store',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (selectedShift != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 14,
                                color: TossColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '1 selected',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (selectionMode != null) ...[
                                const SizedBox(width: 4),
                                Text(
                                  '(${selectionMode == 'registered' ? 'Registered' : 'New'})',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.primary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  
                  // Show ALL shifts from the store - Toss Style
                  ...allStoreShifts.map((shift) {
              // Extract shift details
              final shiftId = shift['shift_id'] ?? shift['id'] ?? shift['store_shift_id'];
              final shiftIdStr = shiftId?.toString() ?? '';
              final shiftName = shift['shift_name'] ?? shift['name'] ?? shift['shift_type'] ?? 'Shift ${shiftId ?? ""}';
              final startTime = shift['start_time'] ?? shift['shift_start_time'] ?? shift['default_start_time'] ?? '--:--';
              final endTime = shift['end_time'] ?? shift['shift_end_time'] ?? shift['default_end_time'] ?? '--:--';
              
              // Get employees for this shift from monthlyShiftStatus
              List<Map<String, dynamic>> pendingEmployees = [];
              List<Map<String, dynamic>> approvedEmployees = [];
              
              // Find employees for this shift on the selected date
              final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
              
              if (monthlyShiftStatus != null && monthlyShiftStatus!.isNotEmpty) {
                // MonthlyShiftStatus has flat structure: each row is one shift on one date
                // Find the MonthlyShiftStatus for this date and shift
                final shiftStatusForDate = monthlyShiftStatus!.firstWhere(
                  (status) => status.requestDate == dateStr && status.shiftId == shiftId,
                  orElse: () => monthlyShiftStatus!.first, // Dummy fallback to avoid null
                );

                // Check if we found valid data (not just the fallback)
                if (shiftStatusForDate.requestDate == dateStr && shiftStatusForDate.shiftId == shiftId) {
                  // Get other employees from otherStaffs array
                  final otherStaffs = shiftStatusForDate.otherStaffs;

                  // Separate into approved and pending based on is_approved field
                  for (final employee in otherStaffs) {
                    final isApproved = employee['is_approved'] == true;
                    if (isApproved) {
                      approvedEmployees.add(employee);
                    } else {
                      pendingEmployees.add(employee);
                    }
                  }

                  print('📊 [ShiftRegister] Employees for shift $shiftName on $dateStr:');
                  print('   ✅ Approved: ${approvedEmployees.length}');
                  print('   ⏳ Pending: ${pendingEmployees.length}');
                }
              }
              
              // Check if the current user has registered for this shift
              final authStateAsync = ref.read(authStateProvider);
              final user = authStateAsync.value;
              bool userHasRegistered = false;
              bool userRegistrationIsPending = false; // Track if user's registration is pending

              if (user != null) {
                // Check in pending employees
                for (final emp in pendingEmployees) {
                  if (emp['user_id'] == user.id) {
                    userHasRegistered = true;
                    userRegistrationIsPending = true; // User is in pending list
                    break;
                  }
                }
                
                // Check in approved employees if not found in pending
                if (!userHasRegistered) {
                  for (final emp in approvedEmployees) {
                    if (emp['user_id'] == user.id) {
                      userHasRegistered = true;
                      userRegistrationIsPending = false; // User is in approved list
                      break;
                    }
                  }
                }
                
                if (!userHasRegistered && (pendingEmployees.isNotEmpty || approvedEmployees.isNotEmpty)) {
                }
              }
              
              // Use the full employee lists (including current user)
              final displayPendingEmployees = pendingEmployees;
              final displayApprovedEmployees = approvedEmployees;
              
              // Check if any employees are registered for this shift (for display purposes)
              final hasAnyRegistrations = pendingEmployees.isNotEmpty || approvedEmployees.isNotEmpty;
              final hasPendingEmployees = pendingEmployees.isNotEmpty;
              final isSelected = selectedShift == shiftIdStr;
              
              return GestureDetector(
                onTap: () => _handleShiftClick(shiftIdStr, userHasRegistered),
                child: Container(
                    margin: const EdgeInsets.only(bottom: TossSpacing.space3),
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? TossColors.primary.withOpacity(0.08)
                        : (userRegistrationIsPending
                            ? TossColors.warning.withOpacity(0.08)  // Orange/yellow background when user's registration is pending
                            : (userHasRegistered && !userRegistrationIsPending
                                ? TossColors.success.withOpacity(0.08)  // Green background when user's registration is approved
                                : (hasAnyRegistrations 
                                    ? TossColors.gray50
                                    : TossColors.background))),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      border: Border.all(
                        color: isSelected
                          ? TossColors.primary
                          : (userRegistrationIsPending
                              ? TossColors.warning.withOpacity(0.3)  // Orange/yellow border when user's registration is pending
                              : (userHasRegistered && !userRegistrationIsPending
                                  ? TossColors.success.withOpacity(0.3)  // Green border when user's registration is approved
                                  : (hasAnyRegistrations 
                                      ? TossColors.gray300
                                      : TossColors.gray200))),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Radio button style selector
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected 
                                    ? TossColors.primary
                                    : TossColors.gray400,
                                  width: isSelected ? 2 : 1.5,
                                ),
                              ),
                              child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: TossColors.primary,
                                      ),
                                    ),
                                  )
                                : null,
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            // Clock icon
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.transparent,  // Make background transparent to show parent color
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              ),
                              child: Icon(
                                Icons.access_time,
                                size: 18,
                                color: hasAnyRegistrations 
                                  ? TossColors.primary
                                  : TossColors.gray600,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            Expanded(
                              child: Text(
                                shiftName.toString(),
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Show employee count if there are registrations
                            if (hasAnyRegistrations) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space2,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: userHasRegistered && !userRegistrationIsPending
                                    ? TossColors.success.withOpacity(0.1)  // Light green background for approved
                                    : userRegistrationIsPending
                                      ? TossColors.warning.withOpacity(0.1)  // Light orange background for pending
                                      : TossColors.gray100,  // Default gray background
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                ),
                                child: Text(
                                  userHasRegistered && !userRegistrationIsPending
                                    ? 'Approved'  // Show "Approved" when user's registration is approved
                                    : userRegistrationIsPending
                                      ? 'Pending'  // Show "Pending" when user's registration is pending
                                      : '${approvedEmployees.length + pendingEmployees.length} registered',  // Show count when user not registered
                                  style: TossTextStyles.caption.copyWith(
                                    color: userHasRegistered && !userRegistrationIsPending
                                      ? TossColors.success  // Green text for approved
                                      : userRegistrationIsPending
                                        ? TossColors.warning  // Orange text for pending
                                        : TossColors.gray700,  // Default gray for count
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                    const SizedBox(height: TossSpacing.space3),
                    // Time display - Toss Style
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,  // Make background transparent to show parent color
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_outlined,
                            size: 14,
                            color: TossColors.gray600,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            '$startTime - $endTime',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Show registered employees for this shift
                    if (approvedEmployees.isNotEmpty || pendingEmployees.isNotEmpty) ...[
                      const SizedBox(height: TossSpacing.space3),
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space2),
                        decoration: BoxDecoration(
                          color: Colors.transparent,  // Make background transparent to show parent color
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Approved employees
                            if (displayApprovedEmployees.isNotEmpty) ...[
                              ...displayApprovedEmployees.map((employee) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    // Profile image
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: TossColors.success.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: employee['profile_image'] != null && 
                                             employee['profile_image'].toString().isNotEmpty
                                        ? ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: employee['profile_image'].toString(),
                                              width: 32,
                                              height: 32,
                                              fit: BoxFit.contain,
                                              memCacheWidth: 64,
                                              memCacheHeight: 64,
                                              placeholder: (context, url) => Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: TossColors.success.withValues(alpha: 0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.person_outline,
                                                    size: 16,
                                                    color: TossColors.success,
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Center(
                                                child: Icon(
                                                  Icons.person_outline,
                                                  size: 16,
                                                  color: TossColors.success,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.person_outline,
                                            size: 16,
                                            color: TossColors.success,
                                          ),
                                    ),
                                    const SizedBox(width: TossSpacing.space2),
                                    // Name
                                    Expanded(
                                      child: Text(
                                        (employee['employee_full_name'] ?? 'Unknown').toString(),
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.gray900,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Approval status
                                    Text(
                                      'Approved',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.success,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                            ],
                            // Pending employees
                            if (displayPendingEmployees.isNotEmpty) ...[
                              ...displayPendingEmployees.map((employee) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    // Profile image
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: TossColors.warning.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: employee['profile_image'] != null && 
                                             employee['profile_image'].toString().isNotEmpty
                                        ? ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: employee['profile_image'].toString(),
                                              width: 32,
                                              height: 32,
                                              fit: BoxFit.contain,
                                              memCacheWidth: 64,
                                              memCacheHeight: 64,
                                              placeholder: (context, url) => Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: TossColors.warning.withValues(alpha: 0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.person_outline,
                                                    size: 16,
                                                    color: TossColors.warning,
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Center(
                                                child: Icon(
                                                  Icons.person_outline,
                                                  size: 16,
                                                  color: TossColors.warning,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.person_outline,
                                            size: 16,
                                            color: TossColors.warning,
                                          ),
                                    ),
                                    const SizedBox(width: TossSpacing.space2),
                                    // Name
                                    Expanded(
                                      child: Text(
                                        (employee['employee_full_name'] ?? 'Unknown').toString(),
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.gray900,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Approval status
                                    Text(
                                      'Pending',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.error,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                            ],
                          ],
                        ),
                      ),
                    ],
                    if (displayPendingEmployees.isEmpty && displayApprovedEmployees.isEmpty && !isSelected) ...[
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'No employees registered for this shift',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ] else if (isSelected) ...[
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'Selected - Tap to deselect',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
            }).toList(),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(
                  color: TossColors.warning.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: TossColors.warning,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    'No shifts configured for this store',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
              ],
            ),
          ],
        ),
      );
  }
  
  // Get ALL shifts from store metadata
  List<Map<String, dynamic>> _getAllStoreShifts() {
    print('🔍 [ShiftRegister] _getAllStoreShifts() 호출');
    print('   - shiftMetadata: $shiftMetadata');
    print('   - shiftMetadata type: ${shiftMetadata.runtimeType}');

    if (shiftMetadata == null) {
      print('❌ [ShiftRegister] shiftMetadata가 null - 빈 리스트 반환');
      return [];
    }

    // The RPC response should be a list directly
    if (shiftMetadata is List) {
      print('✅ [ShiftRegister] shiftMetadata는 List 타입 - 개수: ${shiftMetadata!.length}');

      // Convert ShiftMetadata entities to Map and filter for active shifts only
      final shifts = (shiftMetadata as List).where((item) {
        // If it's a ShiftMetadata entity, check isActive directly
        if (item is ShiftMetadata) {
          print('   📦 ShiftMetadata entity 발견: ${item.shiftName}, isActive: ${item.isActive}');
          return item.isActive;
        }
        // If it's a Map, check is_active field
        if (item is Map) {
          print('   📦 Map 발견: ${item['shift_name']}, is_active: ${item['is_active']}');
          return item['is_active'] == true;
        }
        return false;
      }).map((item) {
        // Convert ShiftMetadata entity to Map
        if (item is ShiftMetadata) {
          return {
            'shift_id': item.shiftId,
            'shift_name': item.shiftName,
            'start_time': item.startTime,
            'end_time': item.endTime,
            'is_active': item.isActive,
            'description': item.description,
          };
        }
        // If already a Map, use it
        if (item is Map<String, dynamic>) {
          return item;
        }
        if (item is Map) {
          return Map<String, dynamic>.from(item);
        }
        return <String, dynamic>{};
      }).where((item) => item.isNotEmpty).toList();

      print('📋 [ShiftRegister] active shifts 필터링 완료 - ${shifts.length}개');
      if (shifts.isNotEmpty) {
        print('   - 첫 번째 shift: ${shifts.first}');
      } else {
        print('⚠️ [ShiftRegister] active shift가 없음! (is_active가 false일 수 있음)');
      }

      return shifts;
    }
    
    // If somehow it's still a Map, check if it contains shift data
    if (shiftMetadata is Map) {
      final map = shiftMetadata as Map;
      
      // If it has shift properties, treat it as a single shift
      if (map['shift_id'] != null || map['id'] != null || map['shift_name'] != null) {
        return [Map<String, dynamic>.from(map)];
      }
      
      // Check if it has a data property that contains shifts
      if (map['data'] is List) {
        return List<Map<String, dynamic>>.from(map['data'] as List);
      }
    }
    
    return [];
  }
  
  void _showShiftRegistrationDialog() {
    // This would show a dialog to register or edit shift
    // For now, just show a simple bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Text(
                _hasShiftOnDate(selectedDate) ? 'Edit Shift' : 'Register Shift',
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                child: Column(
                  children: [
                    // Date Display
                    Container(
                      padding: const EdgeInsets.all(TossSpacing.space3),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: TossColors.primary),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            '${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space4),
                    
                    // Time Selection Placeholder
                    Text(
                      'Time selection UI would go here',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Save shift logic here
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TossColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TossSpacing.space5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getMonthName(int month) => DateFormatUtils.getMonthName(month);
  String _getWeekdayFull(int weekday) => DateFormatUtils.getWeekdayFull(weekday);
}

