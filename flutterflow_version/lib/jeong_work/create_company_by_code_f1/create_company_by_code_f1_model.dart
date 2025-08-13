import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/jeong_work/add/add_widget.dart';
import 'create_company_by_code_f1_widget.dart' show CreateCompanyByCodeF1Widget;
import 'package:flutter/material.dart';

class CreateCompanyByCodeF1Model
    extends FlutterFlowModel<CreateCompanyByCodeF1Widget> {
  ///  Local state fields for this component.

  bool? finishWork = false;

  String? storeId;

  ///  State fields for stateful widgets in this component.

  // State field(s) for CompanyCode widget.
  FocusNode? companyCodeFocusNode;
  TextEditingController? companyCodeTextController;
  String? Function(BuildContext, String?)? companyCodeTextControllerValidator;
  // Stores action output result for [Backend Call - Query Rows] action in Icon widget.
  List<CompaniesRow>? searchCompany;
  // Stores action output result for [Backend Call - Query Rows] action in Icon widget.
  List<StoresRow>? storeChoosen;
  // Model for add component.
  late AddModel addModel;
  // Stores action output result for [Backend Call - API (JoinUserByCode)] action in add widget.
  ApiCallResponse? joinByCodeCopy;
  // Stores action output result for [Backend Call - API (getUserCompanies)] action in add widget.
  ApiCallResponse? apiResultd5q;

  @override
  void initState(BuildContext context) {
    addModel = createModel(context, () => AddModel());
  }

  @override
  void dispose() {
    companyCodeFocusNode?.dispose();
    companyCodeTextController?.dispose();

    addModel.dispose();
  }
}
