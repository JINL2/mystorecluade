import '/components/menu_bar_widget.dart';
import '/delegate_role/deletage_role_component/deletage_role_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'delegate_role_page_widget.dart' show DelegateRolePageWidget;
import 'package:flutter/material.dart';

class DelegateRolePageModel extends FlutterFlowModel<DelegateRolePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // Models for deletageRoleComponent dynamic component.
  late FlutterFlowDynamicModels<DeletageRoleComponentModel>
      deletageRoleComponentModels;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
    deletageRoleComponentModels =
        FlutterFlowDynamicModels(() => DeletageRoleComponentModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
    deletageRoleComponentModels.dispose();
  }
}
