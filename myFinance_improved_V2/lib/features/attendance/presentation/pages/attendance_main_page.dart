import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../widgets/check_in_out/attendance_content.dart';
import '../widgets/shift_register/shift_register_tab.dart';

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
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
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
    return TossScaffold(
      backgroundColor: TossColors.background,
      appBar: const TossAppBar1(
        title: 'Attendance',
        backgroundColor: TossColors.background,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar Container
            Container(
              color: TossColors.background,
              child: Column(
                children: [
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
                            borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
                          ),
                        ),
                        // Tab Bar
                        TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: TossColors.background,
                            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                            boxShadow: [
                              BoxShadow(
                                color: TossColors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.all(TossSpacing.space1 / 2),
                          dividerColor: TossColors.transparent,
                          labelColor: TossColors.gray900,
                          unselectedLabelColor: TossColors.gray600,
                          labelStyle: TossTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          unselectedLabelStyle: TossTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          splashBorderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                          tabs: const [
                            Tab(
                              text: 'Check In/Out',
                              height: 44,
                            ),
                            Tab(
                              text: 'Register',
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
                  // First Tab - Check In/Out
                  const AttendanceContent(),
                  
                  // Second Tab - Register Shifts
                  _buildRegisterTab(),
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
