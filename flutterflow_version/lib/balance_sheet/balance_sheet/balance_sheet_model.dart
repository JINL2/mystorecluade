import '/backend/api_requests/api_calls.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'balance_sheet_widget.dart' show BalanceSheetWidget;
import 'package:flutter/material.dart';

class BalanceSheetModel extends FlutterFlowModel<BalanceSheetWidget> {
  ///  Local state fields for this page.

  double? debit;

  double? credit;

  double? diff;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getBalanceDfiferences)] action in balanceSheet widget.
  ApiCallResponse? apiResultfhw;
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
