# Time Table Page Design

## Purpose
The Time Table page enables managers to create, view, and manage employee work schedules efficiently. It provides a clear overview of who's working when and helps optimize staff coverage.

## User Needs
- **Schedule Overview**: See weekly/monthly schedules at a glance
- **Easy Scheduling**: Drag-and-drop or tap to create shifts
- **Conflict Detection**: Avoid double-booking or understaffing
- **Employee Availability**: Respect time-off requests
- **Quick Changes**: Swap shifts, handle last-minute changes
- **Mobile-Friendly**: Manage schedules on the go

## Page Structure

### 1. View Selector & Navigation
```dart
// Top navigation bar
Container(
  color: TossColors.white,
  child: Column(
    children: [
      // Title and actions
      SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              Text('Time Table', style: TossTextStyles.h3),
              Spacer(),
              TossIconButton(
                icon: Icons.today,
                onPressed: () => jumpToToday(),
              ),
              SizedBox(width: 8),
              TossIconButton(
                icon: Icons.more_vert,
                onPressed: () => showMoreOptions(),
              ),
            ],
          ),
        ),
      ),
      
      // View type selector
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TossSegmentedControl(
          value: viewType,
          onChanged: (type) => setState(() => viewType = type),
          children: {
            ViewType.week: Text('Week'),
            ViewType.month: Text('Month'),
            ViewType.day: Text('Day'),
          },
        ),
      ),
      SizedBox(height: 12),
      
      // Date navigation
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () => navigatePrevious(),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => showDatePicker(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    getDateRangeText(),
                    style: TossTextStyles.body.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () => navigateNext(),
            ),
          ],
        ),
      ),
    ],
  ),
)
```

### 2. Week View Design
```dart
// Weekly schedule grid
class WeekViewSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Day headers
        Container(
          height: 40,
          child: Row(
            children: [
              SizedBox(width: 80), // Employee column width
              ...weekDays.map((day) => Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: TossColors.gray200),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.dayName,
                        style: TossTextStyles.caption,
                      ),
                      Text(
                        day.dayNumber,
                        style: TossTextStyles.body.bold.copyWith(
                          color: day.isToday ? TossColors.primary : null,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
        
        // Schedule grid
        Expanded(
          child: ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              
              return Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: TossColors.gray100),
                  ),
                ),
                child: Row(
                  children: [
                    // Employee info
                    Container(
                      width: 80,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee.name,
                            style: TossTextStyles.caption.bold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${employee.weeklyHours}h',
                            style: TossTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    
                    // Shift cells
                    ...weekDays.map((day) => Expanded(
                      child: GestureDetector(
                        onTap: () => handleCellTap(employee, day),
                        child: Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: getShiftColor(employee, day),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: TossColors.gray200,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              getShiftText(employee, day),
                              style: TossTextStyles.caption,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              );
            },
          ),
        ),
        
        // Summary footer
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            border: Border(
              top: BorderSide(color: TossColors.gray200),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(
                label: 'Total Hours',
                value: '${totalHours}h',
              ),
              _SummaryItem(
                label: 'Employees',
                value: '$scheduledEmployees/$totalEmployees',
              ),
              _SummaryItem(
                label: 'Coverage',
                value: '${coveragePercent}%',
                color: getCoverageColor(coveragePercent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

### 3. Day View Design
```dart
// Detailed daily schedule
class DayViewSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Shift summary cards
        Container(
          height: 120,
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TossCard(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.wb_sunny, 
                              size: 20, 
                              color: TossColors.warning,
                            ),
                            SizedBox(width: 8),
                            Text('Morning', style: TossTextStyles.caption),
                          ],
                        ),
                        Spacer(),
                        Text(
                          '$morningStaff staff',
                          style: TossTextStyles.h3,
                        ),
                        Text(
                          '6 AM - 2 PM',
                          style: TossTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TossCard(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.wb_cloudy, 
                              size: 20, 
                              color: TossColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text('Evening', style: TossTextStyles.caption),
                          ],
                        ),
                        Spacer(),
                        Text(
                          '$eveningStaff staff',
                          style: TossTextStyles.h3,
                        ),
                        Text(
                          '2 PM - 10 PM',
                          style: TossTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Timeline view
        Expanded(
          child: ListView.builder(
            itemCount: shifts.length,
            itemBuilder: (context, index) {
              final shift = shifts[index];
              
              return TossListItem(
                onTap: () => showShiftDetails(shift),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(shift.employee.avatar),
                  radius: 20,
                ),
                title: shift.employee.name,
                subtitle: '${shift.role} • ${shift.location}',
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: getShiftTypeColor(shift.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${shift.startTime} - ${shift.endTime}',
                    style: TossTextStyles.caption.copyWith(
                      color: getShiftTypeColor(shift.type),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

### 4. Create/Edit Shift Bottom Sheet
```dart
TossBottomSheet.show(
  context: context,
  isScrollControlled: true,
  title: isEditing ? 'Edit Shift' : 'Create Shift',
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Employee selector
      if (!isEditing)
        TossListTile(
          leading: CircleAvatar(
            backgroundImage: selectedEmployee != null
              ? NetworkImage(selectedEmployee!.avatar)
              : null,
            child: selectedEmployee == null
              ? Icon(Icons.person)
              : null,
          ),
          title: 'Employee',
          subtitle: selectedEmployee?.name ?? 'Select employee',
          trailing: Icon(Icons.chevron_right),
          onTap: () => showEmployeeSelector(),
        ),
      
      Divider(),
      
      // Date selector
      TossListTile(
        leading: Icon(Icons.calendar_today),
        title: 'Date',
        subtitle: formatDate(selectedDate),
        trailing: Icon(Icons.chevron_right),
        onTap: () => selectDate(),
      ),
      
      Divider(),
      
      // Time selection
      Row(
        children: [
          Expanded(
            child: TossListTile(
              title: 'Start Time',
              subtitle: formatTime(startTime),
              onTap: () => selectStartTime(),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.arrow_forward, size: 16),
          ),
          Expanded(
            child: TossListTile(
              title: 'End Time',
              subtitle: formatTime(endTime),
              onTap: () => selectEndTime(),
            ),
          ),
        ],
      ),
      
      // Duration display
      Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          '${calculateDuration()} hours',
          style: TossTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ),
      
      Divider(),
      
      // Shift type
      TossSection(
        title: 'Shift Type',
        child: Wrap(
          spacing: 8,
          children: ShiftType.values.map((type) => 
            TossChoiceChip(
              label: type.label,
              selected: shiftType == type,
              onSelected: (_) => setState(() => shiftType = type),
            ),
          ).toList(),
        ),
      ),
      
      // Notes
      TossTextField(
        controller: notesController,
        label: 'Notes (optional)',
        hintText: 'e.g., Cover for sick leave',
        maxLines: 2,
      ),
      
      SizedBox(height: 24),
      
      // Actions
      Row(
        children: [
          if (isEditing)
            TossTextButton(
              text: 'Delete',
              onPressed: deleteShift,
              color: TossColors.error,
            ),
          Spacer(),
          TossTextButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 12),
          TossPrimaryButton(
            text: isEditing ? 'Update' : 'Create',
            onPressed: isValid ? saveShift : null,
            size: TossButtonSize.medium,
          ),
        ],
      ),
    ],
  ),
)
```

### 5. Conflict Resolution Dialog
```dart
// When scheduling conflicts arise
showDialog(
  context: context,
  builder: (context) => TossAlertDialog(
    title: 'Schedule Conflict',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          size: 48,
          color: TossColors.warning,
        ),
        SizedBox(height: 16),
        Text(
          'Jin Lee is already scheduled from 2 PM - 6 PM',
          style: TossTextStyles.body,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Existing: Customer Service\nNew: Cashier',
            style: TossTextStyles.caption,
          ),
        ),
      ],
    ),
    actions: [
      TossTextButton(
        text: 'Cancel',
        onPressed: () => Navigator.pop(context),
      ),
      TossPrimaryButton(
        text: 'Replace Shift',
        onPressed: () {
          Navigator.pop(context);
          replaceShift();
        },
        size: TossButtonSize.small,
      ),
    ],
  ),
)
```

## State Management

```dart
@riverpod
class TimeTableState extends _$TimeTableState {
  @override
  Future<TimeTableData> build() async {
    final repository = ref.watch(scheduleRepositoryProvider);
    final dateRange = ref.watch(selectedDateRangeProvider);
    final store = ref.watch(selectedStoreProvider);
    
    return repository.getSchedule(
      storeId: store?.id,
      startDate: dateRange.start,
      endDate: dateRange.end,
    );
  }
  
  Future<void> createShift(Shift shift) async {
    final repository = ref.read(scheduleRepositoryProvider);
    
    // Check conflicts
    final conflicts = await repository.checkConflicts(shift);
    if (conflicts.isNotEmpty) {
      // Handle conflicts
      return;
    }
    
    await repository.createShift(shift);
    ref.invalidateSelf();
  }
}

@riverpod
class SelectedDateRange extends _$SelectedDateRange {
  @override
  DateTimeRange build() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    
    return DateTimeRange(start: startOfWeek, end: endOfWeek);
  }
  
  void updateRange(DateTimeRange range) {
    state = range;
  }
}
```

## Gestures & Interactions

- **Tap empty cell**: Create new shift
- **Tap existing shift**: Edit shift
- **Long press shift**: Show quick actions
- **Swipe shift**: Delete with confirmation
- **Pinch**: Zoom in/out on schedule

## Performance Considerations

- Virtualized rendering for large teams
- Cache weekly schedules
- Optimistic UI updates
- Batch shift operations
- Lazy load employee avatars

## Analytics Events

- `timetable_viewed`
- `shift_created`
- `shift_updated`
- `shift_deleted`
- `view_type_changed`
- `conflict_resolved`