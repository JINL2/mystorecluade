import '/flutter_flow/flutter_flow_util.dart';
import 'vault_currency_textfield_widget.dart' show VaultCurrencyTextfieldWidget;
import 'package:flutter/material.dart';

class VaultCurrencyTextfieldModel
    extends FlutterFlowModel<VaultCurrencyTextfieldWidget> {
  ///  Local state fields for this component.

  int? quantity;

  ///  State fields for stateful widgets in this component.

  // State field(s) for quantity widget.
  FocusNode? quantityFocusNode;
  TextEditingController? quantityTextController;
  String? Function(BuildContext, String?)? quantityTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    quantityFocusNode?.dispose();
    quantityTextController?.dispose();
  }
}
