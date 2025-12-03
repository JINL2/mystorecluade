import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../pages/attention_list_page.dart';
import 'attention_card.dart';
import 'shift_info_card.dart';

/// Overview Tab
///
/// Main overview tab showing:
/// - Store selector
/// - Currently Active shift with snapshot metrics
/// - Upcoming shift with staff grid
/// - Need Attention horizontal scroll
class OverviewTab extends ConsumerStatefulWidget {
  final String? selectedStoreId;
  final VoidCallback onStoreSelectorTap;

  const OverviewTab({
    super.key,
    required this.selectedStoreId,
    required this.onStoreSelectorTap,
  });

  @override
  ConsumerState<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends ConsumerState<OverviewTab> {
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final stores = _extractStores(appState.user);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1️⃣ Store Selector Dropdown (same as Schedule tab)
          _buildStoreSelector(stores),
          const SizedBox(height: TossSpacing.space6),

          // 2️⃣ Currently Active Section
          _buildSectionLabel('Currently Active'),
          const SizedBox(height: TossSpacing.space2),
          ShiftInfoCard(
            date: 'Tue, 18 Jun 2025',
            shiftName: 'Morning Shift',
            timeRange: '09:00 – 13:00',
            type: ShiftCardType.active,
            statusLabel: '2/4 arrived',
            statusType: ShiftStatusType.error,
            snapshotData: SnapshotData(
              onTime: SnapshotMetric(
                count: 2,
                employees: [
                  {
                    'user_name': 'Alex Rivera',
                    'profile_image': 'https://app.banani.co/avatar1.jpeg',
                  },
                  {
                    'user_name': 'Jamie Lee',
                    'profile_image': 'https://app.banani.co/avatar2.jpg',
                  },
                ],
              ),
              late: SnapshotMetric(
                count: 1,
                employees: [
                  {
                    'user_name': 'Taylor Kim',
                    'profile_image': 'https://app.banani.co/avatar3.jpeg',
                  },
                ],
              ),
              notCheckedIn: SnapshotMetric(
                count: 1,
                employees: [
                  {
                    'user_name': 'Jordan Park',
                    'profile_image': 'https://app.banani.co/avatar4.jpg',
                  },
                ],
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space6),

          // 3️⃣ Upcoming Section
          _buildSectionLabel('Upcoming'),
          const SizedBox(height: TossSpacing.space2),
          ShiftInfoCard(
            date: 'Tue, 18 Jun 2025',
            shiftName: 'Afternoon Shift',
            timeRange: '13:00 – 18:00',
            type: ShiftCardType.upcoming,
            statusLabel: '6/6 assigned',
            statusType: ShiftStatusType.neutral,
            staffList: [
              StaffMember(
                name: 'Alex Rivera',
                avatarUrl: 'https://app.banani.co/avatar1.jpeg',
              ),
              StaffMember(
                name: 'Jamie Lee',
                avatarUrl: 'https://app.banani.co/avatar2.jpg',
              ),
              StaffMember(
                name: 'Taylor Kim',
                avatarUrl: 'https://app.banani.co/avatar5.jpg',
              ),
              StaffMember(
                name: 'Jordan Park',
                avatarUrl: 'https://app.banani.co/avatar6.jpg',
              ),
              StaffMember(
                name: 'Sam Chen',
                avatarUrl: 'https://app.banani.co/avatar3.jpeg',
              ),
              StaffMember(
                name: 'Riley Johnson',
                avatarUrl: 'https://app.banani.co/avatar4.jpg',
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space6),

          // 4️⃣ Need Attention Section
          _buildNeedAttentionHeader(),
          const SizedBox(height: TossSpacing.space2),
          _buildNeedAttentionScroll(),
        ],
      ),
    );
  }

  /// Build section label
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TossTextStyles.labelMedium.copyWith(
        color: TossColors.gray600,
      ),
    );
  }

  /// Build Need Attention header with "See All" button
  Widget _buildNeedAttentionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Need Attention (3)',
          style: TossTextStyles.labelMedium.copyWith(
            color: TossColors.gray600,
          ),
        ),
        TextButton(
          onPressed: () {
            final attentionItems = _getAttentionItems();
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => AttentionListPage(items: attentionItems),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'See All',
            style: TossTextStyles.button.copyWith(
              color: TossColors.primary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  /// Get attention items data
  List<AttentionItemData> _getAttentionItems() {
    return [
      AttentionItemData(
        type: AttentionType.late,
        title: 'Jamie Lee',
        date: 'Tue, 18 Jun 2025',
        time: '09:00 – 13:00',
        subtext: '5 mins late',
      ),
      AttentionItemData(
        type: AttentionType.understaffed,
        title: 'Night Shift',
        date: 'Wed, 19 Jun 2025',
        time: '18:00 – 23:00',
        subtext: '3/4 assigned',
      ),
      AttentionItemData(
        type: AttentionType.overtime,
        title: 'Alex Park',
        date: 'Wed, 19 Jun 2025',
        time: '13:00 – 17:30',
        subtext: '1.5 hrs overtime',
      ),
    ];
  }

  /// Build Need Attention horizontal scroll
  Widget _buildNeedAttentionScroll() {
    final attentionItems = _getAttentionItems();

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: attentionItems.length,
        separatorBuilder: (context, index) => const SizedBox(width: TossSpacing.space3),
        itemBuilder: (context, index) {
          return AttentionCard(item: attentionItems[index]);
        },
      ),
    );
  }

  /// Build store selector dropdown (same as Schedule tab)
  Widget _buildStoreSelector(List<dynamic> stores) {
    final storeItems = stores.map((store) {
      final storeMap = store as Map<String, dynamic>;
      return TossDropdownItem<String>(
        value: storeMap['store_id']?.toString() ?? '',
        label: storeMap['store_name']?.toString() ?? 'Unknown',
      );
    }).toList();

    return TossDropdown<String>(
      label: 'Store',
      value: widget.selectedStoreId,
      items: storeItems,
      onChanged: (newValue) {
        if (newValue != null) {
          widget.onStoreSelectorTap();
        }
      },
    );
  }

  /// Extract stores from user data
  List<dynamic> _extractStores(Map<String, dynamic> userData) {
    if (userData.isEmpty) return [];

    try {
      final companies = userData['companies'] as List<dynamic>?;
      if (companies == null || companies.isEmpty) return [];

      final firstCompany = companies[0] as Map<String, dynamic>;
      final stores = firstCompany['stores'] as List<dynamic>?;
      if (stores == null) return [];

      return stores;
    } catch (e) {
      return [];
    }
  }
}
