import '/backend/api_requests/api_calls.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'conetents_creation_widget.dart' show ConetentsCreationWidget;
import 'package:flutter/material.dart';

class ConetentsCreationModel extends FlutterFlowModel<ConetentsCreationWidget> {
  ///  Local state fields for this page.

  dynamic jsondata;

  bool isCompany = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getuserdashboarddata)] action in conetentsCreation widget.
  ApiCallResponse? apiResulthmu;
  // Model for menuBar component.
  late MenuBarModel menuBarModel;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
  }
}
