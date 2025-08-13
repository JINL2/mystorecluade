import '/backend/api_requests/api_calls.dart';
import '/cash_location/cash_location_list_comp/cash_location_list_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'cash_location_choose_widget.dart' show CashLocationChooseWidget;
import 'package:flutter/material.dart';

class CashLocationChooseModel
    extends FlutterFlowModel<CashLocationChooseWidget> {
  ///  Local state fields for this component.

  dynamic cashLocationJson;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (getcashlocationsnested)] action in cashLocationChoose widget.
  ApiCallResponse? apiResultzqs;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for cashLocationListComp component.
  late CashLocationListCompModel cashLocationListCompModel;

  @override
  void initState(BuildContext context) {
    cashLocationListCompModel =
        createModel(context, () => CashLocationListCompModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    cashLocationListCompModel.dispose();
  }
}
