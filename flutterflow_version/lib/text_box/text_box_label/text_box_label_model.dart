import '/flutter_flow/flutter_flow_util.dart';
import 'text_box_label_widget.dart' show TextBoxLabelWidget;
import 'package:flutter/material.dart';

class TextBoxLabelModel extends FlutterFlowModel<TextBoxLabelWidget> {
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
