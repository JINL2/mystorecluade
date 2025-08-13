import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_state_provider.dart';
import 'attendance_page.dart';
import 'qr_scanner_page.dart';

class AttendanceMainPage extends StatefulWidget {
  const AttendanceMainPage({super.key});

  @override
  State<AttendanceMainPage> createState() => _AttendanceMainPageState();
}

class _AttendanceMainPageState extends State<AttendanceMainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.selectionClick();
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Tabs
            Container(
              color: TossColors.background,
              child: Column(
                children: [
                  // Title Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space5,
                      vertical: TossSpacing.space4,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 24),
                          onPressed: () => Navigator.of(context).pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const Spacer(),
                        Text(
                          'Attendance',
                          style: TossTextStyles.h3.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 24), // Balance for back button
                      ],
                    ),
                  ),
                  
                  // Tab Bar - Toss Style
                  Container(
                    height: 48,
                    margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    child: Stack(
                      children: [
                        // Background
                        Container(
                          decoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        // Tab Bar
                        TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: TossColors.background,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: const EdgeInsets.all(2),
                          dividerColor: Colors.transparent,
                          labelColor: TossColors.gray900,
                          unselectedLabelColor: TossColors.gray500,
                          labelStyle: TossTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelStyle: TossTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                          splashBorderRadius: BorderRadius.circular(22),
                          tabs: const [
                            Tab(
                              text: 'Register',
                              height: 44,
                            ),
                            Tab(
                              text: 'Check In/Out',
                              height: 44,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space4),
                ],
              ),
            ),
            
            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // First Tab - Register Shifts
                  _buildRegisterTab(),
                  
                  // Second Tab - Attendance Page
                  const AttendanceContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRegisterTab() {
    return const ShiftRegisterTab();
  }
}

// Shift Registration Tab
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
  
  // Fetch shift metadata from Supabase RPC
  Future<void> fetchShiftMetadata(String storeId) async {
    if (storeId.isEmpty) return;
    
    setState(() {
      isLoadingMetadata = true;
    });
    
    try {
      final response = await Supabase.instance.client.rpc(
        'get_shift_metadata',
        params: {
          'p_store_id': storeId,
        },
      );
      
      print('DEBUG: Raw shift metadata response type: ${response.runtimeType}');
      print('DEBUG: Raw shift metadata response: $response');
      
      setState(() {
        // Store the raw response directly - it should be a List of shift objects
        if (response != null) {
          shiftMetadata = response;
        } else {
          shiftMetadata = [];
        }
        isLoadingMetadata = false;
      });
      
      print('Shift metadata loaded for store $storeId');
      print('Processed shiftMetadata: $shiftMetadata');
      print('Number of shifts: ${shiftMetadata is List ? (shiftMetadata as List).length : "not a list"}');
    } catch (e) {
      print('Error fetching shift metadata: $e');
      setState(() {
        isLoadingMetadata = false;
        shiftMetadata = [];
      });
    }
  }
  
  // Fetch monthly shift status from Supabase RPC
  Future<void> fetchMonthlyShiftStatus() async {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;
    
    // Get user ID from auth provider
    final user = ref.read(authStateProvider);
    if (user == null) return;
    
    setState(() {
      isLoadingShiftStatus = true;
    });
    
    try {
      // Format date as YYYY-MM-DD for the first day of the focused month
      final requestDate = '${focusedMonth.year}-${focusedMonth.month.toString().padLeft(2, '0')}-01';
      
      final response = await Supabase.instance.client.rpc(
        'get_monthly_shift_status',
        params: {
          'p_user_id': user.id,
          'p_store_id': selectedStoreId,
          'p_request_date': requestDate,
        },
      );
      
      setState(() {
        monthlyShiftStatus = response != null ? List<Map<String, dynamic>>.from(response) : [];
        isLoadingShiftStatus = false;
      });
      
      print('Monthly shift status loaded: ${monthlyShiftStatus?.length ?? 0} shifts');
    } catch (e) {
      print('Error fetching monthly shift status: $e');
      setState(() {
        isLoadingShiftStatus = false;
        monthlyShiftStatus = null;
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
      }
    });
    
    // Haptic feedback
    HapticFeedback.selectionClick();
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
      backgroundColor: Colors.transparent,
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
                borderRadius: BorderRadius.circular(100),
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
                        selectedStoreId = store['store_id'];
                        _resetSelections();
                      });
                      
                      // Update app state with the new store selection
                      await ref.read(appStateProvider.notifier).setStoreChoosen(store['store_id']);
                      // Fetch shift metadata and monthly status for the new store
                      await fetchShiftMetadata(store['store_id']);
                      await fetchMonthlyShiftStatus();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space5,
                        vertical: TossSpacing.space4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? TossColors.gray50 : Colors.transparent,
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
                              color: isSelected ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray100,
                              borderRadius: BorderRadius.circular(10),
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
                              store['store_name'] ?? 'Unknown Store',
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
    if (selectedShift == null) return;
    
    // Get the selected shift details
    final allStoreShifts = _getAllStoreShifts();
    Map<String, dynamic>? selectedShiftDetail;
    
    // Get user's shift data for the selected date
    final userShiftsForDate = monthlyShiftStatus?.where((shift) {
      final shiftDate = shift['shift_date'] ?? shift['request_date'];
      final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
      return shiftDate == dateStr;
    }).toList() ?? [];
    
    // Find the selected shift details
    for (final shift in allStoreShifts) {
      final shiftId = shift['shift_id'] ?? shift['id'] ?? shift['store_shift_id'];
      if (shiftId?.toString() == selectedShift) {
        // Find the corresponding user shift
        final userShift = userShiftsForDate.firstWhere(
          (us) => (us['shift_id']?.toString() == selectedShift || 
                   us['store_shift_id']?.toString() == selectedShift ||
                   us['shift_type'] == (shift['shift_name'] ?? shift['name'] ?? shift['shift_type'])),
          orElse: () => <String, dynamic>{},
        );
        
        if (userShift.isNotEmpty) {
          selectedShiftDetail = {
            ...shift,
            'shift_request_id': userShift['shift_request_id'],
            'is_approved': userShift['is_approved'] ?? false,
          };
        }
        break;
      }
    }
    
    if (selectedShiftDetail == null) return;
    
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
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                          color: TossColors.primary.withValues(alpha: 0.1),
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
                          borderRadius: BorderRadius.circular(12),
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
                              shiftName,
                              style: TossTextStyles.h3.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
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
                            final user = ref.read(authStateProvider);
                            if (user == null) return;
                            
                            try {
                              // Call RPC function to register shift
                              final response = await Supabase.instance.client.rpc(
                                'insert_shift_request_v2',
                                params: {
                                  'p_user_id': user.id,
                                  'p_shift_id': selectedShift,
                                  'p_store_id': selectedStoreId,
                                  'p_request_date': dateStr,
                                },
                              );
                              
                              // Immediately refresh the shift status after successful registration
                              await fetchMonthlyShiftStatus();
                              _resetSelections();
                              
                              // Force UI update to show the new status
                              if (mounted) {
                                setState(() {});
                              }
                              
                              // Show success message
                              if (mounted) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.1),
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
                                                      color: TossColors.success.withValues(alpha: 0.1),
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
                              print('Error registering shift: $e');
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to register shift: ${e.toString()}'),
                                    backgroundColor: TossColors.error,
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
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                          color: TossColors.warning.withValues(alpha: 0.1),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: TossColors.success,
                              ),
                            ),
                            const TextSpan(text: ' are approved and cannot be cancelled.\n'),
                            const TextSpan(text: 'Only '),
                            TextSpan(
                              text: '${pendingShifts.length} pending shift${pendingShifts.length > 1 ? 's' : ''}',
                              style: const TextStyle(
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
  
  // Show alert for approved shifts
  void _showApprovedShiftAlert() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                          color: TossColors.warning.withValues(alpha: 0.1),
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
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                          color: TossColors.error.withValues(alpha: 0.1),
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
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      
      // Cancel each shift
      for (final shift in shiftsToCancel) {
        final shiftRequestId = shift['shift_request_id'];
        if (shiftRequestId != null) {
          await Supabase.instance.client
              .from('shift_requests')
              .delete()
              .eq('shift_request_id', shiftRequestId);
        }
      }
      
      // Close loading indicator
      if (mounted) Navigator.of(context).pop();
      
      // Refresh the shift status
      await fetchMonthlyShiftStatus();
      
      // Reset selections
      _resetSelections();
      
      // Show success message
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
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
                              color: TossColors.success.withValues(alpha: 0.1),
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
                    style: TextStyle(color: TossColors.primary),
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
    final selectedCompany = ref.read(appStateProvider.notifier).selectedCompany;
    final stores = selectedCompany?['stores'] as List<dynamic>? ?? [];
    
    // If selectedStoreId is null and stores are available, use the first store
    if (selectedStoreId == null && stores.isNotEmpty) {
      selectedStoreId = stores.first['store_id'];
      // Fetch metadata and monthly status for the auto-selected store
      if (shiftMetadata == null && !isLoadingMetadata) {
        fetchShiftMetadata(selectedStoreId!);
        fetchMonthlyShiftStatus();
      }
    }
    
    return Column(
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
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
                decoration: BoxDecoration(
                  color: TossColors.background,
                  borderRadius: BorderRadius.circular(16),
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
                        borderRadius: BorderRadius.circular(8),
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
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            stores.firstWhere(
                              (store) => store['store_id'] == selectedStoreId,
                              orElse: () => {'store_name': 'Select Store'},
                            )['store_name'] ?? 'Select Store',
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
                borderRadius: BorderRadius.circular(20),
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
                borderRadius: BorderRadius.circular(20),
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
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: EdgeInsets.zero,
            children: [
              // Calendar - Toss Style
              Container(
                margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                child: _buildCalendar(),
              ),
              
              const SizedBox(height: TossSpacing.space4),
              
              // Selected Date Shift Details
              if (selectedDate != null)
                _buildSelectedDateShiftDetails(),
              
              // Register/Edit/Cancel Shift Button - Toss Style (Only show when shift is selected)
              if (selectedShift != null) ...[
                const SizedBox(height: TossSpacing.space4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      // Check what action to take based on selection
                      if (selectionMode == 'registered' && selectedShift != null) {
                        _handleCancelShifts();
                      } else if (selectionMode == 'unregistered' && selectedShift != null) {
                        _handleRegisterShift();
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: selectionMode == 'registered'
                          ? TossColors.gray900
                          : TossColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          selectionMode == 'registered'
                            ? 'Cancel Shift'
                            : 'Register Shift',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              
              // Add bottom padding for comfortable scrolling
              const SizedBox(height: 24),
            ],
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
              fontWeight: FontWeight.w500,
              fontSize: 12,
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
      final isApproved = shiftData?['is_approved'] ?? false;
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
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.gray100
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
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
                            ? Colors.white
                            : isPast
                                ? TossColors.gray300
                                : isWeekend
                                    ? TossColors.gray500
                                    : TossColors.gray900,
                        fontWeight: isSelected || isToday
                            ? FontWeight.w700
                            : FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    if (hasShift) ...[
                      const SizedBox(height: 2),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : isApproved
                                  ? TossColors.success
                                  : TossColors.warning,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ] else
                      const SizedBox(height: 8),
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
        borderRadius: BorderRadius.circular(12),
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
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
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
                        color: TossColors.gray600,
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
                color: TossColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: TossColors.warning.withValues(alpha: 0.3),
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
                      fontWeight: FontWeight.w500,
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
            color: TossColors.gray600,
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
    
    // Check if user has a registered shift for this date
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return monthlyShiftStatus!.any((shift) {
      final shiftDate = shift['shift_date'] ?? shift['request_date'];
      return shiftDate == dateStr;
    });
  }
  
  // Get shift details for a specific date
  Map<String, dynamic>? _getShiftForDate(DateTime date) {
    if (monthlyShiftStatus == null || monthlyShiftStatus!.isEmpty) return null;
    
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    try {
      return monthlyShiftStatus!.firstWhere(
        (shift) {
          final shiftDate = shift['shift_date'] ?? shift['request_date'];
          return shiftDate == dateStr;
        },
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
              borderRadius: BorderRadius.circular(16),
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
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontSize: 11,
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
                      color: TossColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
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
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: TossColors.primary,
                      ),
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
                            color: TossColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
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
              final description = shift['description'] ?? shift['shift_description'] ?? '';
              
              // Check registration status
              final userShiftForDate = _getShiftForDate(selectedDate);
              final isRegisteredForThisShift = userShiftForDate != null && 
                  (userShiftForDate['shift_id'] == shiftId || 
                   userShiftForDate['store_shift_id'] == shiftId ||
                   userShiftForDate['shift_type'] == shiftName);
              final isApproved = isRegisteredForThisShift && (userShiftForDate['is_approved'] ?? false);
              final isSelected = selectedShift == shiftIdStr;
              
              return GestureDetector(
                onTap: () => _handleShiftClick(shiftIdStr, isRegisteredForThisShift),
                child: Container(
                    margin: const EdgeInsets.only(bottom: TossSpacing.space3),
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? (isRegisteredForThisShift 
                            ? (isApproved 
                                ? TossColors.primary.withValues(alpha: 0.08)
                                : TossColors.primary.withValues(alpha: 0.08))
                            : TossColors.primary.withValues(alpha: 0.08))
                        : (isRegisteredForThisShift 
                            ? (isApproved 
                                ? TossColors.success.withValues(alpha: 0.05)
                                : TossColors.warning.withValues(alpha: 0.05))
                            : TossColors.background),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                          ? TossColors.primary
                          : (isRegisteredForThisShift 
                              ? (isApproved 
                                  ? TossColors.success.withValues(alpha: 0.3)
                                  : TossColors.warning.withValues(alpha: 0.3))
                              : TossColors.gray200),
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
                                color: TossColors.gray100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.access_time,
                                size: 18,
                                color: isRegisteredForThisShift 
                                  ? (isApproved ? TossColors.success : TossColors.warning)
                                  : TossColors.gray600,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            Expanded(
                              child: Text(
                                shiftName,
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isRegisteredForThisShift) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space2,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isApproved 
                                    ? TossColors.success
                                    : TossColors.warning,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isApproved ? 'Approved' : 'Pending',
                                  style: TossTextStyles.caption.copyWith(
                                    color: Colors.white,
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
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(8),
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
                    if (!isRegisteredForThisShift && !isSelected) ...[
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'Tap to select for ${selectedDate.day} ${_getMonthName(selectedDate.month)}',
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
                color: TossColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: TossColors.warning.withValues(alpha: 0.3),
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
                      fontWeight: FontWeight.w500,
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
      print('DEBUG: shiftMetadata is null');
      return [];
    }
    
    print('DEBUG: shiftMetadata type: ${shiftMetadata.runtimeType}');
    print('DEBUG: shiftMetadata content: $shiftMetadata');
    
    // The RPC response should be a list directly
    if (shiftMetadata is List) {
      print('DEBUG: shiftMetadata is a List with ${(shiftMetadata as List).length} items');
      // Convert each item to Map<String, dynamic>
      return (shiftMetadata as List).map((item) {
        if (item is Map<String, dynamic>) {
          return item;
        } else if (item is Map) {
          return Map<String, dynamic>.from(item);
        } else {
          print('DEBUG: Unexpected item type in list: ${item.runtimeType}');
          return <String, dynamic>{};
        }
      }).where((item) => item.isNotEmpty).toList();
    }
    
    // If somehow it's still a Map, check if it contains shift data
    if (shiftMetadata is Map) {
      print('DEBUG: shiftMetadata is a Map, checking for shift data');
      final map = shiftMetadata as Map;
      
      // If it has shift properties, treat it as a single shift
      if (map['shift_id'] != null || map['id'] != null || map['shift_name'] != null) {
        print('DEBUG: Single shift object found, wrapping in list');
        return [Map<String, dynamic>.from(map)];
      }
      
      // Check if it has a data property that contains shifts
      if (map['data'] is List) {
        print('DEBUG: Found shifts under "data" key');
        return List<Map<String, dynamic>>.from(map['data'] as List);
      }
    }
    
    print('DEBUG: Could not parse shift metadata, returning empty list');
    return [];
  }
  
  void _showShiftRegistrationDialog() {
    // This would show a dialog to register or edit shift
    // For now, just show a simple bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
                borderRadius: BorderRadius.circular(100),
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
                        borderRadius: BorderRadius.circular(8),
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: TossTextStyles.body.copyWith(
                                color: Colors.white,
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

// Shift data model
class ShiftData {
  final String startTime;
  final String endTime;
  final String store;
  
  ShiftData(this.startTime, this.endTime, this.store);
}

// Extract the content from AttendancePage without the app bar
class AttendanceContent extends ConsumerStatefulWidget {
  const AttendanceContent({super.key});

  @override
  ConsumerState<AttendanceContent> createState() => _AttendanceContentState();
}

class _AttendanceContentState extends ConsumerState<AttendanceContent> {
  final DateTime currentTime = DateTime.now();
  late DateTime selectedDate;
  late DateTime centerDate;
  final ScrollController _weekScrollController = ScrollController();
  
  // Cache for monthly overview data - key is "yyyy-MM" format
  final Map<String, Map<String, dynamic>> _monthlyOverviewCache = {};
  
  // Cache for monthly cards data - key is "yyyy-MM" format
  final Map<String, List<Map<String, dynamic>>> _monthlyCardsCache = {};
  
  // Track which months have been loaded
  final Set<String> _loadedMonths = {};
  
  // ALL shift cards data accumulated across all loaded months
  List<Map<String, dynamic>> allShiftCardsData = [];
  
  // Current displayed month overview
  Map<String, dynamic>? shiftOverviewData;
  
  // Filtered cards for current view
  List<Map<String, dynamic>> get shiftCardsData {
    // Return all accumulated cards (can be filtered if needed)
    return allShiftCardsData;
  }
  
  bool isLoading = true;
  String? errorMessage;
  bool isWorking = false;
  String? currentDisplayedMonth; // Track which month overview is currently displayed
  
  @override
  void initState() {
    super.initState();
    // Use current date
    final testDate = DateTime.now();
    selectedDate = testDate;
    centerDate = testDate;
    
    // Fetch current month's data when page loads
    _fetchMonthData(testDate);
  }
  
  @override
  void dispose() {
    _weekScrollController.dispose();
    super.dispose();
  }
  
  void _updateCenterDate(DateTime newCenterDate) {
    // Check if the new date is in a different month
    final newMonthKey = '${newCenterDate.year}-${newCenterDate.month.toString().padLeft(2, '0')}';
    final currentMonthKey = currentDisplayedMonth;
    
    print('_updateCenterDate: newMonthKey=$newMonthKey, currentMonthKey=$currentMonthKey');
    
    setState(() {
      centerDate = newCenterDate;
      selectedDate = newCenterDate;
    });
    
    // If moving to a different month, fetch that month's data
    if (newMonthKey != currentMonthKey) {
      print('_updateCenterDate: Different month detected, will fetch data for $newMonthKey');
      _fetchMonthData(newCenterDate);
      // Don't adjust the center date after user explicitly selected a date
      // The user wants THIS specific date to be centered
    }
    // When user clicks a date, keep it centered as they requested
    // Don't auto-adjust to first available shift
  }
  
  void _adjustCenterDateForAvailableData(String monthKey) {
    print('_adjustCenterDateForAvailableData: Looking for shifts in month $monthKey');
    
    // Find the first date with shift data in this month
    final monthShifts = allShiftCardsData.where((card) {
      final date = card['request_date'] ?? '';
      return date.startsWith(monthKey);
    }).toList();
    
    print('_adjustCenterDateForAvailableData: Found ${monthShifts.length} shifts for $monthKey');
    
    if (monthShifts.isNotEmpty) {
      // Sort by date to find the earliest shift
      monthShifts.sort((a, b) {
        final dateA = a['request_date'] ?? '';
        final dateB = b['request_date'] ?? '';
        return dateA.compareTo(dateB);
      });
      
      // Parse the first shift date
      final firstShiftDateStr = monthShifts.first['request_date'];
      final lastShiftDateStr = monthShifts.last['request_date'];
      print('_adjustCenterDateForAvailableData: Shifts range from $firstShiftDateStr to $lastShiftDateStr');
      
      if (firstShiftDateStr != null) {
        final parts = firstShiftDateStr.split('-');
        if (parts.length == 3) {
          final firstShiftDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          
          // Adjust center date to show the week containing the first shift
          // If first shift is early in month (days 1-3), center on day 4
          // Otherwise center on the first shift date
          setState(() {
            if (firstShiftDate.day <= 3) {
              centerDate = DateTime(firstShiftDate.year, firstShiftDate.month, 4);
            } else {
              centerDate = firstShiftDate;
            }
            selectedDate = centerDate;
            print('_adjustCenterDateForAvailableData: Adjusted centerDate to $centerDate to show available shifts');
          });
        }
      }
    } else {
      print('_adjustCenterDateForAvailableData: No shifts found for $monthKey, keeping current centerDate');
    }
  }
  
  Future<void> _fetchMonthData(DateTime targetDate) async {
    // Create month key for tracking (yyyy-MM format)
    final monthKey = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';
    
    print('_fetchMonthData: Called with targetDate = $targetDate');
    print('_fetchMonthData: monthKey = $monthKey');
    
    // Check if we already have cached data for this month
    bool hasOverview = _monthlyOverviewCache.containsKey(monthKey);
    bool hasCards = _monthlyCardsCache.containsKey(monthKey);
    
    print('_fetchMonthData: hasOverview = $hasOverview, hasCards = $hasCards');
    
    // If we already have data for this month, just update the display from cache
    if (hasOverview && hasCards) {
      setState(() {
        shiftOverviewData = _monthlyOverviewCache[monthKey];
        currentDisplayedMonth = monthKey;
        
        // Rebuild allShiftCardsData from cached data
        allShiftCardsData.clear();
        for (final cachedMonth in _monthlyCardsCache.keys) {
          allShiftCardsData.addAll(_monthlyCardsCache[cachedMonth]!);
        }
        
        // Sort all cards by date (descending)
        allShiftCardsData.sort((a, b) {
          final dateA = a['request_date'] ?? '';
          final dateB = b['request_date'] ?? '';
          return dateB.compareTo(dateA);
        });
        
        isLoading = false;
      });
      print('AttendancePage: Already have data for $monthKey, using cached data');
      print('AttendancePage: Restored ${allShiftCardsData.length} total cards from cache');
      return;
    }
    
    // Need to fetch data for this month
    print('AttendancePage: Fetching new data for $monthKey with requestDate');
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      // Get required data from providers
      final authState = ref.read(authStateProvider);
      final appState = ref.read(appStateProvider);
      final service = ref.read(attendanceServiceProvider);
      
      final userId = authState?.id;
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      
      print('AttendancePage: Fetching data for month $monthKey with userId=$userId, companyId=$companyId, storeId=$storeId');
      
      if (userId == null || companyId.isEmpty || storeId.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'Please select a company and store';
        });
        return;
      }
      
      // IMPORTANT: RPC functions require the LAST day of the month as p_request_date
      // Calculate the last day of the month for the target date
      final lastDayOfMonth = DateTime(targetDate.year, targetDate.month + 1, 0);
      final requestDate = '${lastDayOfMonth.year}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')}';
      
      print('_fetchMonthData: Target date: ${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}');
      print('_fetchMonthData: Using last day of month for API: $requestDate');
      print('>>> CALLING RPC: user_shift_overview and user_shift_cards for $requestDate <<<');
      
      // Call both APIs in parallel
      final results = await Future.wait([
        service.getUserShiftOverview(
          requestDate: requestDate,
          userId: userId,
          companyId: companyId,
          storeId: storeId,
        ),
        service.getUserShiftCards(
          requestDate: requestDate,
          userId: userId,
          companyId: companyId,
          storeId: storeId,
        ),
        service.getCurrentShift(
          userId: userId,
          storeId: storeId,
        ),
      ]);
      
      final overviewResponse = results[0] as Map<String, dynamic>;
      final cardsResponse = results[1] as List<Map<String, dynamic>>;
      final currentShift = results[2] as Map<String, dynamic>?;
      
      print('AttendancePage: Received overview for $monthKey: $overviewResponse');
      print('AttendancePage: Received ${cardsResponse.length} shift cards for $monthKey');
      
      
      // Cache the overview data
      _monthlyOverviewCache[monthKey] = overviewResponse;
      
      // Cache the cards data for this month
      _monthlyCardsCache[monthKey] = List<Map<String, dynamic>>.from(cardsResponse);
      
      // Mark this month as loaded
      _loadedMonths.add(monthKey);
      
      // Rebuild allShiftCardsData from ALL cached months
      setState(() {
        print('AttendancePage: Caching ${cardsResponse.length} cards for month $monthKey');
        
        // Clear and rebuild allShiftCardsData from all cached months
        allShiftCardsData.clear();
        
        // Add cards from all cached months
        for (final cachedMonth in _monthlyCardsCache.keys) {
          final monthCards = _monthlyCardsCache[cachedMonth]!;
          allShiftCardsData.addAll(monthCards);
          print('AttendancePage: Added ${monthCards.length} cards from cached month $cachedMonth');
        }
        
        print('AttendancePage: Total cards after rebuilding from cache: ${allShiftCardsData.length}');
        
        
        // Sort all cards by date
        allShiftCardsData.sort((a, b) {
          final dateA = a['request_date'] ?? '';
          final dateB = b['request_date'] ?? '';
          return dateB.compareTo(dateA); // Descending order
        });
        
        shiftOverviewData = overviewResponse;
        currentDisplayedMonth = monthKey;
        isLoading = false;
        
        // Check if user is currently working (only relevant for current month)
        if (monthKey == '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}') {
          isWorking = currentShift != null && 
                     currentShift['confirm_start_time'] != null && 
                     currentShift['confirm_end_time'] == null;
        }
      });
      
      print('AttendancePage: Total accumulated cards: ${allShiftCardsData.length}');
      
    } catch (e) {
      print('AttendancePage: Error fetching data for $monthKey - $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading data: ${e.toString()}';
      });
    }
  }
  
  
  List<Map<String, dynamic>> get weekSchedule {
    // Create a 7-day window with centerDate at position 3 (index 3)
    // This gives us 3 days before and 3 days after the center date
    List<Map<String, dynamic>> schedule = [];
    
    
    for (int i = -3; i <= 3; i++) {  // This creates 7 days: -3, -2, -1, 0, 1, 2, 3
      final date = centerDate.add(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Find ALL shift cards for this date - use allShiftCardsData
      final shiftsForDate = allShiftCardsData.where(
        (card) => card['request_date'] == dateStr,
      ).toList();
      
      
      if (shiftsForDate.isNotEmpty) {
        // Has shift(s) for this date - use the first one for display
        // but mark that there are shifts
        final shiftCard = shiftsForDate.first;
        // The RPC returns shift_time as "22:00 ~ 02:00" format
        final shiftTime = shiftCard['shift_time'] ?? '';
        final actualStart = shiftCard['confirm_start_time'];
        final actualEnd = shiftCard['confirm_end_time'];
        
        // Check approval status for all shifts
        final hasApprovedShift = shiftsForDate.any((card) => 
          card['is_approved'] ?? card['approval_status'] == 'approved' ?? false
        );
        final hasNonApprovedShift = shiftsForDate.any((card) => 
          !(card['is_approved'] ?? card['approval_status'] == 'approved' ?? false)
        );
        
        schedule.add({
          'date': date,
          'hasShift': true,
          'shiftCount': shiftsForDate.length, // Track number of shifts
          'worked': actualStart != null, // Worked if they checked in
          'hasApprovedShift': hasApprovedShift,
          'hasNonApprovedShift': hasNonApprovedShift,
          'shift': shiftTime,
          'actualStart': actualStart,
          'actualEnd': actualEnd,
          'lateMinutes': shiftCard['late_minutes'] ?? 0,
          'overtimeMinutes': shiftCard['overtime_minutes'] ?? 0,
          'allShifts': shiftsForDate, // Store all shifts for this date
        });
      } else {
        // No shift for this date
        schedule.add({
          'date': date,
          'hasShift': false,
          'worked': false,
          'hasApprovedShift': false,
          'hasNonApprovedShift': false,
          'shift': '',
        });
      }
    }
    
    return schedule;
  }
  
  @override
  Widget build(BuildContext context) {
    // Calculate work duration if currently working
    Duration workDuration = Duration.zero;
    // This would be calculated from actual shift data when available
    
    return RefreshIndicator(
      onRefresh: () async {
        // Clear all cached data and refresh from current month
        setState(() {
          allShiftCardsData.clear();
          _monthlyOverviewCache.clear();
          _monthlyCardsCache.clear();
          _loadedMonths.clear();
        });
        await _fetchMonthData(centerDate);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Compact Hero Section with real data
            _buildCompactHeroSection(workDuration),
            
            const SizedBox(height: TossSpacing.space4),
            
            // QR Scan Button
            _buildQRScanButton(),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Week Schedule View
          _buildWeekScheduleView(),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Today Activity - filtered by selected date
          _buildRecentActivity(),
          
            const SizedBox(height: TossSpacing.space8),
          ],
        ),
      ),
    );
  }
  
  // Copy all the build methods from AttendancePage
  Widget _buildCompactHeroSection(Duration workDuration) {
    // Show loading state
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TossColors.primary.withValues(alpha: 0.05),
                TossColors.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    
    // Show error state if there's an error
    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            errorMessage!,
            style: TossTextStyles.body.copyWith(color: TossColors.error),
          ),
        ),
      );
    }
    
    // If no data yet, show empty state
    if (shiftOverviewData == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              'No data available',
              style: TossTextStyles.body.copyWith(color: TossColors.gray600),
            ),
          ),
        ),
      );
    }
    
    // Parse data from the API response
    final requestMonth = shiftOverviewData!['request_month'] ?? '';
    final actualWorkDays = shiftOverviewData!['actual_work_days'] ?? 0;
    final actualWorkHours = (shiftOverviewData!['actual_work_hours'] ?? 0).toDouble();
    final estimatedSalary = shiftOverviewData!['estimated_salary'] ?? '0';
    final currencySymbol = shiftOverviewData!['currency_symbol'] ?? '₩';
    final salaryAmount = (shiftOverviewData!['salary_amount'] ?? 0).toDouble();
    final lateDeductionTotal = shiftOverviewData!['late_deduction_total'] ?? 0;
    final overtimeTotal = shiftOverviewData!['overtime_total'] ?? 0;
    
    // Calculate total unique shifts from the shift cards data for the current month
    print('MonthlyOverview: currentDisplayedMonth = $currentDisplayedMonth');
    print('MonthlyOverview: allShiftCardsData has ${allShiftCardsData.length} total items');
    
    final currentMonthShifts = allShiftCardsData.where((card) {
      final requestDate = card['request_date'] ?? '';
      return requestDate.startsWith(currentDisplayedMonth ?? '');
    }).toList();
    
    print('MonthlyOverview: currentMonthShifts for $currentDisplayedMonth has ${currentMonthShifts.length} items');
    final totalShifts = currentMonthShifts.length;
    
    // Parse month and year from request_month (format: "2025-08")
    String monthDisplay = 'Current Month';
    if (requestMonth.isNotEmpty) {
      final parts = requestMonth.split('-');
      if (parts.length == 2) {
        final year = parts[0];
        final month = int.tryParse(parts[1]) ?? DateTime.now().month;
        final monthNames = ['January', 'February', 'March', 'April', 'May', 'June',
                           'July', 'August', 'September', 'October', 'November', 'December'];
        monthDisplay = '${monthNames[month - 1]} $year';
      }
    }
    
    // Toss-style overview section
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TossColors.primary.withValues(alpha: 0.08),
              TossColors.primary.withValues(alpha: 0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Month and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        monthDisplay,
                        style: TossTextStyles.h2.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      Text(
                        'Monthly Overview',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.surface.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isWorking ? TossColors.success : TossColors.gray400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          isWorking ? 'Working' : 'Off Duty',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: TossSpacing.space6),
              
              // Stats Grid - 2x2 layout
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: TossColors.primary,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Total Shifts',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                totalShifts.toString(),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'shifts',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.info.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: TossColors.info,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Total Hours',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                actualWorkHours.toStringAsFixed(1),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'hrs',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: TossSpacing.space3),
              
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.success.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                size: 18,
                                color: TossColors.success,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Overtime',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                overtimeTotal.toString(),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'min',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.warning.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_down,
                                size: 18,
                                color: TossColors.warning,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Late Deduct',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                lateDeductionTotal.toString(),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'min',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: TossSpacing.space5),
              
              // Estimated Salary Card
              Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.surface.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space2),
                          decoration: BoxDecoration(
                            color: TossColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet,
                            size: 20,
                            color: TossColors.primary,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        Text(
                          'Estimated Salary',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            '${currencySymbol}${estimatedSalary}',
                            style: TossTextStyles.display.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                            ),
                          ),
                        ),
                        if (overtimeTotal > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: TossSpacing.space1,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '+${currencySymbol}${(overtimeTotal * salaryAmount / 60).toStringAsFixed(0)}',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (overtimeTotal > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: TossSpacing.space1),
                        child: Text(
                          'overtime bonus',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: TossSpacing.space5),
              
              // QR Scan Button
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildQRScanButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Material(
        color: TossColors.primary,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () async {
                    HapticFeedback.mediumImpact();
                    
                    // Check today's shifts
                    final today = DateTime.now();
                    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
                    
                    // Filter cards data for today
                    final todayShifts = allShiftCardsData.where((card) {
                      return card['request_date'] == todayStr;
                    }).toList();
                    
                    // Check if there are any shifts today
                    if (todayShifts.isEmpty) {
                      // No shifts today
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: TossColors.warning,
                                size: 24,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'No Shift Today',
                                style: TossTextStyles.h3.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            'You don\'t have any scheduled shifts for today.',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'OK',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    
                    // Check if at least one shift is approved
                    final hasApprovedShift = todayShifts.any((card) {
                      return card['is_approved'] ?? false;
                    });
                    
                    if (!hasApprovedShift) {
                      // All shifts are not approved
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: TossColors.warning,
                                size: 24,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Schedule Not Approved',
                                style: TossTextStyles.h3.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            'Your schedule for today has not been approved yet. Please wait for approval before checking in.',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'OK',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    
                    // At least one shift is approved - proceed with QR scanning
                    print('Ready to scan QR - Found ${todayShifts.length} shift(s) for today, at least one is approved');
                    
                    // Navigate to QR scanner page
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRScannerPage(),
                      ),
                    );
                    
                    // If successfully checked in/out, refresh the data
                    if (result == true) {
                      _fetchMonthData(selectedDate);
                      // Refresh the shift overview as well
                      ref.read(shiftOverviewProvider.notifier).refresh();
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          'Scan QR',
                          style: TossTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
  }
  
  
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String label,
    required String value,
    required String suffix,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: iconColor,
              ),
              const SizedBox(width: TossSpacing.space1),
              Expanded(
                child: Text(
                  label,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: TossSpacing.space1),
              Text(
                suffix,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeekScheduleView() {
    // Calculate centered week schedule based on selected date
    // Always show 7 days with selected date in the center (position 3)
    final centeredWeekSchedule = <Map<String, dynamic>>[];
    
    // Start from 3 days before selected date
    for (int i = -3; i <= 3; i++) {
      final date = selectedDate.add(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Check if this date has any shift data
      final hasData = allShiftCardsData.any((card) => card['request_date'] == dateStr);
      final dayCards = allShiftCardsData.where((card) => card['request_date'] == dateStr).toList();
      
      // Check approval status
      bool hasApprovedShift = false;
      bool hasNonApprovedShift = false;
      if (dayCards.isNotEmpty) {
        hasApprovedShift = dayCards.any((card) => card['is_approved'] == true);
        hasNonApprovedShift = dayCards.any((card) => card['is_approved'] != true);
      }
      
      centeredWeekSchedule.add({
        'date': date,
        'hasShift': hasData,
        'hasApprovedShift': hasApprovedShift,
        'hasNonApprovedShift': hasNonApprovedShift,
      });
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Week Schedule',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              // View Calendar Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _showCalendarBottomSheet();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 18,
                          color: TossColors.gray600,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          'View Calendar',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Week Days
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(centeredWeekSchedule.length, (index) {
                final schedule = centeredWeekSchedule[index];
                final date = schedule['date'] as DateTime;
                final hasShift = schedule['hasShift'] as bool;
                final hasApprovedShift = schedule['hasApprovedShift'] ?? false;
                final hasNonApprovedShift = schedule['hasNonApprovedShift'] ?? false;
                final isSelected = date.day == selectedDate.day && 
                                 date.month == selectedDate.month && 
                                 date.year == selectedDate.year;
                final isToday = date.day == DateTime.now().day && 
                               date.month == DateTime.now().month && 
                               date.year == DateTime.now().year;
                
                // Weekday names
                final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                final weekdayName = weekdays[date.weekday % 7];
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      // Check if the date is in a different month
                      final currentMonth = selectedDate.month;
                      final currentYear = selectedDate.year;
                      final newMonth = date.month;
                      final newYear = date.year;
                      
                      setState(() {
                        selectedDate = date;
                        centerDate = date;
                      });
                      HapticFeedback.selectionClick();
                      
                      // If month changed, fetch data for the new month
                      if (currentMonth != newMonth || currentYear != newYear) {
                        print('Week schedule date clicked: Month changed from $currentYear-$currentMonth to $newYear-$newMonth');
                        await _fetchMonthData(date);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space3,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? TossColors.primary 
                          : isToday 
                            ? TossColors.surface
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: isToday && !isSelected
                          ? Border.all(
                              color: TossColors.gray200,
                              width: 1,
                            )
                          : null,
                        // Add subtle shadow for selected date
                        boxShadow: isSelected 
                          ? [
                              BoxShadow(
                                color: TossColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Weekday
                          Text(
                            weekdayName,
                            style: TossTextStyles.caption.copyWith(
                              color: isSelected 
                                ? TossColors.surface 
                                : TossColors.gray500,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          // Day number
                          Text(
                            date.day.toString(),
                            style: TossTextStyles.h3.copyWith(
                              color: isSelected 
                                ? TossColors.surface 
                                : TossColors.gray900,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          // Status indicator
                          if (hasShift)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: hasApprovedShift
                                  ? (isSelected ? TossColors.surface : TossColors.success)
                                  : (isSelected ? TossColors.surface : TossColors.warning),
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            Text(
                              'off',
                              style: TossTextStyles.caption.copyWith(
                                color: isSelected 
                                  ? TossColors.surface.withValues(alpha: 0.8)
                                  : TossColors.gray400,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentActivity() {
    // Filter activities for the selected date
    final selectedDateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    
    print('_buildRecentActivity: Filtering for selected date: $selectedDateStr');
    print('_buildRecentActivity: allShiftCardsData has ${allShiftCardsData.length} items');
    
    // Filter cards for the selected date only
    final selectedDateCards = allShiftCardsData.where((card) {
      final cardDate = card['request_date'] ?? '';
      return cardDate == selectedDateStr;
    }).toList();
    
    print('_buildRecentActivity: Found ${selectedDateCards.length} cards for $selectedDateStr');
    
    // Sort by shift_request_id or any other relevant field
    selectedDateCards.sort((a, b) {
      final idA = a['shift_request_id'] ?? '';
      final idB = b['shift_request_id'] ?? '';
      return idA.compareTo(idB);
    });
    
    final recentActivities = selectedDateCards
      .map((card) {
        // Parse date
        final dateStr = card['request_date'] ?? '';
        final dateParts = dateStr.split('-');
        final date = dateParts.length == 3 
          ? DateTime(
              int.parse(dateParts[0]), 
              int.parse(dateParts[1]), 
              int.parse(dateParts[2])
            )
          : DateTime.now();
        
        // Parse times - use confirm_start_time and confirm_end_time
        final actualStart = card['confirm_start_time'];
        final actualEnd = card['confirm_end_time'];
        String checkInTime = '--:--';
        String checkOutTime = '--:--';
        String hoursWorked = '0h 0m';
        
        if (actualStart != null && actualStart.toString().isNotEmpty) {
          try {
            // If it's just a time (HH:mm:ss), extract hours and minutes
            if (actualStart.toString().contains(':') && !actualStart.toString().contains('T')) {
              final timeParts = actualStart.toString().split(':');
              if (timeParts.length >= 2) {
                checkInTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
              }
            } else {
              // It's a full datetime string
              final startTime = DateTime.parse(actualStart.toString());
              checkInTime = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
            }
          } catch (e) {
            print('Error parsing start time: $actualStart - $e');
            checkInTime = actualStart.toString().substring(0, 5); // Try to get first 5 chars (HH:mm)
          }
        }
        
        if (actualEnd != null && actualEnd.toString().isNotEmpty) {
          try {
            // If it's just a time (HH:mm:ss), extract hours and minutes
            if (actualEnd.toString().contains(':') && !actualEnd.toString().contains('T')) {
              final timeParts = actualEnd.toString().split(':');
              if (timeParts.length >= 2) {
                checkOutTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
              }
            } else {
              // It's a full datetime string
              final endTime = DateTime.parse(actualEnd.toString());
              checkOutTime = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
            }
            
            // Calculate hours worked if we have both times
            if (actualStart != null && actualStart.toString().isNotEmpty) {
              try {
                // Parse the request_date and combine with times to get full DateTime
                final baseDate = date;
                
                // Parse start time
                DateTime startDateTime;
                if (actualStart.toString().contains('T')) {
                  startDateTime = DateTime.parse(actualStart.toString());
                } else {
                  final startParts = actualStart.toString().split(':');
                  startDateTime = DateTime(
                    baseDate.year, 
                    baseDate.month, 
                    baseDate.day,
                    int.parse(startParts[0]),
                    int.parse(startParts[1]),
                  );
                }
                
                // Parse end time
                DateTime endDateTime;
                if (actualEnd.toString().contains('T')) {
                  endDateTime = DateTime.parse(actualEnd.toString());
                } else {
                  final endParts = actualEnd.toString().split(':');
                  endDateTime = DateTime(
                    baseDate.year, 
                    baseDate.month, 
                    baseDate.day,
                    int.parse(endParts[0]),
                    int.parse(endParts[1]),
                  );
                  
                  // If end time is before start time, it's the next day
                  if (endDateTime.isBefore(startDateTime)) {
                    endDateTime = endDateTime.add(const Duration(days: 1));
                  }
                }
                
                final duration = endDateTime.difference(startDateTime);
                final hours = duration.inHours;
                final minutes = duration.inMinutes % 60;
                hoursWorked = '${hours}h ${minutes}m';
              } catch (e) {
                print('Error calculating work duration: $e');
              }
            }
          } catch (e) {
            print('Error parsing end time: $actualEnd - $e');
            checkOutTime = actualEnd.toString().substring(0, 5); // Try to get first 5 chars (HH:mm)
          }
        }
        
        // Check if shift is approved and reported
        final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
        final isReported = card['is_reported'] ?? false;
        
        return {
          'date': date,
          'checkIn': checkInTime,
          'checkOut': checkOutTime,
          'hours': hoursWorked,
          'store': card['store_name'] ?? 'Store',
          'status': actualEnd != null ? 'completed' : 'in_progress',
          'lateMinutes': card['late_minutes'] ?? 0,
          'overtimeMinutes': card['overtime_minutes'] ?? 0,
          'isApproved': isApproved,
          'isReported': isReported,
          'rawCard': card, // Keep the raw card data for debugging
        };
      }).toList();
    
    // Toss-style activity section - Minimalist design
    if (recentActivities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Activity',
              style: TossTextStyles.labelLarge.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            // Empty state - Simple and clean
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space6,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 32,
                      color: TossColors.gray400,
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    Text(
                      'No activity',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple header with View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // View All Button - Subtle text button
              GestureDetector(
                onTap: () {
                  _showAllAttendanceHistory();
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  child: Text(
                    'View All',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          // Activity List - Clean card design
          Container(
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TossColors.gray100,
                width: 1,
              ),
            ),
            child: Column(
              children: recentActivities.asMap().entries.map((entry) {
                final index = entry.key;
                final activity = entry.value;
                final date = activity['date'] as DateTime;
                final isLast = index == recentActivities.length - 1;
                
                return Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _showActivityDetails(activity);
                          HapticFeedback.selectionClick();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(TossSpacing.space4),
                          child: Row(
                            children: [
                              // Time info - Simplified
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Main time display - Show both confirm times
                                    Row(
                                      children: [
                                        Text(
                                          activity['checkIn'] as String,
                                          style: TossTextStyles.body.copyWith(
                                            color: activity['checkIn'] == '--:--' 
                                              ? TossColors.gray400 
                                              : TossColors.gray900,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          ' → ',
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray400,
                                          ),
                                        ),
                                        Text(
                                          activity['checkOut'] as String,
                                          style: TossTextStyles.body.copyWith(
                                            color: activity['checkOut'] == '--:--' 
                                              ? TossColors.gray400 
                                              : TossColors.gray900,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: TossSpacing.space1),
                                    // Store name
                                    Text(
                                      activity['store'] as String,
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Duration and status
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Duration
                                  Text(
                                    activity['hours'] as String,
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: TossSpacing.space1),
                                  // Status indicators
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Approval status
                                      Row(
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: (activity['isApproved'] as bool)
                                                  ? TossColors.success
                                                  : TossColors.warning,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: TossSpacing.space1),
                                          Text(
                                            (activity['isApproved'] as bool) ? 'Approved' : 'Pending',
                                            style: TossTextStyles.caption.copyWith(
                                              color: TossColors.gray600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Reported status if applicable
                                      if (activity['isReported'] as bool) ...[
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.flag,
                                              size: 10,
                                              color: TossColors.error,
                                            ),
                                            const SizedBox(width: TossSpacing.space1),
                                            Text(
                                              'Reported',
                                              style: TossTextStyles.caption.copyWith(
                                                color: TossColors.error,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              // Chevron
                              const SizedBox(width: TossSpacing.space3),
                              Icon(
                                Icons.chevron_right,
                                color: TossColors.gray300,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Divider between items
                    if (!isLast)
                      Container(
                        height: 1,
                        color: TossColors.gray100,
                        margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  String _getWeekdayShort(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
  
  void _showAllAttendanceHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar - Toss style
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space2),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            
            // Header - Minimalist
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space5,
                vertical: TossSpacing.space4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Activity',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space2),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: TossColors.gray600,
                      ),
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
            
            // History List - Clean Toss style
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
                itemCount: allShiftCardsData.length,
                itemBuilder: (context, index) {
                  final card = allShiftCardsData[index];
                  
                  // Parse date
                  final dateStr = card['request_date'] ?? '';
                  final dateParts = dateStr.split('-');
                  final date = dateParts.length == 3 
                    ? DateTime(
                        int.parse(dateParts[0]), 
                        int.parse(dateParts[1]), 
                        int.parse(dateParts[2])
                      )
                    : DateTime.now();
                  
                  // Parse times
                  final actualStart = card['confirm_start_time'];
                  final actualEnd = card['confirm_end_time'];
                  String checkInTime = '--:--';
                  String checkOutTime = '--:--';
                  String hoursWorked = '0h 0m';
                  
                  if (actualStart != null && actualStart.toString().isNotEmpty) {
                    try {
                      if (actualStart.toString().contains(':')) {
                        final timeParts = actualStart.toString().split(':');
                        if (timeParts.length >= 2) {
                          checkInTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
                        }
                      }
                    } catch (e) {
                      checkInTime = '--:--';
                    }
                  }
                  
                  if (actualEnd != null && actualEnd.toString().isNotEmpty) {
                    try {
                      if (actualEnd.toString().contains(':')) {
                        final timeParts = actualEnd.toString().split(':');
                        if (timeParts.length >= 2) {
                          checkOutTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
                        }
                      }
                      
                      // Calculate hours worked
                      if (actualStart != null && actualEnd != null) {
                        try {
                          final startParts = actualStart.toString().split(':');
                          final endParts = actualEnd.toString().split(':');
                          if (startParts.length >= 2 && endParts.length >= 2) {
                            final startHour = int.parse(startParts[0]);
                            final startMin = int.parse(startParts[1]);
                            final endHour = int.parse(endParts[0]);
                            final endMin = int.parse(endParts[1]);
                            
                            var totalMinutes = (endHour * 60 + endMin) - (startHour * 60 + startMin);
                            if (totalMinutes < 0) totalMinutes += 24 * 60; // Handle overnight shifts
                            
                            final hours = totalMinutes ~/ 60;
                            final minutes = totalMinutes % 60;
                            hoursWorked = '${hours}h ${minutes}m';
                          }
                        } catch (e) {
                          // Keep default
                        }
                      }
                    } catch (e) {
                      checkOutTime = '--:--';
                    }
                  }
                  
                  final isApproved = card['is_approved'] ?? false;
                  final isReported = card['is_reported'] ?? false;
                  final storeName = card['store_name'] ?? 'Store';
                  
                  // Check if this is first item or if month changed
                  bool showMonthHeader = false;
                  String monthHeader = '';
                  if (index == 0) {
                    showMonthHeader = true;
                    monthHeader = '${_getMonthName(date.month)} ${date.year}';
                  } else {
                    final prevCard = allShiftCardsData[index - 1];
                    final prevDateStr = prevCard['request_date'] ?? '';
                    final prevDateParts = prevDateStr.split('-');
                    if (prevDateParts.length == 3) {
                      final prevMonth = int.parse(prevDateParts[1]);
                      if (prevMonth != date.month) {
                        showMonthHeader = true;
                        monthHeader = '${_getMonthName(date.month)} ${date.year}';
                      }
                    }
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month header if needed
                      if (showMonthHeader) ...[
                        if (index > 0) const SizedBox(height: TossSpacing.space4),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space1,
                            vertical: TossSpacing.space2,
                          ),
                          child: Text(
                            monthHeader,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space2),
                      ],
                      
                      // Activity Card - Clean Toss style
                      Container(
                        margin: const EdgeInsets.only(bottom: TossSpacing.space2),
                        decoration: BoxDecoration(
                          color: TossColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: TossColors.gray100,
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // Create activity object and show details
                              final activity = {
                                'date': date,
                                'checkIn': checkInTime,
                                'checkOut': checkOutTime,
                                'hours': hoursWorked,
                                'store': storeName,
                                'status': actualEnd != null ? 'completed' : 'in_progress',
                                'isApproved': isApproved,
                                'rawCard': card,
                              };
                              Navigator.pop(context); // Close bottom sheet
                              _showActivityDetails(activity);
                              HapticFeedback.selectionClick();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(TossSpacing.space3),
                              child: Row(
                                children: [
                                  // Date - Compact
                                  Container(
                                    width: 44,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          date.day.toString(),
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray900,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          _getWeekdayShort(date.weekday),
                                          style: TossTextStyles.caption.copyWith(
                                            color: TossColors.gray500,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Vertical divider
                                  Container(
                                    height: 32,
                                    width: 1,
                                    color: TossColors.gray100,
                                    margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                                  ),
                                  
                                  // Time and Store
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Time display - Always show both times
                                        Row(
                                          children: [
                                            Text(
                                              checkInTime,
                                              style: TossTextStyles.bodySmall.copyWith(
                                                color: checkInTime == '--:--' 
                                                  ? TossColors.gray400 
                                                  : TossColors.gray900,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              ' → ',
                                              style: TossTextStyles.bodySmall.copyWith(
                                                color: TossColors.gray400,
                                              ),
                                            ),
                                            Text(
                                              checkOutTime,
                                              style: TossTextStyles.bodySmall.copyWith(
                                                color: checkOutTime == '--:--' 
                                                  ? TossColors.gray400 
                                                  : TossColors.gray900,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        // Store
                                        Text(
                                          storeName,
                                          style: TossTextStyles.caption.copyWith(
                                            color: TossColors.gray500,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Duration and status
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Duration
                                      Text(
                                        hoursWorked,
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      // Status badges
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          // Approval status
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: TossSpacing.space2,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isApproved
                                                  ? TossColors.success.withValues(alpha: 0.1)
                                                  : TossColors.warning.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 4,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    color: isApproved
                                                        ? TossColors.success
                                                        : TossColors.warning,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  isApproved ? 'Approved' : 'Pending',
                                                  style: TossTextStyles.caption.copyWith(
                                                    color: isApproved
                                                        ? TossColors.success
                                                        : TossColors.warning,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Reported status if applicable
                                          if (isReported) ...[
                                            const SizedBox(height: 4),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: TossSpacing.space2,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: TossColors.error.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.flag,
                                                    size: 10,
                                                    color: TossColors.error,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    'Reported',
                                                    style: TossTextStyles.caption.copyWith(
                                                      color: TossColors.error,
                                                      fontSize: 10,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showQRScanner(bool isWorking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Text(
                isWorking ? 'Check Out' : 'Check In',
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
            // QR Scanner Area (Mock)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(TossSpacing.space5),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 80,
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Point at store QR code',
                        style: TossTextStyles.body.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                children: [
                  Text(
                    'Store A, Gangnam',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    'Time: ${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Cancel Button
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  ),
                  child: Text(
                    'Cancel',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showCalendarBottomSheet() {
    // Initialize with the currently selected date from the main state
    DateTime modalSelectedDate = selectedDate;
    DateTime modalFocusedDate = selectedDate;
    List<Map<String, dynamic>> modalShiftData = List.from(allShiftCardsData);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        // Use StatefulBuilder to ensure the modal rebuilds when parent state changes
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return _CalendarBottomSheet(
              initialSelectedDate: modalSelectedDate,
              initialFocusedDate: modalFocusedDate,
              allShiftCardsData: modalShiftData,
              onFetchMonthData: (DateTime date) async {
                // Call _fetchMonthData which will check if month is already loaded
                await _fetchMonthData(date);
                // Update the modal's local copy of shift data with the new data
                setModalState(() {
                  modalShiftData = List.from(allShiftCardsData);
                });
              },
              onNavigateToDate: (DateTime date) {
                _navigateToDate(date);
                // Update modal's selected date and refresh data
                setModalState(() {
                  modalSelectedDate = date;
                  modalFocusedDate = date;
                  modalShiftData = List.from(allShiftCardsData);
                });
              },
              parentSetState: () {
                if (mounted) {
                  setState(() {});
                  // Also update modal state with fresh data
                  setModalState(() {
                    modalShiftData = List.from(allShiftCardsData);
                  });
                }
              },
            );
          },
        );
      },
    );
  }
  
  Widget _buildCalendarGrid(DateTime focusedDate, DateTime selectedDate, Function(DateTime) onDateSelected, [List<Map<String, dynamic>>? shiftCardsData]) {
    return _buildCalendarGridStatic(focusedDate, selectedDate, onDateSelected, shiftCardsData ?? allShiftCardsData);
  }
  
  static Widget _buildCalendarGridStatic(DateTime focusedDate, DateTime selectedDate, Function(DateTime) onDateSelected, [List<Map<String, dynamic>>? shiftCardsData]) {
    // Use the passed shiftCardsData if available
    final shiftsData = shiftCardsData ?? [];
    
    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final lastDayOfMonth = DateTime(focusedDate.year, focusedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;
    
    print('_buildCalendarGrid: Building calendar for ${focusedDate.year}-${focusedDate.month}');
    print('_buildCalendarGrid: shiftsData has ${shiftsData.length} total items');
    
    List<Widget> calendarDays = [];
    
    // Week day headers
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (final day in weekDays) {
      calendarDays.add(
        Center(
          child: Text(
            day,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
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
    
    // Days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(focusedDate.year, focusedDate.month, day);
      final isSelected = selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day;
      final isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;
      
      // Get shift data for this date
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Check if there are any shifts for this date in shiftsData
      final shiftsForDate = shiftsData.where(
        (card) => card['request_date'] == dateStr,
      ).toList();
      
      if (day == 1 || day == 31) {  // Debug first and last day of month
        print('_buildCalendarGrid: Date $dateStr has ${shiftsForDate.length} shifts');
      }
      
      final hasShift = shiftsForDate.isNotEmpty;
      
      // Check approval status for shifts
      final hasApprovedShift = hasShift && shiftsForDate.any((card) => 
        card['is_approved'] ?? card['approval_status'] == 'approved' ?? false
      );
      final hasNonApprovedShift = hasShift && shiftsForDate.any((card) => 
        !(card['is_approved'] ?? card['approval_status'] == 'approved' ?? false)
      );
      
      calendarDays.add(
        InkWell(
          onTap: () => onDateSelected(date),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isToday && !isSelected
                    ? TossColors.primary
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    day.toString(),
                    style: TossTextStyles.body.copyWith(
                      color: isSelected
                          ? Colors.white
                          : TossColors.gray900,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (hasShift)
                  Positioned(
                    bottom: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Show green dot for approved shifts
                        if (hasApprovedShift)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : TossColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                        // Add spacing if both types exist
                        if (hasApprovedShift && hasNonApprovedShift)
                          const SizedBox(width: 2),
                        // Show orange dot for non-approved shifts
                        if (hasNonApprovedShift)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : TossColors.warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: GridView.count(
        crossAxisCount: 7,
        children: calendarDays,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
  }

  void _showActivityDetails(Map<String, dynamic> activity) {
    // Get the raw card data which contains all the shift information
    final cardData = activity['rawCard'] as Map<String, dynamic>?;
    if (cardData == null) {
      return;
    }
    
    // Parse date for better display
    final dateStr = cardData['request_date'] ?? '';
    final dateParts = dateStr.split('-');
    final date = dateParts.length == 3 
      ? DateTime(
          int.parse(dateParts[0]), 
          int.parse(dateParts[1]), 
          int.parse(dateParts[2])
        )
      : DateTime.now();
    
    // Get currency symbol from shift overview data
    final currencySymbol = shiftOverviewData?['currency_symbol'] ?? 'VND';
    
    // Parse shift time
    String shiftTime = cardData['shift_time'] ?? '09:00 ~ 17:00';
    shiftTime = shiftTime.replaceAll('~', ' ~ ');
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar - Toss style (thinner)
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray200,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            
            // Title - Centered with better weight
            Text(
              'Shift Details',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: TossSpacing.space5),
            
            // Content with scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Section - Clean rows without Store
                    _buildInfoRow('Date', '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'),
                    const SizedBox(height: TossSpacing.space4),
                    
                    _buildInfoRow('Shift Time', shiftTime),
                    const SizedBox(height: TossSpacing.space4),
                    
                    // Approval Status with clean text (no badge)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Approval Status',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                        Text(
                          (cardData['is_approved'] ?? false) ? 'Approved' : 'Pending',
                          style: TossTextStyles.body.copyWith(
                            color: (cardData['is_approved'] ?? false)
                                ? TossColors.success
                                : TossColors.gray500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    
                    // Late info if exists
                    if ((cardData['is_late'] ?? false) || (cardData['late_minutes'] ?? 0) > 0) ...[
                      const SizedBox(height: TossSpacing.space4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Late',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.error,
                            ),
                          ),
                          Text(
                            '${cardData['late_minutes'] ?? 0} minutes',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: TossSpacing.space6),
                    
                    // Actual Attendance Section
                    Text(
                      'Actual Attendance',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    
                    _buildInfoRow('Actual Check-in', _formatTime(cardData['actual_start_time'])),
                    const SizedBox(height: TossSpacing.space3),
                    _buildInfoRow('Actual Check-out', _formatTime(cardData['actual_end_time'])),
                    
                    const SizedBox(height: TossSpacing.space4),
                    
                    // Hours Section
                    _buildInfoRow('Scheduled Hours', '${cardData['scheduled_hours'] ?? 0.0} hours'),
                    const SizedBox(height: TossSpacing.space3),
                    _buildInfoRow('Paid Hours', '${cardData['paid_hours'] ?? 0} hours'),
                    
                    const SizedBox(height: TossSpacing.space4),
                    
                    // Salary information
                    _buildInfoRow('Salary Type', cardData['salary_type'] ?? 'hourly'),
                    const SizedBox(height: TossSpacing.space3),
                    _buildInfoRow('Salary per Hour', '$currencySymbol${_formatNumber(cardData['salary_amount'] ?? 0)}'),
                    
                    const SizedBox(height: TossSpacing.space6),
                    
                    // Confirmed Attendance - Simpler design with light background
                    Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.info.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirmed Attendance',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Check-in',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                              Text(
                                _formatTime(cardData['confirm_start_time']),
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Check-out',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                              Text(
                                _formatTime(cardData['confirm_end_time']),
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: TossSpacing.space6),
                    
                    // Divider
                    Container(
                      height: 1,
                      color: TossColors.gray100,
                    ),
                    
                    const SizedBox(height: TossSpacing.space4),
                    
                    // Total Pay - More prominent
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pay',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$currencySymbol${_formatNumber(cardData['total_pay_with_bonus'] ?? '0')}',
                          style: TossTextStyles.h2.copyWith(
                            color: TossColors.info,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
              
                    
                    const SizedBox(height: TossSpacing.space5),
                    
                    // Show reported status if already reported
                    if (cardData['is_reported'] ?? false) ...[
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.warning.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: TossColors.warning.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: TossColors.warning,
                              size: 20,
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Issue Reported',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.warning,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    (cardData['is_problem_solved'] ?? false)
                                        ? 'Your report has been resolved'
                                        : 'Your report is being reviewed',
                                    style: TossTextStyles.bodySmall.copyWith(
                                      color: TossColors.gray600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space5),
                    ],
                    
                    // Report Issue Button - Toss style with better visibility
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: (cardData['is_reported'] ?? false) || !(cardData['is_approved'] ?? false)
                            ? TossColors.gray50
                            : TossColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (cardData['is_reported'] ?? false) || !(cardData['is_approved'] ?? false)
                              ? TossColors.gray100
                              : TossColors.gray200,
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (cardData['is_reported'] ?? false) || !(cardData['is_approved'] ?? false)
                              ? null  // Disable if already reported OR not approved
                              : () async {
                          final shiftRequestId = cardData['shift_request_id'];
                          if (shiftRequestId == null) {
                            // Show error if no shift request ID
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Unable to report issue: Missing shift ID'),
                                backgroundColor: TossColors.error,
                              ),
                            );
                            return;
                          }
                          
                          HapticFeedback.selectionClick();
                          
                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                              child: Container(
                                padding: const EdgeInsets.all(TossSpacing.space4),
                                decoration: BoxDecoration(
                                  color: TossColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const CircularProgressIndicator(),
                              ),
                            ),
                          );
                          
                          // Call the service to report the issue
                          final service = ref.read(attendanceServiceProvider);
                          final success = await service.reportShiftIssue(
                            shiftRequestId: shiftRequestId,
                          );
                          
                          // Dismiss loading
                          Navigator.of(context).pop();
                          
                          if (success) {
                            // Update the local card data to reflect the change
                            cardData['is_reported'] = true;
                            cardData['is_problem_solved'] = false;
                            
                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Issue reported successfully'),
                                backgroundColor: TossColors.success,
                              ),
                            );
                            
                            // Close the modal after a short delay
                            Future.delayed(const Duration(milliseconds: 500), () {
                              Navigator.of(context).pop();
                            });
                            
                            // Refresh the main page data
                            _fetchMonthData(selectedDate);
                          } else {
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to report issue. Please try again.'),
                                backgroundColor: TossColors.error,
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space3,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flag_outlined,
                                size: 20,
                                color: (cardData['is_reported'] ?? false) || !(cardData['is_approved'] ?? false)
                                    ? TossColors.gray300
                                    : TossColors.gray600,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Report Issue',
                                style: TossTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: (cardData['is_reported'] ?? false) || !(cardData['is_approved'] ?? false)
                                      ? TossColors.gray300
                                      : TossColors.gray700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                    
                    const SizedBox(height: TossSpacing.space4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMinimalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCleanRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
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
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
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
  
  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false, Color? highlightColor, bool isSubtle = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: isHighlighted 
                  ? highlightColor 
                  : isSubtle 
                      ? TossColors.gray600 
                      : TossColors.gray700,
              fontSize: isSubtle ? 14 : null,
              fontWeight: isSubtle ? FontWeight.w500 : FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: isHighlighted 
                  ? highlightColor 
                  : isSubtle 
                      ? TossColors.gray600 
                      : TossColors.gray900,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
              fontSize: isSubtle ? 14 : null,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatNumber(dynamic value) {
    if (value == null) return '0';
    if (value is String) {
      // Remove any existing commas and try to parse
      final cleanValue = value.replaceAll(',', '');
      final parsed = int.tryParse(cleanValue);
      if (parsed != null) {
        return parsed.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
      }
      return value;
    }
    if (value is num) {
      return value.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return value.toString();
  }
  
  String _formatTime(dynamic time) {
    if (time == null || time.toString().isEmpty) {
      return '--:--';
    }
    
    final timeStr = time.toString();
    
    try {
      // If it's already in HH:mm format
      if (timeStr.contains(':') && !timeStr.contains('T')) {
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }
      
      // If it's a datetime string
      if (timeStr.contains('T') || timeStr.length > 10) {
        final dateTime = DateTime.parse(timeStr);
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
      
      // If it's just HH:mm:ss format, take first 5 chars
      if (timeStr.length >= 5) {
        return timeStr.substring(0, 5);
      }
      
      return timeStr;
    } catch (e) {
      // If all parsing fails, try to extract HH:mm from the string
      if (timeStr.length >= 5) {
        return timeStr.substring(0, 5);
      }
      return '--:--';
    }
  }

  void _navigateToDate(DateTime date) {
    print('_navigateToDate called with date: $date');
    setState(() {
      selectedDate = date;
    });
    _updateCenterDate(date);
  }
}

// Create a separate StatefulWidget for the calendar bottom sheet
class _CalendarBottomSheet extends StatefulWidget {
  final DateTime initialSelectedDate;
  final DateTime initialFocusedDate;
  final List<Map<String, dynamic>> allShiftCardsData;
  final Future<void> Function(DateTime) onFetchMonthData;
  final void Function(DateTime) onNavigateToDate;
  final VoidCallback parentSetState;

  const _CalendarBottomSheet({
    required this.initialSelectedDate,
    required this.initialFocusedDate,
    required this.allShiftCardsData,
    required this.onFetchMonthData,
    required this.onNavigateToDate,
    required this.parentSetState,
  });

  @override
  State<_CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<_CalendarBottomSheet> {
  late DateTime selectedDate;
  late DateTime focusedDate;
  List<Map<String, dynamic>> localShiftData = [];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialSelectedDate;
    focusedDate = widget.initialFocusedDate;
    localShiftData = List<Map<String, dynamic>>.from(widget.allShiftCardsData);
  }

  @override
  void didUpdateWidget(_CalendarBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local shift data when parent data changes
    if (widget.allShiftCardsData != oldWidget.allShiftCardsData) {
      setState(() {
        localShiftData = List<Map<String, dynamic>>.from(widget.allShiftCardsData);
      });
    }
  }

  void _updateFocusedMonth(DateTime newDate) async {
    // Update the focused date for calendar display
    setState(() {
      focusedDate = newDate;
    });
    
    // Fetch data for the new month if not already loaded
    await widget.onFetchMonthData(newDate);
    
    // Update parent state to reflect the new data
    widget.parentSetState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Date',
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          
          // Calendar
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.01),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Month Year Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: TossColors.gray100,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            final newDate = DateTime(
                              focusedDate.year,
                              focusedDate.month - 1,
                              1,
                            );
                            _updateFocusedMonth(newDate);
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                            color: TossColors.gray700,
                          ),
                        ),
                        Text(
                          '${_AttendanceContentState._getMonthName(focusedDate.month)} ${focusedDate.year}',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final newDate = DateTime(
                              focusedDate.year,
                              focusedDate.month + 1,
                              1,
                            );
                            _updateFocusedMonth(newDate);
                          },
                          icon: const Icon(
                            Icons.chevron_right,
                            color: TossColors.gray700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Calendar Grid - Use widget's shift data which gets updated via props
                  Expanded(
                    child: _AttendanceContentState._buildCalendarGridStatic(
                      focusedDate,
                      selectedDate,
                      (date) {
                        setState(() {
                          selectedDate = date;
                        });
                        HapticFeedback.selectionClick();
                        
                        // Check if this is a new month
                        final clickedMonthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
                        final currentMonthKey = '${focusedDate.year}-${focusedDate.month.toString().padLeft(2, '0')}';
                        
                        print('Calendar date clicked: $date');
                        print('Clicked month: $clickedMonthKey, Current focused month: $currentMonthKey');
                        
                        // Close the modal
                        Navigator.pop(context);
                        
                        // Navigate to the date (this will check if month changed and fetch if needed)
                        widget.onNavigateToDate(date);
                      },
                      widget.allShiftCardsData, // Use widget's data directly
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Selected Date Info
          if (selectedDate != null)
            Container(
              margin: const EdgeInsets.all(TossSpacing.space5),
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: TossColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.event,
                      size: 20,
                      color: TossColors.primary,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Selected Date',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${selectedDate.day} ${_AttendanceContentState._getMonthName(selectedDate.month)} ${selectedDate.year}',
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
            ),
        ],
      ),
    );
  }
}
