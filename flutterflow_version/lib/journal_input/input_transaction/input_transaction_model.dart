import '/backend/api_requests/api_calls.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'input_transaction_widget.dart' show InputTransactionWidget;
import 'package:flutter/material.dart';

class InputTransactionModel extends FlutterFlowModel<InputTransactionWidget> {
  ///  Local state fields for this component.

  String? interestDueDate;

  DateTime? issueDate;

  DateTime? dueDate;

  dynamic transactionDetail;

  String? selectedCounterparty;

  String? category;

  bool debitOrCredit = true;

  double? diff;

  DateTime? acquireDate;

  bool? isInternal = false;

  String? accountTag;

  String? cashLocationString;

  String? debtCounterString;

  bool? isAccountMap;

  bool? isfinished;

  ///  State fields for stateful widgets in this component.

  // State field(s) for accountDropDown widget.
  String? accountDropDownValue;
  FormFieldController<String>? accountDropDownValueController;
  // Stores action output result for [Backend Call - API (checkAccountMap)] action in accountDropDown widget.
  ApiCallResponse? accountMapaccount;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for cashlocatio widget.
  String? cashlocatioValue;
  FormFieldController<String>? cashlocatioValueController;
  // State field(s) for counterpartycompanyDropDown widget.
  String? counterpartycompanyDropDownValue;
  FormFieldController<String>? counterpartycompanyDropDownValueController;
  // Stores action output result for [Backend Call - API (checkAccountMap)] action in counterpartycompanyDropDown widget.
  ApiCallResponse? accountMap;
  // State field(s) for isinternal widget.
  bool? isinternalValue;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // State field(s) for counterpartystoreDropDown widget.
  String? counterpartystoreDropDownValue;
  FormFieldController<String>? counterpartystoreDropDownValueController;
  // State field(s) for debtcategoryDropdown widget.
  String? debtcategoryDropdownValue;
  FormFieldController<String>? debtcategoryDropdownValueController;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for fixedAssetName widget.
  FocusNode? fixedAssetNameFocusNode;
  TextEditingController? fixedAssetNameTextController;
  String? Function(BuildContext, String?)?
      fixedAssetNameTextControllerValidator;
  // State field(s) for usefulLifeDropdown widget.
  int? usefulLifeDropdownValue;
  FormFieldController<int>? usefulLifeDropdownValueController;
  // State field(s) for salvageValue widget.
  FocusNode? salvageValueFocusNode;
  TextEditingController? salvageValueTextController;
  String? Function(BuildContext, String?)? salvageValueTextControllerValidator;
  DateTime? datePicked3;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
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

    fixedAssetNameFocusNode?.dispose();
    fixedAssetNameTextController?.dispose();

    salvageValueFocusNode?.dispose();
    salvageValueTextController?.dispose();

    textFieldFocusNode2?.dispose();
    textController4?.dispose();

    isloadingModel.dispose();
  }
}
