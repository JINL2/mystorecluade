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
  bool isExpanded = false;
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
                    
                    const SizedBox(height: TossSpacing.space4),
                    
                    // Monthly Summary (Collapsible)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                      child: _buildCollapsibleMonthlySummary(),
                    ),
                    
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
              TossColors.primary.withValues(alpha: 0.05),
              TossColors.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          boxShadow: TossShadows.shadow2,
        ),
        child: Column(
          children: [
            // Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isWorking ? 'Currently Working' : 'Not Working',
                      style: TossTextStyles.caption.copyWith(
                        color: isWorking ? TossColors.success : TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}',
                      style: TossTextStyles.h1.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray900,
                      ),
                    ),
                  ],
                ),
                if (isWorking)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: TossColors.success,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          '${workDuration.inHours}h ${workDuration.inMinutes % 60}m',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: TossSpacing.space4),
            
            // Today's Shift Info
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.store_outlined,
                    size: 20,
                    color: TossColors.gray700,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Store A · Today',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '09:00 - 18:00',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isWorking)
                    Text(
                      'Check In: ${checkInTime.hour.toString().padLeft(2, '0')}:${checkInTime.minute.toString().padLeft(2, '0')}',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
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
  
  Widget _buildWeekScheduleView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week Schedule',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
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
                                ? Colors.white.withValues(alpha: 0.7)
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
  
  Widget _buildCollapsibleMonthlySummary() {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
        HapticFeedback.selectionClick();
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          boxShadow: TossShadows.shadow1,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'This Month',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '₩2.4M',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.expand_more,
                    color: TossColors.gray600,
                    size: 24,
                  ),
                ),
              ],
            ),
            
            if (isExpanded) ...[
              const SizedBox(height: TossSpacing.space4),
              const Divider(color: TossColors.gray200, thickness: 1),
              const SizedBox(height: TossSpacing.space4),
              _buildSummaryRow('Days Worked', '15 / 22'),
              const SizedBox(height: TossSpacing.space3),
              _buildSummaryRow('Total Hours', '120h'),
              const SizedBox(height: TossSpacing.space3),
              _buildSummaryRow('Overtime', '12h'),
              const SizedBox(height: TossSpacing.space3),
              _buildSummaryRow('Attendance Rate', '95%', valueColor: TossColors.success),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
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
          style: TossTextStyles.body.copyWith(
            color: valueColor ?? TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
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
}