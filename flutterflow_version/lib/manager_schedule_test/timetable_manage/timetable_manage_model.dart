import '/attendance/datetestes/datetestes_widget.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/manager/calnder_comp/calnder_comp_widget.dart';
import 'timetable_manage_widget.dart' show TimetableManageWidget;
import 'package:flutter/material.dart';

class TimetableManageModel extends FlutterFlowModel<TimetableManageWidget> {
  ///  Local state fields for this page.

  GetTodayPlusMinusStruct? selectedDate;
  void updateSelectedDateStruct(Function(GetTodayPlusMinusStruct) updateFn) {
    updateFn(selectedDate ??= GetTodayPlusMinusStruct());
  }

  List<String> selectedShiftRequestId = [];
  void addToSelectedShiftRequestId(String item) =>
      selectedShiftRequestId.add(item);
  void removeFromSelectedShiftRequestId(String item) =>
      selectedShiftRequestId.remove(item);
  void removeAtIndexFromSelectedShiftRequestId(int index) =>
      selectedShiftRequestId.removeAt(index);
  void insertAtIndexInSelectedShiftRequestId(int index, String item) =>
      selectedShiftRequestId.insert(index, item);
  void updateSelectedShiftRequestIdAtIndex(
          int index, Function(String) updateFn) =>
      selectedShiftRequestId[index] = updateFn(selectedShiftRequestId[index]);

  String? selectedStoreId;

  List<dynamic> dailySummary = [];
  void addToDailySummary(dynamic item) => dailySummary.add(item);
  void removeFromDailySummary(dynamic item) => dailySummary.remove(item);
  void removeAtIndexFromDailySummary(int index) => dailySummary.removeAt(index);
  void insertAtIndexInDailySummary(int index, dynamic item) =>
      dailySummary.insert(index, item);
  void updateDailySummaryAtIndex(int index, Function(dynamic) updateFn) =>
      dailySummary[index] = updateFn(dailySummary[index]);

  List<dynamic> montlystat = [];
  void addToMontlystat(dynamic item) => montlystat.add(item);
  void removeFromMontlystat(dynamic item) => montlystat.remove(item);
  void removeAtIndexFromMontlystat(int index) => montlystat.removeAt(index);
  void insertAtIndexInMontlystat(int index, dynamic item) =>
      montlystat.insert(index, item);
  void updateMontlystatAtIndex(int index, Function(dynamic) updateFn) =>
      montlystat[index] = updateFn(montlystat[index]);

  String? clickedMonthStatus;

  List<dynamic> storeData = [];
  void addToStoreData(dynamic item) => storeData.add(item);
  void removeFromStoreData(dynamic item) => storeData.remove(item);
  void removeAtIndexFromStoreData(int index) => storeData.removeAt(index);
  void insertAtIndexInStoreData(int index, dynamic item) =>
      storeData.insert(index, item);
  void updateStoreDataAtIndex(int index, Function(dynamic) updateFn) =>
      storeData[index] = updateFn(storeData[index]);

  List<dynamic> overviewStore = [];
  void addToOverviewStore(dynamic item) => overviewStore.add(item);
  void removeFromOverviewStore(dynamic item) => overviewStore.remove(item);
  void removeAtIndexFromOverviewStore(int index) =>
      overviewStore.removeAt(index);
  void insertAtIndexInOverviewStore(int index, dynamic item) =>
      overviewStore.insert(index, item);
  void updateOverviewStoreAtIndex(int index, Function(dynamic) updateFn) =>
      overviewStore[index] = updateFn(overviewStore[index]);

  List<String> monthFilter = [];
  void addToMonthFilter(String item) => monthFilter.add(item);
  void removeFromMonthFilter(String item) => monthFilter.remove(item);
  void removeAtIndexFromMonthFilter(int index) => monthFilter.removeAt(index);
  void insertAtIndexInMonthFilter(int index, String item) =>
      monthFilter.insert(index, item);
  void updateMonthFilterAtIndex(int index, Function(String) updateFn) =>
      monthFilter[index] = updateFn(monthFilter[index]);

  List<dynamic> cardsdata = [];
  void addToCardsdata(dynamic item) => cardsdata.add(item);
  void removeFromCardsdata(dynamic item) => cardsdata.remove(item);
  void removeAtIndexFromCardsdata(int index) => cardsdata.removeAt(index);
  void insertAtIndexInCardsdata(int index, dynamic item) =>
      cardsdata.insert(index, item);
  void updateCardsdataAtIndex(int index, Function(dynamic) updateFn) =>
      cardsdata[index] = updateFn(cardsdata[index]);

  List<dynamic> tagFilter = [];
  void addToTagFilter(dynamic item) => tagFilter.add(item);
  void removeFromTagFilter(dynamic item) => tagFilter.remove(item);
  void removeAtIndexFromTagFilter(int index) => tagFilter.removeAt(index);
  void insertAtIndexInTagFilter(int index, dynamic item) =>
      tagFilter.insert(index, item);
  void updateTagFilterAtIndex(int index, Function(dynamic) updateFn) =>
      tagFilter[index] = updateFn(tagFilter[index]);

  String? clickedTagFilter;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getshiftmetadata)] action in timetableManage widget.
  ApiCallResponse? oPLgetShiftMetaData;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesShiftMeta] action in timetableManage widget.
  List<ShiftMetaDataStruct>? oPLgetShiftMetaDataCustom;
  // Stores action output result for [Backend Call - API (GetManagerShift)] action in timetableManage widget.
  ApiCallResponse? oPLGetManagerShift;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesManagerShift] action in timetableManage widget.
  List<ManagerShiftDetailStruct>? oPLGetManagerShiftCustom;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in timetableManage widget.
  ApiCallResponse? oPLOverview;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in timetableManage widget.
  ApiCallResponse? oPLManagerCard;
  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in Container widget.
  ApiCallResponse? overviewOverview;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in Container widget.
  ApiCallResponse? cardCard;
  // Stores action output result for [Backend Call - API (getshiftmetadata)] action in Container widget.
  ApiCallResponse? storeMetaData;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesShiftMeta] action in Container widget.
  List<ShiftMetaDataStruct>? storeMetaData2;
  // Stores action output result for [Backend Call - API (GetManagerShift)] action in Container widget.
  ApiCallResponse? storeManager;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesManagerShift] action in Container widget.
  List<ManagerShiftDetailStruct>? storeManager2;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in Container widget.
  ApiCallResponse? storeClickOverview;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in Container widget.
  ApiCallResponse? storeClickManagerCard;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Stores action output result for [Backend Call - API (GetManagerShift)] action in Icon widget.
  ApiCallResponse? getManagerShiftRefresh1;
  // Model for CalnderComp component.
  late CalnderCompModel calnderCompModel;
  // State field(s) for Checkbox widget.
  Map<PendingEmployeesStruct, bool> checkboxValueMap = {};
  List<PendingEmployeesStruct> get checkboxCheckedItems =>
      checkboxValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  // Stores action output result for [Backend Call - API (toggleshiftapproval)] action in Button widget.
  ApiCallResponse? changeSupaBaseApprove1;
  // Stores action output result for [Custom Action - changeManagerShiftList] action in Button widget.
  List<ManagerShiftDetailStruct>? newShiftDetail1;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in Button widget.
  ApiCallResponse? updateManagerShiftGetOverview;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in Button widget.
  ApiCallResponse? updateManagerShiftGetCards;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in Icon widget.
  ApiCallResponse? dateClickOverviewb;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in Icon widget.
  ApiCallResponse? dateClickCardb;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in Container widget.
  ApiCallResponse? dateClickCardH;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in Container widget.
  ApiCallResponse? dateClickOverviewH;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in Container widget.
  ApiCallResponse? dateClickCardG;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in Container widget.
  ApiCallResponse? dateClickOverviewG;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in Icon widget.
  ApiCallResponse? dateClickOverview;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in Icon widget.
  ApiCallResponse? dateClickCard;
  // Model for M2.
  late DatetestesModel m2Model;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in M2 widget.
  ApiCallResponse? dateClickOverviewc;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in M2 widget.
  ApiCallResponse? dateClickCardc;
  // Model for M1.
  late DatetestesModel m1Model;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in M1 widget.
  ApiCallResponse? dateClickOverviewD;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in M1 widget.
  ApiCallResponse? dateClickCardD;
  // Model for D0.
  late DatetestesModel d0Model;
  // Model for DP1.
  late DatetestesModel dp1Model;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in DP1 widget.
  ApiCallResponse? dateClickOverviewE;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in DP1 widget.
  ApiCallResponse? dateClickCardE;
  // Model for DP2.
  late DatetestesModel dp2Model;
  // Stores action output result for [Backend Call - API (managershiftgetoverview)] action in DP2 widget.
  ApiCallResponse? dateClickOverviewF;
  // Stores action output result for [Backend Call - API (managershiftgetcards)] action in DP2 widget.
  ApiCallResponse? dateClickCardF;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
    calnderCompModel = createModel(context, () => CalnderCompModel());
    m2Model = createModel(context, () => DatetestesModel());
    m1Model = createModel(context, () => DatetestesModel());
    d0Model = createModel(context, () => DatetestesModel());
    dp1Model = createModel(context, () => DatetestesModel());
    dp2Model = createModel(context, () => DatetestesModel());
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
    tabBarController?.dispose();
    calnderCompModel.dispose();
    m2Model.dispose();
    m1Model.dispose();
    d0Model.dispose();
    dp1Model.dispose();
    dp2Model.dispose();
    isloadingModel.dispose();
  }
}
