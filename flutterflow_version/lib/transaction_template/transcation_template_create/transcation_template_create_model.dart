import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/isloading_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'transcation_template_create_widget.dart'
    show TranscationTemplateCreateWidget;
import 'package:flutter/material.dart';

class TranscationTemplateCreateModel
    extends FlutterFlowModel<TranscationTemplateCreateWidget> {
  ///  Local state fields for this component.

  List<TransactionDetailStruct> transactionDetail = [];
  void addToTransactionDetail(TransactionDetailStruct item) =>
      transactionDetail.add(item);
  void removeFromTransactionDetail(TransactionDetailStruct item) =>
      transactionDetail.remove(item);
  void removeAtIndexFromTransactionDetail(int index) =>
      transactionDetail.removeAt(index);
  void insertAtIndexInTransactionDetail(
          int index, TransactionDetailStruct item) =>
      transactionDetail.insert(index, item);
  void updateTransactionDetailAtIndex(
          int index, Function(TransactionDetailStruct) updateFn) =>
      transactionDetail[index] = updateFn(transactionDetail[index]);

  ///  State fields for stateful widgets in this component.

  // State field(s) for cashLocationName widget.
  FocusNode? cashLocationNameFocusNode;
  TextEditingController? cashLocationNameTextController;
  String? Function(BuildContext, String?)?
      cashLocationNameTextControllerValidator;
  // State field(s) for debitAccountId widget.
  String? debitAccountIdValue;
  FormFieldController<String>? debitAccountIdValueController;
  // State field(s) for DebutCashlocation widget.
  String? debutCashlocationValue;
  FormFieldController<String>? debutCashlocationValueController;
  // State field(s) for creditAccountId widget.
  String? creditAccountIdValue;
  FormFieldController<String>? creditAccountIdValueController;
  // State field(s) for creditLocation widget.
  String? creditLocationValue;
  FormFieldController<String>? creditLocationValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [Backend Call - API (createTamplate)] action in Button widget.
  ApiCallResponse? bothcash;
  // Stores action output result for [Backend Call - API (createTamplate)] action in Button widget.
  ApiCallResponse? withdebitcash;
  // Stores action output result for [Backend Call - API (createTamplate)] action in Button widget.
  ApiCallResponse? withcreditcash;
  // Stores action output result for [Backend Call - API (createTamplate)] action in Button widget.
  ApiCallResponse? nocash;
  // Model for isloading component.
  late IsloadingModel isloadingModel;

  @override
  void initState(BuildContext context) {
    isloadingModel = createModel(context, () => IsloadingModel());
  }

  @override
  void dispose() {
    cashLocationNameFocusNode?.dispose();
    cashLocationNameTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController2?.dispose();

    isloadingModel.dispose();
  }
}
