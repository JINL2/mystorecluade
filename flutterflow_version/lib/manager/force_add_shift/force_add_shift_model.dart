import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'force_add_shift_widget.dart' show ForceAddShiftWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForceAddShiftModel extends FlutterFlowModel<ForceAddShiftWidget> {
  ///  Local state fields for this component.

  DateTime? selectedDate;

  String? chooseUserName;

  ///  State fields for stateful widgets in this component.

  DateTime? datePicked;
  // State field(s) for storeDropdown widget.
  String? storeDropdownValue;
  FormFieldController<String>? storeDropdownValueController;
  // State field(s) for shiftDropDown widget.
  String? shiftDropDownValue;
  FormFieldController<String>? shiftDropDownValueController;
  // State field(s) for userIdDropdown widget.
  String? userIdDropdownValue;
  FormFieldController<String>? userIdDropdownValueController;
  // Stores action output result for [Backend Call - Insert Row] action in Column widget.
  ShiftRequestsRow? createmanagershift;
  // Stores action output result for [Custom Action - createUserIdByShiftReuqestId] action in Column widget.
  List<ManagerShiftDetailStruct>? newManageShiftData;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
