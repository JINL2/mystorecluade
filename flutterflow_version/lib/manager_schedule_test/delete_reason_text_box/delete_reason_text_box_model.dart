import '/backend/api_requests/api_calls.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'delete_reason_text_box_widget.dart' show DeleteReasonTextBoxWidget;
import 'package:flutter/material.dart';

class DeleteReasonTextBoxModel
    extends FlutterFlowModel<DeleteReasonTextBoxWidget> {
  ///  Local state fields for this component.

  String? reason;

  ///  State fields for stateful widgets in this component.

  // State field(s) for reason widget.
  FocusNode? reasonFocusNode;
  TextEditingController? reasonTextController;
  String? Function(BuildContext, String?)? reasonTextControllerValidator;
  // Stores action output result for [Backend Call - API (managershiftnotapprove)] action in Button widget.
  ApiCallResponse? removal;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    reasonFocusNode?.dispose();
    reasonTextController?.dispose();

    isloadingModel.dispose();
  }
}
