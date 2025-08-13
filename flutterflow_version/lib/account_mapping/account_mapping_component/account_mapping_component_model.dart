import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'account_mapping_component_widget.dart'
    show AccountMappingComponentWidget;
import 'package:flutter/material.dart';

class AccountMappingComponentModel
    extends FlutterFlowModel<AccountMappingComponentWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for mycompanyChoose widget.
  String? mycompanyChooseValue;
  FormFieldController<String>? mycompanyChooseValueController;
  // State field(s) for myaccountChoose widget.
  String? myaccountChooseValue;
  FormFieldController<String>? myaccountChooseValueController;
  // State field(s) for countercompnayChoose2 widget.
  String? countercompnayChoose2Value;
  FormFieldController<String>? countercompnayChoose2ValueController;
  // State field(s) for counteraccountChoose2 widget.
  String? counteraccountChoose2Value;
  FormFieldController<String>? counteraccountChoose2ValueController;
  // Stores action output result for [Backend Call - API (insertAccountMapping)] action in Button widget.
  ApiCallResponse? insertapi;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
