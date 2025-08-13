import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/jeong_work/add/add_widget.dart';
import 'employee_setting_update_v1_widget.dart'
    show EmployeeSettingUpdateV1Widget;
import 'package:flutter/material.dart';

class EmployeeSettingUpdateV1Model
    extends FlutterFlowModel<EmployeeSettingUpdateV1Widget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for SalaryType widget.
  String? salaryTypeValue;
  FormFieldController<String>? salaryTypeValueController;
  // State field(s) for Currency widget.
  String? currencyValue;
  FormFieldController<String>? currencyValueController;
  // State field(s) for SalaryAmount widget.
  FocusNode? salaryAmountFocusNode;
  TextEditingController? salaryAmountTextController;
  String? Function(BuildContext, String?)? salaryAmountTextControllerValidator;
  // Model for add component.
  late AddModel addModel;
  // Stores action output result for [Backend Call - API (updateUserSalary)] action in add widget.
  ApiCallResponse? updateSalary;

  @override
  void initState(BuildContext context) {
    addModel = createModel(context, () => AddModel());
  }

  @override
  void dispose() {
    salaryAmountFocusNode?.dispose();
    salaryAmountTextController?.dispose();

    addModel.dispose();
  }
}
