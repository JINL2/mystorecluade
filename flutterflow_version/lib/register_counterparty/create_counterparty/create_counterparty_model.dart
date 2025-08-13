import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'create_counterparty_widget.dart' show CreateCounterpartyWidget;
import 'package:flutter/material.dart';

class CreateCounterpartyModel
    extends FlutterFlowModel<CreateCounterpartyWidget> {
  ///  Local state fields for this component.

  String? linkedCounterPartyId;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (GetNotMyCounterParty)] action in createCounterparty widget.
  ApiCallResponse? getnotmycounterParty;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for Switch widget.
  bool? switchValue;
  // State field(s) for mycomdrop widget.
  String? mycomdropValue;
  FormFieldController<String>? mycomdropValueController;
  // Stores action output result for [Backend Call - API (GetNotMyCounterParty)] action in mycomdrop widget.
  ApiCallResponse? actionoutput;
  // State field(s) for TypeDropDown widget.
  String? typeDropDownValue;
  FormFieldController<String>? typeDropDownValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  CounterpartiesRow? test;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();

    isloadingModel.dispose();
  }
}
