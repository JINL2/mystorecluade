import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'cashlocation_add_component_widget.dart'
    show CashlocationAddComponentWidget;
import 'package:flutter/material.dart';

class CashlocationAddComponentModel
    extends FlutterFlowModel<CashlocationAddComponentWidget> {
  ///  Local state fields for this component.

  String selectedType = 'bank';

  String selectedViewType = 'bank';

  String? locationName;

  String locationType = 'bank';

  String? storeId;

  String locationInfo = 'bank';

  String? currencyCode;

  String? accoutNumber;

  String? bankName;

  CashLocationsRow? cashData;

  ///  State fields for stateful widgets in this component.

  // State field(s) for locationNameBank widget.
  FocusNode? locationNameBankFocusNode;
  TextEditingController? locationNameBankTextController;
  String? Function(BuildContext, String?)?
      locationNameBankTextControllerValidator;
  // State field(s) for currencyCodeBank widget.
  String? currencyCodeBankValue;
  FormFieldController<String>? currencyCodeBankValueController;
  // State field(s) for isonlyforstoreBank widget.
  String? isonlyforstoreBankValue;
  FormFieldController<String>? isonlyforstoreBankValueController;
  // State field(s) for storeIdbank widget.
  String? storeIdbankValue;
  FormFieldController<String>? storeIdbankValueController;
  // State field(s) for bankName widget.
  FocusNode? bankNameFocusNode;
  TextEditingController? bankNameTextController;
  String? Function(BuildContext, String?)? bankNameTextControllerValidator;
  // State field(s) for bankacount widget.
  FocusNode? bankacountFocusNode;
  TextEditingController? bankacountTextController;
  String? Function(BuildContext, String?)? bankacountTextControllerValidator;
  // State field(s) for noteBank widget.
  FocusNode? noteBankFocusNode;
  TextEditingController? noteBankTextController;
  String? Function(BuildContext, String?)? noteBankTextControllerValidator;
  // Stores action output result for [Backend Call - API (cashlocationedit)] action in Button widget.
  ApiCallResponse? editCashLocation;
  // Stores action output result for [Backend Call - API (cashlocationcreate)] action in Button widget.
  ApiCallResponse? cashCreate;
  // Stores action output result for [Backend Call - API (getcashlocationsnested)] action in Button widget.
  ApiCallResponse? update;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    locationNameBankFocusNode?.dispose();
    locationNameBankTextController?.dispose();

    bankNameFocusNode?.dispose();
    bankNameTextController?.dispose();

    bankacountFocusNode?.dispose();
    bankacountTextController?.dispose();

    noteBankFocusNode?.dispose();
    noteBankTextController?.dispose();
  }
}
