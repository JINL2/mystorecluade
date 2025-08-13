import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/isloading_widget.dart';
import '/components/put_information_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'choose_company_widget.dart' show ChooseCompanyWidget;
import 'package:flutter/material.dart';

class ChooseCompanyModel extends FlutterFlowModel<ChooseCompanyWidget> {
  ///  Local state fields for this page.

  bool? finish = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for CompanyCode widget.
  FocusNode? companyCodeFocusNode;
  TextEditingController? companyCodeTextController;
  String? Function(BuildContext, String?)? companyCodeTextControllerValidator;
  // Stores action output result for [Backend Call - Query Rows] action in Icon widget.
  List<CompaniesRow>? searchCompany;
  // Stores action output result for [Backend Call - Query Rows] action in Icon widget.
  List<StoresRow>? storeChoosen;
  // Stores action output result for [Backend Call - API (JoinUserByCode)] action in Button widget.
  ApiCallResponse? joinByCodeCopy;
  // Stores action output result for [Backend Call - API (getUserCompanies)] action in Button widget.
  ApiCallResponse? getuserId;
  // Model for putInformation component.
  late PutInformationModel putInformationModel;
  // State field(s) for company_type widget.
  String? companyTypeValue;
  FormFieldController<String>? companyTypeValueController;
  // State field(s) for choose_currency widget.
  String? chooseCurrencyValue;
  FormFieldController<String>? chooseCurrencyValueController;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  CompaniesRow? companyOutcome;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    putInformationModel = createModel(context, () => PutInformationModel());
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    companyCodeFocusNode?.dispose();
    companyCodeTextController?.dispose();

    putInformationModel.dispose();
    isloadingModel.dispose();
  }
}
