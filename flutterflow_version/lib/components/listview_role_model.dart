import '/components/role_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'listview_role_widget.dart' show ListviewRoleWidget;
import 'package:flutter/material.dart';

class ListviewRoleModel extends FlutterFlowModel<ListviewRoleWidget> {
  ///  State fields for stateful widgets in this component.

  // Models for RoleCard dynamic component.
  late FlutterFlowDynamicModels<RoleCardModel> roleCardModels;

  @override
  void initState(BuildContext context) {
    roleCardModels = FlutterFlowDynamicModels(() => RoleCardModel());
  }

  @override
  void dispose() {
    roleCardModels.dispose();
  }
}
