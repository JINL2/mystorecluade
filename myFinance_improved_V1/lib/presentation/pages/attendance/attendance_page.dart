import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_border_radius.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // Mock data
  final bool isWorking = true;
  final DateTime checkInTime = DateTime(2024, 11, 14, 9, 24);
  final DateTime currentTime = DateTime.now();
  int selectedDateIndex = 3; // Today (0 = 3 days ago, 3 = today, 6 = 3 days later)
  
  // Mock schedule data
  final List<Map<String, dynamic>> weekSchedule = [
    {'date': DateTime(2024, 11, 11), 'hasShift': true, 'worked': true, 'shift': '09:00-18:00'},
    {'date': DateTime(2024, 11, 12), 'hasShift': true, 'worked': true, 'shift': '09:00-18:00'},
    {'date': DateTime(2024, 11, 13), 'hasShift': true, 'worked': true, 'shift': '14:00-22:00'},
    {'date': DateTime(2024, 11, 14), 'hasShift': true, 'worked': false, 'shift': '09:00-18:00'}, // Today
    {'date': DateTime(2024, 11, 15), 'hasShift': true, 'worked': false, 'shift': '09:00-18:00'},
    {'date': DateTime(2024, 11, 16), 'hasShift': false, 'worked': false, 'shift': ''},
    {'date': DateTime(2024, 11, 17), 'hasShift': false, 'worked': false, 'shift': ''},
  ];
  
  @override
  Widget build(BuildContext context) {
    final workDuration = currentTime.difference(checkInTime);
    
    return Scaffold(
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Simple App Bar
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
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Compact Hero Section
                    _buildCompactHeroSection(workDuration),
                    
                    const SizedBox(height: TossSpacing.space4),
                    
                    // Week Schedule View
                    _buildWeekScheduleView(),
                    
                    const SizedBox(height: TossSpacing.space4),
                    
                    // Recent Activity
                    _buildRecentActivity(),
                    
                    const SizedBox(height: TossSpacing.space8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCompactHeroSection(Duration workDuration) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TossColors.primary.withOpacity(0.05),
              TossColors.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          boxShadow: TossShadows.shadow2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Overview Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'November 2024',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      'Monthly Overview',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // Current Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  decoration: BoxDecoration(
                    color: isWorking 
                      ? TossColors.success.withOpacity(0.1)
                      : TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isWorking ? Icons.circle : Icons.circle_outlined,
                        size: 8,
                        color: isWorking ? TossColors.success : TossColors.gray600,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        isWorking ? 'Working' : 'Off Duty',
                        style: TossTextStyles.caption.copyWith(
                          color: isWorking ? TossColors.success : TossColors.gray600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: TossSpacing.space5),
            
            // Monthly Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.calendar_today_outlined,
                    iconColor: TossColors.primary,
                    backgroundColor: TossColors.primary.withOpacity(0.1),
                    label: 'Total Shifts',
                    value: '35',
                    suffix: 'shifts',
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.access_time,
                    iconColor: TossColors.info,
                    backgroundColor: TossColors.info.withOpacity(0.1),
                    label: 'Total Hours',
                    value: '176',
                    suffix: 'hrs',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: TossSpacing.space3),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.trending_up,
                    iconColor: TossColors.success,
                    backgroundColor: TossColors.success.withOpacity(0.1),
                    label: 'Overtime',
                    value: '750',
                    suffix: 'min',
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.trending_down,
                    iconColor: TossColors.warning,
                    backgroundColor: TossColors.warning.withOpacity(0.1),
                    label: 'Late Deduct',
                    value: '15',
                    suffix: 'min',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: TossSpacing.space4),
            
            // Estimated Salary Card
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    TossColors.primary.withOpacity(0.15),
                    TossColors.primary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                border: Border.all(
                  color: TossColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 24,
                      color: TossColors.primary,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Salary',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₩2,485,000',
                          style: TossTextStyles.h2.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '+₩85,000',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'overtime bonus',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: TossSpacing.space4),
            
            // QR Scan Button
            SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _showQRScanner();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.primary,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: TossColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
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
                          isWorking ? 'Scan to Check Out' : 'Scan to Check In',
                          style: TossTextStyles.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This Week Schedule',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  _showCalendarBottomSheet();
                },
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: TossColors.gray700,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        'View Calendar',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          SizedBox(
            height: 85,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: weekSchedule.length,
              itemBuilder: (context, index) {
                final schedule = weekSchedule[index];
                final date = schedule['date'] as DateTime;
                final hasShift = schedule['hasShift'] as bool;
                final worked = schedule['worked'] as bool;
                final isToday = index == selectedDateIndex;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDateIndex = index;
                    });
                    HapticFeedback.selectionClick();
                  },
                  child: Container(
                    width: 65,
                    margin: EdgeInsets.only(
                      right: index < weekSchedule.length - 1 ? 6 : 0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isToday ? TossColors.primary : TossColors.surface,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(
                        color: isToday 
                          ? TossColors.primary 
                          : hasShift 
                            ? TossColors.gray200 
                            : Colors.transparent,
                        width: isToday ? 2 : 1,
                      ),
                      boxShadow: isToday ? TossShadows.shadow2 : TossShadows.shadow1,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getWeekdayShort(date.weekday),
                          style: TossTextStyles.caption.copyWith(
                            color: isToday ? Colors.white : TossColors.gray600,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space1),
                        Text(
                          date.day.toString(),
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: isToday ? Colors.white : TossColors.gray900,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (hasShift) 
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: worked 
                                ? TossColors.success 
                                : isToday 
                                  ? Colors.white 
                                  : TossColors.warning,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          Text(
                            'Off',
                            style: TossTextStyles.caption.copyWith(
                              color: isToday 
                                ? Colors.white.withOpacity(0.7)
                                : TossColors.gray400,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentActivity() {
    // Mock recent activity data
    final recentActivities = [
      {
        'date': DateTime(2024, 11, 13),
        'checkIn': '14:02',
        'checkOut': '22:05',
        'hours': '8h 3m',
        'store': 'Store A',
        'status': 'completed',
      },
      {
        'date': DateTime(2024, 11, 12),
        'checkIn': '09:01',
        'checkOut': '18:03',
        'hours': '9h 2m',
        'store': 'Store A',
        'status': 'completed',
      },
      {
        'date': DateTime(2024, 11, 11),
        'checkIn': '08:58',
        'checkOut': '17:59',
        'hours': '9h 1m',
        'store': 'Store A',
        'status': 'completed',
      },
    ];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full attendance history
                },
                child: Text(
                  'View All',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          Container(
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              boxShadow: TossShadows.shadow1,
            ),
            child: Column(
              children: recentActivities.asMap().entries.map((entry) {
                final index = entry.key;
                final activity = entry.value;
                final date = activity['date'] as DateTime;
                
                return Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    border: index < recentActivities.length - 1
                      ? const Border(
                          bottom: BorderSide(
                            color: TossColors.gray100,
                            width: 1,
                          ),
                        )
                      : null,
                  ),
                  child: Row(
                    children: [
                      // Date
                      SizedBox(
                        width: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getWeekdayShort(date.weekday),
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                            Text(
                              '${date.month}/${date.day}',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      // Time info
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.login,
                              size: 16,
                              color: TossColors.gray500,
                            ),
                            const SizedBox(width: TossSpacing.space1),
                            Text(
                              activity['checkIn'] as String,
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray700,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            const Icon(
                              Icons.logout,
                              size: 16,
                              color: TossColors.gray500,
                            ),
                            const SizedBox(width: TossSpacing.space1),
                            Text(
                              activity['checkOut'] as String,
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Duration
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: TossSpacing.space1,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: Text(
                          activity['hours'] as String,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
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
  
  void _showQRScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xxl),
            topRight: Radius.circular(TossBorderRadius.xxl),
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
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
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
                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
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
    DateTime selectedDate = DateTime.now();
    DateTime focusedDate = DateTime.now();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: TossColors.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(TossBorderRadius.xxl),
              topRight: Radius.circular(TossBorderRadius.xxl),
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
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
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
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    boxShadow: TossShadows.shadow1,
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
                                setState(() {
                                  focusedDate = DateTime(
                                    focusedDate.year,
                                    focusedDate.month - 1,
                                  );
                                });
                              },
                              icon: const Icon(
                                Icons.chevron_left,
                                color: TossColors.gray700,
                              ),
                            ),
                            Text(
                              '${_getMonthName(focusedDate.month)} ${focusedDate.year}',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  focusedDate = DateTime(
                                    focusedDate.year,
                                    focusedDate.month + 1,
                                  );
                                });
                              },
                              icon: const Icon(
                                Icons.chevron_right,
                                color: TossColors.gray700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Calendar Grid
                      Expanded(
                        child: _buildCalendarGrid(
                          focusedDate,
                          selectedDate,
                          (date) {
                            setState(() {
                              selectedDate = date;
                            });
                            HapticFeedback.selectionClick();
                          },
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
                    color: TossColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    border: Border.all(
                      color: TossColors.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space2),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
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
                          children: [
                            Text(
                              'Selected Date',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                            Text(
                              '${_getWeekdayFull(selectedDate.weekday)}, ${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Handle date selection - navigate to that date's attendance
                          _navigateToDate(selectedDate);
                        },
                        child: Text(
                          'View',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
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
  
  Widget _buildCalendarGrid(DateTime focusedDate, DateTime selectedDate, Function(DateTime) onDateSelected) {
    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final lastDayOfMonth = DateTime(focusedDate.year, focusedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;
    
    // Create calendar grid
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
      
      // Mock attendance data
      final hasShift = day % 7 != 0 && day % 7 != 6; // No shifts on weekends
      final isWorked = date.isBefore(DateTime.now()) && hasShift;
      
      calendarDays.add(
        InkWell(
          onTap: () => onDateSelected(date),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.primary.withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
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
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isWorked
                            ? TossColors.success
                            : isSelected
                                ? Colors.white
                                : TossColors.warning,
                        shape: BoxShape.circle,
                      ),
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
  
  String _getMonthName(int month) {
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
  
  void _navigateToDate(DateTime date) {
    // Navigate to the selected date's attendance details
    // For now, just update the selected date index if it's in the current week
    for (int i = 0; i < weekSchedule.length; i++) {
      final scheduleDate = weekSchedule[i]['date'] as DateTime;
      if (scheduleDate.year == date.year &&
          scheduleDate.month == date.month &&
          scheduleDate.day == date.day) {
        setState(() {
          selectedDateIndex = i;
        });
        break;
      }
    }
  }
}