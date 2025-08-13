import '/backend/supabase/supabase.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'currency_denomination_widget.dart' show CurrencyDenominationWidget;
import 'package:flutter/material.dart';

class CurrencyDenominationModel
    extends FlutterFlowModel<CurrencyDenominationWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for d1 widget.
  FocusNode? d1FocusNode;
  TextEditingController? d1TextController;
  String? Function(BuildContext, String?)? d1TextControllerValidator;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<CurrencyDenominationsRow>? denomination;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    d1FocusNode?.dispose();
    d1TextController?.dispose();

    isloadingModel.dispose();
  }
}
