import '/backend/api_requests/api_calls.dart';
import '/cash_location/cash_location_list_comp/cash_location_list_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'cash_location_comp_widget.dart' show CashLocationCompWidget;
import 'package:flutter/material.dart';

class CashLocationCompModel extends FlutterFlowModel<CashLocationCompWidget> {
  ///  Local state fields for this component.

  dynamic cashLocationPara;

  String? clickedType;

  String? clickedId;

  String? selectLocationName;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (getcashlocationsnested)] action in cashLocationComp widget.
  ApiCallResponse? apiResultls9;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Models for cashLocationListComp dynamic component.
  late FlutterFlowDynamicModels<CashLocationListCompModel>
      cashLocationListCompModels;

  @override
  void initState(BuildContext context) {
    cashLocationListCompModels =
        FlutterFlowDynamicModels(() => CashLocationListCompModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    cashLocationListCompModels.dispose();
  }
}
