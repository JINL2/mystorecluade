import 'package:cached_network_image/cached_network_image.dart';
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
import '../../../domain/entities/shift_data.dart';
import '../../providers/attendance_provider.dart';

class ShiftRegisterTab extends ConsumerStatefulWidget {
  const ShiftRegisterTab({super.key});

  @override
  ConsumerState<ShiftRegisterTab> createState() => _ShiftRegisterTabState();
}

class _ShiftRegisterTabState extends ConsumerState<ShiftRegisterTab> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedMonth = DateTime.now();
  String? selectedStoreId;
  dynamic shiftMetadata; // Store shift metadata from RPC (can be List or Map)
  bool isLoadingMetadata = false;
  List<Map<String, dynamic>>? monthlyShiftStatus; // Store monthly shift status from RPC
  bool isLoadingShiftStatus = false;
  
  // ScrollController for auto-scroll functionality
  final ScrollController _scrollController = ScrollController();
  bool _isAutoScrolling = false; // Prevent conflicting scroll animations
  
  // Selection state for shift cards
  String? selectedShift; // Store single selected shift ID
  String? selectionMode; // 'registered' or 'unregistered' - determined by selection
  
  // Remove mock data - will use real data from RPC
  Map<DateTime, ShiftData> registeredShifts = {
    DateTime(2024, 11, 11): ShiftData('09:00', '18:00', 'Store A'),
    DateTime(2024, 11, 12): ShiftData('09:00', '18:00', 'Store A'),
    DateTime(2024, 11, 13): ShiftData('14:00', '22:00', 'Store B'),
    DateTime(2024, 11, 14): ShiftData('09:00', '18:00', 'Store A'),
    DateTime(2024, 11, 15): ShiftData('09:00', '18:00', 'Store A'),
    DateTime(2024, 11, 18): ShiftData('10:00', '19:00', 'Store A'),
    DateTime(2024, 11, 19): ShiftData('09:00', '18:00', 'Store A'),
    DateTime(2024, 11, 20): ShiftData('14:00', '22:00', 'Store B'),
  };
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  // Fetch shift metadata from Supabase RPC
  Future<void> fetchShiftMetadata(String storeId) async {
    if (storeId.isEmpty) return;

    if (mounted) {
      setState(() {
        isLoadingMetadata = true;
      });
    }

    try {
      // Use datasource instead of direct Supabase call
      final datasource = ref.read(attendanceDatasourceProvider);

      final response = await datasource.getShiftMetadata(
        storeId: storeId,
      );

      if (mounted) {
        setState(() {
          // Store the raw response directly - it should be a List of shift objects
          shiftMetadata = response;
          isLoadingMetadata = false;
        });
      }

    } catch (e) {
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
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;
    
    setState(() {
      isLoadingShiftStatus = true;
    });
    
    try {
      // Format date as YYYY-MM-DD for the first day of the focused month
      final requestDate = '${focusedMonth.year}-${focusedMonth.month.toString().padLeft(2, '0')}-01';

      // Use datasource instead of direct Supabase call
      final datasource = ref.read(attendanceDatasourceProvider);
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      final response = await datasource.getMonthlyShiftStatusManager(
        storeId: selectedStoreId!,
        companyId: companyId,
        requestDate: requestDate,
      );

      setState(() {
        monthlyShiftStatus = response;
        isLoadingShiftStatus = false;
      });
      
    } catch (e) {
      setState(() {
        isLoadingShiftStatus = false;
        monthlyShiftStatus = [];
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    // Initialize selectedStoreId from app state
    final appState = ref.read(appStateProvider);
    selectedStoreId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;
    
    // Fetch shift metadata and monthly status for the default store
    if (selectedStoreId != null) {
      fetchShiftMetadata(selectedStoreId!);
      fetchMonthlyShiftStatus();
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
  
  
  // Optimistically update local shift status to prevent race condition
  void _updateLocalShiftStatusOptimistically({
    required String shiftId,
    required String userId,
    required String userName,
    required String profileImage,
    required String requestDate,
  }) {
    if (monthlyShiftStatus == null) {
      monthlyShiftStatus = [];
    }
    
    
    // We don't have shift_request_id since we're not calling RPC after registration
    // Set it to null for local state update
    
    // Find the existing shift data for this date
    Map<String, dynamic>? existingDayData;
    int existingIndex = -1;
    
    for (int i = 0; i < monthlyShiftStatus!.length; i++) {
      if (monthlyShiftStatus![i]['request_date'] == requestDate) {
        existingDayData = monthlyShiftStatus![i];
        existingIndex = i;
        break;
      }
    }
    
    // Create new employee entry for optimistic update
    final newEmployee = {
      'user_id': userId,
      'user_name': userName,
      'profile_image': profileImage,
      'is_approved': false, // New registrations start as not approved
      'shift_request_id': null, // Set to null since we don't have it from RPC
    };
    
    if (existingDayData != null && existingIndex != -1) {
      // Update existing day data
      var shifts = existingDayData['shifts'] as List<dynamic>?;
      if (shifts == null) {
        shifts = [];
        existingDayData['shifts'] = shifts;
      }
      
      // Find the specific shift
      bool shiftFound = false;
      for (var shift in shifts) {
        if (shift['shift_id'].toString() == shiftId) {
          shiftFound = true;
          // Add to pending_employees list
          var pendingEmployees = shift['pending_employees'] as List<dynamic>? ?? [];
          
          // Check if user is not already registered
          bool alreadyRegistered = false;
          for (var emp in pendingEmployees) {
            if (emp['user_id'] == userId) {
              alreadyRegistered = true;
              break;
            }
          }
          
          // Also check approved employees
          var approvedEmployees = shift['approved_employees'] as List<dynamic>? ?? [];
          for (var emp in approvedEmployees) {
            if (emp['user_id'] == userId) {
              alreadyRegistered = true;
              break;
            }
          }
          
          if (!alreadyRegistered) {
            pendingEmployees.add(newEmployee);
            shift['pending_employees'] = pendingEmployees;
            
            // Update the total_pending count for the day
            existingDayData['total_pending'] = (existingDayData['total_pending'] ?? 0) + 1;
          } else {
          }
          break;
        }
      }
      
      // If shift doesn't exist in this day, create it
      if (!shiftFound) {
        // Get shift metadata to properly create the shift structure
        final allStoreShifts = _getAllStoreShifts();
        
        Map<String, dynamic>? shiftMetadata;
        for (final storeShift in allStoreShifts) {
          final storeShiftId = (storeShift['shift_id'] ?? storeShift['id'] ?? storeShift['store_shift_id'])?.toString();
          if (storeShiftId == shiftId) {
            shiftMetadata = storeShift;
            break;
          }
        }
        
        if (shiftMetadata == null) {
        }
        
        final newShift = {
          'shift_id': shiftId,
          'shift_name': shiftMetadata?['shift_name'] ?? shiftMetadata?['name'] ?? 'Unknown Shift',
          'start_time': shiftMetadata?['start_time'] ?? '00:00:00',
          'end_time': shiftMetadata?['end_time'] ?? '00:00:00',
          'pending_employees': [newEmployee],
          'approved_employees': [],
        };
        shifts.add(newShift);
        
        // Update the total_pending count for the day
        existingDayData['total_pending'] = (existingDayData['total_pending'] ?? 0) + 1;
      }
    } else {
      // Create new day data if it doesn't exist
      // Get shift metadata to properly create the shift structure
      final allStoreShifts = _getAllStoreShifts();
      
      Map<String, dynamic>? shiftMetadata;
      for (final storeShift in allStoreShifts) {
        final storeShiftId = (storeShift['shift_id'] ?? storeShift['id'] ?? storeShift['store_shift_id'])?.toString();
        if (storeShiftId == shiftId) {
          shiftMetadata = storeShift;
          break;
        }
      }
      
      if (shiftMetadata == null) {
      }
      
      final newDayData = {
        'request_date': requestDate,
        'total_pending': 1, // Starting with 1 pending employee
        'total_approved': 0,
        'shifts': [
          {
            'shift_id': shiftId,
            'shift_name': shiftMetadata?['shift_name'] ?? shiftMetadata?['name'] ?? 'Unknown Shift',
            'start_time': shiftMetadata?['start_time'] ?? '00:00:00',
            'end_time': shiftMetadata?['end_time'] ?? '00:00:00',
            'pending_employees': [newEmployee],
            'approved_employees': [],
          }
        ],
      };
      monthlyShiftStatus!.add(newDayData);
    }
    
    // Trigger UI update
    setState(() {
      // Force a new list to trigger rebuild
      monthlyShiftStatus = List<Map<String, dynamic>>.from(monthlyShiftStatus!);
    });
    
    
  }
  
  // Optimistically remove user from local shift status to prevent race condition on cancellation
  void _removeFromLocalShiftStatusOptimistically({
    required String shiftId,
    required String userId,
    required String requestDate,
  }) {
    if (monthlyShiftStatus == null || monthlyShiftStatus!.isEmpty) return;
    
    
    // Find the existing shift data for this date
    for (int dayIndex = 0; dayIndex < monthlyShiftStatus!.length; dayIndex++) {
      if (monthlyShiftStatus![dayIndex]['request_date'] == requestDate) {
        final dayData = monthlyShiftStatus![dayIndex];
        final shifts = dayData['shifts'] as List<dynamic>?;
        
        bool removedFromPending = false;
        bool removedFromApproved = false;
        
        if (shifts != null) {
          // Find the specific shift and remove the employee
          for (var shift in shifts) {
            if (shift['shift_id'].toString() == shiftId) {
              // Remove from pending_employees list
              var pendingEmployees = shift['pending_employees'] as List<dynamic>? ?? [];
              int pendingCountBefore = pendingEmployees.length;
              pendingEmployees.removeWhere((emp) => emp['user_id'] == userId);
              shift['pending_employees'] = pendingEmployees;
              if (pendingCountBefore > pendingEmployees.length) {
                removedFromPending = true;
              }
              
              // Remove from approved_employees list
              var approvedEmployees = shift['approved_employees'] as List<dynamic>? ?? [];
              int approvedCountBefore = approvedEmployees.length;
              approvedEmployees.removeWhere((emp) => emp['user_id'] == userId);
              shift['approved_employees'] = approvedEmployees;
              if (approvedCountBefore > approvedEmployees.length) {
                removedFromApproved = true;
              }
              
              break;
            }
          }
        }
        
        // Update the total counts for the day
        if (removedFromPending) {
          dayData['total_pending'] = (dayData['total_pending'] ?? 1) - 1;
        }
        if (removedFromApproved) {
          dayData['total_approved'] = (dayData['total_approved'] ?? 1) - 1;
        }
        
        break;
      }
    }
    
    
    // Trigger UI update
    setState(() {
      // Force a new list to trigger rebuild
      monthlyShiftStatus = List<Map<String, dynamic>>.from(monthlyShiftStatus!);
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
  Future<void> _handleCancelShifts() async {
    
    if (selectedShift == null) {
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
    }
  }
  
  // Handle register shift
  Future<void> _handleRegisterShift() async {
    if (selectedShift == null) return;
    
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
                          onPressed: () => Navigator.of(context).pop(),
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
                            Navigator.of(context).pop();

                            // Get user ID
                            final authStateAsync = ref.read(authStateProvider);
                            final user = authStateAsync.value;
                            if (user == null) return;
                            
                            
                            try {
                              // Use datasource instead of direct Supabase call
                              final datasource = ref.read(attendanceDatasourceProvider);
                              await datasource.insertShiftRequest(
                                userId: user.id,
                                shiftId: selectedShift!,
                                storeId: selectedStoreId!,
                                requestDate: dateStr,
                              );
                              
                              
                              // Optimistic UI update: immediately update local state
                              // This prevents the race condition where fetch happens before DB commit
                              
                              // Get user data from app state for more accurate information
                              final appState = ref.read(appStateProvider);
                              final userData = appState.user as Map<String, dynamic>? ?? {};
                              
                              // Use app state data first, fallback to auth metadata
                              final firstName = userData['user_first_name'] ?? '';
                              final lastName = userData['user_last_name'] ?? '';
                              final fullName = '$firstName $lastName'.trim();
                              
                              final userName = fullName.isNotEmpty 
                                             ? fullName
                                             : (user.userMetadata?['full_name'] as String?) ?? 
                                               (user.userMetadata?['name'] as String?) ?? 
                                               user.email?.split('@')[0] ?? 
                                               'Unknown';
                              
                              // Get profile image from app state
                              final profileImage = userData['profile_image'] ?? 
                                                 (user.userMetadata?['avatar_url'] as String?) ?? 
                                                 '';
                              
                              
                              _updateLocalShiftStatusOptimistically(
                                shiftId: selectedShift!,
                                userId: user.id,
                                userName: userName,
                                profileImage: profileImage?.toString() ?? '',
                                requestDate: dateStr,
                              );
                              
                              _resetSelections();
                              
                              // Force immediate UI update with local state changes
                              // NO RPC CALL - just use the updated local state
                              if (mounted) {
                                setState(() {
                                  // The UI will now reflect the changes made by _updateLocalShiftStatusOptimistically
                                });
                              }

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
                                                  Navigator.of(context).pop();
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
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) => TossDialog.error(
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
                          Navigator.of(context).pop();
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
                          Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
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
                          Navigator.of(context).pop();
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
                          Navigator.of(context).pop();
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

          // Delete using the three-column filter approach via datasource
          // This uniquely identifies the row without needing shift_request_id
          final datasource = ref.read(attendanceDatasourceProvider);
          await datasource.deleteShiftRequest(
            userId: user.id,
            shiftId: shiftId,
            requestDate: dateStr,
          );


          // Optimistic UI update: immediately remove from local state
          // This prevents the race condition where fetch happens before DB commit
          _removeFromLocalShiftStatusOptimistically(
            shiftId: shiftId,
            userId: user.id,
            requestDate: dateStr,
          );
        }
      }
      
      // Close loading indicator
      if (mounted) Navigator.of(context).pop();
      
      // Reset selections first
      _resetSelections();
      
      // Force immediate UI update with local state changes
      // NO RPC CALL - just use the updated local state
      if (mounted) {
        setState(() {
          // The UI will now reflect the changes made by _removeFromLocalShiftStatusOptimistically
        });
      }

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
                        Navigator.of(context).pop();
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
      if (mounted) Navigator.of(context).pop();
      
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
                    Navigator.of(context).pop();
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
    final appState = ref.watch(appStateProvider);

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
    
    // If selectedStoreId is null and stores are available, use the first store
    if (selectedStoreId == null && stores.isNotEmpty) {
      selectedStoreId = stores.first['store_id']?.toString();
      // Fetch metadata and monthly status for the auto-selected store
      if (shiftMetadata == null && !isLoadingMetadata) {
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
                    child: _buildCalendar(),
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
  
  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;
    
    List<Widget> calendarDays = [];
    
    // Week day headers - Toss Style
    const weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    for (int i = 0; i < weekDays.length; i++) {
      final isWeekend = i >= 5;
      calendarDays.add(
        Center(
          child: Text(
            weekDays[i],
            style: TossTextStyles.caption.copyWith(
              color: isWeekend ? TossColors.gray400 : TossColors.gray500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    
    // Empty cells before first day of month
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox());
    }
    
    // Days of the month - Toss Style
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(focusedMonth.year, focusedMonth.month, day);
      final isSelected = selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day;
      final isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;
      final isWeekend = date.weekday >= 6;
      final hasShift = _hasShiftOnDate(date);
      final shiftData = _getShiftForDate(date);
      
      // Get current user ID from app state
      final appState = ref.read(appStateProvider);
      final String currentUserId = (appState.user['user_id'] ?? '') as String;

      // Check user registration status for this date
      bool userIsApproved = false;
      bool userIsPending = false;

      if (shiftData != null && currentUserId.isNotEmpty) {
        // Check all shifts for this date
        final shifts = shiftData['shifts'] as List<dynamic>? ?? [];
        
        for (var shift in shifts) {
          // Check approved employees
          final approvedEmployees = shift['approved_employees'] as List<dynamic>? ?? [];
          for (var employee in approvedEmployees) {
            if (employee['user_id'] == currentUserId) {
              userIsApproved = true;
              break;
            }
          }
          
          // Check pending employees if not already approved
          if (!userIsApproved) {
            final pendingEmployees = shift['pending_employees'] as List<dynamic>? ?? [];
            for (var employee in pendingEmployees) {
              if (employee['user_id'] == currentUserId) {
                userIsPending = true;
                break;
              }
            }
          }
          
          if (userIsApproved || userIsPending) break;
        }
      }
      
      final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
      
      calendarDays.add(
        InkWell(
          onTap: () {
            setState(() {
              selectedDate = date;
              _resetSelections();
            });
            HapticFeedback.selectionClick();
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            margin: EdgeInsets.all(TossSpacing.space1 * 0.75),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.gray100
                      : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.toString(),
                      style: TossTextStyles.body.copyWith(
                        color: isSelected
                            ? TossColors.white
                            : isPast
                                ? TossColors.gray300
                                : isWeekend
                                    ? TossColors.gray500
                                    : TossColors.gray900,
                        fontWeight: isSelected || isToday
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    if (hasShift && (userIsApproved || userIsPending)) ...[
                      const SizedBox(height: 2),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? TossColors.white
                              : userIsApproved
                                  ? TossColors.success  // Green - user is approved
                                  : TossColors.warning,  // Orange - user is pending
                          shape: BoxShape.circle,
                        ),
                      ),
                    ] else
                      const SizedBox(height: TossSpacing.space2),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      crossAxisCount: 7,
      childAspectRatio: 1.0,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      children: calendarDays,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
  
  Widget _buildSelectedDateDetails() {
    final shift = registeredShifts[DateTime(selectedDate.year, selectedDate.month, selectedDate.day)];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getWeekdayFull(selectedDate.weekday),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
            ],
          ),
          
          if (shift != null) ...[
            const SizedBox(height: TossSpacing.space3),
            const Divider(color: TossColors.gray200),
            const SizedBox(height: TossSpacing.space3),
            
            Row(
              children: [
                Expanded(
                  child: _buildShiftInfo(
                    icon: Icons.login,
                    label: 'Start',
                    value: shift.startTime,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: _buildShiftInfo(
                    icon: Icons.logout,
                    label: 'End',
                    value: shift.endTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space2),
            _buildShiftInfo(
              icon: Icons.store,
              label: 'Store',
              value: shift.store,
            ),
          ] else ...[
            const SizedBox(height: TossSpacing.space3),
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
                    'No shift registered for this date',
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
  
  bool _hasShiftOnDate(DateTime date) {
    if (monthlyShiftStatus == null || monthlyShiftStatus!.isEmpty) return false;
    
    // Check if there are any shifts registered for this date (for any employee)
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return monthlyShiftStatus!.any((dayData) {
      return dayData['request_date'] == dateStr && 
             (((dayData['total_approved'] ?? 0) as int) > 0 || 
              ((dayData['total_pending'] ?? 0) as int) > 0);
    });
  }
  
  // Get shift details for a specific date (returns the day's data with all employees)
  Map<String, dynamic>? _getShiftForDate(DateTime date) {
    if (monthlyShiftStatus == null || monthlyShiftStatus!.isEmpty) return null;
    
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    try {
      return monthlyShiftStatus!.firstWhere(
        (dayData) => dayData['request_date'] == dateStr,
      );
    } catch (e) {
      return null;
    }
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
          Container(
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
                Text(
                  '${selectedDate.day}',
                  style: TossTextStyles.h1.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getWeekdayFull(selectedDate.weekday),
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (selectedShift != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                    ),
                    child: Text(
                      '1 Selected',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
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
                // Find the data for the selected date
                bool foundDate = false;
                for (final dayData in monthlyShiftStatus!) {
                  if (dayData['request_date'] == dateStr) {
                    foundDate = true;
                    final shifts = dayData['shifts'] as List? ?? [];
                    
                    // Find the matching shift by ID
                    for (final shiftData in shifts) {
                      // Compare shift IDs as strings to avoid type issues
                      if (shiftData['shift_id'].toString() == shiftId.toString()) {
                        // Extract pending employees
                        if (shiftData['pending_employees'] != null) {
                          final pending = shiftData['pending_employees'] as List;
                          pendingEmployees = List<Map<String, dynamic>>.from(
                            pending.map((e) => Map<String, dynamic>.from(e as Map))
                          );
                        }
                        
                        // Extract approved employees
                        if (shiftData['approved_employees'] != null) {
                          final approved = shiftData['approved_employees'] as List;
                          approvedEmployees = List<Map<String, dynamic>>.from(
                            approved.map((e) => Map<String, dynamic>.from(e as Map))
                          );
                        }
                        break;
                      }
                    }
                    break;
                  }
                }
                if (!foundDate) {
                }
              } else {
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
                                        (employee['user_name'] ?? 'Unknown').toString(),
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
                                        (employee['user_name'] ?? 'Unknown').toString(),
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
    if (shiftMetadata == null) {
      return [];
    }
    
    
    // The RPC response should be a list directly
    if (shiftMetadata is List) {
      // Convert each item to Map<String, dynamic> and filter for active shifts only
      return (shiftMetadata as List).map((item) {
        if (item is Map<String, dynamic>) {
          return item;
        } else if (item is Map) {
          return Map<String, dynamic>.from(item);
        } else {
          return <String, dynamic>{};
        }
      }).where((item) => 
        item.isNotEmpty && 
        item['is_active'] == true  // Filter only active shifts
      ).toList();
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
  
  static String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
  
  String _getWeekdayFull(int weekday) {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return weekdays[weekday - 1];
  }
}
