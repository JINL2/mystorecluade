import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/buttons/add_button/add_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'update_roles_v1_widget.dart' show UpdateRolesV1Widget;
import 'package:flutter/material.dart';

class UpdateRolesV1Model extends FlutterFlowModel<UpdateRolesV1Widget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for Checkbox widget.
  Map<FeaturesStruct, bool> checkboxValueMap = {};
  List<FeaturesStruct> get checkboxCheckedItems =>
      checkboxValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  // Model for add_button component.
  late AddButtonModel addButtonModel1;
  // Stores action output result for [Backend Call - API (Update Role)] action in add_button widget.
  ApiCallResponse? upDateRole;
  // Stores action output result for [Backend Call - API (Delete Role)] action in Container widget.
  ApiCallResponse? deleteRole;
  // Model for add_button component.
  late AddButtonModel addButtonModel2;

  @override
  void initState(BuildContext context) {
    addButtonModel1 = createModel(context, () => AddButtonModel());
    addButtonModel2 = createModel(context, () => AddButtonModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    addButtonModel1.dispose();
    addButtonModel2.dispose();
  }
}
