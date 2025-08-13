import '/backend/api_requests/api_calls.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'debt_detail_component_widget.dart' show DebtDetailComponentWidget;
import 'package:flutter/material.dart';

class DebtDetailComponentModel
    extends FlutterFlowModel<DebtDetailComponentWidget> {
  ///  Local state fields for this component.

  dynamic dataSave;

  String? selectedJournalId;

  String? typeOfPerspective;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (getdebttransactions)] action in debtDetailComponent widget.
  ApiCallResponse? debtDetail;
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
