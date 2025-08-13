import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/jeong_work/add/add_widget.dart';
import 'delegate_role_v1_widget.dart' show DelegateRoleV1Widget;
import 'package:flutter/material.dart';

class DelegateRoleV1Model extends FlutterFlowModel<DelegateRoleV1Widget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for newRole widget.
  String? newRoleValue;
  FormFieldController<String>? newRoleValueController;
  // Model for add component.
  late AddModel addModel;
  // Stores action output result for [Backend Call - Update Row(s)] action in add widget.
  List<UserRolesRow>? updateRole;

  @override
  void initState(BuildContext context) {
    addModel = createModel(context, () => AddModel());
  }

  @override
  void dispose() {
    addModel.dispose();
  }
}
