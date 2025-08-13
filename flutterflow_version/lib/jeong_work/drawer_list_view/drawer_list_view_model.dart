import '/flutter_flow/flutter_flow_util.dart';
import '/jeong_work/drawer_company_name/drawer_company_name_widget.dart';
import '/jeong_work/drawer_store/drawer_store_widget.dart';
import 'drawer_list_view_widget.dart' show DrawerListViewWidget;
import 'package:flutter/material.dart';

class DrawerListViewModel extends FlutterFlowModel<DrawerListViewWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for DrawerCompanyName component.
  late DrawerCompanyNameModel drawerCompanyNameModel;
  // Models for DrawerStore dynamic component.
  late FlutterFlowDynamicModels<DrawerStoreModel> drawerStoreModels;

  @override
  void initState(BuildContext context) {
    drawerCompanyNameModel =
        createModel(context, () => DrawerCompanyNameModel());
    drawerStoreModels = FlutterFlowDynamicModels(() => DrawerStoreModel());
  }

  @override
  void dispose() {
    drawerCompanyNameModel.dispose();
    drawerStoreModels.dispose();
  }
}
