import '/backend/api_requests/api_calls.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'show_counterparty_widget.dart' show ShowCounterpartyWidget;
import 'package:flutter/material.dart';

class ShowCounterpartyModel extends FlutterFlowModel<ShowCounterpartyWidget> {
  ///  Local state fields for this component.

  String? clickedId;

  ///  State fields for stateful widgets in this component.

  // Model for menuBar component.
  late MenuBarModel menuBarModel;
  // Stores action output result for [Backend Call - API (getsinglecounterparty)] action in Button widget.
  ApiCallResponse? getdebtcard;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
  }
}
