import '/flutter_flow/flutter_flow_util.dart';
import 'put_information_widget.dart' show PutInformationWidget;
import 'package:flutter/material.dart';

class PutInformationModel extends FlutterFlowModel<PutInformationWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for putInfomation widget.
  FocusNode? putInfomationFocusNode;
  TextEditingController? putInfomationTextController;
  String? Function(BuildContext, String?)? putInfomationTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    putInfomationFocusNode?.dispose();
    putInfomationTextController?.dispose();
  }
}
