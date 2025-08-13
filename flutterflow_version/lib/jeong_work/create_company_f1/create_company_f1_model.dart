import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/jeong_work/add/add_widget.dart';
import 'create_company_f1_widget.dart' show CreateCompanyF1Widget;
import 'package:flutter/material.dart';

class CreateCompanyF1Model extends FlutterFlowModel<CreateCompanyF1Widget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for CompanyName widget.
  FocusNode? companyNameFocusNode;
  TextEditingController? companyNameTextController;
  String? Function(BuildContext, String?)? companyNameTextControllerValidator;
  // State field(s) for CompanyType widget.
  String? companyTypeValue;
  FormFieldController<String>? companyTypeValueController;
  // State field(s) for currencyType widget.
  String? currencyTypeValue;
  FormFieldController<String>? currencyTypeValueController;
  // Model for add component.
  late AddModel addModel;

  @override
  void initState(BuildContext context) {
    addModel = createModel(context, () => AddModel());
  }

  @override
  void dispose() {
    companyNameFocusNode?.dispose();
    companyNameTextController?.dispose();

    addModel.dispose();
  }
}
