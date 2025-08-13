import '/flutter_flow/flutter_flow_util.dart';
import 'cash_ending_component_widget.dart' show CashEndingComponentWidget;
import 'package:flutter/material.dart';

class CashEndingComponentModel
    extends FlutterFlowModel<CashEndingComponentWidget> {
  ///  Local state fields for this component.

  int? quantity;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
