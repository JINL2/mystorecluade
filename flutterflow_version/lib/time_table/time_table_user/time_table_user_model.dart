import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/jeong_work/add/add_widget.dart';
import '/time_table/register_cal_comp/register_cal_comp_widget.dart';
import '/time_table/shift_test/shift_test_widget.dart';
import '/time_table/table_schdule/table_schdule_widget.dart';
import 'time_table_user_widget.dart' show TimeTableUserWidget;
import 'package:flutter/material.dart';

class TimeTableUserModel extends FlutterFlowModel<TimeTableUserWidget> {
  ///  Local state fields for this page.

  DateTime? selectedDatePageState;

  String? shiftId;

  List<String> calledStoreId = [];
  void addToCalledStoreId(String item) => calledStoreId.add(item);
  void removeFromCalledStoreId(String item) => calledStoreId.remove(item);
  void removeAtIndexFromCalledStoreId(int index) =>
      calledStoreId.removeAt(index);
  void insertAtIndexInCalledStoreId(int index, String item) =>
      calledStoreId.insert(index, item);
  void updateCalledStoreIdAtIndex(int index, Function(String) updateFn) =>
      calledStoreId[index] = updateFn(calledStoreId[index]);

  String? selectedStoreId;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getshiftmetadata)] action in timeTableUser widget.
  ApiCallResponse? newshiftMetadata;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesShiftMeta] action in timeTableUser widget.
  List<ShiftMetaDataStruct>? newMetadata2;
  // Stores action output result for [Backend Call - API (getUserShiftStatus)] action in timeTableUser widget.
  ApiCallResponse? newshiftstatus;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesShiftStatus] action in timeTableUser widget.
  List<ShiftStatusStruct>? newShiftData2;
  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for DropDownStore1 widget.
  String? dropDownStore1Value;
  FormFieldController<String>? dropDownStore1ValueController;
  // Stores action output result for [Backend Call - API (getshiftmetadata)] action in DropDownStore1 widget.
  ApiCallResponse? dream1;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesShiftMeta] action in DropDownStore1 widget.
  List<ShiftMetaDataStruct>? dream1Complete;
  // Stores action output result for [Backend Call - API (getUserShiftStatus)] action in DropDownStore1 widget.
  ApiCallResponse? dream2;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesShiftStatus] action in DropDownStore1 widget.
  List<ShiftStatusStruct>? dream2complete;
  // Model for registerCalComp component.
  late RegisterCalCompModel registerCalCompModel;
  // Models for shift_test dynamic component.
  late FlutterFlowDynamicModels<ShiftTestModel> shiftTestModels;
  // Model for add component.
  late AddModel addModel;
  // Stores action output result for [Backend Call - Delete Row(s)] action in add widget.
  List<ShiftRequestsRow>? deleteResult;
  // Stores action output result for [Backend Call - API (insertshiftrequestv)] action in add widget.
  ApiCallResponse? insertShift;
  // State field(s) for filterStore widget.
  String? filterStoreValue;
  FormFieldController<String>? filterStoreValueController;
  // Stores action output result for [Backend Call - API (getshiftmetadata)] action in filterStore widget.
  ApiCallResponse? meta11;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesShiftMeta] action in filterStore widget.
  List<ShiftMetaDataStruct>? meta12;
  // Stores action output result for [Backend Call - API (getUserShiftStatus)] action in filterStore widget.
  ApiCallResponse? userShift11;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesShiftStatus] action in filterStore widget.
  List<ShiftStatusStruct>? userShift12;
  // State field(s) for Switch widget.
  bool? switchValue;
  // Model for table_schdule component.
  late TableSchduleModel tableSchduleModel;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
    registerCalCompModel = createModel(context, () => RegisterCalCompModel());
    shiftTestModels = FlutterFlowDynamicModels(() => ShiftTestModel());
    addModel = createModel(context, () => AddModel());
    tableSchduleModel = createModel(context, () => TableSchduleModel());
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
    tabBarController?.dispose();
    registerCalCompModel.dispose();
    shiftTestModels.dispose();
    addModel.dispose();
    tableSchduleModel.dispose();
    isloadingModel.dispose();
  }
}
