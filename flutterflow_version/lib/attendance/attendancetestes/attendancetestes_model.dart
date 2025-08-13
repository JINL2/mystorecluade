import '/attendance/datetestes/datetestes_widget.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'attendancetestes_widget.dart' show AttendancetestesWidget;
import 'package:flutter/material.dart';

class AttendancetestesModel extends FlutterFlowModel<AttendancetestesWidget> {
  ///  Local state fields for this page.

  GetTodayPlusMinusStruct? clickedDate;
  void updateClickedDateStruct(Function(GetTodayPlusMinusStruct) updateFn) {
    updateFn(clickedDate ??= GetTodayPlusMinusStruct());
  }

  String? scanedStoreId;

  List<UserShiftQuantityStruct> userShiftQuantity = [];
  void addToUserShiftQuantity(UserShiftQuantityStruct item) =>
      userShiftQuantity.add(item);
  void removeFromUserShiftQuantity(UserShiftQuantityStruct item) =>
      userShiftQuantity.remove(item);
  void removeAtIndexFromUserShiftQuantity(int index) =>
      userShiftQuantity.removeAt(index);
  void insertAtIndexInUserShiftQuantity(
          int index, UserShiftQuantityStruct item) =>
      userShiftQuantity.insert(index, item);
  void updateUserShiftQuantityAtIndex(
          int index, Function(UserShiftQuantityStruct) updateFn) =>
      userShiftQuantity[index] = updateFn(userShiftQuantity[index]);

  List<VShiftRequestMonthStruct> vshiftRequestMonth = [];
  void addToVshiftRequestMonth(VShiftRequestMonthStruct item) =>
      vshiftRequestMonth.add(item);
  void removeFromVshiftRequestMonth(VShiftRequestMonthStruct item) =>
      vshiftRequestMonth.remove(item);
  void removeAtIndexFromVshiftRequestMonth(int index) =>
      vshiftRequestMonth.removeAt(index);
  void insertAtIndexInVshiftRequestMonth(
          int index, VShiftRequestMonthStruct item) =>
      vshiftRequestMonth.insert(index, item);
  void updateVshiftRequestMonthAtIndex(
          int index, Function(VShiftRequestMonthStruct) updateFn) =>
      vshiftRequestMonth[index] = updateFn(vshiftRequestMonth[index]);

  List<VSalaryIndividualStruct> vsalaryIndividual = [];
  void addToVsalaryIndividual(VSalaryIndividualStruct item) =>
      vsalaryIndividual.add(item);
  void removeFromVsalaryIndividual(VSalaryIndividualStruct item) =>
      vsalaryIndividual.remove(item);
  void removeAtIndexFromVsalaryIndividual(int index) =>
      vsalaryIndividual.removeAt(index);
  void insertAtIndexInVsalaryIndividual(
          int index, VSalaryIndividualStruct item) =>
      vsalaryIndividual.insert(index, item);
  void updateVsalaryIndividualAtIndex(
          int index, Function(VSalaryIndividualStruct) updateFn) =>
      vsalaryIndividual[index] = updateFn(vsalaryIndividual[index]);

  List<dynamic> overView = [];
  void addToOverView(dynamic item) => overView.add(item);
  void removeFromOverView(dynamic item) => overView.remove(item);
  void removeAtIndexFromOverView(int index) => overView.removeAt(index);
  void insertAtIndexInOverView(int index, dynamic item) =>
      overView.insert(index, item);
  void updateOverViewAtIndex(int index, Function(dynamic) updateFn) =>
      overView[index] = updateFn(overView[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in attendancetestes widget.
  List<CurrencyTypesRow>? oPLCurrencyType;
  // Stores action output result for [Backend Call - API (usershiftmonthlysummary)] action in attendancetestes widget.
  ApiCallResponse? oPLOverView;
  // Stores action output result for [Backend Call - API (getusersalaryindividual)] action in attendancetestes widget.
  ApiCallResponse? oPLgetusersalaryindividual;
  // Stores action output result for [Backend Call - API (getshiftrequestmonthly)] action in attendancetestes widget.
  ApiCallResponse? oPLShiftRequestMonthly;
  // Stores action output result for [Backend Call - API (getshiftmetadata)] action in attendancetestes widget.
  ApiCallResponse? oPLshiftMetaData;
  // Stores action output result for [Backend Call - API (getUserShiftStatus)] action in attendancetestes widget.
  ApiCallResponse? oPLUserShiftStatus;
  // Stores action output result for [Backend Call - API (getUserShiftQuantity)] action in attendancetestes widget.
  ApiCallResponse? oPLGetUserShiftQuantity;
  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // Stores action output result for [Backend Call - API (usershiftmonthlysummary)] action in Container widget.
  ApiCallResponse? clickDate;
  // Stores action output result for [Backend Call - API (usershiftmonthlysummary)] action in Icon widget.
  ApiCallResponse? dateBack;
  // Stores action output result for [Backend Call - API (usershiftmonthlysummary)] action in Icon widget.
  ApiCallResponse? datefoward;
  // Model for DayBeforeYesterday.
  late DatetestesModel dayBeforeYesterdayModel;
  // Stores action output result for [Backend Call - API (usershiftmonthlysummary)] action in DayBeforeYesterday widget.
  ApiCallResponse? dateM2;
  // Model for yesterday.
  late DatetestesModel yesterdayModel;
  // Stores action output result for [Backend Call - API (usershiftmonthlysummary)] action in yesterday widget.
  ApiCallResponse? dateM1;
  // Model for Today.
  late DatetestesModel todayModel;
  // Model for Tmw.
  late DatetestesModel tmwModel;
  // Stores action output result for [Backend Call - API (usershiftmonthlysummary)] action in Tmw widget.
  ApiCallResponse? dateTmw;
  // Model for DayAfterTmw.
  late DatetestesModel dayAfterTmwModel;
  // Stores action output result for [Backend Call - API (usershiftmonthlysummary)] action in DayAfterTmw widget.
  ApiCallResponse? datetmw2;
  // State field(s) for filteredApprove widget.
  bool? filteredApproveValue;
  var scanQR = '';
  // Stores action output result for [Backend Call - API (updateShiftRequests)] action in calanderDatatestse widget.
  ApiCallResponse? clickFinish;
  // Stores action output result for [Backend Call - API (updateShiftRequests)] action in calanderDatatestse widget.
  ApiCallResponse? clickAttend;
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
