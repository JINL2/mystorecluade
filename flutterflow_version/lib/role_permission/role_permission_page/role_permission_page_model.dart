import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/jeong_work/add/add_widget.dart';
import '/role_permission/role_permissio_component/role_permissio_component_widget.dart';
import 'role_permission_page_widget.dart' show RolePermissionPageWidget;
import 'package:flutter/material.dart';

class RolePermissionPageModel
    extends FlutterFlowModel<RolePermissionPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // Model for add component.
  late AddModel addModel;
  // Models for debtControlComponent.
  late FlutterFlowDynamicModels<RolePermissioComponentModel>
      debtControlComponentModels;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
    addModel = createModel(context, () => AddModel());
    debtControlComponentModels =
        FlutterFlowDynamicModels(() => RolePermissioComponentModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
    addModel.dispose();
    debtControlComponentModels.dispose();
  }
}
