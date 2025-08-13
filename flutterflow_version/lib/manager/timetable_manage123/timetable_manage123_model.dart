import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/buttons/add_button/add_button_widget.dart';
import '/components/isloading_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/manager/calnder_comp/calnder_comp_widget.dart';
import '/manager/managershift_list/managershift_list_widget.dart';
import 'timetable_manage123_widget.dart' show TimetableManage123Widget;
import 'package:flutter/material.dart';

class TimetableManage123Model
    extends FlutterFlowModel<TimetableManage123Widget> {
  ///  Local state fields for this page.

  DateTime? selectedDate;

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

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getshiftmetadata)] action in timetableManage123 widget.
  ApiCallResponse? goalMeta1;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesShiftMeta] action in timetableManage123 widget.
  List<ShiftMetaDataStruct>? goalMeta1Finish;
  // Stores action output result for [Backend Call - API (GetManagerShift)] action in timetableManage123 widget.
  ApiCallResponse? goalManager1;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesManagerShift] action in timetableManage123 widget.
  List<ManagerShiftDetailStruct>? goalManagerFinish1;
  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for storeDropDown widget.
  String? storeDropDownValue;
  FormFieldController<String>? storeDropDownValueController;
  // Stores action output result for [Backend Call - API (getshiftmetadata)] action in storeDropDown widget.
  ApiCallResponse? dreamMeta2;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesShiftMeta] action in storeDropDown widget.
  List<ShiftMetaDataStruct>? dreamMeta2Complete;
  // Stores action output result for [Backend Call - API (GetManagerShift)] action in storeDropDown widget.
  ApiCallResponse? dreamManager2;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesManagerShift] action in storeDropDown widget.
  List<ManagerShiftDetailStruct>? dreamManager2Complete;
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
  // State field(s) for filterStore22 widget.
  String? filterStore22Value;
  FormFieldController<String>? filterStore22ValueController;
  // Stores action output result for [Backend Call - API (getshiftmetadata)] action in filterStore22 widget.
  ApiCallResponse? meta11;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesShiftMeta] action in filterStore22 widget.
  List<ShiftMetaDataStruct>? meta12;
  // Stores action output result for [Backend Call - API (GetManagerShift)] action in filterStore22 widget.
  ApiCallResponse? manager11;
  // Stores action output result for [Custom Action - mergeAndRemoveDuplicatesManagerShift] action in filterStore22 widget.
  List<ManagerShiftDetailStruct>? manager12;
  // State field(s) for oKSwitch widget.
  bool? oKSwitchValue;
  // Model for add_button component.
  late AddButtonModel addButtonModel;
  // Model for managershiftList component.
  late ManagershiftListModel managershiftListModel;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
    calnderCompModel = createModel(context, () => CalnderCompModel());
    addButtonModel = createModel(context, () => AddButtonModel());
    managershiftListModel = createModel(context, () => ManagershiftListModel());
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
    tabBarController?.dispose();
    calnderCompModel.dispose();
    addButtonModel.dispose();
    managershiftListModel.dispose();
    isloadingModel.dispose();
  }
}
