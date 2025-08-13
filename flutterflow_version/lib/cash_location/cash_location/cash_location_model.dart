import '/backend/api_requests/api_calls.dart';
import '/cash_location/cash_location_comp/cash_location_comp_widget.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'cash_location_widget.dart' show CashLocationWidget;
import 'package:flutter/material.dart';

class CashLocationModel extends FlutterFlowModel<CashLocationWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // Model for cashLocationComp component.
  late CashLocationCompModel cashLocationCompModel;
  // Stores action output result for [Backend Call - API (getcashlocationsnested)] action in cashLocationComp widget.
  ApiCallResponse? updateRecallAPI;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
    cashLocationCompModel = createModel(context, () => CashLocationCompModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
    cashLocationCompModel.dispose();
  }
}
