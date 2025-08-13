import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'create_role_v1_widget.dart' show CreateRoleV1Widget;
import 'package:flutter/material.dart';

class CreateRoleV1Model extends FlutterFlowModel<CreateRoleV1Widget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for Checkbox widget.
  Map<FeaturesStruct, bool> checkboxValueMap = {};
  List<FeaturesStruct> get checkboxCheckedItems =>
      checkboxValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  // Stores action output result for [Backend Call - API (Create Role)] action in Icon widget.
  ApiCallResponse? createRole;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    isloadingModel.dispose();
  }
}
