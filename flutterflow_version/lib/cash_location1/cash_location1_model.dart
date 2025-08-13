import '/flutter_flow/flutter_flow_util.dart';
import 'cash_location1_widget.dart' show CashLocation1Widget;
import 'package:flutter/material.dart';

class CashLocation1Model extends FlutterFlowModel<CashLocation1Widget> {
  ///  State fields for stateful widgets in this page.

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
