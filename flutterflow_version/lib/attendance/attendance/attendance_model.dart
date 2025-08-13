import '/attendance/datetestes/datetestes_widget.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'attendance_widget.dart' show AttendanceWidget;
import 'package:flutter/material.dart';

class AttendanceModel extends FlutterFlowModel<AttendanceWidget> {
  ///  Local state fields for this page.

  GetTodayPlusMinusStruct? clickedDate;
  void updateClickedDateStruct(Function(GetTodayPlusMinusStruct) updateFn) {
    updateFn(clickedDate ??= GetTodayPlusMinusStruct());
  }

  List<dynamic> userMonthSummary = [];
  void addToUserMonthSummary(dynamic item) => userMonthSummary.add(item);
  void removeFromUserMonthSummary(dynamic item) =>
      userMonthSummary.remove(item);
  void removeAtIndexFromUserMonthSummary(int index) =>
      userMonthSummary.removeAt(index);
  void insertAtIndexInUserMonthSummary(int index, dynamic item) =>
      userMonthSummary.insert(index, item);
  void updateUserMonthSummaryAtIndex(int index, Function(dynamic) updateFn) =>
      userMonthSummary[index] = updateFn(userMonthSummary[index]);

  List<String> monthFilter = [];
  void addToMonthFilter(String item) => monthFilter.add(item);
  void removeFromMonthFilter(String item) => monthFilter.remove(item);
  void removeAtIndexFromMonthFilter(int index) => monthFilter.removeAt(index);
  void insertAtIndexInMonthFilter(int index, String item) =>
      monthFilter.insert(index, item);
  void updateMonthFilterAtIndex(int index, Function(String) updateFn) =>
      monthFilter[index] = updateFn(monthFilter[index]);

  List<dynamic> userShiftCard = [];
  void addToUserShiftCard(dynamic item) => userShiftCard.add(item);
  void removeFromUserShiftCard(dynamic item) => userShiftCard.remove(item);
  void removeAtIndexFromUserShiftCard(int index) =>
      userShiftCard.removeAt(index);
  void insertAtIndexInUserShiftCard(int index, dynamic item) =>
      userShiftCard.insert(index, item);
  void updateUserShiftCardAtIndex(int index, Function(dynamic) updateFn) =>
      userShiftCard[index] = updateFn(userShiftCard[index]);

  String? isApprovedFilter;

  bool? workingboolean;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (usershiftoverview)] action in attendance widget.
  ApiCallResponse? oPLUserShiftOverview;
  // Stores action output result for [Backend Call - API (usershiftcards)] action in attendance widget.
  ApiCallResponse? oPLUserShiftCards;
  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // Stores action output result for [Backend Call - API (usershiftoverview)] action in Container widget.
  ApiCallResponse? dateClickG;
  // Stores action output result for [Backend Call - API (usershiftoverview)] action in Icon widget.
  ApiCallResponse? dateClickB;
  // Stores action output result for [Backend Call - API (usershiftoverview)] action in Icon widget.
  ApiCallResponse? dateClickA;
  // Model for DayBeforeYesterday.
  late DatetestesModel dayBeforeYesterdayModel;
  // Stores action output result for [Backend Call - API (usershiftoverview)] action in DayBeforeYesterday widget.
  ApiCallResponse? dateClickF;
  // Model for yesterday.
  late DatetestesModel yesterdayModel;
  // Stores action output result for [Backend Call - API (usershiftoverview)] action in yesterday widget.
  ApiCallResponse? dateClickE;
  // Model for Today.
  late DatetestesModel todayModel;
  // Model for Tmw.
  late DatetestesModel tmwModel;
  // Stores action output result for [Backend Call - API (usershiftoverview)] action in Tmw widget.
  ApiCallResponse? dateClickD;
  // Model for DayAfterTmw.
  late DatetestesModel dayAfterTmwModel;
  // Stores action output result for [Backend Call - API (usershiftoverview)] action in DayAfterTmw widget.
  ApiCallResponse? dateClickC;
  // State field(s) for filteredApprove widget.
  bool? filteredApproveValue;
  var qrScan1 = '';
  // Stores action output result for [Backend Call - API (updateshiftrequestsv)] action in calanderData widget.
  ApiCallResponse? updateShiftRequest1;
  // Stores action output result for [Backend Call - API (usershiftcards)] action in calanderData widget.
  ApiCallResponse? callback1;
  // Stores action output result for [Backend Call - API (usershiftcards)] action in calanderData widget.
  ApiCallResponse? callback2;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
    dayBeforeYesterdayModel = createModel(context, () => DatetestesModel());
    yesterdayModel = createModel(context, () => DatetestesModel());
    todayModel = createModel(context, () => DatetestesModel());
    tmwModel = createModel(context, () => DatetestesModel());
    dayAfterTmwModel = createModel(context, () => DatetestesModel());
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
    dayBeforeYesterdayModel.dispose();
    yesterdayModel.dispose();
    todayModel.dispose();
    tmwModel.dispose();
    dayAfterTmwModel.dispose();
    isloadingModel.dispose();
  }
}
